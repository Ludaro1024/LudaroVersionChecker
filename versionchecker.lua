
repo = GetResourceMetadata(GetCurrentResourceName(), "github", 0) or "https://github.com/Ludaro1024/LudaroVersionChecker"
scriptname = GetResourceMetadata(GetCurrentResourceName(), "name", 0) or GetCurrentResourceName()
currentversion = GetResourceMetaData(GetCurrentResourceName(), "version")

function ConvertVersionToInt(version)
    