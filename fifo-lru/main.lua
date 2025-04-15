require('fifo')
require("lru")

function love.load()
    love.window.setTitle("Animação FIFO")
    love.window.setMode(800, 600)

    fifoCache = {}
    lruCache = {}  
    waitTimeElapsed = 0
    waitTime = 1.5
    speed = 300 
    centerX = 400 + 110
    maxCacheSize = 5
    maxPageNumber = 8
    removedBlocks = {}
    chosenNumber = nil
end

function love.update(dt)
    for i, block in ipairs(fifoCache) do
        moveBlock(block,dt)
    end
    for i, block in ipairs(lruCache) do
        moveBlock(block,dt)
    end

    waitTimeElapsed = waitTimeElapsed + dt
    if waitTimeElapsed >= waitTime then
        chosenNumber = love.math.random(1, maxPageNumber)
        insertFifo(chosenNumber,dt) 
        insertLru(chosenNumber,dt) 
        waitTimeElapsed = 0
    end
    for i,block in ipairs(removedBlocks) do
        removeBlock(i,dt)
    end
end

function moveBlock(block,dt)
    if block.x < block.desiredX then
        block.x = block.x + speed * dt
    else
        block.x = block.desiredX
    end

    if block.y > block.desiredY then
        block.y = block.y + speed * dt
    end
end

function removeBlock(index,dt)
    block = removedBlocks[index]
    block.y = block.y - speed * dt
    if block.y < block.desiredY-150 then
        table.remove(removedBlocks, index)
    end
end


function love.draw()
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2)

    -- Desenha a fila de blocos
    for i, block in ipairs(fifoCache) do
        love.graphics.setColor(0, 0, 1)
        if block.id == chosenNumber then
            love.graphics.setColor(0, 1, 0)
        end
        love.graphics.rectangle("fill", block.x, block.y, block.width, block.height)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("ID: " .. block.id, block.x, block.y)
    end

    for i, block in ipairs(lruCache) do
        love.graphics.setColor(0, 0, 1)
        if block.id == chosenNumber then
            love.graphics.setColor(0, 1, 0)
        end
        love.graphics.rectangle("fill", block.x, block.y, block.width, block.height)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("ID: " .. block.id, block.x, block.y)
    end


    for i,removedBlock in ipairs(removedBlocks)do
      love.graphics.setColor(1, 0, 0) 
      love.graphics.rectangle("fill", removedBlock.x, removedBlock.y, removedBlock.width, removedBlock.height)
    end
    -- Texto explicativo
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FIFO - O primeiro bloco a entrar é o primeiro a sair", 260, 100)
        love.graphics.print("LRU - O menos recentemente usado é removido", 260, 400)

    if chosenNumber then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Página acessada: " .. chosenNumber, 350, 300)
    end
end

