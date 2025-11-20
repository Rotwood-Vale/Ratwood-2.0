/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/Shapeshift(mob/living/carbon/human/caster)
	if(!istype(caster)) // FVCK OFF
		return

	var/obj/shapeshift_holder/H = locate() in caster
	if(H)
		to_chat(caster, span_warning("You're already shapeshifted!"))
		return

	if(!do_after(caster, (SHAPESHIFT_MOVEAFTER - caster.get_vampire_generation()) SECONDS, target = caster))
		to_chat(caster, span_userdanger("You are unable to concentrate enough to shapeshift!"))
		return

	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat
	name = "Bat Form"
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
	name = "Mist Form"
	desc = ""
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/gaseousform
	convert_damage = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/crow
	name = "Zad Form"
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
	invocations = list("Zad formus!")
	invocation_type = "shout"

/obj/effect/proc_holder/spell/targeted/shapeshift/rat
	name = "Rat Form"
	desc = ""
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	die_with_shapeshifted_form = FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/smallrat

/obj/effect/proc_holder/spell/targeted/shapeshift/cabbit
	name = "Cabbit Form"
	desc = ""
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	die_with_shapeshifted_form = FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit
