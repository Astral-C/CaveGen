require 'dungeon'
map = initDungeon(100, 70)
mapCanvas = love.graphics.newCanvas(100*32, 70*32)
scrollX = 0
scrollY = 0
zoom = 1

function love.conf(t)
 t.identity = 'LoveDungeonGen'
end

function drawDungeon(map)
    grass = love.graphics.newImage('textures/grass_test.png')
    stone = love.graphics.newImage('textures/stone.png')
    drCorner = love.graphics.newImage('textures/drstone.png')
    dlCorner = love.graphics.newImage('textures/dlstone.png')
    urCorner = love.graphics.newImage('textures/uright.png')
    ulCorner = love.graphics.newImage('textures/ulstone.png')
    down = love.graphics.newImage('textures/downStone.png')
    left = love.graphics.newImage('textures/left.png')
    right = love.graphics.newImage('textures/right.png')
    up = love.graphics.newImage('textures/top.png')
    sastone = love.graphics.newImage('textures/standaloneStone.png')

    for y=1,map.h do
        for x=1,map.w do
            if(map.data[y][x]) then
                love.graphics.draw(stone, (x-1)*32, (y-1)*32)
                if(map.data[y+1][x] == false) then
                    love.graphics.draw(down, (x-1)*32, (y-1)*32)
                end
                if(x - 1 > 0 and y - 1 > 0 and map.data[y][x-1] == false and map.data[y-1][x] == false) then
                    love.graphics.draw(ulCorner, (x-1)*32, (y-1)*32)
                end
                if(x - 1 > 0 and y - 1 > 0 and map.data[y][x+1] == false and map.data[y-1][x] == false) then
                    love.graphics.draw(urCorner, (x-1)*32, (y-1)*32)
                end
                if(map.data[y][x+1] == false and map.data[y+1][x] == false) then
                    love.graphics.draw(drCorner, (x-1)*32, (y-1)*32)
                end
                if(x - 1 > 0 and y - 1 > 0 and map.data[y][x-1] == false and map.data[y+1][x] == false) then
                    love.graphics.draw(dlCorner, (x-1)*32, (y-1)*32)
                end
                if(x - 1 > 0 and y - 1 > 0 and map.data[y][x+1] == false and map.data[y+1][x] and map.data[y-1][x]) then
                    love.graphics.draw(right, (x-1)*32, (y-1)*32)
                end
                
            else
                love.graphics.draw(grass, (x-1)*32, (y-1)*32)
            end
        end
    end
end

function love.load()
    for x=0,3 do
        map = generateDungeonStep(map)
    end
    love.graphics.setCanvas(mapCanvas)
        drawDungeon(map)
    love.graphics.setCanvas()
    mapCanvas:newImageData():encode('png', 'map.png')
end

function love.draw()
    love.graphics.draw(mapCanvas, scrollX, scrollY, 0, zoom, zoom)
end


function love.keypressed(k)
    if(k == 'z') then
        zoom = zoom - 0.01
    end
    if(k == 'x') then
        zoom = zoom + 0.01
    end
    if(k == 's') then
        map = generateDungeonStep(map)
        
        love.graphics.setCanvas(mapCanvas)
            drawDungeon(map)
        love.graphics.setCanvas()
    end
end

function love.update()
    if(love.keyboard.isDown('left')) then
        scrollX = scrollX + 5
    end
    if(love.keyboard.isDown('right')) then
        scrollX = scrollX - 5
    end
    if(love.keyboard.isDown('up')) then
        scrollY = scrollY + 5
    end
    if(love.keyboard.isDown('down')) then
        scrollY = scrollY - 5
    end
end
