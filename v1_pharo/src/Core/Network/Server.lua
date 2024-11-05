return function(framework)
	-- [ Services ]
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	-- [ Variables ]
	local module = {}
	local events = ReplicatedStorage:WaitForChild("Events", 3)
	local network = { BE = {}, BF = {}, RE = {}, RF = {} }

	-- [ Functions ]
	local function Bind(name, type, func)
		if type == "RemoteEvent" then
			local event = network["RE"][name]
			if not event then
				event = {}
			end
			table.insert(event, func)
			network["RE"][name] = event
		else
			--RIPPED THIS LAST PART STRAIGHT FROM YOU KENJI CAUSE THE WAY I WAS GONNA DO IT ENDED UP NOT WORKING SORRY
			local event = events[type]:FindFirstChild(name)
			if not event then
				event = Instance.new(type)
				event.Name = name
				event.Parent = events[type]
			end
			if type == "RemoteFunction" then
				event.OnServerInvoke = func
			elseif type == "BindableEvent" then
				event.Event:Connect(func)
			elseif type == "BindableFunction" then
				event.OnInvoke = func
			end
		end
	end

	local function Fire(player, name, type, ...)
		local event = (type == "RemoteEvent") and events:FindFirstChildOfClass(type)
			or events[type]:FindFirstChild(name)
		if event then
			if type == "RemoteEvent" then
				if player.ClassName == "Player" then
					event:FireClient(player, name, ...)
				else
					event:FireAllClients(name, ...)
				end
			elseif type == "RemoteFunction" then
				return event:InvokeClient(player, ...)
			elseif type == "BindableEvent" then
				event:Fire(...)
			elseif type == "BindableFunction" then
				return event:Invoke(...)
			end
		end
	end

	local function ReceiveRE(name, salt, player, ...)
		warn(name, salt)
		-- Compare received hash to stored network binds
		local hash0 = name
		for bindName, bindTable in pairs(network["RE"]) do
			local hash1 = framework.Security:Hash(salt .. bindName)
			if hash1 == hash0 then
				name = bindName
			end
		end
		-- Execute binded functions
		local event = network["RE"][name]
		if event then
			for i, func in pairs(event) do
				func(player, ...)
			end
		end
	end

	function framework:FireRE(player, name, ...)
		Fire(player, name, "RemoteEvent", ...)
	end

	function framework:BindRE(name, func)
		Bind(name, "RemoteEvent", func)
	end

	function framework:FireRF(player, name, ...)
		return Fire(player, name, "RemoteFunction", ...)
	end

	function framework:BindRF(name, func)
		Bind(name, "RemoteFunction", func)
	end

	function framework:FireBE(name, ...)
		Fire(nil, name, "BindableEvent", ...)
	end

	function framework:BindBE(name, func)
		Bind(name, "BindableEvent", func)
	end

	function framework:FireBF(name, ...)
		return Fire(nil, name, "BindableFunction", ...)
	end

	function framework:BindBF(name, func)
		Bind(name, "BindableFunction", func)
	end

	-- [ Setup ]
	events:FindFirstChildOfClass("RemoteEvent").OnServerEvent:Connect(function(player, name, salt, ...)
		ReceiveRE(name, salt, player, ...)
	end)

	events.RemoteFunction.NewEvent.OnServerInvoke = function(player, name, eventType)
		if eventType ~= "RemoteFunction" then
			local event = Instance.new(eventType)
			event.Name = name
			event.Parent = network[eventType]
			return event
		end
	end

	-- [ Execution ]
	return module
end
