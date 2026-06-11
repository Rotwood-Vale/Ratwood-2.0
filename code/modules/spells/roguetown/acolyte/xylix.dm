/obj/effect/proc_holder/spell/invoked/wheel
	name = "命轮"
	desc = "转动命轮，为目标的命运施加增益或减益。"
	overlay_state = "wheel" //Wheel of Fortune
	releasedrain = 10
	chargedrain = 0
	chargetime = 3
	range = 1
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/misc/letsgogambling.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 MINUTES

/obj/effect/proc_holder/spell/invoked/wheel/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.apply_status_effect(/datum/status_effect/wheel)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/ventriloquism
	name = "腹语术"
	desc = "将自己的声音投向一件物体。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "ventril"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 1
	no_early_release = TRUE
	associated_skill = /datum/skill/magic/holy
	recharge_time = 15 SECONDS

/obj/effect/proc_holder/spell/invoked/ventriloquism/cast(list/targets, mob/user = usr)
	if(isobj(targets[1]))
		var/obj/target = targets[1]
		var/input_message = input(usr, "要让 [target] 说什么？", src) as null|text
		target.say("[input_message]")
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/mastersillusion
	name = "设下替身"
	desc = "制造一个自己的替身并令你隐形，片刻后分身会爆成烟雾。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "disguise"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 1
	no_early_release = TRUE
	movement_interrupt = FALSE
	chargedloop = /datum/looping_sound/invokeholy
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 1 MINUTES
	var/firstcast = TRUE
	var/icon/clone_icon

/obj/effect/proc_holder/spell/invoked/mastersillusion/cast(list/targets, mob/living/carbon/human/user = usr)
	if(firstcast)
		to_chat(user, span_italics("……噢，噢，你这副容貌可真是出众！让我们拿它来耍点把戏吧！"))
		clone_icon = get_flat_human_icon("[user.real_name] decoy", null, null, DUMMY_HUMAN_SLOT_MANIFEST, GLOB.cardinals, TRUE, user, TRUE) // We can only set our decoy icon once. This proc is sort of expensive on generation.
		firstcast = FALSE
		name = "大师幻影"
		to_chat(user, "好了……完美。")
		revert_cast()
		return
	var/turf/T = get_turf(user)
	var/holy_skill = user.get_skill_level(/datum/skill/magic/holy)
	var/scaled_skill = max(1, holy_skill)
	var/invis_seconds = min(6, 3 + FLOOR(scaled_skill / 2, 1))
	var/invis_time = invis_seconds SECONDS
	var/clone_duration = max(1 SECONDS, round(invis_time * 0.7))
	new /mob/living/simple_animal/hostile/rogue/xylixdouble(T, user, clone_icon, clone_duration)
	animate(user, alpha = 0, time = 0 SECONDS, easing = EASE_IN)
	user.mob_timers[MT_INVISIBILITY] = world.time + invis_time
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon/human, update_sneak_invis), TRUE), invis_time)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[user] 重新在视野中显现了出来。"), span_notice("你重新显露了身形。")), invis_time)
	return TRUE

/mob/living/simple_animal/hostile/rogue/xylixdouble
	name = "Xylix 替身 - 你本不该看到这个。"
	desc = ""
	gender = NEUTER
	mob_biotypes = MOB_HUMANOID
	maxHealth = 20
	health = 20
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = TRUE
	loot = list(/obj/item/bomb/smoke/decoy)
	can_have_ai = FALSE
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/mudcrab // doesnt really matter


/obj/item/bomb/smoke/decoy/Initialize(mapload)
	. = ..()
	playsound(loc, 'sound/magic/decoylaugh.ogg', 50)
	explode()

/mob/living/simple_animal/hostile/rogue/xylixdouble/Initialize(mapload, mob/living/carbon/human/copycat, icon/I, duration = 7 SECONDS)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal, death), TRUE), duration)
	icon = I
	name = copycat.name


/obj/effect/proc_holder/spell/invoked/mockery
	name = "恶毒嘲弄"
	desc = "嘲弄目标，使其一段时间内降低智力、速度、力量与意志。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "mockery"
	releasedrain = 50
	associated_skill = /datum/skill/misc/music
	recharge_time = 2 MINUTES
	range = 7

/obj/effect/proc_holder/spell/invoked/mockery/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/mockery.ogg', 40, FALSE)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		if(!target.can_hear()) // Vicious mockery requires people to be able to hear you.
			revert_cast()
			return FALSE
		target.apply_status_effect(/datum/status_effect/debuff/viciousmockery)
		SEND_SIGNAL(user, COMSIG_VICIOUSLY_MOCKED, target)
		record_round_statistic(STATS_PEOPLE_MOCKED)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/mockery/invocation(mob/user = usr)
	if(ishuman(user))
		switch(pick(1,2,3,4,5,6,7,8,9,10,11,12,13))
			if(1)
				user.say("你母亲是只 Rous，你父亲闻起来像杰克莓！", forced = "spell")
			if(2)
				user.say("等大魔鬼来把屁股讨回去时，你准备用什么当脸面？！", forced = "spell")
			if(3)
				user.say("你那刀站得倒挺直，和你那话儿一样不中用！", forced = "spell")
			if(4)
				user.say("连 Eora 都不会爱上你那张脸！", forced = "spell")
			if(5)
				user.say("你嘴里的味儿像生黄油和廉价啤酒！", forced = "spell")
			if(6)
				user.say("我向你咬拇指，阁下！", forced = "spell")
			if(7)
				user.say("废话少说，来吧！", forced = "spell")
			if(8)
				user.say("我祖母打得都比你好！", forced = "spell")
			if(9)
				user.say("要借我的眼镜吗？有本事自己来拿！", forced = "spell")
			if(10)
				user.say("你到底练了多久，才变得这么不堪？！", forced = "spell")
			if(11)
				user.say("你恐怕得去找铁匠了，因为你根本没资格来打一场智斗！", forced = "spell")
			if(12)
				user.say("看来你真是 PSY-DONE 了！不？太早了？行吧。", forced = "spell")
			if(13)
				user.say("愿 Ravox 替你那无用的导师降下正义，阁下！", forced = "spell")

/datum/status_effect/debuff/viciousmockery
	id = "viciousmockery"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/viciousmockery
	duration = 600 // One minute
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -1,STATKEY_WIL = -1, STATKEY_INT = -3)

/atom/movable/screen/alert/status_effect/debuff/viciousmockery
	name = "恶毒嘲弄"
	desc = "<span class='warning'>那个狂妄的吟游诗人！啊啊啊！</span>\n"
	icon_state = "mockery"

/obj/effect/proc_holder/spell/self/xylixslip
	name = "Xylix 滑步"
	desc = "让你跃至最远 3 格外。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slip"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 12 SECONDS
	devotion_cost = 30
	miracle = TRUE
	var/leap_dist = 4	//3 tiles (+1 to account for origin tile)
	var/static/list/sounds = list('sound/magic/xylix_slip1.ogg','sound/magic/xylix_slip2.ogg','sound/magic/xylix_slip2.ogg','sound/magic/xylix_slip3.ogg','sound/magic/xylix_slip4.ogg','sound/magic/xylix_slip4.ogg')

/obj/effect/proc_holder/spell/self/xylixslip/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user

	if(H.IsImmobilized() || !(H.mobility_flags & MOBILITY_STAND))
		revert_cast()
		return FALSE

	if(H.IsOffBalanced())
		H.visible_message(span_warning("[H] 失了脚步！"))
		var/turnangle = (prob(50) ? 270 : 90)
		var/turndir = turn(dir, turnangle)
		var/dist = rand(1, 2)
		var/current_turf = get_turf(H)
		var/target_turf = get_ranged_target_turf(current_turf, turndir, dist)
		H.throw_at(target_turf, dist, 1, H, TRUE)
		playsound(H,'sound/magic/xylix_slip_fail.ogg', 100)
		H.Knockdown(10)
		return TRUE
	else
		var/current_turf = get_turf(H)
		var/turf/target_turf = get_ranged_target_turf(current_turf, H.dir, leap_dist)
		H.visible_message(span_warning("[H] 滑走了！"))
		H.throw_at(target_turf, leap_dist, 1, H, TRUE)
		if(target_turf.landsound)
			playsound(target_turf, target_turf.landsound, 100, FALSE)
		H.emote("jump", forced = TRUE)
		H.OffBalance(8 SECONDS)
		playsound(H, pick(sounds), 100, TRUE)
		return TRUE

/obj/effect/proc_holder/spell/invoked/abscond
	name = "遁逸"
	desc = "在一阵烟雾中消失！（最远 4 格）"
	releasedrain = 30
	warnie = "spellwarning"
	movement_interrupt = TRUE
	associated_skill = /datum/skill/magic/holy
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "abscond"
	chargedrain = 1
	chargetime = 0 SECONDS
	recharge_time = 60 SECONDS
	hide_charge_effect = TRUE
	gesture_required = FALSE // Slippery
	devotion_cost = 100
	miracle = TRUE
	var/area_of_effect = 1
	var/max_range = 4
	var/turf/destination_turf
	var/turf/user_turf
	var/mutable_appearance/tile_effect
	var/mutable_appearance/target_effect
	var/datum/looping_sound/invokeshadow/shadowloop
	var/static/list/sounds = list('sound/magic/xylix_slip1.ogg','sound/magic/xylix_slip2.ogg','sound/magic/xylix_slip3.ogg','sound/magic/xylix_slip4.ogg')

//Resets the tile and turf effects.
/obj/effect/proc_holder/spell/invoked/abscond/proc/reset(silent = FALSE)
	if(tile_effect && destination_turf)
		destination_turf.cut_overlay(tile_effect)
		qdel(tile_effect)
		destination_turf = null
	if(user_turf && target_effect)
		user_turf.cut_overlay(target_effect)
		qdel(target_effect)
		user_turf = null
	update_icon()

/obj/effect/proc_holder/spell/invoked/abscond/proc/check_path(turf/Tu, turf/Tt)
	var/dist = get_dist(Tt, Tu)
	var/last_dir
	var/turf/last_step
	if(Tu.z > Tt.z) 
		last_step = get_step_multiz(Tu, DOWN)
	else if(Tu.z < Tt.z)
		last_step = get_step_multiz(Tu, UP)
	else 
		last_step = locate(Tu.x, Tu.y, Tu.z)
	var/success = FALSE
	for(var/i = 0, i <= dist, i++)
		last_dir = get_dir(last_step, Tt)
		var/turf/Tstep = get_step(last_step, last_dir)
		if(!Tstep.density)
			success = TRUE
			var/list/contents = Tstep.GetAllContents()
			for(var/obj/structure/bars/B in contents)
				success = FALSE
				return success
			var/list/cont = Tstep.GetAllContents(/obj/structure/roguewindow)
			for(var/obj/structure/roguewindow/W in cont)
				if(W.climbable && !W.opacity)	//It's climbable and can be seen through
					success = TRUE
					continue
				else if(!W.climbable)
					success = FALSE
					return success
		else
			success = FALSE
			return success
		last_step = Tstep
	return success

//Successful teleport, complete reset.
/obj/effect/proc_holder/spell/invoked/abscond/proc/tp(mob/user)
	if(destination_turf)
		if(do_teleport(user, destination_turf, no_effects=TRUE))
			log_admin("[user.real_name]([key_name(user)] Shadowstepped from X:[user_turf.x] Y:[user_turf.y] Z:[user_turf.z] to X:[destination_turf.x] Y:[destination_turf.y] Z:[destination_turf.z] in area: [get_area(destination_turf)]")
			if(user.m_intent == MOVE_INTENT_SNEAK)
				playsound(user_turf, pick(sounds), 20, TRUE)
				playsound(destination_turf, pick(sounds), 20, TRUE)
			else
				playsound(user_turf, pick(sounds), 100, TRUE)
				playsound(destination_turf, pick(sounds), 100, TRUE)
			reset(silent = TRUE)

/obj/effect/proc_holder/spell/invoked/abscond/cast(list/targets, mob/user)
	var/turf/O = get_turf(user)
	var/turf/T = get_turf(targets[1])
	var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread/fast
	if(!istransparentturf(T))
		var/reason
		if(max_range >= get_dist(user, T) && !T.density)
			if(check_path(get_turf(user), T))	//We check for opaque turfs or non-climbable windows in the way via a simple pathfind.
				if(get_dist(user, T) < 2 && user.z == T.z)
					to_chat(user, span_info("太近了！"))
					revert_cast()
					return FALSE
				to_chat(user, span_info("我开始滑脱而去了！"))
				lockon(T, user)
				if(do_after(user, 3 SECONDS))
					S.set_up(1, O)
					S.start()
					tp(user)
					return TRUE
				else
					reset(silent = TRUE)
					revert_cast()
				return FALSE
			else
				to_chat(user, span_info("去路被挡住了！"))
				revert_cast()
				return FALSE
		else if(get_dist(user, T) > max_range)
			reason = "太远了。"
			revert_cast()
			return FALSE
		else if (T.density)
			reason = "那是一堵墙！"
			revert_cast()
			return FALSE
		to_chat(user, span_info("我无法滑到那里！"+"[reason]"))
	else
		to_chat(user, span_info("我无法滑到那里！"))
		revert_cast()
		return
	. = ..()

//Plays affects at target Turf
/obj/effect/proc_holder/spell/invoked/abscond/proc/lockon(turf/T, mob/user)
	if(user.m_intent == MOVE_INTENT_SNEAK)
		playsound(T, 'sound/magic/shadowstep_destination.ogg', 20, FALSE, 5)
	else
		playsound(T, 'sound/magic/shadowstep_destination.ogg', 100, FALSE, 5)
	tile_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "mist", layer = 18)
	target_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "mist", layer = 18)
	user_turf = get_turf(user)
	destination_turf = T
	user_turf.add_overlay(target_effect)
	destination_turf.add_overlay(tile_effect)

/obj/effect/proc_holder/spell/invoked/mimicry
	name = "拟形戏法"
	desc = "在目标地点播放你选择的声音，或化作一件物品逗人取乐，你这聪明的小丑。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "mimicry"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 12 SECONDS
	devotion_cost = 30
	miracle = TRUE
	var/parlor_hand_path = /obj/item/melee/touch_attack/parlor_trick
	var/list/soundpick = list(
		"愤怒骷髅" = 'sound/vo/mobs/skel/skeleton_scream (1).ogg',
		"护甲碎裂" = 'sound/combat/sharpness_loss1.ogg',
		"挥击" = 'sound/combat/wooshes/bladed/wooshlarge (1).ogg',
		"钟声" = 'sound/misc/bell.ogg',
		"铃铛叮当" = 'sound/items/jinglebell1.ogg',
		"门板破裂" = 'sound/combat/hits/onwood/destroywalldoor.ogg',
		"鼓掌" = 'sound/vo/clap (1).ogg',
		"清嗓" = 'sound/vo/female/gen/clearthroat.ogg',
		"招架" = 'sound/combat/clash_initiate.ogg',
		"开锁" = 'sound/foley/doors/woodlock.ogg',
		"爆炸" = 'sound/magic/fireball.ogg',
		"玻璃碎裂" = 'sound/combat/hits/onglass/glassbreak (2).ogg',
		"哥布林喋喋" = 'sound/vo/male/goblin/giggle (2).ogg',
		"守卫警讯" = 'sound/misc/garrisonscom.ogg',
		"哈利路亚" = 'sound/magic/hallelujah.ogg',
		"嚎叫" = 'sound/vo/mobs/wwolf/howl (1).ogg',
		"跳跃" = 'sound/vo/male/gen/jump.ogg',
		"大型怪物跃起" = 'sound/vo/mobs/wwolf/jump (1).ogg',
		"开锁拨片声" = 'sound/items/pickbad.ogg',
		"讯息" = 'sound/magic/message.ogg',
		"嘘声" = 'sound/vo/psst.ogg',
		"老鼠吱吱/SCOM" = 'sound/vo/mobs/rat/rat_life.ogg',
		"释然" = 'sound/ddrelief.ogg',
		"惨叫 - 痛苦" = 'sound/vo/male/old/scream.ogg',
		"惨叫 - 狂怒" = 'sound/vo/female/gen/rage (1).ogg',
		"骷髅笑声" = 'sound/vo/mobs/skel/skeleton_laugh.ogg',
		"打响指" = 'sound/foley/finger-snap.ogg',
		"蜘蛛嘶鸣" = 'sound/vo/mobs/spider/idle (1).ogg',
		"压力" = 'sound/ddstress.ogg',
		"恶毒嘲弄" = 'sound/magic/mockery.ogg',
		"Volf 咆哮" = 'sound/vo/mobs/vw/idle (1).ogg',
	)
/obj/item/melee/touch_attack/parlor_trick
	name = "戏法道具"
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#FFFFFF"
	slot_flags = ITEM_SLOT_BELT
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/can_use = 1
	var/datum/weakref/active_dummy_ref = null
	var/saved_appearance = null

/obj/item/melee/touch_attack/parlor_trick/afterattack()
	return

/obj/item/melee/touch_attack/parlor_trick/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/mask/cigarette/rollie/zig = /obj/item/clothing/mask/cigarette/rollie
	saved_appearance = initial(zig.appearance)

/obj/item/melee/touch_attack/parlor_trick/dropped()
	..()
	disrupt()
	qdel(src)

/obj/item/melee/touch_attack/parlor_trick/equipped()
	..()
	disrupt()

/obj/item/melee/touch_attack/parlor_trick/attack_self(mob/user)
	disrupt()
	qdel(src)

/obj/item/melee/touch_attack/parlor_trick/attack_obj(obj/item/interacting_with, mob/living/user, list/modifiers)
	make_copy(interacting_with, user)

/obj/item/melee/touch_attack/parlor_trick/attack_right(mob/user)
	qdel(src)

/obj/item/melee/touch_attack/parlor_trick/proc/make_copy(atom/target, mob/user)
	playsound(get_turf(src), 'sound/magic/decoylaugh.ogg', 20, TRUE, -6)
	to_chat(user, span_notice("已复制 [target]。"))
	var/obj/temp = new /obj()
	temp.appearance = target.appearance
	temp.layer = initial(target.layer)
	saved_appearance = temp.appearance

/obj/item/melee/touch_attack/parlor_trick/proc/check_sprite(atom/target)
	return icon_exists(target.icon, target.icon_state)

/obj/item/melee/touch_attack/parlor_trick/proc/toggle(mob/user)
	if(!can_use || !saved_appearance)
		return
	var/obj/effect/dummy/parlor_trick/active_dummy = active_dummy_ref?.resolve()
	if(active_dummy)
		eject_all()
		playsound(get_turf(src), 'sound/magic/decoylaugh.ogg', 20, TRUE, -6)
		qdel(active_dummy)
		active_dummy_ref = null
		to_chat(user, span_notice("你停用了 \the [src]。"))
		new /obj/effect/temp_visual/gravpush(get_turf(src))
	else
		playsound(get_turf(src), 'sound/magic/decoylaugh.ogg', 20, TRUE, -6)
		var/obj/effect/dummy/parlor_trick/C = new/obj/effect/dummy/parlor_trick(user.drop_location())
		C.activate(user, saved_appearance, src)
		to_chat(user, span_notice("你启用了 \the [src]。"))
		new /obj/effect/temp_visual/gravpush(get_turf(src))

/obj/item/melee/touch_attack/parlor_trick/proc/disrupt(delete_dummy = 1)
	var/obj/effect/dummy/parlor_trick/active_dummy = active_dummy_ref?.resolve()
	if(active_dummy)
		for(var/mob/M in active_dummy)
			to_chat(M, span_danger("你的戏法正在消散！"))
		new /obj/effect/temp_visual/gravpush(loc)
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy_ref = null
		can_use = FALSE
		addtimer(VARSET_CALLBACK(src, can_use, TRUE), 2.5 SECONDS)

/obj/item/melee/touch_attack/parlor_trick/proc/eject_all()
	var/obj/effect/dummy/parlor_trick/active_dummy = active_dummy_ref?.resolve()
	if(!active_dummy)
		return
	for(var/atom/movable/A in active_dummy)
		A.forceMove(active_dummy.loc)
		if(ismob(A))
			var/mob/M = A
			M.reset_perspective(null)

/obj/effect/dummy/parlor_trick
	name = ""
	desc = ""
	density = FALSE
	var/can_move = 0
	var/obj/item/melee/touch_attack/parlor_trick/master = null

/obj/effect/dummy/parlor_trick/proc/pixel_shift(direction)
	if(CHECK_BITFIELD(direction, NORTH))
		pixel_y = min(pixel_y + 1, PIXEL_SHIFT_MAXIMUM)
	if(CHECK_BITFIELD(direction, EAST))
		pixel_x = min(pixel_x + 1, PIXEL_SHIFT_MAXIMUM)
	if(CHECK_BITFIELD(direction, SOUTH))
		pixel_y = max(pixel_y - 1, -PIXEL_SHIFT_MAXIMUM)
	if(CHECK_BITFIELD(direction, WEST))
		pixel_x = max(pixel_x - 1, -PIXEL_SHIFT_MAXIMUM)

/obj/effect/dummy/parlor_trick/proc/unpixel_shift()
	pixel_x = 0
	pixel_y = 0

/obj/effect/dummy/parlor_trick/proc/activate(mob/M, saved_appearance, obj/item/melee/touch_attack/parlor_trick/C)
	appearance = saved_appearance
	if(istype(M.buckled, /obj/vehicle))
		var/obj/vehicle/V = M.buckled
		V.unbuckle_mob(M, force = TRUE)
	M.forceMove(src)
	master = C
	master.active_dummy_ref = WEAKREF(src)


/obj/effect/dummy/parlor_trick/Destroy()
	if(master)
		master.disrupt(0)
		master = null
	return ..()

/obj/effect/dummy/parlor_trick/attackby()
	master.disrupt()

/obj/effect/dummy/parlor_trick/attack_hand()
	master.disrupt()

/mob/living/carbon/human/pixel_shift(direction)
	if(istype(loc, /obj/effect/dummy/parlor_trick))
		var/obj/effect/dummy/parlor_trick/D = loc
		D.pixel_shift(direction)
		is_shifted = TRUE
		return
	return ..()

/mob/living/carbon/human/unpixel_shift()
	if(istype(loc, /obj/effect/dummy/parlor_trick))
		var/obj/effect/dummy/parlor_trick/D = loc
		D.unpixel_shift()
		passthroughable = NONE
		is_shifted = FALSE
		return
	return ..()

/mob/living/carbon/human/send_speech(message, range = 7, obj/source = src, bubble_type, list/spans, datum/language/message_language = null, message_mode)
	. = ..()
	if(!istype(loc, /obj/effect/dummy/parlor_trick))
		return

	var/obj/effect/dummy/parlor_trick/D = loc
	var/list/hearers = get_hearers_in_view(range, source)
	for(var/mob/M in hearers)
		M.create_chat_message(D, message_language, message, spans, message_mode)

/obj/effect/proc_holder/spell/invoked/mimicry/proc/get_or_create_parlor_trick(mob/living/user)
	var/obj/item/melee/touch_attack/parlor_trick/active_hand = user.get_active_held_item()
	if(istype(active_hand))
		return active_hand

	for(var/obj/item/melee/touch_attack/parlor_trick/P in user.contents)
		if(!user.is_holding(P))
			if(!user.put_in_hands(P))
				to_chat(user, span_warning("我的手满了！"))
				return null
		return P

	var/obj/item/melee/touch_attack/parlor_trick/P = new parlor_hand_path(user)
	if(!user.put_in_hands(P))
		qdel(P)
		to_chat(user, span_warning("我的手满了！"))
		return null
	to_chat(user, span_notice("你将一道戏法引入手中。"))
	return P
	
/obj/effect/proc_holder/spell/invoked/mimicry/cast(list/targets, mob/living/user)
	var/atom/target = targets[1]
	var/turf/T = get_turf(target)

	if(target == user)
		var/obj/item/melee/touch_attack/parlor_trick/P = get_or_create_parlor_trick(user)
		if(!P)
			revert_cast()
			return FALSE
		to_chat(user, span_notice("你将一道戏法引入手中。对物体使用它以进行复制，然后右键自己进行变形。"))
		return TRUE

	if(isobj(target))
		var/obj/item/melee/touch_attack/parlor_trick/P = get_or_create_parlor_trick(user)
		if(!P)
			revert_cast()
			return FALSE
		P.make_copy(target, user)
		to_chat(user, span_notice("你将一道戏法奇迹灌入手中并复制了 [target]。右键自己即可变形。"))
		return TRUE

	var/pickedsound = input(user, "选择一种声音吧，我聪慧的官僚。", "拟声") as anything in soundpick
	if(!pickedsound)
		revert_cast()
		return FALSE
	if(T)
		new /obj/effect/temp_visual/soundping(T)
		playsound(T, soundpick[pickedsound], 100)
		return TRUE
	else
		to_chat(user, "<span class='warning'>戏法辜负了你，可怜的傻瓜。</span>")
		revert_cast()
		return FALSE

/obj/effect/proc_holder/spell/invoked/projectile/fetch/miracle
	name = "神圣牵引"
	miracle = TRUE
	devotion_cost = 10
	invocations = list()
	associated_skill = /datum/skill/magic/holy
	recharge_time = 5 SECONDS

/obj/effect/proc_holder/spell/invoked/projectile/fetch/miracle/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(T.z < user.z)
		to_chat(user, span_warning("你不能在低于自己所在楼层的位置使用神圣牵引！"))
		revert_cast()
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/projectile/repel/miracle
	name = "神圣斥退"
	miracle = TRUE
	devotion_cost = 14
	invocations = list()
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/projectile/repel/miracle/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(T.z < user.z)
		to_chat(user, span_warning("你不能在低于自己所在楼层的位置使用神圣斥退！"))
		revert_cast()
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/slick_trick_small/miracle
	name = "Xylix 滑域"
	desc = "创造一小片神圣湿滑区域，绊倒疏于防备者。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slipsquare1"
	miracle = TRUE
	devotion_cost = 30
	chargetime = 0.5 SECONDS
	invocations = list()
	associated_skill = /datum/skill/magic/holy
	recharge_time = 30 SECONDS

/obj/effect/proc_holder/spell/invoked/slick_trick/miracle
	name = "巨型 Xylix 滑域"
	desc = "让大片区域覆满神圣滑面，将受害者掀翻在地。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slipsquare2"
	miracle = TRUE
	devotion_cost = 60
	chargetime = 1 SECONDS
	invocations = list()
	associated_skill = /datum/skill/magic/holy
	recharge_time = 90 SECONDS
	area_of_effect_radius = 1 // 1 = 3x3

#define NOTHING "nothing"
#define XYLIX "xylix"
#define ASTRATA "astrata"
#define NOC "noc"
#define ZIZO "zizo"
#define RAVOX "ravox"
#define ABYSSOR "abyssor"
#define MALUM "malum"
#define EORA "eora"
#define NECRA "necra"
#define PESTRA "pestra"
#define DENDOR "dendor"
#define BAOTHA "baotha"
#define GRAGGAR "graggar"
#define MATTHIOS "matthios"

//JACKPOOOOOOOT 777
/datum/status_effect/xylix_blessed_luck
	id = "xylix_blessed_luck"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/xylix_blessed_luck

/datum/status_effect/xylix_blessed_luck/on_apply()
	var/random_luck = rand(2,4)
	effectedstats = list("fortune" = random_luck)
	. = ..()

/datum/status_effect/xylix_blessed_luck/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/xylix_blessed_luck
	name = "Xylix 赐福之运"
	desc = "即便你没有真正赢得他的恩宠，他依旧眷顾着你。"
	icon_state = "status"

/particles/astartian_favor
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = list("dot" = 8,"curl" = 1)
	width = 64
	height = 96
	color = 0
	color_change = 0.05
	count = 200
	spawning = 50
	gradient = list("#f37a34", "#FBAF4D", "#f02b1d", "#ff6d40")
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	fadein = 0.1 SECONDS
	grow = -0.1
	velocity = generator("box", list(-3, -0.7), list(3,3), NORMAL_RAND)
	position = generator("sphere", 8, 8, LINEAR_RAND)
	scale = generator("vector", list(2, 2), list(4,4), NORMAL_RAND)
	drift = list(0)

//Astrata Jackpot
/datum/status_effect/astrata_favor
	id = "astrata_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 40 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/astrata_favor

/datum/status_effect/astrata_favor/on_apply()
	effectedstats = list("constitution" = rand(1, 3), "willpower" = rand(1, 3))
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, XYLIX_LUCK_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, XYLIX_LUCK_TRAIT)
	ADD_TRAIT(owner, TRAIT_STEELHEARTED, XYLIX_LUCK_TRAIT)
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, XYLIX_LUCK_TRAIT)
	owner.particles = new /particles/astartian_favor()
	. = ..()

/datum/status_effect/astrata_favor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, XYLIX_LUCK_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, XYLIX_LUCK_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_STEELHEARTED, XYLIX_LUCK_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, XYLIX_LUCK_TRAIT)
	qdel(owner.particles)
	owner.particles = null
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/astrata_favor
	name = "Astrata 的恩泽"
	desc = "虽然这份恩泽来之不易，但 Xylix 还是动用了它。你几乎如同不朽。"
	icon_state = "status"

//Noc Jackpot
/datum/status_effect/noc_favor
	id = "noc_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/noc_favor

/datum/status_effect/noc_favor/on_apply()
	effectedstats = list("intelligence" = rand(1, 3), "speed" = rand(1, 3))
	owner.alpha = 127
	. = ..()

/datum/status_effect/noc_favor/on_remove()
	owner.alpha = 255
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/noc_favor
	name = "Noc 的恩泽"
	desc = "Noc 的知识、光与影笼罩着你。"
	icon_state = "status"

//Zizo punishment
/datum/status_effect/zizo_unfavor
	id = "zizo_unfavor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/zizo_unfavor

/datum/status_effect/zizo_unfavor/on_apply()
	effectedstats = list("strength" = -rand(1, 5), "perception" = -rand(1, 5), "intelligence" = -rand(1, 5), "constitution" = -rand(1, 5), "willpower" = -rand(1, 5), "speed" = -rand(1, 5))
	. = ..()

/datum/status_effect/zizo_unfavor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/zizo_unfavor
	name = "Zizo 的介入"
	desc = "你的庇护者不够专注，引来了 Zizo 的注意。你感到自己变弱了。"
	icon_state = "status"

//Ravox Jackpot
/datum/status_effect/ravox_favor
	id = "ravox_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/ravox_favor

/datum/status_effect/ravox_favor/on_apply()
	effectedstats = list("strength" = rand(1, 3), "speed" = rand(1, 3), "willpower" = rand(1, 3))
	. = ..()

/datum/status_effect/ravox_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/ravox_favor
	name = "Ravox 的恩泽"
	desc = "Ravox 的力量支撑着你。"
	icon_state = "status"

//Malum Jackpot
/datum/status_effect/malum_favor
	id = "malum_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/malum_favor

/datum/status_effect/malum_favor/on_apply()
	effectedstats = list("constitution" = 1, "willpower" = rand(1, 5))
	. = ..()

/datum/status_effect/malum_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

//Baotha Jackpot
/datum/status_effect/baotha_favor
	id = "baotha_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/baotha_favor

/datum/status_effect/baotha_favor/on_apply()
	effectedstats = list("speed" = rand(2, 3))
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.drunkenness = max(C.drunkenness, 30)
	owner.apply_status_effect(/datum/status_effect/buff/druqks/baotha)
	if(owner.client?.prefs?.sexable)
		if(!owner.sexcon)
			owner.sexcon = new /datum/sex_controller(owner)
		owner.sexcon.set_arousal(110)
	. = ..()

/datum/status_effect/baotha_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/baotha_favor
	name = "Baotha 的恩泽"
	desc = "你感到欣快、敏捷，浑身燥热而微醺。"
	icon_state = "status"

//Graggar Jackpot
/datum/status_effect/graggar_favor
	id = "graggar_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/graggar_favor

/datum/status_effect/graggar_favor/on_apply()
	var/list/allowed_zones = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/zone = pick(allowed_zones)
	var/obj/item/bodypart/BP = owner.get_bodypart(zone)
	if(BP)
		BP.add_wound(pick(/datum/wound/dynamic/bruise, /datum/wound/dynamic/slash, /datum/wound/dynamic/puncture))
		if(prob(25))
			BP.add_wound(/datum/wound/fracture)
	owner.visible_message(span_warning("[owner] 在 Graggar 的怒火下忽然痛得抽搐，血肉撕裂、瘀伤遍生！"), span_userdanger("Graggar 的怒火将我撕伤，剧痛在我全身绽开！"))
	. = ..()

/datum/status_effect/graggar_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/graggar_favor
	name = "Graggar 的恩泽"
	desc = "暴力转而向内。鲜血与痛苦都降临在你身上！"
	icon_state = "status"

//Matthios Jackpot
/datum/status_effect/matthios_favor
	id = "matthios_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/matthios_favor

/datum/status_effect/matthios_favor/on_apply()
	var/meister_balance = SStreasury.bank_accounts[owner] ? SStreasury.bank_accounts[owner] : 0
	if(meister_balance > 0)
		var/stolen = min(rand(1, 10), meister_balance)
		SStreasury.bank_accounts[owner] -= stolen
		to_chat(owner, span_warning("Matthios 从你的钱袋里顺走了 [stolen] 枚 Mammon！"))
	else
		to_chat(owner, span_notice("Matthios 伸手去摸你的钱袋，却发现里面空空如也。真是个穷酸的傻瓜！"))
	. = ..()

/datum/status_effect/matthios_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/matthios_favor
	name = "Matthios 的恩泽"
	desc = "那位自由之神带着歪斜的笑意，从你的钱袋里顺走了钱币。"
	icon_state = "status"

/atom/movable/screen/alert/status_effect/buff/malum_favor
	name = "Malum 的恩泽"
	desc = "Malum 将他持久的力量与意志借给了你。"
	icon_state = "status"

//Eora Jackpot
/datum/status_effect/eora_favor
	id = "eora_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/eora_favor

/datum/status_effect/eora_favor/on_apply()
	if(!HAS_TRAIT(owner, TRAIT_UNSEEMLY))
		ADD_TRAIT(owner, TRAIT_BEAUTIFUL, XYLIX_LUCK_TRAIT)
	. = ..()

/datum/status_effect/eora_favor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_BEAUTIFUL, XYLIX_LUCK_TRAIT)
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/datum/status_effect/eora_favor/process()
	owner.adjustBruteLoss(-1.25)
	owner.adjustFireLoss(-1.25)
	. = ..()

/atom/movable/screen/alert/status_effect/buff/eora_favor
	name = "Eora 的恩泽"
	desc = "Eora 以她的爱包裹着你，抚平你的伤口，并令你焕发神性的美丽。"
	icon_state = "status"

//Necra Jackpot
/datum/status_effect/necra_favor
	id = "necra_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/necra_favor
	var/last_smoke = 0
	var/smoke_interval = 5 SECONDS

/datum/status_effect/necra_favor/on_apply()
	owner.AddElement(/datum/element/cleaning)
	last_smoke = world.time
	. = ..()

/datum/status_effect/necra_favor/process()
	. = ..()
	if(world.time >= last_smoke + smoke_interval)
		last_smoke = world.time
		emit_censer_smoke()

/datum/status_effect/necra_favor/proc/emit_censer_smoke()
	var/turf/origin = get_turf(owner)
	if(!origin)
		return
	for(var/turf/T in view(1, origin))
		if(T == origin)
			continue
		new /obj/effect/particle_effect/smoke/necra_censer(T)
	playsound(origin, 'sound/items/censer_use.ogg', 40, TRUE)

/datum/status_effect/necra_favor/on_remove()
	owner.RemoveElement(/datum/element/cleaning)
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/necra_favor
	name = "Necra 的恩泽"
	desc = "Necra 香炉中的烟雾缠绕在你的步履之间，净化着你周围的地面。"
	icon_state = "status"

//Pestra Jackpot
/datum/status_effect/pestra_favor
	id = "pestra_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/pestra_favor

/datum/status_effect/pestra_favor/on_apply()
	playsound(owner, 'sound/misc/fliesloop.ogg', 100, FALSE, -1)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.vomit()
		new /obj/item/natural/worms/leech(get_turf(C))
	owner.adjustToxLoss(-30)
	owner.apply_status_effect(/datum/status_effect/buff/healing, 5)
	owner.apply_status_effect(/datum/status_effect/buff/pestra_care)
	to_chat(owner, span_notice("一声湿漉漉的干呕吐出了一条水蛭，Pestra 的虫群正从体内修补着我。"))
	. = ..()

/datum/status_effect/pestra_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/pestra_favor
	name = "Pestra 的恩泽"
	desc = "水蛭般的净除与爬行的慈悲缓解了毒素，并将你的伤口缝合。"
	icon_state = "status"

//Dendor Jackpot
/datum/status_effect/dendor_favor
	id = "dendor_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/dendor_favor

/datum/status_effect/dendor_favor/on_apply()
	owner.electrocute_act(30, owner)
	owner.emote("painscream")
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, XYLIX_LUCK_TRAIT)
	to_chat(owner, span_warning("你忽然被针刺般的一触电得一颤，Dendor 的力量让你短时间内能在崎岖地面上自由奔行！"))
	. = ..()

/datum/status_effect/dendor_favor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, XYLIX_LUCK_TRAIT)
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/dendor_favor
	name = "Dendor 的恩泽"
	desc = "Dendor 的祝福如针刺般电过你的身体，暂时将你的步伐从大地的束缚中解放。"
	icon_state = "status"

//Abyssor Jackpot
/datum/status_effect/abyssor_favor
	id = "abyssor_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/abyssor_favor

/datum/status_effect/abyssor_favor/on_apply()
	playsound(owner, 'sound/misc/undertow.ogg', 75, FALSE)
	if(prob(50))
		owner.stamina_add(-round(owner.max_stamina * 0.8))
		owner.energy_add(-round(owner.max_energy * 0.2))
		owner.adjustOxyLoss(30)
		owner.losebreath += 2
		owner.Dizzy(10)
		owner.blur_eyes(10)
		owner.emote("drown")
		to_chat(owner, span_warning("Abyssor 的深渊攫住了你的肺腑，扯走了你的呼吸，也抽干了你的精力！"))
	else
		owner.stamina_add(round(owner.max_stamina * 0.8))
		owner.energy_add(round(owner.max_energy * 0.2))
		to_chat(owner, span_notice("一股清凉的潮汐拂过你的心神，恢复了你的精力。"))
	. = ..()

/datum/status_effect/abyssor_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/abyssor_favor
	name = "Abyssor 的恩泽"
	desc = "你唤醒了本不该唤醒之物。它会夺走你的呼吸，或者赐你第二口气。"
	icon_state = "status"

/obj/effect/proc_holder/spell/invoked/xylixlian_luck
	name = "Xylix 的赌运"
	desc = "向你的运气与庇护者发起挑战。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "xylixfort"
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	recharge_time = 2 MINUTES
	miracle = TRUE
	devotion_cost = 50
	var/used_times = 0
	var/last_used = 0
	var/bonus_luck_threshould = 600

/obj/effect/proc_holder/spell/invoked/xylixlian_luck/Initialize(mapload)
	. = ..()

	last_used = world.time

/obj/effect/proc_holder/spell/invoked/xylixlian_luck/cast(list/targets,mob/living/carbon/human/user = usr)
	user.play_overhead_indicator('modular_twilight_axis/icons/mob/overhead_effects.dmi', "xylix_fortune", 30, MUTATIONS_LAYER, soundin = 'modular_twilight_axis/sound/slotmachine.ogg', y_offset = 24)

	to_chat(user, span_danger("Xylix 给了你一次动用他恩泽的机会。"))
	var/luck_bonus = 0
	luck_bonus -= used_times * 5
	luck_bonus += 1.9444 * ((world.time - last_used) / bonus_luck_threshould)
	var/list/patronChances = list(
								XYLIX = 100 - luck_bonus,			RAVOX = 60 -luck_bonus/2,
								EORA = 70 - luck_bonus/2,			NOTHING = 80 - luck_bonus,
								MALUM = 50 - luck_bonus/2,			NOC = 50 - luck_bonus,
								ABYSSOR = 45 - luck_bonus/2,
								NECRA = 50 - luck_bonus/2,
								PESTRA = 40 - luck_bonus/3,
								ASTRATA = 15 + luck_bonus * 1.5,	ZIZO = ceil(10-luck_bonus),
								DENDOR = 40 - luck_bonus/3,
								BAOTHA = 40 - luck_bonus/3,		GRAGGAR = 35 - luck_bonus/3,
								MATTHIOS = 45 - luck_bonus/3
								)

	var/list/chances = typelist("patronChances", patronChances)
	var/result = pickweight(chances)

	used_times += 1
	last_used = world.time

	switch(result)
		if(NOTHING)
			to_chat(user, span_danger("你赢得了……虚无！"))
		if(XYLIX)
			user.apply_status_effect(/datum/status_effect/xylix_blessed_luck)
			new /obj/item/roguecoin/gold(get_turf(user), 1)
			to_chat(user, span_danger("Xylix 的赌运站在你这边！"))
		if(ASTRATA)
			user.apply_status_effect(/datum/status_effect/astrata_favor)
			to_chat(user, span_danger("Astrata 的光辉赐予了你力量！"))
		if(NOC)
			user.apply_status_effect(/datum/status_effect/noc_favor)
			to_chat(user, span_danger("Noc 银辉的阴影笼罩着你！"))
		if(ZIZO)
			user.apply_status_effect(/datum/status_effect/zizo_unfavor)
			to_chat(user, span_danger("Zizo 的面容正在嘲弄你！"))
		if(RAVOX)
			user.apply_status_effect(/datum/status_effect/ravox_favor)
			to_chat(user, span_danger("Ravox 赐予了你力量！"))
		if(ABYSSOR)
			user.apply_status_effect(/datum/status_effect/abyssor_favor)
			to_chat(user, span_danger("Abyssor 的潮汐转瞬之间便倒向了你，或与你为敌！"))
		if(MALUM)
			user.apply_status_effect(/datum/status_effect/malum_favor)
			to_chat(user, span_danger("Malum 重铸了你的身躯，并赐你精力！"))
		if(EORA)
			user.apply_status_effect(/datum/status_effect/eora_favor)
			to_chat(user, span_danger("Eora 的爱意将你环抱！"))
		if(NECRA)
			user.apply_status_effect(/datum/status_effect/necra_favor)
			to_chat(user, span_danger("Necra 的香炉烟雾跟随着你的脚步，净化着前行之路。"))
		if(PESTRA)
			user.apply_status_effect(/datum/status_effect/pestra_favor)
			to_chat(user, span_danger("Pestra 的虫群在你腹中翻涌，驱散毒素并缝合血肉。"))
		if(DENDOR)
			user.apply_status_effect(/datum/status_effect/dendor_favor)
			to_chat(user, span_danger("Dendor 狂野的力量奔流过你的全身，只要你受得住那刺痛之吻！"))
		if(BAOTHA)
			user.apply_status_effect(/datum/status_effect/baotha_favor)
			to_chat(user, span_danger("Baotha 的迷雾攫住了你的身心！"))
		if(GRAGGAR)
			user.apply_status_effect(/datum/status_effect/graggar_favor)
			to_chat(user, span_danger("Graggar 的怒火已在你的血肉上留下烙印！"))
		if(MATTHIOS)
			user.apply_status_effect(/datum/status_effect/matthios_favor)
			to_chat(user, span_danger("Matthios 从你的钱袋里偷走了钱财，好给你上一课何为贪婪！"))
	return ..()

#undef NOTHING
#undef XYLIX
#undef ASTRATA
#undef NOC
#undef ZIZO
#undef RAVOX
#undef ABYSSOR
#undef MALUM
#undef EORA
#undef NECRA
#undef PESTRA
#undef DENDOR
#undef BAOTHA
#undef GRAGGAR
#undef MATTHIOS
