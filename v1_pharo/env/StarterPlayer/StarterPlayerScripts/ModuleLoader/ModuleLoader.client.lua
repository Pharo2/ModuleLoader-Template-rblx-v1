local ReplicatedStorage = game:GetService("ReplicatedStorage")

local moduleFolder = ReplicatedStorage:WaitForChild("Module")
local moduleScript = moduleFolder:FindFirstChild("ModuleClient")
local moduleSource = moduleFolder:WaitForChild("src", 5)

repeat
	task.wait()
	moduleScript = moduleFolder:FindFirstChild("ModuleClient")
	moduleSource = moduleFolder:FindFirstChild("src")
until moduleScript and moduleSource

local module = require(moduleScript)

-- Bye bye! Sets module loader to nil instance
task.wait()
local me = game.StarterPlayer.StarterPlayerScripts:FindFirstChild("ModuleLoader")
local me2 = script.Parent
me.Parent = nil
me2.Parent = nil
