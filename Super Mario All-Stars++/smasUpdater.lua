local smasUpdater = {}

if SMBX_VERSION ~= VER_SEE_MOD then return end

function smasUpdater.onInitAPI()
    registerEvent(smasUpdater,"onStart")
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

function smasUpdater.downloadFile(url, folder, file)
    return Internet.DownloadFile(url, Misc.episodePath()..folder, file, "")
end

function smasUpdater.compareOnlineFileSize(folder, file)
    local urlPart = file
    
    local tempFolder = "data/temp/"
    
    local finalUrl
    
    for i = 1,#smasUpdater.urlStringTable do
        finalUrl = string.gsub(urlPart, smasUpdater.urlStringTable[i].oldString, smasUpdater.urlStringTable[i].newString)
    end
    
    smasUpdater.downloadFile("https://raw.githubusercontent.com/SpencerEverly/smasplusplus/main/Super%20Mario%20All-Stars%2B%2B/"..finalUrl, Misc.episodePath().."data/temp/"..folder, file)
    
    local firstSize = File.fileToByteSize(Misc.episodePath().."data/temp/"..file)
    local secondSize = File.fileToByteSize(Misc.episodePath()..file)
    
    if firstSize == secondSize then
        os.remove(Misc.episodePath().."data/temp/"..file)
        return true
    else
        os.remove(Misc.episodePath().."data/temp/"..file)
        return false
    end
end

function smasUpdater.readVersionUpdateList()
    local fileList = File.readFile("version-latestfiles.txt")
    
    local finalTable = {}
    
    for k,v in ipairs(string.split(fileList, "\n", true)) do
        table.insert(finalTable, v)
    end
    
    return finalTable
end

function smasUpdater.downloadLatestUpdate()
    for i = 1,#smasUpdater.readVersionUpdateList() do
        if 
    end
end

function smasUpdater.onStart()
    
end

return smasUpdater