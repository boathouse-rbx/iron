local TweenService = game:GetService("TweenService")

local function makeTween(object: Instance, tweenInfo: TweenInfo, properties: { [string]: any }): Tween
	local tween = TweenService:Create(object, tweenInfo, properties)

	tween.Completed:Connect(function()
		tween:Destroy()
	end)

	return tween
end

return makeTween
