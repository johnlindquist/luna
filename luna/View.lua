return function()
  local o = {}

  local scoreDisplay
  function o:getScoreDisplay()
    return scoreDisplay
  end


  local function onTimeChanged(event)
    scoreDisplay.text = event.data
  end

  function o:tap(event)
    --send a "tap" to anyone listening by receive("tap")
    self:dispatchEvent({ name = "scoreTap", data = 0 })

    if self:hasEventListener("timeChange", onTimeChanged) then
      self:removeEventListener("timeChange", onTimeChanged)
    else
      self:addEventListener("timeChange", onTimeChanged)
    end
  end

  --init is called automatically
  function o:init()
    scoreDisplay = display.newText("Woo haa!", 0, 0, native.systemFont, 16)

    scoreDisplay:setTextColor(255, 255, 255)
    scoreDisplay:addEventListener("tap", self)

    --example of a "function listener"
    self:addEventListener("timeChange", onTimeChanged)
  end

  return o
end