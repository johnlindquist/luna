Model = function()
  local o = {}
  local modelTimer
  local isPaused = false

  local currentTime
  function o:getCurrentTime()
    return currentTime
  end

  local function onScoreTap(event)
    o:setCurrentTime(event.data)
  end

  local function onTimer()
    o:setCurrentTime(currentTime + 1)
  end

  function o:pause()
    if isPaused then
      modelTimer = timer.performWithDelay(1000, onTimer, 0)
      isPaused = false
    else
      timer.pause(modelTimer)
      isPaused = true
    end
  end

  function o:setCurrentTime(value)
    currentTime = value
    o:dispatchEvent({ name = "timeChange", data = currentTime })
  end

  function o:init(startingTime)
    o:setCurrentTime(startingTime)
    o:addEventListener("scoreTap", onScoreTap)
    o:addEventListener("pause")

    modelTimer = timer.performWithDelay(1000, onTimer, 0)
  end

  return o
end

return Model