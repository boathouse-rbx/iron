local function Create(instanceType: string, properties: { [string]: any }): Instance?
	local instance = Instance.new(instanceType)

	for index, value in properties do
		instance[index] = value
	end

	return instance
end

return Create
