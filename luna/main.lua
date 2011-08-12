require"Luna"

local startingTime = 0
local model = luna"Model"(startingTime)

-- Any params passed into () will be handled in the "init()" method
local view = luna"View"()
view.scoreDisplay.x = 100
view.scoreDisplay.y = 100

local view2 = luna"View"()
view2.scoreDisplay.x = 100
view2.scoreDisplay.y = 200

local view3 = luna"View"()
view3.scoreDisplay.x = 100
view3.scoreDisplay.y = 300



