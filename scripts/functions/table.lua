local Tabled = {}

function Tabled.findStringPartFromTable(tbl, value, shouldFindIndex)
    for k,v in ipairs(tbl) do
        if not shouldFindIndex then
            if string.find(v, value) then
                return v
            end
        else
            if string.find(v, value) then
                return k
            end
        end
    end
    return nil
end

function Tabled.find(tbl, value)
    for k,v in ipairs(tbl) do
        if v == value then
            return k
        end
    end
    return nil
end

function Tabled.splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

return Tabled