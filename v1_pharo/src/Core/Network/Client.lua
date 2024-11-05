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
			local event = network[type]:FindFirstChild(name)
			if not event then
				event = network.RemoteFunction.NewEvent:InvokeServer(name, type)
				repeat
					task.wait()
				until event ~= nil
			end
			if type == "RemoteFunction" then
				event.OnClientInvoke = func
			elseif type == "BindableEvent" then
				event.Event:Connect(func)
			elseif type == "BindableFunction" then
				event.OnInvoke = func
			end
		end
	end

	local function Fire(name, type, ...)
		local event = (type == "RemoteEvent") and events:FindFirstChildOfClass(type)
			or events[type]:FindFirstChild(name)
		if event then
			if type == "RemoteEvent" then
				event:FireServer(name, ...)
			elseif type == "RemoteFunction" then
				return event:InvokeServer(...)
			elseif type == "BindableEvent" then
				event:Fire(...)
			elseif type == "BindableFunction" then
				return event:Invoke(...)
			end
		end
	end

	local function ReceiveRE(name, ...)
		local event = network["RE"][name]
		if event then
			for i, func in pairs(event) do
				func(...)
			end
		end
	end

	function framework:FireRE(name, ...)
		Fire(name, "RemoteEvent", ...)
	end

	function framework:BindRE(name, func)
		Bind(name, "RemoteEvent", func)
	end

	function framework:FireRF(name, ...)
		return Fire(name, "RemoteFunction", ...)
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
	events:FindFirstChildOfClass("RemoteEvent").OnClientEvent:Connect(function(name, ...)
		print(name, ...)
		ReceiveRE(name, ...)
	end)

	-- [ Execution ]
	return module
end
