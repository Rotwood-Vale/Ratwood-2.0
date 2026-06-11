#define GNOLL_STEALTH_TIMER 60 SECONDS
#define GNOLL_ABDUCT_TIMER 20 SECONDS
#define GNOLL_ABDUCT_DAMAGE_THRESHOLD 100
/obj/effect/proc_holder/spell/self/claws/gnoll
	name = "豺狼人利爪"
	claw_type = /obj/item/rogueweapon/werewolf_claw/gnoll

/obj/effect/proc_holder/spell/self/howl/gnoll
	howl_sounds = list('sound/vo/mobs/gnoll/yeen_howl.ogg')
	howl_sounds_far = list('sound/vo/mobs/hyena/gnoll_distant.ogg')
	howl_antag_type = /datum/antagonist/gnoll
	howl_channels = list(HOWL_CHANNEL_GNOLL) // gnolls only — separate channel from werewolves/druids
	howl_distance_limit = 50
	howl_distance_volume = 25
	howl_prompt_text = "向那染血的天空嚎叫……"
	howl_prompt_title = "血裔"
	howl_announcement_target = "染血的天空"

/obj/effect/proc_holder/spell/invoked/gnoll_sniff
	name = "追踪"
	desc = "那位血腥之神为你挑选了几个值得狩猎的家伙，去追猎他们吧！对自己施放以设定目标，再次施放可追踪目标，对某个人施放则可暂时记住他们的气味。"
	recharge_time = 0.5 SECONDS
	chargetime = 0.1 SECONDS
	breaks_invisibility = FALSE
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "sniff"
	invocation_type = "none"
	action_icon_state = "sniff"
	hide_charge_effect = TRUE
	var/datum/weakref/tracked_target_ref = null
	var/list/target_warning_next_by_ref = list()
	var/shown_hunt_disclaimer = FALSE
	var/last_selection

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/sync_antag_tracked_target(mob/user, mob/living/target)
	var/datum/antagonist/gnoll/gnoll_antag = user?.mind?.has_antag_datum(/datum/antagonist/gnoll)
	if(!gnoll_antag)
		return
	gnoll_antag.set_tracked_target(target)

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/cast(list/targets, mob/user)
	var/mob/living/target = targets[1]
	var/mob/living/tracked_target = tracked_target_ref?.resolve()

	if(!tracked_target || QDELETED(tracked_target) || tracked_target.stat == DEAD || target == user)
		select_new_target(user)
	else
		give_tracking_directions(user)

	if(is_valid_hunted(target) && target != user)
		tracked_target_ref = WEAKREF(target)
		sync_antag_tracked_target(user, target)
		to_chat(user, span_notice("你捕捉到了 [target.real_name] 的气味。狩猎开始了！"))
		notify_tracked_target(target)
		user.playsound_local(get_turf(user), 'sound/vo/mobs/wwolf/sniff.ogg', 50, TRUE)
	else if(!tracked_target_ref?.resolve())
		sync_antag_tracked_target(user, null)
		to_chat(user, span_warning("[target] 不是你能狩猎的目标。"))
		revert_cast()
		return FALSE
	
	return TRUE

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/select_new_target(mob/user)
	var/list/hunted_targets = list()
	var/list/combat_targets = list()
	var/list/combat_roles = get_gnoll_tracking_combat_roles()
	var/list/name_counts = list()
	//Allows a fallback, if no hunted targets are available, we can track worthy prey (combat roles) instead. 
	for(var/mob/living/carbon/human/human in GLOB.player_list)
		if(human == user || QDELETED(human) || human.stat == DEAD || istype(human, /mob/living/carbon/human/dummy) || !human.mind)
			continue
		if(human.advsetup || !human.class_equip_finished) // they haven't gotten their true class name yet
			continue
		if(human.has_flaw(/datum/charflaw/hunted))
			add_target_to_list(human, hunted_targets, name_counts)
		else if(human.job in combat_roles)
			add_target_to_list(human, combat_targets, name_counts)

	var/list/possible_targets = length(hunted_targets) ? hunted_targets : combat_targets

	if(!length(possible_targets))
		to_chat(user, span_warning("空气死寂沉闷。这片土地上没有值得狩猎的猎物。"))
		return

	var/selection = tgui_input_list(user, "我们要追随谁的气味？", "伟大狩猎", possible_targets, last_selection)
	if(!selection)
		return

	if(!shown_hunt_disclaimer)
		to_chat(user, span_notice("你已经选定了第一个猎物。") + span_biginfo("去看看这家伙是否值得你费心。\
									如果不值得，你随时都可以再去寻找别的目标。"))
		shown_hunt_disclaimer = TRUE

	var/mob/living/selected_target = possible_targets[selection]
	if(!is_valid_hunted(selected_target))
		to_chat(user, span_warning("那道气味在你锁定之前就已经溜走了。"))
		return

	last_selection = selection
	tracked_target_ref = WEAKREF(selected_target)
	sync_antag_tracked_target(user, selected_target)
	notify_tracked_target(selected_target)
	to_chat(user, span_notice("你将感官集中在 [selected_target.real_name] 身上。"))
	give_tracking_directions(user)

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/add_target_to_list(mob/living/carbon/human/human, list/target_list, list/name_counts)
	var/base_name = "[human.real_name]"
	var/name_count = (name_counts[base_name] || 0) + 1
	name_counts[base_name] = name_count
	var/class = human.get_class_title()
	var/static/list/class_title_map = list(
		"Orthodoxist" = "正教徒",
		"Absolver" = "赦罪者",
		"Templar" = "圣堂武士",
		"Dungeoneer" = "地牢探险者",
		"Sergeant" = "军士",
		"Man at Arms" = "披甲武士",
		"Knight" = "骑士",
		"Squire" = "侍从",
		"Mercenary" = "雇佣兵",
		"Warden" = "典狱官",
		"Acolyte" = "侍僧",
		"Vanguard" = "先锋",
		"City Guard" = "城卫",
		"Bandit" = "强盗",
		"Watch Captain" = "卫队队长",
		"Master Warden" = "首席典狱官",
		"Knight Captain" = "骑士队长",
		"Inquisitor" = "审判官"
	)
	if(class_title_map[class])
		class = class_title_map[class]
	// Names will display in the format "Urist McDwarf (2) - Grudgebearer Soldier"
	var/entry_name = (name_count > 1) ? "[base_name] ([name_count])[length(class) ? " - [class]" : ""]" : "[base_name][length(class) ? " - [class]" : ""]"
	
	target_list[entry_name] = human
	return

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/give_tracking_directions(mob/user)
	var/mob/living/tracked_target = tracked_target_ref?.resolve()
	if(!tracked_target || QDELETED(tracked_target) || tracked_target.stat == DEAD)
		to_chat(user, span_warning("气味已经冷了……你的目标不复存在。"))
		tracked_target_ref = null
		sync_antag_tracked_target(user, null)
		return

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(tracked_target)

	if(user_turf.z != target_turf.z)
		to_chat(user, span_notice("[tracked_target.real_name] 的气味正从你的[user_turf.z > target_turf.z ? "下方" : "上方"]飘来。"))
	else
		var/dist = get_dist(user, tracked_target)
		var/dir_text = dir2text(get_dir(user, tracked_target))
		
		if(dist <= 1)
			to_chat(user, span_boldnotice("猎物就在这里！鲜血与钢铁！"))
		else if(dist < 10)
			to_chat(user, span_notice("[dir_text] 方向的气味极其浓烈。他们离得非常近。"))
		else
			to_chat(user, span_notice("你在 [dir_text] 方向捕捉到了一丝 [tracked_target.real_name] 的微弱气味。"))

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/notify_tracked_target(mob/living/target)
	if(!is_valid_hunted(target))
		return

	var/target_ref = "\ref[target]"
	var/next_warning_time = target_warning_next_by_ref[target_ref]
	if(isnull(next_warning_time))
		target_warning_next_by_ref[target_ref] = world.time + 10 MINUTES
		to_chat(target, span_warning("微弱的狞笑随风而来。我必须小心自己踏入哪些阴影，否则很可能会沦为猎物！"))
		return

	if(world.time < next_warning_time)
		return

	target_warning_next_by_ref[target_ref] = world.time + 10 MINUTES
	to_chat(target, span_warning("我感受到了猎手的注视，他们正冲着我来！"))

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/is_valid_hunted(atom/A)
	if(!isliving(A))
		return FALSE
	var/mob/living/L = A
	if(!L || QDELETED(L) || L.stat == DEAD)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/abduct
	name = "掳掠"
	desc = "对自己施放以设定目的地。对一名被你激进抓取的人类施放，可将其与附近的同类一同传送到该处。对被狩猎目标施放会快得多。所有参与者都要付出少量鲜血代价，务必小心。追兵可能会跟上来。若你最近受伤过重，则无法施放。"
	var/turf/destination_turf
	var/blood_loss = 75
	recharge_time = 5 MINUTES
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>我用利爪在现实中撕开了一道裂口！</span>"
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "abduct"
	action_icon_state = "abduct"

/obj/effect/proc_holder/spell/invoked/abduct/cast(list/targets, mob/user)
	if(targets[1] == user)
		to_chat(user, span_notice("你开始为掳掠仪式设定锚点。"))
		if(do_after(user, 10 SECONDS, target = user))
			destination_turf = get_turf(user)
			to_chat(user, span_notice("你将自己与 格拉加尔 位面的联系锚定在此处。所有被掳走的人都会被带到这里。"))
		// We are reverting cast because we're only setting the destination.
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/target = targets[1]
	if(!ishuman(target))
		to_chat(user, span_warning("这个法术只能对人类或你自己生效！"))
		revert_cast()
		return FALSE

	if(user.pulling != target || user.grab_state < GRAB_AGGRESSIVE)
		to_chat(user, span_warning("你必须对 [target] 进行激进抓取，才能开始仪式！"))
		revert_cast()
		return FALSE

	// Shouldn't ever prop up, but sanity check!
	if(!destination_turf)
		to_chat(user, span_warning("你还没有设定目的地锚点！"))
		revert_cast()
		return FALSE

	var/datum/component/gnoll_combat_tracker/tracker = user.GetComponent(/datum/component/gnoll_combat_tracker)
	if(!tracker)
		tracker = user.AddComponent(/datum/component/gnoll_combat_tracker)

	if(tracker.get_recent_damage() > GNOLL_ABDUCT_DAMAGE_THRESHOLD)
		to_chat(user, span_warning("你最近承受了太多打击，无法专注进行掳掠，你不由得一阵退缩！"))
		revert_cast()
		return FALSE

	// Determine Channel Time
	var/channel_time = 15 SECONDS
	if(target.has_flaw(/datum/charflaw/hunted))
		channel_time = 6 SECONDS

	to_chat(user, span_notice("你开始将 [target] 拖入 格拉加尔 的位面。"))
	to_chat(target, span_userdanger("你周围的世界开始溶解，化作一场带着血腥气的噩梦！"))
	user.visible_message(span_userdanger("[user] 以利爪在空间中撕开一道血红裂隙，并开始将 [target] 拖入其中！"))
	tracker.channeling_abduction = TRUE

	if(!do_after(user, channel_time, target = target))
		tracker.channeling_abduction = FALSE
		revert_cast()
		return FALSE

	// Extra safety check
	if(tracker.get_recent_damage() > GNOLL_ABDUCT_DAMAGE_THRESHOLD)
		tracker.channeling_abduction = FALSE
		to_chat(user, span_warning("伤痛在最后一刻打断了你的掳掠仪式！"))
		revert_cast()
		return FALSE

	// Ritual Execution
	var/turf/origin_turf = get_turf(target)
	var/gnoll_hitchhikers = 0

	do_teleport(user, destination_turf)
	do_teleport(target, destination_turf)

	if(ishuman(user))
		var/mob/living/carbon/human/userashuman = user
		userashuman.blood_volume = max(0, userashuman.blood_volume - blood_loss)
	for(var/mob/living/carbon/human/H in range(7, origin_turf))
		if(H.dna?.species?.id == "gnoll" && H != user)
			gnoll_hitchhikers++
			H.blood_volume = max(0, H.blood_volume - blood_loss)
			do_teleport(H, destination_turf)
			to_chat(H, span_notice("你被裹挟进了这场血之掳掠的余波之中！"))

	// Basically, if a gnoll is badass enough to abduct his target alone, no one can follow
	if(gnoll_hitchhikers)
		var/obj/structure/portal_jaunt/portal = new(origin_turf)
		portal.linked_turf = destination_turf
		portal.safe_passage = TRUE
		portal.name = "消逝的血色裂隙"
		portal.color = "#570f04"
		portal.max_uses = 1
	new /obj/effect/gibspawner/human/bodypartless(origin_turf, target)

	to_chat(user, span_warning("仪式完成了。你已经将他们带到了自己的锚点。"))
	tracker.channeling_abduction = FALSE
	return TRUE

/datum/component/gnoll_combat_tracker
	var/damage_taken = 0
	var/last_damage_time = 0
	var/death_loot_given = FALSE
	var/channeling_abduction = FALSE

/datum/component/gnoll_combat_tracker/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damage))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/gnoll_combat_tracker/proc/on_damage(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = parent
	last_damage_time = world.time
	damage_taken += damage
	H.invisibility = initial(H.invisibility) //Prevent any potential issues with gnolls becoming invisible (THIS SHOULD NEVER BE NECESSARY, but the timer may fail!)
	if(channeling_abduction && ishuman(parent) && get_recent_damage() >= GNOLL_ABDUCT_DAMAGE_THRESHOLD)
		// micro stun to break any do_afters
		// asynchronous as to not mess with signal behavior!
		spawn(0)
			H.Stun(1)
		to_chat(H, span_userdanger("痛楚打断了你的专注！"))
		channeling_abduction = FALSE // Reset channel flag

/datum/component/gnoll_combat_tracker/proc/on_death()
	SIGNAL_HANDLER
	if(!death_loot_given)
		var/obj/item/loot = pick(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll, /obj/item/roguegem/blood_diamond)
		var/mob/living/gnoll = parent
		new loot(gnoll.loc)
		gnoll.visible_message(span_notice("一只染血的虚幻之手将 [loot.name] 轻轻放在豺狼人的尸体旁。"))
		death_loot_given = TRUE

/datum/component/gnoll_combat_tracker/proc/can_cast_stealth()
	// Returns TRUE if 1 minute has passed
	return (world.time >= last_damage_time + GNOLL_STEALTH_TIMER)

/datum/component/gnoll_combat_tracker/proc/get_recent_damage()
	if(world.time >= last_damage_time + GNOLL_ABDUCT_TIMER)
		damage_taken = 0
	return damage_taken

/obj/effect/proc_holder/spell/invoked/invisibility/gnoll
	name = "潜猎"
	desc = "从视野中消失，直到你发动攻击为止。受到伤害后，一分钟内都无法再次隐形。"
	recharge_time = 2 MINUTES
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "stalk"
	action_icon_state = "stalk"

/obj/effect/proc_holder/spell/invoked/invisibility/gnoll/cast(list/targets, mob/living/user)
	var/mob/living/target = user
	if(!isliving(target))
		revert_cast()
		return FALSE

	// Check Damage Tracker Component
	var/datum/component/gnoll_combat_tracker/tracker = user.GetComponent(/datum/component/gnoll_combat_tracker)
	if(tracker && !tracker.can_cast_stealth())
		var/wait = (tracker.last_damage_time + 60 SECONDS - world.time) / 10
		to_chat(user, span_warning("你的血液奔涌得太快了，无法借此遮蔽自身！请等待 [round(wait)] 秒。"))
		revert_cast()
		return FALSE

	if(target.anti_magic_check(TRUE, TRUE))
		revert_cast()
		return FALSE

	// Practically indefinite
	var/base_dur = 999 MINUTES

	target.visible_message(span_warning("[target] 消失在狩猎的气息之中！"), span_notice("你隐没无踪，狩猎正指引你的阴影。"))

	animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
	target.mob_timers[MT_INVISIBILITY] = world.time + base_dur
	user.invisibility = (SEE_INVISIBLE_LIVING + (user.get_skill_level(/datum/skill/misc/sneaking) * 0.75))+3 //Gnolls are harder to spot when using their evil magicks.
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), base_dur)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target] 从阴影中猛扑而出！"), span_notice("你的隐形消退了。")), base_dur)

	return TRUE

#undef GNOLL_STEALTH_TIMER
#undef GNOLL_ABDUCT_TIMER
#undef GNOLL_ABDUCT_DAMAGE_THRESHOLD
