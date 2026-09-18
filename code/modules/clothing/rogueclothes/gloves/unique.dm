/obj/item/clothing/gloves/roguetown/elven_gloves
	name = "woad elven gloves"
	desc = "The insides are lined with soft, living leaves and soil. They wick away moisture easily."
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfhand"
	item_state = "welfhand"
	armor = ARMOR_BLACKOAK //Resistant to blunt and stab, super weak to slash.
	prevent_crits = list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK)
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_IRON
	smeltresult = /obj/item/rogueore/coal
	anvilrepair = /datum/skill/craft/carpentry
	sewrepair = FALSE
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/// Dendor ritual variant of the woad elven gloves — grown from the Treefather's sanctified root.
/obj/item/clothing/gloves/roguetown/elven_gloves/druidic
	name = "blessed druid gloves"
	desc = "Gauntlets woven from roots nurtured by the Treefather's blessing. The living wood absorbs impacts and softens cuts that would otherwise tear through."
	armor = list("blunt" = 100, "slash" = 65, "stab" = 130, "piercing" = 20, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/roguetown/elven_gloves/druidic/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/clothing/gloves/roguetown/elven_gloves/druidic/pickup(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type == /datum/patron/divine/dendor)
		return
	H.electrocute_act(30, src)
	H.mob_timers["kneestinger"] = world.time
	to_chat(H, span_warning("[name] rejects my grasp — only the Treefather's faithful may bear such a gift!"))

/obj/item/clothing/gloves/roguetown/bandages
	name = "bandages"
	desc = "Thickly-woven bandages that've been wrapped around the hands. It soaks up the sweat from your palm, strengthens your fists, and protects your knuckles from dislodged teeth."
	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon_state = "clothwraps"
	item_state = "clothwraps"
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT)
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/cloth
	unarmed_bonus = 1.125 //Sublight armor with minimal durability, but a greater unarmed damage multiplier. More damage than leather, less than maille. Loadout-selectable.
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/bandages/weighted
	name = "weighted bandages"
	desc = "Thickly-woven bandages that've been wrapped around the hands, fitted with padded knuckleweights. It soaks up the sweat from your palm, strengthens your fists, and protects your knuckles from dislodged teeth."
	unarmed_bonus = 1.225 //Craftable. Given to non-specialized Monks and other certain subclasses. Provides a +25% unarmed damage bonus over plate gauntlets.

/obj/item/clothing/gloves/roguetown/bandages/pugilist
	name = "pugilistic bandages"
	desc = "Thickly-woven bandages that've been wrapped around the hands, fitted with alloyed knuckleweights. It soaks up the sweat from your palm, strengthens your fists, and protects your knuckles from dislodged teeth."
	unarmed_bonus = 1.3 //Non-craftable. Restricted to Monks who've specialized in unarmed combat, and nothing else.

/obj/item/clothing/gloves/roguetown/bandages/abboteer
	name = "abboteer's wraps"
	desc = "NODD 6:20... We must love everyone, regardless if they love us or not; guide them to brevity with a opened palm, nary-a-clenched fist."
	unarmed_bonus = 1.3
	unarmed_weapon_effects = TRUE
	is_silver = TRUE

/obj/item/clothing/gloves/roguetown/bandages/abboteer/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/clothing/gloves/roguetown/bandages/weighted/caestus
	name = "caestus"
	desc = "An antique fighting glove fashioned from hard leather straps wrapped tightly around the hand. This pair was customized with gruesome-looking bronze spikes along the knuckles. Modifications like this are common among thespian performers; after all, a bloodless fight makes for lacking spectacle."
	icon_state = "caestus"
	item_state = "caestus"
	unarmed_bonus = 1.3
	armor = ARMOR_BRONZE
	max_integrity = ARMOR_INT_SIDE_BRONZE
	salvage_result = /obj/item/natural/hide/cured
