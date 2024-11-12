return function(framework)
	-- [ Services ]

	-- [ Variables ]
	local PlayerWrapper = {}
	local wrappercache = setmetatable({}, { __mode = "k" })

	-- [ Functions ]
	function PlayerWrapper:Unwrap(wrapped)
		if type(wrapped) == "table" then
			local real = {}
			for k, v in next, wrapped do
				real[k] = PlayerWrapper:Unwrap(v)
			end
			return real
		else
			local real = wrappercache[wrapped]
			if real == nil then
				return wrapped
			end
			return real
		end
	end

	function PlayerWrapper:Wrap(real)
		for w, r in next, wrappercache do
			if r == real then
				return w
			end
		end

		if type(real) == "userdata" and real.ClassName == "Player" then
			local fake = newproxy(true)
			local meta = getmetatable(fake)

			meta.__index = function(s, k)
				for i, v in pairs(framework.Players.Functions) do
					if i == k then
						return function(self)
							return PlayerWrapper:Wrap(v(self))
						end
					end
				end
				return PlayerWrapper:Wrap(real[k])
			end

			meta.__newindex = function(s, k, v)
				real[k] = v
			end

			wrappercache[fake] = real
			return fake
		elseif type(real) == "function" then
			local fake = function(...)
				local args = PlayerWrapper:Unwrap({ ... })
				local results = PlayerWrapper:Wrap({ real(unpack(args)) })
				return unpack(results)
			end
			wrappercache[fake] = real

			return fake
		elseif type(real) == "table" then
			local fake = {}

			for k, v in next, real do
				fake[k] = PlayerWrapper:Wrap(v)
			end

			return fake
		else
			return real
		end
	end

	-- [ Setup ]

	-- [ Execution ]
	return PlayerWrapper
end
