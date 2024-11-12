return function(framework)
	-- [ Services ]
    local CollectionService = game:GetService("CollectionService")
    local HttpService = game:GetService("HttpService")

	-- [ Variables ]
	local module = {}
    local objRegistry = {}

	-- [ Functions ]
    function framework:UnregisterInstance(object: Instance)
        local id = framework:FindInstanceId(object)
        if id and objRegistry[id] then
            objRegistry[id] = nil
        end
    end

	function framework:RegisterInstance(object: Instance)
		if not object:GetAttribute("reg") then
            local newId = HttpService:GenerateGUID()

            object:SetAttribute("reg", true)
            CollectionService:AddTag(object, newId)
            objRegistry[newId] = object

            return newId
        end
	end

	function framework:FindInstanceId(object: Instance)
		local objId = table.find(objRegistry, object)
        return objId and objId or nil
	end

    function framework:FindInstance(id: string)
        local objId = objRegistry[id]
        return objId and objId or nil
    end

	-- [ Setup ]

	-- [ Execution ]
	return module
end
