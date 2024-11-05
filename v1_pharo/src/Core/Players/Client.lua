return function(framework)
	-- [ Services ]
	local PlayerWrapper = require(script.Parent.Wrapper:FindFirstChild("PlayerWrapper"))(framework)

	-- [ Variables ]
	local Players = {}
	local Class = {}

	-- [ Functions ]

	-- \\ Player class functions

	-- [ Setup ]
	framework.Players = Players
	framework.Players.Functions = Class

	-- [ Execution ]
	return Players
end
