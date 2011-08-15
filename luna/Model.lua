return function()
  local o = {}

  local currentTime
  function o:getCurrentTime()
    return currentTime
  end

  function o:setCurrentTime(value)
    currentTime = value
    self:dispatchEvent({name = "timeChange", data = currentTime})
  end

  local someTable = {}
  function someTable:scoreTap(event)
    o:setCurrentTime(event.data)
  end

  function o:timer()
    self:setCurrentTime(currentTime + 1)
  end

  function o:init(startingTime)
    self:setCurrentTime(startingTime)
    --example of a "table listener"
    self:addEventListener("scoreTap", someTable) --If you don't include the second param, it will default to "self"
    timer.performWithDelay(1000, self, 0)
  end

  return o
end