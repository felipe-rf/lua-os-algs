CLOOK = {}
CLOOK.__index = CLOOK
setmetatable(CLOOK, { __index = ALG })

function CLOOK:new()
    local obj = ALG.new(self)
    setmetatable(obj, CLOOK)
    obj.direction = 1
    obj.stopMoving = false
    obj.closest = nil
    obj.name = "C-LOOK"
    return obj
end

function CLOOK:update(dt)
    if #self.requests == 0 then
        self.target = nil
        self.closest = nil
        return
    end
    
    self:moveHead(dt)

    if self.target and self.position == self.target then
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

    if not self.stopMoving and not self.target then
        self.closest = self:getClosest()
        if self.closest then
            self.target = self.requests[self.closest]
        end
    end
end

function CLOOK:getClosest()
    if #self.requests == 0 then return nil end
    
    local closestIndex, minDistance = nil, math.huge
    for i, pos in ipairs(self.requests) do
        if pos >= self.position then
            local diff = pos - self.position
            if diff < minDistance then
                minDistance = diff
                closestIndex = i
            end
        end
    end
    self.direction = 1
    if not closestIndex then
        self.direction = -1
        closestIndex = self:getMinRequest()
    end
    
    return closestIndex
end

function CLOOK:getMinRequest()
    local minIndex, minValue = nil, math.huge
    for i, pos in ipairs(self.requests) do
        if pos < minValue then
            minValue = pos
            minIndex = i
        end
    end
    return minIndex
end

function CLOOK:getMaxRequest()
    local maxIndex, maxValue = nil, -math.huge
    for i, pos in ipairs(self.requests) do
        if pos > maxValue then
            maxValue = pos
            maxIndex = i
        end
    end
    return maxIndex
end

function CLOOK:moveHead(dt)
    if self.stopMoving then return end
    
    local newPos = self.position + self.direction * speed * dt
    
    if self.target then
        if (self.direction == 1 and newPos > self.target) or (self.direction == -1 and newPos < self.target) then
            self.position = self.target
        else
            self.position = newPos
        end
    end
end
