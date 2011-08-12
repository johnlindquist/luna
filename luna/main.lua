require("Luna")

-- Any params passed into () will be handled in the "init()" method
local startingTime = 0
local model = luna("Model")(startingTime)

local view = luna("View")()
local view2 = luna("View")()
local view3 = luna("View")()

--You can define a custom context and pass it in as the second param otherwise it will be set to the default context.
local context = {}

local startingTime = 0
local model2 = luna("Model", context)(startingTime)

local view4 = luna("View", context)()
local view5 = luna("View", context)()
local view6 = luna("View", context)()


display.newText("Context 1", 61, 70, native.systemFont, 16)
display.newText("Context 2", 158, 70, native.systemFont, 16)

view.getScoreDisplay().x = 100
view.getScoreDisplay().y = 100

view2.getScoreDisplay().x = 100
view2.getScoreDisplay().y = 200

view3.getScoreDisplay().x = 100
view3.getScoreDisplay().y = 300

view4.getScoreDisplay().x = 200
view4.getScoreDisplay().y = 100

view5.getScoreDisplay().x = 200
view5.getScoreDisplay().y = 200

view6.getScoreDisplay().x = 200
view6.getScoreDisplay().y = 300



