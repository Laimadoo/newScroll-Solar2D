local newScroll = require("newScroll")

local centerX, centerY = display.contentCenterX, display.contentCenterY
local width, height = display.actualContentWidth, display.actualContentHeight

local s = newScroll({
	width = width,
	height = height,
    x = centerX,
    y = centerY,
    typeScroll = "vertical", -- vertical, horizontal, type3
    effect = "scalePadding", -- nil, bounce, scalePadding, scaleAll, scaleObjects
    friction = 0.972,
    padding = 10,
    isLocked = false,
    isOrder = true,
    isScrollBar = true,
    speedAnimation = 750,
    scrollBarWidth = 20,
    scrollBarRounded = 10,
    scrollBarColorBG = {0, 0.5},
    scrollBarColorSlider = {1}
})
-- + xScale, yScale, roration
local N = 99
local i = 0
timer.performWithDelay(0, function()
    i = i + 1
    local g = display.newGroup()
    local r = display.newRoundedRect(g, 0, 0, width - 20, math.random(80, width - 20), 20)
    local t = display.newText(g, i .. "/" .. N, 0, 0)
    t:setFillColor(0)
    
    s:insert(g)
end, N)