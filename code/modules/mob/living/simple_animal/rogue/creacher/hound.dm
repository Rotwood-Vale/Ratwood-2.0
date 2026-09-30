/mob/living/simple_animal/hostile/retaliate/rogue/wolf/hound
	name = "bog hound"
	desc = "A lean, scarred hound bred by the wardens to run down what the bog hides. It follows its handler and bites whoever bites first."
	ai_controller = /datum/ai_controller/volf/hound

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/hound/proc/bind_to_handler(mob/living/handler)
	owner = handler
	tame = TRUE
	faction = handler.faction.Copy()
	ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, handler)
