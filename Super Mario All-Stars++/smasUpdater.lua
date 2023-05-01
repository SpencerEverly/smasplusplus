local smasUpdater = {}

if SMBX_VERSION ~= VER_SEE_MOD then return end

smasUpdater.doUpdate = false --ONLY toggled on the start level.

smasUpdater.drawUpdateText = false
smasUpdater.drawVersionText = false

smasUpdater.doneUpdating = true --Toggled false when updating is active.

smasUpdater.updateStage = 0
smasUpdater.updateTimer = 0

smasUpdater.fadeToBlackOpacity = 0
smasUpdater.fadeToBlack = false

smasUpdater.checkFileIndicator = 1
smasUpdater.checkFileDownloadInficator = 0

smasUpdater.tableOfFilesToCheck = {}
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
    return Internet.GetFileSize(Misc.episodePath()..file)
end

function smasUpdater.readVersionUpdateList(patternToGoThrough)
    if patternToGoThrough == nil then
        patternToGoThrough = 1
    end
    
    local fileList = File.readFile("version-latestfiles.txt")
    
    local preTable = {}
    local finalTable = {}
    
    for k,v in ipairs(string.split(fileList, "\n", true)) do
        if k > 1 then
            table.insert(preTable, v)
        end
    end
    
    local startingPoint = 1
    local endPoint = 4
    
    local subtractMarker = patternToGoThrough - 1
    
    for i = startingPoint, #preTable do
        splitstrings = string.split(preTable[patternToGoThrough], "=")
        
        if patternToGoThrough > 1 then
            i = i - subtractMarker
        end
        
        --Check for a pattern. For every 4 of each values in a table, add them to a specific table
        table.insert(finalTable, {
            folder = splitstrings[i],
            file = splitstrings[i + 1],
            extension = splitstrings[i + 2],
            size = tonumber(splitstrings[i + 3]),
        })
    end
    
    return finalTable[patternToGoThrough]
end

function smasUpdater.findLatestUpdateConfigFileSize(index, file)
    local fileList = File.readFile("version-latestfiles.txt")
    local foundSize = 0
    
    if file == smasUpdater.readVersionUpdateList(index).folder..smasUpdater.readVersionUpdateList(index).file..smasUpdater.readVersionUpdateList(index).extension then
        foundSize = smasUpdater.readVersionUpdateList(index).size
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
        smasUpdater.downloadFile("https://raw.githubusercontent.com/SpencerEverly/smasplusplus/main/Super%20Mario%20All-Stars%2B%2B/version-latestfiles.txt", "/", "version-latestfiles.txt")
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
    local version = File.readSpecificAreaFromFile("version-latestfiles.txt", 1)
    return version
end

function smasUpdater.checkForInternet()
    smasUpdater.downloadFile("https://raw.githubusercontent.com/SpencerEverly/smasplusplus/main/Super%20Mario%20All-Stars%2B%2B/version-latestfiles.txt", "/data/temp/", "version-latestfiles-temp.txt")
    if io.exists(Misc.episodePath().."data/temp/version-latestfiles-temp.txt") then
        os.remove(Misc.episodePath().."data/temp/version-latestfiles-temp.txt")
        return true
    else
        return false
    end
end

local internetCheck = false

function smasUpdater.onStart()
    internetCheck = smasUpdater.checkForInternet()
end

if not Misc.inEditor() then
    function smasUpdater.onDraw()
        if smasUpdater.doUpdate then
            if smasUpdater.drawUpdateText then
                textplus.print{text = UpdateMessageForUpdater, pivot = vector.v2(0.5,0.5), x = 400, y = 290, priority = 10, color = Color.white}
                if smasUpdater.drawVersionText then
                    textplus.print{text = smasUpdater.versionNumber(), pivot = vector.v2(0.5,0.5), x = 400, y = 250, priority = 10, color = Color.white}
                end
            end
            
            if not smasUpdater.doneUpdating and internetCheck then
                if smasUpdater.updateStage == 0 then
                    smasUpdater.updateStage = 1
                end
                
                if smasUpdater.updateStage == 1 then
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer == 5 then
                        smasUpdater.downloadLatestUpdateConfig()
                    end
                    if smasUpdater.updateTimer == 10 then
                        if smasUpdater.versionNumber() == VersionOfEpisode then
                            smasUpdater.updateTimer = 0
                            smasUpdater.updateStage = 8
                            smasUpdater.doneUpdating = true
                        end
                    end
                    if smasUpdater.updateTimer == 35 then
                        smasUpdater.updateTimer = 0
                        smasUpdater.updateStage = 2
                    end
                end
                if smasUpdater.updateStage == 2 then
                    UpdateMessageForUpdater = "Checking files... ("..tostring(#smasUpdater.tableOfFilesToCheck)..")"
                    if smasUpdater.checkFileIndicator < smasUpdater.checkFileAmountUpdateConfig() then
                        smasUpdater.tableOfFilesToCheck[smasUpdater.checkFileIndicator] = {
                            folder = smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).folder,
                            file = smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).file,
                            extension = smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).extension,
                            size = smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).size,
                        }
                        smasUpdater.checkFileIndicator = smasUpdater.checkFileIndicator + 1
                    elseif smasUpdater.checkFileIndicator >= smasUpdater.checkFileAmountUpdateConfig() then
                        smasUpdater.checkFileIndicator = 1
                        smasUpdater.updateStage = 3
                    end
                end
                if smasUpdater.updateStage == 3 then
                    UpdateMessageForUpdater = "Checking file sizes... ("..tostring(#smasUpdater.tableOfFilesToCheckSizes)..")"
                    if smasUpdater.checkFileIndicator < smasUpdater.checkFileAmountUpdateConfig() then
                        smasUpdater.tableOfFilesToCheckSizes[smasUpdater.checkFileIndicator] = {
                            shouldNotUpdate = smasUpdater.compareFileSize(smasUpdater.checkFileIndicator, smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).folder..smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).file..smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).extension),
                            oldSize = smasUpdater.checkFileSize(smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).folder..smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).file..smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).extension),
                            newSize = smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).size,
                        }
                        smasUpdater.checkFileIndicator = smasUpdater.checkFileIndicator + 1
                    elseif smasUpdater.checkFileIndicator >= smasUpdater.checkFileAmountUpdateConfig() then
                        smasUpdater.checkFileIndicator = 1
                        smasUpdater.updateStage = 4
                    end
                end
                if smasUpdater.updateStage == 4 then
                    UpdateMessageForUpdater = "Adding files to update list... ("..tostring(#smasUpdater.tableOfFilesToDownload)..")"
                    if smasUpdater.checkFileIndicator < smasUpdater.checkFileAmountUpdateConfig() then
                        if not smasUpdater.tableOfFilesToCheckSizes[smasUpdater.checkFileIndicator].shouldNotUpdate then
                            smasUpdater.checkFileDownloadInficator = smasUpdater.checkFileDownloadInficator + 1
                            smasUpdater.tableOfFilesToDownload[smasUpdater.checkFileDownloadInficator] = {
                                fileToDownload = smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).folder..smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).file..smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).extension,
                                folderToUse = smasUpdater.readVersionUpdateList(smasUpdater.checkFileIndicator).folder,
                            }
                        end
                        smasUpdater.checkFileIndicator = smasUpdater.checkFileIndicator + 1
                    elseif smasUpdater.checkFileIndicator >= smasUpdater.checkFileAmountUpdateConfig() then
                        smasUpdater.checkFileIndicator = 1
                        smasUpdater.updateStage = 5
                    end
                end
                if smasUpdater.updateStage == 5 then
                    UpdateMessageForUpdater = "Downloading file "..tostring(smasUpdater.checkFileIndicator).." of "..tostring(#smasUpdater.tableOfFilesToDownload).."."
                    smasUpdater.downloadFile("https://raw.githubusercontent.com/SpencerEverly/smasplusplus/main/Super%20Mario%20All-Stars%2B%2B/"..smasUpdater.stringToURLPiece(smasUpdater.tableOfFilesToDownload[smasUpdater.checkFileIndicator].fileToDownload), "/data/temp/"..smasUpdater.tableOfFilesToDownload[smasUpdater.checkFileIndicator].folderToUse, smasUpdater.tableOfFilesToDownload[smasUpdater.checkFileIndicator].fileToDownload)
                    if smasUpdater.checkFileIndicator < #smasUpdater.tableOfFilesToDownload then
                        smasUpdater.checkFileIndicator = smasUpdater.checkFileIndicator + 1
                    elseif smasUpdater.checkFileIndicator >= #smasUpdater.tableOfFilesToDownload then
                        smasUpdater.checkFileIndicator = 1
                        smasUpdater.updateStage = 6
                    end
                end
                if smasUpdater.updateStage == 6 then
                    UpdateMessageForUpdater = "Patching file "..tostring(smasUpdater.checkFileIndicator).." of "..tostring(#smasUpdater.tableOfFilesToDownload).."."
                    os.rename(Misc.episodePath().."data/temp/"..smasUpdater.tableOfFilesToDownload[smasUpdater.checkFileIndicator].fileToDownload, Misc.episodePath()..smasUpdater.tableOfFilesToDownload[smasUpdater.checkFileIndicator].fileToDownload)
                    if smasUpdater.checkFileIndicator < #smasUpdater.tableOfFilesToDownload then
                        smasUpdater.checkFileIndicator = smasUpdater.checkFileIndicator + 1
                    elseif smasUpdater.checkFileIndicator >= #smasUpdater.tableOfFilesToDownload then
                        smasUpdater.checkFileIndicator = 1
                        smasUpdater.updateStage = 7
                    end
                end
                if smasUpdater.updateStage == 7 then
                    UpdateMessageForUpdater = "Update complete! Restarting episode..."
                    smasUpdater.checkFileIndicator = 1
                    smasUpdater.doneUpdating = true
                end
                if smasUpdater.updateStage == 8 then
                    UpdateMessageForUpdater = "You are on the latest version!"
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer >= lunatime.toTicks(5) then
                        launchAfterNoUpdate()
                    end
                end
            else
                if not internetCheck then
                    UpdateMessageForUpdater = "No internet! Skipping update..."
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer >= lunatime.toTicks(5) then
                        launchAfterNoUpdate()
                    end
                end
                if UpdateMessageForUpdater == "Update complete! Restarting episode..." then
                    smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                    if smasUpdater.updateTimer >= lunatime.toTicks(5) then
                        restartAfterUpdating()
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
                textplus.print{text = UpdateMessageForUpdater, pivot = vector.v2(0.5,0.5), x = 400, y = 290, priority = 10, color = Color.white}
            end
            
            if not smasUpdater.doneUpdating then
                smasUpdater.updateTimer = smasUpdater.updateTimer + 1
                if smasUpdater.updateTimer >= lunatime.toTicks(5) then
                    launchAfterNoUpdate()
                end
            end
        end
    end
end

return smasUpdater