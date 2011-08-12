return function()
  local public = {}

  local currentTime
  function public:getCurrentTime()
    return currentTime
  end

  function public:setCurrentTime(value)
    currentTime = value
    self:send("timeChange", currentTime)
  end

  local someTable = {}
  function someTable:scoreTap(event)
    public:setCurrentTime(event.data)
  end

  function public:timer()
    self:setCurrentTime(currentTime + 1)
  end

  function public:init(startingTime)
    self:setCurrentTime(startingTime)
    --example of a "table listener"
    self:receive("scoreTap", someTable) --If you don't include the second param, it will default to "self"
    timer.performWithDelay(1000, self, 0)
  end

  return public
end