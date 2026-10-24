// Thieves' Guild antagonist for RT

/datum/antagonist/thievesguild
	name = "Thieves' Guild"
	roundend_category = "thievesguild"
	antagpanel_category = "Roguetown"
	briefing_title = "The Thieves' Guild"
	briefing_text = "By day you are another face in the crowd. By night you belong to the Guild: a web of cutpurses, lockpicks and quiet knives that has bled this town for longer than the Duke has worn his crown. The Guild has set you a task, and it will not be forgotten. Do the work, keep your hands clean where you can, and remember that a thief who is caught answers to the gallows, not to the Guild."
	briefing_tips = list(
		"You know thieves' cant. Speak it where honest ears are listening and your brothers and sisters can pass word without a soul understanding.",
		"Your lockpick ring and your vial are tools for the job, not for show. A good lock opens quietly, and a good poison leaves no one to point a finger.",
		"The best theft is the one nobody notices until you are long gone. Mind your witnesses, and mind the watch.",
		"Coin, a prize or a corpse: whatever the Guild asks of you, it only counts if you still have it when the dust settles.",
		"The Guild is not a family. Fellow thieves are useful, but they will sell you the moment the noose gets tight. Trust sparingly."
	)
	show_name_in_check_antagonists = TRUE
	can_coexist_with_others = TRUE
	confess_lines = list(
		"I am a member of the Thieves' Guild!",
		"I work for the underground crime syndicate!",
		"I am a thief and proud of it!",
		"The Thieves' Guild has chosen me as their operative!",
		"I am a criminal mastermind in training!",
		"I serve the shadowy organization known as the Thieves' Guild!",
		"I am a rogue and a scoundrel!",
		"The Thieves' Guild has recruited me for their schemes!",
		"I am a member of the secret crime network!",
		"I work in the shadows for the Thieves' Guild!"
	)
	rogue_enabled = TRUE

/datum/antagonist/thievesguild/on_gain()
	..()
	if(owner && owner.current)
		// Grant Thieves' Cant
		owner.current.grant_language(/datum/language/thievescant, source = "[type]")
		// Grant skill bonuses
		owner.current.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
		owner.current.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
		owner.current.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		// Only add items to special inventory, do not spawn them directly
		owner.special_items["Lockpick Ring"] = /obj/item/lockpickring/mundane
		owner.special_items["Strong Poison"] = /obj/item/reagent_containers/glass/bottle/rogue/strongpoison
		owner.special_items["Sleep Poison"] = /obj/item/reagent_containers/glass/bottle/sleep
		// Assign objective if not already present
		if(!objectives.len)
			var/datum/objective/thieves_guild_objective/obj = new /datum/objective/thieves_guild_objective(owner = owner)
			objectives += obj
			// Add objective to memory
			owner.store_memory("Objective: [obj.explanation_text]")
			// Show objective to player
			to_chat(owner.current, "<span class='danger'>You have been chosen as an operative of a secret crime guild. Carry out your orders quietly and avoid suspicion.</span>")
			to_chat(owner.current, "<span class='danger'>Your objective: [obj.explanation_text]</span>")
			to_chat(owner.current, "<span class='notice'>You can retrieve your thieves guild tools from a statue, or a tree.</span>")

/datum/antagonist/thievesguild/apply_innate_effects(mob/living/mob_override)
	..()
	if(mob_override)
		mob_override.grant_language(/datum/language/thievescant, source = "[type]")

/datum/antagonist/thievesguild/remove_innate_effects(mob/living/mob_override)
	..()
	if(mob_override)
		mob_override.remove_language(/datum/language/thievescant, source = "[type]")
