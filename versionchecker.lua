local repo = GetResourceMetadata(GetCurrentResourceName(), "github", 0) or "https://github.com/Ludaro1024/LudaroVersionChecker"
local scriptname = GetResourceMetadata(GetCurrentResourceName(), "name", 0) or GetCurrentResourceName()
local currentversion = tonumber(GetResourceMetadata(GetCurrentResourceName(), "version"))

if not repo or not scriptname or not currentversion then
    print("Error: Missing metadata in fxmanifest.")
    return
end

-- Function to split a string by a given delimiter
local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

-- Function to perform the HTTP request and check for updates
local function checkVersion(version)
    local url = repo .. "/raw/main/" .. scriptname .. "/" .. version .. ".json"
    
    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            if data and data.version then
                local latestVersion = tonumber(data.version)
                if latestVersion and latestVersion > currentversion then
                    print("Update available for " .. scriptname .. ":")
                    print("  Current version: " .. currentversion)
                    print("  Latest version: " .. latestVersion)
                    print("  Changed files: " .. data.changed_files)
                    print("  Changelog: " .. data.changelog)
                    print("  Date: " .. data.date)
                    currentversion = latestVersion
                    -- Check the next version
                    checkNextVersion()
                else
                    print(scriptname .. " is up to date. Current version: " .. currentversion)
                end
            else
                print("Error: Invalid response from version check.")
            end
        elseif statusCode == 404 then
            print("[MyScripts Updater] -- You are using the latest version of " .. scriptname .. ". and are up To date!")
        else
            print("Error: Failed to check version. HTTP Status Code: " .. statusCode)
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
end

-- Check the next version
local function checkNextVersion()
    local nextVersion = currentversion + 1
    checkVersion(nextVersion)
end

-- Call the function to check the next version
checkNextVersion()
