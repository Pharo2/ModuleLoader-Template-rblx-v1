return function(framework)
	-- [ Services ]
	local Players = game:GetService("Players")
	local PlayerWrapper = require(script.Parent.Wrapper:FindFirstChild("PlayerWrapper"))(framework)

	-- [ Variables ]
	local Service = {}
	local Class = {}

	local playerList = {}

	-- [ Functions ]
	local function NewPlayer(player)
		local data = {
			Player = player,
			FakePlayer = PlayerWrapper:Wrap(player),
		}
		local meta = {}
		meta.__index = data.FakePlayer
		meta.__call = function(self)
			return table.clone(self)
		end
		setmetatable(data, meta)
		playerList[player.Name] = data
	end

	-- \\ Player class functions

	-- [ Setup ]
	framework.Players = Service
	framework.Players.Functions = Class

	-- [ Execution ]
	for i, player in pairs(Players:GetChildren()) do
		NewPlayer(player)
	end
	Players.PlayerAdded:Connect(NewPlayer)
	return Service
end
