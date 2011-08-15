require("Luna")

local startingTime = 0
local model = luna("Model")(startingTime)

local view = luna("View")("view 1")
local view2 = luna("View")("view 2")
local view3 = luna("View")("view 3")

local lunaEventDispatcherLogger = {}
function lunaEventDispatcherLogger:timeChange(event)
  print("Log: ", event.name, event.data)
end

lunaEventDispatcherLogger = luna(lunaEventDispatcherLogger)
lunaEventDispatcherLogger:addEventListener("timeChange")

local context1Display = display.newText("Context 1", 30, 30, native.systemFont, 20)
view.getScoreDisplay().x = 75
view.getScoreDisplay().y = 100

view2.getScoreDisplay().x = 75
view2.getScoreDisplay().y = 200

view3.getScoreDisplay().x = 75
view3.getScoreDisplay().y = 300

function context1Display:tap(event)
  lunaEventDispatcher:dispatchEvent({ name = "pause" })
end
context1Display:addEventListener("tap", context1Display)

local isRunning = true
local function onShake(event)
  if event.isShake then
    if isRunning then
      lunaEventDispatcher:removeAllEventListeners()
      isRunning = false
    else
      lunaEventDispatcher:addAllRemovedEventListeners()
      isRunning = true
    end
  end
end

Runtime:addEventListener("accelerometer", onShake)

