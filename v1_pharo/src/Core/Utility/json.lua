return function(framework)
	-- [ Services ]
	local HttpService = game:GetService("HttpService")

	-- [ Variables ]
	local module = {}

	-- [ Functions ]
	function module.encode(Table: table)
		return HttpService:JSONEncode(Table)
	end

	function module.decode(String: string)
		return HttpService:JSONDecode(String)
	end

	-- [ Setup ]
	framework.json = module

	-- [ Execution ]
	return module
end
