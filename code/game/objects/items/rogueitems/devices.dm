/obj/item/gem_device
	name = "红宝石"
	icon_state = "ruby_cut"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "它的切面闪耀得异常明亮。"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	var/usage_prompt
	resistance_flags = FIRE_PROOF

/obj/item/gem_device/attack_self(mob/living/user)
	var/alert = alert(user, "我要使用这个吗？\n[usage_prompt]", "附魔宝石", "是", "否")
	if(alert != "是")
		return
	if(!on_use(user))
		to_chat(user, span_warning("[src]发出光芒，随后熄灭了！"))
		return
	to_chat(user, span_warning("[src]在一道明亮火花中消失了！"))
	qdel(src)

/obj/item/gem_device/proc/on_use(mob/living/user)
	return FALSE

/obj/item/gem_device/goldface
	name = "祖母绿"
	icon_state = "emerald_cut"
	desc = "闪烁着翠绿的华彩。"
	usage_prompt = "召唤GOLDFACE"

/obj/item/gem_device/goldface/on_use(mob/living/user)
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	do_sparks(3, TRUE, step_turf)
	new /obj/structure/roguemachine/goldface(step_turf)
	to_chat(user, span_notice("一道强光闪过，一个GOLDFACE出现在你面前！"))
	return TRUE
