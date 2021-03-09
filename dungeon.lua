function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function printDungeon(map)
    for y=1,map.h do
        rowStr = ""
        for x=1,map.w do
            if(map.data[y][x]) then
                rowStr = rowStr .. "OOO"
            else
                rowStr = rowStr .. "   "
            end
        end
        print(rowStr)
    end
end

function initDungeon(w, h)
    map = {}
    map['w'] = w
    map['h'] = h
    map.data = {}
    chance = 0.37
    math.randomseed(os.time())
    for y=0,h do
        row = {}
        rowStr = ""
        for x=0,w do
            if(math.random() < chance) then
                table.insert(row, true)
                rowStr = rowStr .. " X "
            else
                table.insert(row, false)
                rowStr = rowStr .. "   "
            end
        end
        --print(rowStr)
        table.insert(map.data, row)
    end
    return map
end

function getLivingNeighbors(map, x, y)
    count = 0
    
    for i = -1,1 do
        for j = -1,1 do
            if(x + i <= 0 or y + j <= 0 or y + 1 > map.h or x + 1 > map.w) then
                count = count + 1
            else
                if(map.data[y+j][x+i] and not (i == 0 and j == 0)) then
                    count = count + 1
                end
            end
        end
    end
    --print(count)
    return count
end

function generateDungeonStep(map)
    newmap = deepcopy(map)
    minNeighbors = 3
    maxNeighbors = 4
    for y=1,map.h do
        for x=1,map.w do
            nCount = getLivingNeighbors(map, x, y)
            if(map.data[y][x]) then
                if(nCount < minNeighbors) then
                    newmap.data[y][x] = false
                else
                    newmap.data[y][x] = true
                end
            else
                if(nCount > maxNeighbors) then
                    newmap.data[y][x] = true
                else
                    newmap.data[y][x] = false
                end
            end
        end
    end
    return newmap
end
