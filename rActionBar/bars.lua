
-- rActionBar: bars
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Init
-----------------------------

--BagBar
function rActionBar:CreateBagBar(addonName,cfg)
  cfg.blizzardBar = nil
  cfg.frameName = (addonName or A).."BagBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle] hide; show"
  local buttonList = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--MicroMenuBar
function rActionBar:CreateMicroMenuBar(addonName,cfg)
  cfg.blizzardBar = nil
  cfg.frameName = (addonName or A).."MicroMenuBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle] hide; show"
  local buttonList = {}
  for idx, buttonName in next, MICRO_BUTTONS do
    local button = _G[buttonName]
    if button and button:IsShown() then
      if buttonName == "StoreMicroButton" then
         table.insert(buttonList, #buttonList, button) --storemicrobutton fix
      else
         table.insert(buttonList, button)
      end
    end
  end
  --achievement micro button has wrong alpha on first login when buttons are reparented to early, delay bar creation
  local function OnLogin(...)
    local frame = L:CreateButtonFrame(cfg,buttonList)
  end
  rLib:RegisterCallback("PLAYER_LOGIN", OnLogin)
  --special
  PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil)
  OverrideActionBar:SetScript("OnShow", nil)
  MainMenuBar:SetScript("OnShow", nil)
end

--Bar1
function rActionBar:CreateActionBar1(addonName,cfg)
  L:HideMainMenuBar()
  cfg.blizzardBar = nil
  cfg.frameName = (addonName or A).."Bar1"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle] hide; show"
  cfg.buttonName = "ActionButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --_onstate-page state driver
  for i, button in next, buttonList do
    frame:SetFrameRef(cfg.buttonName..i, button)
  end
  frame:Execute(([[
    buttons = table.new()
    for i=1, %d do
      table.insert(buttons, self:GetFrameRef("%s"..i))
    end
  ]]):format(cfg.numButtons, cfg.buttonName))
  frame:SetAttribute("_onstate-page", [[
    for i, button in next, buttons do
      button:SetAttribute("actionpage", newstate)
    end
  ]])
  RegisterStateDriver(frame, "page", "[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;1")
end

--Bar2
function rActionBar:CreateActionBar2(addonName,cfg)
  cfg.blizzardBar = MultiBarBottomLeft
  cfg.frameName = (addonName or A).."Bar2"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  cfg.buttonName = "MultiBarBottomLeftButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar3
function rActionBar:CreateActionBar3(addonName,cfg)
  cfg.blizzardBar = MultiBarBottomRight
  cfg.frameName = (addonName or A).."Bar3"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  cfg.buttonName = "MultiBarBottomRightButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar4
function rActionBar:CreateActionBar4(addonName,cfg)
  cfg.blizzardBar = MultiBarRight
  cfg.frameName = (addonName or A).."Bar4"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  cfg.buttonName = "MultiBarRightButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--Bar5
function rActionBar:CreateActionBar5(addonName,cfg)
  cfg.blizzardBar = MultiBarLeft
  cfg.frameName = (addonName or A).."Bar5"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  cfg.buttonName = "MultiBarLeftButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
end

--StanceBar
function rActionBar:CreateStanceBar(addonName,cfg)
  cfg.blizzardBar = StanceBarFrame
  cfg.frameName = (addonName or A).."StanceBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
  cfg.buttonName = "StanceButton"
  cfg.numButtons = NUM_STANCE_SLOTS
  --delay bar creation until we know for sure that the character has any stances
  local function OnLogin(...)
    if GetNumShapeshiftForms() == 0 then return end
    local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
    local frame = L:CreateButtonFrame(cfg,buttonList)
  end
  rLib:RegisterCallback("PLAYER_LOGIN", OnLogin)
  --special
  StanceBarLeft:SetTexture(nil)
  StanceBarMiddle:SetTexture(nil)
  StanceBarRight:SetTexture(nil)
end

--PetBar
function rActionBar:CreatePetBar(addonName,cfg)
  cfg.blizzardBar = PetActionBarFrame
  cfg.frameName = (addonName or A).."PetBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide"
  cfg.buttonName = "PetActionButton"
  cfg.numButtons = NUM_PET_ACTION_SLOTS
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  SlidingActionBarTexture0:SetTexture(nil)
  SlidingActionBarTexture1:SetTexture(nil)
end

--ExtraBar
function rActionBar:CreateExtraBar(addonName,cfg)
  cfg.blizzardBar = ExtraActionBarFrame
  cfg.frameName = (addonName or A).."ExtraBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[extrabar] show; hide"
  cfg.buttonName = "ExtraActionButton"
  cfg.numButtons = NUM_ACTIONBAR_BUTTONS
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --special
  ExtraActionBarFrame.ignoreFramePositionManager = true
end

--VehicleExitBar
function rActionBar:CreateVehicleExitBar(addonName,cfg)
  cfg.blizzardBar = nil
  cfg.frameName = (addonName or A).."VehicleExitBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[canexitvehicle] show; hide"
  local buttonList = { OverrideActionBar.LeaveButton }
  local frame = L:CreateButtonFrame(cfg, buttonList)
end

--PossessExitBar, this is the two button bar to cancel a possess in progress
function rActionBar:CreatePossessExitBar(addonName,cfg)
  cfg.blizzardBar = PossessBarFrame
  cfg.frameName = (addonName or A).."PossessExitBar"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = "SecureHandlerStateTemplate"
  cfg.frameVisibility = cfg.frameVisibility or "[possessbar] show; hide"
  cfg.buttonName = "PossessButton"
  cfg.numButtons = NUM_POSSESS_SLOTS
  local buttonList = L:GetButtonList(cfg.buttonName, cfg.numButtons)
  local frame = L:CreateButtonFrame(cfg,buttonList)
  --frame test
--  local t = frame:CreateTexture(nil,"BACKGROUND",nil,-8)
--  t:SetAllPoints()
--  t:SetColorTexture(0,0,0)
--  t:SetVertexColor(0,0,0)
--  t:SetAlpha(0.3)
  --special
  PossessBackground1:SetTexture(nil)
  PossessBackground2:SetTexture(nil)
end