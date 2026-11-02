//Crossbow man.
//He gets silver stakes.
//He gets a bolt that exposes and blinds.
//He gets a big 'fuck off' crossbow.
//Entirely focused around range. Knives for good measure.
/datum/advclass/arbalist
	name = "Arbalist"
	tutorial = "They'd pulled you from the line. To be a Confessor was your fate. Now? You're one of the Inquisitor's sharpest, of eye and steady hand alike. \
	Armed with your beloved sauterelle, you'll drive back the dark. One stake at a time."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/arbalist
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/psydonite.ogg'
	category_tags = list(CTAG_INQUISITION)
	traits_applied = list(
		TRAIT_PERFECT_TRACKER,
		TRAIT_SLEUTH,
	)
	vice_restrictions = list(/datum/charflaw/hemophage, /datum/charflaw/silverweakness)
	subclass_stats = list(//+9, You get PER/STR for the crossbow.
		STATKEY_PER = 3,
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	maximum_possible_slots = 1

/datum/outfit/job/roguetown/arbalist
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/arbalist/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/headband/bloodied
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	cloak = /obj/item/clothing/cloak/psydontabard/alt
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	neck = /obj/item/clothing/neck/roguetown/gorget
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	mask = /obj/item/clothing/mask/rogue/sack/psy
	id = /obj/item/clothing/ring/signet/silver/inqscomm
	backpack_contents = list(
		/obj/item/roguekey/inquisition = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.

/datum/outfit/job/roguetown/arbalist/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/ranged_weapons = list("Arbalest", "Fusilier")
	var/ranged_choice = input(H, "CHOOSE YOUR RANGED WEAPON.", "STRIKE FROM AFAR.") as anything in ranged_weapons
	switch(ranged_choice)
		if("Arbalest")
			H.equip_to_slot_or_del(new /obj/item/storage/belt/rogue/leather/stakebelt, SLOT_BELT, TRUE)//Because your 'crossbow' FUCKS.
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed/psy, SLOT_BELT_L, TRUE)//Your ticket to fame, brother.
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/arbalest, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/heavybolts, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/ammo_casing/caseless/rogue/heavy_bolt/tempest, SLOT_IN_BACKPACK, TRUE)//You get ONE.
			if(H.mind)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_inviolability)//A shield against the undead.
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_lux_bolt)//Take a guess. Exclusive to arbalist.
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_sacrosanctity)//To get your blood back, m'lord.
		if("Fusilier")
			ADD_TRAIT(H, TRAIT_FUSILIER, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/combat/crossbows, -1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/firearms, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)// To parry with the Rifle
			H.equip_to_slot_or_del(new /obj/item/storage/belt/rogue/leather/entropy_sphere_belt, SLOT_BELT, TRUE) // stakes < concept of entropy
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed/psy, SLOT_BELT_L, TRUE)//Your ticket to fame, brother.
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/rune/twilight_runelock/rifle, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/twilight_bullet/runicbag/arbalist, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/twilight_bullet/runicbag/arbalist/mark, SLOT_IN_BACKPACK, TRUE)//You get ONE.


//Stake belt. Here because nothing else uses it. It's just a throwing knife belt, but for stake bolts.
//A better way to carry them, since these are unobtanium.
/obj/item/storage/belt/rogue/leather/stakebelt
	name = "stake bolt belt"
	desc = "A five-slotted belt meant for stake bolts. Little room left over."
	icon_state = "blackknife"
	item_state = "blackknife"
	strip_delay = 20
	var/max_storage = 5
	var/list/stakes = list()
	component_type = /datum/component/storage/concrete/roguetown/belt/knife_belt

/obj/item/storage/belt/rogue/leather/stakebelt/attackby(obj/A, loc, params)
	if(A.type in typesof(/obj/item/ammo_casing/caseless/rogue/heavy_bolt/holy))
		if(stakes.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			stakes += A
			update_icon()
			to_chat(usr, span_notice("I discreetly slip [A] into [src]."))
		else
			to_chat(loc, span_warning("Full!"))
		return
	..()

/obj/item/storage/belt/rogue/leather/stakebelt/attack_right(mob/user)
	if(stakes.len)
		var/obj/O = stakes[stakes.len]
		stakes -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/storage/belt/rogue/leather/stakebelt/examine(mob/user)
	. = ..()
	if(stakes.len)
		. += span_notice("[stakes.len] inside.")

/obj/item/storage/belt/rogue/leather/stakebelt/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/holy/K = new()
		stakes += K
	update_icon()


/obj/item/storage/belt/rogue/leather/entropy_sphere_belt
	name = "entropic sphere belt"
	desc = "Belt containg very specialised entropic spheres, whose runes are to energy hungry to be shot from anything less then a rifle."
	icon_state = "blackknife"
	item_state = "blackknife"
	strip_delay = 20
	var/max_storage = 6
	var/has_types = TRUE
	var/ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/entropy
	var/ammo_type_name = "heavy entropic"
	var/list/arrows = list()
	var/list/linked_ammo_types = list() // types the casings report on firing
	var/list/linked_casings = list()    // every live casing linked to this bag, in or out of it
	var/recall_energy_cost = 50 // energy drained per sphere recalled
	component_type = /datum/component/storage/concrete/roguetown/belt/knife_belt

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/attackby(obj/item/A, mob/user, params)
	if(istype(A, ammo_type))
		if(eatarrow(A, user))
			to_chat(user, span_notice("You insert \the [A] into \the [src]."))
		else
			to_chat(user, span_warning("\The [src] is full!"))
		return TRUE
	return ..()

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/proc/eatarrow(obj/A, loc)
	if(!istype(A, ammo_type))
		return FALSE
	if(arrows.len >= max_storage)
		return FALSE
	var/obj/item/ammo_casing/R = A
	if(ismob(loc))
		var/mob/M = loc
		M.doUnEquip(R, TRUE, src, TRUE, silent = TRUE)
	else
		R.forceMove(src)
	arrows += R
	link_casing(R)
	update_icon()
	return TRUE

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/attack_right(mob/user)
	if(!arrows.len)
		to_chat(user, span_warning("The belt is empty."))
		return TRUE
	var/obj/item/ammo_casing/O = arrows[arrows.len]
	arrows -= O 
	O.forceMove(user.loc)
	user.put_in_hands(O)
	update_icon()
	return TRUE

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/MiddleClick(mob/living/user)
	if(!isliving(user))
		return
	if(arrows.len >= max_storage)
		to_chat(user, span_notice("The [src.name] is full and can accept no more ammunition!"))
		return
	if(user.energy < recall_energy_cost)
		to_chat(user, span_warning("The runes on the belt flicker and die. I don't have the energy to recall them."))
		return
	to_chat(user, span_notice("The runes on the belt flare as I call the [ammo_type_name] spheres home..."))
	if(!do_after(user, 15 SECONDS, src))
		to_chat(user, span_warning("My concentration breaks, and the runes go dark."))
		return
	var/affordable = round(user.energy / recall_energy_cost)
	if(affordable < 1)
		to_chat(user, span_warning("My energy gutters out before the spheres can answer."))
		return
	var/summoned = 0
	for(var/obj/item/ammo_casing/C as anything in linked_casings - arrows)
		if(summoned >= affordable || arrows.len >= max_storage)
			break
		if(recursive_loc_check(C.loc, /obj/item/gun))
			continue
		qdel(C)
		if(summon_round(ammo_type))
			summoned++
	while(summoned < affordable && summon_round(ammo_type))
		summoned++
	if(!summoned)
		return
	playsound(src, 'sound/magic/blink.ogg', 80)
	user.energy_add(-(recall_energy_cost * summoned))
	if(arrows.len < max_storage)
		to_chat(user, span_warning("My energy runs dry. Only [summoned] sphere\s answered the call."))
	else
		to_chat(user, span_notice("The spheres snap back into the belt."))
	linked_ammo_types.Cut()
	update_icon()

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/examine(mob/user)
	. = ..()
	. += span_info("It holds [arrows.len]/[max_storage] [ammo_type_name] spheres.")
	. += span_info("Middle-click it to recall spheres. Right-click to draw a sphere.")

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/proc/summon_round(sphere_type)
	if(!ispath(sphere_type, ammo_type))
		return FALSE
	if(arrows.len >= max_storage)
		return FALSE
	var/obj/item/ammo_casing/R = new sphere_type(src)
	arrows += R
	link_casing(R)
	update_icon()
	return TRUE

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/Destroy()
	for(var/obj/item/ammo_casing/C as anything in linked_casings)
		C.linked_belt = null
	linked_casings.Cut()
	linked_ammo_types.Cut()
	QDEL_LIST(arrows)
	return ..()

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/proc/link_casing(obj/item/ammo_casing/C)
	C.linked_belt = src
	linked_casings |= C

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/proc/unlink_casing(obj/item/ammo_casing/C)
	linked_casings -= C
	arrows -= C
	if(C.linked_belt == src)
		C.linked_belt = null

/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/R = new ammo_type(src)
		arrows += R
		link_casing(R)
	update_icon()
