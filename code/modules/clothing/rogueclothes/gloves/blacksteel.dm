/obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves
	name = "blacksteel plate gauntlets"
	desc = "A set of plate gauntlets forged of blacksteel, using a modern design."
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplategloves"
	item_state = "bplategloves"
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = list(BCLASS_CHOP, BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	resistance_flags = FIRE_PROOF
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/clothing/gloves/roguetown/blacksteel/plategloves
	name = "ancient blacksteel plate gauntlets"
	desc = "A set of plate gauntlets forged of blacksteel."
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bkgloves"
	item_state = "bkgloves"
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = list(BCLASS_CHOP, BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	resistance_flags = FIRE_PROOF
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/clothing/wrists/roguetown/bracers/blacksteel
	name = "ancient blacksteel bracers"
	desc = "Antiquated wristguards of blacksteel, forgotten-yet-enduring after all this time. Who are you to know what awaits after lyfe, so fleeting yet fascinating? </br>	</br>Only the first tyme around is free; make the most of it, however you see fit."
	icon_state = "bsbracersclassic"
	smeltresult = /obj/item/ingot/blacksteel
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/wrists/roguetown/bracers/blacksteel/modern
	name = "blacksteel bracers"
	desc = "Alloyed plate bracers, meticulously assembled from blacksteel. Besilked straps peek out from both ends; soft enough to barely impede finer movements, while still strong enough to lock a pair of accompying gauntlets-and-couters into place."
	icon_state = "bsbracers"
