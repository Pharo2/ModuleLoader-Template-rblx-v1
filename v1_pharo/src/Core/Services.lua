return function(framework)
	-- [ Services ]

	-- [ Variables ]
	local module = {}
	local services = framework.source:FindFirstChild("Services")

	-- [ Functions ]
	function framework:GetService(service)
		if module[service] then
			return module[service]
		else
			local toFind = services:FindFirstChild(service)
			local toLoad = nil
			if toFind then
				local toLoad = toFind:FindFirstChildOfClass("ModuleScript")
				if toLoad then
					module[service] = require(toLoad)(framework)
				end
			end
			return module[service] and module[service] or nil
		end
	end

	-- [ Setup ]
	-- [ Execution ]
	return module
end
