SSTF = {}
SSTF.__index = SSTF
setmetatable(SSTF, { __index = ALG }) 

function SSTF:new()
    local obj = ALG.new(self)
    setmetatable(obj, SSTF)
    obj.closest = nil
    obj.name = "SSTF"
    return obj
end

function SSTF:update(dt)
    if #self.requests == 0 then
        self.target = nil
        self.closest = nil
        return
    end

    if self.target == nil then
        self.closest = self:getClosest() 
        if self.closest then
            self.target = self.requests[self.closest]
        end
    end
    self:moveHead(dt)
    if self.position == self.target then
        self.readTimeElapsed = self.readTimeElapsed + dt
        if self.readTimeElapsed >= self.readTime then
            table.remove(self.requests, self.closest) 
            self.target = nil
            self.closest = nil
            self.readTimeElapsed = 0
        end
    end
end

function SSTF:getClosest()
    if #self.requests == 0 then return nil end

    local closestIndex, minDistance = nil, math.huge
    for i, pos in ipairs(self.requests) do
        local diff = math.abs(pos - self.position)
        if diff < minDistance then
            minDistance = diff
            closestIndex = i
        end
    end
    return closestIndex
end

function SSTF:moveHead(dt)
    local direction = (self.target > self.position) and 1 or -1
    local newPos = self.position + direction * speed * dt

    -- Prevent overshooting
    if (direction == 1 and newPos > self.target) or (direction == -1 and newPos < self.target) then
        self.position = self.target
    else
        self.position = newPos
    end
end
