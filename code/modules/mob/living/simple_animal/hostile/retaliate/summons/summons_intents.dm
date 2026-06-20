/datum/intent/simple/elemental_unarmed
	name = "elemental unarmed"
	icon_state = "instrike"
	attack_verb = list("拳击", "击打", "滚压", "碾碎")
	animname = "blank22"
	blade_class = BCLASS_BLUNT
	hitsound = null
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 3

/datum/intent/simple/elementalt2_unarmed
	name = "elemental unarmed"
	icon_state = "instrike"
	attack_verb = list("拳击", "击打", "踢", "踩踏", "碾碎")
	animname = "blank22"
	blade_class = BCLASS_SMASH
	hitsound = null
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 3

/datum/intent/simple/elementalt2_unarmed/lesser_dryad
	swingdelay = 2 // ~50% faster attack speed than the base dryad (swingdelay 3 → 2)
