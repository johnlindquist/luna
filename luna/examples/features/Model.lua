Model = function()
  local o = {}
  local modelTimer
  local isPaused = false

  local currentTime
  function o:getCurrentTime()
    return currentTime
  end

  function o:setCurrentTime(value)
    currentTime = value
    o:dispatchEvent({ name = "timeChange", data = currentTime })
  end

  local someTable = {}
  function someTable:scoreTap(event)
    o:setCurrentTime(event.data)
  end

  local function onTimer()
    o:setCurrentTime(currentTime + 1)
  end

  function o:pause()
    if isPaused then
      timer.resume(modelTimer)
      isPaused = false
    else
    print("timer.pause", timer.resume)
      timer.pause(modelTimer)
      isPaused = true
    end
  end

  function o:init(startingTime)
    o:setCurrentTime(startingTime)
    --If you don't include the second param, it will default to "self" (which is also "o" in this case)
    --example of a "table listener"
    o:addEventListener("scoreTap", someTable)
    o:addEventListener("pause")

    modelTimer = timer.performWithDelay(1000, onTimer, 0)
  end

  return o
end

return Model