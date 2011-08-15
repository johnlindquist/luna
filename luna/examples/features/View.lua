View = function()
  -- I named this "o" because it's really short and I use it everywhere in this module
  -- This is only a personal preference, you can name it whatever you want
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

  --[[
  Because "self" and "o" are the same in the "init" function,
  "o:timeChange" could be invoked if you use one of these options:

  --the function
    function o:timeChange(event)
      scoreDisplay.text = event.data
    end

  --the options
    self:addEventListener("timeChange") --defaults to "self"
    self:addEventListener("timeChange", self)
    o:addEventListener("timeChange")
    o:addEventListener("timeChange", o)
    self:addEventListener("timeChange", o)
    o:addEventListener("timeChange", self)
  ]]

  local function onTap(event)
    --send a "scoreTap" to anyone listening by receive("scoreTap")
    o:dispatchEvent({ name = "scoreTap", data = 0 })

    if o:hasEventListener("timeChange", onTimeChanged) then
      o:removeEventListener("timeChange", onTimeChanged)
      scoreDisplay.text = "Stopped"
    else
      o:addEventListener("timeChange", onTimeChanged)
    end
  end

  --[[
  -- "init()" is convenience function called automatically after messaging is added
  -- You typically use this to setup listeners
  -- ]]
  function o:init(text)
    scoreDisplay.text = text
    --This is a Corona display listener, NOT a luna listener!
    scoreDisplay:addEventListener("tap", onTap)

    --example of a "function listener"
    o:addEventListener("timeChange", onTimeChanged)
  end

  return o
end
return View