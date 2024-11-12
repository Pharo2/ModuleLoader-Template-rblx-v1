return function(framework)
	-- [ Services ]
	local HttpService = game:GetService("HttpService")

	-- [ Variables ]
	local module = {}
	local validData = {"string", "boolean", "number", "table"}

	-- [ Functions ]
	function module.encode(Table: table)
		return HttpService:JSONEncode(Table)
	end

	function module.decode(String: string)
		return HttpService:JSONDecode(String)
	end

	function module:SanitizeList(list: table)
		local cleanList = {}

		for i, v in list do
			if table.find(validData, typeof(v)) then
				cleanList[i] = v
			elseif typeof(v) == "Instance" then
				local id = framework:FindInstanceId(v)
				id = id and id or framework:RegisterInstance(v)
				cleanList[i] = id
			end
		end

		return framework.json.encode(cleanList)
	end

	-- [ Setup ]
	framework.json = module

	-- [ Execution ]
	return module
end
