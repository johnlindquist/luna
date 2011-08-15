require("Luna")

-- Any params passed into () will be handled in the "init()" method
local startingTime = 0
local model = luna("Model")(startingTime)

-- If you define a path, your module needs to return an object
local view = luna("View")("view 1")
local view2 = luna("View")("view 2")
local view3 = luna("View")("view 3")

--You can define a custom context and pass it in as the second param otherwise it will be set to the default context.
local context = {}

local startingTime = 0
local model2 = luna("Model", context)(startingTime)

local view4 = luna("View", context)("view 4")
local view5 = luna("View", context)("view 5")

-- For this example, view6 intentionally doesn't call (),
-- so it doesn't call init and doesn't set up events
local view6 = luna("View", context)


--Instead of passing in the path to the module, you can also pass in a pre-made table
local defaultContextLogger = {}
function defaultContextLogger:timeChange(event)
  print("defaultContext", event.name, event.data)
end
defaultContextLogger = luna(defaultContextLogger) --No second (), so "init()" isn't called
-- You have to put this after "luna(defaultContextLogger)" if you don't have an init()
defaultContextLogger:addEventListener("timeChange")


--You may also define a custom context
local customContextLogger = {}
function customContextLogger:timeChange(event)
  print("customContext", event.name, event.data)
end

function customContextLogger:init()
  customContextLogger:addEventListener("timeChange")
end

customContextLogger = luna(customContextLogger, context)() -- <--There's a context and you can "init" this too


-- Simple visual setup
display.newText("Context 1", 61, 70, native.systemFont, 16)
view.getScoreDisplay().x = 100
view.getScoreDisplay().y = 100

view2.getScoreDisplay().x = 100
view2.getScoreDisplay().y = 200

view3.getScoreDisplay().x = 100
view3.getScoreDisplay().y = 300

display.newText("Context 2", 158, 70, native.systemFont, 16)
view4.getScoreDisplay().x = 200
view4.getScoreDisplay().y = 100

view5.getScoreDisplay().x = 200
view5.getScoreDisplay().y = 200

view6.getScoreDisplay().x = 200
view6.getScoreDisplay().y = 300



