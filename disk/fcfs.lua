FCFS = {}
FCFS.__index = FCFS
setmetatable(FCFS, { __index = ALG }) 

function FCFS:new()
    local obj = ALG.new(self) 
    setmetatable(obj, FCFS) 
    obj.name = "FCFS"

    return obj
end

function FCFS:update(dt)
    if #self.requests > 0 then
        if self.target == nil then
        	self.target = self.requests[1]
	    end

	    self:moveHead(dt)
	    
	    if self.position == self.target then
	      	self.readTimeElapsed = self.readTimeElapsed + dt
	        if self.readTimeElapsed >= self.readTime then
		        table.remove(self.requests, 1)
		        self.target = nil
		        self.readTimeElapsed = 0
		    end
	    end
    end
end

function FCFS:moveHead(dt)
    local direction = (self.target > self.position) and 1 or -1
    local newPos = self.position + direction * speed * dt

    if (direction == 1 and newPos > self.target) or (direction == -1 and newPos < self.target) then
        self.position = self.target
    else
        self.position = newPos
    end
end