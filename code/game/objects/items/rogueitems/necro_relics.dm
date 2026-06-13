/obj/item/necro_relics/necro_crystal
	name = "黑暗水晶"
	desc = "它在你手中冰冷刺骨。你本不该拿着这东西。"
	icon = 'icons/roguetown/items/gems.dmi'
	icon_state = "necro_crystal"
	hitsound = 'sound/blank.ogg'
	dropshrink = 0.6
	var/last_use_time = 0
	var/use_cooldown = 300 // 30 seconds
	var/list/active_skeletons = list() //List of active skeletons stored here.
	var/max_summons = 2 //Maximum amount of skeletons that can be summoned at one time.
	var/max_charges = 2 //Maximum amount of charges the crystal can hold.
	var/current_charges = 2
	grid_height = 32
	grid_width = 32

/obj/item/necro_relics/necro_crystal/examine(mob/user)
	. = ..()
	if(current_charges > 0)
		. += span_notice("水晶散发着黑暗而充盈的力量。")
	else
		. += span_danger("水晶空洞而死寂，其中的魔力已经枯竭。")

/obj/item/necro_relics/necro_crystal/Initialize(mapload)
	..()
	set_light(2, 2, 1, l_color = "#551c1c")

/obj/item/necro_relics/necro_crystal/proc/recharge(obj/item/reagent_containers/lux_impure/L, mob/user)
	if(current_charges >= max_charges)
		to_chat(user, span_notice("水晶已经充满力量了。"))
		return FALSE

	qdel(L) // consume the lux
	current_charges = min(current_charges + 1, max_charges)
	to_chat(user, span_notice("水晶在吸收生命精粹时发出低鸣。"))
	playsound(src, 'sound/magic/churn.ogg', 70, TRUE)
	return TRUE

/obj/item/necro_relics/necro_crystal/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/lux_impure))
		return recharge(I, user)
	return ..()

/obj/item/necro_relics/necro_crystal/attack_self(mob/living/user)
	..()
	if(!user)
		return FALSE

	if(length(active_skeletons) >= max_summons)
		to_chat(user, span_warning("水晶发出不祥的嗡鸣。其内的力量此刻过于吃紧，无法再召出一个骷髅。"))
		return FALSE

	if(world.time - src.last_use_time < src.use_cooldown)
		to_chat(user, span_warning("水晶在你手下轻轻震颤，却依旧毫无反应。"))
		return FALSE

	if(current_charges <= 0)
		to_chat(user, span_warning("水晶显得空虚枯竭。它渴求光明精粹。"))
		return FALSE

	// Ask the Necromancer for a task for the skeleton BEFORE the timer
	var/tasks = list("劳作","战斗","守卫","搜寻")
	var/tasks_choice = input(user, "汝之命令为何？", "以她之名") as anything in tasks
	if(!tasks_choice)
		to_chat(user, span_warning("你必须为你的骷髅分配一项任务！"))
		return FALSE

	src.last_use_time = world.time

	if(!do_after(user, 60, src))
		to_chat(user, span_warning("你失去了专注。"))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_CABAL))
		to_chat(user, span_warning("水晶拒绝了你！它在你掌中碎裂了！"))
		user.flash_fullscreen("redflash1")
		new /obj/item/natural/glass_shard(get_turf(src))
		playsound(src, "glassbreak", 70, TRUE)
		qdel(src)
		return FALSE

	var/turf/T = get_step(user, user.dir)
	if(!isopenturf(T))
		to_chat(user, span_warning("目标位置被阻挡了。我的召唤无法显现。"))
		return FALSE

	var/necro_name = user.real_name ? user.real_name : user.name
	var/list/candidates = pollGhostCandidates("帷幕裂开，一只手伸了出来！你愿意以高阶骷髅的身份在不死中侍奉 [necro_name] 吗？你将会 [tasks_choice]", ROLE_NECRO_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_NECROMANCER_SKELETON)
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("深渊空空如也。"))
		return FALSE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		return FALSE

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/skeleton/no_equipment/target = new /mob/living/carbon/human/species/skeleton/no_equipment(T)
	target.crystal = WEAKREF(src)
	target.key = C.key
	current_charges--
	SSjob.EquipRank(target, "Fortified Skeleton", TRUE)
	target.visible_message(span_warning("[target]的双眼亮起了诡异的光芒！"))
	var/datum/weakref/W = WEAKREF(target)
	active_skeletons += W

	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "FORTIFIED SKELETON"), 3 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	target.faction |= list("[user.mind.current.real_name]_faction")

	if(current_charges <= 0)
		to_chat(user, span_notice("水晶黯淡下来，它的力量已经耗尽。"))
	else
		to_chat(user, span_notice("水晶的光芒减弱了。还剩[current_charges]次使用。"))

	user.flash_fullscreen("redflash1")
	playsound(src, "shatter", 50, TRUE)

	return TRUE

/mob/living/carbon/human/proc/choose_pronouns_and_body()
	var/p_input = input(src, "选择你角色的代称", "代称") as anything in GLOB.pronouns_list
	if(p_input)
		src.pronouns = p_input
	if(alert(src, "你想改变自己的体型吗？", "体型", "是", "否") == "是")
		src.gender = (src.gender == MALE) ? FEMALE : MALE
	src.regenerate_icons()
