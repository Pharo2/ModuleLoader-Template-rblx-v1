return function(framework)
	-- [ Services ]
	local PlayerWrapper = require(script.Parent.Wrapper:FindFirstChild("PlayerWrapper"))(framework)

	-- [ Variables ]
	local Service = {}
	local Class = {}

	local playerList = {}
	local meta = {}

	-- [ Functions ]
	local function NewPlayer(player)
		local data = {
			Player = player,
			FakePlayer = PlayerWrapper:Wrap(player),
		}
		setmetatable(data, meta)
		meta.__index = data.FakePlayer
		meta.__call = function(self)
			return table.clone(self)
		end
		playerList[player.Name] = data
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
	game:GetService("Players").PlayerAdded:Connect(function(player)
		NewPlayer(player)
	end)
	return Service
end
