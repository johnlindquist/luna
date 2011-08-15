View = function()
  local o = {}

  local scoreDisplay
  scoreDisplay = display.newText("Not initialized", 0, 0, native.systemFont, 20)
  scoreDisplay:setTextColor(255, 255, 255)

  function o:getScoreDisplay()
    return scoreDisplay
  end

  local function onTimeChanged(event)
    scoreDisplay.text = event.data
  end

  local function onTap(event)
    o:dispatchEvent({ name = "scoreTap", data = 0 })

    if o:hasEventListener("timeChange", onTimeChanged) then
      o:removeEventListener("timeChange", onTimeChanged)
      scoreDisplay.text = "Stopped"
    else
      o:addEventListener("timeChange", onTimeChanged)
    end
  end

  function o:init(text)
    scoreDisplay.text = text
    scoreDisplay:addEventListener("tap", onTap)

    o:addEventListener("timeChange", onTimeChanged)
  end

  return o
end
return View