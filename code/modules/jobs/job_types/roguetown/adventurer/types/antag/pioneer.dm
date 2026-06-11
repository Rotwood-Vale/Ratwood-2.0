/datum/advclass/pioneer
	name = "拓荒工兵"
	tutorial = "靠着陷阱、顺手的铲子和炸药，你至今还没把自己玩死。\
	这总归也算一种本事吧。至于他们为什么还肯留你，多半不是因为你长得讨喜。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/pioneer
	category_tags = list(CTAG_BANDIT)
	maximum_possible_slots = 1//They're limited because these guys can LEVEL THE TOWN. RAAAAAAAAAA!!!!!!
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_WEBWALK, TRAIT_FUSILIER)//GET THIS SHIT OFF OF ME!!!!!
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/firearms = SKILL_LEVEL_EXPERT,//He works with explosives. And firearms are otherwise unobtanium. Just fluff.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,//Bare minimum for dedicated classes. Here because handyman Joe wrastling is funny.
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,//For the shovel...
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,//For the backup knives.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,//For when his backup knives run out of backups.
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,//Sadly, for Joe, he has less than stellar athletics.
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,//Contraptions, explosives, etc.
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,//Repairs, really. But dabbling.
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,//As above.
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,//Yet again.
		/datum/skill/craft/smelting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
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

/datum/outfit/job/roguetown/bandit/pioneer/post_equip(mob/living/carbon/human/H)
	. = ..()
	for(var/datum/bounty/b in GLOB.head_bounties)
		if(b.target == H.real_name || b.target_hidden == H.real_name)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_CON, 1)

// Their snowflake mine//

//This has a serious exploit, but I can't be buggered to fix it. If you know, you know.
//Average player won't. Others can be banned. I hate slop code.
/obj/effect/proc_holder/spell/targeted/pioneer/plant_bogtrap_delayed
	name = "布设沼泽陷阱（延时）"
	desc = "8 秒后，一枚沼泽陷阱会在我脚下完成布设并启动。"
	range = 0
	overlay_state = "trap"//Temp.
	releasedrain = 0
	recharge_time = 50 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	antimagic_allowed = TRUE
	associated_skill = /datum/skill/craft/crafting
	invocations = list("量两遍，再下套……")
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
		to_chat(user, span_warning("我已经在布置一枚延时陷阱了！"))
		return FALSE

	if(!_has_saperka(user))
		to_chat(user, span_warning("我要有工具才能布设这个陷阱。"))
		revert_cast()
		return FALSE

	var/turf/T = get_turf(user)
	if(!T || !isturf(T))
		revert_cast()
		return FALSE

	if(_is_town_blocked(T))
		to_chat(user, span_warning("我没法在这里布设沼泽陷阱；地面太硬了。"))
		revert_cast()
		return FALSE

	for(var/obj/structure/fluff/traveltile/TT in range(1, T))
		to_chat(user, span_warning("我得找个更合适的地方来布设陷阱。"))
		revert_cast()
		return FALSE

	var/list/trap_choices = list(
		"爆炸"			= /obj/structure/trap/bogtrap/bomb,
		"霜冻"			= /obj/structure/trap/bogtrap/freeze,
		"刺膝"			= /obj/structure/trap/bogtrap/kneestingers,
		"剧毒"			= /obj/structure/trap/bogtrap/poison,
	)

	var/choice = input(user, "选择要布设的陷阱类型：", "沼泽陷阱") as null|anything in trap_choices
	if(!choice)
		revert_cast()
		return FALSE

	var/trap_path = trap_choices[choice]

	pending = TRUE

	user.visible_message(
		span_notice("[user]跪了下来，正在脚边布置什么东西。"),
		span_notice("我开始布设一个[choice]沼泽陷阱。")
	)
	playsound(user, 'sound/misc/clockloop.ogg', 50, TRUE)

	if(!do_after(user, setup_delay, target = T))
		pending = FALSE
		to_chat(user, span_warning("我停止布设沼泽陷阱。"))
		revert_cast()
		return FALSE

	for(var/obj/structure/fluff/traveltile/TT in range(1, T))
		pending = FALSE
		to_chat(user, span_warning("我得找个更合适的地方来布设陷阱。"))
		revert_cast()
		return FALSE

	_clear_existing_bogtrap(T)
	_spawn_bogtrap(T, trap_path)

	user.visible_message(
		span_warning("[user]脚下传来一声机关暗扣就位的轻响！"),
		span_notice("[choice]沼泽陷阱已在我脚下完成布设。")
	)
	playsound(T, 'sound/misc/chains.ogg', 50, TRUE)

	message_admins("[user.real_name]([key_name(user)]) has planted a trap, [ADMIN_JMP(user)]")
	log_admin("[user.real_name]([key_name(user)]) has planted a trap")

	pending = FALSE
	return TRUE
