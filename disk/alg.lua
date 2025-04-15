ALG = {}
ALG.__index = ALG 

function ALG:new()
    local obj = setmetatable({
    	name = "none",
        requests = {},
        position = 0,
        target = nil,
        readTime = 0.5,
        readTimeElapsed = 0,
    }, self)  
    return obj
end

function ALG:addRequest(pos)
	for i, req in ipairs(self.requests) do
		if req == pos then
			return
		end
	end
    table.insert(self.requests, pos)
end


function ALG:update(dt)
    return
end