local Global = {
	Game = require(script.Game),
	Data = require(script.Data),
	UI = require(script.UI),
	Teams = require(script.Teams),
	World = require(script.World),
}

for Class, Constants in pairs(Global) do
	Global[Class] = setmetatable(Constants, {
		__index = function(_, k)
			error(string.format("%s is not a valid member of %s!", k, Class), 2)
		end,

		__newindex = function()
			error(string.format("Creating new members in %s is not allowed!", Class), 2)
		end,

		__tostring = function()
			return string.format("Constants %s", Class)
		end,
	})
end

return setmetatable(Global, {
	__index = function(_, k)
		error(string.format("%s is not a valid member of Global!", k), 2)
	end,

	__newindex = function()
		error("Creating new members in Global is not allowed!", 2)
	end,

	__tostring = function()
		return "Global"
	end,
})
