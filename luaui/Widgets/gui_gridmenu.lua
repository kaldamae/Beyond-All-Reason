--
-- Actions exposed:
--
-- bind z gridmenu_key 1 1 <-- Sets the first grid key, useful for german keyboard layout. Unnecessary if using the Bar Swap Y Z widget
-- bind alt+x gridmenu_next_page <-- Go to next page
-- bind alt+z gridmenu_prev_page <-- Go to previous page
function widget:GetInfo()
	return {
		name = "Grid menu",
		desc = "Build menu with grid hotkeys",
		author = "Floris, grid by badosu and resopmok",
		date = "October 2021",
		license = "GNU GPL, v2 or later",
		layer = 0,
		enabled = false,
		handler = true,
	}
end

include("keysym.h.lua")
VFS.Include('luarules/configs/customcmds.h.lua')

SYMKEYS = table.invert(KEYSYMS)

local configs = VFS.Include('luaui/configs/gridmenu_layouts.lua')
local keyConfig = VFS.Include("luaui/configs/keyboard_layouts.lua")
local labGrids = configs.LabGrids
local unitGrids = configs.UnitGrids
local currentLayout = Spring.GetConfigString("KeyboardLayout", "qwerty")

local prevHoveredCellID, hoverDlist, hoverUdefID, hoverCellSelected
local prevQueueNr, prevB, prevB3

local cachedUnitIcons

local BUILDCAT_ECONOMY = "Economy"
local BUILDCAT_COMBAT = "Combat"
local BUILDCAT_UTILITY = "Utility"
local BUILDCAT_PRODUCTION = "Production"
local categoryFontSize, pageButtonHeight, pageButtonWidth, paginatorCellWidth
local paginatorFontSize, paginatorCellHeight

local Cfgs = {
	NEXT_PAGE_KEY = "SC_B",
	PREV_PAGE_KEY = "SC_N",
	qwerty = {
		[3] = {
			[1]  = "SC_Q",
			[2]  = "SC_W",
			[3]  = "SC_E",
			[4]  = "SC_R",
		},
		[2] = {
			[1] = "SC_A",
			[2] = "SC_S",
			[3] = "SC_D",
			[4] = "SC_F",
		},
		[1] = {
			[1] = "SC_Z",
			[2] = "SC_X",
			[3] = "SC_C",
			[4] = "SC_V",
		}
	},
	disableInputWhenSpec = false, -- disable specs selecting buildoptions
	cfgCellPadding = 0.007,
	cfgIconPadding = 0.015, -- space between icons
	cfgIconCornerSize = 0.025,
	cfgRadariconSize = 0.23,
	cfgRadariconOffset = 0.025,
	cfgGroupiconSize = 0.29,
	cfgPriceFontSize = 0.19,
	cfgCategoryFontSize = 0.19,
	cfgActiveAreaMargin = 0.1, -- (# * bgpadding) space between the background border and active area
	maxPosY = 0.74,
	sound_queue_add = 'LuaUI/Sounds/buildbar_add.wav',
	sound_queue_rem = 'LuaUI/Sounds/buildbar_rem.wav',
	fontFile = "fonts/" .. Spring.GetConfigString("bar_font2", "Exo2-SemiBold.otf"),
	categoryTooltips = {
		[BUILDCAT_ECONOMY] = "Filter economy buildings",
		[BUILDCAT_COMBAT] = "Filter combat buildings",
		[BUILDCAT_UTILITY] = "Filter utility buildings",
		[BUILDCAT_PRODUCTION] = "Filter production buildings",
	},
	buildCategories = {
		BUILDCAT_ECONOMY,
		BUILDCAT_COMBAT,
		BUILDCAT_UTILITY,
		BUILDCAT_PRODUCTION
	},
	categoryKeys = {},
	vKeyLayout = {},
	keyLayout = {},
	categoryGroupMapping = {
		energy = BUILDCAT_ECONOMY,
		metal = BUILDCAT_ECONOMY,
		builder = BUILDCAT_PRODUCTION,
		buildert2 = BUILDCAT_PRODUCTION,
		buildert3 = BUILDCAT_PRODUCTION,
		buildert4 = BUILDCAT_PRODUCTION,
		util = BUILDCAT_UTILITY,
		weapon = BUILDCAT_COMBAT,
		explo = BUILDCAT_COMBAT,
		weaponaa = BUILDCAT_COMBAT,
		aa = BUILDCAT_COMBAT,
		emp = BUILDCAT_COMBAT,
		sub = BUILDCAT_COMBAT,
		nuke = BUILDCAT_COMBAT,
		antinuke = BUILDCAT_COMBAT,
	},
	armToCor = {
		[UnitDefNames["armmex"].id] = UnitDefNames["cormex"].id,
		[UnitDefNames["armuwmex"].id] = UnitDefNames["coruwmex"].id,
		[UnitDefNames["armsolar"].id] = UnitDefNames["corsolar"].id,
		[UnitDefNames["armwin"].id] = UnitDefNames["corwin"].id,
		[UnitDefNames["armtide"].id] = UnitDefNames["cortide"].id,
		[UnitDefNames["armllt"].id] = UnitDefNames["corllt"].id,
		[UnitDefNames["armrad"].id] = UnitDefNames["corrad"].id,
		[UnitDefNames["armrl"].id] = UnitDefNames["corrl"].id,
		[UnitDefNames["armtl"].id] = UnitDefNames["cortl"].id,
		[UnitDefNames["armsonar"].id] = UnitDefNames["corsonar"].id,
		[UnitDefNames["armfrt"].id] = UnitDefNames["corfrt"].id,
		[UnitDefNames["armlab"].id] = UnitDefNames["corlab"].id,
		[UnitDefNames["armvp"].id] = UnitDefNames["corvp"].id,
		[UnitDefNames["armsy"].id] = UnitDefNames["corsy"].id,
		[UnitDefNames["armmstor"].id] = UnitDefNames["cormstor"].id,
		[UnitDefNames["armestor"].id] = UnitDefNames["corestor"].id,
		[UnitDefNames["armmakr"].id] = UnitDefNames["cormakr"].id,
		[UnitDefNames["armeyes"].id] = UnitDefNames["coreyes"].id,
		[UnitDefNames["armdrag"].id] = UnitDefNames["cordrag"].id,
		[UnitDefNames["armdl"].id] = UnitDefNames["cordl"].id,
		[UnitDefNames["armap"].id] = UnitDefNames["corap"].id,
		[UnitDefNames["armfrad"].id] = UnitDefNames["corfrad"].id,
		[UnitDefNames["armuwms"].id] = UnitDefNames["coruwms"].id,
		[UnitDefNames["armuwes"].id] = UnitDefNames["coruwes"].id,
		[UnitDefNames["armfmkr"].id] = UnitDefNames["corfmkr"].id,
		[UnitDefNames["armfdrag"].id] = UnitDefNames["corfdrag"].id,
		[UnitDefNames["armptl"].id] = UnitDefNames["corptl"].id,
	},
}

Cfgs.corToArm = table.invert(Cfgs.armToCor)

local unitCategories = {}
local hotkeyActions = {}
local hoveredCat, drawnHoveredCat
local selBuildQueueDefID

local stickToBottom = false
local alwaysShow = false

local showPrice = false		-- false will still show hover
local showRadarIcon = true		-- false will still show hover
local showGroupIcon = true		-- false will still show hover
local showBuildProgress = true

local activeCmd
local priceFontSize

local zoomMult = 1.5
local defaultCellZoom = 0.025 * zoomMult
local rightclickCellZoom = 0.033 * zoomMult
local clickCellZoom = 0.07 * zoomMult
local hoverCellZoom = 0.05 * zoomMult
local clickSelectedCellZoom = 0.125 * zoomMult
local selectedCellZoom = 0.135 * zoomMult

local bgpadding, chobbyInterface, activeAreaMargin, iconTypesMap
local dlistGuishader, dlistBuildmenuBg, dlistBuildmenu, font2, cmdsCount
local doUpdate, doUpdateClock, ordermenuHeight, prevAdvplayerlistLeft
local cellPadding, iconPadding, cornerSize, cellInnerSize, cellSize

local selectedBuilder, selectedFactory, selectedFactoryUID

local facingMap = {south=0, east=1, north=2, west=3}

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local unbaStartBuildoptions = {}
if Spring.GetModOptions().unba then
	VFS.Include("unbaconfigs/buildoptions.lua")
	for unitname,level in pairs(ArmBuildOptions) do
		if level == 1 then
			unbaStartBuildoptions[UnitDefNames[unitname].id] = unitname
		end
	end
	ArmBuildOptions = nil
	for unitname,level in pairs(CorBuildOptions) do
		if level == 1 then
			unbaStartBuildoptions[UnitDefNames[unitname].id] = unitname
		end
	end
	CorBuildOptions = nil
	ArmDefsBuildOptions = nil
	CorDefsBuildOptions = nil
	ArmBuildOptionsStop = nil
	CorBuildOptionsStop = nil
else
	unbaStartBuildoptions = nil
end

local vsx, vsy = Spring.GetViewGeometry()

local ordermenuLeft = vsx / 5
local advplayerlistLeft = vsx * 0.8

local isSpec = Spring.GetSpectatingState()
local myTeamID = Spring.GetMyTeamID()

local startDefID = Spring.GetTeamRulesParam(myTeamID, 'startUnit')

local buildQueue = {}
local disableInput = Cfgs.disableInputWhenSpec and isSpec
local backgroundRect = { 0, 0, 0, 0 }
local colls = 4
local rows = 3
local minimapHeight = 0.235
local posY = 0
local posY2 = 0
local posX = 0
local posX2 = 0.2
local width = 0
local height = 0
local selectedBuilders = {}
local cellRects = {}
local cmds = {}
local cellcmds = {}
local uidcmds = {}
local uidcmdsCount
local categories = {}
local catRects = {}
local currentBuildCategory, currentCategoryIndex
local currentPage = 1
local pages = 1
local paginatorRects = {}
local preGamestartPlayer = Spring.GetGameFrame() == 0 and not isSpec
local unitshapes = {}

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local spGetCmdDescIndex = Spring.GetCmdDescIndex
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitHealth = Spring.GetUnitHealth
local spGetUnitIsBuilding = Spring.GetUnitIsBuilding
local SelectedUnitsCount = Spring.GetSelectedUnitsCount()

local math_floor = math.floor
local math_ceil = math.ceil
local math_max = math.max
local math_min = math.min
local math_isInRect = math.isInRect

local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_ONE = GL.ONE
local GL_ONE_MINUS_SRC_COLOR = GL.ONE_MINUS_SRC_COLOR

-- Get from FlowUI
local RectRound, RectRoundProgress, UiUnit, UiElement, UiButton, elementCorner
local ui_opacity, ui_scale

local folder = 'LuaUI/Images/groupicons/'
local groups = {
	energy = folder..'energy.png',
	metal = folder..'metal.png',
	builder = folder..'builder.png',
	buildert2 = folder..'buildert2.png',
	buildert3 = folder..'buildert3.png',
	buildert4 = folder..'buildert4.png',
	util = folder..'util.png',
	weapon = folder..'weapon.png',
	explo = folder..'weaponexplo.png',
	weaponaa = folder..'weaponaa.png',
	aa = folder..'aa.png',
	emp = folder..'emp.png',
	sub = folder..'sub.png',
	nuke = folder..'nuke.png',
	antinuke = folder..'antinuke.png',
}

local unitEnergyCost = {}
local unitMetalCost = {}
local unitGroup = {}
local unitRestricted = {}
local isBuilder = {}
local isFactory = {}
local unitIconType = {}
local isMex = {}
local isWaterUnit = {}
local unitMaxWeaponRange = {}

local unitGridPos = { }
local gridPosUnit = { }
local hasUnitGrid = { }
local selectNextFrame, switchedCategory

for uname, ugrid in pairs(unitGrids) do
	local udef = UnitDefNames[uname]
	local uid = udef.id

	unitGridPos[uid] = {{},{},{},{}}
	gridPosUnit[uid] = {}
	hasUnitGrid[uid] = {}
	local uCanBuild = {}

	local uBuilds = udef.buildOptions
	for i = 1, #uBuilds do
		uCanBuild[uBuilds[i]] = true
	end

	for cat=1,4 do
		for r=1,3 do
			for c=1,4 do
				local ugdefname = ugrid[cat] and ugrid[cat][r] and ugrid[cat][r][c]

				if ugdefname then
					local ugdef = UnitDefNames[ugdefname]

					if ugdef and ugdef.id and uCanBuild[ugdef.id] then
						gridPosUnit[uid][cat .. r .. c] = ugdef.id
						unitGridPos[uid][cat][ugdef.id] = cat .. r .. c
						hasUnitGrid[uid][ugdef.id] = true
					end
				end
			end
		end
	end
end

for uname, ugrid in pairs(labGrids) do
	local udef = UnitDefNames[uname]
	local uid = udef.id

	unitGridPos[uid] = {}
	gridPosUnit[uid] = {}
	local uCanBuild = {}

	local uBuilds = udef.buildOptions
	for i = 1, #uBuilds do
		uCanBuild[uBuilds[i]] = true
	end

	for r=1,3 do
		for c=1,4 do
			local index = (r - 1) * 4 + c
			local ugdefname = ugrid[index]

			if ugdefname then
				local ugdef = UnitDefNames[ugdefname]

				if ugdef and ugdef.id and uCanBuild[ugdef.id] then
					gridPosUnit[uid][r .. c] = ugdef.id
					unitGridPos[uid][ugdef.id] = r .. c
				end
			end
		end
	end
end

for unitDefID, unitDef in pairs(UnitDefs) do
	unitGroup[unitDefID] = unitDef.customParams.unitgroup
	unitCategories[unitDefID] = Cfgs.categoryGroupMapping[unitDef.customParams.unitgroup] or BUILDCAT_UTILITY

	if unitDef.name == 'armdl' or unitDef.name == 'cordl' or unitDef.name == 'armlance' or unitDef.name == 'cortitan'	-- or unitDef.name == 'armbeaver' or unitDef.name == 'cormuskrat'
		or (unitDef.minWaterDepth > 0 or unitDef.modCategories['ship']) then
		isWaterUnit[unitDefID] = true
	end
	if unitDef.name == 'armthovr' or unitDef.name == 'corintr' then
		isWaterUnit[unitDefID] = nil
	end

	if unitDef.maxWeaponRange > 16 then
		unitMaxWeaponRange[unitDefID] = unitDef.maxWeaponRange
	end

	unitIconType[unitDefID] = unitDef.iconType
	unitEnergyCost[unitDefID] = unitDef.energyCost
	unitMetalCost[unitDefID] = unitDef.metalCost

	if unitDef.maxThisUnit == 0 then
		unitRestricted[unitDefID] = true
	end

	if unitDef.buildSpeed > 0 and unitDef.buildOptions[1] then
		isBuilder[unitDefID] = unitDef.buildOptions
	end

	if unitDef.isFactory and #unitDef.buildOptions > 0 then
		isFactory[unitDefID] = true
	end

	if unitDef.extractsMetal > 0 then
		isMex[unitDefID] = true
	end
end

------------------------------------
-- UNIT ORDER ----------------------
------------------------------------

local unitOrder = {}
local unitOrderManualOverrideTable = VFS.Include("luaui/configs/buildmenu_sorting.lua")

for unitDefID, _ in pairs(UnitDefs) do
	if unitOrderManualOverrideTable[unitDefID] then
		unitOrder[unitDefID] = -unitOrderManualOverrideTable[unitDefID]
	else
		unitOrder[unitDefID] = 9999999
	end
end

local function getHighestOrderedUnit()
	local highest = { 0, 0, false }
	local firstOrderTest = true
	local newSortingUnit = {}
	for unitDefID, orderValue in pairs(unitOrder) do

		if unitOrderManualOverrideTable[unitDefID] then
			newSortingUnit[unitDefID] = true
		else
			newSortingUnit[unitDefID] = false
		end

		if firstOrderTest == true then
			firstOrderTest = false
			highest = { unitDefID, orderValue, newSortingUnit[unitDefID]}
		--elseif orderValue > highest[2] then
		elseif highest[3] == false and newSortingUnit[unitDefID] == true then
			highest = { unitDefID, orderValue, newSortingUnit[unitDefID]}
		elseif highest[3] == false and newSortingUnit[unitDefID] == false then
			if orderValue > highest[2] then
				highest = { unitDefID, orderValue, newSortingUnit[unitDefID]}
			end
		elseif highest[3] == true and newSortingUnit[unitDefID] == true then
			if orderValue > highest[2] then
				highest = { unitDefID, orderValue, newSortingUnit[unitDefID]}
			end
		end
	end
	return highest[1]
end

local unitsOrdered = {}
for _, _ in pairs(UnitDefs) do
	local uDefID = getHighestOrderedUnit()
	unitsOrdered[#unitsOrdered + 1] = uDefID
	unitOrder[uDefID] = nil
end

unitOrder = unitsOrdered
unitsOrdered = nil

local voidWater = false
local success, mapinfo = pcall(VFS.Include,"mapinfo.lua") -- load mapinfo.lua confs
if success and mapinfo then
	voidWater = mapinfo.voidwater
end

local minWaterUnitDepth = -11
local showWaterUnits = false

------------------------------------
-- /UNIT ORDER ----------------------
------------------------------------


local function checkGuishader(force)
	if WG['guishader'] then
		if force and dlistGuishader then
			dlistGuishader = gl.DeleteList(dlistGuishader)
		end
		if not dlistGuishader then
			dlistGuishader = gl.CreateList(function()
				RectRound(backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4], elementCorner)
			end)
			if selectedBuilder or selectedFactory then
				WG['guishader'].InsertDlist(dlistGuishader, 'buildmenu')
			end
		end
	elseif dlistGuishader then
		dlistGuishader = gl.DeleteList(dlistGuishader)
	end
end

function widget:PlayerChanged()
	isSpec = Spring.GetSpectatingState()
	myTeamID = Spring.GetMyTeamID()
end

local function RefreshCommands()
	local gridPos, lHasUnitGrid

	if preGamestartPlayer and startDefID then
		selectedBuilder = startDefID
	end

	if currentBuildCategory then
		gridPos = unitGridPos[selectedBuilder] and unitGridPos[selectedBuilder][currentCategoryIndex]
		lHasUnitGrid = hasUnitGrid[selectedBuilder] -- Ensure if unit has static grid to not repeat unit on different category
	elseif selectedFactory then
		gridPos = unitGridPos[selectedFactory]
	end

	cmds = {}
	uidcmds = {}
	cmdsCount = 0
	uidcmdsCount = 0

	local unorderedCmdDefs = {}

	if preGamestartPlayer then
		if startDefID then
			categories = Cfgs.buildCategories

			for _, udefid in pairs(UnitDefs[startDefID].buildOptions) do
				if not unbaStartBuildoptions or unbaStartBuildoptions[udefid] then
					if showWaterUnits or not isWaterUnit[udefid] then
						if gridPos and gridPos[udefid] then
							uidcmdsCount = uidcmdsCount + 1
							uidcmds[udefid] = {
								id = udefid * -1,
								name = UnitDefs[udefid].name,
								params = {}
							}
						elseif currentBuildCategory == nil or (unitCategories[udefid] == currentBuildCategory and not (lHasUnitGrid and lHasUnitGrid[udefid])) then
							local cmd = {
								id = udefid * -1,
								name = UnitDefs[udefid].name,
								params = {}
							}

							uidcmdsCount = uidcmdsCount + 1
							uidcmds[udefid] = cmd

							unorderedCmdDefs[udefid] = true
						end
					end
				end
			end

			for _, uDefID in pairs(unitOrder) do
				if unorderedCmdDefs[uDefID] then
					cmdsCount = cmdsCount + 1
					cmds[cmdsCount] = uidcmds[uDefID]
				end
			end
		end
	else
		local activeCmdDescs = selectedFactory and Spring.GetUnitCmdDescs(selectedFactoryUID) or Spring.GetActiveCmdDescs()

		local cmdUnitdefs = {}

		for index, cmd in pairs(activeCmdDescs) do
			if type(cmd) == "table" and not cmd.disabled then
				if string.sub(cmd.action, 1, 10) == 'buildunit_' and (showWaterUnits or not isWaterUnit[cmd.id * -1]) then
					cmdUnitdefs[cmd.id * -1] = index

					if gridPos and gridPos[cmd.id * -1] then
						uidcmdsCount = uidcmdsCount + 1
						uidcmds[cmd.id * -1] = activeCmdDescs[index]
					elseif currentBuildCategory == nil or (unitCategories[cmd.id * -1] == currentBuildCategory and not (lHasUnitGrid and lHasUnitGrid[cmd.id * -1])) then
						uidcmdsCount = uidcmdsCount + 1
						uidcmds[cmd.id * -1] = activeCmdDescs[index]

						unorderedCmdDefs[cmd.id * -1] = true
					end
				end
			end
		end

		for _, uDefID in pairs(unitOrder) do
			if unorderedCmdDefs[uDefID] then
				cmdsCount = cmdsCount + 1
				cmds[cmdsCount] = activeCmdDescs[cmdUnitdefs[uDefID]]
			end
		end
	end
end

local function clear()
	dlistBuildmenu = gl.DeleteList(dlistBuildmenu)
	dlistBuildmenuBg = gl.DeleteList(dlistBuildmenuBg)
end

function widget:ViewResize()
	local widgetSpaceMargin = WG.FlowUI.elementMargin
	bgpadding = WG.FlowUI.elementPadding
	elementCorner = WG.FlowUI.elementCorner

	RectRound = WG.FlowUI.Draw.RectRound
	RectRoundProgress = WG.FlowUI.Draw.RectRoundProgress
	UiUnit = WG.FlowUI.Draw.Unit
	UiElement = WG.FlowUI.Draw.Element
	UiButton = WG.FlowUI.Draw.Button
	elementCorner = WG.FlowUI.elementCorner
	categoryFontSize = 0.0115 * ui_scale * vsy
	pageButtonHeight = 2.3 * categoryFontSize * ui_scale
	pageButtonWidth = 7 * categoryFontSize * ui_scale
	if stickToBottom then
		paginatorFontSize = categoryFontSize
	else
		paginatorFontSize = categoryFontSize * 1.2
	end
	paginatorCellWidth = paginatorFontSize * 2
	paginatorCellHeight = 3 * paginatorFontSize

	activeAreaMargin = math_ceil(bgpadding * Cfgs.cfgActiveAreaMargin)

	vsx, vsy = Spring.GetViewGeometry()

	font2 = WG['fonts'].getFont(Cfgs.fontFile, 1.2, 0.28, 1.6)

	if WG['minimap'] then
		minimapHeight = WG['minimap'].getHeight()
	end

	if stickToBottom then
		posY = math_floor(0.14 * ui_scale * vsy) / vsy
		posY2 = 0
		posX = math_floor(ordermenuLeft*vsx) + widgetSpaceMargin
		posX2 = math_floor(posX + posY * vsy * 3) + paginatorCellWidth + pageButtonWidth
		width = posX2 - posX
		height = posY

		backgroundRect = { posX, (posY - height) * vsy, posX2, posY * vsy }
	else
		width = 0.212
		width = width / (vsx / vsy) * 1.78				-- make smaller for ultrawide screens
		width = width * ui_scale

		posY2 = math_floor(0.14 * ui_scale * vsy) / vsy
		posY2 = posY2 + (widgetSpaceMargin/vsy)
		posY = posY2 + (0.74 * width * vsx + pageButtonHeight + paginatorCellWidth)/vsy
		posX = 0

		if WG['ordermenu'] and not WG['ordermenu'].getBottomPosition() then
			local _, oposY, _, oheight = WG['ordermenu'].getPosition()
			if posY > oposY then
				posY = oposY - oheight - ((widgetSpaceMargin)/vsy)
			end
		end

		posY = math_floor(posY * vsy) / vsy
		posX = math_floor(posX * vsx) / vsx

		height = (posY - posY2)

		posX2 = math_floor(width * vsx)

		-- make pixel aligned
		width = math_floor(width * vsx) / vsx
		height = math_floor(height * vsy) / vsy

		backgroundRect = { posX, (posY - height) * vsy, posX2, posY * vsy }
	end

	checkGuishader(true)
	clear()
	doUpdate = true
end

local function getActionHotkey(action)
	local key
	for _, keybinding in pairs(Spring.GetActionHotKeys(action)) do
		if (not key) or keybinding:len() < key:len() then
			key = keybinding
		end

		if key:len() == 1 then break end
	end

	return key
end

local function reloadBindings()
	currentLayout = Spring.GetConfigString("KeyboardLayout", 'qwerty')

	Cfgs.keyLayout = {{}, {}, {}}

	for c=1,4 do
		local cKey = getActionHotkey('gridmenu_category ' .. c)

		if not cKey then
			cKey = Cfgs.qwerty[1][c]
			Spring.SendCommands("bind " .. cKey .. " gridmenu_category " .. c)
			Spring.SendCommands("bind Shift+" .. cKey .. " gridmenu_category " .. c)
		end

		Cfgs.categoryKeys[c] = cKey

		for r=1,3 do
			local key = getActionHotkey('gridmenu_key ' .. r .. ' ' .. c)

			if not key then
				key = Cfgs.qwerty[r][c]
				Spring.SendCommands("bind Any+" .. key .. ' gridmenu_key ' .. r .. ' ' .. c)
			end

			Cfgs.keyLayout[r][c] = key
		end
	end

	local key = getActionHotkey('gridmenu_next_page')
	if not key then
		key = Cfgs.NEXT_PAGE_KEY
		Spring.SendCommands('bind ' .. key .. ' gridmenu_next_page')
	end

	Cfgs.NEXT_PAGE_KEY = key

	key = getActionHotkey('gridmenu_prev_page')
	if not key then
		key = Cfgs.PREV_PAGE_KEY
		Spring.SendCommands('bind ' .. key .. ' gridmenu_prev_page')
	end

	Cfgs.PREV_PAGE_KEY = key

	-- Autogenerate bottom layout keys
	Cfgs.vKeyLayout = {}

	-- For bottom layout, 1-2 row x 1-4 col positions remain the same
	for r=1,2 do
		Cfgs.vKeyLayout[r] = {}
		for c=1,4 do
			Cfgs.vKeyLayout[r][c] = Cfgs.keyLayout[r][c]
		end
	end

	Cfgs.vKeyLayout[1][5] = Cfgs.keyLayout[3][3]
	Cfgs.vKeyLayout[1][6] = Cfgs.keyLayout[3][4]
	Cfgs.vKeyLayout[2][5] = Cfgs.keyLayout[3][1]
	Cfgs.vKeyLayout[2][6] = Cfgs.keyLayout[3][2]

	doUpdate = true
end

local function setPreGamestartDefID(uDefID)
	selBuildQueueDefID = uDefID

	if not uDefID then
		currentBuildCategory = nil
		currentCategoryIndex = nil
		doUpdate = true
	end

	if isMex[uDefID] then
		if Spring.GetMapDrawMode() ~= "metal" then
			Spring.SendCommands("ShowMetalMap")
		end
	elseif Spring.GetMapDrawMode() == "metal" then
		Spring.SendCommands("ShowStandard")
	end
end

local function gridmenuCategoryHandler(_, _, args)
	local cIndex = args and tonumber(args[1])

	if not cIndex or cIndex < 1 or cIndex > 4 then
		return
	end

	if not selectedBuilder or (currentBuildCategory and hotkeyActions['1' .. cIndex]) then
		return
	end

	local alt, ctrl, meta, _ = Spring.GetModKeyState()

	if alt or ctrl or meta then return end

	currentBuildCategory = categories[cIndex]
	currentCategoryIndex = cIndex
	switchedCategory = os.clock()
	doUpdate = true

	return true
end

local function enqueueUnit(uDefID, opts)
	local udTable = Spring.GetSelectedUnitsSorted()
	udTable.n = nil
	for udidFac, uTable in pairs(udTable) do
		if isFactory[udidFac] then
			uTable.n = nil
			for _, uid in ipairs(uTable) do
				Spring.GiveOrderToUnit(uid, uDefID, {}, opts)
			end
		end
	end
end

local function gridmenuKeyHandler(_, _, args, _, isRepeat)
	-- validate args
	local row = args and tonumber(args[1])
	local col = args and tonumber(args[2])

	if (not row or row < 1 or row > 3) or (not col or col < 1 or col > 4) then
		return
	end

	local uDefID = hotkeyActions[tostring(row) .. tostring(col)]

	if not uDefID then
		return
	end

	if isRepeat and selectedBuilder then
		return currentCategoryIndex and true or false
	end

	local alt, ctrl, meta, shift = Spring.GetModKeyState()

	if selectedFactory then
		if meta then return end

		local opts

		if ctrl then
			opts = { "right" }
			Spring.PlaySoundFile(Cfgs.sound_queue_rem, 0.75, 'ui')
		else
			opts = { "left" }
			Spring.PlaySoundFile(Cfgs.sound_queue_add, 0.75, 'ui')
		end

		if alt then table.insert(opts, 'alt') end
		if shift then table.insert(opts, 'shift') end

		enqueueUnit(uDefID, opts)

		return true
	elseif preGamestartPlayer and currentBuildCategory then
		if alt or ctrl or meta then return end

		setPreGamestartDefID(-uDefID)

		doUpdate = true

		return true
	elseif selectedBuilder and currentBuildCategory then
		if alt or ctrl or meta then return end

		local uDef = UnitDefs[-uDefID]
		local isRepeatMex = uDef.customParams.metal_extractor and uDef.name == activeCmd and not (uDef.stealth or #uDef.weapons > 0)
		local cmd = isRepeatMex and 'areamex' or spGetCmdDescIndex(uDefID)
		Spring.SetActiveCommand(cmd, 3, false, true, alt, ctrl, meta, shift)

		return true
	end

	return false
end

function widget:CommandNotify(cmdID, _, cmdOpts)
	if cmdID >= 0 then
		return
	end

	if not cmdOpts.shift then
		currentBuildCategory = nil
		doUpdate = true
	end
end

local function nextPageHandler()
	if not (selectedBuilder or selectedFactory) then return end
	if pages < 2 then return end

	currentPage = math_min(pages, currentPage + 1)
	doUpdate = true

	return true
end

local function prevPageHandler()
	if not (selectedBuilder or selectedFactory) then return end
	if pages < 2 then return end

	currentPage = math_max(1, currentPage - 1)
	doUpdate = true

	return true
end

local function gridmenuCategoriesHandler()
	if not (selectedBuilder and currentBuildCategory) then return end

	currentBuildCategory = nil
	currentCategoryIndex = nil
	doUpdate = true

	return true
end

-- Spring handles buildfacing already, this is for managing pregamestart
local function buildFacingHandler(_, _, args)
	if not (preGamestartPlayer and selBuildQueueDefID) then
		return
	end

	local facing = Spring.GetBuildFacing()
	if args and args[1] == "inc" then
		facing = (facing + 1) % 4
		Spring.SetBuildFacing(facing)

		return true
	elseif args and args[1] == "dec" then
		facing = (facing - 1) % 4
		Spring.SetBuildFacing(facing)

		return true
	elseif args and facingMap[args[1]] then
		Spring.SetBuildFacing(facingMap[args[1]])

		return true
	end
end

local function buildmenuPregameDeselectHandler()
	if not (preGamestartPlayer and selBuildQueueDefID) then return end

	setPreGamestartDefID()

	return true
end

local function clearPregameBuildQueue()
	if not preGamestartPlayer then return end

	setPreGamestartDefID()
	buildQueue = {}

	return true
end

function widget:Initialize()
	if widgetHandler:IsWidgetKnown("Build menu") then
		widgetHandler:DisableWidget("Build menu")
	end

	-- For some reason when handler = true widgetHandler:AddAction is not available
	widgetHandler.actionHandler:AddAction(self, "stop", clearPregameBuildQueue, nil, "p")
	widgetHandler.actionHandler:AddAction(self, "buildfacing", buildFacingHandler, nil, "p")
	widgetHandler.actionHandler:AddAction(self, "gridmenu_next_page", nextPageHandler, nil, "p")
	widgetHandler.actionHandler:AddAction(self, "gridmenu_prev_page", prevPageHandler, nil, "p")
	widgetHandler.actionHandler:AddAction(self, "gridmenu_key", gridmenuKeyHandler, nil, "pR")
	widgetHandler.actionHandler:AddAction(self, "gridmenu_category", gridmenuCategoryHandler, nil, "p")
	widgetHandler.actionHandler:AddAction(self, "gridmenu_categories", gridmenuCategoriesHandler, nil, "p")
	widgetHandler.actionHandler:AddAction(self, "buildmenu_pregame_deselect", buildmenuPregameDeselectHandler, nil, "p")

	reloadBindings()

	ui_opacity = WG.FlowUI.opacity
	ui_scale = WG.FlowUI.scale

	iconTypesMap = {}
	if Script.LuaRules('GetIconTypes') then
		iconTypesMap = Script.LuaRules.GetIconTypes()
	end

	-- Get our starting unit
	if preGamestartPlayer then
		SetBuildFacing()
		if not startDefID or startDefID ~= Spring.GetTeamRulesParam(myTeamID, 'startUnit') then
			startDefID = Spring.GetTeamRulesParam(myTeamID, 'startUnit')
			doUpdate = true
		end
	end

	widget:ViewResize()
	widget:SelectionChanged(Spring.GetSelectedUnits())

	WG['buildmenu'] = {}
	WG['buildmenu'].getPreGameDefID = function()
		return selBuildQueueDefID
	end
	WG['buildmenu'].getGroups = function()
		return groups, unitGroup
	end
	WG['buildmenu'].getOrder = function()
		return unitOrder
	end
	WG['buildmenu'].getShowPrice = function()
		return showPrice
	end
	WG['buildmenu'].setShowPrice = function(value)
		showPrice = value
		doUpdate = true
	end
	WG['buildmenu'].getAlwaysShow = function()
		return alwaysShow
	end
	WG['buildmenu'].setAlwaysShow = function(value)
		alwaysShow = value
		doUpdate = true
	end
	WG['buildmenu'].getShowRadarIcon = function()
		return showRadarIcon
	end
	WG['buildmenu'].setShowRadarIcon = function(value)
		showRadarIcon = value
		doUpdate = true
	end
	WG['buildmenu'].getShowGroupIcon = function()
		return showGroupIcon
	end
	WG['buildmenu'].setShowGroupIcon = function(value)
		showGroupIcon = value
		doUpdate = true
	end
	WG['buildmenu'].getBottomPosition = function()
		return stickToBottom
	end
	WG['buildmenu'].setBottomPosition = function(value)
		stickToBottom = value
		widget:Update(1000)
		widget:ViewResize()
		doUpdate = true
	end
	WG['buildmenu'].getSize = function()
		return posY, posY2
	end
	WG['buildmenu'].reloadBindings = reloadBindings
end

-- update queue number
function widget:UnitFromFactory(_, _, _, factID)
	if Spring.IsUnitSelected(factID) then
		doUpdateClock = os.clock() + 0.01
	end
end

local sec = 0
local updateSelection = true
function widget:Update(dt)
	if updateSelection then
		updateSelection = false
		SelectedUnitsCount = Spring.GetSelectedUnitsCount()

		selectedBuilder = nil
		selectedFactory = nil
		currentBuildCategory = nil
		currentCategoryIndex = nil
		selectedBuilders = {}
		currentPage = 1

		if SelectedUnitsCount > 0 then
			local sel = Spring.GetSelectedUnits()
			for _, unitID in pairs(sel) do
				local unitDefID = spGetUnitDefID(unitID)

				if isBuilder[unitDefID] then
					doUpdate = true

					selectedBuilders[unitID] = true
					selectedBuilder = unitDefID
				end

				if isFactory[unitDefID] then
					doUpdate = true

					selectedFactory = unitDefID
					selectedFactoryUID = unitID
					selectedBuilder = nil

					break
				end
			end

			if selectedBuilder then
				categories = Cfgs.buildCategories
			else
				categories = {}
			end
		end
	end

	sec = sec + dt
	if sec > 0.33 then
		sec = 0
		checkGuishader()
		if ui_scale ~= Spring.GetConfigFloat("ui_scale", 1) then
			ui_scale = Spring.GetConfigFloat("ui_scale", 1)
			widget:ViewResize()
			doUpdate = true
		end
		if ui_opacity ~= Spring.GetConfigFloat("ui_opacity", 0.6) then
			ui_opacity = Spring.GetConfigFloat("ui_opacity", 0.6)
			clear()
			doUpdate = true
		end
		if WG['minimap'] and minimapHeight ~= WG['minimap'].getHeight() then
			widget:ViewResize()
			doUpdate = true
		end

		local _, _, mapMinWater, _ = Spring.GetGroundExtremes()
		if not voidWater and mapMinWater <= minWaterUnitDepth then
			showWaterUnits = true
		end

		local prevOrdermenuLeft = ordermenuLeft
		local prevOrdermenuHeight = ordermenuHeight
		if WG['ordermenu'] then
			local oposX, _, owidth, oheight = WG['ordermenu'].getPosition()
			ordermenuLeft = oposX + owidth
			ordermenuHeight = oheight
		end
		if not prevAdvplayerlistLeft or advplayerlistLeft ~= prevAdvplayerlistLeft or not prevOrdermenuLeft or ordermenuLeft ~= prevOrdermenuLeft  or not prevOrdermenuHeight or ordermenuHeight ~= prevOrdermenuHeight then
			widget:ViewResize()
		end

		disableInput = Cfgs.disableInputWhenSpec and isSpec
		if Spring.IsGodModeEnabled() then
			disableInput = false
		end
	end

	if selectNextFrame and not preGamestartPlayer then
		local cmdIndex = spGetCmdDescIndex(selectNextFrame)
		if cmdIndex then
			Spring.SetActiveCommand(cmdIndex, 1, true, false, Spring.GetModKeyState())
		end
		selectNextFrame = nil
		switchedCategory = nil

		doUpdate = true
	else
		-- refresh buildmenu if active cmd changed
		local prevActiveCmd = activeCmd

		activeCmd = select(4, Spring.GetActiveCommand())

		if activeCmd ~= prevActiveCmd then doUpdate = true end
	end
end

local function drawBuildmenuBg()
	WG['buildmenu'].selectedID = nil
	UiElement(backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4], (posX > 0 and 1 or 0), 1, ((posY-height > 0 or posX <= 0) and 1 or 0), 0)
end

local function drawButton(rect, text, opts)
	opts = opts or {}
	local highlight = opts.highlight
	local fontSize = opts.fontSize
	local hovered = opts.hovered

	local color1 = { 0.6, 0.6, 0.6, math_max(0.35, math_min(0.55, ui_opacity/1.5)) }
	color1[4] = math_max(0, math_min(0.35, (ui_opacity-0.3)))
	local color2 = { 1,1,1, math_max(0, math_min(0.35, (ui_opacity-0.3))) }

	local padding = math_max(1, math_floor(bgpadding * 0.52))
	local pad1 = padding

	RectRound(rect[1] + pad1, rect[2] + pad1, rect[3] - pad1, rect[4] - pad1, padding * 1.5, 2, 2, 2, 2, color1, color2)
	color1 = {0,0,0, color1[4]*0.85}
	color2 = {0,0,0, color2[4]*0.85}
	RectRound(rect[1] + padding + pad1, rect[2] + padding + pad1, rect[3] - padding - pad1, rect[4] - padding - pad1, padding * 1.2, 2, 2, 2, 2, color1, color2)

	color1 = { 0, 0, 0, math_max(0.55, math_min(0.95, ui_opacity)) }	-- bottom
	color2 = { 0, 0, 0, math_max(0.55, math_min(0.95, ui_opacity)) }	-- top

	if highlight then
		gl.Blending(GL_SRC_ALPHA, GL_ONE)
		gl.Color(0, 0, 0, 0.75)
	end

	UiButton(rect[1] + padding + pad1, rect[2] + padding + pad1, rect[3] - padding - pad1, rect[4] - padding - pad1, 1,1,1,1, 1,1,1,1, nil, color1, color2, padding)

	if highlight then
		gl.Blending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end

	local zoom = 1

	if hovered then
		zoom = 1.07

		local leftMargin = 0
		local rightMargin = 0
		local topMargin = 0
		local bottomMargin = 0

		-- gloss highlight
		local pad = padding
		local pad2 = 0
		gl.Blending(GL_SRC_ALPHA, GL_ONE)
		RectRound(rect[1] + leftMargin + pad + pad2, rect[4] - topMargin - bgpadding - pad - pad2 - ((rect[4] - rect[2]) * 0.42), rect[3] - rightMargin - pad - pad2, (rect[4] - topMargin - pad - pad2), padding * 1.5, 2, 2, 0, 0, { 1, 1, 1, 0.035 }, { 1, 1, 1, (disableInput and 0.11 or 0.24) })
		RectRound(rect[1] + leftMargin + pad + pad2, rect[2] + bottomMargin + pad + pad2, rect[3] - rightMargin - pad - pad2, (rect[2] - bottomMargin - pad - pad2) + ((rect[4] - rect[2]) * 0.5), padding * 1.5, 0, 0, 2, 2, { 1, 1, 1, (disableInput and 0.035 or 0.075) }, { 1, 1, 1, 0 })
		gl.Blending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end

	local fontHeight = font2:GetTextHeight(text) * fontSize * zoom
	local fontHeightOffset = fontHeight * 0.34
	font2:Print(text, rect[1] + ((rect[3] - rect[1]) / 2), (rect[2] - (rect[2] - rect[4]) / 2) - fontHeightOffset, fontSize * zoom, "con")
end

local function drawCategoryButtons()
	local catTexts = {}
	local maxTextSize = 0

	for catIndex, cat in pairs(Cfgs.buildCategories) do
		local catText = cat .. " \255\215\255\215" .. "[" .. keyConfig.sanitizeKey(Cfgs.categoryKeys[catIndex], currentLayout) .. "]"
		catTexts[cat] = catText
		local catTextSize = font2:GetTextWidth(catText)
		if maxTextSize < catTextSize then
			maxTextSize = catTextSize
		end
	end

	for _, cat in pairs(Cfgs.buildCategories) do
		local rect = catRects[cat]

		local opts = {
			highlight = (cat == currentBuildCategory),
			hovered = (hoveredCat == cat),
			fontSize = (rect[3] - rect[1] - (stickToBottom and 2 or 1.5) * 8 * math_max(1, math_floor(bgpadding * 0.52))) / maxTextSize,
		}

		if opts.hovered then
			drawnHoveredCat = cat
		end

		drawButton(rect, catTexts[cat], opts)
	end
end

local function drawCell(cellRectID, usedZoom, cellColor, disabled)
	local cmd = cellcmds[cellRectID]
	local uid = cmd.id * -1
	-- unit icon
	if disabled then
		gl.Color(0.4, 0.4, 0.4, 1)
	else
		gl.Color(1, 1, 1, 1)
	end

	local showIcon = showGroupIcon and not (selectedFactory or currentCategoryIndex)

	UiUnit(
	cellRects[cellRectID][1] + cellPadding + iconPadding,
	cellRects[cellRectID][2] + cellPadding + iconPadding,
	cellRects[cellRectID][3] - cellPadding - iconPadding,
	cellRects[cellRectID][4] - cellPadding - iconPadding,
	cornerSize, 1,1,1,1,
	usedZoom,
	nil, disabled and 0 or nil,
	'#' .. uid,
	showRadarIcon and (((unitIconType[uid] and iconTypesMap[unitIconType[uid]]) and ':l' .. (disabled and 't0.35,0.35,0.35' or '') ..':' .. iconTypesMap[unitIconType[uid]] or nil)) or nil,
	showIcon and (groups[unitGroup[uid]] and ':l' .. (disabled and 'gt0.4,0.4,0.4:' or ':') ..groups[unitGroup[uid]] or nil) or nil,
	{unitMetalCost[uid], unitEnergyCost[uid]},
	tonumber(cmd.params[1])
	)

	-- colorize/highlight unit icon
	if cellColor then
		gl.Blending(GL.DST_ALPHA, GL_ONE_MINUS_SRC_COLOR)
		gl.Color(cellColor[1], cellColor[2], cellColor[3], cellColor[4])
		gl.Texture('#' .. uid)
		UiUnit(
		cellRects[cellRectID][1] + cellPadding + iconPadding,
		cellRects[cellRectID][2] + cellPadding + iconPadding,
		cellRects[cellRectID][3] - cellPadding - iconPadding,
		cellRects[cellRectID][4] - cellPadding - iconPadding,
		cornerSize, 1,1,1,1,
		usedZoom
		)
		if cellColor[4] > 0 then
			gl.Blending(GL_SRC_ALPHA, GL_ONE)
			UiUnit(
			cellRects[cellRectID][1] + cellPadding + iconPadding,
			cellRects[cellRectID][2] + cellPadding + iconPadding,
			cellRects[cellRectID][3] - cellPadding - iconPadding,
			cellRects[cellRectID][4] - cellPadding - iconPadding,
			cornerSize, 1,1,1,1,
			usedZoom
			)
		end
		gl.Blending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	end
	gl.Texture(false)

	-- price
	if showPrice then
		local text
		if disabled then
			text = "\255\125\125\125" .. unitMetalCost[uid] .. "\n\255\135\135\135"
		else
			text = "\255\245\245\245" .. unitMetalCost[uid] .. "\n\255\255\255\000"
		end
		font2:Print(text .. unitEnergyCost[uid], cellRects[cellRectID][1] + cellPadding + (cellInnerSize * 0.048), cellRects[cellRectID][2] + cellPadding + (priceFontSize * 1.35), priceFontSize, "o")
	end

	-- factory queue number
	if cmd.params[1] then
		local pad = math_floor(cellInnerSize * 0.03)
		local textWidth = math_floor(font2:GetTextWidth(cmd.params[1] .. '	') * cellInnerSize * 0.285)
		local pad2 = 0
		RectRound(cellRects[cellRectID][3] - cellPadding - iconPadding - textWidth - pad2, cellRects[cellRectID][4] - cellPadding - iconPadding - math_floor(cellInnerSize * 0.365) - pad2, cellRects[cellRectID][3] - cellPadding - iconPadding, cellRects[cellRectID][4] - cellPadding - iconPadding, cornerSize * 3.3, 0, 0, 0, 1, { 0.15, 0.15, 0.15, 0.95 }, { 0.25, 0.25, 0.25, 0.95 })
		RectRound(cellRects[cellRectID][3] - cellPadding - iconPadding - textWidth - pad2, cellRects[cellRectID][4] - cellPadding - iconPadding - math_floor(cellInnerSize * 0.15) - pad2, cellRects[cellRectID][3] - cellPadding - iconPadding, cellRects[cellRectID][4] - cellPadding - iconPadding, 0, 0, 0, 0, 0, { 1, 1, 1, 0 }, { 1, 1, 1, 0.05 })
		RectRound(cellRects[cellRectID][3] - cellPadding - iconPadding - textWidth - pad2 + pad, cellRects[cellRectID][4] - cellPadding - iconPadding - math_floor(cellInnerSize * 0.365) - pad2 + pad, cellRects[cellRectID][3] - cellPadding - iconPadding - pad2, cellRects[cellRectID][4] - cellPadding - iconPadding - pad2, cornerSize * 2.6, 0, 0, 0, 1, { 0.7, 0.7, 0.7, 0.1 }, { 1, 1, 1, 0.1 })
		font2:Print("\255\190\255\190" .. cmd.params[1],
			cellRects[cellRectID][1] + cellPadding + math_floor(cellInnerSize * 0.96) - pad2,
			cellRects[cellRectID][2] + cellPadding + math_floor(cellInnerSize * 0.735) - pad2,
			cellInnerSize * 0.29, "ro"
		)
	end

	if cmd.hotkey and (selectedFactory or (selectedBuilder and currentBuildCategory)) then
		local hotkeyText = keyConfig.sanitizeKey(cmd.hotkey, currentLayout)

		local hotkeyFontSize = priceFontSize * 1.1
		font2:Print("\255\215\255\215" .. hotkeyText, cellRects[cellRectID][1] + cellPadding + (cellInnerSize * 0.048), cellRects[cellRectID][4] - cellPadding - hotkeyFontSize, hotkeyFontSize, "o")
	end
end

local function labActiveArea()
	if stickToBottom then
		return {
			backgroundRect[1] + bgpadding,
			backgroundRect[2],
			backgroundRect[3],
			backgroundRect[4] - bgpadding
		}
	else
		return {
			backgroundRect[1],
			backgroundRect[2],
			backgroundRect[3] - bgpadding,
			backgroundRect[4] - bgpadding
		}
	end
end

local function drawCategories()
	local numCats = #categories
	local activeArea

	if stickToBottom then
		local x1 = backgroundRect[1] + bgpadding

		activeArea = {
			x1 + pageButtonWidth,
			backgroundRect[2] - 2 * activeAreaMargin,
			backgroundRect[3],
			backgroundRect[4] - bgpadding
		}

		local contentHeight = activeArea[4] - activeArea[2]

		for i, cat in ipairs(categories) do
			local a1 = x1
			local a2 = activeArea[4] - i * (contentHeight / numCats) + 2
			local a3 = a1 + pageButtonWidth - activeAreaMargin
			local a4 = a2 + (contentHeight / numCats) - 2

			catRects[cat] = { a1, a2, a3, a4 }
		end
	else
		local y2 = backgroundRect[4] - bgpadding

		activeArea = {
			backgroundRect[1],
			backgroundRect[2],
			backgroundRect[3] - bgpadding,
			y2 - pageButtonHeight
		}

		local buttonWidth = math.round((activeArea[3] - activeArea[1] - bgpadding) / numCats)

		for i, cat in ipairs(categories) do
			local a1 = backgroundRect[1] + activeAreaMargin + (i - 1) * buttonWidth
			local a2 = y2 - pageButtonHeight
			local a3 = a1 + buttonWidth
			local a4 = y2 - activeAreaMargin

			catRects[cat] = { a1, a2, a3, a4 }
		end
	end

	drawCategoryButtons()

	return activeArea
end

local function drawGrid(activeArea)
	local numCellsPerPage = rows * colls
	local cellRectID = 0
	local unitGrid
	if selectedFactory then
		unitGrid = gridPosUnit[selectedFactory]
	else
		unitGrid = gridPosUnit[selectedBuilder]
	end
	local curCmd = currentPage > 1 and (numCellsPerPage * (currentPage - 1) - (uidcmdsCount - cmdsCount) + 1) or 1

	cellcmds = {}

	for row = 3, 1, -1 do
		for coll = 1, 4 do
			cellRectID = cellRectID + 1

			local uDefID
			local kcol = coll
			local arow = 3 - row + 1
			local krow = arow
			-- hotkey mapping from 2x6 -> 3x4 grid
			-- 3,1 -> 2,5
			-- 3,2 -> 2,6
			-- 3,3 -> 1,5
			-- 3,4 -> 1,6
			if arow > 2 and stickToBottom then
				krow = coll < 3 and 2 or 1
				kcol = 6 - coll % 2
			end

			if selectedFactory then
				if currentPage == 1 and unitGrid and unitGrid[arow .. coll] then
					uDefID = unitGrid[arow .. coll]
				elseif cmds[curCmd] then
					uDefID = cmds[curCmd].id * -1
					curCmd = curCmd + 1
				end
			elseif currentPage == 1 and currentBuildCategory and unitGrid and unitGrid[currentCategoryIndex .. arow .. coll] then
				uDefID = unitGrid[currentCategoryIndex .. arow .. coll]
			elseif cmds[curCmd] then
				uDefID = cmds[curCmd].id * -1
				curCmd = curCmd + 1
			end

			if uDefID and uidcmds[uDefID] then
				cellcmds[cellRectID] = uidcmds[uDefID]

				uidcmds[uDefID].hotkey = string.gsub(string.upper(Cfgs.keyLayout[arow][coll]), "ANY%+", '')
				hotkeyActions[tostring(arow) .. tostring(coll)] = -uDefID

				local udef = uidcmds[uDefID]

				cellRects[cellRectID] = {
					activeArea[1] + (kcol - 1) * cellSize,
					activeArea[4] - (rows - krow + 1) * cellSize,
					activeArea[1] + (kcol ) * cellSize,
					activeArea[4] - (rows - krow) * cellSize,
				}

				local cellIsSelected = (activeCmd and udef and activeCmd == udef.name) or
															 (preGamestartPlayer and selBuildQueueDefID == uDefID)
				local usedZoom = (cellIsSelected and selectedCellZoom or defaultCellZoom)

				if cellIsSelected then
					WG['buildmenu'].selectedID = uDefID
				end

				drawCell(cellRectID, usedZoom, cellIsSelected and { 1, 0.85, 0.2, 0.25 } or nil, nil, unitRestricted[uDefID])
			else
				hotkeyActions[tostring(arow) .. tostring(coll)] = nil
			end
		end
	end

	if cellcmds[1] and (selectedBuilder or preGamestartPlayer) and switchedCategory then
		selectNextFrame = cellcmds[1].id
	end
end

local function drawPaginators(activeArea)
	paginatorRects = {}

	if pages == 1 then
		return
	end

	if stickToBottom then
		local contentHeight = activeArea[4] - activeArea[2]
		paginatorCellHeight = contentHeight / 3

		paginatorRects[1] = { activeArea[1] + 6 * cellSize, activeArea[2] + activeAreaMargin, activeArea[3] - bgpadding, activeArea[2] + paginatorCellHeight }
		paginatorRects[2] = { paginatorRects[1][1], activeArea[2] + 2 * paginatorCellHeight, paginatorRects[1][3], activeArea[2] + 3 * paginatorCellHeight }

		local paginatorWidth = paginatorRects[1][3] - paginatorRects[1][1]

		UiButton(paginatorRects[1][1] + cellPadding, paginatorRects[1][2] + cellPadding, paginatorRects[1][3] - cellPadding, paginatorRects[1][4] - cellPadding, 1,1,1,1, 1,1,1,1, nil, { 0, 0, 0, 0.8 }, { 0.2, 0.2, 0.2, 0.8 }, bgpadding * 0.5)
		font2:Print("\255\215\255\215[".. keyConfig.sanitizeKey(Cfgs.PREV_PAGE_KEY, currentLayout) .."]", paginatorRects[1][1] + paginatorWidth/2, paginatorRects[1][2] + (paginatorCellHeight * 0.5) - paginatorFontSize * 0.25, paginatorFontSize, "co")
		UiButton(paginatorRects[2][1] + cellPadding, paginatorRects[2][2] + cellPadding, paginatorRects[2][3] - cellPadding, paginatorRects[2][4] - cellPadding, 1,1,1,1, 1,1,1,1, nil, { 0, 0, 0, 0.8 }, { 0.2, 0.2, 0.2, 0.8 }, bgpadding * 0.5)
		font2:Print("\255\215\255\215[".. keyConfig.sanitizeKey(Cfgs.NEXT_PAGE_KEY, currentLayout) .."]", paginatorRects[2][1] + paginatorWidth/2, paginatorRects[2][2] + (paginatorCellHeight * 0.5) - paginatorFontSize * 0.25, paginatorFontSize, "co")

		font2:Print("\255\245\245\245" .. currentPage .. "/" .. pages,
		(paginatorRects[1][1] + paginatorRects[1][3]) * 0.5,
		paginatorRects[1][4] + paginatorCellHeight * 0.5 - paginatorFontSize * 0.25, paginatorFontSize, "co")
	else
		local contentWidth = activeArea[3] - activeArea[1]
		paginatorCellWidth = math_floor(contentWidth * 0.33)

		paginatorRects[1] = { activeArea[1] + activeAreaMargin, activeArea[2], activeArea[1] + paginatorCellWidth, activeArea[4] - 3 * cellSize }
		paginatorRects[2] = { activeArea[3] - paginatorCellWidth, paginatorRects[1][2], activeArea[3], paginatorRects[1][4] }
		paginatorCellHeight = paginatorRects[1][4] - paginatorRects[1][2]
		local prevText = "\255\215\255\215[".. keyConfig.sanitizeKey(Cfgs.PREV_PAGE_KEY, currentLayout) .."]"
		local nextText = "\255\215\255\215[".. keyConfig.sanitizeKey(Cfgs.NEXT_PAGE_KEY, currentLayout) .."]"

		UiButton(paginatorRects[1][1] + cellPadding, paginatorRects[1][2] + bgpadding, paginatorRects[1][3] - cellPadding, paginatorRects[1][4] - cellPadding, 1,1,1,1, 1,1,1,1, nil, { 0, 0, 0, 0.8 }, { 0.2, 0.2, 0.2, 0.8 }, bgpadding * 0.5)
		font2:Print(prevText, paginatorRects[1][1] + (paginatorCellWidth * 0.5), paginatorRects[1][4] - font2:GetTextHeight(prevText) * paginatorFontSize * 0.25 - paginatorCellHeight/2, paginatorFontSize, "co")
		UiButton(paginatorRects[2][1] + cellPadding, paginatorRects[2][2] + bgpadding, paginatorRects[2][3] - cellPadding, paginatorRects[2][4] - cellPadding, 1,1,1,1, 1,1,1,1, nil, { 0, 0, 0, 0.8 }, { 0.2, 0.2, 0.2, 0.8 }, bgpadding * 0.5)
		font2:Print(nextText, paginatorRects[2][1] + (paginatorCellWidth * 0.5), paginatorRects[2][4] - font2:GetTextHeight(nextText) * paginatorFontSize * 0.25 - paginatorCellHeight/2, paginatorFontSize, "co")

		local pagesText = currentPage .. " / " .. pages
		font2:Print("\255\245\245\245" .. pagesText, contentWidth * 0.5, paginatorRects[1][4] - font2:GetTextHeight(pagesText) * paginatorFontSize * 0.25 - paginatorCellHeight/2, paginatorFontSize, "co")
	end
end

local function drawBuildmenu()
	local activeArea

	catRects = {}

	font2:Begin()

	if selectedFactory then
		activeArea = labActiveArea()
	elseif selectedBuilder then
		activeArea = drawCategories()
	end

	if stickToBottom then
		rows = 2
		colls = 6
		cellSize = math_floor((activeArea[4] - activeArea[2]) / rows)
	else
		rows = 3
		colls = 4
		cellSize = math_floor((activeArea[3] - activeArea[1]) / colls)
	end

	-- adjust grid size when pages are needed
	if uidcmdsCount > colls * rows then
		pages = math_ceil(uidcmdsCount / (rows * colls))

		if currentPage > pages then
			currentPage = pages
		end
	else
		currentPage = 1
		pages = 1
	end

	-- these are globals so it can be re-used (hover highlight)
	cellPadding = math_floor(cellSize * Cfgs.cfgCellPadding)
	iconPadding = math_max(1, math_floor(cellSize * Cfgs.cfgIconPadding))
	cornerSize = math_floor(cellSize * Cfgs.cfgIconCornerSize)
	cellInnerSize = cellSize - cellPadding - cellPadding
	priceFontSize = math_floor((cellInnerSize * Cfgs.cfgPriceFontSize) + 0.5)

	cellRects = {}
	hotkeyActions = {}

	drawGrid(activeArea)
	drawPaginators(activeArea)

	font2:End()
end

function widget:RecvLuaMsg(msg)
	if msg:sub(1, 18) == 'LobbyOverlayActive' then
		chobbyInterface = (msg:sub(1, 19) == 'LobbyOverlayActive1')
	end
end

local function GetBuildingDimensions(uDefID, facing)
	local bDef = UnitDefs[uDefID]
	if (facing % 2 == 1) then
		return 4 * bDef.zsize, 4 * bDef.xsize
	else
		return 4 * bDef.xsize, 4 * bDef.zsize
	end
end

local function removeUnitShape(id)
	if unitshapes[id] then
		WG.StopDrawUnitShapeGL4(unitshapes[id])
		unitshapes[id] = nil
	end
end

local function addUnitShape(id, unitDefID, px, py, pz, rotationY, teamID)
	if unitshapes[id] then
		removeUnitShape(id)
	end
	unitshapes[id] = WG.DrawUnitShapeGL4(unitDefID, px, py, pz, rotationY, 1, teamID, nil, nil)
	return unitshapes[id]
end

local function DrawBuilding(buildData, borderColor, drawRanges)
	local bDefID, bx, by, bz, facing = buildData[1], buildData[2], buildData[3], buildData[4], buildData[5]
	local bw, bh = GetBuildingDimensions(bDefID, facing)

	gl.DepthTest(false)
	gl.Color(borderColor)

	gl.Shape(GL.LINE_LOOP, { { v = { bx - bw, by, bz - bh } },
	{ v = { bx + bw, by, bz - bh } },
	{ v = { bx + bw, by, bz + bh } },
	{ v = { bx - bw, by, bz + bh } } })

	if drawRanges then
		if isMex[bDefID] then
			gl.Color(1.0, 0.3, 0.3, 0.7)
			gl.DrawGroundCircle(bx, by, bz, Game.extractorRadius, 50)
		end

		local wRange = unitMaxWeaponRange[bDefID]
		if wRange then
			gl.Color(1.0, 0.3, 0.3, 0.7)
			gl.DrawGroundCircle(bx, by, bz, wRange, 40)
		end
	end

	if WG.StopDrawUnitShapeGL4 then
		local id = buildData[1]..'_'..buildData[2]..'_'..buildData[3]..'_'..buildData[4]..'_'..buildData[5]
		addUnitShape(id, buildData[1], buildData[2], buildData[3], buildData[4], buildData[5]*(math.pi/2), myTeamID)
	end
end

local function DoBuildingsClash(buildData1, buildData2)
	local w1, h1 = GetBuildingDimensions(buildData1[1], buildData1[5])
	local w2, h2 = GetBuildingDimensions(buildData2[1], buildData2[5])

	return math.abs(buildData1[2] - buildData2[2]) < w1 + w2 and
	math.abs(buildData1[4] - buildData2[4]) < h1 + h2
end

-- load all icons to prevent briefly showing white unit icons (will happen due to the custom texture filtering options)
local function cacheUnitIcons()
	local excludeScavs = not (Spring.Utilities.Gametype.IsScavengers() or Spring.GetModOptions().experimentalscavuniqueunits)
	local excludeChickens = not Spring.Utilities.Gametype.IsChickens()
	gl.Translate(-vsx,0,0)
	gl.Color(1, 1, 1, 0.001)
	for id, unit in pairs(UnitDefs) do
		if not excludeScavs or not string.find(unit.name,'_scav') then
			if not excludeChickens or not string.find(unit.name,'chicken') then
				gl.Texture('#'..id)
				gl.TexRect(-1, -1, 0, 0)
				if unitIconType[id] and iconTypesMap[unitIconType[id]] then
					gl.Texture(':l:' .. iconTypesMap[unitIconType[id]])
					gl.TexRect(-1, -1, 0, 0)
				end
			end
		end
	end
	gl.Color(1, 1, 1, 1)
	gl.Translate(vsx,0,0)
end

local function drawBuildProgress()
	local numCellsPerPage = rows * colls
	local maxCellRectID = numCellsPerPage * currentPage
	if maxCellRectID > uidcmdsCount then
		maxCellRectID = uidcmdsCount
	end
	-- loop selected builders
	local drawncellRectIDs = {}
	for builderUnitID, _ in pairs(selectedBuilders) do
		local unitBuildID = spGetUnitIsBuilding(builderUnitID)
		if unitBuildID then
			local unitBuildDefID = spGetUnitDefID(unitBuildID)
			if unitBuildDefID then
				-- loop all shown cells
				for cellRectID, _ in pairs(cellRects) do
					if not drawncellRectIDs[cellRectID] then
						if cellRectID > maxCellRectID then
							break
						end
						local cellUnitDefID = cellcmds[cellRectID].id * -1
						if unitBuildDefID == cellUnitDefID then
							drawncellRectIDs[cellRectID] = true
							local progress = 1 - select(5, spGetUnitHealth(unitBuildID))
							RectRoundProgress(cellRects[cellRectID][1] + cellPadding + iconPadding, cellRects[cellRectID][2] + cellPadding + iconPadding, cellRects[cellRectID][3] - cellPadding - iconPadding, cellRects[cellRectID][4] - cellPadding - iconPadding, cellSize * 0.03, progress, { 0.08, 0.08, 0.08, 0.6 })
						end
					end
				end
			end
		end
	end
end

function widget:DrawScreen()
	if (not cachedUnitIcons) and Spring.GetGameFrame() == 0 then
		cachedUnitIcons = true
		cacheUnitIcons()
	end

	if chobbyInterface then
		return
	end

	if WG['buildmenu'] then
		WG['buildmenu'].hoverID = nil
	end
	if not (preGamestartPlayer or selectedBuilder or selectedFactory or alwaysShow) then
		if WG['guishader'] and dlistGuishader then
			WG['guishader'].RemoveDlist('buildmenu')
		end
	else
		local x, y, b, b2, b3 = Spring.GetMouseState()
		local now = os.clock()
		if doUpdate or (doUpdateClock and now >= doUpdateClock) then
			if doUpdateClock and now >= doUpdateClock then
				doUpdateClock = nil
			end
			clear()
			RefreshCommands()
			doUpdate = nil
		end

		-- create buildmenu drawlists
		if WG['guishader'] and dlistGuishader then
			WG['guishader'].InsertDlist(dlistGuishader, 'buildmenu')
		end
		if not dlistBuildmenu then
			dlistBuildmenuBg = gl.CreateList(function()
				drawBuildmenuBg()
			end)
			dlistBuildmenu = gl.CreateList(function()
				drawBuildmenu()
			end)
		end

		local hovering = false
		if math_isInRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then
			Spring.SetMouseCursor('cursornormal')
			hovering = true
		end

		-- draw buildmenu background
		gl.CallList(dlistBuildmenuBg)
		if preGamestartPlayer or selectedBuilder or selectedFactory then
			-- pre process + 'highlight' under the icons
			local hoveredCellID = nil
			local hoveredCatNotFound = true
			if not WG['topbar'] or not WG['topbar'].showingQuit() then
				if hovering then
					for cellRectID, cellRect in pairs(cellRects) do
						if math_isInRect(x, y, cellRect[1], cellRect[2], cellRect[3], cellRect[4]) then
							hoveredCellID = cellRectID
							local cmd = cellcmds[cellRectID]
							local uDefID = cmd.id * -1
							WG['buildmenu'].hoverID = uDefID
							gl.Color(1, 1, 1, 1)
							local _, _, meta, _ = Spring.GetModKeyState()
							if WG['tooltip'] and not meta then
								-- when meta: unitstats does the tooltip
								local text
								local textColor = "\255\215\255\215"

								if unitRestricted[uDefID] then
									text = Spring.I18N('ui.buildMenu.disabled', { unit = UnitDefs[uDefID].translatedHumanName, textColor = textColor, warnColor = "\255\166\166\166" })
								else
									text = textColor .. UnitDefs[uDefID].translatedHumanName
								end

								text = text .. "\n\255\240\240\240" .. UnitDefs[uDefID].translatedTooltip

								WG['tooltip'].ShowTooltip('buildmenu', text)
							end

							-- highlight --if b and not disableInput then
							gl.Blending(GL_SRC_ALPHA, GL_ONE)
							RectRound(cellRects[cellRectID][1] + cellPadding, cellRects[cellRectID][2] + cellPadding, cellRects[cellRectID][3] - cellPadding, cellRects[cellRectID][4] - cellPadding, cellSize * 0.03, 1, 1, 1, 1, { 0, 0, 0, 0.1 * ui_opacity }, { 0, 0, 0, 0.1 * ui_opacity })
							gl.Blending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
							break
						end
					end

					for cat, catRect in pairs(catRects) do
						if math_isInRect(x, y, catRect[1], catRect[2], catRect[3], catRect[4]) then
							hoveredCat = cat

							if hoveredCat ~= drawnHoveredCat then
								doUpdate = true
							end


							if WG['tooltip'] then
								-- when meta: unitstats does the tooltip
								local text
								local textColor = "\255\215\255\215"

								text = textColor .. cat
								text = text .. "\n\255\240\240\240" .. Cfgs.categoryTooltips[cat]
								local index=0
								for k,v in pairs(categories) do
									if v == cat then
										index = k
									end
								end

								local catKey = keyConfig.sanitizeKey(Cfgs.keyLayout[1][index], currentLayout)
								text = text .. "\n\255\240\240\240Hotkey: " .. textColor .. "[" .. catKey .. "]"

								WG['tooltip'].ShowTooltip('buildmenu', text)
							end

							hoveredCatNotFound = false
							break
						end
					end
				end
			end

			if (not hovering) or (selectedBuilder and hoveredCatNotFound) then
				if drawnHoveredCat then
					doUpdate = true
				end

				drawnHoveredCat = nil
				hoveredCat = nil
			end

			-- draw buildmenu content
			gl.CallList(dlistBuildmenu)

			-- draw highlight
			local usedZoom
			local cellColor
			if not WG['topbar'] or not WG['topbar'].showingQuit() then
				if math_isInRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then

					-- paginator buttons
					local paginatorHovered
					if paginatorRects[1] and math_isInRect(x, y, paginatorRects[1][1], paginatorRects[1][2], paginatorRects[1][3], paginatorRects[1][4]) then
						paginatorHovered = 1
					end
					if paginatorRects[2] and math_isInRect(x, y, paginatorRects[2][1], paginatorRects[2][2], paginatorRects[2][3], paginatorRects[2][4]) then
						paginatorHovered = 2
					end
					if paginatorHovered then
						if WG['tooltip'] then
							local text = "\255\240\240\240" .. (paginatorHovered == 1 and Spring.I18N('ui.buildMenu.previousPage') or Spring.I18N('ui.buildMenu.nextPage'))
							WG['tooltip'].ShowTooltip('buildmenu', text)
						end
						RectRound(paginatorRects[paginatorHovered][1] + cellPadding, paginatorRects[paginatorHovered][2] + cellPadding, paginatorRects[paginatorHovered][3] - cellPadding, paginatorRects[paginatorHovered][4] - cellPadding, cellSize * 0.03, 2, 2, 2, 2, { 1, 1, 1, 0 }, { 1, 1, 1, (b and 0.35 or 0.15) })
						-- gloss
						RectRound(paginatorRects[paginatorHovered][1] + cellPadding, paginatorRects[paginatorHovered][4] - cellPadding - ((paginatorRects[paginatorHovered][4] - paginatorRects[paginatorHovered][2]) * 0.5), paginatorRects[paginatorHovered][3] - cellPadding, paginatorRects[paginatorHovered][4] - cellPadding, cellSize * 0.03, 2, 2, 0, 0, { 1, 1, 1, 0.015 }, { 1, 1, 1, 0.13 })
						RectRound(paginatorRects[paginatorHovered][1] + cellPadding, paginatorRects[paginatorHovered][2] + cellPadding, paginatorRects[paginatorHovered][3] - cellPadding, paginatorRects[paginatorHovered][2] + cellPadding + ((paginatorRects[paginatorHovered][4] - paginatorRects[paginatorHovered][2]) * 0.33), cellSize * 0.03, 0, 0, 2, 2, { 1, 1, 1, 0.025 }, { 1, 1, 1, 0 })
					end

					-- cells
					if hoveredCellID then
						local uDefID = cellcmds[hoveredCellID].id * -1
						local cellIsSelected = (activeCmd and cellcmds[hoveredCellID] and activeCmd == cellcmds[hoveredCellID].name)
						if not prevHoveredCellID or hoveredCellID ~= prevHoveredCellID or uDefID ~= hoverUdefID or cellIsSelected ~= hoverCellSelected or b ~= prevB or b3 ~= prevB3 or cellcmds[hoveredCellID].params[1] ~= prevQueueNr then
							prevQueueNr = cellcmds[hoveredCellID].params[1]
							prevB = b
							prevB3 = b3
							prevHoveredCellID = hoveredCellID
							hoverUdefID = uDefID
							hoverCellSelected = cellIsSelected
							if hoverDlist then
								hoverDlist = gl.DeleteList(hoverDlist)
							end
							hoverDlist = gl.CreateList(function()

								-- determine zoom amount and cell color
								usedZoom = hoverCellZoom
								if not cellIsSelected then
									if (b or b2) and cellIsSelected then
										usedZoom = clickSelectedCellZoom
									elseif cellIsSelected then
										usedZoom = selectedCellZoom
									elseif (b or b2) and not disableInput then
										usedZoom = clickCellZoom
									elseif b3 and not disableInput and cellcmds[hoveredCellID].params[1] then
										-- has queue
										usedZoom = rightclickCellZoom
									end
									-- determine color
									if (b or b2) and not disableInput then
										cellColor = { 0.3, 0.8, 0.25, 0.2 }
									elseif b3 and not disableInput then
										cellColor = { 1, 0.35, 0.3, 0.2 }
									else
										cellColor = { 0.63, 0.63, 0.63, 0 }
									end
								else
									-- selected cell
									if (b or b2 or b3) then
										usedZoom = clickSelectedCellZoom
									else
										usedZoom = selectedCellZoom
									end
									cellColor = { 1, 0.85, 0.2, 0.25 }
								end
								if not unitRestricted[uDefID] then

									local unsetShowPrice
									if not showPrice then
										unsetShowPrice = true
										showPrice = true
									end

									drawCell(hoveredCellID, usedZoom, cellColor, unitRestricted[uDefID])

									if unsetShowPrice then
										showPrice = false
										unsetShowPrice = nil
									end
								end
							end)
						end
						if hoverDlist then
							gl.CallList(hoverDlist)
						end
					end
				end
			end

			-- draw builders buildoption progress
			if showBuildProgress then
				drawBuildProgress()
			end
		end
	end
end

function widget:DrawWorld()
	-- Avoid unnecessary overhead after buildqueue has been setup in early frames
	if Spring.GetGameFrame() > 0 then
		widgetHandler:RemoveWidgetCallIn('DrawWorld', self)

		return
	end

	if not WG.StopDrawUnitShapeGL4 then return end

		-- remove unit shape queue to re-add again later
	for id, _ in pairs(unitshapes) do
		removeUnitShape(id)
	end

	if not preGamestartPlayer then return end

	-- draw pregame build queue
	local buildDistanceColor = { 0.3, 1.0, 0.3, 0.6 }
	local buildLinesColor = { 0.3, 1.0, 0.3, 0.6 }
	local borderNormalColor = { 0.3, 1.0, 0.3, 0.5 }
	local borderClashColor = { 0.7, 0.3, 0.3, 1.0 }
	local borderValidColor = { 0.0, 1.0, 0.0, 1.0 }
	local borderInvalidColor = { 1.0, 0.0, 0.0, 1.0 }

	gl.LineWidth(1.49)

	if switchedCategory and selectNextFrame then
		setPreGamestartDefID(-selectNextFrame)
		switchedCategory = nil
		selectNextFrame = nil

		doUpdate = true
	end

	-- We need data about currently selected building, for drawing clashes etc
	local selBuildData
	if selBuildQueueDefID then
		local x, y, _ = Spring.GetMouseState()
		local _, pos = Spring.TraceScreenRay(x, y, true)
		if pos then
			local bx, by, bz = Spring.Pos2BuildPos(selBuildQueueDefID, pos[1], pos[2], pos[3])
			local buildFacing = Spring.GetBuildFacing()
			selBuildData = { selBuildQueueDefID, bx, by, bz, buildFacing }
		end
	end

	if startDefID ~= Spring.GetTeamRulesParam(myTeamID, 'startUnit') then
		startDefID = Spring.GetTeamRulesParam(myTeamID, 'startUnit')
		doUpdate = true
	end

	local sx, sy, sz = Spring.GetTeamStartPosition(myTeamID) -- Returns -100, -100, -100 when none chosen
	local startChosen = (sx ~= -100)
	if startChosen and startDefID then
		-- Correction for start positions in the air
		sy = Spring.GetGroundHeight(sx, sz)

		-- Draw start units build radius
		gl.Color(buildDistanceColor)
		gl.DrawGroundCircle(sx, sy, sz, UnitDefs[startDefID].buildDistance, 40)
	end

	-- Check for faction change
	for b = 1, #buildQueue do
		local buildData = buildQueue[b]
		local buildDataId = buildData[1]
		if startDefID == UnitDefNames["armcom"].id then
			if Cfgs.corToArm[buildDataId] ~= nil then
				buildData[1] = Cfgs.corToArm[buildDataId]
				buildQueue[b] = buildData
			end
		elseif startDefID == UnitDefNames["corcom"].id then
			if Cfgs.armToCor[buildDataId] ~= nil then
				buildData[1] = Cfgs.armToCor[buildDataId]
				buildQueue[b] = buildData
			end
		end
	end

	-- Draw all the buildings
	local queueLineVerts = startChosen and { { v = { sx, sy, sz } } } or {}
	for b = 1, #buildQueue do
		local buildData = buildQueue[b]

		if selBuildData and DoBuildingsClash(selBuildData, buildData) then
			DrawBuilding(buildData, borderClashColor)
		else
			DrawBuilding(buildData, borderNormalColor)
		end

		queueLineVerts[#queueLineVerts + 1] = { v = { buildData[2], buildData[3], buildData[4] } }
	end

	-- Draw queue lines
	gl.Color(buildLinesColor)
	gl.LineStipple("springdefault")
	gl.Shape(GL.LINE_STRIP, queueLineVerts)
	gl.LineStipple(false)

	-- Draw selected building
	if selBuildData then
		if Spring.TestBuildOrder(selBuildQueueDefID, selBuildData[2], selBuildData[3], selBuildData[4], selBuildData[5]) ~= 0 then
			DrawBuilding(selBuildData, borderValidColor, true)
		else
			DrawBuilding(selBuildData, borderInvalidColor, true)
		end
	end

	-- Reset gl
	gl.Color(1, 1, 1, 1)
	gl.LineWidth(1.0)
end

function widget:UnitCommand(_, unitDefID, _, cmdID)
	if isFactory[unitDefID] and cmdID < 0 then
		-- filter away non build cmd's
		if doUpdateClock == nil then
			doUpdateClock = os.clock() + 0.01
		end
	end
end

function widget:SelectionChanged()
	updateSelection = true
end

local function GetUnitCanCompleteQueue(uID)
	local uDefID = Spring.GetUnitDefID(uID)
	if uDefID == startDefID then
		return true
	end

	-- What can this unit build ?
	local uCanBuild = {}
	local uBuilds = UnitDefs[uDefID].buildOptions
	for i = 1, #uBuilds do
		uCanBuild[uBuilds[i]] = true
	end

	-- Can it build everything that was queued ?
	for i = 1, #buildQueue do
		if not uCanBuild[buildQueue[i][1]] then
			return false
		end
	end

	return true
end

function widget:GameStart()
	preGamestartPlayer = false

	-- Deattach pregame action handlers
	widgetHandler.actionHandler:RemoveAction(self, "stop")
	widgetHandler.actionHandler:RemoveAction(self, "buildfacing")
	widgetHandler.actionHandler:RemoveAction(self, "buildmenu_pregame_deselect")
end

function widget:GameFrame(n)
	-- Avoid unnecessary overhead after buildqueue has been setup in early frames
	if #buildQueue == 0 then
		widgetHandler:RemoveWidgetCallIn('GameFrame', self)
		return
	end

	-- handle the pregame build queue
	if not (n <= 90 and n > 1) then return end

	-- inform gadget how long is our queue
	local t = 0
	for i = 1, #buildQueue do
		t = t + UnitDefs[buildQueue[i][1]].buildTime
	end
	if startDefID then
		local buildTime = t / UnitDefs[startDefID].buildSpeed
		Spring.SendCommands("luarules initialQueueTime " .. buildTime)
	end

	local tasker
	-- Search for our starting unit
	local units = Spring.GetTeamUnits(Spring.GetMyTeamID())
	for u = 1, #units do
		local uID = units[u]
		if GetUnitCanCompleteQueue(uID) then
			tasker = uID
			if Spring.GetUnitRulesParam(uID, "startingOwner") == Spring.GetMyPlayerID() then
				-- we found our com even if cooping, assigning queue to this particular unit
				break
			end
		end
	end
	if tasker then
		for b = 1, #buildQueue do
			local buildData = buildQueue[b]
			Spring.GiveOrderToUnit(tasker, -buildData[1], { buildData[2], buildData[3], buildData[4], buildData[5] }, { "shift" })
		end
		buildQueue = {}
	end
end

function SetBuildFacing()
	local wx, wy, _, _ = Spring.GetScreenGeometry()
	local _, pos = Spring.TraceScreenRay(wx / 2, wy / 2, true)
	if not pos then
		return
	end
	local x = pos[1]
	local z = pos[3]

	local facing
	if math.abs(Game.mapSizeX - 2 * x) > math.abs(Game.mapSizeZ - 2 * z) then
		if 2 * x > Game.mapSizeX then
			facing = 3
		else
			facing = 1
		end
	else
		if 2 * z > Game.mapSizeZ then
			facing = 2
		else
			facing = 0
		end
	end
	Spring.SetBuildFacing(facing)
end

function widget:KeyRelease(key)
	if key == KEYSYMS.LSHIFT then
		currentBuildCategory = nil
		currentCategoryIndex = nil
		doUpdate = true
	end
end

function widget:MousePress(x, y, button)
	if Spring.IsGUIHidden() then
		return
	end
	if WG['topbar'] and WG['topbar'].showingQuit() then
		return
	end

	if math_isInRect(x, y, backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4]) then
		if selectedBuilder or selectedFactory or (preGamestartPlayer and startDefID) then
			if paginatorRects[1] and math_isInRect(x, y, paginatorRects[1][1], paginatorRects[1][2], paginatorRects[1][3], paginatorRects[1][4]) then
				currentPage = math_max(1, currentPage - 1)
				Spring.PlaySoundFile(Cfgs.sound_queue_add, 0.75, 'ui')
				doUpdate = true
				return true
			elseif paginatorRects[2] and math_isInRect(x, y, paginatorRects[2][1], paginatorRects[2][2], paginatorRects[2][3], paginatorRects[2][4]) then
				currentPage = math_min(pages, currentPage + 1)
				Spring.PlaySoundFile(Cfgs.sound_queue_add, 0.75, 'ui')
				doUpdate = true
				return true
			end

			if not disableInput then
				for cat, catRect in pairs(catRects) do
					if math_isInRect(x, y, catRect[1], catRect[2], catRect[3], catRect[4]) then
						currentBuildCategory = cat
						switchedCategory = os.clock()
						Spring.PlaySoundFile(Cfgs.sound_queue_add, 0.75, 'ui')

						for i,c in pairs(categories) do
							 if c == cat then
								 currentCategoryIndex = i
							 end
						end

						doUpdate = true
						return true
					end
				end

				for cellRectID, cellRect in pairs(cellRects) do
					if cellcmds[cellRectID].id and UnitDefs[-cellcmds[cellRectID].id].translatedHumanName and math_isInRect(x, y, cellRect[1], cellRect[2], cellRect[3], cellRect[4]) and not unitRestricted[-cellcmds[cellRectID].id] then
						if button ~= 3 then
							Spring.PlaySoundFile(Cfgs.sound_queue_add, 0.75, 'ui')

							if preGamestartPlayer then
								setPreGamestartDefID(cellcmds[cellRectID].id * -1)
							elseif spGetCmdDescIndex(cellcmds[cellRectID].id) then
								Spring.SetActiveCommand(spGetCmdDescIndex(cellcmds[cellRectID].id), 1, true, false, Spring.GetModKeyState())
							end
						elseif selectedFactory and spGetCmdDescIndex(cellcmds[cellRectID].id) then
							Spring.PlaySoundFile(Cfgs.sound_queue_rem, 0.75, 'ui')
							Spring.SetActiveCommand(spGetCmdDescIndex(cellcmds[cellRectID].id), 3, false, true, Spring.GetModKeyState())
						end
						doUpdateClock = os.clock() + 0.01
						return true
					end
				end
			end
			return true
		elseif alwaysShow then
			return true
		end

	elseif preGamestartPlayer then

		if selBuildQueueDefID then
			if button == 1 then
				local pos
				local curMexPosition = WG.MexSnap and WG.MexSnap.curPosition

				if curMexPosition then
					pos = { curMexPosition.x, curMexPosition.y, curMexPosition.z }
				else
					local mx, my = Spring.GetMouseState()
					_, pos = Spring.TraceScreenRay(mx, my, true)
				end

				if not pos then
					return
				end

				local bx, by, bz = Spring.Pos2BuildPos(selBuildQueueDefID, pos[1], pos[2], pos[3])
				local buildFacing = Spring.GetBuildFacing()

				if Spring.TestBuildOrder(selBuildQueueDefID, bx, by, bz, buildFacing) ~= 0 then

					local buildData = { selBuildQueueDefID, bx, by, bz, buildFacing }
					local _, _, meta, shift = Spring.GetModKeyState()
					if meta then
						table.insert(buildQueue, 1, buildData)

					elseif shift then

						local anyClashes = false
						for i = #buildQueue, 1, -1 do
							if DoBuildingsClash(buildData, buildQueue[i]) then
								anyClashes = true
								table.remove(buildQueue, i)
							end
						end

						if not anyClashes then
							buildQueue[#buildQueue + 1] = buildData
						end
					else
						buildQueue = { buildData }
					end

					if not shift then
						setPreGamestartDefID(nil)
					end
				end

				return true
			elseif button == 3 then
				setPreGamestartDefID(nil)
			end
		end
	elseif selectedBuilder and button == 3 then
		currentBuildCategory = nil
		currentCategoryIndex = nil
		doUpdate = true
	end
end

function widget:Shutdown()
	clear()
	hoverDlist = gl.DeleteList(hoverDlist)
	if WG['guishader'] and dlistGuishader then
		WG['guishader'].DeleteDlist('buildmenu')
		dlistGuishader = nil
	end
	WG['buildmenu'] = nil
	if WG.StopDrawUnitShapeGL4 then
		for id, _ in pairs(unitshapes) do
			removeUnitShape(id)
		end
	end
end

function widget:GetConfigData()
	return {
		showPrice = showPrice,
		showRadarIcon = showRadarIcon,
		showGroupIcon = showGroupIcon,
		buildQueue = buildQueue,
		stickToBottom = stickToBottom,
		gameID = Game.gameID,
		alwaysShow = alwaysShow,
	}
end

function widget:SetConfigData(data)
	if data.showPrice ~= nil then
		showPrice = data.showPrice
	end
	if data.showRadarIcon ~= nil then
		showRadarIcon = data.showRadarIcon
	end
	if data.showGroupIcon ~= nil then
		showGroupIcon = data.showGroupIcon
	end
	if data.stickToBottom ~= nil then
		stickToBottom = data.stickToBottom
	end
	if data.buildQueue and Spring.GetGameFrame() == 0 and data.gameID and data.gameID == Game.gameID then
		buildQueue = data.buildQueue
	end
	if data.alwaysShow ~= nil then
		alwaysShow = data.alwaysShow
	end
end

function GiveOrderToFactories(cmd, data)
	data = data or {}

	local udTable = Spring.GetSelectedUnitsSorted()
	udTable.n = nil
	for _, uTable in pairs(udTable) do
		for _, uid in ipairs(uTable) do
			Spring.GiveOrderToUnit(uid, cmd, data, 0)
		end
	end
end
