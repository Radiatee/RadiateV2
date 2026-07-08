local accessoryIds = {}
local loadedAccessories = {}
local accessoryDisplayToId = {}
local selectedAccessoryName = nil

local character
local humanoid

local headlessEnabled = false
local korbloxEnabled = false

local originalHeadData = {}
local originalKorbloxData = {}

local function saveAccessoryIdsToConfig()
	if Options.SavedAccessoryIds then
		Options.SavedAccessoryIds:SetValue(table.concat(accessoryIds, ","))
	end
end

local function notifyAvatar(text)
	Library:Notify({
		Title = "Avatar",
		Description = text,
		Time = 3,
        PlayNotifySound()
	})
end

local function saveOriginalHead()
	if not character then return end

	local head = character:FindFirstChild("Head")
	if head and not originalHeadData.Head then
		originalHeadData.Head = {
			Transparency = head.Transparency,
			LocalTransparencyModifier = head.LocalTransparencyModifier,
		}
	end

	local face = head and head:FindFirstChildOfClass("Decal")
	if face and not originalHeadData.Face then
		originalHeadData.Face = {
			Object = face,
			Transparency = face.Transparency,
		}
	end
end

local function applyHeadless()
	if not character then return end
	saveOriginalHead()

	local head = character:FindFirstChild("Head")
	if head then
		head.Transparency = 1
		head.LocalTransparencyModifier = 1

		for _, obj in ipairs(head:GetChildren()) do
			if obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Transparency = 1
			end
		end
	end
end

local function restoreHeadless()
	if not character then return end

	local head = character:FindFirstChild("Head")
	if head then
		head.Transparency = originalHeadData.Head and originalHeadData.Head.Transparency or 0
		head.LocalTransparencyModifier = originalHeadData.Head and originalHeadData.Head.LocalTransparencyModifier or 0

		for _, obj in ipairs(head:GetChildren()) do
			if obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Transparency = 0
			end
		end
	end
end

local function saveOriginalKorblox()
	if not character then return end

	for _, name in ipairs({ "RightFoot", "RightLowerLeg", "RightUpperLeg" }) do
		local part = character:FindFirstChild(name)
		if part and not originalKorbloxData[name] then
			originalKorbloxData[name] = {
				MeshId = part.MeshId,
				TextureID = part.TextureID,
				Transparency = part.Transparency,
			}
		end
	end
end

local function applyKorblox()
	if not character then return end
	saveOriginalKorblox()

	local RightFoot = character:FindFirstChild("RightFoot")
	local RightLowerLeg = character:FindFirstChild("RightLowerLeg")
	local RightUpperLeg = character:FindFirstChild("RightUpperLeg")

	if RightFoot then
		RightFoot.MeshId = "http://www.roblox.com/asset/?id=902942089"
		RightFoot.Transparency = 1
	end

	if RightLowerLeg then
		RightLowerLeg.MeshId = "http://www.roblox.com/asset/?id=902942093"
		RightLowerLeg.Transparency = 1
	end

	if RightUpperLeg then
		RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
		RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
	end
end

local function restoreKorblox()
	if not character then return end

	for name, data in pairs(originalKorbloxData) do
		local part = character:FindFirstChild(name)
		if part then
			part.MeshId = data.MeshId or ""
			part.TextureID = data.TextureID or ""
			part.Transparency = data.Transparency or 0
		end
	end
end

local function getAccessoryDropdownValues()
	local values = {}
	accessoryDisplayToId = {}

	for id, data in pairs(loadedAccessories) do
		if data.Accessory and data.Accessory.Parent then
			local display = data.Name

			if accessoryDisplayToId[display] then
				display = data.Name .. " [" .. tostring(id) .. "]"
			end

			accessoryDisplayToId[display] = id
			table.insert(values, display)
		end
	end

	table.sort(values)

	if #values == 0 then
		table.insert(values, "None")
	end

	return values
end

local function refreshAccessoryDropdown()
	local values = getAccessoryDropdownValues()

	if Options.LoadedAccessoriesDropdown then
		pcall(function()
			Options.LoadedAccessoriesDropdown:SetValues(values)
		end)

		pcall(function()
			Options.LoadedAccessoriesDropdown:SetValue(values[1])
		end)
	end
end

local function removeCollisions(accessory)
	for _, part in ipairs(accessory:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.Massless = true
		end
	end
end

local function loadAccessory(accessoryId)
	local success, result = pcall(function()
		return InsertService:LoadAsset(accessoryId)
	end)

	if success and result then
		local objects = {}

		for _, obj in ipairs(result:GetChildren()) do
			table.insert(objects, obj)
			obj.Parent = nil
		end

		result:Destroy()

		if #objects > 0 then
			return objects
		end
	end

	success, result = pcall(function()
		return game:GetObjects("rbxassetid://" .. tostring(accessoryId))
	end)

	if success and result and #result > 0 then
		return result
	end

	return nil
end

local function findAccessory(objects)
	for _, obj in ipairs(objects) do
		if obj:IsA("Accessory") then
			return obj
		end

		local accessory = obj:FindFirstChildWhichIsA("Accessory", true)
		if accessory then
			accessory.Parent = nil
			return accessory
		end
	end

	return nil
end

local function findHandleAttachment(handle)
	for _, obj in ipairs(handle:GetChildren()) do
		if obj:IsA("Attachment") then
			return obj
		end
	end

	return nil
end

local function clearWelds(handle)
	for _, obj in ipairs(handle:GetChildren()) do
		if obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj.Name == "AccessoryWeld" then
			obj:Destroy()
		end
	end
end

local function alreadyWearing(accessoryId)
	return character and character:FindFirstChild("Accessory_" .. tostring(accessoryId)) ~= nil
end

local function markAsWearing(accessoryId)
	if not character then return end

	local old = character:FindFirstChild("Accessory_" .. tostring(accessoryId))
	if old then old:Destroy() end

	local marker = Instance.new("BoolValue")
	marker.Name = "Accessory_" .. tostring(accessoryId)
	marker.Parent = character
end

local function removeMarker(accessoryId)
	if not character then return end

	local marker = character:FindFirstChild("Accessory_" .. tostring(accessoryId))
	if marker then
		marker:Destroy()
	end
end

local function addAccessoryIdToAutoLoad(accessoryId)
	for _, id in ipairs(accessoryIds) do
		if id == accessoryId then
			saveAccessoryIdsToConfig()
			return
		end
	end

	table.insert(accessoryIds, accessoryId)
	saveAccessoryIdsToConfig()
end

local function removeAccessoryIdFromAutoLoad(accessoryId)
	for i = #accessoryIds, 1, -1 do
		if accessoryIds[i] == accessoryId then
			table.remove(accessoryIds, i)
		end
	end

	saveAccessoryIdsToConfig()
end

local function addAccessory(accessoryId, silent)
	accessoryId = tonumber(accessoryId)

	if not accessoryId then
		if not silent then notifyAvatar("Invalid accessory ID.") end
        PlayNotifySound()
		return false
	end

	if not character or not humanoid then
		if not silent then notifyAvatar("Character not loaded.") end
        PlayNotifySound()
		return false
	end

	if loadedAccessories[accessoryId] and loadedAccessories[accessoryId].Accessory and loadedAccessories[accessoryId].Accessory.Parent then
		return true
	end

	if alreadyWearing(accessoryId) then
		return true
	end

	local objects = loadAccessory(accessoryId)

	if not objects or #objects == 0 then
		if not silent then notifyAvatar("Could not load accessory.") end
        PlayNotifySound()
		return false
	end

	local accessory = findAccessory(objects)

	if not accessory then
		for _, obj in ipairs(objects) do
			pcall(function()
				obj:Destroy()
			end)
		end

		if not silent then notifyAvatar("Asset is not an accessory.") end
        PlayNotifySound()
		return false
	end

	local realName = accessory.Name
	accessory.Name = "LoadedAccessory_" .. tostring(accessoryId)
	accessory.Parent = character
	removeCollisions(accessory)

	local handle = accessory:FindFirstChild("Handle")

	if not handle then
		accessory:Destroy()
		if not silent then notifyAvatar("Accessory has no Handle.") end
        PlayNotifySound()
		return false
	end

	clearWelds(handle)

	local handleAttachment = findHandleAttachment(handle)

	if not handleAttachment then
		accessory:Destroy()
		if not silent then notifyAvatar("Accessory has no attachment.") end
        PlayNotifySound()
		return false
	end

	local characterAttachment = character:FindFirstChild(handleAttachment.Name, true)

	if not characterAttachment or not characterAttachment:IsA("Attachment") then
		accessory:Destroy()
		if not silent then notifyAvatar("Character missing attachment: " .. handleAttachment.Name) end
        PlayNotifySound()
		return false
	end

	handle.CFrame = characterAttachment.WorldCFrame * handleAttachment.CFrame:Inverse()

	local weld = Instance.new("Weld")
	weld.Name = "AccessoryWeld"
	weld.Part0 = characterAttachment.Parent
	weld.Part1 = handle
	weld.C0 = characterAttachment.CFrame
	weld.C1 = handleAttachment.CFrame
	weld.Parent = handle

	for _, obj in ipairs(objects) do
		if obj ~= accessory and obj ~= accessory.Parent and not obj:IsDescendantOf(accessory) then
			pcall(function()
				obj:Destroy()
			end)
		end
	end

	loadedAccessories[accessoryId] = {
		Accessory = accessory,
		Name = realName,
	}

	addAccessoryIdToAutoLoad(accessoryId)
	markAsWearing(accessoryId)
	refreshAccessoryDropdown()

	if not silent then
		notifyAvatar("Loaded: " .. realName)
        PlayNotifySound()
	end

	return true
end

local function removeAccessory(accessoryId)
	accessoryId = tonumber(accessoryId)
	if not accessoryId then return false end

	local data = loadedAccessories[accessoryId]

	if data and data.Accessory then
		pcall(function()
			data.Accessory:Destroy()
		end)
	end

	loadedAccessories[accessoryId] = nil
	removeAccessoryIdFromAutoLoad(accessoryId)
	removeMarker(accessoryId)
	refreshAccessoryDropdown()

	notifyAvatar("Removed accessory.")
    PlayNotifySound()

	return true
end

local function removeSelectedAccessory()
	if not selectedAccessoryName or selectedAccessoryName == "None" then
		return
	end

	local id = accessoryDisplayToId[selectedAccessoryName]
	removeAccessory(id)
end

local function clearAccessories()
	for id, data in pairs(loadedAccessories) do
		if data.Accessory then
			pcall(function()
				data.Accessory:Destroy()
			end)
		end

		removeMarker(id)
	end

	table.clear(loadedAccessories)
	table.clear(accessoryIds)
	refreshAccessoryDropdown()
	saveAccessoryIdsToConfig()

	notifyAvatar("Cleared all accessories.")
    PlayNotifySound()
end

local function addAllAccessories(silent)
	for _, id in ipairs(accessoryIds) do
		addAccessory(id, silent)
		task.wait(0.15)
	end
end
