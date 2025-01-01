local changePosKeys = {
    x = true, y = true
}
local changeGroupKeys = {
    groupX = true,
    groupY = true
}
local changeContentKeys = {
    width = true, height = true
}
local changePathKeys = {
    friction = true,
    isLocked = true,
    isScrollBar = true,
    scrollBarWidth = true,
    scrollBarRounded = true,
    scrollBarMargin = true,
    speedAnimation = true,
    typeScroll = true,
    effect = true,
    padding = true,
    listener = true
}
local changeColorKeys = {
    scrollBarColorBG = true,
    scrollBarColorSlider = true
}
local notChangeKeys = {
    _path = true,
    _group = true,
    _container = true,
    _forContainerGroup = true,
    _scrollBarY = true,
    _scrollBarX = true,
    _cache = true
}

local setValue = function(value, orValue)
    if value ~= nil then
        return value
    else
        return orValue
    end
end

local minMax = function(value, min, max)
    return math.min(math.max(value, min), max)
end

local map = function(oldValue, oldMin, oldMax, newMin, newMax)
    return ((oldValue - oldMin) / (oldMax - oldMin)) * (newMax - newMin) + newMin
end

local setFillColor = function(obj, color)
    local r, g, b, a = color[1], color[2], color[3], color[4]
    r = r or 1
    local c = obj
	if not g then
		c[1], c[2], c[3], c[4] = r, r, r, 1
	elseif not b then
		c[1], c[2], c[3], c[4] = r, r, r, g
	elseif not a then
		c[1], c[2], c[3], c[4] = r, g, b, 1
	else
		c[1], c[2], c[3], c[4] = r, g, b, a
	end

    return obj
end

local setFillColorRGBA = function(obj, r, g, b, a)
    r = r or 1
    local c = obj
	if not g then
		c[1], c[2], c[3], c[4] = r, r, r, 1
	elseif not b then
		c[1], c[2], c[3], c[4] = r, r, r, g
	elseif not a then
		c[1], c[2], c[3], c[4] = r, g, b, 1
	else
		c[1], c[2], c[3], c[4] = r, g, b, a
	end

    return obj
end

-- Переменные константы

local MIN = 10^-323.6

local resizeScrollBar = function(obj)
    local scrollBarHeightMin = math.min(
        display.actualContentWidth,
        display.actualContentHeight
    )/10

    local is3type = (obj._path.typeScroll ~= "vertical" and obj._path.typeScroll ~= "horizontal") and true or false
    local margin = is3type and obj._path.scrollBarMargin or 0
    local margin2 = is3type and obj._path.scrollBarWidth or 0

    local widthScroll = minMax(
        obj._path.width*(obj._path.width/obj._path.scrollWidth),
        scrollBarHeightMin,
        obj._path.width - margin2 - margin
    )

    local heightScroll = minMax(
        obj._path.height*(obj._path.height/obj._path.scrollHeight),
        scrollBarHeightMin,
        obj._path.height - margin2 - margin
    )

    local posX = map(
        -obj._children.x,
        0,
        obj._path.scrollWidth - obj._path.width - MIN,
        0,
        obj._path.width - widthScroll - margin2 - margin
    ) - obj._path.width/2 + widthScroll/2

    local posY = map(
        -obj._children.y,
        0,
        obj._path.scrollHeight - obj._path.height - MIN,
        0,
        obj._path.height - heightScroll - margin2 - margin
    ) - obj._path.height/2 + heightScroll/2

    local g = obj._scrollBarX

    g[1].x = -margin2/2 - margin/2
    g[1].y = obj._path.height/2 - obj._path.scrollBarWidth/2 - obj._path.scrollBarMargin
    g[1].width = obj._path.width - margin2 - margin
    g[1].height = obj._path.scrollBarWidth

    g[2].x = posX
    g[2].y = obj._path.height/2 - obj._path.scrollBarWidth/2 - obj._path.scrollBarMargin
    g[2].width = widthScroll
    g[2].height = obj._path.scrollBarWidth

    g = obj._scrollBarY

    g[1].x = obj._path.width/2 - obj._path.scrollBarWidth/2 - obj._path.scrollBarMargin
    g[1].y = -margin2/2 - margin/2
    g[1].width = obj._path.scrollBarWidth
    g[1].height = obj._path.height - margin2 - margin
    
    g[2].x = obj._path.width/2 - obj._path.scrollBarWidth/2 - obj._path.scrollBarMargin
    g[2].y = posY
    g[2].width = obj._path.scrollBarWidth
    g[2].height = heightScroll
end

local reContent = function(obj, padding, scale)
    if not obj._path.isOrder then
        if obj._path.typeScroll == "vertical" then
            obj._forContainerGroup.x = 0
            obj._forContainerGroup.y = -obj._path.height/2

            obj._path.scrollHeight = obj._children.height
        elseif obj._path.typeScroll == "horizontal" then
            obj._forContainerGroup.x = -obj._path.width/2
            obj._forContainerGroup.y = 0

            obj._path.scrollWidth = obj._children.width
        else
            obj._forContainerGroup.x = -obj._path.width/2
            obj._forContainerGroup.y = -obj._path.height/2

            obj._path.scrollWidth = obj._children.width
            obj._path.scrollHeight = obj._children.height
        end
        return
    end
    scale = scale or 1
    padding = padding or obj._path.padding
    padding = padding*(1/scale)

    if obj._path.typeScroll == "vertical" then
        obj._forContainerGroup.x = 0
        obj._forContainerGroup.y = -obj._path.height/2

        obj._children.yScale = scale
        obj._children.xScale = 1

        local posY = padding / 2
        for i = 1, obj._children.numChildren do
            local child = obj._children[i]

            posY = posY + padding / 2 + child.height / 2
            child.x = 0
            child.y = posY

            posY = posY + padding / 2 + child.height / 2
        end
        obj._path.scrollHeight = posY + padding / 2
    elseif obj._path.typeScroll == "horizontal" then
        obj._forContainerGroup.x = -obj._path.width/2
        obj._forContainerGroup.y = 0

        local posX = padding / 2
        for i = 1, obj._children.numChildren do
            local child = obj._children[i]

            posX = posX + padding / 2 + child.width / 2
            child.x = posX
            child.y = 0

            posX = posX + padding / 2 + child.width / 2
        end
        obj._path.scrollWidth = posX + padding / 2
    else
        obj._forContainerGroup.x = -obj._path.width/2
        obj._forContainerGroup.y = -obj._path.height/2

        obj._path.scrollWidth = obj._children.width
        obj._path.scrollHeight = obj._children.height 
    end
end

local scrollingYFun = function(ev)
    local OBJ = ev.target.parentOBJ
    local ofs = OBJ._children
    local oc = OBJ._cache

    if OBJ._path.isLocked then
        return
    end

    if ev.phase == "began" then
        local stage = display.getCurrentStage()
        stage:setFocus(ev.target)
        -- stage:setFocus(ev.target, ev)
        ev.target.isFocus = true
        
        oc.startY = ofs.y
        oc.tY = (ev.y - ev.yStart)
        oc.dragDistanceY = 0
        local a = true

        transition.cancel(OBJ._scrollBarY)
        transition.to(OBJ._scrollBarY, {
            time = OBJ._path.speedAnimation,
            alpha = 1,
            transition = easing.outCubic
        })

        timer.cancel(oc.scrollTimer)
        timer.cancel(oc.effectTimerY)
        timer.cancel(oc.effectTimerX)

        oc.speedY = 0
        oc.isEndScrolling = false

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "began",
                target = OBJ,
                isScrollBar = false,
                xSpeed = 0,
                ySpeed = 0
            })
        end

        oc.scrollTimer = timer.performWithDelay(0, function()
            oc.speedY = oc.speedY * OBJ._path.friction

            oc.startY = minMax(
                oc.startY + oc.speedY,
                -OBJ._path.scrollHeight + OBJ._path.height,
                0
            )
            ofs.y = minMax(
                oc.startY + oc.tY,
                -OBJ._path.scrollHeight + OBJ._path.height,
                0
            )
            OBJ._path.groupY = ofs.y

            local plus = minMax(
                oc.startY + oc.speedY*oc.plusXYStep,
                -OBJ._path.scrollHeight + OBJ._path.height,
                0
            )
            oc.speedY2 = 0

            resizeScrollBar(OBJ)

            if oc.isEndScrolling and math.abs(oc.startY - plus) < oc.epsilon then
                transition.cancel(OBJ._scrollBarY)
                transition.to(OBJ._scrollBarY, {
                    time = OBJ._path.speedAnimation,
                    alpha = 0,
                    transition = easing.outCubic
                })

                if OBJ._path.listener then
                    OBJ._path.listener({
                        phase = "stopped",
                        target = OBJ,
                        isScrollBar = false,
                        xSpeed = 0,
                        ySpeed = oc.speedY
                    })
                end
                
                timer.cancel(oc.scrollTimer)
            elseif oc.speedY ~= 0 and OBJ._path.listener then
                OBJ._path.listener({
                    phase = "moved",
                    target = OBJ,
                    isScrollBar = false,
                    xSpeed = 0,
                    ySpeed = oc.speedY
                })
            end
        end, 0)

    elseif ev.phase == "moved" and ev.target.isFocus == true then
        oc.speedY2 = (ev.y - ev.yStart) - oc.tY
        oc.tY = (ev.y - ev.yStart)

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "moved",
                target = OBJ,
                isScrollBar = false,
                xSpeed = 0,
                ySpeed = 0
            })
        end
    elseif (ev.phase == "ended" or ev.phase == "cancelled") and ev.target.isFocus == true then
        oc.speedY = oc.speedY2
        oc.isEndScrolling = true

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "ended",
                target = OBJ,
                isScrollBar = false,
                xSpeed = 0,
                ySpeed = oc.speedY
            })
        end

        local stage = display.getCurrentStage()
        -- stage:setFocus(ev.target, nil)
        stage:setFocus(nil)
        ev.target.isFocus = false
    end
end

local scrollingXFun = function(ev)
    local OBJ = ev.target.parentOBJ
    local ofs = OBJ._children
    local oc = OBJ._cache

    if OBJ._path.isLocked then
        return
    end

    if ev.phase == "began" then
        local stage = display.getCurrentStage()
        stage:setFocus(ev.target)
        -- stage:setFocus(ev.target, ev)
        ev.target.isFocus = true
        
        transition.cancel(OBJ._scrollBarX)
        transition.to(OBJ._scrollBarX, {
            time = OBJ._path.speedAnimation,
            alpha = 1,
            transition = easing.outCubic
        })

        oc.startX = ofs.x
        oc.tX = (ev.x - ev.xStart)

        timer.cancel(oc.scrollTimer)

        oc.speedY = 0
        oc.isEndScrolling = false

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "began",
                target = OBJ,
                isScrollBar = false,
                xSpeed = 0,
                ySpeed = 0
            })
        end

        oc.scrollTimer = timer.performWithDelay(0, function()
            oc.speedX = oc.speedX * OBJ._path.friction

            oc.startX = minMax(
                oc.startX + oc.speedX,
                -OBJ._path.scrollWidth + OBJ._path.width,
                0
            )
            ofs.x = minMax(
                oc.startX + oc.tX,
                -OBJ._path.scrollWidth + OBJ._path.width,
                0
            )
            OBJ._path.groupX = ofs.x

            local plus = minMax(
                oc.startX + oc.speedX*oc.plusXYStep,
                -OBJ._path.scrollWidth + OBJ._path.width,
                0
            )

            oc.speedX2 = 0

            resizeScrollBar(OBJ)

            if oc.isEndScrolling and math.abs(oc.startX - plus) < oc.epsilon then
                transition.cancel(OBJ._scrollBarX)
                transition.to(OBJ._scrollBarX, {
                    time = OBJ._path.speedAnimation,
                    alpha = 0,
                    transition = easing.outCubic
                })
                timer.cancel(oc.scrollTimer)

                if OBJ._path.listener then
                    OBJ._path.listener({
                        phase = "stopped",
                        target = OBJ,
                        isScrollBar = false,
                        xSpeed = oc.speedX,
                        ySpeed = 0
                    })
                end
            elseif oc.speedX ~= 0 and OBJ._path.listener then
                OBJ._path.listener({
                    phase = "moved",
                    target = OBJ,
                    isScrollBar = false,
                    xSpeed = oc.speedX,
                    ySpeed = 0
                })
            end
        end, 0)

    elseif ev.phase == "moved" and ev.target.isFocus == true then
        oc.speedX2 = (ev.x - ev.xStart) - oc.tX
        oc.tX = (ev.x - ev.xStart)

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "moved",
                target = OBJ,
                isScrollBar = false,
                xSpeed = 0,
                ySpeed = 0
            })
        end
    elseif (ev.phase == "ended" or ev.phase == "cancelled") and ev.target.isFocus == true then
        oc.speedX = oc.speedX2
        oc.isEndScrolling = true

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "ended",
                target = OBJ,
                isScrollBar = false,
                xSpeed = oc.speedX,
                ySpeed = 0
            })
        end

        local stage = display.getCurrentStage()
        -- stage:setFocus(ev.target, nil)
        stage:setFocus(nil)
        ev.target.isFocus = false
    end
end

local scrollingXYFun = function(ev)
    local OBJ = ev.target.parentOBJ
    local ofs = OBJ._children
    local oc = OBJ._cache

    if OBJ._path.isLocked then
        return
    end

    if ev.phase == "began" then
        local stage = display.getCurrentStage()
        stage:setFocus(ev.target)
        -- stage:setFocus(ev.target, ev)
        ev.target.isFocus = true

        transition.cancel(OBJ._scrollBarX)
        transition.to(OBJ._scrollBarX, {
            time = OBJ._path.speedAnimation,
            alpha = 1,
            transition = easing.outCubic
        })

        transition.cancel(OBJ._scrollBarY)
        transition.to(OBJ._scrollBarY, {
            time = OBJ._path.speedAnimation,
            alpha = 1,
            transition = easing.outCubic
        })

        oc.startX = ofs.x
        oc.tX = (ev.x - ev.xStart)
        oc.startY = ofs.y
        oc.tY = (ev.y - ev.yStart)

        timer.cancel(oc.scrollTimer)

        oc.speedY = 0
        oc.isEndScrolling = false

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "began",
                target = OBJ,
                isScrollBar = false,
                xSpeed = 0,
                ySpeed = 0
            })
        end

        oc.scrollTimer = timer.performWithDelay(0, function()
            oc.speedX = oc.speedX * OBJ._path.friction
            oc.speedY = oc.speedY * OBJ._path.friction

            oc.startX = minMax(
                oc.startX + oc.speedX,
                -OBJ._path.scrollWidth + OBJ._path.width,
                0
            )
            ofs.x = minMax(
                oc.startX + oc.tX,
                -OBJ._path.scrollWidth + OBJ._path.width,
                0
            )
            OBJ._path.groupX = ofs.x

            oc.startY = minMax(
                oc.startY + oc.speedY,
                -OBJ._path.scrollHeight + OBJ._path.height,
                0
            )
            ofs.y = minMax(
                oc.startY + oc.tY,
                -OBJ._path.scrollHeight + OBJ._path.height,
                0
            )
            OBJ._path.groupY = ofs.y

            local plusX = minMax(
                oc.startX + oc.speedX*oc.plusXYStep,
                -OBJ._path.scrollWidth + OBJ._path.width,
                0
            )

            local plusY = minMax(
                oc.startY + oc.speedY*oc.plusXYStep,
                -OBJ._path.scrollHeight + OBJ._path.height,
                0
            )

            oc.speedX2 = 0
            oc.speedY2 = 0

            resizeScrollBar(OBJ)

            if oc.isEndScrolling and math.abs(oc.startX - plusX) < oc.epsilon and math.abs(oc.startY - plusY) < oc.epsilon then
                transition.cancel(OBJ._scrollBarX)
                transition.to(OBJ._scrollBarX, {
                    time = OBJ._path.speedAnimation,
                    alpha = 0,
                    transition = easing.outCubic
                })

                transition.cancel(OBJ._scrollBarY)
                transition.to(OBJ._scrollBarY, {
                    time = OBJ._path.speedAnimation,
                    alpha = 0,
                    transition = easing.outCubic
                })

                if OBJ._path.listener then
                    OBJ._path.listener({
                        phase = "stopped",
                        target = OBJ,
                        isScrollBar = false,
                        xSpeed = oc.speedX,
                        ySpeed = oc.speedY
                    })
                end
                
                timer.cancel(oc.scrollTimer)
            elseif oc.speedX ~= 0 or oc.speedY ~= 0 then
                if OBJ._path.listener then
                    OBJ._path.listener({
                        phase = "moved",
                        target = OBJ,
                        isScrollBar = false,
                        xSpeed = oc.speedX,
                        ySpeed = oc.speedY
                    })
                end
            end
        end, 0)

    elseif ev.phase == "moved" and ev.target.isFocus == true then
        oc.speedX2 = (ev.x - ev.xStart) - oc.tX
        oc.tX = (ev.x - ev.xStart)
        oc.speedY2 = (ev.y - ev.yStart) - oc.tY
        oc.tY = (ev.y - ev.yStart)

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "moved",
                target = OBJ,
                isScrollBar = false,
                xSpeed = 0,
                ySpeed = 0
            })
        end
    elseif (ev.phase == "ended" or ev.phase == "cancelled") and ev.target.isFocus == true then
        oc.speedX = oc.speedX2
        oc.speedY = oc.speedY2
        oc.isEndScrolling = true

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "ended",
                target = OBJ,
                isScrollBar = false,
                xSpeed = oc.speedX,
                ySpeed = oc.speedY
            })
        end

        local stage = display.getCurrentStage()
        -- stage:setFocus(ev.target, nil)
        stage:setFocus(nil)
        ev.target.isFocus = false
    end
end

local scrollBarYFun = function(ev)
    local OBJ = ev.target.parentOBJ
    local oc = OBJ._cache

    if OBJ._path.isLocked then
        return
    end

    local is3type = (OBJ._path.typeScroll ~= "vertical" and OBJ._path.typeScroll ~= "horizontal") and true or false
    local margin = is3type and OBJ._path.scrollBarMargin or 0
    local margin2 = is3type and OBJ._path.scrollBarWidth or 0

    if ev.phase == "began" then
        timer.cancel(oc.scrollTimer)

        transition.cancel(OBJ._scrollBarX)
        transition.to(OBJ._scrollBarX, {
            time = OBJ._path.speedAnimation,
            alpha = 0,
            transition = easing.outCubic
        })

        transition.cancel(OBJ._scrollBarY)
        transition.to(OBJ._scrollBarY, {
            time = OBJ._path.speedAnimation,
            alpha = 1,
            transition = easing.outCubic
        })

        local stage = display.getCurrentStage()
        stage:setFocus(ev.target)
        -- stage:setFocus(ev.target, ev)
        ev.target.isFocus = true

        oc.startSBY = ev.target.y

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "began",
                target = OBJ,
                isScrollBar = true,
                xSpeed = 0,
                ySpeed = 0
            })
        end

    elseif ev.phase == "moved" and ev.target.isFocus == true then
        ev.target.y = minMax(
            oc.startSBY + (ev.y - ev.yStart),
            -OBJ._path.height/2 + ev.target.height/2,
            OBJ._path.height/2 - ev.target.height/2 - margin2 - margin
        )

        OBJ._children.y = map(
            -(ev.target.y) - OBJ._path.height/2 + ev.target.height/2,
            0,
            OBJ._path.height - ev.target.height - margin2 - margin,
            0,
            OBJ._path.scrollHeight - OBJ._path.height - MIN
        )

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "moved",
                target = OBJ,
                isScrollBar = true,
                xSpeed = 0,
                ySpeed = 0
            })
        end
    elseif (ev.phase == "ended" or ev.phase == "cancelled") and ev.target.isFocus == true then
        transition.cancel(OBJ._scrollBarY)
        transition.to(OBJ._scrollBarY, {
            time = OBJ._path.speedAnimation,
            alpha = 0,
            transition = easing.outCubic
        })

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "ended",
                target = OBJ,
                isScrollBar = true,
                xSpeed = 0,
                ySpeed = 0
            })
        end

        local stage = display.getCurrentStage()
        -- stage:setFocus(ev.target, nil)
        stage:setFocus(nil)
        ev.target.isFocus = false
    end

    return true
end

local scrollBarXFun = function(ev)
    local OBJ = ev.target.parentOBJ
    local oc = OBJ._cache

    if OBJ._path.isLocked then
        return
    end

    local is3type = (OBJ._path.typeScroll ~= "vertical" and OBJ._path.typeScroll ~= "horizontal") and true or false
    local margin = is3type and OBJ._path.scrollBarMargin or 0
    local margin2 = is3type and OBJ._path.scrollBarWidth or 0

    if ev.phase == "began" then
        timer.cancel(oc.scrollTimer)

        transition.cancel(OBJ._scrollBarX)
        transition.to(OBJ._scrollBarX, {
            time = OBJ._path.speedAnimation,
            alpha = 1,
            transition = easing.outCubic
        })

        transition.cancel(OBJ._scrollBarY)
        transition.to(OBJ._scrollBarY, {
            time = OBJ._path.speedAnimation,
            alpha = 0,
            transition = easing.outCubic
        })

        local stage = display.getCurrentStage()
        stage:setFocus(ev.target)
        -- stage:setFocus(ev.target, ev)
        ev.target.isFocus = true

        oc.startSBX = ev.target.x

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "began",
                target = OBJ,
                isScrollBar = true,
                xSpeed = 0,
                ySpeed = 0
            })
        end

    elseif ev.phase == "moved" and ev.target.isFocus == true then
        ev.target.x = minMax(
            oc.startSBX + (ev.x - ev.xStart),
            -OBJ._path.width/2 + ev.target.width/2,
            OBJ._path.width/2 - ev.target.width/2 - margin2 - margin
        )

        OBJ._children.x = map(
            -(ev.target.x) - OBJ._path.width/2 + ev.target.width/2,
            0,
            OBJ._path.width - ev.target.width - margin2 - margin,
            0,
            OBJ._path.scrollWidth - OBJ._path.width - MIN
        )

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "moved",
                target = OBJ,
                isScrollBar = true,
                xSpeed = 0,
                ySpeed = 0
            })
        end

    elseif (ev.phase == "ended" or ev.phase == "cancelled") and ev.target.isFocus == true then
        transition.cancel(OBJ._scrollBarX)
        transition.to(OBJ._scrollBarX, {
            time = OBJ._path.speedAnimation,
            alpha = 0,
            transition = easing.outCubic
        })

        if OBJ._path.listener then
            OBJ._path.listener({
                phase = "ended",
                target = OBJ,
                isScrollBar = true,
                xSpeed = 0,
                ySpeed = 0
            })
        end

        local stage = display.getCurrentStage()
        -- stage:setFocus(ev.target, nil)
        stage:setFocus(nil)
        ev.target.isFocus = false
    end

    return true
end


local changeContent = function(obj, key)
    if key == "width" then
        obj._container.width = obj._path.width
        obj._forContainerGroup.x = -obj._path.width/2

        local g = obj._scrollBarX

        g[1].x = -obj._path.scrollBarWidth/2
        g[1].y = obj._path.height/2 - obj._path.scrollBarWidth/2
        g[1].width = obj._path.width - obj._path.scrollBarWidth
        g[1].height = obj._path.scrollBarWidth

        g[2].x = -obj._path.scrollBarWidth/2
        g[2].y = obj._path.height/2 - obj._path.scrollBarWidth/2
        g[2].width = obj._path.width - obj._path.scrollBarWidth
        g[2].height = obj._path.scrollBarWidth
    elseif key == "height" then
        obj._container.height = obj._path.height
        obj._forContainerGroup.y = -obj._path.height/2

        local g = obj._scrollBarY

        g[1].x = obj._path.width/2 - obj._path.scrollBarWidth/2
        g[1].y = -obj._path.scrollBarWidth/2
        g[1].width = obj._path.scrollBarWidth
        g[1].height = obj._path.height - obj._path.scrollBarWidth

        g[2].x = obj._path.width/2 - obj._path.scrollBarWidth/2
        g[2].y = -obj._path.scrollBarWidth/2
        g[2].width = obj._path.scrollBarWidth
        g[2].height = obj._path.height - obj._path.scrollBarWidth
    end
    reContent(obj)
end

local changeGroup = function(obj, key)
    if obj._path.typeScroll == "vertical" and key == "groupY" then
        obj._children.y = minMax(
            obj._path.groupY,
            -obj._path.scrollHeight + obj._path.height,
            0
        )
        obj._path.groupY = obj._children.y
    elseif obj._path.typeScroll == "horizontal" and key == "groupX" then
        obj._children.x = minMax(
            obj._path.groupX,
            -obj._path.scrollWidth + obj._path.width,
            0
        )
        obj._path.groupX = obj._children.x
    else
        if key == "groupY" then
            obj._children.y = minMax(
                obj._path.groupY,
                -obj._path.scrollHeight + obj._path.height,
                0
            )
            obj._path.groupY = obj._children.y
        elseif key == "groupX" then
            obj._children.x = minMax(
                obj._path.groupX,
                -obj._path.scrollWidth + obj._path.width,
                0
            )
            obj._path.groupX = obj._children.x
        end
    end
    resizeScrollBar(obj)
end

local changePath = function(obj, key)
    if key == "isScrollBar" then
        obj._scrollBarX.isVisible = key
        obj._scrollBarY.isVisible = key
    elseif key == "scrollBarWidth" then
        resizeScrollBar(obj)
    elseif key == "scrollBarRounded" then
        local g = obj._scrollBarX
        g[1].path.radius = obj._path.scrollBarRounded
        g[2].path.radius = obj._path.scrollBarRounded

        local g = obj._scrollBarY
        g[1].path.radius = obj._path.scrollBarRounded
        g[2].path.radius = obj._path.scrollBarRounded
    elseif key == "scrollBarMargin" then
        resizeScrollBar(obj)
    elseif key == "typeScroll" then
        reContent(obj)
    elseif key == "padding" then
        reContent(obj)
    end
end

local changeColor = function(obj, key)
    if key == "scrollBarColorBG" then
        local c = obj._path.scrollBarColorBG
        obj._scrollBarX[1]:setFillColor(c[1], c[2], c[3], c[4])
        obj._scrollBarY[1]:setFillColor(c[1], c[2], c[3], c[4])
    elseif key == "scrollBarColorSlider" then
        local c = obj._path.scrollBarColorSlider
        obj._scrollBarX[2]:setFillColor(c[1], c[2], c[3], c[4])
        obj._scrollBarY[2]:setFillColor(c[1], c[2], c[3], c[4])
    end
end

local indexMT = {
    getContentPosition = function(obj)
        return obj._children.x, obj._children.y
    end,

    scrollToPosition = function(obj, args)
        local op = obj._path
        local t = {}
        if args.x then
            t.groupX = args.x
        end
        if args.y then
            t.groupY = args.y
        end
        t.time = args.time or 1000
        t.transition = args.transition or easing.outCubic
        if args.onComplete then
            t.onComplete = args.onComplete
        end

        transition.to(obj, t)
    end,

    takeFocus = function(obj, event)
        local s = display.getCurrentStage()
        s:setFocus(obj._bg, event)
    end,

    setScrollBarColorBG = function(obj, r, g, b, a)
        local c = obj._path.scrollBarColorBG

        setFillColorRGBA(c, r, g, b, a)
        
        obj._scrollBarX[1]:setFillColor(c[1], c[2], c[3], c[4])
        obj._scrollBarY[1]:setFillColor(c[1], c[2], c[3], c[4])
    end,

    setScrollBarColorSlider = function(obj, r, g, b, a)
        local c = obj._path.scrollBarColorSlider
        
        setFillColorRGBA(c, r, g, b, a)
        
        obj._scrollBarX[2]:setFillColor(c[1], c[2], c[3], c[4])
        obj._scrollBarY[2]:setFillColor(c[1], c[2], c[3], c[4])
    end,

    insert = function(scroll, index, obj)
        scroll._children:insert(index, obj)
        reContent(scroll)
        resizeScrollBar(scroll)
    end,

    remove = function(scroll, obj)
        scroll._children:remove(obj)
        reContent(scroll)
        resizeScrollBar(scroll)
    end
}

local ScrollMT = {
    __newindex = function(t, k, v)
        if changePosKeys[k] then
            t._path[k] = v
            t._group[k] = v
        elseif changeContentKeys[k] then
            t._path[k] = v
            changeContent(t, k)
        elseif changeGroupKeys[k] then
            t._path[k] = v
            changeGroup(t, k)
        elseif changePathKeys[k] then
            t._path[k] = v
            changePath(t, k)
        elseif changeColorKeys[k] then
            setFillColor(t._path[k], v)
            changeColor(t, k)
        elseif not notChangeKeys[k] then
            rawset(t, k, v)
        end
    end,

    __index = function(t, k) return indexMT[k] or t._path[k] end
}


local M = function(args)
    args = args or {}
    local OBJ = {}
    OBJ._path = {}

    local op = OBJ._path
    op.x = args.x or 0
    op.y = args.y or 0
    op.width = args.width or 200
    op.height = args.height or 300
    op.friction = args.friction or 0.972
    op.typeScroll = args.typeScroll or "vertical"
    op.isLocked = setValue(args.isLocked, false)
    op.effect = args.effect or "scaleObjects"
    op.padding = args.padding or 10
    op.isScrollBar = setValue(args.isScrollBar, true)
    op.scrollBarWidth = args.scrollBarWidth or 20
    op.scrollBarRounded = args.scrollBarRounded or 0
    op.scrollBarMargin = args.scrollBarMargin or 5
    op.scrollBarColorBG = setFillColor({}, args.scrollBarColorBG or {0, 0.5})
    op.scrollBarColorSlider = setFillColor({}, args.scrollBarColorSlider or {1})

    op.speedAnimation = args.speedAnimation or 1000
    op.isOrder = setValue(args.isOrder, true)
    op.listener = args.listener

    OBJ._path.scrollWidth = 0
    OBJ._path.scrollHeight = 0
    OBJ._path.groupX = 0
    OBJ._path.groupY = 0

    -- effects:
    -- nil, bounce, scaleObjects, scalePadding, scaleAll
    -- typeScroll:
    -- horizontal, vertical, type3

    OBJ._group = display.newGroup()
    OBJ._children = display.newGroup()
    OBJ._container = display.newContainer(op.width, op.height)
    OBJ._forContainerGroup = display.newGroup()
    OBJ._bg = display.newRect(0, 0, op.width, op.height)

    OBJ._scrollBarX = display.newGroup()
    OBJ._scrollBarX.alpha = 0
    OBJ._scrollBarX.isVisible = op.isScrollBar

    display.newRoundedRect(
        OBJ._scrollBarX,
        -op.scrollBarWidth/2, op.height/2 - op.scrollBarWidth/2 - op.scrollBarMargin,
        op.width - op.scrollBarWidth - op.scrollBarMargin, op.scrollBarWidth,
        op.scrollBarRounded
    )
    display.newRoundedRect(
        OBJ._scrollBarX,
        -op.scrollBarWidth/2, op.height/2 - op.scrollBarWidth/2 - op.scrollBarMargin,
        op.width - op.scrollBarWidth - op.scrollBarMargin, op.scrollBarWidth,
        op.scrollBarRounded
    )

    OBJ._scrollBarY = display.newGroup()
    OBJ._scrollBarY.alpha = 0
    OBJ._scrollBarY.isVisible = op.isScrollBar
    display.newRoundedRect(
        OBJ._scrollBarY,
        op.width/2 - op.scrollBarWidth/2 - op.scrollBarMargin, -op.scrollBarWidth/2,
        op.scrollBarWidth, op.height - op.scrollBarWidth - op.scrollBarMargin,
        op.scrollBarRounded
    )
    display.newRoundedRect(
        OBJ._scrollBarY,
        op.width/2 - op.scrollBarWidth/2 - op.scrollBarMargin, -op.scrollBarWidth/2,
        op.scrollBarWidth, op.height - op.scrollBarWidth - op.scrollBarMargin,
        op.scrollBarRounded
    )

    OBJ._group:insert(OBJ._bg)
    OBJ._group:insert(OBJ._container)
    OBJ._group:insert(OBJ._scrollBarY)
    OBJ._group:insert(OBJ._scrollBarX)
    OBJ._container:insert(OBJ._forContainerGroup)
    OBJ._forContainerGroup:insert(OBJ._children)

    OBJ._group.x = op.x
    OBJ._group.y = op.y

    OBJ._bg.alpha = 1/255
    OBJ._bg.parentOBJ = OBJ

    local bg = OBJ._scrollBarY[1]
    local slider = OBJ._scrollBarY[2]
    slider.parentOBJ = OBJ
    slider:addEventListener("touch", scrollBarYFun)

    bg = OBJ._scrollBarX[1]
    local slider = OBJ._scrollBarX[2]
    slider.parentOBJ = OBJ
    slider:addEventListener("touch", scrollBarXFun)

    changeColor(OBJ, "scrollBarColorBG")
    changeColor(OBJ, "scrollBarColorSlider")

    if op.typeScroll == "vertical" then
        OBJ._forContainerGroup.y = -op.height/2
        OBJ._bg:addEventListener("touch", scrollingYFun)
    elseif op.typeScroll == "horizontal" then
        OBJ._forContainerGroup.x = -op.width/2
        OBJ._bg:addEventListener("touch", scrollingXFun)
    else
        OBJ._forContainerGroup.x = -op.width/2
        OBJ._forContainerGroup.y = -op.height/2
        OBJ._bg:addEventListener("touch", scrollingXYFun)
    end

    OBJ._cache = {
        tY = 0,
        startY = 0,
        speedY = 0,
        speedY2 = 0,
        dragDistanceY = 0,
        tX = 0,
        startX = 0,
        speedX = 0,
        speedX2 = 0,
        isEndScrolling = true,
        epsilon = 0.5,
        plusXYStep = 10,
        scrollTimer = timer.performWithDelay(0, function() end),

        effectTimerY = timer.performWithDelay(0, function() end),
        effectTimerX = timer.performWithDelay(0, function() end),

        startSBY = 0,
        startSBX = 0,
    }

    setmetatable(OBJ, ScrollMT)
    return OBJ
end

return M
