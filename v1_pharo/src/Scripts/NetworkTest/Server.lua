return function(framework)
	-- [ Services ]

	-- [ Variables ]
	local module = {}

	-- [ Functions ]
	local function Goodbye(player)
		framework:FireRE(player, "Goodbye")
	end

	local function Hello(player, text)
		print("Hello " .. player.Name .. ", " .. text)
		task.wait(3)
		Goodbye(player)
	end

	-- [ Setup ]
	framework:BindRE("Hello", Hello)

	-- [ Execution ]
	return module
end
