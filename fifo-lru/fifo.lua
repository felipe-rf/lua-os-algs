function spawnFifo(id)
	table.insert(fifoCache, {x = 0, y = 150, width = 50, height = 50,desiredX = centerX - #fifoCache * 55, desiredY = 150, id = id})
end

function insertFifo(id,dt)
	for i, block in ipairs(fifoCache) do
		if block.id == id then
			return
		end
	end
	if #fifoCache < maxCacheSize then
		spawnFifo(id)
	else
		removeFifo(id, dt)
		spawnFifo(id)
	end
end

function removeFifo(dt)
    table.insert(removedBlocks, fifoCache[1])
    table.remove(fifoCache, 1)
    updateFifoBlocks(dt)
end

function updateFifoBlocks(dt)
    for i, block in ipairs(fifoCache) do
        block.desiredX = block.desiredX + 55
    end
end
