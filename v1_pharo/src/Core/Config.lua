return function(framework)
	-- [ Services ]

	-- [ Variables ]
	local module = {}

	-- [ Functions ]
	function framework:LoadConfig(search)
		if module[search] then
			return module[search]
		else
			return nil
		end
	end

	-- [ Setup ]
	for i, v in pairs(framework.config:GetChildren()) do
		module[v.Name] = require(v)
	end

	-- [ Execution ]
	return module
end
