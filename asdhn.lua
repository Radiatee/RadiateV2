local function ApplyHalloweenWorldMode()
	Lighting.FogStart = 0
	Lighting.FogEnd = 500
	Lighting.FogColor = Color3.fromRGB(255, 140, 40)
	Lighting.Ambient = OldLighting.Ambient
	Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient

	EnsureLightingObject(Sky)
	Sky.SkyboxBk = "http://www.roblox.com/asset/?id=458016711"
	Sky.SkyboxDn = "http://www.roblox.com/asset/?id=458016826"
	Sky.SkyboxFt = "http://www.roblox.com/asset/?id=458016532"
	Sky.SkyboxLf = "http://www.roblox.com/asset/?id=458016655"
	Sky.SkyboxRt = "http://www.roblox.com/asset/?id=458016782"
	Sky.SkyboxUp = "http://www.roblox.com/asset/?id=458016792"
	Sky.MoonTextureId = "2"

	getgenv().Txt.Textures.GrassColor = Color3.fromRGB(200, 150, 0)
	ApplyGrassColor(true)
	SyncUIToCurrentWorld()
	SafeSetColor("TextureGrassColor", getgenv().Txt.Textures.GrassColor)
end

local function ApplyChristmasWorldMode()
	Lighting.FogStart = 0
	Lighting.FogEnd = 650
	Lighting.FogColor = Color3.fromRGB(210, 220, 230)
	Lighting.Ambient = Color3.fromRGB(100, 100, 120)
	Lighting.OutdoorAmbient = Color3.fromRGB(120, 130, 150)

	EnsureLightingObject(Atmosphere)
	Atmosphere.Color = Color3.fromRGB(220, 230, 240)
	Atmosphere.Decay = Color3.fromRGB(180, 190, 200)
	Atmosphere.Density = 0.5
	Atmosphere.Glare = 0.05
	Atmosphere.Haze = 1.8

	EnsureLightingObject(Sky)
	Sky.SkyboxBk = "http://www.roblox.com/asset/?id=155657655"
	Sky.SkyboxDn = "http://www.roblox.com/asset/?id=155674246"
	Sky.SkyboxFt = "http://www.roblox.com/asset/?id=155657609"
	Sky.SkyboxLf = "http://www.roblox.com/asset/?id=155657671"
	Sky.SkyboxRt = "http://www.roblox.com/asset/?id=155657619"
	Sky.SkyboxUp = "http://www.roblox.com/asset/?id=155674931"
	Sky.MoonTextureId = "2"

	getgenv().Classic.Textures.Material = "Sand"
	SafeSetValue("ClassicMaterialList", "Sand")
	SetClassicTextureMode(true)
	SyncUIToCurrentWorld()
end

local function UpdateSpecialModes()
	if getgenv().modes.Halloween then
		getgenv().modes.Christmas = false
		do
			local WasReady = ScriptReady
			ScriptReady = false
			SafeSetToggle("ChristmasMode", false)
			ScriptReady = WasReady
		end
		ApplyGameWorldSettings()
		ApplyHalloweenWorldMode()
	elseif getgenv().modes.Christmas then
		getgenv().modes.Halloween = false
		do
			local WasReady = ScriptReady
			ScriptReady = false
			SafeSetToggle("HalloweenMode", false)
			ScriptReady = WasReady
		end
		ApplyGameWorldSettings()
		ApplyChristmasWorldMode()
	else
		ApplyGameWorldSettings()
		SyncUIToGameWorldSettings()
	end
end

ModesGroup:AddToggle("HalloweenMode", {
	Text = "Halloween Mode",
	Default = false,
	Callback = function(Value)
		if not ScriptReady then return end
		getgenv().modes.Halloween = Value
		UpdateSpecialModes()
	end
})

ModesGroup:AddToggle("ChristmasMode", {
	Text = "Christmas Mode",
	Default = false,
	Callback = function(Value)
		if not ScriptReady then return end
		getgenv().modes.Christmas = Value
		UpdateSpecialModes()
	end
})

TexturesGroup:AddToggle("Use2022Materials", {
	Text = "Use2022Materials",
	Default = OriginalUse2022Materials,
	Callback = function(Value)
		if not ScriptReady then return end
		pcall(function()
			MaterialService.Use2022Materials = Value
		end)
	end
})

TexturesGroup:AddDivider()

TexturesGroup:AddToggle("OldStyleTextures", {
	Text = "Old style",
	Default = false,
	Callback = function(Value)
		if not ScriptReady or TextureInternalUpdate then return end
		getgenv().Txt.Textures.Enabled = Value
		ApplyTexturePreset("Old", Value)
	end
})

TexturesGroup:AddToggle("MinecraftTextures", {
	Text = "Minecraft v1",
	Default = false,
	Callback = function(Value)
		if not ScriptReady or TextureInternalUpdate then return end
		getgenv().Minecraft.Textures.Enabled = Value
		ApplyTexturePreset("Minecraft", Value)
	end
})

TexturesGroup:AddToggle("BloodTextures", {
	Text = "Blood mode",
	Default = false,
	Callback = function(Value)
		if not ScriptReady or TextureInternalUpdate then return end
		getgenv().Blood.Textures.Enabled = Value
		ApplyTexturePreset("Blood", Value)
		ApplyBloodSkybox(Value)
	end
})

TexturesGroup:AddDivider()

TexturesGroup:AddToggle("ClassicMaterials", {
	Text = "Classic Materials",
	Default = false,
	Callback = function(Value)
		if not ScriptReady or TextureInternalUpdate then return end
		getgenv().Classic.Textures.Enabled = Value
		SetClassicTextureMode(Value)
	end
})

TexturesGroup:AddDropdown("ClassicMaterialList", {
	Values = MaterialValues,
	Default = getgenv().Classic.Textures.Material or "Brick",
	Multi = false,
	Text = "Material",
	Searchable = true,
	Callback = function(Value)
		if not ScriptReady then return end
		if Enum.Material[Value] then
			getgenv().Classic.Textures.Material = Value
			if getgenv().Classic.Textures.Enabled then
				SetClassicTextureMode(true)
			end
		end
	end,
})

TexturesGroup:AddSlider("TextureTileSize", {
	Text = "Tile Size",
	Default = 5,
	Min = 1,
	Max = 25,
	Rounding = 0,
	Callback = function(Value)
		getgenv().Txt.Textures.TileSize = Value
		getgenv().Minecraft.Textures.TileSize = Value
		getgenv().Blood.Textures.TileSize = Value
		if ScriptReady then
			if getgenv().Txt.Textures.Enabled then ApplyTexturePreset("Old", true) end
			if getgenv().Minecraft.Textures.Enabled then ApplyTexturePreset("Minecraft", true) end
			if getgenv().Blood.Textures.Enabled then ApplyTexturePreset("Blood", true) end
		end
	end
})

TexturesGroup:AddSlider("TextureLoadDelay", {
	Text = "Load Delay",
	Default = getgenv().RadiateTextureLoadDelay,
	Min = 0,
	Max = 0.1,
	Rounding = 3,
	Callback = function(Value)
		getgenv().RadiateTextureLoadDelay = Value
	end
})

TexturesGroup:AddDivider()

TexturesGroup:AddToggle("TextureGrassToggle", {
	Text = "Custom Grass Color",
	Default = false,
	Callback = function(Value)
		if not ScriptReady then return end
		getgenv().Txt.Textures.GrassEnabled = Value
		ApplyGrassColor(Value)
	end
})

TexturesGroup:AddLabel("Grass Color"):AddColorPicker("TextureGrassColor", {
	Default = getgenv().Txt.Textures.GrassColor,
	Title = "Grass Color",
	Callback = function(Value)
		getgenv().Txt.Textures.GrassColor = Value
		if ScriptReady and getgenv().Txt.Textures.GrassEnabled then
			ApplyGrassColor(true)
		end
	end
})



MaterialRemapGroup:AddToggle("MaterialRemapperEnabled", {
	Text = "Enable Material Remapper",
	Default = false,
	Callback = function(Value)
		if not ScriptReady then return end
		MaterialRemapEnabled = Value
		ApplyMaterialRemap()
	end
})

MaterialRemapGroup:AddButton({
	Text = "Apply Material Remap",
	Func = function()
		if not ScriptReady then return end
		MaterialRemapEnabled = true
		SafeSetToggle("MaterialRemapperEnabled", true)
		ApplyMaterialRemap()
	end
})

MaterialRemapGroup:AddButton({
	Text = "Reset Material Remap",
	Func = function()
		if not ScriptReady then return end
		MaterialRemapEnabled = false
		SafeSetToggle("MaterialRemapperEnabled", false)
		ResetMaterialRemap()
	end
})

MaterialRemapGroup:AddDivider()

for _, SourceName in ipairs(MaterialRemapSources) do
	MaterialRemapGroup:AddDropdown("Remap_" .. SourceName, {
		Values = MaterialRemapValues,
		Default = DefaultMaterialRemap[SourceName] or "Keep",
		Multi = false,
		Text = SourceName .. " Material",
		Searchable = true,
		Callback = function(Value)
			if not ScriptReady then return end
			if MaterialRemapEnabled then
				ApplyMaterialRemap()
			end
		end,
	})
end

MaterialRemapGroup:AddLabel("Example: Grass Material = Rock makes every Grass part become Rock. Rock = Snow and Sand = Cobblestone work the same.", true)

local function SyncUIToGameWorldSettings()
	local WasReady = ScriptReady
	ScriptReady = false

	SafeSetToggle("Fullbright", false)
	SafeSetValue("Brightness", OldLighting.Brightness)
	SafeSetValue("ClockTime", OldLighting.ClockTime)
	SafeSetValue("TimeOfDayInput", OldLighting.TimeOfDay)
	SafeSetValue("ExposureCompensation", OldLighting.ExposureCompensation)
	SafeSetValue("EnvironmentDiffuseScale", OldLighting.EnvironmentDiffuseScale)
	SafeSetValue("EnvironmentSpecularScale", OldLighting.EnvironmentSpecularScale)
	SafeSetValue("GeographicLatitude", OldLighting.GeographicLatitude)
	SafeSetToggle("GlobalShadows", OldLighting.GlobalShadows)
	SafeSetValue("Technology", tostring(OldLighting.Technology):gsub("Enum.Technology.", ""))

	SafeSetColor("AmbientColor", OldLighting.Ambient)
	SafeSetColor("OutdoorAmbientColor", OldLighting.OutdoorAmbient)
	SafeSetColor("ColorShiftTopColor", OldLighting.ColorShift_Top)
	SafeSetColor("ColorShiftBottomColor", OldLighting.ColorShift_Bottom)

	FogEnabled = OriginalWorld.FogEnabled
	AtmosphereEnabled = OriginalWorld.AtmosphereEnabled
	SavedFog.FogStart = OldLighting.FogStart
	SavedFog.FogEnd = OldLighting.FogEnd
	SavedFog.FogColor = OldLighting.FogColor
	for i, v in pairs(OriginalWorld.Atmosphere) do SavedAtmosphere[i] = v end

	SafeSetToggle("FogEnabled", OriginalWorld.FogEnabled)
	SafeSetValue("FogStart", OldLighting.FogStart)
	SafeSetValue("FogEnd", OldLighting.FogEnd)
	SafeSetColor("FogColor", OldLighting.FogColor)

	SafeSetToggle("AtmosphereEnabled", OriginalWorld.AtmosphereEnabled)
	SafeSetValue("AtmosphereDensity", OriginalWorld.Atmosphere.Density)
	SafeSetValue("AtmosphereOffset", OriginalWorld.Atmosphere.Offset)
	SafeSetValue("AtmosphereGlare", OriginalWorld.Atmosphere.Glare)
	SafeSetValue("AtmosphereHaze", OriginalWorld.Atmosphere.Haze)
	SafeSetColor("AtmosphereColor", OriginalWorld.Atmosphere.Color)
	SafeSetColor("AtmosphereDecay", OriginalWorld.Atmosphere.Decay)

	SafeSetToggle("BloomEnabled", OriginalWorld.Bloom.Enabled)
	SafeSetValue("BloomIntensity", OriginalWorld.Bloom.Intensity)
	SafeSetValue("BloomSize", OriginalWorld.Bloom.Size)
	SafeSetValue("BloomThreshold", OriginalWorld.Bloom.Threshold)

	SafeSetToggle("BlurEnabled", OriginalWorld.Blur.Enabled)
	SafeSetValue("BlurSize", OriginalWorld.Blur.Size)

	SafeSetToggle("ColorCorrectionEnabled", OriginalWorld.ColorCorrection.Enabled)
	SafeSetValue("CCBrightness", OriginalWorld.ColorCorrection.Brightness)
	SafeSetValue("CCContrast", OriginalWorld.ColorCorrection.Contrast)
	SafeSetValue("CCSaturation", OriginalWorld.ColorCorrection.Saturation)
	SafeSetColor("TintColor", OriginalWorld.ColorCorrection.TintColor)

	SafeSetToggle("DOFEnabled", OriginalWorld.DepthOfField.Enabled)
	SafeSetValue("DOFFarIntensity", OriginalWorld.DepthOfField.FarIntensity)
	SafeSetValue("DOFNearIntensity", OriginalWorld.DepthOfField.NearIntensity)
	SafeSetValue("DOFFocusDistance", OriginalWorld.DepthOfField.FocusDistance)
	SafeSetValue("DOFInFocusRadius", OriginalWorld.DepthOfField.InFocusRadius)

	SafeSetToggle("SunRaysEnabled", OriginalWorld.SunRays.Enabled)
	SafeSetValue("SunRaysIntensity", OriginalWorld.SunRays.Intensity)
	SafeSetValue("SunRaysSpread", OriginalWorld.SunRays.Spread)

	SafeSetToggle("CelestialBodiesShown", OriginalWorld.Sky.CelestialBodiesShown)
	SafeSetValue("SunAngularSize", OriginalWorld.Sky.SunAngularSize)
	SafeSetValue("MoonAngularSize", OriginalWorld.Sky.MoonAngularSize)
	SafeSetValue("StarCount", OriginalWorld.Sky.StarCount)
	SafeSetValue("SkyboxBk", OriginalWorld.Sky.SkyboxBk)
	SafeSetValue("SkyboxDn", OriginalWorld.Sky.SkyboxDn)
	SafeSetValue("SkyboxFt", OriginalWorld.Sky.SkyboxFt)
	SafeSetValue("SkyboxLf", OriginalWorld.Sky.SkyboxLf)
	SafeSetValue("SkyboxRt", OriginalWorld.Sky.SkyboxRt)
	SafeSetValue("SkyboxUp", OriginalWorld.Sky.SkyboxUp)

	if OriginalWorld.Clouds then
		SafeSetToggle("CloudsEnabled", OriginalWorld.Clouds.Enabled)
		SafeSetValue("CloudsCover", OriginalWorld.Clouds.Cover)
		SafeSetValue("CloudsDensity", OriginalWorld.Clouds.Density)
		SafeSetColor("CloudsColor", OriginalWorld.Clouds.Color)
	end

	SafeSetValue("CameraFOV", OriginalWorld.CameraFOV)
	SafeSetToggle("Snow", false)
	SafeSetToggle("Rain", false)
	SafeSetToggle("Use2022Materials", OriginalUse2022Materials)
	SafeSetToggle("MaterialRemapperEnabled", false)
	pcall(function()
		MaterialService.Use2022Materials = OriginalUse2022Materials
	end)
	MaterialRemapEnabled = false
	ResetMaterialRemap()

	ScriptReady = WasReady
end


SkyGroup:AddButton({
	Text = "Reset To Game World Settings",
	Func = function()
		if not ScriptReady then return end
		ApplyGameWorldSettings()
		SyncUIToGameWorldSettings()
	end
})

-- // UI SETTINGS

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = false,
	Text = "Open Keybind Menu",
	Callback = function(value)
		if not ScriptReady then return end
		Library.KeybindFrame.Visible = value
	end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		if not ScriptReady then return end
		Library.ShowCustomCursor = Value
	end,
})

MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",
	Text = "Notification Side",
	Callback = function(Value)
		if not ScriptReady then return end
		Library:SetNotifySide(Value)
	end,
})

MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",
	Text = "DPI Scale",
	Callback = function(Value)
		if not ScriptReady then return end
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)
		Library:SetDPIScale(DPI)
	end,
})

MenuGroup:AddSlider("UICornerSlider", {
	Text = "Corner Radius",
	Default = Library.CornerRadius,
	Min = 0,
	Max = 20,
	Rounding = 0,
	Callback = function(value)
		if not ScriptReady then return end
		Window:SetCornerRadius(value)
	end
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", {
		Default = "RightShift",
		NoUI = true,
		Text = "Menu keybind"
	})

MenuGroup:AddButton({
	Text = "Unload",
	Func = function()
		Library:Unload()
	end
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()

if Options.SavedAccessoryIds and Options.SavedAccessoryIds.Value ~= "" then
	for id in tostring(Options.SavedAccessoryIds.Value):gmatch("%d+") do
		table.insert(accessoryIds, tonumber(id))
	end

	task.spawn(function()
		task.wait(1)

		for _, id in ipairs(accessoryIds) do
			addAccessory(id, true)
			task.wait(0.15)
		end

		refreshAccessoryDropdown()
	end)
end

ApplyGameWorldSettings()
SyncUIToGameWorldSettings()
ScriptReady = true
