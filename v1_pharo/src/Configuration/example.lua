return function(framework)
	--[[
        THIS IS AN EXAMPLE SCRIPT SETUP TO SHOW HOW TO USE CONFIGURATION
        Configuration uses JSON formatting

        Access a config from any script using framework:GetConfig()
            ex: local jobs = framework:LoadConfig("example")
        This will return the json table in the config file, and you can now access this data from your script
            ex: print(jobs.doctor.wage)
            prints: 8000.0
        The data can NOT be changed across scripts.
            in script A: jobs.doctor.wage =  4000.0
            in script A: print(jobs.doctor.wage)
            prints: 4000.0
            in script B: print(jobs.doctor.wage)
            prints: 8000.0
    ]]

	-- [ Setup ]

	-- [ Execution ]
	return {
		Farmer = {
			PayTypes = {
				"WAGE",
				"PER_WHEAT_HARVESTED",
				"PER_WHEAT_DELIVERED",
			},
			DefaultPayType = "PER_WHEAT_DELIVERED",
			DefaultWageTime = 5,
			DefaultPay = 5,
		},
	}
end
