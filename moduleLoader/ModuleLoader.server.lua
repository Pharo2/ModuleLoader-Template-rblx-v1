local ServerStorage = game:GetService("ServerStorage")

local moduleFolder = ServerStorage:WaitForChild("v1_pharo")
local moduleScript = moduleFolder:FindFirstChild("Module")

local module = require(moduleScript)
