return function()
  local public = {}

  local scoreDisplay

  local function onTimeChanged(event)
    scoreDisplay.text = event.data
  end

  function public:tap(event)
    --send a "tap" to anyone listening by receive("tap")
    self:dispatchEvent({name = "scoreTap", data = 0})

    if self:hasEventListener("timeChange", onTimeChanged) then
      self:removeEventListener("timeChange", onTimeChanged)
    else
      self:addEventListener("timeChange", onTimeChanged)
    end
  end

  --init is called automatically
  function public:init()
    scoreDisplay = display.newText("", 0, 0, native.systemFont, 16)
    scoreDisplay:setTextColor(255, 255, 255)
    scoreDisplay:addEventListener("tap", self)
    self.scoreDisplay = scoreDisplay --make accessible

    --example of a "function listener"
    self:addEventListener("timeChange", onTimeChanged)
  end

  return public
end