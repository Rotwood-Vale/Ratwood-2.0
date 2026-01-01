/datum/advclass/pioneer
	name = "Pioneer"
	tutorial = "Aided by your traps, trusty shovel and explosives, you've not yet met your end. \
	That has to count for something. They surely keep you around for your charm, though."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/pioneer
	category_tags = list(CTAG_BANDIT)
	maximum_possible_slots = 1//They're limited because these guys can LEVEL THE TOWN. RAAAAAAAAAA!!!!!!
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_WEBWALK)//GET THIS SHIT OFF OF ME!!!!!
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_LCK = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,//Bare minimum for dedicated classes. Here because handyman Joe wrastling is funny.
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,//For the shovel...
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,//For the backup knives.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,//For when his backup knives run out of backups.
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,//Sadly, for Joe, he has less than stellar athletics.
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,//Point of the class.
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,//Contraptions, explosives, etc.
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,//Repairs, really. But dabbling.
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,//As above.
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,//Yet again.
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/bandit/pioneer/pre_equip(mob/living/carbon/human/H)
	..()
	belt =	/obj/item/storage/belt/rogue/leather
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor //toe safety first
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/coif
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/shovel/saperka
	beltl = /obj/item/storage/detpack
	beltr = /obj/item/flashlight/flare/torch/lantern
	id = /obj/item/mattcoin
	backpack_contents = list(
		/obj/item/restraints/legcuffs/beartrap = 4,
		/obj/item/flint = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/pick/steel = 1,
	)

	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/pioneer/plant_bogtrap_delayed)

// Their snowflake mine//

//This has a serious exploit, but I can't be buggered to fix it. If you know, you know.
//Average player won't. Others can be banned. I hate slop code.
/obj/effect/proc_holder/spell/targeted/pioneer/plant_bogtrap_delayed
	name = "Set Bogtrap (Delayed)"
	desc = "After 8 seconds, a bogtrap arms beneath your feet."
	range = 0
	overlay_state = "trap"//Temp.
	releasedrain = 0
	recharge_time = 50 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	antimagic_allowed = TRUE
	associated_skill = /datum/skill/craft/traps
	invocations = list("Measure twice, set once...")
	invocation_type = "whisper"
	miracle = FALSE
	req_items = list(/obj/item/rogueweapon/shovel)

	var/setup_delay = 8 SECONDS
	var/pending = FALSE
	var/trap_path = /obj/structure/trap/bogtrap/bomb

/obj/effect/proc_holder/spell/targeted/pioneer/plant_bogtrap_delayed/proc/_has_saperka(mob/living/user)
	for(var/obj/item/rogueweapon/shovel/saperka/S in user)
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/targeted/pioneer/plant_bogtrap_delayed/proc/_clear_existing_bogtrap(turf/T) //no 1000 traps on one tile
	if(!T) return
	for(var/obj/structure/trap/bogtrap/BT in T)
		qdel(BT)

/obj/effect/proc_holder/spell/targeted/pioneer/plant_bogtrap_delayed/proc/_spawn_bogtrap(turf/T, trap_path)
	if(!T || !trap_path) return
	var/obj/structure/trap/bogtrap/B = new trap_path(T)
	B.armed = TRUE
	B.alpha = 100
	B.update_icon()

/obj/effect/proc_holder/spell/targeted/pioneer/plant_bogtrap_delayed/proc/_is_town_blocked(turf/T)
	if(!T) return TRUE
	var/area/A = get_area(T)
	return istype(A, /area/rogue/outdoors/town)

/obj/effect/proc_holder/spell/targeted/pioneer/plant_bogtrap_delayed/cast(list/targets, mob/living/user = usr)
	. = ..()
	if(!isliving(user))
		return FALSE

	if(pending)
		to_chat(user, span_warning("I'm already rigging a delayed charge!"))
		return FALSE

	if(!_has_saperka(user))
		to_chat(user, span_warning("I need my tool to set this trap."))
		revert_cast()
		return FALSE

	var/turf/T = get_turf(user)
	if(!T || !isturf(T))
		revert_cast()
		return FALSE

	if(_is_town_blocked(T))
		to_chat(user, span_warning("I cannot set a bogtrap here; the ground is too hard."))
		revert_cast()
		return FALSE

	for(var/obj/structure/fluff/traveltile/TT in range(1, T))
		to_chat(user, span_warning("Should find better place to set up the trap."))
		revert_cast()
		return FALSE

	var/list/trap_choices = list(
		"Bomb"			= /obj/structure/trap/bogtrap/bomb,
		"Frost"			= /obj/structure/trap/bogtrap/freeze,
		"Kneestingers"	= /obj/structure/trap/bogtrap/kneestingers,
		"Toxic"			= /obj/structure/trap/bogtrap/poison,
	)

	var/choice = input(user, "Select the trap type to rig:", "Bogtrap") as null|anything in trap_choices
	if(!choice)
		revert_cast()
		return FALSE

	var/trap_path = trap_choices[choice]

	pending = TRUE

	user.visible_message(
		span_notice("[user] kneels, rigging something beneath their feet."),
		span_notice("I begin setting a [choice] bogtrap.")
	)
	playsound(user, 'sound/misc/clockloop.ogg', 50, TRUE)

	if(!do_after(user, setup_delay, target = T))
		pending = FALSE
		to_chat(user, span_warning("I stop setting the bogtrap."))
		revert_cast()
		return FALSE

	for(var/obj/structure/fluff/traveltile/TT in range(1, T))
		pending = FALSE
		to_chat(user, span_warning("Should find better place to set up the trap."))
		revert_cast()
		return FALSE

	_clear_existing_bogtrap(T)
	_spawn_bogtrap(T, trap_path)

	user.visible_message(
		span_warning("A hidden mechanism clicks into place under [user]!"),
		span_notice("The [choice] bogtrap arms beneath my feet.")
	)
	playsound(T, 'sound/misc/chains.ogg', 50, TRUE)

	message_admins("[user.real_name]([key_name(user)]) has planted a trap, [ADMIN_JMP(user)]")
	log_admin("[user.real_name]([key_name(user)]) has planted a trap")

	pending = FALSE
	return TRUE
