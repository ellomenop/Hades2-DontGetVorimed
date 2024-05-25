---@meta _
---@diagnostic disable: lowercase-global

modutil.mod.Path.Wrap("ChooseStartingRoom", function(base, ...)
	return ChooseStartingRoom_wrap(base, ...)
end)

modutil.mod.Path.Wrap("CreateLoot", function(base, args)
	return CreateLoot_wrap( base, args )
end)

modutil.mod.Path.Wrap("HandleUpgradeChoiceSelection", function(base, screen, button, args)
	return HandleUpgradeChoiceSelection_wrap(base, screen, button, args)
end)

modutil.mod.Path.Wrap("CalcNumLootChoices", function(base, isGodLoot, treatAsGodLootByShops)
	return CalcNumLootChoices_wrap( base, isGodLoot, treatAsGodLootByShops )
end)

modutil.mod.Path.Wrap("DestroyBoonLootButtons", function(base, screen, lootData)
	return DestroyBoonLootButtons_wrap( base, screen, lootData )
end)