return function()
  local o = {}

  local currentTime
  function o:getCurrentTime()
    return currentTime
  end

  function o:setCurrentTime(value)
    currentTime = value
    o:dispatchEvent({name = "timeChange", data = currentTime})
  end

  local someTable = {}
  function someTable:scoreTap(event)
    o:setCurrentTime(event.data)
  end

  function o:timer()
    o:setCurrentTime(currentTime + 1)
  end

  function o:init(startingTime)
    o:setCurrentTime(startingTime)
    --If you don't include the second param, it will default to "self" (which is also "o" in this case)
    --example of a "table listener"
    o:addEventListener("scoreTap", someTable)
    timer.performWithDelay(1000, o, 0)
  end

  return o
end