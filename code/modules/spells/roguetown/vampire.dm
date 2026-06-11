/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/Shapeshift(mob/living/carbon/human/caster)
	if(!istype(caster)) // FVCK OFF
		return

	var/obj/shapeshift_holder/H = locate() in caster
	if(H)
		to_chat(caster, span_warning("我已经处于变形状态了！"))
		return

	if(!do_after(caster, (SHAPESHIFT_MOVEAFTER - caster.get_vampire_generation()) SECONDS, target = caster))
		to_chat(caster, span_userdanger("我无法集中足够的精神完成变形！"))
		return

	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat
	name = "蝙蝠形态"
	desc = ""
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat
	shifted_speed_increase = 1.25
	show_true_name = FALSE
	convert_damage = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform
	name = "雾形"
	desc = ""
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/gaseousform
	convert_damage = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/crow
	name = "Zad 形态"
	overlay_state = "zad"
	desc = ""
	gesture_required = TRUE
	chargetime = 500 SECONDS
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	do_gib = TRUE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat/crow
	sound = 'sound/vo/mobs/bird/birdfly.ogg'
	shifted_speed_increase = 1.25
	show_true_name = FALSE
	convert_damage = FALSE
	invocations = list("Zad，赐我此形！")
	invocation_type = "shout"

/obj/effect/proc_holder/spell/targeted/shapeshift/rat
	name = "鼠形"
	desc = ""
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	die_with_shapeshifted_form = FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/smallrat

/obj/effect/proc_holder/spell/targeted/shapeshift/cabbit
	name = "兔蟹形态"
	desc = ""
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	die_with_shapeshifted_form = FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit
