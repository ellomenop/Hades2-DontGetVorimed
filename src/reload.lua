---@meta _
---@diagnostic disable: lowercase-global

-- When the first room is created, set the number of loot choices to 5
-- This will persist until the first boon reward is received or rolled over
function ChooseStartingRoom_wrap( base, ... )
	print("ChooseStartingRoom")
    if config.Enabled then
        rom.mods['ellomenop-LootChoiceExtension'].config.Choices = config.NumberOfChoices
        config.BoonTakenFlag = false
    end
    return base(...)
end

function CreateLoot_wrap( baseFunc, args )
	print("CreateLoot")
	-- FieldLootData ?
    local lootData = args.LootData or LootData[args.Name]
	-- TreatAsGodLootByShops?
    if not lootData.GodLoot and not config.BoonTakenFlag then
        rom.mods['ellomenop-LootChoiceExtension'].config.Choices = 3
        rom.mods['ellomenop-LootChoiceExtension'].config.LastLootChoices = 3
    end

    return baseFunc(args)
end

-- After first boon reward has been selected, return to normal number of choices
function HandleUpgradeChoiceSelection_wrap( base, screen, button, args )
	print("HandleUpgradeChoiceSelection, boon taken: " .. tostring(config.BoonTakenFlag) .. ", upgradeableGodTraits: " .. tostring(#GetAllUpgradeableGodTraits()))
    if not config.BoonTakenFlag and #GetAllUpgradeableGodTraits() == 0 then
        if button.LootData.GodLoot ~= nil then
            rom.mods['ellomenop-LootChoiceExtension'].config.Choices = 3
            rom.mods['ellomenop-LootChoiceExtension'].config.LastLootChoices = 3
            config.BoonTakenFlag = true
        else
            -- reset to 5 options after selecting a hammer/chaos before first boon has been taken
            rom.mods['ellomenop-LootChoiceExtension'].config.Choices = config.NumberOfChoices
            rom.mods['ellomenop-LootChoiceExtension'].config.LastLootChoices = config.NumberOfChoices
        end
    end

    base(screen, button, args)
end

-- Removing Approval Process blockers on the 5-core boon
function CalcNumLootChoices_wrap( base, isGodLoot, treatAsGodLootByShops )
	print("CalcNumLootChoices")
    if rom.mods['ellomenop-LootChoiceExtension'].config.Choices == config.NumberOfChoices then
		if (isGodLoot or treatAsGodLootByShops) and HasHeroTraitValue("RestrictBoonChoices") then
			return base(isGodLoot, treatAsGodLootByShops) + GetNumMetaUpgrades("ReducedLootChoicesShrineUpgrade") + 1
		else
        	return base(isGodLoot, treatAsGodLootByShops) + GetNumMetaUpgrades("ReducedLootChoicesShrineUpgrade")
		end
    else
        return base(isGodLoot, treatAsGodLootByShops)
    end
end

-- If the player ever rerolls, reduce to 3 options
function DestroyBoonLootButtons_wrap( base, screen, lootData )
	print("DestroyBoonLootButtons, boon taken: " .. tostring(config.BoonTakenFlag) .. ", godloot: " .. tostring(lootData.GodLoot))
    base(screen, lootData)
	print("DestroyBoonLootButtons, boon taken: " .. tostring(config.BoonTakenFlag) .. ", godloot: " .. tostring(lootData.GodLoot))
    if lootData.GodLoot and not config.BoonTakenFlag then
        rom.mods['ellomenop-LootChoiceExtension'].config.Choices = 3
        rom.mods['ellomenop-LootChoiceExtension'].config.LastLootChoices = 3
        config.BoonTakenFlag = true
    end
end