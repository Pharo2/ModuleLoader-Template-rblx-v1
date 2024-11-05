local ReplicatedStorage = game:GetService("ReplicatedStorage")
local framework = {}

local dir = script.Parent
local src = dir.src
local coreOrder = {
	[1] = "Utility",
	[2] = "Security",
	[3] = "Network",
	[4] = "Config",
	[5] = "Services",
	[6] = "Players",
}

framework.Version = "Client"
framework.assets = ReplicatedStorage:WaitForChild("Assets", 3)
framework.cache = ReplicatedStorage:WaitForChild("Cache", 3)
framework.config = src.Configuration
framework.source = src

-- Load code and store
local function Load(toLoad)
	if toLoad and toLoad.ClassName == "ModuleScript" then
		require(toLoad)(framework)
		return true
	else
		return nil
	end
end

-- Loads all code within module
local function LoadModules()
	-- Load core scripts first
	local Core = src:FindFirstChild("Core")
	for i, nextLoad in ipairs(coreOrder) do
		local toLoad = Core:FindFirstChild(nextLoad)
		-- If we didnt find core script, panic!
		if not toLoad then
			warn("[C] Did not find core module " .. nextLoad .. " to load!")
			continue
		end
		-- If it's a folder, load all it's contents
		if toLoad.ClassName == "Folder" then
			for i, child in pairs(toLoad:GetChildren()) do
				Load(child)
			end
		-- Otherwise we can just load the thing itself
		else
			Load(toLoad)
		end
	end
	-- Load not core scripts
	local Scripts = src:FindFirstChild("Scripts")
	for i, child in pairs(Scripts:GetChildren()) do
		Load(child:FindFirstChildOfClass("ModuleScript"))
	end

	return src
end

local function Initialize()
	-- Load client modules
	LoadModules()

	-- Finished loading
	print("[C] Loaded module")
	ReplicatedStorage:SetAttribute("ClientLoaded", true)

	-- Retreat to hidey hole (sets client module code to nil instance)
	local folder = script.Parent
	folder.Parent = nil
end

Initialize()

return framework
