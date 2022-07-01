local toolbar = plugin:CreateToolbar("Instant Weld Tools")
local weldConstButton = toolbar:CreateButton("Instant Weld Constraint", "Weld Selected BaseParts", "rbxassetid://4458901886")
--local weldButton = toolbar:CreateButton("Instant Weld", "Weld Selected BaseParts", "rbxassetid://4458901886")

local instantWeldConstMainPart = nil

local function instantWeldConstraint()
	local ChangeHistoryService = game:GetService("ChangeHistoryService")
	local Selection = game:GetService("Selection")
	local selectionList = Selection:Get()
	
	if instantWeldConstMainPart == nil then
		
		if #selectionList == 1 then
			if selectionList[1]:IsA('BasePart') then
				instantWeldConstMainPart = selectionList[1]
				print(instantWeldConstMainPart.Name .. ' succesfully set as the main part.')
			else
				warn('Selected instance is not a BasePart.')
			end
		else
			warn('You must only select one BasePart.')
		end
		
	else
		ChangeHistoryService:SetWaypoint("Welding selection to main part")
		local numSuccess = 0
		
		for _, object in pairs(Selection:Get()) do
			if object:IsA("BasePart") then
				if object == instantWeldConstMainPart then
					warn(instantWeldConstMainPart.Name .. ' cannot be welded to itself.')
				else
					local weldConst = Instance.new('WeldConstraint')
					weldConst.Part0 = instantWeldConstMainPart
					weldConst.Part1 = object
					weldConst.Parent = instantWeldConstMainPart
					print(object.Name .. ' succesfully welded with weld constraint with ' .. instantWeldConstMainPart.Name)
					numSuccess = numSuccess + 1
				end
			else
				warn(object.Name .. ' is not a BasePart.')
			end
		end
		
		print(instantWeldConstMainPart.Name .. ' has successfully welded with weld constraints with ' .. numSuccess .. ' BaseParts')
		instantWeldConstMainPart = nil
		ChangeHistoryService:SetWaypoint("Weld selection to main part")
	end
end


weldConstButton.Click:Connect(instantWeldConstraint)
