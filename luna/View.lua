return function()
  local o = {}

  local scoreDisplay
  function o:getScoreDisplay()
    return scoreDisplay
  end


  --  This is invoked if you use     self:addEventListener("timeChange")
  local function onTimeChanged(event)
    scoreDisplay.text = event.data
  end

  --[[
  Because "self" and "o" are the same in the "init" function,
  "o:timeChange" is invoked if you use one of these options:
    self:addEventListener("timeChange") --defaults to "self"
    self:addEventListener("timeChange", self)
    o:addEventListener("timeChange")
    o:addEventListener("timeChange", o)
    self:addEventListener("timeChange", o)
    o:addEventListener("timeChange", self)
  ]]

  function o:timeChange(event)
    scoreDisplay.text = event.data
  end

  function o:tap(event)
    --send a "scoreTap" to anyone listening by receive("scoreTap")
    o:dispatchEvent({ name = "scoreTap", data = 0 })

    if o:hasEventListener("timeChange", onTimeChanged) then
      o:removeEventListener("timeChange", onTimeChanged)
    else
      o:addEventListener("timeChange", onTimeChanged)
    end
  end

  --init is called automatically
  function o:init()
    scoreDisplay = display.newText("Woo haa!", 0, 0, native.systemFont, 16)

    scoreDisplay:setTextColor(255, 255, 255)
    scoreDisplay:addEventListener("tap", o)

    --example of a "function listener"
    o:addEventListener("timeChange", onTimeChanged)
  end

  return o
end