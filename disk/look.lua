LOOK = {}
LOOK.__index = LOOK
setmetatable(LOOK, { __index = ALG }) 

function LOOK:new()
    local obj = ALG.new(self)
    setmetatable(obj, LOOK)
    obj.direction = 1 
    obj.name = "LOOK"

    return obj
end

function LOOK:update(dt)
    if #self.requests == 0 then
        self.target = nil
        return
    end

    if self.target == nil then
        local nextRequest = self:getNextRequest()
        if nextRequest then
            self.target = self.requests[nextRequest]
        else
            self.direction = -self.direction
            self.target = self.requests[self:getNextRequest()]
        end
    else
        self:moveHead(dt)
        if self.position == self.target then
            self.readTimeElapsed = self.readTimeElapsed + dt
            if self.readTimeElapsed >= self.readTime then
                for i, pos in ipairs(self.requests) do
                    if pos == self.target then
                        table.remove(self.requests, i)
                        break
                    end
                end
                self.target = nil
                self.readTimeElapsed = 0
            end
        end
    end
end

function LOOK:getNextRequest()
    local bestIndex = nil
    local bestPos = (self.direction == 1) and math.huge or -math.huge

    for i, pos in ipairs(self.requests) do
        if (self.direction == 1 and pos >= self.position and pos < bestPos) or
           (self.direction == -1 and pos <= self.position and pos > bestPos) then
            bestPos = pos
            bestIndex = i
        end
    end

    return bestIndex
end

function LOOK:moveHead(dt)
    local newPos = self.position + self.direction * speed * dt

    if (self.direction == 1 and newPos > self.target) or (self.direction == -1 and newPos < self.target) then
        self.position = self.target
    else
        self.position = newPos
    end
end
