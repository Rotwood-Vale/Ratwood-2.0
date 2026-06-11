/obj/effect/proc_holder/spell/self/suicidebomb
	name = "钙骨迸爆"
	desc = "以一场骇人的骨片爆裂将自己引爆。"
	overlay_state = "tragedy"
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	sound = 'sound/magic/swap.ogg'
	warnie = "spellwarning"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	stat_allowed = TRUE
	var/exp_heavy = 0
	var/exp_light = 3
	var/exp_flash = 3
	var/exp_fire = 0

/obj/effect/proc_holder/spell/self/suicidebomb/cast(list/targets, mob/living/user = usr)
	..()
	if(!user)
		return FALSE
	if(user.stat == DEAD)
		return FALSE
	if(alert(user, "你是否要以这具躯壳为祭，引发一场威力惊人的爆炸？", "诡异爆裂", "是", "否") == "否")
		return FALSE
	playsound(get_turf(user), 'sound/magic/antimagic.ogg', 100)
	user.visible_message(
		span_danger("[user] 的身躯开始剧烈颤抖，刺目的强光正从其体内迸射而出！"), 
		span_danger("狂暴的能量正从我体内向外膨胀！")
	)

	user.Immobilize(5 SECONDS)
	user.Knockdown(5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(lichdeath), user), 5 SECONDS)

/obj/effect/proc_holder/spell/self/suicidebomb/proc/lichdeath(mob/living/user)
	var/datum/antagonist/lich/lichman = user.mind.has_antag_datum(/datum/antagonist/lich)
	explosion(get_turf(user), -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, soundin = 'sound/misc/explode/incendiary (1).ogg')
	if(lichman && user.stat != DEAD && lichman.consume_phylactery(0)) // Use phylactery at 0 timer. Die if none.
		return TRUE

	user.death()
	return TRUE

/obj/effect/proc_holder/spell/self/suicidebomb/lesser
	name = "次级钙骨迸爆"
	exp_heavy = 0
	exp_light = 2
	exp_flash = 2
	exp_fire = 0
