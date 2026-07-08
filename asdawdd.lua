local function resetOriginalClothes()
	if not ScriptReady then return end
	if not character then notifyAvatar("Character not loaded.") return end
    PlayNotifySound()

	if not originalClothesData.Saved then
		saveOriginalClothes()
	end

	local shirt = character:FindFirstChildOfClass("Shirt")
	local pants = character:FindFirstChildOfClass("Pants")

	if originalClothesData.HadShirt then
		if not shirt then
			shirt = Instance.new("Shirt")
			shirt.Name = "Shirt"
			shirt.Parent = character
		end
		shirt.ShirtTemplate = originalClothesData.ShirtTemplate or ""
	elseif shirt then
		shirt:Destroy()
	end

	if originalClothesData.HadPants then
		if not pants then
			pants = Instance.new("Pants")
			pants.Name = "Pants"
			pants.Parent = character
		end
		pants.PantsTemplate = originalClothesData.PantsTemplate or ""
	elseif pants then
		pants:Destroy()
	end

	notifyAvatar("Reset clothes to original avatar.")
    PlayNotifySound()
end

local activeAnimationIds = {}
local hasActiveAnimations
local reapplyActiveAnimationsAfterRespawn

local function setupCharacter(newCharacter, isRespawn)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")

	table.clear(originalClothesData)
	originalClothesData.Saved = false
	saveOriginalClothes()

	table.clear(loadedAccessories)
	table.clear(originalHeadData)
	table.clear(originalKorbloxData)

	local shouldReloadAccessories = #accessoryIds > 0
	local shouldReloadAnimations = hasActiveAnimations and hasActiveAnimations()

	if isRespawn and shouldReloadAnimations then
		notifyAvatar("Death detected loading animations...")
	elseif isRespawn and shouldReloadAccessories then
		notifyAvatar("Death detected, adding back accessories...")
	end

	task.wait(0.25)

	if headlessEnabled then
		applyHeadless()
	end

	if korbloxEnabled then
		applyKorblox()
	end

	addAllAccessories(true)
	refreshAccessoryDropdown()

	if isRespawn and shouldReloadAnimations and reapplyActiveAnimationsAfterRespawn then
		reapplyActiveAnimationsAfterRespawn(true)
	end
end

AvatarGroup:AddInput("AccessoryIdInput", {
	Text = "Accessory ID",
	Default = "",
	Numeric = true,
	Finished = false,
	ClearTextOnFocus = false,
	Placeholder = "0000000000",
	Callback = function(Value) end,
})

AvatarGroup:AddButton({
	Text = "Load Accessory",
	Func = function()
		local id = tonumber(Options.AccessoryIdInput.Value)
		addAccessory(id, false)
	end
})

AvatarGroup:AddDivider()

AvatarGroup:AddToggle("HeadlessToggle", {
	Text = "Headless",
	Default = false,
	Callback = function(Value)
		if not ScriptReady then return end
		headlessEnabled = Value

		if Value then
			applyHeadless()
		else
			restoreHeadless()
		end
	end
})

AvatarGroup:AddToggle("KorbloxToggle", {
	Text = "Korblox Right Leg",
	Default = false,
	Callback = function(Value)
		if not ScriptReady then return end
		korbloxEnabled = Value

		if Value then
			applyKorblox()
		else
			restoreKorblox()
		end
	end
})
local presetAccessories = {
	FieryHorns = 215718515,
	FrozenHorns = 74891470,
	PoisonedHorns = 1744060292,
}

local function togglePresetAccessory(accessoryId, value)
	if value then
		addAccessory(accessoryId, false)
	else
		removeAccessory(accessoryId)
	end
end

AvatarGroup:AddDivider()

AvatarGroup:AddToggle("FieryHornsToggle", {
	Text = "Fiery Horns",
	Default = false,
	Callback = function(Value)
		if not ScriptReady then return end
		togglePresetAccessory(presetAccessories.FieryHorns, Value)
	end
})

AvatarGroup:AddToggle("FrozenHornsToggle", {
	Text = "Frozen Horns",
	Default = false,
	Callback = function(Value)
		if not ScriptReady then return end
		togglePresetAccessory(presetAccessories.FrozenHorns, Value)
	end
})

AvatarGroup:AddToggle("PoisonedHornsToggle", {
	Text = "Poisoned Horns",
	Default = false,
	Callback = function(Value)
		if not ScriptReady then return end
		togglePresetAccessory(presetAccessories.PoisonedHorns, Value)
	end
})

AvatarManageGroup:AddDropdown("LoadedAccessoriesDropdown", {
	Values = { "None" },
	Default = 1,
	Multi = false,
	Text = "Loaded Accessories",
	Searchable = true,
	Callback = function(Value)
		if not ScriptReady then return end
		selectedAccessoryName = Value
	end,
})

AvatarManageGroup:AddButton({
	Text = "Remove Selected",
	Func = function()
		removeSelectedAccessory()
	end
})

AvatarManageGroup:AddButton({
	Text = "Clear All",
	Func = function()
		clearAccessories()
	end
})

AvatarManageGroup:AddButton({
	Text = "Refresh List",
	Func = function()
		refreshAccessoryDropdown()
	end
})


AvatarManageGroup:AddLabel("Dropdown shows accessory names.", true)


ClothesGroup:AddInput("ShirtAssetId", {
	Text = "Shirt Asset ID",
	Default = "",
	Numeric = true,
	Finished = false,
	ClearTextOnFocus = false,
	Placeholder = "Shirt ID",
	Callback = function(Value) end,
})

ClothesGroup:AddButton({
	Text = "Load Shirt",
	Func = function()
		applyShirt(Options.ShirtAssetId and Options.ShirtAssetId.Value or "")
	end
})

ClothesGroup:AddInput("PantsAssetId", {
	Text = "Pants Asset ID",
	Default = "",
	Numeric = true,
	Finished = false,
	ClearTextOnFocus = false,
	Placeholder = "Pants ID",
	Callback = function(Value) end,
})

ClothesGroup:AddButton({
	Text = "Load Pants",
	Func = function()
		applyPants(Options.PantsAssetId and Options.PantsAssetId.Value or "")
	end
})

ClothesGroup:AddButton({
	Text = "Reset Clothes",
	Func = function()
		resetOriginalClothes()
	end
})

ClothesGroup:AddLabel("Loads classic Shirt/Pants by asset ID. Reset restores clothes from your avatar.", true)

-- // AVATAR ANIMATIONS / EMOTES (Motiona logic without Motiona UI)

local AvatarEmotesGroup = Tabs.Avatar:AddLeftGroupbox("Emotes", "smile")
local AvatarAnimationsGroup = Tabs.Avatar:AddRightGroupbox("Animations", "person-standing")

local animationSlots = { "idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle" }
local emoteSlots = { "slot1", "slot2", "slot3", "slot4", "slot5", "slot6", "slot7", "slot8" }

local AnimationPresets = {
	["Cartoony Animation Package"] = {
		run = "10921076136", walk = "10921082452", fall = "10921077030", jump = "10921078135",
		idle = "10921071918,10921072875", swim = "10921079380", swimidle = "10921081059", climb = "10921070953",
	},
	["Ninja Animation Package"] = {
		run = "10921157929", walk = "10921162768", fall = "10921159222", jump = "10921160088",
		idle = "10921155160,10921155867", swim = "10921161002", swimidle = "10922757002", climb = "10921154678",
	},
	["Vampire Animation Pack"] = {
		run = "10921320299", walk = "10921326949", fall = "10921321317", jump = "10921322186",
		idle = "10921315373,10921316709", swim = "10921324408", swimidle = "10921325443", climb = "10921314188",
	},
	["Toy Animation Pack"] = {
		run = "10921306285", walk = "10921312010", fall = "10921307241", jump = "10921308158",
		idle = "10921301576,10921302207", swim = "10921309319", swimidle = "10921310341", climb = "10921300839",
	},
	["Oldschool Animation Pack"] = {
		run = "10921240218", walk = "10921244891", fall = "10921241244", jump = "10921242013",
		idle = "10921230744,10921232093", swim = "10921243048", swimidle = "10921244018", climb = "10921229866",
	},
}

local MotionaAnimationStorage = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Radiatee/RadiateV2/refs/heads/main/asdawd.lua"
))()

local originalAnimationIds = nil

local function getCurrentCharacter()
	return player.Character or character
end

local function getAnimateScript()
	local char = getCurrentCharacter()
	return char and char:FindFirstChild("Animate")
end

local function cleanAssetId(value)
	value = tostring(value or ""):gsub("%s+", "")
	if value == "" then return "" end
	local id = value:match("%d+")
	if not id then return value end
	return "rbxassetid://" .. id
end

local function normalizeSearchText(value)
	return tostring(value or ""):lower():gsub("[^%w]", "")
end

local function normalizeSearchLetters(value)
	return tostring(value or ""):lower():gsub("[^%a]", "")
end

local function matchesSearchName(name, input)
	local a = normalizeSearchText(name)
	local b = normalizeSearchText(input)
	return b ~= "" and (a == b or a:find(b, 1, true) ~= nil or b:find(a, 1, true) ~= nil)
end

local function matchesMotionaText(name, input)
	local a = normalizeSearchLetters(name)
	local b = normalizeSearchLetters(input)
	return b ~= "" and (a == b or a:find(b, 1, true) ~= nil or b:find(a, 1, true) ~= nil)
end

local function idsFromMotionaSlot(slotTable)
	local ids = {}
	if type(slotTable) ~= "table" then return "" end
	for _, value in pairs(slotTable) do
		local id = tostring(value):match("%d+")
		if id then
			table.insert(ids, id)
		end
	end
	return table.concat(ids, ",")
end

local function resolveAnimationInput(slot, value)
	value = tostring(value or "")
	if value:match("%d+") then
		return value
	end

	for presetName, preset in pairs(AnimationPresets) do
		if matchesSearchName(presetName, value) and preset[slot] then
			return preset[slot]
		end
	end

	for presetName, preset in pairs(MotionaAnimationStorage) do
		if matchesSearchName(presetName, value) and preset[slot] then
			return idsFromMotionaSlot(preset[slot])
		end
	end

	return value
end

local function resolveEmoteDetailed(value, useAssetId)
	value = tostring(value or "")
	local directId = value:match("%d+")
	if directId then
		return directId, "Custom", true
	end

	for emoteName, ids in pairs(MotionaEmoteStorage) do
		if matchesSearchName(emoteName, value) or matchesMotionaText(emoteName, value) then
			local wanted = useAssetId and ids[2] or ids[1]
			return tostring(wanted or ""), emoteName, true
		end
	end

	return value, nil, false
end

local function resolveEmoteInput(value, useAssetId)
	local id = resolveEmoteDetailed(value, useAssetId)
	return id
end

local function saveOriginalAnimations()
	if originalAnimationIds then return end
	originalAnimationIds = {}
	local animate = getAnimateScript()
	if not animate then return end

	for _, folder in ipairs(animate:GetChildren()) do
		if folder:IsA("StringValue") then
			originalAnimationIds[folder.Name] = {}
			for _, obj in ipairs(folder:GetChildren()) do
				if obj:IsA("Animation") then
					originalAnimationIds[folder.Name][obj.Name] = obj.AnimationId
				end
			end
		end
	end
end

local function restartAnimate()
	local char = getCurrentCharacter()
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local animate = getAnimateScript()
	if hum then
		for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
			pcall(function() track:Stop(0) end)
		end
	end
	if animate and animate:IsA("LocalScript") then
		animate.Disabled = true
		task.wait()
		animate.Disabled = false
	end
end

local function setAnimationFolder(folderName, idsText)
	local animate = getAnimateScript()
	if not animate then return false end
	local folder = animate:FindFirstChild(folderName)
	if not folder then return false end

	local ids = {}
	for id in tostring(idsText or ""):gmatch("[^,%s]+") do
		table.insert(ids, cleanAssetId(id))
	end
	if #ids == 0 then return true end

	local animations = {}
	for _, obj in ipairs(folder:GetChildren()) do
		if obj:IsA("Animation") then
			table.insert(animations, obj)
		end
	end

	if #animations == 0 then
		local anim = Instance.new("Animation")
		anim.Name = folderName
		anim.Parent = folder
		animations = { anim }
	end

	for i, anim in ipairs(animations) do
		anim.AnimationId = ids[((i - 1) % #ids) + 1]
	end

	return true
end

local function rememberActiveAnimation(slot, idsText)
	idsText = tostring(idsText or "")
	if idsText == "" then
		activeAnimationIds[slot] = nil
	else
		activeAnimationIds[slot] = idsText
	end
end

hasActiveAnimations = function()
	for _, idsText in pairs(activeAnimationIds) do
		if tostring(idsText or "") ~= "" then
			return true
		end
	end
	return false
end

reapplyActiveAnimationsAfterRespawn = function(silent)
	if not hasActiveAnimations() then
		return false
	end

	local changed = 0
	for _, slot in ipairs(animationSlots) do
		local ids = activeAnimationIds[slot]
		if ids and tostring(ids) ~= "" then
			if setAnimationFolder(slot, ids) then
				changed += 1
			end
		end
	end

	if changed > 0 then
		restartAnimate()
		if not silent then
			notifyAvatar("Applied " .. tostring(changed) .. " animation slots.")
		end
		return true
	end

	return false
end

local function applyAnimationInputs()
	saveOriginalAnimations()
	local changed = 0
	for _, slot in ipairs(animationSlots) do
		local opt = Options["Anim_" .. slot]
		if opt and tostring(opt.Value or "") ~= "" then
			local resolved = resolveAnimationInput(slot, opt.Value)
			if resolved ~= tostring(opt.Value or "") then
				pcall(function() opt:SetValue(resolved) end)
			end
			if setAnimationFolder(slot, resolved) then
				rememberActiveAnimation(slot, resolved)
				changed += 1
			end
		end
	end
	restartAnimate()
	notifyAvatar("Applied " .. tostring(changed) .. " animation slots.")
    PlayNotifySound()
end

local function applyAnimationPreset(presetName)
	local preset = AnimationPresets[presetName] or MotionaAnimationStorage[presetName]
	if not preset then
		for name, data in pairs(MotionaAnimationStorage) do
			if matchesSearchName(name, presetName) then
				presetName = name
				preset = data
				break
			end
		end
	end
	if not preset then return end
	saveOriginalAnimations()
	for _, slot in ipairs(animationSlots) do
		local ids = preset[slot]
		if type(ids) == "table" then
			ids = idsFromMotionaSlot(ids)
		end
		if ids and Options["Anim_" .. slot] then
			Options["Anim_" .. slot]:SetValue(ids)
		end
		if ids then
			if setAnimationFolder(slot, ids) then
				rememberActiveAnimation(slot, ids)
			end
		end
	end
	restartAnimate()
	notifyAvatar("Applied " .. tostring(presetName) .. ".")
    PlayNotifySound()
end

local function resetAnimations()
	if not originalAnimationIds then
		notifyAvatar("No saved original animations yet.")
        PlayNotifySound()
		return
	end
	local animate = getAnimateScript()
	if not animate then return end
	for folderName, anims in pairs(originalAnimationIds) do
		local folder = animate:FindFirstChild(folderName)
		if folder then
			for animName, id in pairs(anims) do
				local anim = folder:FindFirstChild(animName)
				if anim and anim:IsA("Animation") then
					anim.AnimationId = id
				end
			end
		end
	end
	table.clear(activeAnimationIds)
	restartAnimate()
	notifyAvatar("Animations reset.")
    PlayNotifySound()
end

local function playEmoteId(emoteId)
	local char = getCurrentCharacter()
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local resolvedId, emoteName, found = resolveEmoteDetailed(emoteId, false)
	local id = cleanAssetId(resolvedId)
	if id == "" or (not tostring(id):match("%d+")) then
		notifyAvatar("Emote not found: " .. tostring(emoteId))
        PlayNotifySound()
		return
	end

	if Options.PlayEmoteId and found then
		pcall(function() Options.PlayEmoteId:SetValue(emoteName or resolvedId) end)
	end

	local anim = Instance.new("Animation")
	anim.AnimationId = id

	local animate = getAnimateScript()
	local playEmote = animate and animate:FindFirstChild("PlayEmote")
	if playEmote and playEmote:IsA("BindableFunction") then
		local ok = pcall(function() playEmote:Invoke(anim) end)
		if ok then
			game:GetService("Debris"):AddItem(anim, 2)
			return
		end
	end

	local track = hum:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action
	track:Play(0.1, 1, 1)
	game:GetService("Debris"):AddItem(anim, 2)
end


local ActiveRadiateEmoteTable = nil
local ActiveRadiateEmoteOrder = nil
local OriginalRobloxEmoteTable = nil
local OriginalRobloxEmoteOrder = nil
local EmoteInputsHydrated = false
local EmoteCharacterWatcher = nil
local EmoteDescriptionWatcher = nil
local EmoteReapplyBusy = false


local function copyEmoteTable(source)
	local copied = {}
	if type(source) ~= "table" then
		return copied
	end

	for name, ids in pairs(source) do
		copied[name] = {}
		if type(ids) == "table" then
			for _, id in ipairs(ids) do
				table.insert(copied[name], id)
			end
		else
			copied[name] = { ids }
		end
	end

	return copied
end

local function copyEmoteOrder(source)
	local copied = {}
	if type(source) ~= "table" then
		return copied
	end

	for _, name in ipairs(source) do
		table.insert(copied, name)
	end

	return copied
end

local function getCurrentRobloxEmotes(hum)
	local description
	pcall(function()
		description = hum:GetAppliedDescription()
	end)

	if not description then
		description = hum:FindFirstChildOfClass("HumanoidDescription") or hum.HumanoidDescription
	end

	local currentEmotes = {}
	local currentOrder = {}

	if description then
		pcall(function()
			currentEmotes = description:GetEmotes()
		end)

		pcall(function()
			currentOrder = description:GetEquippedEmotes()
		end)
	end

	return copyEmoteTable(currentEmotes), copyEmoteOrder(currentOrder)
end

local function cacheCurrentRobloxEmotes(force)
	if OriginalRobloxEmoteTable and OriginalRobloxEmoteOrder and not force then
		return OriginalRobloxEmoteTable, OriginalRobloxEmoteOrder
	end

	local char = getCurrentCharacter()
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then
		OriginalRobloxEmoteTable = OriginalRobloxEmoteTable or {}
		OriginalRobloxEmoteOrder = OriginalRobloxEmoteOrder or {}
		return OriginalRobloxEmoteTable, OriginalRobloxEmoteOrder
	end

	local currentTable, currentOrder = getCurrentRobloxEmotes(hum)
	OriginalRobloxEmoteTable = copyEmoteTable(currentTable)
	OriginalRobloxEmoteOrder = copyEmoteOrder(currentOrder)
	return OriginalRobloxEmoteTable, OriginalRobloxEmoteOrder
end

local function hydrateEmoteInputsFromRoblox(force)
	if EmoteInputsHydrated and not force then return end

	local baseTable, baseOrder = cacheCurrentRobloxEmotes(force)
	for i, slot in ipairs(emoteSlots) do
		local opt = Options["Emote_" .. slot]
		local currentValue = opt and tostring(opt.Value or "") or ""
		local emoteName = baseOrder and baseOrder[i]

		if opt and emoteName and emoteName ~= "" and baseTable and baseTable[emoteName] then
			if force or currentValue == "" then
				pcall(function()
					opt:SetValue(emoteName)
				end)
			end
		end
	end

	EmoteInputsHydrated = true
end

local function buildMergedEmoteSlots(hum)
	local baseTable, baseOrder = cacheCurrentRobloxEmotes(false)
	local emoteTable = copyEmoteTable(baseTable)
	local emoteOrder = copyEmoteOrder(baseOrder)
	local changed = false

	for i, slot in ipairs(emoteSlots) do
		local opt = Options["Emote_" .. slot]
		local raw = opt and tostring(opt.Value or "") or ""

		if raw ~= "" then
			if emoteTable[raw] then
				emoteOrder[i] = raw
				changed = true
			else
				local resolvedId, emoteName, found = resolveEmoteDetailed(raw, true)
				local id = tostring(resolvedId or ""):match("%d+")

				if id then
					local name = found and emoteName or ("Radiate" .. tostring(i))
					emoteTable[name] = { tonumber(id) }
					emoteOrder[i] = name
					changed = true

					if opt and found then
						pcall(function() opt:SetValue(emoteName) end)
					end
				else
					notifyAvatar("Emote not found: " .. raw)
                    PlayNotifySound()
				end
			end
		end
	end

	for i = #emoteOrder, 1, -1 do
		local name = emoteOrder[i]
		if name == nil or name == "" or emoteTable[name] == nil then
			table.remove(emoteOrder, i)
		end
	end

	return emoteTable, emoteOrder, changed
end

local function refreshRobloxEmoteMenu()
	hydrateEmoteInputsFromRoblox(false)

	local StarterGui = game:GetService("StarterGui")
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
	end)
	task.wait(0.05)
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
	end)
end

local function forceApplyActiveEmoteSlots(silent)
	if not ActiveRadiateEmoteTable or not ActiveRadiateEmoteOrder or #ActiveRadiateEmoteOrder == 0 then
		return false
	end

	local char = getCurrentCharacter()
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then
		return false
	end

	local ok, err = pcall(function()
		local description = hum:GetAppliedDescription()
		description:SetEmotes(ActiveRadiateEmoteTable)
		description:SetEquippedEmotes(ActiveRadiateEmoteOrder)

		local liveDescription = hum:FindFirstChildOfClass("HumanoidDescription") or hum.HumanoidDescription
		if liveDescription then
			liveDescription:SetEmotes(ActiveRadiateEmoteTable)
			liveDescription:SetEquippedEmotes(ActiveRadiateEmoteOrder)
		end

		pcall(function()
			hum:ApplyDescription(description)
		end)

		task.wait(0.15)
		local refreshedDescription = hum:FindFirstChildOfClass("HumanoidDescription") or hum.HumanoidDescription
		if refreshedDescription then
			refreshedDescription:SetEmotes(ActiveRadiateEmoteTable)
			refreshedDescription:SetEquippedEmotes(ActiveRadiateEmoteOrder)
		end
	end)

	if not ok and not silent then
		notifyAvatar("Could not lock emote slots: " .. tostring(err))
        PlayNotifySound()
	end

	return ok
end

local function scheduleEmoteSlotLock()
	if EmoteReapplyBusy then return end
	EmoteReapplyBusy = true

	task.spawn(function()
		for _, delayTime in ipairs({0, 0.2, 0.6, 1.2, 2.0, 3.0}) do
			if delayTime > 0 then task.wait(delayTime) end
			forceApplyActiveEmoteSlots(true)
		end

		refreshRobloxEmoteMenu()
		EmoteReapplyBusy = false
	end)
end

local function startEmoteSlotLockWatcher()
	if EmoteCharacterWatcher then EmoteCharacterWatcher:Disconnect() EmoteCharacterWatcher = nil end
	if EmoteDescriptionWatcher then EmoteDescriptionWatcher:Disconnect() EmoteDescriptionWatcher = nil end

	local char = getCurrentCharacter()
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if hum then
		EmoteDescriptionWatcher = hum.DescendantAdded:Connect(function(obj)
			if obj:IsA("HumanoidDescription") then
				scheduleEmoteSlotLock()
			end
		end)
	end

	EmoteCharacterWatcher = player.CharacterAdded:Connect(function(newCharacter)
		task.wait(0.8)
		local newHumanoid = newCharacter:FindFirstChildOfClass("Humanoid") or newCharacter:WaitForChild("Humanoid", 5)
		if EmoteDescriptionWatcher then EmoteDescriptionWatcher:Disconnect() EmoteDescriptionWatcher = nil end
		if newHumanoid then
			EmoteDescriptionWatcher = newHumanoid.DescendantAdded:Connect(function(obj)
				if obj:IsA("HumanoidDescription") then
					scheduleEmoteSlotLock()
				end
			end)
		end
		scheduleEmoteSlotLock()
	end)

	scheduleEmoteSlotLock()
end

local function applyEmoteSlots()
	local char = getCurrentCharacter()
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local StarterGui = game:GetService("StarterGui")
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
	end)
	task.wait(0.05)
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
	end)

	local emoteTable, emoteOrder, changed = buildMergedEmoteSlots(hum)

	if not changed then
		notifyAvatar("No emote slots changed. Type a name or ID in any slot first.")
        PlayNotifySound()
		return
	end

	if #emoteOrder == 0 then
		notifyAvatar("No emotes to apply.")
        PlayNotifySound()
		return
	end

	ActiveRadiateEmoteTable = emoteTable
	ActiveRadiateEmoteOrder = emoteOrder

	local ok, err = pcall(function()
		local description = hum:GetAppliedDescription()
		description:SetEmotes(emoteTable)
		description:SetEquippedEmotes(emoteOrder)

		local liveDescription = hum:FindFirstChildOfClass("HumanoidDescription") or hum.HumanoidDescription
		if liveDescription then
			liveDescription:SetEmotes(emoteTable)
			liveDescription:SetEquippedEmotes(emoteOrder)
		end

		pcall(function()
			hum:ApplyDescription(description)
		end)

		task.wait(0.1)
		local refreshedDescription = hum:FindFirstChildOfClass("HumanoidDescription") or hum.HumanoidDescription
		if refreshedDescription then
			refreshedDescription:SetEmotes(emoteTable)
			refreshedDescription:SetEquippedEmotes(emoteOrder)
		end

		pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
		end)
		task.wait(0.05)
		pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
		end)
	end)

	if ok then
		startEmoteSlotLockWatcher()
		notifyAvatar("Applied Roblox emote slots without removing your other emotes. Reopen emote wheel if it was already open.")
        PlayNotifySound()
	else
		notifyAvatar("Could not apply emote slots: " .. tostring(err))
        PlayNotifySound()
	end
end

AvatarEmotesGroup:AddInput("PlayEmoteId", {
	Text = "Play Emote / ID",
	Default = "",
	Numeric = false,
	Finished = false,
	ClearTextOnFocus = false,
	Placeholder = "Name or ID",
	Callback = function(Value) end,
})

AvatarEmotesGroup:AddButton({
	Text = "Play Emote",
	Func = function()
		if not ScriptReady then return end
		playEmoteId(Options.PlayEmoteId.Value)
	end
})

AvatarEmotesGroup:AddDivider()

for i, slot in ipairs(emoteSlots) do
	AvatarEmotesGroup:AddInput("Emote_" .. slot, {
		Text = "Emote Slot " .. tostring(i),
		Default = "",
		Numeric = false,
		Finished = false,
		ClearTextOnFocus = false,
		Placeholder = "Name or ID",
		Callback = function(Value) end,
	})
end

task.defer(function()
	task.wait(1)
	hydrateEmoteInputsFromRoblox(false)
end)

AvatarEmotesGroup:AddButton({
	Text = "Load My Roblox Emotes",
	Func = function()
		if not ScriptReady then return end
		cacheCurrentRobloxEmotes(true)
		hydrateEmoteInputsFromRoblox(true)
		notifyAvatar("Loaded your current Roblox emotes into the slots.")
        PlayNotifySound()
	end
})

AvatarEmotesGroup:AddButton({
	Text = "Apply Emote Slots",
	Func = function()
		if not ScriptReady then return end
		applyEmoteSlots()
	end
})

local AnimationPresetValues = { "Cartoony Animation Package", "Ninja Animation Package", "Vampire Animation Pack", "Toy Animation Pack", "Oldschool Animation Pack" }
for name in pairs(MotionaAnimationStorage) do
	if not table.find(AnimationPresetValues, name) then
		table.insert(AnimationPresetValues, name)
	end
end
table.sort(AnimationPresetValues)

AvatarAnimationsGroup:AddDropdown("AnimationPreset", {
	Values = AnimationPresetValues,
	Default = "Cartoony Animation Package",
	Multi = false,
	Text = "Animation Preset",
	Searchable = true,
	Callback = function(Value) end,
})

AvatarAnimationsGroup:AddButton({
	Text = "Apply Preset",
	Func = function()
		if not ScriptReady then return end
		applyAnimationPreset(Options.AnimationPreset.Value)
	end
})

AvatarAnimationsGroup:AddDivider()

for _, slot in ipairs(animationSlots) do
	AvatarAnimationsGroup:AddInput("Anim_" .. slot, {
		Text = slot:gsub("^%l", string.upper),
		Default = "",
		Numeric = false,
		Finished = false,
		ClearTextOnFocus = false,
		Placeholder = "Name or ID",
		Callback = function(Value) end,
	})
end

AvatarAnimationsGroup:AddButton({
	Text = "Apply Custom Animations",
	Func = function()
		if not ScriptReady then return end
		applyAnimationInputs()
	end
})

AvatarAnimationsGroup:AddButton({
	Text = "Reset Animations",
	Func = function()
		if not ScriptReady then return end
		resetAnimations()
	end
})

setupCharacter(player.Character or player.CharacterAdded:Wait(), false)

player.CharacterAdded:Connect(function(newCharacter)
	setupCharacter(newCharacter, true)
end)
