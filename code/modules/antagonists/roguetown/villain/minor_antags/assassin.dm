// Assassin, cultist of graggar. Normally found as a drifter.
/datum/antagonist/assassin
	name = "刺客"
	roundend_category = "刺客"
	antagpanel_category = "刺客"
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "assassin"
	show_name_in_check_antagonists = TRUE
	confess_lines = list(
		"我的信条即是鲜血！",
		"匕首告诉了我该杀谁！",
		"死亡就是我的信仰！",
		"黑暗之日指引着我的手！",
	)
	antag_flags = FLAG_FAKE_ANTAG

	var/traits_assassin = list(
		TRAIT_ASSASSIN,
		TRAIT_NOSTINK,
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
	)

/datum/antagonist/assassin/on_gain()
	owner.current.cmode_music = list('sound/music/cmode/antag/combat_assassin.ogg')
	var/yea = /obj/item/rogueweapon/huntingknife/idagger/steel/profane
	owner.special_items["亵渎匕首"] = yea // Assigned assassins can get their special dagger from right clicking certain objects.
	to_chat(owner.current, "<span class='danger'>直到现在我都伪装得很好，但现在该让 格拉加尔 的猎物灭亡了。我必须去取回我藏起来的匕首。</span>")
	return ..()

/mob/living/carbon/human/proc/who_targets() // Verb for the assassin to remember their targets.
	set name = "回想目标"
	set category = "格拉加尔"
	if(!mind)
		return
	mind.recall_targets(src)

/datum/antagonist/assassin/on_removal()
	if(!silent && owner.current)
		to_chat(owner.current,"<span class='danger'>我脑海中的血红迷雾正在消散。我不再是[name]了！</span>")
	return ..()

/datum/antagonist/assassin/on_life(mob/user)
	if(!user)
		return
	var/mob/living/carbon/human/H = user
	H.verbs |= /mob/living/carbon/human/proc/who_targets

/datum/antagonist/assassin/roundend_report()
	var/traitorwin = FALSE
	for(var/obj/item/I in owner.current) // Check to see if the Assassin has their profane dagger on them, and then check the souls contained therein.
		if(istype(I, /obj/item/rogueweapon/huntingknife/idagger/steel/profane))
			for(var/mob/dead/observer/profane/A in I) // Each trapped soul is announced to the server
				if(A)
					to_chat(world, "[A.name] 已被 [owner.name] 献给 格拉加尔 夺走。<span class='greentext'>诅咒降临！</span>")
					traitorwin = TRUE

	if(!considered_alive(owner))
		traitorwin = FALSE

	if(traitorwin)
		to_chat(world, "<span class='greentext'>[name] [owner.name] 凯旋了！</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, "<span class='redtext'>[name] [owner.name] 失败了！</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)
