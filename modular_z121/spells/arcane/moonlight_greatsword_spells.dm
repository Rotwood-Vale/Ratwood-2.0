#define MOONLIGHT_ACTION_ICON 'modular_z121/assets/spells/moonlight_greatsword/actions_spells.dmi'
#define MOONLIGHT_WAVE_DURATION (5 SECONDS)

/atom/movable/screen/alert/status_effect/buff/moonlight_blessing
	name = "月之祝福"
	desc = "月光抚慰着我的躯体与灵魂，全属性暂时提高。"
	icon_state = "buff"

/datum/status_effect/buff/moonlight_blessing
	id = "moonlight_blessing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/moonlight_blessing
	duration = 3 MINUTES
	effectedstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_LCK = 2,
	)

/datum/status_effect/buff/moonlight_blessing/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	return ..()

/datum/status_effect/buff/moonlight_blessing/on_apply()
	. = ..()
	if(!.)
		return FALSE
	to_chat(owner, span_notice("柔和的月光浸入四肢百骸，我的身心都被白龙遗留的力量所祝福。"))
	return TRUE

/datum/status_effect/buff/moonlight_blessing/on_remove()
	. = ..()
	to_chat(owner, span_warning("萦绕周身的月华渐渐散去，那份祝福也随之沉寂。"))

/obj/effect/moonlight_wave_segment
	name = "月光波动"
	icon = 'icons/effects/effects.dmi'
	icon_state = "obeliskbeam_mid"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_system = MOVABLE_LIGHT
	light_color = "#77dfff"
	light_power = 2
	light_outer_range = 2
	color = "#8fe8ff"
	alpha = 220
	var/datum/weakref/creator_ref
	var/next_damage_tick = 0

/obj/effect/moonlight_wave_segment/Initialize(mapload, mob/living/maker)
	. = ..()
	if(maker)
		creator_ref = WEAKREF(maker)
	set_light_range(1.5, 2)
	set_light_power(2)
	set_light_color("#77dfff")
	set_light_on(TRUE)
	START_PROCESSING(SSfastprocess, src)
	QDEL_IN(src, MOONLIGHT_WAVE_DURATION)

/obj/effect/moonlight_wave_segment/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/moonlight_wave_segment/process()
	if(world.time < next_damage_tick)
		return
	next_damage_tick = world.time + 1 SECONDS
	var/mob/living/creator = creator_ref?.resolve()
	for(var/mob/living/target in loc)
		if(target == creator)
			continue
		target.apply_damage(15, BRUTE)
		target.apply_damage(15, BURN)
		to_chat(target, span_userdanger("幽蓝的月光洪流撕裂并灼烧着我的身体！"))

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell
	name = "月光秘术"
	desc = "这是从月光大剑中苏醒的古老魔法。"
	associated_skill = /datum/skill/magic/arcane
	cost = 0
	xp_gain = FALSE
	releasedrain = 0
	chargedrain = 0
	human_req = TRUE
	warnie = "spellwarning"
	spell_tier = 4
	invocation_type = "whisper"
	no_early_release = TRUE
	movement_interrupt = TRUE
	gesture_required = TRUE
	action_icon = MOONLIGHT_ACTION_ICON
	action_background_icon_state = ""
	var/datum/weakref/source_weapon_ref

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/New(obj/item/rogueweapon/greatsword/moonlight_greatsword/source_weapon)
	if(source_weapon)
		source_weapon_ref = WEAKREF(source_weapon)
	. = ..()

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/proc/get_source_weapon()
	return source_weapon_ref?.resolve()

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/proc/validate_moonlight_weapon(mob/living/user, silent = FALSE)
	var/obj/item/rogueweapon/greatsword/moonlight_greatsword/weapon = get_source_weapon()
	if(!weapon)
		if(!silent)
			to_chat(user, span_warning("唤醒这道秘术的月光大剑已经不在我手中了。"))
		return FALSE
	if(!weapon.moonlight_active)
		if(!silent)
			to_chat(user, span_warning("天穹中没有足够明亮的月色，月光大剑暂时无法回应我的呼唤。"))
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.get_active_held_item() != weapon && H.get_inactive_held_item() != weapon)
		if(!silent)
			to_chat(user, span_warning("我必须亲手握住月光大剑，才能引导这道秘术。"))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/cast_check(skipcharge = 0, mob/user = usr)
	. = ..()
	if(!.)
		return FALSE
	return validate_moonlight_weapon(user)

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave
	name = "月之波动"
	desc = "月光的力量在剑身之上涌动，只待你的意志下达命令。"
	recharge_time = 10 MINUTES
	cooldown_min = 10 MINUTES
	chargetime = 0
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("月光，奔涌吧。")
	action_icon_state = "moon_wave"
	overlay_state = "moon_wave"

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave/cast(list/targets, mob/living/user = usr)
	if(!validate_moonlight_weapon(user))
		revert_cast(user)
		return FALSE

	user.visible_message(span_notice("[user] 将月光大剑横在身前，幽蓝月华正沿着剑脊迅速汇聚。"), span_notice("我将月光大剑横在身前，任由月华在剑身之上奔涌汇聚。"))
	if(!do_after(user, 2 SECONDS, target = user))
		to_chat(user, span_warning("月之波动的蓄势被打断了。"))
		revert_cast(user)
		return FALSE
	if(!validate_moonlight_weapon(user))
		revert_cast(user)
		return FALSE

	var/turf/origin = get_turf(user)
	if(!origin)
		revert_cast(user)
		return FALSE

	var/turf/target_turf = get_ranged_target_turf(user, user.dir, 15)
	var/list/beam_segments = list()
	for(var/turf/T in getline(origin, target_turf) - origin)
		if(T.density || T.opacity)
			break
		var/blocked = FALSE
		for(var/obj/obstacle in T.contents)
			if(obstacle.density || obstacle.opacity)
				blocked = TRUE
				break
		if(blocked)
			break
		var/obj/effect/moonlight_wave_segment/segment = new(T, user)
		segment.dir = user.dir
		beam_segments += segment

	if(!beam_segments.len)
		to_chat(user, span_warning("面前的阻挡太近，月光波动还未成形便被压碎了。"))
		revert_cast(user)
		return FALSE

	var/obj/effect/moonlight_wave_segment/first_segment = beam_segments[1]
	var/obj/effect/moonlight_wave_segment/last_segment = beam_segments[beam_segments.len]
	first_segment.icon_state = "obeliskbeam_start"
	last_segment.icon_state = "obeliskbeam_end"

	playsound(origin, 'sound/magic/obeliskbeam.ogg', 100, FALSE, 0, 3)
	user.Paralyze(MOONLIGHT_WAVE_DURATION)
	user.visible_message(span_warning("[user] 将月光大剑朝前一引，幽蓝洪流沿着夜色轰然奔涌！"), span_notice("我将月色压入剑身，再一口气把它释放成奔腾的月光洪流。"))
	return TRUE

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing
	name = "月之祝福"
	desc = "呼唤月光的力量，祈求月亮的祝福。"
	recharge_time = 15 MINUTES
	cooldown_min = 15 MINUTES
	chargetime = 0
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("月华啊，加诸吾身。")
	action_icon_state = "moon_blessing"
	overlay_state = "moon_blessing"

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing/cast(list/targets, mob/living/user = usr)
	if(!validate_moonlight_weapon(user))
		revert_cast(user)
		return FALSE

	user.visible_message(span_notice("[user] 双手稳住月光大剑，低声祈请夜空中的月辉降下赐福。"), span_notice("我稳住月光大剑，向月色献上祈请，让那股古老而清冷的力量缓缓汇入体内。"))
	if(!do_after(user, 10 SECONDS, target = user))
		to_chat(user, span_warning("月之祝福的祈祷被打断了。"))
		revert_cast(user)
		return FALSE
	if(!validate_moonlight_weapon(user))
		revert_cast(user)
		return FALSE

	var/already_blessed = user.has_status_effect(/datum/status_effect/buff/moonlight_blessing)
	user.apply_status_effect(/datum/status_effect/buff/moonlight_blessing, 3 MINUTES)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	if(already_blessed)
		user.visible_message(span_notice("[user] 周身再度漾起柔和月华。"))
		to_chat(user, span_notice("我重新续上了月之祝福，流淌在体内的月光再度变得充盈。"))
	else
		user.visible_message(span_notice("[user] 的身躯被一层柔和月辉所笼罩。"))
		to_chat(user, span_notice("月光如潮水般浸透我的身躯，希斯遗留的祝福正在强化我的每一寸血肉。"))
	return TRUE

#undef MOONLIGHT_WAVE_DURATION
#undef MOONLIGHT_ACTION_ICON
