SCAN = {}
SCAN.__index = SCAN
setmetatable(SCAN, { __index = ALG }) 

function SCAN:new()
    local obj = ALG.new(self)
    setmetatable(obj, SCAN)
    obj.direction = 1 
    obj.stopMoving = false
    obj.closest = nil
    obj.name = "SCAN"

    return obj
end

function SCAN:update(dt)
    if #self.requests == 0 then
        self.target = nil
        self.closest = nil
    end
    self:moveHead(dt)

    if self.position == self.target then
        self.stopMoving = true
        self.readTimeElapsed = self.readTimeElapsed + dt
        if self.readTimeElapsed >= self.readTime then
            table.remove(self.requests, self.closest)
            self.target = nil
            self.closest = nil
            self.readTimeElapsed = 0
            self.stopMoving = false
        end
    end

    if not self.stopMoving then
        self.closest = self:getClosest() 
        if self.closest then
            self.target = self.requests[self.closest]
        end
    end

end

function SCAN:getClosest()
    if #self.requests == 0 then return nil end

    local closestIndex, minDistance = nil, math.huge
    for i, pos in ipairs(self.requests) do
        if (self.direction == 1 and pos > self.position) or (self.direction == -1 and pos < self.position) then
            local diff = math.abs(pos - self.position)
            if diff < minDistance then
                minDistance = diff
                closestIndex = i
            end
        end
    end
    return closestIndex
end

function SCAN:moveHead(dt)    
    if self.stopMoving then return end    
    local newPos = self.position + self.direction * speed * dt
    
    if self.target then
        if (self.direction == 1 and newPos > self.target) or (self.direction == -1 and newPos < self.target) then
            self.position = self.target
        else
            self.position = newPos
        end
    else
        if self.direction == 1 and newPos >= diskSize then
            self.position = diskSize
            self.direction = -1  
        elseif self.direction == -1 and newPos <= 0 then
            self.position = 0
            self.direction = 1  
        else
            self.position = newPos
        end
    end
end