//Higher health, mixed stat dreamfiend.
/mob/living/simple_animal/hostile/rogue/spirit_respite
	name = "Aspect of Respite"
	desc = ""
	icon = 'modular_helmsguard/icons/mob/gravelord.dmi'
	icon_state = "glord"
	icon_living = "glord"
	gender = MALE
	mob_biotypes = MOB_HUMANOID
	robust_searching = 1
	turns_per_move = 1
	move_to_delay = 3
	STACON = 18
	STASTR = 17
	STASPD = 4
	health = RESPITE_ASPECT_HEALTH
	maxHealth = RESPITE_ASPECT_HEALTH
	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 40
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 1
	base_intents = list(/datum/intent/simple/bite)
	attack_verb_continuous = "hacks"
	attack_verb_simple = "hack"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	defprob = 30
	speak_emote = list("rattles")
	del_on_death = TRUE
	can_have_ai = FALSE //disable native ai
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/spirit_vengeance
	melee_cooldown = SKELETON_ATTACK_SPEED
	footstep_type = FOOTSTEP_MOB_SHOE

/mob/living/simple_animal/hostile/rogue/spirit_respite/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/skel/skeleton_rage (1).ogg','sound/vo/mobs/skel/skeleton_rage (2).ogg','sound/vo/mobs/skel/skeleton_rage (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/skel/skeleton_pain (1).ogg','sound/vo/mobs/skel/skeleton_pain (2).ogg','sound/vo/mobs/skel/skeleton_pain (3).ogg', 'sound/vo/mobs/skel/skeleton_pain (4).ogg', 'sound/vo/mobs/skel/skeleton_pain (5).ogg')
		if("death")
			return pick('sound/vo/mobs/skel/skeleton_death (1).ogg','sound/vo/mobs/skel/skeleton_death (2).ogg','sound/vo/mobs/skel/skeleton_death (3).ogg','sound/vo/mobs/skel/skeleton_death (4).ogg','sound/vo/mobs/skel/skeleton_death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/skel/skeleton_idle (1).ogg','sound/vo/mobs/skel/skeleton_idle (2).ogg','sound/vo/mobs/skel/skeleton_idle (3).ogg')

/mob/living/simple_animal/hostile/rogue/spirit_respite/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal, death), TRUE), 30 SECONDS)
