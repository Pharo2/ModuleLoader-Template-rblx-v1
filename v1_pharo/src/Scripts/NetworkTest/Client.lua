return function(framework)
	-- [ Services ]
	local Players = game:GetService("Players")

	-- [ Variables ]
	local module = {}
	local Player = game.Players.LocalPlayer

	-- [ Functions ]
	local function Hello()
		framework:FireRE("Hello", "whats up?")
	end

	local function Goodbye()
		print("Goodbye server.")
	end

	-- [ Setup ]
	framework:BindRE("Goodbye", Goodbye)

	-- [ Execution ]
	Hello()

	return module
end
