//The antipope. The evil twin sibling of Bishop.
//Locked to Inhumen. Powerful support class with, however, very limited combat potential.
//Gets the ability to torture, recycled from normal heretic, combined with EVIL sermons and some extra miracles from other Inhumen patrons.
#define EVIL_PRIEST_SERMON_COOLDOWN (30 MINUTES)
#define EVIL_PRIEST_SWITCH_FAITH_COOLDOWN (10 MINUTES)
#define EVIL_PRIEST_ANNOUNCEMENT_COOLDOWN (5 MINUTES)
#define EVIL_PRIEST_CURSE_COOLDOWN (15 MINUTES)

/datum/advclass/wretch/antipope
	name = "Heresiarch" //formerly Doomsayer
	tutorial = "They are pretentious. They are weak. They are complacent. And they are hopeless. But you. You will change this. \
	A high-ranking official of the Holy Ecclesial, for your deeds you have been blessed by the Four Ascendants to bring upon change and be their God Hand. \
	But this change will be resisted. Crush the dissent. Show them why it is better to rule in Gehenna than serve under the Firmament."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS //The Inhumen discriminate not.
	outfit = /datum/outfit/job/roguetown/wretch/antipope
	cmode_music = 'sound/music/combat_cult.ogg'
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_WRETCH)
//Seer to see other Inhumen.
	traits_applied = list(TRAIT_HERETIC_SEER, TRAIT_GODHAND, TRAIT_RITUALIST, TRAIT_GRAVEROBBER, TRAIT_RESONANCE, TRAIT_OVERTHERETIC)
//Support class statline, somewhat better than Bishop's. No armour traits, DE or CR, so needs good stats desperately.
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
	)
	maximum_possible_slots = 1//THERE CAN BE ONLY ONE GOD HAND.
	subclass_skills = list(//Has Expert in two comparatively bad weapon types, otherwise supposed to be a support rather than a frontliner.
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, //For self-defence, no STR so can't grab well, only resist
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER, //You are Ascendants' chosen.
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "Inhumen exclusive. No wretch bounty, for the purpose of infiltration and doomsaying. Given EVIL sermon abilities, torture, maxed out miracles of their own patron and some extra miracles from other Inhumen patrons."

/datum/outfit/job/roguetown/wretch/antipope
	has_loadout = TRUE

//Starts with some basic leather armour.
/datum/outfit/job/roguetown/wretch/antipope/pre_equip(mob/living/carbon/human/H)
	if(!istype(H.patron, /datum/patron/inhumen))
		H.set_patron(/datum/patron/inhumen/zizo)//If you're not of the Inhumen before? You are now!
	head = /obj/item/clothing/head/roguetown/roguehood
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/woodstaff/quarterstaff
	if(istype(H.patron, /datum/patron/inhumen/zizo))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/g
	if(istype(H.patron, /datum/patron/inhumen/graggar))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
	if(istype(H.patron, /datum/patron/inhumen/baotha))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
	if(istype(H.patron, /datum/patron/inhumen/matthios))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/ritechalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/organ/heart = 1,
	)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 6, TRUE)

	if(H.mind)
		wretch_select_bounty(H)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/silence)//Shut that guy up!
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/nondetection)//For the purposes of meeting folks.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)//See above.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/evil_resurrect)//Sacrifice a heart to bring somebody back to life.
		H.verbs |= /mob/living/carbon/human/proc/completesermon_evil
		H.verbs |= /mob/living/carbon/human/proc/revelations
		H.verbs |= /mob/living/carbon/human/proc/switch_faith_antipope
		H.verbs |= /mob/living/carbon/human/proc/church_evil_announcement

		H.mind.current.faction += "[H.name]_faction" // for necromancing

		//gives hieresiath faith traits of every assendant patron 
		for(var/path as anything in GLOB.patrons_by_faith[/datum/faith/inhumen])
			var/datum/patron/patron = GLOB.patronlist[path]
			if(!patron || !patron.name)
				continue
			patron.on_gain(H)
		//and any potential patreon specyfic launguthes
		H.grant_language(/datum/language/thievescant) // mathias
		H.grant_language(/datum/language/undead) // zizo
		
		ADD_TRAIT(H, TRAIT_DEATHSIGHT, "godhand") // zizo cleric trait

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()

/datum/outfit/job/roguetown/wretch/antipope/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.choose_miracles_heresiarch()


/mob/living/carbon/human/proc/choose_miracles_heresiarch()
	var/t3_count = 1
	var/t2_count = 1
	var/t1_count = 1
	var/t0_count = 1
	var/list/t3 = list()
	var/list/t2 = list()
	var/list/t1 = list()
	var/list/t0 = list()
	for(var/path as anything in GLOB.patrons_by_faith[/datum/faith/inhumen])
		var/datum/patron/patron = GLOB.patronlist[path]
		if(!patron || !patron.name)
			continue
		for(var/miracle in patron.miracles)
			var/obj/effect/proc_holder/checked_miracle = miracle
			if(patron.miracles[checked_miracle] == CLERIC_T3)
				t3[initial(checked_miracle.name)] = checked_miracle
			if(patron.miracles[checked_miracle] == CLERIC_T2)
				t2[initial(checked_miracle.name)] = checked_miracle
			if(patron.miracles[checked_miracle] == CLERIC_T1)
				t1[initial(checked_miracle.name)] = checked_miracle
			if(patron.miracles[checked_miracle] == CLERIC_T0)
				t0[initial(checked_miracle.name)] = checked_miracle
	for(var/miracle in t3)
		if(src.mind?.has_spell(t3[miracle]))
			t3.Remove(miracle)
	for(var/miracle in t2)
		if(src.mind?.has_spell(t2[miracle]))
			t2.Remove(miracle)
	for(var/miracle in t1)
		if(src.mind?.has_spell(t1[miracle]))
			t1.Remove(miracle)
	for(var/miracle in t0)
		if(src.mind?.has_spell(t0[miracle]))
			t0.Remove(miracle)
	for(var/i in 1 to t3_count)
		var/t3_choice = input(src,"Choose your Tier Three Miracle.", "TAKE UP DARK KNOWLEDGE ([t3_count] CHOICES REMAIN)") as anything in t3
		if(t3_choice)
			var/obj/effect/proc_holder/chosen_miracle = t3[t3_choice]
			src.mind?.AddSpell(new chosen_miracle)
			t3.Remove(t3_choice)
			t3_count--
	for(var/i in 1 to t2_count)
		var/t2_choice = input(src,"Choose your Tier Two Miracle.", "TAKE UP DARK KNOWLEDGE ([t2_count] CHOICES REMAIN)") as anything in t2
		if(t2_choice)
			var/obj/effect/proc_holder/chosen_miracle = t2[t2_choice]
			src.mind?.AddSpell(new chosen_miracle)
			t2.Remove(t2_choice)
			t2_count--
	for(var/i in 1 to t1_count)
		var/t1_choice = input(src,"Choose your Tier One Miracle.", "TAKE UP DARK KNOWLEDGE ([t1_count] CHOICES REMAIN)") as anything in t1
		if(t1_choice)
			var/obj/effect/proc_holder/chosen_miracle = t1[t1_choice]
			src.mind?.AddSpell(new chosen_miracle)
			t1.Remove(t1_choice)
			t1_count--
	for(var/i in 1 to t0_count)
		var/t0_choice = input(src,"Choose your Tier Zero Miracle.", "TAKE UP DARK KNOWLEDGE ([t0_count] CHOICES REMAIN)") as anything in t0
		if(t0_choice)
			var/obj/effect/proc_holder/chosen_miracle = t0[t0_choice]
			src.mind?.AddSpell(new chosen_miracle)
			t0.Remove(t0_choice)
			t0_count--

	if(src.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_undead_formation/miracle))
		src.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/command_undead)
		src.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)


/mob/living/carbon/human/proc/completesermon_evil()
	set name = "Inhumen Sermon"
	set category = "Antipope"

	if (!mind)
		return

	//ANYWHERE, really, EXCEPT the chapel.
	if (istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("I can't do this here! They'll know!"))
		return FALSE

	if (!COOLDOWN_FINISHED(src, priest_sermon))
		to_chat(src, span_warning("You cannot inspire others so early."))
		return

	src.visible_message(span_notice("[src] begins preaching a sermon..."))

	if (!do_after(src, 120, target = src)) // 120 seconds
		src.visible_message(span_warning("[src] stops preaching."))
		return

	src.visible_message(span_notice("[src] finishes the sermon, inspiring those nearby!"))
	playsound(src.loc, 'sound/magic/ahh2.ogg', 80, TRUE)
	COOLDOWN_START(src, priest_sermon, EVIL_PRIEST_SERMON_COOLDOWN)

	for (var/mob/living/carbon/human/H in view(7, src))
		if (!H.patron)
			continue
		//We invert the sermon positives and negatives. Wild how that works.
		if (istype(H.patron, /datum/patron/divine) && !HAS_TRAIT(H, TRAIT_HERESIARCH)) //Tennite Wretches won't be affected for the sake of convenience.
			H.apply_status_effect(/datum/status_effect/debuff/hereticsermon)
			H.add_stress(/datum/stressevent/heretic_on_sermon)
			to_chat(H, span_warning("Your patron seethes with disapproval."))
		else if (istype(H.patron, /datum/patron/inhumen))
			H.apply_status_effect(/datum/status_effect/buff/sermon)
			H.add_stress(/datum/stressevent/sermon)
			to_chat(H, span_notice("You feel a divine affirmation from your patron."))
		else
			// Other patrons - fluff only
			to_chat(H, span_notice("Nothing seems to happen to you."))

	return TRUE

/mob/living/carbon/human/proc/revelations()
	set name = "Revelations"
	set category = "Antipope"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/S = get_inactive_held_item()
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("I don't have a victim in my hands!"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I already torture myself."))
		return
	if (!H.restrained())
		to_chat(src, span_warning ("My victim needs to be restrained in order to do this!"))
		return
	if(!istype(S, /obj/item/clothing/neck/roguetown/psicross/inhumen/))
		to_chat(src, span_warning("I need to be holding an inhumen amulet to extract this divination!"))
		return
	for(var/obj/structure/fluff/psycross/zizocross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("I need a large profane shrine structure nearby to extract this divination!"))
		return
	if(!H.stat)
		var/static/list/faith_lines = list(
			"THE TRUTH SHALL SET YOU FREE!",
			"WHO IS YOUR GOD!?",
			"ARE YOU FAITHFUL!?",
			"WHO IS YOUR SHEPHERD!?",
		)
		src.visible_message(span_warning("[src] shoves [S] into [H]'s lux!"))
		say(pick(faith_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return
		H.confess_sins("patron")
		return
	to_chat(src, span_warning("This one is not in a ready state to be questioned..."))

/mob/living/carbon/human/proc/switch_faith_antipope()
	set name = "Change Patron"
	set category = "Antipope"

	if(!mind)
		return

	if (!COOLDOWN_FINISHED(src, priest_change_miracles))
		to_chat(src, span_warning("I cant switch my patrons so often."))
		return

	var/list/god_choice = list()
	var/list/god_type = list()

	for(var/path as anything in GLOB.patrons_by_faith[/datum/faith/inhumen])
		var/datum/patron/patron_choice = GLOB.patronlist[path]
		if(!patron_choice || !patron_choice.name)
			continue

		god_choice += list("[patron_choice.name]" = icon(icon = 'icons/mob/overhead_effects.dmi', icon_state = "sign_[patron_choice.name]"))
		god_type[patron_choice.name] = patron_choice.type

	var/string_choice = show_radial_menu(src, src, god_choice, require_near = FALSE)
	if(!string_choice)
		return
	var/new_patron_type = god_type[string_choice]
	if(!new_patron_type)
		return
	if(patron && istype(patron, new_patron_type))
		to_chat(src, span_info("You already follow [string_choice]."))
		return
	
	//Might as well futureprof
	var/saved_level = CLERIC_T0
	var/saved_max_progression = CLERIC_T1
	var/saved_devotion_gain = CLERIC_REGEN_MINOR
	var/saved_current_devotion = 0

	if(src.devotion)
		saved_level = src.devotion.level
		saved_devotion_gain = src.devotion.passive_devotion_gain
		saved_max_progression = src.devotion.max_progression
		saved_current_devotion = src.devotion.devotion

		src.mind.RemoveAllMiracles()
		if(src.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/command_undead))
			src.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/command_undead)
		if(src.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/gravemark))
			src.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/gravemark)
		src.devotion.Destroy()

	patron = new new_patron_type()

	// Grant new devotion
	var/datum/devotion/new_devotion = new /datum/devotion(src, src.patron)
	src.devotion = new_devotion
	new_devotion.grant_miracles(src, saved_level, saved_devotion_gain, saved_max_progression)
	new_devotion.devotion = saved_current_devotion

	src.choose_miracles_heresiarch()

	COOLDOWN_START(src, priest_change_miracles, EVIL_PRIEST_SWITCH_FAITH_COOLDOWN)

/mob/living/carbon/human/proc/church_evil_announcement() // Like the bishop's announcement, but needs a cross next to you and has a longer coldown
	set name = "Announcement"
	set category = "Antipope"

	if(stat)
		return

	if (istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("I can't do this here! They'll know!"))
		return FALSE

	var/announcementinput = input("Spread Their word", "Make an Announcement") as text|null
	if(announcementinput)
		if(!src.can_speak_vocal())
			to_chat(src,span_warning("I can't speak!"))
			return FALSE
		if (!COOLDOWN_FINISHED(src, priest_announcement))
			to_chat(src, span_warning("You must wait before speaking again."))
			return
	
		var/found_structure = FALSE
		var/list/search_area = view(1, src)
		var/chanelling_cross = null
		for(var/obj/structure/fluff/psycross/A in search_area)
			if(istype(A, /obj/structure/fluff/psycross/zizocross) || istype(A, /obj/structure/fluff/psycross/graggar) || istype(A, /obj/structure/fluff/psycross/baotha) || istype(A, /obj/structure/fluff/psycross/matthios))
				A.visible_message(span_notice("Unholy cross starts to glow with an otherworldly light."))
				found_structure = TRUE
				chanelling_cross = A
				break

		if(!found_structure)
			to_chat(src, span_warning("I need a cross of one of the Four to empower my words."))
			return FALSE
		
		visible_message(span_warning("[src] takes a deep breath, preparing to speak something to the glowing cross.."))
		if(do_after(src, 15 SECONDS, target = src))
			
			found_structure = FALSE
			search_area = view(1, src)
			for(var/obj/structure/fluff/psycross/A in search_area)
				if(A == chanelling_cross)
					found_structure = TRUE
					break
			if(!found_structure)
				to_chat(src, span_warning("The cross is no longer present!"))
				return FALSE

			visible_message(span_notice("[src] speaks to the cross, and the words echo across the realm!"))
			say(announcementinput)
			priority_announce("[announcementinput]", "Heresiarch preaches", 'sound/misc/bell.ogg', sender = src)
			COOLDOWN_START(src, priest_announcement, EVIL_PRIEST_ANNOUNCEMENT_COOLDOWN) // Double and a half the coldown since your gods have to intervene to even let you do so, and EVIL announcment shoudnt be spamable
		else
			to_chat(src, span_warning("Your announcement was interrupted!"))
			return FALSE


/mob/living/carbon/human/proc/evil_churchecancurse(mob/living/carbon/human/H, apostasy = FALSE)
	
	//Flavor messages for cursing certain god's faithful.
	if(istype(H.patron, /datum/patron/divine/dendor))
		to_chat(src, span_warning("The mad god Dendor is felt strongly. The wolf in this one balks and trashes as it is faintly restrained. Yet his madness but a pale shadow of Graggar own and the strugle will be short."))

	//Abyssor's clergy are gripped by his dream.
	if (istype(H.patron, /datum/patron/divine/abyssor))
		to_chat(src, span_warning("The Dreamer, Abyssor has his clutches grasped firmly around this one. The light of the divine only barely penetrates the depths."))
		ADD_TRAIT(H, TRAIT_CURSE_RESIST, TRAIT_GENERIC)

	if(HAS_TRAIT(H, TRAIT_GODHAND))
		to_chat(src, span_warning("Four will not curse thier own chosen!"))
		return FALSE

	if(H.job == /datum/job/roguetown/priest)
		to_chat(src, span_warning("Ten stand behind this one united, the curse cant gain a foothold!"))
		return FALSE

	if(H.job == /datum/job/roguetown/absolver) // absolvers alredy are proven to be able to undo gods works with the armour ritual, and can remove vampirism and werwolfism with their lux manipulation, i think thats a resonable combination of those facts
		to_chat(src, span_warning("The curse have been unvoven by mortal hands before it coudl get a hold!"))
		to_chat(H, span_warning("Something have tried to gain a hold on your lux, but you managed to remove it!"))
		return FALSE

	// Ascendants may in fact turn their back on their followers
	if(istype(H.patron, /datum/patron/inhumen))
		return TRUE
	// Ones rejecting the pantheon arent protected by it
	if(HAS_TRAIT(H, TRAIT_HERESIARCH))
		return TRUE
	// Patron doesnt protect the excomunicated
	if(H.real_name in GLOB.excommunicated_players)
		return TRUE
	if(H.real_name in GLOB.apostasy_players)
		return TRUE

	to_chat(src, span_warning("This one is protected by the Ten. Ascendants arent willing to bother getting the curse past them.")) // Reminder that cannonicly ascendants are stronger, so not going to bother is the reson, not cant
	return FALSE

/mob/living/carbon/human/proc/evil_churchecancurse_selection(mob/living/carbon/human/H)
	
	// Ascendants may in fact turn their back on their followers
	if(istype(H.patron, /datum/patron/inhumen))
		return TRUE
	// Ones rejecting the pantheon arent protected by it
	if(HAS_TRAIT(H, TRAIT_HERESIARCH))
		return TRUE
	// Patron doesnt protect the excomunicated
	if(H.real_name in GLOB.excommunicated_players)
		return TRUE
	if(H.real_name in GLOB.apostasy_players)
		return TRUE

	return FALSE

/mob/living/carbon/human/proc/evil_churchpriestcurse(mob/living/carbon/human/H in GLOB.player_list)
	set name = "Ascendants Curse"
	set category = "Antipope"

	
	var/list/posible_targets = list()
	for(var/mob/living/carbon/human/P in GLOB.player_list)
		if(evil_churchecancurse_selection(P))
			posible_targets["[P.real_name] ([P.advjob])"] = P

	posible_targets_names = assoc_list_strip_value(posible_targets)

	var/target_pick = input("Who shall receive a curse?", "Select Target") as null|anything in posible_targets_names

	if (!target_pick)
		return

	if (istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("I can't do this here! They'll know!"))
		return FALSE

	if(!src.key)
		return

	target_pick = posible_targets[target_pick]

	var/list/curse_choices = list(
		"Curse of Zizo" = /datum/curse/zizo,
		"Curse of Baotha" = /datum/curse/baotha,
		"Curse of Graggar" = /datum/curse/graggar,
		"Curse of Matthios" = /datum/curse/matthios,
	)

	var/curse_pick = input("Choose a curse to apply or lift.", "Select Curse") as null|anything in curse_choices
	if (!curse_pick)
		return

	var/curse_type = curse_choices[curse_pick]

	if (H == target_pick)
		var/datum/curse/temp = new curse_type()

		if (H.is_cursed(temp))
			H.remove_curse(temp)
			priority_announce("Heresiath has lifted [curse_pick] from [H.real_name]! They are free from ascendants grasps!", title = "PITY", sound = 'sound/misc/bell.ogg')
			message_admins("ASCEDANT CURSE: [real_name] ([ckey]) has removed [curse_pick] from [H.real_name]) ") //[ADMIN_LOOKUPFLW(user)] Maybe add this here if desirable but dunno.
			log_game("ASCEDANT CURSE: [real_name] ([ckey]) has removed [curse_pick] from [H.real_name])")
		else
			if (length(H.curses) >= 1)
				to_chat(src, span_syndradio("[H.real_name] is already afflicted by another curse."))
				message_admins("ASCEDANT CURSE: [real_name] ([ckey]) has attempted to strike [H.real_name] ([H.ckey] with [curse_pick])")
				log_game("ASCEDANT CURSE: [real_name] ([ckey]) has attempted to strike [H.real_name] ([H.ckey] with [curse_pick])")
				return

			if (!COOLDOWN_FINISHED(src, priest_curse))
				to_chat(src, span_warning("You must wait before invoking a curse again."))
				return

			//Check if we can curse this person.
			if(!evil_churchecancurse(H))
				return

			COOLDOWN_START(src, priest_curse, EVIL_PRIEST_CURSE_COOLDOWN)
			H.add_curse(curse_type)

			priority_announce("Heresiath has stricken [H.real_name] with [curse_pick]! FEAR!", title = "ASCEDANT IRE", sound = 'sound/misc/excomm.ogg')
			message_admins("ASCEDANT CURSE: [real_name] ([ckey]) has stricken [H.real_name] ([H.ckey] with [curse_pick])")
			log_game("ASCEDANT CURSE: [real_name] ([ckey]) has stricken [H.real_name] ([H.ckey] with [curse_pick])")

		return
