local HttpService = game:GetService("HttpService")

local Compressor = require(script.Parent.Util.Compressor)

local function Inbound(args: {}): boolean
	if typeof(args) == "table" and not typeof(args) == "Instance" then
		for index, value in args do
			if typeof(value) == "string" then
				args[index] = Compressor.Decompress(value)
			end
		end
	end

	return true
end

local function Outbound(args: {}): boolean
	if typeof(args) == "table" and not typeof(args) == "Instance" then
		for index, value in args do
			if typeof(value) == "table" then
				local json = HttpService:JSONEncode(value)
				args[index] = Compressor.Compress(json)
			elseif typeof(value) == "string" then
				args[index] = Compressor.Compress(value)
			end
		end
	end

	return true
end

return {
	Inbound = Inbound,
	Outbound = Outbound,
}
