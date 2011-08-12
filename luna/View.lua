return function()
  local public = {}

  local scoreDisplay

  local function onTimeChanged(event)
    scoreDisplay.text = event.data
  end

  function public:tap(event)
    --send a "tap" to anyone listening by receive("tap")
    self:send("scoreTap", 0)

    if self:isReceiving("timeChange", onTimeChanged) then
      self:stopReceive("timeChange", onTimeChanged)
    else
      self:receive("timeChange", onTimeChanged)
    end
  end

  --init is called automatically
  function public:init()
    scoreDisplay = display.newText("", 0, 0, native.systemFont, 16)
    scoreDisplay:setTextColor(255, 255, 255)
    scoreDisplay:addEventListener("tap", self)
    self.scoreDisplay = scoreDisplay --make accessible

    --example of a "function listener"
    self:receive("timeChange", onTimeChanged)
  end

  return public
end