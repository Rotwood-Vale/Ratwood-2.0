/obj/item/clothing/suit/roguetown/armor/plate/voidarmor
	slot_flags = ITEM_SLOT_ARMOR
	name = "Modular combat spacesuit"
	desc = "A super-durable combat suit made from adaptive materials. Violium fibers and energy fabric allow it to absorb kinetic energy. Ultratech technology. The plates never quite hold still."
	body_parts_covered = NECK | BELOW_HEAD

	mob_overlay_icon = 'modular_fenysha_events/icons/mob/onmob_armor.dmi'
	armor = ARMOR_VOIDCOMBAT
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PUNCH, BCLASS_BURN, BCLASS_PUNISH, BCLASS_SUNDER)
	resistance_flags = FIRE_PROOF|LAVA_PROOF|ACID_PROOF|FREEZE_PROOF
	nodismemsleeves = FALSE
	max_integrity = 999999
	allowed_sex = list(MALE, FEMALE)
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_HEAVY
	peel_threshold = 4
	smelt_bar_num = 3

	/// Weakref to the mob currently wearing the suit, for cleanup.
	var/datum/weakref/void_wearer

/obj/item/clothing/suit/roguetown/armor/plate/voidarmor/Initialize(mapload)
	. = ..()
	setup_voidarmor_visuals(src)

/obj/item/clothing/suit/roguetown/armor/plate/voidarmor/Destroy()
	var/mob/living/carbon/human/H = void_wearer?.resolve()
	if(H)
		clear_voidarmor_visuals(H)
	void_wearer = null
	clear_voidarmor_visuals(src)
	return ..()

/obj/item/clothing/suit/roguetown/armor/plate/voidarmor/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	// Only when actually worn as armor, not held in hand.
	if(slot != SLOT_ARMOR && slot != ITEM_SLOT_ARMOR)
		return
	var/mob/living/carbon/human/H = user
	void_wearer = WEAKREF(H)
	setup_voidarmor_visuals(H)
	to_chat(H, span_fractal_whisper("The suit settles against you. The plates begin to breathe."))

/obj/item/clothing/suit/roguetown/armor/plate/voidarmor/dropped(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = void_wearer?.resolve()
	if(!H)
		H = ishuman(user) ? user : null
	if(H)
		clear_voidarmor_visuals(H)
	void_wearer = null


/obj/item/clothing/suit/roguetown/armor/plate/voidarmor/mob_can_equip(mob/M, mob/equipper, slot, disable_warning)
	return length(M.faction) && ("void" in M.faction)

/**
 * Wave + outline on any atom/movable (the item itself, or the wearer).
 * Matches the mutant's fractal_wave language, softer so it reads as gear not flesh.
 */
/obj/item/clothing/suit/roguetown/armor/plate/voidarmor/proc/setup_voidarmor_visuals(atom/movable/target)
	if(!target || QDELETED(target))
		return

	target.remove_filter("voidarmor_wave")
	target.remove_filter("voidarmor_ripple")
	target.remove_filter("voidarmor_outline")

	target.add_filter("voidarmor_wave", 1, list(
		"type" = "wave",
		"size" = 1.2,
		"x" = 8,
		"y" = 8,
		"offset" = 0
	))
	var/wave = target.get_filter("voidarmor_wave")
	if(wave)
		animate(wave, offset = 80, time = 40, loop = -1, flags = ANIMATION_PARALLEL)
		animate(offset = 10, time = 40)

	target.add_filter("voidarmor_ripple", 2, list(
		"type" = "wave",
		"size" = 0.6,
		"x" = 3,
		"y" = 10,
		"offset" = 15
	))
	var/ripple = target.get_filter("voidarmor_ripple")
	if(ripple)
		animate(ripple, offset = 50, time = 55, loop = -1, flags = ANIMATION_PARALLEL)
		animate(offset = 5, time = 55)

	target.add_filter("voidarmor_outline", 3, list(
		"type" = "outline",
		"color" = "#6b3fa066",
		"size" = 1
	))

	start_voidarmor_pulse(target)

/**
 * Soft scale pulse — same idea as fractal_mutant/start_fractal_pulse, gentler.
 * Only on the ITEM when on the ground; on the WEARER when equipped so the whole
 * silhouette breathes with the suit.
 */
/obj/item/clothing/suit/roguetown/armor/plate/voidarmor/proc/start_voidarmor_pulse(atom/movable/target)
	if(!target || QDELETED(target))
		return

	// Do not stack transform loops if called twice.
	animate(target, transform = matrix(), time = 0)

	var/matrix/M1 = matrix()
	M1.Scale(1.03, 0.97)
	var/matrix/M2 = matrix()
	M2.Scale(0.97, 1.03)
	var/matrix/M_reset = matrix()

	animate(target, transform = M1, time = 5, loop = -1, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
	animate(transform = M2, time = 5, easing = SINE_EASING)
	animate(transform = M_reset, time = 8)

/obj/item/clothing/suit/roguetown/armor/plate/voidarmor/proc/clear_voidarmor_visuals(atom/movable/target)
	if(!target || QDELETED(target))
		return
	target.remove_filter("voidarmor_wave")
	target.remove_filter("voidarmor_ripple")
	target.remove_filter("voidarmor_outline")
	// Kill any leftover transform loop
	animate(target, transform = matrix(), time = 0)


/mob/living/carbon/human/species/human/northern/dunewell_raider
