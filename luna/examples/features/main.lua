require("Luna")
lunaDebug = true
-- Any params passed into () will be handled in the "init()" method
local startingTime = 0
local model = luna("Model")(startingTime)

-- If you define a path, your module needs to return an object
local view = luna("View")("view 1")
local view2 = luna("View")("view 2")
local view3 = luna("View")("view 3")

--You can define a custom EventDispatcher and pass it in as the second param otherwise it will be set to the default LunaEventDispatcher.
local eventDispatcher = EventDispatcher()

local startingTime = 0
local model2 = luna("Model", eventDispatcher)(startingTime)

-- view4 demonstrates how you can require "View" then create it inside of luna()
require("View")
local view4 = luna(View(), eventDispatcher)("view 4")

-- view5 demonstrates creating the view, then wrapping it with luna
local view5 = View()
view5 = luna(view5, eventDispatcher)("view 5")

-- For this example, view6 intentionally doesn't call (),
-- so it doesn't call init and doesn't set up events
-- scroll to the bottom to see how to call init() later
local view6 = luna("View", eventDispatcher)


--Instead of passing in the path to the module, you can also pass in a pre-made table
local lunaEventDispatcherLogger = {}
function lunaEventDispatcherLogger:timeChange(event)
  --  print("defaultContext", event.name, event.data)
end

lunaEventDispatcherLogger = luna(lunaEventDispatcherLogger) --No second (), so "init()" isn't called
-- You have to put this after "luna(defaultContextLogger)" if you don't have an init()
lunaEventDispatcherLogger:addEventListener("timeChange")


--You may also define a custom context
local customEventDispatcherLogger = {}
function customEventDispatcherLogger:timeChange(event)
  --    print("customContext", event.name, event.data)
end

function customEventDispatcherLogger:init()
  customEventDispatcherLogger:addEventListener("timeChange")
end

customEventDispatcherLogger = luna(customEventDispatcherLogger, eventDispatcher)() -- <--There's a context and you can "init" this too


-- Simple visual setup
local context1Display = display.newText("Context 1", 30, 30, native.systemFont, 20)
view.getScoreDisplay().x = 75
view.getScoreDisplay().y = 100

view2.getScoreDisplay().x = 75
view2.getScoreDisplay().y = 200

view3.getScoreDisplay().x = 75
view3.getScoreDisplay().y = 300

-- You can also dispatchEvents directly from the lunaEventDispatcher
function context1Display:tap(event)
  lunaEventDispatcher:dispatchEvent({ name = "pause" })
end

context1Display:addEventListener("tap", context1Display)

local context2Display = display.newText("Context 2", 158, 30, native.systemFont, 20)
view4.getScoreDisplay().x = 200
view4.getScoreDisplay().y = 100

view5.getScoreDisplay().x = 200
view5.getScoreDisplay().y = 200

view6.getScoreDisplay().x = 200
view6.getScoreDisplay().y = 300

function view6:tap(event)
  view6.getScoreDisplay():removeEventListener("tap", view6)
  --  You can also call "init" later
  view6:init("view 6")
end

view6.getScoreDisplay():addEventListener("tap", view6)

-- And from any custom EventDispatcher
function context2Display:tap(event)
  eventDispatcher:dispatchEvent({ name = "pause" })
end

context2Display:addEventListener("tap", context2Display)

local isRunning = true
local function onShake(event)
  if event.isShake then
    if isRunning then
      -- Be very careful with removeAllEventListeners
      -- because your tables are still dispatching events
      lunaEventDispatcher:removeAllEventListeners()
      eventDispatcher:removeAllEventListeners()
      isRunning = false
    else
      lunaEventDispatcher:addAllRemovedEventListeners()
      eventDispatcher:addAllRemovedEventListeners()
      isRunning = true
    end
  end
end

Runtime:addEventListener("accelerometer", onShake)

