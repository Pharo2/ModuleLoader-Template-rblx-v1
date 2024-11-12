return function(framework)
	-- [ Services ]
	local PlayerWrapper = require(script.Parent.Wrapper:FindFirstChild("PlayerWrapper"))(framework)
	local Players = game:GetService("Players")

	-- [ Variables ]
	local Service = {}
	local Class = {}

	local playerList = {}
	local playerBinds = {adding = {}, removing = {}}
	local meta = {}

	-- [ Functions ]
	local function UpdateList()
		
	end

	local function NewCharacter(character, data)
		-- Data setup
		data.Character = character
		framework:RegisterInstance(character)
		-- Setup character

		-- Initialize connections
		for i, boundFunc in data.charBinds.adding do
			boundFunc()
		end
	end

	local function RemoveCharacter(character, data)
		-- Data cleanup
		data.Character = nil
		framework:UnregisterInstance(character)

		-- Initialize Connections
		for i, boundFunc in data.charBinds.removing do
			boundFunc()
		end
	end

	local function NewPlayer(player)
		-- Data setup
		local regId = framework:RegisterInstance(player)
		local data = {
			Player = player,
			FakePlayer = PlayerWrapper:Wrap(player),
			charBinds = {adding = {}, removing = {}}
		}
		--[[ Metatable setup
		local meta = {}
		meta.__index = data.FakePlayer
		meta.__call = function(self)
			return table.clone(self)
		end
		setmetatable(data, meta) ]]
		-- Save to playerlist
		playerList[player.Name] = data
		-- Setup player

		-- Initialize connections
		player.CharacterAdded:Connect(function(character)
			NewCharacter(character, data)
		end)
		player.CharacterRemoving:Connect(function(character)
			RemoveCharacter(character, data)
		end)
		for i, boundFunc in playerBinds.adding do
			boundFunc()
		end
	end

	local function RemovePlayer(player)
		-- Data cleanup
		framework:UnregisterInstance(player)
		playerList[player.Name] = nil
		-- Exit player

		-- Initialize connections
		for i, boundFunc in playerBinds.removing do
			boundFunc()
		end
	end

	function Service:GetPlayers()
		return playerList
	end

	-- \\ Player class functions
	function Class:TestFunction()

	end

	-- [ Setup ]
	framework.Players = Service
	framework.Players.Functions = Class

	-- [ Execution ]
	for i, player in pairs(game:GetService("Players"):GetChildren()) do
		NewPlayer(player)
	end
	Players.PlayerAdded:Connect(NewPlayer)
	Players.PlayerRemoving:Connect(RemovePlayer)
	return Service
end
