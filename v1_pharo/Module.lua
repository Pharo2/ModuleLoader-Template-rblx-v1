local version = "1.0"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local framework = {}

local dir = script.Parent
local src = dir.src
local env = dir.env
local assets = env.Assets
local coreOrder = {
	[1] = "Utility",
	[2] = "Network",
	[3] = "Config",
	[4] = "Services",
	--[5] = "Players",
}
local loadedModules = {}

framework.Version = "Server"
framework.assets = env.Assets
framework.config = src.Configuration
framework.source = src

-- Obscures server files from client version or vice versa
local function Obscure(file, version)
	for i, descendant in pairs(file:GetDescendants()) do
		if descendant.Name == version and descendant.ClassName == "ModuleScript" then
			descendant:Destroy()
		end
	end

	return file
end

-- Loads environment services into respective locations
local function LoadEnvironment()
	-- Move assets to replicated storage first
	assets.Parent = game:GetService("ReplicatedStorage")
	-- Iterate through cleaned environment
	for i, service in pairs(env:GetChildren()) do
		-- Find the service to load, or create it if necessary
		local toLoad = game:GetService(service.Name)
		-- Clear the current contents of the service if requested.
		if service:GetAttribute("Replace") == true then
			toLoad:ClearAllChildren()
		end
		-- Copy all children from module environment to game environment
		for i, child in pairs(service:GetChildren()) do
			if service.Name ~= "StarterPlayer" then
				child.Parent = toLoad
			-- StarterPlayer compat
			else
				for i, grandchild in pairs(child:GetChildren()) do
					grandchild.Parent = toLoad:FindFirstChild(child.Name)
				end
			end
		end
	end
	-- I don't like clutter, so destroy the folder of empty folders
	env:Destroy()
	return env
end

-- Load code and store
local function Load(toLoad)
	if toLoad then
		require(toLoad)(framework)
		loadedModules[toLoad.Name] = true
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
			warn("[S] Did not find core module " .. nextLoad .. " to load!")
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

	return loadedModules
end

local function Initialize()
	-- Prepare game environment
	LoadEnvironment()

	-- Removes server-side code from the client version, then sends it to the client.
	Obscure(src:Clone(), "Server").Parent = ReplicatedStorage.Module
	script.Parent:FindFirstChild("ModuleClient").Parent = ReplicatedStorage.Module

	-- Removes client-side code from the server version, then loads it.
	Obscure(src, "Client")
	print(LoadModules())

	-- Finished loading
	print("[S] Loaded module with version " .. version)
	ReplicatedStorage:SetAttribute("ServerLoaded", true)
end

Initialize()

return framework
