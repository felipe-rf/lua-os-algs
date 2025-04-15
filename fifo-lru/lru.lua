function spawnLru(id)
	table.insert(lruCache, {x = 0, y = 450, width = 50, height = 50,desiredX = centerX - #lruCache * 55, desiredY = 450, id = id})             
end

function insertLru(id,dt)
	for i, block in ipairs(lruCache) do
		if block.id == id then
			accessBlock(id,i,dt)
			return
		end
	end
	if #lruCache < maxCacheSize then
		spawnLru(id)
	else
		removeLru(dt)
		spawnLru(id)
	end
end

function accessBlock(id,index,dt)
	block = lruCache[index]
	table.remove(lruCache, index)
	block.desiredX =centerX - #lruCache * 55
	while block.x >= block.desiredX do
		block.x = block.x - speed * dt
	end
	updateLruBlocks(dt,index)
	table.insert(lruCache, block)
end

function removeLru(dt)
    table.insert(removedBlocks, lruCache[1])
    table.remove(lruCache, 1)
    updateLruBlocks(dt,0)
end

function updateLruBlocks(dt,removedIndex)
    for i, block in ipairs(lruCache) do
    	if i >= removedIndex then
       		block.desiredX = block.desiredX + 55
       	end
    end
end
