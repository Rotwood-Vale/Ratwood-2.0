// Ranged weapons and daggers on the side - lighter armor, but fleet!
// In exchange for martial skills beyond ranged, they can now set traps, too.
// Footman gets expert in a good bit of martial with STR. Cavalry gets a saiga and CON/WIL setup.
/datum/advclass/manorguard/skirmisher
	name = "游击兵"
	tutorial = "你是王国的职业军士，专精各类远程兵器。你目光锐利，总在寻找敌人的破绽。"
	outfit = /datum/outfit/job/roguetown/manorguard/skirmisher

	category_tags = list(CTAG_MENATARMS)
	//Garrison ranged/speed class. Time to go wild
	subclass_stats = list(
		STATKEY_SPD = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_PER = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/slings = SKILL_LEVEL_MASTER,//Your entire point is ranged.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,//You get a knife, just in case.
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,//And can double in maces and swords.
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)
	extra_context = "可在轻甲（闪避专精）与中甲之间选择，并且该子职业还能布设陷阱。"

/datum/outfit/job/roguetown/manorguard/skirmisher/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/splintlegs
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	beltl = /obj/item/rogueweapon/mace/cudgel
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("十字弩","弓","投石索")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		var/armor_options = list("轻甲", "中甲")
		var/armor_choice = input(H, "选择你的护甲。", "穿上护甲") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)
			if("十字弩")
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("弓") // They can head down to the armory to sideshift into one of the other bows.
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("投石索")
				beltr = /obj/item/quiver/sling/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling // Both are belt slots and it's not worth setting where the cugel goes for everyone else, sad.

		switch(armor_choice)
			if("轻甲")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("中甲")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/guardcastle = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			)
		H.verbs |= /mob/proc/haltyell
		//Skirmishers get funny spells. Wowzers.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/skirmisher_trap)

		var/helmets = list(
		"素盔" 	= /obj/item/clothing/head/roguetown/helmet,
		"锅盔" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"尖顶盔"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"萨莱特盔"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"翼盔" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"护顶盔"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "戴上头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]

//Skirmisher's tripwire. Just Pioneer's with edits.
//As with Pioneer, it has exploits. I hate this so much.
//This does not make use of the sapper check. Just shovels.
/obj/effect/proc_holder/spell/targeted/skirmisher_trap
	name = "延时布陷"
	desc = "8 秒后，一道陷阱会在你脚下完成布设并进入待发状态。守林人与披甲兵不会触发它。"
	overlay_state = "trap2"//Temp.
	invocations = list("铁枝为引……")
	range = 0
	releasedrain = 0
	recharge_time = 50 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	antimagic_allowed = TRUE
	associated_skill = /datum/skill/craft/crafting
	invocation_type = "whisper"
	miracle = FALSE
	req_items = list(/obj/item/rogueweapon/shovel)
	var/setup_delay = 8 SECONDS
	var/pending = FALSE
	var/trap_path = /obj/structure/trap/bogtrap/bomb

/obj/effect/proc_holder/spell/targeted/skirmisher_trap/proc/_clear_existing_trap(turf/T)
	if(!T) return
	for(var/obj/structure/trap/bogtrap/BT in T)
		qdel(BT)

/obj/effect/proc_holder/spell/targeted/skirmisher_trap/proc/_spawn_trap(turf/T, trap_path)
	if(!T || !trap_path) return
	var/obj/structure/trap/bogtrap/B = new trap_path(T)
	B.armed = TRUE
	B.alpha = 100
	B.update_icon()

/obj/effect/proc_holder/spell/targeted/skirmisher_trap/cast(list/targets, mob/living/user = usr)
	. = ..()
	if(!isliving(user))
		return FALSE

	if(pending)
		to_chat(user, span_warning("我已经在布设一处延时陷阱了！"))
		return FALSE

	var/turf/T = get_turf(user)
	if(!T || !isturf(T))
		revert_cast()
		return FALSE

//Do this if it turns out to be absurd.
//Having skirmishers able to alarm areas makes sense.
//They're not offensive traps for the most part. Unlike poison gas and explosives.
/*
	if(_is_town_area(T))//Inverse. Find a good spot, buddy.
		to_chat(user, span_warning("这里的地面太松软了，我没法在此布陷阱。"))
		revert_cast()
		return FALSE
*/

	for(var/obj/structure/fluff/traveltile/TT in range(1, T))
		to_chat(user, span_warning("我该另找个更合适的地方布设陷阱。"))
		revert_cast()
		return FALSE

//Rous for silly traps. Will it be useful? Probably not. Knockdown will, though.
//Flare trap is effectively a global alarm. Same as the church bell.
//Now you can alarm the keep's rooftop on lowpop and such.
	var/list/trap_choices = list(
		"响铃"			= /obj/structure/trap/bogtrap/rous,
		"照明"			= /obj/structure/trap/bogtrap/flare_trap,
	)

	var/choice = input(user, "选择要布设的陷阱类型：", "陷阱") as null|anything in trap_choices
	if(!choice)
		revert_cast()
		return FALSE

	var/trap_path = trap_choices[choice]

	pending = TRUE

	user.visible_message(
		span_notice("[user] 单膝跪地，在脚边摆弄着什么。"),
		span_notice("我开始布设一处[choice]陷阱。")
	)
	playsound(user, 'sound/misc/clockloop.ogg', 50, TRUE)

	if(!do_after(user, setup_delay, target = T))
		pending = FALSE
		to_chat(user, span_warning("我停止了陷阱布设。"))
		revert_cast()
		return FALSE

	for(var/obj/structure/fluff/traveltile/TT in range(1, T))
		pending = FALSE
		to_chat(user, span_warning("我该另找个更合适的地方布设陷阱。"))
		revert_cast()
		return FALSE

	_clear_existing_trap(T)
	_spawn_trap(T, trap_path)

	user.visible_message(
		span_warning("[user] 脚下传来一声隐蔽的机关咔嗒声！"),
		span_notice("[choice]陷阱已在我脚下布设完成。")
	)
	playsound(T, 'sound/misc/chains.ogg', 50, TRUE)

	message_admins("[user.real_name]([key_name(user)]) has planted a trap, [ADMIN_JMP(user)]")
	log_admin("[user.real_name]([key_name(user)]) has planted a trap")

	pending = FALSE
	return TRUE
