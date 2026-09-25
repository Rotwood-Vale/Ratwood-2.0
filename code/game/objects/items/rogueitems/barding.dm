/obj/item/clothing/barding
	name = "padded barding"
	desc = "A set of padded body armor for a Saiga, designed to protect your mount's vital organs. Slightly slows down your mount."
	slot_flags = null
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "sewingkit"
	var/barding_icon = 'icons/roguetown/mob/monster/saiga.dmi'
	var/barding_state = "barding"
	var/female_barding_state = "barding-f"
	gender = NEUTER
	var/list/valid_animal_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga
	)
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	fiber_salvage = TRUE
	integrity_failure = 0.1
	/// slowdown for barding. Multiplicative.
	var/slowdown_factor = 1.1
	/// For mounts with a strong hide, works same as regenerating.dm armors
	var/natural_armor = FALSE

/obj/item/clothing/barding/attack(mob/living/M, mob/living/user)
	if(!issimple(M))
		to_chat(user, span_warning("\The [src] can only be used on animals!"))
		return
	if(!is_type_in_list(M, valid_animal_types))
		to_chat(user, span_warning("\The [src] cannot be used on [M]! It is only meant for specific animals."))
		return

	var/mob/living/simple_animal/animal = M
	if(animal.adult_growth)
		to_chat(user, span_warning("[animal] is a juvenile and cannot wear a bard!"))
		return
	if(animal.bbarding)
		to_chat(user, span_warning("[animal] is already wearing a bard!"))
		return
	if(!animal.ssaddle)
		to_chat(user, span_warning("[animal] needs to be saddled before you can fit a bard onto it!"))
		return
	if(user.buckled)
		to_chat(user, span_warning("You need to hop off [user.buckled] before you can drape [src] on [animal]."))
		return

	user.visible_message(span_notice("[user] is fitting a bard onto [animal]..."), span_notice("I start fitting a bard onto [animal]..."))
	if(!do_after(user, 5 SECONDS, TRUE, animal))
		return

	animal.bbarding = src
	forceMove(animal)
	animal.barding_speed_mult = slowdown_factor
	animal.updatehealth()
	animal.update_icon()
	user.visible_message(span_notice("[user] fits a bard onto [animal]."), span_notice("I fit a bard onto [animal]."))

/obj/item/clothing/barding/obj_destruction(damage_flag)
	if(istype(loc, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = loc
		if(A.bbarding == src)
			A.bbarding = null
			A.barding_speed_mult = 1
			A.updatehealth()
	. = ..()

/obj/item/clothing/barding/chain
	name = "chainmail barding"
	desc = "A set of chainmail body armor for a Saiga, designed to protect your mount's vital organs. Slows down your mount by a mild degree."
	icon_state = "armorkit"
	barding_state = "barding_chain"
	female_barding_state = "barding_chain-f"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	sewrepair = FALSE
	salvage_result = null
	salvage_amount = 0
	fiber_salvage = FALSE
	slowdown_factor = 1.2

/obj/item/clothing/barding/fogbeast
	name = "padded barding"
	desc = "A set of padded body armor for a Fogbeast, designed to protect your mount's vital organs."
	icon_state = "sewingkit"
	barding_icon = 'icons/roguetown/mob/monster/fogbeast.dmi'
	barding_state = "barding"
	female_barding_state = "barding"
	valid_animal_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/fogbeast
	)

/obj/item/clothing/barding/fogbeast/chain
	name = "chainmail barding"
	desc = "A set of chainmail body armor for a Fogbeast, designed to protect your mount's vital organs."
	icon_state = "armorkit"
	barding_state = "barding_chain"
	female_barding_state = "barding_chain"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	sewrepair = FALSE
	salvage_result = null
	salvage_amount = 0
	fiber_salvage = FALSE

/obj/item/clothing/barding/drider
	name = "drider chitin"
	desc = "A drider's tough, living carapace."
	icon = null
	icon_state = null
	invisibility = INVISIBILITY_ABSTRACT
	barding_icon = null
	barding_state = null
	female_barding_state = null
	valid_animal_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/drider)
	armor = ARMOR_BRIGANDINE//The drow hunting sword/thrusting longsword is specifically designed to puncture through drider armor. Only 40 stab prot.
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE
	natural_armor = TRUE
	slowdown_factor = 1//it's part of their body, sire
	sewrepair = FALSE
	salvage_result = null
	salvage_amount = 0
	fiber_salvage = FALSE
	break_sound = null
	drop_sound = null
	var/repair_time = 40 SECONDS//20% integ every 40 seconds
	var/repair_timer

/obj/item/clothing/barding/drider/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)

/obj/item/clothing/barding/drider/Destroy()
	deltimer(repair_timer)
	return ..()

/obj/item/clothing/barding/drider/take_damage(damage_amount, damage_type = BRUTE, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(. && !repair_timer)
		repair_timer = addtimer(CALLBACK(src, PROC_REF(regenerate)), repair_time, TIMER_STOPPABLE)

/obj/item/clothing/barding/drider/obj_destruction(damage_flag)
	//chitin stays attached so it can regenerate even from zero integ.
	return FALSE

/obj/item/clothing/barding/drider/proc/regenerate()
	repair_timer = null
	var/mob/living/simple_animal/hostile/retaliate/rogue/drider/animal = loc
	if(!istype(animal) || QDELETED(animal) || animal.stat == DEAD || animal.bbarding != src)
		return
	obj_integrity = min(obj_integrity + 0.2 * max_integrity, max_integrity)
	if(obj_broken)
		obj_fix(full_repair = FALSE)
	if(obj_integrity < max_integrity)
		repair_timer = addtimer(CALLBACK(src, PROC_REF(regenerate)), repair_time, TIMER_STOPPABLE)
