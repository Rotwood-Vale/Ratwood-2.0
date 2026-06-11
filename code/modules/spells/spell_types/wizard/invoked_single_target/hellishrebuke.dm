//Disabled outside of staff use. Good god don't give this out.
/obj/effect/proc_holder/spell/invoked/rebuke
	name = "炼狱斥咒"
	desc = "只需一指点出，便能令面前的生物当场燃烧，并持续承受火焰伤害。即便被捂住嘴也能施放。"
	cost = 3
	overlay_state = "hellish_rebuke"
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 1
	chargetime = 5
	charging_slowdown = 2
	recharge_time = 6 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokefire
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocation_type = "none"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE
	range = 1
	ignore_los = FALSE


/obj/effect/proc_holder/spell/invoked/rebuke/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		target.adjustFireLoss(30) //damage
		target.adjust_fire_stacks(4)
		target.ignite_mob()
		target.visible_message(span_warning("[user] 朝着 [target] 比出一个粗鄙手势，令其当场燃起熊熊烈焰！"), \
		span_userdanger("[user] 朝我比出一个粗鄙手势，我顿时被火焰吞没了！"))
		playsound(get_turf(target), 'sound/misc/explode/incendiary (1).ogg', 100, TRUE)

