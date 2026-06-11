// Thieves' Guild antagonist for RT

/datum/antagonist/thievesguild
	name = "盗贼公会"
	roundend_category = "盗贼公会"
	antagpanel_category = "Roguetown"
	show_name_in_check_antagonists = TRUE
	can_coexist_with_others = TRUE
	confess_lines = list(
		"我是盗贼公会的一员！",
		"我为地下犯罪组织效力！",
		"我是个贼，而且以此为荣！",
		"盗贼公会选中了我做他们的行动成员！",
		"我正在接受成为犯罪策士的训练！",
		"我侍奉那个名为盗贼公会的阴影组织！",
		"我是个游荡恶徒，也是个无赖！",
		"盗贼公会招募我来执行他们的诡计！",
		"我是秘密犯罪网络中的一员！",
		"我在阴影中为盗贼公会效力！"
	)

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
		owner.special_items["开锁戒"] = /obj/item/lockpickring/mundane
		owner.special_items["强效毒药"] = /obj/item/reagent_containers/glass/bottle/rogue/strongpoison
		// Assign objective if not already present
		if(!objectives.len)
			var/datum/objective/thieves_guild_objective/obj = new /datum/objective/thieves_guild_objective(owner = owner)
			objectives += obj
			// Add objective to memory
			owner.store_memory("目标：[obj.explanation_text]")
			// Show objective to player
			to_chat(owner.current, "<span class='danger'>你已被选为一个秘密犯罪公会的行动成员。安静地执行命令，避免引起怀疑。</span>")
			to_chat(owner.current, "<span class='danger'>你的目标：[obj.explanation_text]</span>")
			to_chat(owner.current, "<span class='notice'>你可以稍后在“笔记”页签的“记忆”中再次查看这个目标。</span>")

/datum/antagonist/thievesguild/apply_innate_effects(mob/living/mob_override)
	..()
	if(mob_override)
		mob_override.grant_language(/datum/language/thievescant, source = "[type]")

/datum/antagonist/thievesguild/remove_innate_effects(mob/living/mob_override)
	..()
	if(mob_override)
		mob_override.remove_language(/datum/language/thievescant, source = "[type]")
