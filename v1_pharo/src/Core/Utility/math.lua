return function(framework)
	-- [ Services ]

	-- [ Variables ]
	local module = {}

	-- [ Functions ]
	function framework.round(num, places)
		local mult = 10 ^ (places or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	function framework.percent(number, percent)
		return (percent / 100 * number)
	end

	function framework.random(min, max)
		min = max and min or 1
		max = max and max or min and min or 10
		math.randomseed(tick() / (os.clock() / math.random(2, 5)) * math.random(6, 15))
		return math.random(min, max)
	end

	-- [ Setup ]
	-- [ Execution ]
	return module
end
