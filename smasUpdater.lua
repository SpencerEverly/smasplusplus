local smasUpdater = {}

if SMBX_VERSION ~= VER_SEE_MOD then return end

local textplus = require("textplus")
local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

smasUpdater.doUpdate = false --ONLY toggled on the start level.

smasUpdater.drawUpdateText = false
smasUpdater.drawVersionText = false

smasUpdater.doneUpdating = true --Toggled false when updating is active.

smasUpdater.updateStage = 0
smasUpdater.updateTimer = 0

smasUpdater.fadeToBlackOpacity = 0
smasUpdater.fadeToBlack = false

smasUpdater.checkFileIndicator = 1
smasUpdater.checkFileDownloadIndicator = 0

smasUpdater.tableOfFilesToCheckSizes = {}
smasUpdater.tableOfFilesToDownload = {}

function smasUpdater.onInitAPI()
    registerEvent(smasUpdater,"onStart")
    registerEvent(smasUpdater,"onDraw")
end

smasUpdater.urlStringTable = {
    [1] = {
        oldString = " ",
        newString = "%%20",
    },
    [2] = {
        oldString = "+",
        newString = "%%2B",
    },
}

function smasUpdater.stringToURLPiece(stringd)
    local stringValue = string.gsub(stringd, smasUpdater.urlStringTable[1].oldString, smasUpdater.urlStringTable[1].newString)
    local stringValue2 = string.gsub(stringValue, smasUpdater.urlStringTable[2].oldString, smasUpdater.urlStringTable[2].newString)
    
    return stringValue2
end

function smasUpdater.downloadFile(url, folder, file)
    return Internet.DownloadFile(url, Misc.episodePath()..folder, file, "")
end

function smasUpdater.checkFileSize(file)
    return Misc.getFileSize(Misc.episodePath()..file)
end

function smasUpdater.readVersionUpdateList()
    local f = io.open(Misc.episodePath().."version-latestfiles.txt", "r")
    local contentsTable = {}
    if f ~= nil then
        while (true) do
            local line = f:read("*l")

            if line == nil then
                break
            end
            
            local contents = line:split("=")
            table.insert(contentsTable, {
                folder = contents[1],
                file = contents[2],
                extension = contents[3],
                size = contents[4]
            })
        end
        f:close()
    end
    return contentsTable
end

function smasUpdater.findLatestUpdateConfigFileSize(index, file)
    local fileList = File.readFile("version-latestfiles.txt")
    local foundSize = 0
    
    if file == smasUpdater.readVersionUpdateList()[index + 1].folder..smasUpdater.readVersionUpdateList()[index + 1].file..smasUpdater.readVersionUpdateList()[index + 1].extension then
        foundSize = smasUpdater.readVersionUpdateList()[index + 1].size
    else
        foundSize = 0
    end
    
    return foundSize
end

function smasUpdater.checkFileAmountUpdateConfig()
    local fileList = File.readFile("version-latestfiles.txt")
    return #fileList
end

function smasUpdater.compareFileSize(index, file)
    local tempFolder = "data/temp/"
    
    local firstSize = smasUpdater.findLatestUpdateConfigFileSize(index, Misc.episodePath()..tempFolder..file)
    local secondSize = smasUpdater.checkFileSize(Misc.episodePath()..file)
    
    if firstSize == secondSize then
        return true
    else
        return false
    end
end

function smasUpdater.downloadLatestUpdateConfig()
    if not Misc.inEditor() then
        smasUpdater.downloadFile("https://raw.githubusercontent.com/SpencerEverly/smasplusplus/main/versionlist-commit.txt", "", "versionlist-commit-temp.txt")
    end
end

function smasUpdater.checkVersionStatus()
    local version = File.readSpecificAreaFromFile("version-latestfiles.txt", 1)
    if version == VersionOfEpisode then
        return true
    else
        return false
    end
end

function smasUpdater.versionNumber()
    local version = File.readSpecificAreaFromFile("versionlist-commit.txt", 1)
    return version
end

function smasUpdater.checkForInternet()
    smasUpdater.downloadFile("https://raw.githubusercontent.com/SpencerEverly/smasplusplus/main/version-latestfiles.txt", "/data/temp/", "version-latestfiles-temp.txt")
    if io.exists(Misc.episodePath().."data/temp/version-latestfiles-temp.txt") then
        os.remove(Misc.episodePath().."data/temp/version-latestfiles-temp.txt")
        return true
    else
        return false
    end
end

function smasUpdater.checkForGitFolder()
    local fileExists = false
    local f = io.open(Misc.episodePath()..".git/HEAD")
    if f ~= nil then
        fileExists = true
        f:close()
    end
    return fileExists
end

function smasUpdater.getLatestHash()
    local line = File.readSpecificAreaFromFile("versionlist-commit-temp.txt", 1)
    return line
end

function smasUpdater.restartAfterUpdating()
    if SMBX_VERSION == VER_SEE_MOD then
        if Misc.isSetToRunWhenUnfocused() then
            Misc.runWhenUnfocused(false)
        end
    end
    if not Misc.loadEpisode("Super Mario All-Stars++") then
        error("SMAS++ is not found. How is that even possible? Reinstall the game using the SMASUpdater, since something has gone terribly wrong.")
    end
end

function smasUpdater.launchAfterNoUpdate()
    if SMBX_VERSION == VER_SEE_MOD then
        if Misc.isSetToRunWhenUnfocused() then
            Misc.runWhenUnfocused(false)
        end
    end
    SysManager.loadIntroTheme()
end

local internetCheck = false

function smasUpdater.onStart()
    internetCheck = smasUpdater.checkForInternet()
end

if not Misc.inEditor() then
    function smasUpdater.onDraw()
        if smasUpdater.doUpdate then
            if smasUpdater.drawUpdateText then
                textplus.print{text = UpdateMessageForUpdater, pivot = vector.v2(0.5,0.5), x = 400, y = 290, priority = 10, color = Color.white, font = statusFont, xscale = 2, yscale = 2, maxWidth = 500}
                if smasUpdater.drawVersionText then
                    textplus.print{text = smasUpdater.versionNumber(), pivot = vector.v2(0.5,0.5), x = 400, y = 250, priority = 10, color = Color.white, font = statusFont, xscale = 1.5, yscale = 1.5}
                end
            end
            
            if not smasUpdater.doneUpdating and internetCheck then
                if smasUpdater.updateStage == 0 then
                    smasUpdater.updateStage = 1
                end
                
                if smasUpdater.updateStage == 1 then
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer == 1 then
                        Internet.StartGit()
                    end
                    if smasUpdater.updateTimer == 5 then
                        smasUpdater.downloadLatestUpdateConfig()
                    end
                    if smasUpdater.updateTimer == 10 then
                        smasUpdater.drawVersionText = true
                    end
                    if smasUpdater.updateTimer >= 35 then
                        smasUpdater.updateTimer = 0
                        smasUpdater.updateStage = 2
                    end
                end
                if smasUpdater.updateStage == 2 then
                    UpdateMessageForUpdater = "Checking for .git..."
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer == 5 then
                        if not smasUpdater.checkForGitFolder() then
                            smasUpdater.updateTimer = 0
                            smasUpdater.updateStage = 4
                        end
                    end
                    if smasUpdater.updateTimer >= 10 then
                        smasUpdater.updateTimer = 0
                        smasUpdater.updateStage = 3
                    end
                end
                if smasUpdater.updateStage == 3 then
                    UpdateMessageForUpdater = "Updating to the latest commit. This will freeze the game for a while, please be patient..."
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer == 5 then
                        Internet.GitPull(smasUpdater.getLatestHash(), getSMBXPath().."/worlds/Super Mario All-Stars++")
                    end
                    if smasUpdater.updateTimer >= 10 then
                        smasUpdater.updateTimer = 0
                        smasUpdater.updateStage = 5
                    end
                end
                if smasUpdater.updateStage == 4 then
                    UpdateMessageForUpdater = "Downloading episode from the Internet. This will freeze the game for a while, please be patient..."
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer == 5 then
                        Internet.GitClone("https://github.com/SpencerEverly/smasplusplus/", getSMBXPath().."/worlds/Super Mario All-Stars++")
                    end
                    if smasUpdater.updateTimer >= 10 then
                        smasUpdater.updateTimer = 0
                        smasUpdater.updateStage = 5
                    end
                end
                if smasUpdater.updateStage == 5 then
                    UpdateMessageForUpdater = "Update complete! Restarting episode..."
                    smasUpdater.doneUpdating = true
                end
                if smasUpdater.updateStage == 6 then
                    UpdateMessageForUpdater = "You are on the latest version!"
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer >= lunatime.toTicks(5) then
                        smasUpdater.launchAfterNoUpdate()
                    end
                end
            else
                if not internetCheck then
                    UpdateMessageForUpdater = "No internet! Skipping update..."
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer >= lunatime.toTicks(5) then
                        smasUpdater.launchAfterNoUpdate()
                    end
                end
                if smasUpdater.updateStage == 5 then
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer >= lunatime.toTicks(5) then
                        Internet.EndGit()
                        smasUpdater.restartAfterUpdating()
                    end
                end
            end
        end
    end
else
    function smasUpdater.onDraw()
        if smasUpdater.doUpdate then
            
            UpdateMessageForUpdater = "On the editor, skipping update..."
            
            if smasUpdater.drawUpdateText then
                textplus.print{text = UpdateMessageForUpdater, pivot = vector.v2(0.5,0.5), x = 400, y = 290, priority = 10, color = Color.white, font = statusFont, xscale = 2, yscale = 2}
            end
            
            if not smasUpdater.doneUpdating then
                smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                if smasUpdater.updateTimer >= lunatime.toTicks(5) then
                    smasUpdater.launchAfterNoUpdate()
                end
            end
        end
    end
end

return smasUpdater