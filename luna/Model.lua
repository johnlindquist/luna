return function()
  local public = {}

  local currentTime = 0
  function public:getCurrentTime()
    return currentTime
  end

  function public:setCurrentTime(value)
    currentTime = value
    self:send("timeChange", currentTime)
  end

  function public:tap(payload, sender)
    self:setCurrentTime(payload)
  end

  function public:timer()
    self:setCurrentTime(currentTime + 1)
  end

  function public:init()
    --    example of a "table listener"
    self:receive("tap", self)
    timer.performWithDelay(1000, self, 0)
  end

  return public
end