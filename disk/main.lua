require('alg')
require('fcfs')
require('sstf')
require('look')
require("scan")
require("cscan")
require("clook")
function love.load()
    love.window.setTitle("Algoritmos de Busca em Disco")
    love.window.setMode(800, 600)
    
    diskSize = 100
    startPosition = 0
    waitTime = 0.6
    waitTimeElapsed = 0
    chosenNumber = nil
    speed = 100
    lineSize = 400
    fcfs = FCFS.new()
    sstf = SSTF.new()
    scan = SCAN.new()
    cscan = CSCAN.new()
    look = LOOK.new()
    clook = CLOOK.new()
    algs = {fcfs,sstf, scan, cscan, look, clook}
end

function love.update(dt)
    waitTimeElapsed = waitTimeElapsed + dt

    if waitTimeElapsed >= waitTime then
        chosenNumber = love.math.random(0, 20) * 5
        for i, alg in ipairs(algs) do
            alg:addRequest(chosenNumber)
        end
        waitTimeElapsed = 0
    end
    for i, alg in ipairs(algs) do
        alg:update(dt)
    end
end




function love.draw()
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2)

    local scale = lineSize / diskSize
    local sep = 80
    for i, alg in ipairs(algs) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.line(200, sep*i, 600, sep*i)
        love.graphics.print(alg.name, 380 , sep *i-20)
        love.graphics.setColor(0, 1, 0) -- Verde
        love.graphics.line(200 + alg.position * scale, sep*i-10, 200 + alg.position * scale, sep*i+10)
        love.graphics.setColor(0, 0, 1)  -- Verde
        if alg.requests then
            for j, req in ipairs(alg.requests) do
                love.graphics.circle("fill", 200 + req * scale, sep*i, 5)
            end
        end
    end
end