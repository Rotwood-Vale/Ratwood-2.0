/mob/living/simple_animal/hostile/lizard
	name = "蜥蜴"
	desc = ""
	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard_dead"
	speak_emote = list("嘶嘶作响")
	health = 5
	maxHealth = 5
	faction = list("Lizard")
	attack_verb_continuous = "咬了"
	attack_verb_simple = "咬"
	melee_damage_lower = 1
	melee_damage_upper = 2
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "驱赶了"
	response_disarm_simple = "驱赶"
	response_harm_continuous = "踩了"
	response_harm_simple = "踩"
	ventcrawler = VENTCRAWLER_ALWAYS
	density = FALSE
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST|MOB_REPTILE
	gold_core_spawnable = FRIENDLY_SPAWN
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	var/static/list/edibles = typecacheof(list(/mob/living/simple_animal/butterfly, /mob/living/simple_animal/cockroach)) //list of atoms, however turfs won't affect AI, but will affect consumption.

/mob/living/simple_animal/hostile/lizard/CanAttack(atom/the_target)//Can we actually attack a possible target?
	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE
	if(is_type_in_typecache(the_target,edibles))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/lizard/AttackingTarget()
	if(is_type_in_typecache(target,edibles)) //Makes sure player lizards only consume edibles.
		visible_message(span_notice("[name]一口吞下了[target]。"), span_notice("我一口吞下了[target]。"))
		QDEL_NULL(target) //Nom
		adjustBruteLoss(-2)
		return TRUE
	else
		return ..()

/mob/living/simple_animal/hostile/lizard/space
	name = "太空蜥蜴"
	desc = ""
	icon_state = "lizard_space"
	icon_living = "lizard_space"
	unsuitable_atmos_damage = 0
	minbodytemp = TCMB
	maxbodytemp = T0C + 40
