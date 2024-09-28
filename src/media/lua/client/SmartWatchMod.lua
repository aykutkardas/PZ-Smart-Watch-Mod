local overallHP = 0
local stepCount = 0
local weather = nil

local ClockElement = nil
local StepsElement = nil
local WeatherElement = nil
local HealtElement = nil

-- Utils
local function formatNumber(n)
    if n >= 1000 then
        return string.format("%.1fk", n / 1000)
    else
        return tostring(n)
    end
end

-- UI Elements
local function initWeatherElement()
    WeatherElement = ISUIElement:new(10, 22, 100, 100)

    WeatherElement.render = function(self)
        weather = getWorld():getWeather()
        self:drawText(weather, 10, 10, 1, 1, 1, 0.4, UIFont.Small)
    end

    WeatherElement:addToUIManager()
end

local function initStepsElement()
    StepsElement = ISUIElement:new(35, 42, 200, 50)

    StepsElement.render = function(self)
        local left = 13;

        if math.floor(stepCount) > 9 then
            left = 9
        end

        if math.floor(stepCount) > 99 then
            left = 7
        end

        if math.floor(stepCount) > 999 then
            left = 5
        end

        self:drawText(formatNumber(math.floor(stepCount)), left, 25, 1, 1, 1, 1, UIFont.Small)
    end

    StepsElement:addToUIManager()
end

local function initHealtElement()
    HealtElement = ISUIElement:new(60, 42, 50, 50)

    HealtElement.render = function(self)
        overallHP = getPlayer():getBodyDamage():getOverallBodyHealth()

        local left = 11;

        if math.floor(overallHP) > 9 then
            left = 10
        end

        if math.floor(overallHP) > 99 then
            left = 9
        end

        self:drawText(tostring(math.floor(overallHP)), left, 8, 1, 1, 1, 1, UIFont.Small)
    end

    HealtElement:addToUIManager()
end

local function initClockElement()
    local clockBackground = ISImage:new(0, 0, 100, 100, getTexture("media/ui/bg.png"))

    ClockElement = ISUIElement:new(100, 10, 100, 100)
    ClockElement:addChild(clockBackground)
    ClockElement:addChild(StepsElement)
    ClockElement:addChild(HealtElement)
    ClockElement:addChild(WeatherElement)

    ClockElement.render = function(self)
        local gameTime = getGameTime()
        local hours = gameTime:getHour()
        local minutes = gameTime:getMinutes()
        local timeString = string.format("%02d:%02d", hours, minutes)
        self:drawText(timeString, 30, 8, 1, 1, 1, 1, UIFont.Large)
    end

    ClockElement:addToUIManager()
end

-- Initializations
local function init()
    if ClockElement then
        ClockElement:removeFromUIManager()
    end

    if StepsElement then
        StepsElement:removeFromUIManager()
    end

    if HealtElement then
        HealtElement:removeFromUIManager()
    end

    if WeatherElement then
        WeatherElement:removeFromUIManager()
    end

    initWeatherElement()
    initStepsElement()
    initHealtElement()
    initClockElement()
end

-- Events
local function onPlayerGetDamage(player)
    overallHP = getPlayer():getHealth()
end

local function onPlayerUpdate(player)
    -- change this approch to get the real frame rate
    local frameRate = 144
    stepCount = stepCount + (1 / frameRate)
end

Events.OnPlayerGetDamage.Add(onPlayerGetDamage)
Events.OnPlayerMove.Add(onPlayerUpdate)
Events.OnGameStart.Add(init)

-- Debugging
-- local function onKeyPressed(key)
--     if key == Keyboard.KEY_F1 then
--         init()
--     end
-- end

-- Events.OnKeyPressed.Add(onKeyPressed)

