return function(framework)
	-- [ Services ]

	-- [ Variables ]
	local Security = {}

	-- [ Functions ]

	-- Bitwise XOR function because roblox doesnt support it I guess???
	local function xor(a, b)
		local toReturn = 0
		local bit = 1

		while a > 0 or b > 0 do
			if (a % 2) ~= (b % 2) then
				toReturn = toReturn + bit
			end
			a = math.floor(a / 2)
			b = math.floor(b / 2)
			bit = bit * 2
		end

		return toReturn
	end

	-- ord function
	local function ord(text: string)
		local toReturn = {}

		for i = 1, #text do
			local value = string.byte(text, i)
			table.insert(toReturn, value)
		end

		return toReturn
	end

	-- Function to get a salt from a given time
	local function salt(givenTime: number)
		local salt = givenTime - math.floor(givenTime)

		salt = math.floor(((10 ^ #tostring(salt) - 2) * salt) / 2)

		return salt
	end

	-- Combine text with given salt
	local function pepper(text: string, salt: number)
		local toReturn = text

		toReturn = tostring(salt) .. toReturn

		return toReturn
	end

	-- Function to season some string to randomize encoding.
	function Security:Season(text: string, seasoning: number)
		local currentTime = workspace:GetServerTimeNow()

		local seasoning = seasoning and salt(seasoning) or salt(currentTime)
		local seasonedText = pepper(text, seasoning)

		return seasonedText, seasoning
	end

	-- Encode a string by using a table given by ord() and B256
	function Security:enBase(text: string)
		local toEncode = ord(text)
		local sum = 0

		for i, v in toEncode do
			sum = sum * 256 + v
		end

		return sum
	end

	-- Decode B256 into string
	function Security:deBase(toDecode: number)
		local result = ""

		while toDecode > 0 do
			local nextByte = toDecode % 256
			result = string.char(nextByte) .. result
			toDecode = toDecode / 256
		end

		return result
	end

	-- Encode using FNV-1a
	function Security:Hash(text: string)
		local toReturn = 2166136261

		for i = 1, #text do
			toReturn = xor(toReturn, string.byte(text, i))
			toReturn = (toReturn * 16777619) % 2 ^ 32
		end

		return toReturn
	end

	-- [ Setup ]
	framework.Security = Security

	-- [ Execution ]
	return Security
end
