/datum/antagonist/dreamwalker
	name = "梦行者"
	roundend_category = "梦行者"
	antagpanel_category = "梦行者"
	job_rank = ROLE_DREAMWALKER
	confess_lines = list(
		"我的愿景高于一切！",
		"我会把你带去我的领域！",
		"祂的形态宏伟绝伦！",
	)
	rogue_enabled = TRUE

	var/traits_dreamwalker = list(
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_NOMOOD,
		TRAIT_NOLIMBDISABLE,
		TRAIT_SHOCKIMMUNE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_HEAVYARMOR,
		TRAIT_COUNTERCOUNTERSPELL,
		TRAIT_RITUALIST,
		TRAIT_STRENGTH_UNCAPPED,
		TRAIT_DREAMWALKER
		)

	var/STASTR = 15
	var/STASPD = 12
	var/STAINT = 12
	var/STAWIL = 12
	var/STACON = 12
	var/STAPER = 12
	var/STALUC = 10

/datum/antagonist/dreamwalker/on_gain()
	SSmapping.retainer.dreamwalkers |= owner
	. = ..()
	reset_stats()
	// We'll set the special role later to avoid revealing dreamwalkers early!
	//owner.special_role = name
	greet()
	return ..()

/datum/antagonist/dreamwalker/greet()
	to_chat(owner.current, span_notice("我感到体内有一种罕见的能力苏醒了。我是大多数神祇都渴望得到的冠军。一名梦行者。我不只是被 阿比索尔 之梦触及，更能毫不费力地从祂的领域中抽取物质与力量。我将为我的神祇带来荣耀。梦境实体的影响正撕扯我的心智，但我的意志必定比它们更强。"))
	to_chat(owner.current, span_notice("我具现出了一截仪式粉笔……它看起来力量非凡。我将锻造一把伟大的武器，一把威力足以凌驾于其他一切之上的武器。我必须先找到一个目标……只要我专注起来，这应该并不难。"))
	owner.announce_objectives()
	..()

/datum/antagonist/dreamwalker/proc/reset_stats()
	owner.current.STASTR = src.STASTR
	owner.current.STAPER = src.STAPER
	owner.current.STAINT = src.STAINT
	owner.current.STASPD = src.STASPD
	owner.current.STAWIL = src.STAWIL
	owner.current.STACON = src.STACON
	owner.current.STALUC = src.STALUC
	//Dreamfiends fear them up close.
	var/mob/living/carbon/human/body = owner.current 
	body.faction |= "dream"
	for (var/trait in traits_dreamwalker)
		ADD_TRAIT(body, trait, "[type]")
	if(body.mind)
		body.mind.RemoveAllSpells()
		body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blink)
		body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mark_target)
		body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/jaunt)
		body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dream_bind)
		body.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dream_trance)
	body.ambushable = FALSE
	body.AddComponent(/datum/component/dreamwalker_repair)
	body.AddComponent(/datum/component/dreamwalker_mark)
	var/obj/item/ritechalk/chalk = new()
	body.put_in_hands(chalk)
	to_chat(body, span_danger("随着梦之能量占据上风，我感到自己与奥术和神术的联系正在减弱……"))
	REMOVE_TRAIT(body, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
	REMOVE_TRAIT(body, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
	REMOVE_TRAIT(body, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
	REMOVE_TRAIT(body, TRAIT_ARCYNE_T4, TRAIT_GENERIC)
	body.devotion = null

/datum/outfit/job/roguetown/dreamwalker/pre_equip(mob/living/carbon/human/H) //Equipment is located below
	..()

	H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	// We lose our statpack & racial, so bonuses are significant.
	H.change_stat(STATKEY_STR, 5)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_WIL, 2)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blink)
	H.ambushable = FALSE

/datum/component/dreamwalker_repair
	/// List of dream items being repaired
	var/list/repairing_items = list()
	/// List of timers for broken items being fully repaired
	var/list/repair_timers = list()
	/// Processing interval
	/// Careful touching this as setting it too low makes it REALLY hard to break items.
	var/process_interval = 5 SECONDS
	/// Time of last processing
	var/last_process = 0
	var/next_armor_peel_process = 0
	var/next_armor_peel_interval = 1 MINUTES

/datum/component/dreamwalker_repair/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	to_chat(parent, span_userdanger("你的身体正随着诡异的梦之能量脉动。"))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_item_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))
	// Register for processing
	START_PROCESSING(SSprocessing, src)

/datum/component/dreamwalker_repair/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	// Clean up all timers
	for(var/obj/item/I in repair_timers)
		deltimer(repair_timers[I])
	repair_timers = null
	repairing_items = null
	return ..()

/datum/component/dreamwalker_repair/process(delta_time)
	// Only process every x seconds
	if(world.time < last_process + process_interval)
		return

	last_process = world.time

	// Process all items in the repair list
	for(var/obj/item/I in repairing_items)
		if(I.obj_broken)
			continue // Broken items are handled separately
		if(I.obj_integrity < I.max_integrity)
			I.obj_integrity = min(I.obj_integrity + I.max_integrity * 0.01, I.max_integrity) // Repair 1% of max integrity
			I.update_icon()
		if(I.blade_int < I.max_blade_int)
			I.add_bintegrity(min(I.blade_int + I.max_blade_int * 0.01, I.max_blade_int), src.parent) // Sharpen 1% of max sharpness

	if(world.time >= next_armor_peel_process)
		next_armor_peel_process = world.time + next_armor_peel_interval

		for(var/obj/item/I in repairing_items)
			if(istype(I, /obj/item/clothing) && I.peel_count > 0)
				I.peel_count--
				I.visible_message(span_notice("梦之能量将 [I] 被剥落的一层猛地复原归位。"))
				break

/datum/component/dreamwalker_repair/proc/on_item_equipped(mob/user, obj/item/source, slot)
	SIGNAL_HANDLER
	if(source.item_flags & DREAM_ITEM)
		to_chat(parent, span_notice("[source] 在你手中脉动，梦之能量正被动地修复着它。"))
		add_item(source)

/datum/component/dreamwalker_repair/proc/on_item_dropped(mob/user, obj/item/source)
	SIGNAL_HANDLER
	if(source.item_flags & DREAM_ITEM)
		to_chat(parent, span_notice("[source] 一离开你的身体便停止了脉动。"))
		remove_item(source)

/datum/component/dreamwalker_repair/proc/add_item(obj/item/I)
	if(I in repairing_items)
		return
	repairing_items += I
	RegisterSignal(I, COMSIG_ITEM_BROKEN, PROC_REF(on_item_broken))

	// If item is already broken, start full repair process
	if(I.obj_broken)
		start_full_repair(I)

/datum/component/dreamwalker_repair/proc/remove_item(obj/item/I)
	if(I in repairing_items)
		repairing_items -= I
		UnregisterSignal(I, COMSIG_ITEM_BROKEN)
		// Cancel any ongoing full repair
		if(I in repair_timers)
			deltimer(repair_timers[I])
			repair_timers -= I

/datum/component/dreamwalker_repair/proc/on_item_broken(obj/item/source)
	SIGNAL_HANDLER
	if(source in repairing_items)
		source.visible_message(span_danger("[source] 碎裂开来，但某种诡异的能量似乎正缓缓将金属扭回原形。"))
		start_full_repair(source)

/datum/component/dreamwalker_repair/proc/start_full_repair(obj/item/I)
	// Cancel any existing timer
	if(I in repair_timers)
		deltimer(repair_timers[I])

	// Set a timer to fully repair after 1 minute
	repair_timers[I] = addtimer(CALLBACK(src, PROC_REF(finish_full_repair), I), 1 MINUTES, TIMER_STOPPABLE)

/datum/component/dreamwalker_repair/proc/finish_full_repair(obj/item/I)
	// Check if the item is still in our inventory and broken
	if(I && (I in repairing_items) && I.obj_broken)
		I.visible_message(span_danger("[I] 重新熔合成了可用的形状。"))
		I.obj_fix()
		// Restore up to 25% of durability instead of all of it. This is slightly more as I.integrity_failure for MOST things.
		I.obj_integrity *= 0.25
		I.update_icon()

	// Remove the timer reference
	repair_timers -= I

/obj/structure/portal_jaunt
	name = "梦境裂隙"
	desc = "一道通往别处的闪烁传送门。靠近时你会听见无数低语，似乎相当危险。"
	icon_state = "shitportal"
	icon = 'icons/roguetown/misc/structure.dmi'
	max_integrity = 250
	var/cooldown = 0
	var/uses = 0
	var/max_uses = 3
	var/turf/linked_turf
	var/safe_passage = FALSE

/obj/structure/portal_jaunt/Initialize(mapload)
	. = ..()
	cooldown = world.time + 4 SECONDS
	visible_message(span_warning("[src] 闪烁着显现出来！"))
	playsound(src, 'sound/magic/charging_lightning.ogg', 50, TRUE)

/obj/structure/portal_jaunt/attack_hand(mob/user)
	if(!do_after(user, 1 SECONDS, target = src))
		to_chat(user, span_warning("我必须站着不动才能使用这道传送门。"))
		return

	if(world.time < cooldown)
		var/time_left = (cooldown - world.time) * 0.1
		to_chat(user, span_warning("这道传送门还不稳定。还剩 [time_left] 秒。"))
		return

	if(uses >= max_uses)
		to_chat(user, span_warning("你一碰到它，传送门就崩塌了！"))
		qdel(src)
		return

	if(!linked_turf || !do_teleport(user, linked_turf))
		to_chat(user, span_warning("传送门闪烁了几下，但什么也没有发生。"))
		return

	uses++
	cooldown = world.time + 15 SECONDS
	// High likelyhood of getting a dreamfiend summon upon non dreamwalkers when used.
	if(!HAS_TRAIT(user, TRAIT_DREAMWALKER) && prob(75))
		summon_dreamfiend(
			target = user,
			user = user,
			F = /mob/living/simple_animal/hostile/rogue/dreamfiend,
			outer_tele_radius = 3,
			inner_tele_radius = 2,
			include_dense = FALSE,
			include_teleport_restricted = FALSE
		)

	visible_message(span_warning("[user] 穿过了[src]！"))
	playsound(src, 'sound/magic/lightning.ogg', 50, TRUE)

	if(uses >= max_uses)
		visible_message(span_danger("[src] 向内坍缩了！"))
		QDEL_IN(src, 1)

// Component to track marked targets and hits
/datum/component/dreamwalker_mark
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/marked_target = null
	var/hit_count = 0
	var/max_hits = 5
	var/mark_duration = 30 MINUTES
	var/mark_start_time = 0
	var/mark_minimum_duration = 10 MINUTES
	var/obj/effect/proc_holder/spell/invoked/summon_marked/summon_spell = null

/datum/component/dreamwalker_mark/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))

/datum/component/dreamwalker_mark/Destroy()
	if(marked_target)
		UnregisterSignal(marked_target, COMSIG_LIVING_DEATH)
		marked_target = null

	if(summon_spell && ishuman(parent))
		var/mob/living/carbon/human/H = parent
		if(H.mind)
			H.mind.RemoveSpell(summon_spell)
		QDEL_NULL(summon_spell)
	return ..()

/datum/component/dreamwalker_mark/proc/set_marked_target(mob/living/target)
	if(marked_target)
		UnregisterSignal(marked_target, COMSIG_LIVING_DEATH)
		if(marked_target.has_status_effect(/datum/status_effect/dream_mark))
			marked_target.remove_status_effect(/datum/status_effect/dream_mark)

	marked_target = target
	hit_count = 0
	mark_start_time = 0

	if(marked_target)
		RegisterSignal(marked_target, COMSIG_LIVING_DEATH, PROC_REF(on_target_death))
		to_chat(parent, span_notice("你开始将梦之能量集中到 [marked_target.real_name] 身上。"))

		// Remove any existing summon spell
		if(summon_spell && ishuman(parent))
			var/mob/living/carbon/human/H = parent
			if(H.mind)
				H.mind.RemoveSpell(summon_spell)
			QDEL_NULL(summon_spell)

/datum/component/dreamwalker_mark/proc/on_attack(mob/parent, mob/living/target, mob/user, obj/item/I)
	SIGNAL_HANDLER

	if(!marked_target || target != marked_target)
		return

	if(!(I.item_flags & DREAM_ITEM))
		return

	if(marked_target.has_status_effect(/datum/status_effect/dream_mark))
		return

	hit_count++
	to_chat(user, span_notice("你的梦境武器准确命中了目标。[hit_count]/[max_hits] 次命中即可建立连接。"))

	if(hit_count >= max_hits)
		// Apply the mark status effect
		marked_target.apply_status_effect(/datum/status_effect/dream_mark, mark_duration)
		mark_start_time = world.time
		to_chat(user, span_warning("你已经与 [marked_target] 建立起稳固的梦境连接！10 分钟后你就能召唤他们。"))
		to_chat(marked_target, span_userdanger("你感到自己与 [user] 之间正在形成一种不自然的联系。你的本质仿佛被系在了他们身上。"))

		create_summon_spell()

/datum/component/dreamwalker_mark/proc/create_summon_spell()
	if(!marked_target || !ishuman(parent))
		return

	// Check if mark is still active
	if(!marked_target.has_status_effect(/datum/status_effect/dream_mark))
		to_chat(parent, span_warning("你还没来得及召唤 [marked_target]，与其之间的联系就已经消散了！"))
		return

	// Create the summon spell
	summon_spell = new()
	var/mob/living/carbon/human/H = parent
	if(H.mind)
		H.mind.AddSpell(summon_spell)
		to_chat(H, span_warning("你与 [marked_target] 的联系如今已经强到足以将其召唤过来！"))

/datum/component/dreamwalker_mark/proc/on_target_death()
	SIGNAL_HANDLER
	to_chat(parent, span_warning("你与 [marked_target] 的联系已被死亡切断。"))
	set_marked_target(null)

/datum/component/dreamwalker_mark/proc/can_summon()
	if(!marked_target)
		return FALSE

	if(!marked_target.has_status_effect(/datum/status_effect/dream_mark))
		return FALSE

	if(world.time < mark_start_time + mark_minimum_duration)
		var/time_left = ((mark_start_time + mark_minimum_duration) - world.time) * 0.1
		to_chat(parent, span_warning("这个印记还不稳定。还剩 [time_left] 秒。"))
		return FALSE

	return TRUE

// Status effect for marked targets
/datum/status_effect/dream_mark
	id = "dream_mark"
	duration = 30 MINUTES // Increased to 30 minutes
	alert_type = /atom/movable/screen/alert/status_effect/dream_mark

/datum/status_effect/dream_mark/on_apply()
	to_chat(owner, span_userdanger("你感到自己的本质正在被拉向另一个领域。你被一名梦行者标记了！"))
	return TRUE

/datum/status_effect/dream_mark/on_remove()
	to_chat(owner, span_notice("与梦境领域的联系消散了。"))

/atom/movable/screen/alert/status_effect/dream_mark
	name = "梦痕标记"
	desc = "一名梦行者已与你的本质建立起联系。待联系稳定后，他们可能会尝试召唤你。"
	icon_state = "dream_mark"

/obj/item/ingot/sylveric
	name = "西尔维里克锭"
	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ingotsylveric"
	desc = "一种轻得不可思议的金属，受压时似乎会变得更硬、更沉。似乎没有任何东西能够塑造这种金属。"

// Add extra examine text for dreamwalkers
/obj/item/ingot/sylveric/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_DREAMWALKER))
		. += span_notice("你能感到这块金属正与你的梦之能量共鸣。如果你用它去敲击另一块西尔维里克锭，你就能将其塑形成武器。")

// Handle attacking one sylveric ingot with another
/obj/item/ingot/sylveric/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ingot/sylveric))
		if(!HAS_TRAIT(user, TRAIT_DREAMWALKER))
			return ..()

		// Check if both ingots are accessible
		if(I != user.get_active_held_item())
			return ..()

		if(!(src in user.contents) && !(isturf(src.loc) && in_range(src, user)))
			return ..()

		// Show weapon selection menu
		var/list/weapon_options = list(
			"裂梦巨斧" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamaxeactive"),
			"和鸣长矛" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamspearactive"),
			"渗液长剑" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamswordactive"),
			"雷鸣三叉戟" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamtriactive")
		)

		var/choice = show_radial_menu(user, src, weapon_options, require_near = TRUE, tooltips = TRUE)
		if(!choice)
			return

		to_chat(user, span_notice("你开始集中梦之能量，将西尔维里克锭塑形成一把 [choice]……"))
		if(do_after(user, 10 SECONDS, target = src))
			var/obj/item/new_weapon
			switch(choice)
				if("裂梦巨斧")
					new_weapon = new /obj/item/rogueweapon/greataxe/dreamscape/active(user.loc)
				if("和鸣长矛")
					new_weapon = new /obj/item/rogueweapon/halberd/glaive/dreamscape/active(user.loc)
				if("渗液长剑")
					new_weapon = new /obj/item/rogueweapon/greatsword/bsword/dreamscape/active(user.loc)
				if("雷鸣三叉戟")
					new_weapon = new /obj/item/rogueweapon/spear/dreamscape_trident/active(user.loc)

			if(new_weapon)
				to_chat(user, span_notice("你将西尔维里克锭塑形成了一把 [choice]。"))
				user.put_in_hands(new_weapon)
				qdel(I)
				qdel(src)
		return
	return ..()

// Component for dream weapon special properties
/datum/component/dream_weapon
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/effect_type = null
	var/cooldown_time
	var/next_use = 0

/datum/component/dream_weapon/Initialize(effect_type, cooldown_time)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.effect_type = effect_type
	src.cooldown_time = cooldown_time

	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SUCCESS, PROC_REF(on_attack))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))


/datum/component/dream_weapon/proc/on_attack(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(!effect_type)
		return

	// Check cooldown
	if(world.time < next_use)
		return

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/H = target

	// Apply effect based on type
	switch(effect_type)
		if("fire")
			H.adjust_fire_stacks(4)
			spawn(0)
				H.ignite_mob()
			target.visible_message(span_warning("[source] 以诡异的火焰点燃了 [target]！"))
		if("frost")
			H.apply_status_effect(/datum/status_effect/buff/frostbite)
			target.visible_message(span_warning("[source] 用灼人的寒冰冻结了 [target]！"))
		if("poison")
			if(H.reagents)
				H.reagents.add_reagent(/datum/reagent/berrypoison, 2)
				target.visible_message(span_warning("[source] 将污秽黏液注入了 [target] 体内！"))

	// Set cooldown
	next_use = world.time + cooldown_time

/datum/component/dream_weapon/proc/on_equipped(obj/item/source, mob/user, slot)
	SIGNAL_HANDLER
	if(HAS_TRAIT(user, TRAIT_DREAMWALKER))
		return

	// Non-dreamwalker trying to equip a dream weapon
	to_chat(user, span_userdanger("这把武器排斥你的触碰，梦之能量灼烧着你的手！"))
	user.dropItemToGround(source, TRUE)

	// Apply some damage or negative effect
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		spawn(0)
			H.apply_damage(10, BURN, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
			H.adjust_fire_stacks(2)
			H.ignite_mob()

/obj/item/rogueweapon/halberd/glaive/dreamscape
	name = "异界长矛"
	desc = "一把奇异的长矛，没人知道它来自何方。它看起来像是由古老骸骨制成的。"
	icon_state = "dreamspear"
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = null
	item_flags = DREAM_ITEM
	wbalance = WBALANCE_HEAVY
	max_blade_int = 200
	wdefense = 8

/obj/item/rogueweapon/halberd/glaive/dreamscape/active
	desc = "一把奇异的长矛，没人知道它来自何方。风穿过孔洞时，会发出奇异而和谐的声响。"
	icon_state = "dreamspearactive"
	max_blade_int = 400
	wdefense = 9
	force = 20
	force_wielded = 35

/obj/item/rogueweapon/greatsword/bsword/dreamscape
	name = "异界长剑"
	desc = "一把由奇异反光金属铸成的奇异长剑。"
	icon_state = "dreamsword"
	force = 25
	force_wielded = 30
	max_integrity = 275
	smeltresult = null
	item_flags = DREAM_ITEM
	wbalance = WBALANCE_HEAVY
	wdefense = 4
	possible_item_intents = list(/datum/intent/sword/cut,/datum/intent/sword/chop,/datum/intent/stab, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop, /datum/intent/sword/lunge, /datum/intent/sword/thrust/estoc)
	alt_intents = list(/datum/intent/effect/daze, /datum/intent/sword/strike, /datum/intent/sword/bash)

/obj/item/rogueweapon/greatsword/bsword/dreamscape/active
	name = "异界长剑"
	desc = "一把由奇异反光金属铸成的奇异长剑。它正渗出令人作呕的污泥。"
	icon_state = "dreamswordactive"
	max_integrity = 500
	force = 30
	force_wielded = 35
	wdefense = 5

/obj/item/rogueweapon/spear/dreamscape_trident
	name = "异界三叉戟"
	desc = "一柄奇异的三叉戟。它看起来本不该是一件高效武器，但那暗哑的金属却向你低语着自身的力量。"
	icon_state = "dreamtri"
	smeltresult = null
	max_blade_int = 240
	minstr = 8
	wdefense = 4
	throwforce = 40
	force = 30
	force_wielded = 20
	item_flags = DREAM_ITEM
	var/shockwave_cooldown = 0
	var/shockwave_cooldown_interval = 1 MINUTES
	var/shockwave_divisor = 3
	var/shockwave_damage = FALSE

/obj/item/rogueweapon/spear/dreamscape_trident/active
	name = "虹彩三叉戟"
	desc = "一柄泛着油亮色泽的奇异三叉戟。它周围的空气都在微微扭曲闪烁。"
	icon_state = "dreamtriactive"
	max_integrity = 480
	throwforce = 50
	force = 35
	force_wielded = 25
	wdefense = 5
	shockwave_cooldown_interval = 30 SECONDS
	shockwave_divisor = 2
	shockwave_damage = TRUE

// Update weapon initializations with specific effects
/obj/item/rogueweapon/greataxe/dreamscape/active/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dream_weapon, "fire", 20 SECONDS)

/obj/item/rogueweapon/halberd/glaive/dreamscape/active/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dream_weapon, "frost", 40 SECONDS)

/obj/item/rogueweapon/greatsword/bsword/dreamscape/active/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dream_weapon, "poison", 20 SECONDS)

/obj/item/rogueweapon/spear/dreamscape_trident/active/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/datum/outfit/job/roguetown/dreamwalker_armorrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/dreamwalker
	pants = /obj/item/clothing/under/roguetown/platelegs/dreamwalker
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dreamwalker
	gloves = /obj/item/clothing/gloves/roguetown/plate/dreamwalker
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/dreamwalker
	neck = /obj/item/clothing/neck/roguetown/bevor

/obj/item/clothing/suit/roguetown/armor/plate/full/dreamwalker
	name = "异界全身板甲"
	desc = "奇异而带虹彩的全身板甲。它反射光线的样子就像表面覆着一层发亮的油膜。"
	icon_state = "dreamplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	item_flags = DREAM_ITEM
	peel_threshold = 5

/obj/item/clothing/suit/roguetown/armor/plate/full/dreamwalker/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/under/roguetown/platelegs/dreamwalker
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "异界腿甲"
	desc = "奇异而带虹彩的腿甲。它反射光线的样子就像表面覆着一层发亮的油膜。"
	icon_state = "dreamlegs"
	armor = ARMOR_ASCENDANT
	item_flags = DREAM_ITEM
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK)

/obj/item/clothing/under/roguetown/platelegs/dreamwalker/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/shoes/roguetown/boots/armor/dreamwalker
	max_integrity = ARMOR_INT_SIDE_ANTAG
	name = "异界金属靴"
	desc = "奇异而带虹彩的金属靴。它反射光线的样子就像表面覆着一层发亮的油膜。"
	icon_state = "dreamboots"
	armor = ARMOR_ASCENDANT
	item_flags = DREAM_ITEM

/obj/item/clothing/shoes/roguetown/boots/armor/dreamwalker/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/gloves/roguetown/plate/dreamwalker
	name = "异界护手"
	desc = "奇异而带虹彩的板甲护手。它反射光线的样子就像表面覆着一层发亮的油膜。"
	icon_state = "dreamgauntlets"
	max_integrity = ARMOR_INT_SIDE_ANTAG
	item_flags = DREAM_ITEM

/obj/item/clothing/gloves/roguetown/plate/dreamwalker/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/head/roguetown/helmet/bascinet/dreamwalker
	name = "异界鱿盔"
	desc = "一顶异界的鱿鱼头盔。它反射光线的样子就像表面覆着一层发亮的油膜。"
	adjustable = CAN_CADJUST
	icon_state = "dreamsquidhelm"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	peel_threshold = 4
	item_flags = DREAM_ITEM
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/head.dmi'
	block2add = null
	worn_x_dimension = 32
	worn_y_dimension = 48
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/roguetown/helmet/bascinet/dreamwalker/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)
