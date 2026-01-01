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
	category_tags = list(CTAG_INQUISITION)
	traits_applied = list(
		TRAIT_PERFECT_TRACKER,
	)
	subclass_stats = list(//You get PER/STR for the crossbow.
		STATKEY_PER = 3,
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
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

/datum/outfit/job/roguetown/arbalist
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/arbalist/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	head = /obj/item/clothing/head/roguetown/headband/bloodied
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/arbalest//Tool of the trade.
	cloak = /obj/item/clothing/cloak/psydontabard/alt
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	neck = /obj/item/clothing/neck/roguetown/gorget
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather/stakebelt//Because your 'crossbow' FUCKS.
	beltr = /obj/item/quiver/heavybolts//IT REALLY DOES. You can't get more of these. Swap to a normal crossbow afterwards.
	beltl = /obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed/psy//Your ticket to fame, brother.
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	mask = /obj/item/clothing/mask/rogue/sack/psy
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/roguekey/inquisition = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/ammo_casing/caseless/rogue/heavy_bolt/tempest = 1//You get ONE.
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.

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
	sewrepair = TRUE
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

/obj/item/storage/belt/rogue/leather/stakebelt/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/holy/K = new()
		stakes += K
	update_icon()
