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
