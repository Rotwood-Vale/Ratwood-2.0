/mob/living/simple_animal/hostile/retaliate/poison
	var/poison_per_bite = 0
	var/poison_type = /datum/reagent/toxin

// todo: envenomated component that registerse to COMSIG_HOSTILE_ATTACKINGTARGET?
/mob/living/simple_animal/hostile/retaliate/poison/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.reagents && !poison_per_bite == 0)
			L.reagents.add_reagent(poison_type, poison_per_bite)
		return .

/mob/living/simple_animal/hostile/retaliate/poison/snake
	name = "snake"
	desc = ""
	icon_state = "snake"
	icon_living = "snake"
	icon_dead = "snake_dead"
	speak_emote = list("hisses")
	health = 20
	maxHealth = 20
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	melee_damage_lower = 5
	melee_damage_upper = 6
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "steps on"
	response_harm_simple = "step on"
	faction = list("hostile")
	ventcrawler = VENTCRAWLER_ALWAYS
	density = FALSE
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST|MOB_REPTILE
	gold_core_spawnable = FRIENDLY_SPAWN
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE


/mob/living/simple_animal/hostile/retaliate/poison/snake/ListTargets(atom/the_target)
	var/old_aggressive = aggressive
	aggressive = TRUE // so we target all mice in view, not just enemies
	. = ..() //get list of things in vision range
	aggressive = old_aggressive
	var/list/mice = list()
	for(var/mob/living/simple_animal/mouse/mouse in .)
		mice += mouse
	//Yum a tasty mouse
	if(length(mice))
		return mice
	// if no tasty mice to chase, lets chase any enemies in our vision range
	return . & enemies

/mob/living/simple_animal/hostile/retaliate/poison/snake/AttackingTarget()
	if(istype(target, /mob/living/simple_animal/mouse))
		visible_message(span_notice("[name] consumes [target] in a single gulp!"), span_notice("I consume [target] in a single gulp!"))
		QDEL_NULL(target)
		adjustBruteLoss(-2)
	else
		return ..()
