
GLOBAL_LIST_INIT(character_flaws, list(
	"Illiterate"=/datum/charflaw/illiterate,
	"Light Sensitivity"=/datum/charflaw/light_sensitive,
	"Alcoholic"=/datum/charflaw/addiction/alcoholic,
	"Annoying Face"=/datum/charflaw/annoying_face,
	"Asundered Mind (+1 TRI)"=/datum/charflaw/mind_broken,
	"Averse"=/datum/charflaw/averse,
	"Bad Sight (+1 TRI)"=/datum/charflaw/badsight,
	"Blindness (+1 TRI)"=/datum/charflaw/noeyeall,
	"Caffiend"=/datum/charflaw/addiction/caffiend,
	"Clamorous"=/datum/charflaw/addiction/clamorous,
	"Clingy"=/datum/charflaw/clingy,
	"Colorblind (+1 TRI)"=/datum/charflaw/colorblind,
	"Critical Weakness (+1 TRI)"=/datum/charflaw/critweakness,
	"Cyclops (L) (+1 TRI)"=/datum/charflaw/noeyel,
	"Cyclops (R) (+1 TRI)"=/datum/charflaw/noeyer,
	"Devout Follower"=/datum/charflaw/addiction/godfearing,
	"Finicky"=/datum/charflaw/finicky,
	"Greedy"=/datum/charflaw/greedy,
	"Hunted (+1 TRI)"=/datum/charflaw/hunted,
	"Indebted"=/datum/charflaw/indebted,
	"Isolationist"=/datum/charflaw/isolationist,
	"Junkie"=/datum/charflaw/addiction/junkie,
	"Marked by Baotha" =/datum/charflaw/marked_by_baotha,
	"Leper (+1 TRI)"=/datum/charflaw/leprosy,
	"Lumbering Giant (-1 TRI)"=/datum/charflaw/lumbering_giant,
	"Masochist"=/datum/charflaw/addiction/masochist,
	"Missing Nose"=/datum/charflaw/missing_nose,
	"Mute (+1 TRI)"=/datum/charflaw/mute,
	"Narcoleptic (+1 TRI)"=/datum/charflaw/narcoleptic,
	"No Flaw (-3 TRI)"=/datum/charflaw/noflaw,
	"Nude Sleeper"=/datum/charflaw/nude_sleeper,
	"Nudist"=/datum/charflaw/nudist,
	"Nymphomaniac"=/datum/charflaw/addiction/lovefiend,
	"Pacifism"=/datum/charflaw/pacifism,
	"Paranoid"=/datum/charflaw/addiction/paranoid,
	"Random or No Flaw"=/datum/charflaw/randflaw,
	"Sadist"=/datum/charflaw/addiction/sadist,
	"Scarred"=/datum/charflaw/scarred,
	"Silver Weakness"=/datum/charflaw/silverweakness,
	"Sleepless (+1 TRI)"=/datum/charflaw/sleepless,
	"Smoker"=/datum/charflaw/addiction/smoker,
	"Ugly"=/datum/charflaw/ugly,
	"Unintelligible (+1 TRI)"=/datum/charflaw/unintelligible,
	"Unsettling Beauty"=/datum/charflaw/unsettling_beauty,
	"Wood Arm (L) (+1 TRI)"=/datum/charflaw/limbloss/arm_l,
	"Wood Arm (R) (+1 TRI)"=/datum/charflaw/limbloss/arm_r,
	"Hemophage (+1 TRI)"=/datum/charflaw/hemophage,
	"Chronic Migraines (+1 TRI)"=/datum/charflaw/chronic_migraine,
	"Weak Heart (+1 TRI)"=/datum/charflaw/weak_heart,
	"Tremors (+2 TRI)"=/datum/charflaw/tremors,
	"Nightmares (+1 TRI)"=/datum/charflaw/nightmares,
	"Chronic Arthritis (+2 TRI)"=/datum/charflaw/chronic_arthritis,
	"Chronic Back Pain (+2 TRI)"=/datum/charflaw/chronic_back_pain,
	"Old War Wound (+1 TRI)"=/datum/charflaw/old_war_wound,
	"Hard of Hearing (+2 TRI)"=/datum/charflaw/hard_of_hearing,
	"Big Ears"=/datum/charflaw/big_ears,
	"Disgraced Noble"=/datum/charflaw/disgraced_noble,
	"Spurned (+2 TRI)"=/datum/charflaw/spurned,
	"Thrillseeker"=/datum/charflaw/addiction/thrillseeker,
	"Carnivore"=/datum/charflaw/carnivore,
	"Herbivore"=/datum/charflaw/herbivore,
	"Lithovore"=/datum/charflaw/lithovore,
	"Voyeur"=/datum/charflaw/addiction/voyeur,
	))

GLOBAL_LIST_INIT(averse_factions, list(
	"Noblemen" = NOBLEMEN,
	"Garrison" = GARRISON,
	"Churchmen" = CHURCHMEN,
	"Courtiers" = COURTIERS,
	"Yeomen" = YEOMEN,
	"Peasants" = PEASANTS,
	"Wanderers" = WANDERERS,
	"Inquisition" = INQUISITION,
	"Guildsmen" = GUILDSMEN,
	))

/datum/charflaw
	var/name
	var/desc
	var/ephemeral = FALSE // This flaw is currently disabled and will not process
	var/needs_life_tick = FALSE // Set to TRUE if this flaw needs to be processed every life tick (performance optimization)

/datum/charflaw/proc/on_mob_creation(mob/user)
	return

/datum/charflaw/proc/apply_post_equipment(mob/user)
	return

/datum/charflaw/proc/flaw_on_life(mob/user)
	return

// Called when a vice is removed from a character to clean up persistent effects
/datum/charflaw/proc/on_removal(mob/user)
	return

/mob/proc/has_flaw(flaw)
	return

/mob/living/carbon/human/has_flaw(flaw)
	if(!flaw)
		return
	// Check new multiple vices system
	if(length(vices))
		for(var/datum/charflaw/vice in vices)
			if(istype(vice, flaw))
				return TRUE
	// Legacy single vice check
	if(istype(charflaw, flaw))
		return TRUE
	return FALSE

/mob/proc/get_flaw(flaw_type)
	return

/mob/living/carbon/human/get_flaw(flaw_type)
	if(!flaw_type)
		return
	// Check new multiple vices system
	if(length(vices))
		for(var/datum/charflaw/vice in vices)
			if(istype(vice, flaw_type))
				return vice
	// Legacy single vice check
	if(istype(charflaw, flaw_type))
		return charflaw
	return

/datum/charflaw/randflaw
	name = "Random or None"
	desc = "A 50% chance to be given a random flaw, or a 50% chance to have NO flaw."

/datum/charflaw/randflaw/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	if(prob(50))
		var/flawz = GLOB.character_flaws.Copy()
		var/charflaw = pick_n_take(flawz)
		charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/noflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/noflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		H.charflaw = new charflaw()
		H.charflaw.on_mob_creation(H)
	else
		H.charflaw = new /datum/charflaw/eznoflaw()
		H.charflaw.on_mob_creation(H)


/datum/charflaw/eznoflaw
	name = "No Flaw"
	desc = "I'm a normal person, how rare!"

/datum/charflaw/noflaw
	name = "No Flaw (-3 TRI)"
	desc = "I'm a normal person, how rare! (Consumes 3 triumphs or gives a random flaw.)"

/datum/charflaw/noflaw/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	if(H.get_triumphs() < 3)
		var/flawz = GLOB.character_flaws.Copy()
		var/charflaw = pick_n_take(flawz)
		charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/randflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/randflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		H.charflaw = new charflaw()
		H.charflaw.on_mob_creation(H)
	else
		H.adjust_triumphs(-3)

/datum/charflaw/badsight
	name = "Bad Eyesight"
	desc = "I need spectacles to see normally. Without them, my vision is blurred and I suffer reduced perception (-20 PER) and speed (-5 SPD). Years of reading have improved my literacy (+1 Reading skill, +1 TRI)."
	needs_life_tick = TRUE

/datum/charflaw/badsight/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.wear_mask)
		if(isclothing(H.wear_mask))
			if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/spectacles))
				var/obj/item/I = H.wear_mask
				if(!I.obj_broken)
					return
	H.blur_eyes(2)
	H.apply_status_effect(/datum/status_effect/debuff/badvision)

/datum/status_effect/debuff/badvision
	id = "badvision"
	alert_type = null
	effectedstats = list(STATKEY_PER = -20, STATKEY_SPD = -5)
	duration = 10 SECONDS

/datum/charflaw/badsight/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/spectacles(H), SLOT_WEAR_MASK)
	else
		new /obj/item/clothing/mask/rogue/spectacles(get_turf(H))

	// we don't seem to have a mind when on_mob_creation fires, so set up a timer to check when we probably will
	addtimer(CALLBACK(src, PROC_REF(apply_reading_skill), H), 5 SECONDS)

/datum/charflaw/badsight/proc/apply_reading_skill(mob/living/carbon/human/H)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_triumphs(1)

/datum/charflaw/averse
	name = "Averse"
	desc = "I loathe a particular group. Being around 2 or more of them causes me stress."
	needs_life_tick = TRUE
	var/check_interval = 15 SECONDS
	var/last_check = 0

/datum/charflaw/averse/flaw_on_life(mob/living/carbon/human/user)
	if(world.time < last_check + check_interval)
		return
	if(!user || !ishuman(user))
		return
	last_check = world.time

	var/datum/preferences/prefs = user?.client?.prefs
	if(!prefs?.averse_chosen_faction)
		return

	var/loathed_flag = prefs.averse_chosen_faction
	var/list/loathed_nearby = list()

	for(var/mob/living/carbon/human/H in get_hearers_in_LOS(7, user))
		if(H == user || H.stat == DEAD)
			continue
		if(!H.mind?.assigned_role)
			continue
		var/datum/job/job = SSjob.GetJob(H.mind.assigned_role)
		if(job && (job.department_flag & loathed_flag))
			loathed_nearby += H

	if(length(loathed_nearby) >= 2)
		user.add_stress(/datum/stressevent/averse)

/datum/charflaw/indebted
	name = "Indebted"
	desc = "I owe a debt to the realm. Every 30 minutes, 30 mammons plus 20% of my current wealth is deducted. If I can't pay, a bounty is placed on my head."
	needs_life_tick = TRUE
	var/debt_interval = 30 MINUTES
	var/minimum_debt = 30
	var/relative_debt = 0.2
	var/next_debt_time = 0

/datum/charflaw/indebted/flaw_on_life(mob/living/carbon/human/user)
	if(!user?.ckey || !SStreasury)
		return
	if(world.time < next_debt_time)
		return

	next_debt_time = world.time + debt_interval
	
	var/datum/bank_account/account = SStreasury.bank_accounts[user.ckey]
	if(!account)
		return

	var/total_debt = minimum_debt + round(account.account_balance * relative_debt)
	
	if(account.adjust_money(-total_debt, "Debt Collection"))
		to_chat(user, span_warning("A debt of [total_debt] mammons has been collected from my account."))
		user.add_stress(/datum/stressevent/debt)
	else
		to_chat(user, span_boldwarning("I failed to pay my debt of [total_debt] mammons! A bounty has been placed on my head!"))
		// Add bounty using the global proc
		var/race = user.dna.species
		var/gender = user.gender
		var/list/d_list = user.get_mob_descriptors()
		var/descriptor_height = build_coalesce_description_nofluff(d_list, user, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
		var/descriptor_body = build_coalesce_description_nofluff(d_list, user, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
		var/descriptor_voice = build_coalesce_description_nofluff(d_list, user, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
		add_bounty(user.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, total_debt, FALSE, "Failure to pay debts", "The Treasury of Rotwood")
		user.add_stress(/datum/stressevent/debt)

/datum/charflaw/isolationist
	name = "Isolationist"
	desc = "I get stressed when more than 3 people are near me. I prefer solitude and small groups."
	needs_life_tick = TRUE
	var/last_check = 0

/datum/charflaw/isolationist/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == user)
			continue
		if(L.stat)
			continue
		if(L.dna.species)
			cnt++
		if(cnt > 3)
			break
	var/mob/living/carbon/P = user
	if(cnt > 3)
		P.add_stress(/datum/stressevent/crowd)

/datum/charflaw/clingy
	name = "Clingy"
	desc = "I get stressed when I'm alone or only near 1 other person. I need to be around people to feel comfortable."
	needs_life_tick = TRUE
	var/last_check = 0

/datum/charflaw/clingy/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == user)
			continue
		if(L.stat)
			continue
		if(L.dna.species)
			cnt++
		if(cnt > 1)
			break
	var/mob/living/carbon/P = user
	if(cnt < 1)
		P.add_stress(/datum/stressevent/nopeople)

/datum/charflaw/finicky
	name = "Finicky"
	desc = "I don't like crowds. I don't like being alone, neither. There's a middle, isn't there?"
	needs_life_tick = TRUE
	var/interval = 1 MINUTES
	var/is_active = FALSE
	var/next_check = 0

/datum/charflaw/finicky/flaw_on_life(mob/user)
	. = ..()
	if(!user)
		return
	if(is_active)
		if(world.time > next_check)
			next_check = world.time + interval
			var/cnt = 0
			for(var/mob/living/carbon/human/L in get_hearers_in_view(6, user, RECURSIVE_CONTENTS_CLIENT_MOBS))
				if(L == user)
					continue
				if(L.stat)
					continue
				if(L.dna.species)
					cnt++
				if(cnt > 3)
					break
			var/mob/living/carbon/P = user
			if(cnt > 3)
				P.add_stress(/datum/stressevent/crowd)
			if(cnt == 0)
				P.add_stress(/datum/stressevent/nocrowd)

/datum/charflaw/finicky/apply_post_equipment(mob/user)
	if(user.mind)
		is_active = TRUE

/datum/charflaw/noeyer
	name = "Cyclops (R)"
	desc = "I lost my right eye long ago. My field of vision is significantly reduced on the right side. I start with an eyepatch. +1 TRI"

/datum/charflaw/noeyer/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch(H), SLOT_WEAR_MASK)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/right/permanent)
	H.update_fov_angles()
	H.adjust_triumphs(1)

/datum/charflaw/noeyel
	name = "Cyclops (L)"
	desc = "I lost my left eye long ago. My field of vision is significantly reduced on the left side. I start with an eyepatch. +1 TRI"

/datum/charflaw/noeyel/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch/left(H), SLOT_WEAR_MASK)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/left/permanent)
	H.update_fov_angles()
	H.adjust_triumphs(1)

/datum/charflaw/noeyeall
	name = "Blindness"
	desc = "I lost both of my eyes long ago. My other senses have sharpened, allowing me to perceive nearby shapes and movement."

/datum/charflaw/noeyeall/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/blindfold(H), SLOT_WEAR_MASK)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/left/permanent)
	head?.add_wound(/datum/wound/facial/eyes/right/permanent)
	ADD_TRAIT(H, TRAIT_BLIND_VICE, TRAIT_GENERIC)
	H.update_fov_angles()
	H.adjust_triumphs(1)

/datum/charflaw/colorblind
	name = "Colorblind"
	desc = "I see the world in grayscale. I cannot perceive colors at all. Incompatible with Night-eyed virtue. +1 TRI"

/datum/charflaw/colorblind/on_mob_creation(mob/user)
	..()
	user.add_client_colour(/datum/client_colour/monochrome)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/hunted
	name = "Hunted"
	desc = "Something in my past has made me a target. I'm always looking over my shoulder. Being alone or in darkness causes stress. Someone will hunt me down eventually, and I need to be prepared for that inevitability. +1 TRI"
	needs_life_tick = TRUE
	var/logged = FALSE
	var/last_paranoia_check = 0

/datum/charflaw/hunted/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)
		last_paranoia_check = world.time

/datum/charflaw/hunted/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	
	if(logged == FALSE)
		if(H.name) // If you don't check this, the log entry wont have a name as flaw_on_life is checked at least once before the name is set.
			log_hunted("[H.ckey] playing as [H.name] had the hunted flaw by vice.")
			logged = TRUE
	
	if(H.stat != CONSCIOUS)
		return
	
	// Check every 10 seconds
	if(world.time < last_paranoia_check + 10 SECONDS)
		return
	last_paranoia_check = world.time
	
	// Check if in darkness
	var/in_darkness = FALSE
	if(H.loc && H.loc.luminosity <= 2)
		in_darkness = TRUE
	
	// Check if alone (no conscious mobs nearby)
	var/is_alone = TRUE
	for(var/mob/living/L in oview(5, H))
		if(L.stat == CONSCIOUS)
			is_alone = FALSE
			break
	
	// Add stress if in danger conditions
	if(in_darkness || is_alone)
		H.add_stress(/datum/stressevent/vice/hunted)
		if(prob(10))
			var/list/paranoid_messages = list(
				"Did someone just move in the shadows?",
				"I swear I heard footsteps...",
				"They're out there, watching me...",
				"I need to stay alert...",
				"Every shadow could be them..."
			)
			to_chat(H, span_warning(pick(paranoid_messages)))
	else
		H.remove_stress(/datum/stressevent/vice/hunted)

/datum/charflaw/ugly
	name = "Ugly"
	desc = "My face is ugly, making me unseemly to others. Social interactions suffer. Incompatible with Socialite (Beautiful) virtue."

/datum/charflaw/ugly/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_UNSEEMLY, TRAIT_GENERIC)

/datum/charflaw/ugly/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_UNSEEMLY, TRAIT_GENERIC)

/datum/charflaw/nudist
	name = "Nudist"
	desc = "I refuse to wear clothes. I'm compelled to remain unclothed and will automatically remove clothing. Others can dress me, but I'll try to remove it and suffer stress while clothed. I can tolerate certain accessories."
	needs_life_tick = TRUE
	var/next_removal_attempt = 0

/datum/charflaw/nudist/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_NUDIST, TRAIT_GENERIC)
		next_removal_attempt = world.time + rand(30 SECONDS, 60 SECONDS)

/datum/charflaw/nudist/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	
	if(H.stat != CONSCIOUS)
		return
	
	// Check if wearing restricted clothing (ignore nudist-approved items)
	var/is_clothed = FALSE
	if(H.wear_armor && (!istype(H.wear_armor, /obj/item/clothing) || !H.wear_armor.nudist_approved))
		is_clothed = TRUE
	if(H.wear_shirt && (!istype(H.wear_shirt, /obj/item/clothing) || !H.wear_shirt.nudist_approved))
		is_clothed = TRUE
	if(H.wear_pants && (!istype(H.wear_pants, /obj/item/clothing) || !H.wear_pants.nudist_approved))
		is_clothed = TRUE
	
	if(is_clothed)
		H.add_stress(/datum/stressevent/vice/nudist_clothed)
	else
		H.remove_stress(/datum/stressevent/vice/nudist_clothed)
	
	// Try to remove clothing periodically
	if(is_clothed && world.time >= next_removal_attempt)
		// Remove armor first, then shirt, then pants (skip nudist-approved items)
		var/obj/item/removed = null
		if(H.wear_armor)
			if(!istype(H.wear_armor, /obj/item/clothing) || !H.wear_armor.nudist_approved)
				removed = H.wear_armor
				if(H.dropItemToGround(removed))
					to_chat(H, span_warning("I can't stand wearing [removed]! I need to be free!"))
		else if(H.wear_shirt)
			if(!istype(H.wear_shirt, /obj/item/clothing) || !H.wear_shirt.nudist_approved)
				removed = H.wear_shirt
				if(H.dropItemToGround(removed))
					to_chat(H, span_warning("This [removed] is suffocating me! Off it goes!"))
		else if(H.wear_pants)
			if(!istype(H.wear_pants, /obj/item/clothing) || !H.wear_pants.nudist_approved)
				removed = H.wear_pants
				if(H.dropItemToGround(removed))
					to_chat(H, span_warning("These [removed] are unbearable! Freedom!"))
		
		if(removed)
			H.visible_message(span_notice("[H] frantically removes [removed]."))
		
		next_removal_attempt = world.time + rand(30 SECONDS, 60 SECONDS)

/datum/charflaw/nudist/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_NUDIST, TRAIT_GENERIC)
		H.remove_stress(/datum/stressevent/vice/nudist_clothed)

/datum/charflaw/inhumen_anatomy
	name = "Inhumen Anatomy"
	desc = "My anatomy is non-human, preventing me from wearing any hats or shoes. These items simply don't fit my body."

/datum/charflaw/inhumen_anatomy/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_INHUMEN_ANATOMY, TRAIT_GENERIC)

/datum/charflaw/inhumen_anatomy/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_INHUMEN_ANATOMY, TRAIT_GENERIC)

/datum/charflaw/missing_nose
	name = "Missing Nose"
	desc = "I have no nose, making breathing difficult. My stamina regeneration is halved."

/datum/charflaw/missing_nose/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_MISSING_NOSE, TRAIT_GENERIC)

/datum/charflaw/missing_nose/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_MISSING_NOSE, TRAIT_GENERIC)

/datum/charflaw/disfigured
	name = "Disfigured"
	desc = "My face has been permanently altered beyond recognition. No one can identify me by my face - I am completely unrecognizable."

/datum/charflaw/disfigured/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_DISFIGURED, TRAIT_GENERIC)

/datum/charflaw/disfigured/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_DISFIGURED, TRAIT_GENERIC)

/datum/charflaw/pacifism
	name = "Pacifism"
	desc = "I cannot harm any living being. I am physically unable to attack or hurt others."

/datum/charflaw/pacifism/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_PACIFISM, TRAIT_GENERIC)

/datum/charflaw/pacifism/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_PACIFISM, TRAIT_GENERIC)

/datum/charflaw/annoying_face
	name = "Annoying Face"
	desc = "I have an odd voice and appearance. My text appears in Comic Sans font."

/datum/charflaw/annoying_face/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_COMICSANS, TRAIT_GENERIC)

/datum/charflaw/annoying_face/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_COMICSANS, TRAIT_GENERIC)

/datum/charflaw/eerie_beauty
	name = "Eerie Beauty"
	desc = "My appearance is hauntingly beautiful in an unsettling way. My beauty makes others deeply uncomfortable. Incompatible with Socialite virtue."

/datum/charflaw/eerie_beauty/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_BEAUTIFUL_UNCANNY, TRAIT_GENERIC)

/datum/charflaw/eerie_beauty/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_BEAUTIFUL_UNCANNY, TRAIT_GENERIC)

/datum/charflaw/nude_sleeper
	name = "Nude Sleeper"
	desc = "I can only fall asleep if I'm completely nude and in a bed. I cannot sleep while wearing equipment. (Unremovable clothing and certain accessories are allowed.)"

/datum/charflaw/nude_sleeper/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_NUDE_SLEEPER, TRAIT_GENERIC)

/datum/charflaw/nude_sleeper/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_NUDE_SLEEPER, TRAIT_GENERIC)

/datum/charflaw/unsettling_beauty
	name = "Unsettling Beauty"
	desc = "My appearance is profoundly wrong and disturbing to others. Something about my features is deeply unsettling. Incompatible with Socialite virtue."

/datum/charflaw/unsettling_beauty/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_UNSETTLING_BEAUTY, TRAIT_GENERIC)

/datum/charflaw/unsettling_beauty/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_UNSETTLING_BEAUTY, TRAIT_GENERIC)

/datum/charflaw/scarred
	name = "Scarred"
	desc = "My face bears terrible scars that obscure my identity, making me harder to recognize (but not impossible like Disfigured)."

/datum/charflaw/scarred/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_SCARRED, TRAIT_GENERIC)

/datum/charflaw/scarred/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_SCARRED, TRAIT_GENERIC)

/datum/charflaw/unintelligible
	name = "Unintelligible"
	desc = "I cannot speak the common tongue. I lose knowledge of the Common language and lose all Reading skill. +1 TRI"

/datum/charflaw/unintelligible/on_mob_creation(mob/user)
	var/mob/living/carbon/human/recipient = user
	addtimer(CALLBACK(src, .proc/unintelligible_apply, recipient), 5 SECONDS)

/datum/charflaw/unintelligible/proc/unintelligible_apply(mob/living/carbon/human/user)
	if(user.advsetup)
		addtimer(CALLBACK(src, .proc/unintelligible_apply, user), 5 SECONDS)
		return
	user.remove_language(/datum/language/common)
	user.adjust_skillrank(/datum/skill/misc/reading, -6, TRUE)
	user.adjust_triumphs(1)

/datum/charflaw/greedy
	name = "Greedy"
	desc = "I need to maintain a certain amount of mammons on my person. The requirement increases over time (capped at 250 mammons). Without enough coins, I suffer stress and withdrawal (reduced stats). I can see item prices."
	var/last_checked_mammons = 0
	var/required_mammons = 0
	var/next_mammon_increase = 0
	var/last_passed_check = 0
	var/first_tick = FALSE
	var/extra_increment_value = 0

/datum/charflaw/greedy/on_mob_creation(mob/user)
	next_mammon_increase = world.time + rand(15 MINUTES, 25 MINUTES)
	last_passed_check = world.time
	ADD_TRAIT(user, TRAIT_SEEPRICES_SHITTY, "[type]")

/datum/charflaw/greedy/flaw_on_life(mob/user)
	if(!first_tick)
		determine_starting_mammons(user)
		first_tick = TRUE
		return
	if(world.time >= next_mammon_increase)
		mammon_increase(user)
	mammon_check(user)

/datum/charflaw/greedy/proc/determine_starting_mammons(mob/living/carbon/human/user)
	var/starting_mammons = get_mammons_in_atom(user)
	required_mammons = round(starting_mammons * 0.7)
	extra_increment_value = round(starting_mammons * 0.15)

/datum/charflaw/greedy/proc/mammon_increase(mob/living/carbon/human/user)
	if(last_passed_check + (50 MINUTES) < world.time) //If we spend a REALLY long time without being able to satisfy, then pity downgrade
		required_mammons -= rand(10, 20)
		to_chat(user, span_blue("Maybe a little less mammons is enough..."))
	else
		required_mammons += rand(25, 35) + extra_increment_value
	required_mammons = min(required_mammons, 250) //Cap at 250 coins maximum
	next_mammon_increase = world.time + rand(35 MINUTES, 40 MINUTES)
	var/current_mammons = get_mammons_in_atom(user)
	if(current_mammons >= required_mammons)
		to_chat(user, span_blue("I'm quite happy with the amount of mammons I have..."))
	else
		to_chat(user, span_boldwarning("I need more mammons, what I have is not enough..."))

	last_checked_mammons = current_mammons

/datum/charflaw/greedy/proc/mammon_check(mob/living/carbon/human/user)
	var/new_mammon_amount = get_mammons_in_atom(user)
	var/ascending = (new_mammon_amount > last_checked_mammons)

	var/do_update_msg = TRUE
	if(new_mammon_amount >= required_mammons)
		// Feel better
		if(user.has_stress_event(/datum/stressevent/vice/greedy))
			to_chat(user, span_blue("[new_mammon_amount] mammons... That's more like it.."))
		user.remove_stress(/datum/stressevent/vice/greedy)
		user.remove_status_effect(/datum/status_effect/debuff/addiction)
		last_passed_check = world.time
		do_update_msg = FALSE
	else
		// Feel bad
		user.add_stress(/datum/stressevent/vice/greedy)
		user.apply_status_effect(/datum/status_effect/debuff/addiction)

	if(new_mammon_amount == last_checked_mammons)
		do_update_msg = FALSE

	if(do_update_msg)
		if(ascending)
			to_chat(user, span_warning("Only [new_mammon_amount] mammons.. I need more..."))
		else
			to_chat(user, span_boldwarning("No! My precious mammons..."))

	last_checked_mammons = new_mammon_amount

/datum/charflaw/narcoleptic
	name = "Narcoleptic"
	desc = "I randomly fall asleep during the day (every 7-15 minutes when conscious). Sleep lasts 30-50 seconds. Pain, stimulants (coffee, tea) and drugs prevent episodes. I can fall asleep faster when intentionally resting. +1 TRI"
	needs_life_tick = TRUE
	var/last_unconsciousness = 0
	var/next_sleep = 0
	var/concious_timer = (10 MINUTES)
	var/do_sleep = FALSE
	var/pain_pity_charges = 3
	var/drugged_up = FALSE

/datum/charflaw/narcoleptic/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_FASTSLEEP, "[type]")
	reset_timer()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/narcoleptic/proc/reset_timer()
	do_sleep = FALSE
	last_unconsciousness = world.time
	concious_timer = rand(7 MINUTES, 15 MINUTES)
	pain_pity_charges = rand(2,4)

/datum/charflaw/narcoleptic/flaw_on_life(mob/living/carbon/human/user)
	if(user.stat != CONSCIOUS)
		reset_timer()
		return
	if(do_sleep)
		if(next_sleep <= world.time)
			var/pain = user.get_complex_pain()
			// Check if user is on stimulants or drugs that prevent sleep
			var/on_stimulants = FALSE
			if(user.has_status_effect(/datum/status_effect/buff/vigorized))
				on_stimulants = TRUE
			else if(user.has_status_effect(/datum/status_effect/buff/weed))
				on_stimulants = TRUE
			else if(user.has_status_effect(/datum/status_effect/buff/ozium))
				on_stimulants = TRUE
			else if(user.has_status_effect(/datum/status_effect/buff/moondust))
				on_stimulants = TRUE
			else if(user.has_status_effect(/datum/status_effect/buff/moondust_purest))
				on_stimulants = TRUE
			
			if(on_stimulants)
				concious_timer = rand(4 MINUTES, 6 MINUTES)
				to_chat(user, span_info("The stimulants keep me alert..."))
				do_sleep = FALSE
				last_unconsciousness = world.time
			else if(pain >= 40 && pain_pity_charges > 0)
				pain_pity_charges--
				concious_timer = rand(1 MINUTES, 2 MINUTES)
				to_chat(user, span_warning("The pain keeps me awake..."))
				do_sleep = FALSE
				last_unconsciousness = world.time
			else
				if(prob(40) || drugged_up)
					drugged_up = FALSE
					concious_timer = rand(4 MINUTES, 6 MINUTES)
					to_chat(user, span_info("The feeling has passed."))
				else
					concious_timer = rand(7 MINUTES, 15 MINUTES)
					to_chat(user, span_boldwarning("I can't keep my eyes open any longer..."))
					user.Sleeping(rand(30 SECONDS, 50 SECONDS))
					user.visible_message(span_warning("[user] suddenly collapses!"))
				do_sleep = FALSE
				last_unconsciousness = world.time
	else
		// Been conscious for ~10 minutes (whatever is the conscious timer)
		if(last_unconsciousness + concious_timer < world.time)
			drugged_up = FALSE
			to_chat(user, span_blue("I'm getting drowsy..."))
			user.emote("yawn", forced = TRUE)
			next_sleep = world.time + rand(7 SECONDS, 11 SECONDS)
			do_sleep = TRUE

/proc/narcolepsy_drug_up(mob/living/living)
	var/datum/charflaw/narcoleptic/narco = living.get_flaw(/datum/charflaw/narcoleptic)
	if(!narco)
		return
	narco.drugged_up = TRUE

/proc/get_mammons_in_atom(atom/movable/movable)
	var/static/list/coins_types = typecacheof(/obj/item/roguecoin)
	var/mammons = 0
	if(coins_types[movable.type])
		var/obj/item/roguecoin/coin = movable
		mammons += coin.quantity * coin.sellprice
	for(var/atom/movable/content in movable.contents)
		mammons += get_mammons_in_atom(content)
	return mammons

/datum/charflaw/sleepless
	name = "Insomnia"
	desc = "I cannot sleep. Ever. I am permanently unable to rest or sleep. +1 TRI"

/datum/charflaw/sleepless/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_NOSLEEP, TRAIT_GENERIC)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/mute
	name = "Mute"
	desc = "I cannot speak at all. I am permanently mute and cannot vocalize. +1 TRI"

/datum/charflaw/mute/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_PERMAMUTE, TRAIT_GENERIC)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/critweakness
	name = "Critical Weakness"
	desc = "Critical hits against me are vastly more lethal. A single crit can easily kill me. +1 TRI"

/datum/charflaw/critweakness/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/silverweakness
	name = "Silver Weakness"
	desc = "Silver weapons deal triple damage to me. Silver burns and wounds me far more severely than normal."

/datum/charflaw/silverweakness/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

/datum/charflaw/leprosy
	name = "Leper (+1 TRI)"
	desc = "I am afflicted with leprosy. All my stats are reduced by 1 (STR, INT, PER, CON, WIL, SPD, LCK). My appearance disturbs others. +1 TRI"

/datum/charflaw/leprosy/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	to_chat(user, "I am afflicted. I am outcast and weak. I am a pox on this world.")
	ADD_TRAIT(user, TRAIT_LEPROSY, TRAIT_GENERIC)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, -1)
	H.change_stat(STATKEY_PER, -1)
	H.change_stat(STATKEY_CON, -1)
	H.change_stat(STATKEY_WIL, -1)
	H.change_stat(STATKEY_SPD, -1)
	H.change_stat(STATKEY_LCK, -1)
	H.adjust_triumphs(1)

/datum/charflaw/mind_broken
	name = "Asundered Mind (+1 TRI)"
	desc = "My mind is shattered. I suffer permanent, infinite hallucinations and psychosis. Reality is a twisted nightmare. +1 TRI"

/datum/charflaw/mind_broken/apply_post_equipment(mob/living/carbon/human/insane_fool)
	insane_fool.hallucination = INFINITY
	ADD_TRAIT(insane_fool, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
	insane_fool.adjust_triumphs(1)

/datum/charflaw/marked_by_baotha
	name = "Marked by Baotha"
	desc = "I bear Baotha's mark on my groin, granting fertility regardless of normal limitations. The mark causes random surges of arousal and involuntary bodily reactions (shiver/twitch/groan) every few minutes. The mark is visible on my body."
	needs_life_tick = TRUE
	var/next_arousal_surge = 0
	var/next_emote = 0

/datum/charflaw/marked_by_baotha/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	
	var/mob/living/carbon/human/H = user
	
	ADD_TRAIT(H, TRAIT_BAOTHA_FERTILITY_BOON, TRAIT_GENERIC)
	
	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	if(vagina && !vagina.fertility)
		vagina.fertility = TRUE
	
	// Initialize timers with random delays
	next_arousal_surge = world.time + rand(3 MINUTES, 8 MINUTES)
	next_emote = world.time + rand(1 MINUTES, 3 MINUTES)

/datum/charflaw/marked_by_baotha/apply_post_equipment(mob/user)
	if(!ishuman(user))
		return
	
	var/mob/living/carbon/human/H = user
	
	// Get mark color from preferences, default to purple
	var/mark_color = "#b967ff" // Default purple
	if(H.client?.prefs?.baotha_mark_color)
		mark_color = "#[H.client.prefs.baotha_mark_color]"
	
	// Create and store the marking overlay
	// Use BODY_MARKINGS_LAYER (44) to render above bodyparts, below clothing  
	H.baotha_mark_overlay = mutable_appearance('icons/roguetown/misc/baotha_marking.dmi', "marking_[H.gender == "male" ? "m" : "f"]", -BODY_MARKINGS_LAYER)
	H.baotha_mark_overlay.color = mark_color
	
	// Trigger body update to apply it
	H.update_body()

/datum/charflaw/marked_by_baotha/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	
	var/mob/living/carbon/human/H = user
	
	// Skip if dead, unconscious, or certain antagonist types
	if(H.stat != CONSCIOUS)
		return
	if(H.mind?.antag_datums)
		for(var/datum/antagonist/D in H.mind.antag_datums)
			if(istype(D, /datum/antagonist/vampire/lord) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie) || istype(D, /datum/antagonist/lich))
				return
	
	// Random arousal surges
	if(world.time >= next_arousal_surge)
		if(H.sexcon)
			var/arousal_amount = rand(15, 45)
			H.sexcon.adjust_arousal(arousal_amount)
			to_chat(H, span_love(pick("The mark burns with desire...", "A wave of heat washes over me...", "My body betrays me...")))
		// Set next surge time
		next_arousal_surge = world.time + rand(2 MINUTES, 10 MINUTES)
	
	// Random involuntary emotes
	if(world.time >= next_emote)
		var/emote_choice = pick("shiver", "twitch", "groan")
		H.emote(emote_choice)
		// Set next emote time
		next_emote = world.time + rand(2 MINUTES, 25 MINUTES)

/datum/charflaw/marked_by_baotha/on_removal(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	REMOVE_TRAIT(H, TRAIT_BAOTHA_FERTILITY_BOON, TRAIT_GENERIC)
	H.baotha_mark_overlay = null
	H.update_body()

/datum/charflaw/hemophage
	name = "Hemophage (+1 TRI)"
	desc = "I can only sustain myself on blood. Normal food and drink make me ill and provide no nutrition. I can bite others to drink blood. Any eating-related virtue benefits are negated. +1 TRI"

/datum/charflaw/hemophage/on_mob_creation(mob/living/carbon/human/vamp_wannabe)
	ADD_TRAIT(vamp_wannabe, TRAIT_HEMOPHAGE, TRAIT_GENERIC)
	ADD_TRAIT(vamp_wannabe, TRAIT_VAMPBITE, TRAIT_GENERIC)
	vamp_wannabe.adjust_triumphs(1)

/datum/charflaw/lumbering_giant
	name = "Lumbering Giant (-1 TRI)"
	desc = "I'm 25% larger than normal people, but gain no strength or resilience from my size. I just tower awkwardly over others. This consumes 1 triumph instead of granting it. -1 TRI"

/datum/charflaw/lumbering_giant/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	// Don't apply transform to preview dummies
	if(istype(H, /mob/living/carbon/human/dummy))
		return
	// Apply size transformation only - no traits, no stat bonuses
	H.transform = H.transform.Scale(1.25, 1.25)
	H.transform = H.transform.Translate(0, (0.25 * 16))
	H.update_transform()
	H.adjust_triumphs(-1)

/datum/charflaw/lumbering_giant/on_removal(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(istype(H, /mob/living/carbon/human/dummy))
		return
	// Reverse the transform applied in on_mob_creation
	H.transform = H.transform.Translate(0, -(0.25 * 16))
	H.transform = H.transform.Scale(1/1.25, 1/1.25)
	H.update_transform()

/datum/charflaw/chronic_migraine
	name = "Chronic Migraines (+1 TRI)"
	desc = "I suffer frequent, debilitating headaches every 2-25 minutes. Migraines cause vision blur and damage (2-3 brute). Bright light triggers additional minor headaches. +1 TRI"
	needs_life_tick = TRUE
	var/next_migraine = 0

/datum/charflaw/chronic_migraine/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	to_chat(H, span_warning("You feel the familiar pressure building behind your eyes."))
	H.adjust_triumphs(1)
	next_migraine = world.time + rand(2 MINUTES, 25 MINUTES)

/datum/charflaw/chronic_migraine/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(world.time >= next_migraine)
		// Randomly severe or mild, but always happens
		if(prob(40))
			H.blur_eyes(6)
			H.adjustBruteLoss(3)
			to_chat(H, span_boldwarning("A severe migraine strikes! Your vision blurs and your head pounds!"))
			H.emote("groan")
		else
			H.adjustBruteLoss(2)
			H.blur_eyes(3)
			to_chat(H, span_warning("A painful migraine headache strikes."))
			H.emote("groan")
		next_migraine = world.time + rand(2 MINUTES, 25 MINUTES)

	// Light sensitivity check (can still happen between migraines)
	if(prob(1))
		if(H.loc && H.loc.luminosity > 2)
			H.adjustBruteLoss(1)
			to_chat(H, span_warning("The bright light makes your head throb!"))

/datum/charflaw/weak_heart
	name = "Weak Heart (+1 TRI)"
	desc = "My heart is fragile. Heart attacks occur at 15 stress instead of 30. I suffer periodic chest pains (oxygen loss) every 2-25 minutes. Running with high stamina causes heart strain. +1 TRI"
	needs_life_tick = TRUE
	var/next_chest_pain = 0

/datum/charflaw/weak_heart/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	ADD_TRAIT(user, TRAIT_WEAK_HEART, "[type]")
	user.adjust_triumphs(1)
	next_chest_pain = world.time + rand(2 MINUTES, 25 MINUTES)

/datum/charflaw/weak_heart/on_removal(mob/user)
	if(!ishuman(user))
		return
	REMOVE_TRAIT(user, TRAIT_WEAK_HEART, "[type]")

/datum/charflaw/weak_heart/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	
	// Chest pain warnings when stressed or timed
	var/stress = H.get_stress_amount()
	if(world.time >= next_chest_pain)
		if(stress >= 15)
			to_chat(H, span_danger("Sharp pain shoots through your chest!"))
			H.adjustOxyLoss(25)
			H.emote("gasp")
		else if(stress >= 10)
			to_chat(H, span_warning("Your heart tightens in your chest..."))
			H.adjustOxyLoss(35)
		else
			to_chat(H, span_warning("You feel a flutter in your chest."))
		next_chest_pain = world.time + rand(2 MINUTES, 25 MINUTES)
	
	// Warning when running with high stamina
	if(H.m_intent == MOVE_INTENT_RUN && H.stamina > (H.max_stamina * 0.7) && prob(3))
		to_chat(H, span_warning("Your heart pounds heavily as you exert yourself!"))

/datum/charflaw/tremors
	name = "Tremors (+1 TRI)"
	desc = "My hands shake uncontrollably every 15-30 minutes, forcing me to drop everything I'm holding for 6 seconds. High stress (6+) causes more frequent tremors. I cannot grip items during episodes. +1 TRI"
	needs_life_tick = TRUE
	var/next_tremor_time = 0
	var/base_tremor_interval = 30 MINUTES
	var/stress_tremor_interval = 15 MINUTES

/datum/charflaw/tremors/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_TREMORS, "[type]")
	schedule_next_tremor(H)
	H.adjust_triumphs(1)

/datum/charflaw/tremors/on_removal(mob/user)
	if(!ishuman(user))
		return
	REMOVE_TRAIT(user, TRAIT_TREMORS, "[type]")

/datum/charflaw/tremors/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(world.time >= next_tremor_time)
		trigger_tremor(H)
		schedule_next_tremor(H)

/datum/charflaw/tremors/proc/schedule_next_tremor(mob/living/carbon/human/H)
	if(!H)
		return

	var/tremor_interval = base_tremor_interval
	var/stress_level = H.get_stress_amount()

	if(stress_level >= 6)
		tremor_interval = stress_tremor_interval
	else if(stress_level >= 4)
		tremor_interval = (base_tremor_interval + stress_tremor_interval) / 2

	// Add some randomness so it's not perfectly predictable
	tremor_interval = tremor_interval + rand(-30 SECONDS, 30 SECONDS)
	next_tremor_time = world.time + tremor_interval

/datum/charflaw/tremors/proc/trigger_tremor(mob/living/carbon/human/H)
	if(!H)
		return

	// Visual and audio feedback
	to_chat(H, span_warning("Your hands begin to shake uncontrollably!"))
	H.visible_message(span_warning("[H]'s hands begin trembling!"))

	// Drop everything in hands - respects TRAIT_NODROP
	var/dropped_anything = FALSE
	for(var/obj/item/I in H.held_items)
		if(I)
			if(H.dropItemToGround(I, force = FALSE, silent = FALSE))
				to_chat(H, span_warning("You drop [I] as your hands shake!"))
				dropped_anything = TRUE
	
	// Fallback: try dropping from each hand explicitly if nothing was dropped
	if(!dropped_anything)
		var/obj/item/left_item = H.get_item_for_held_index(1)
		var/obj/item/right_item = H.get_item_for_held_index(2)
		if(left_item)
			if(H.dropItemToGround(left_item, force = FALSE, silent = FALSE))
				to_chat(H, span_warning("You drop [left_item] as your hands shake!"))
		if(right_item)
			if(H.dropItemToGround(right_item, force = FALSE, silent = FALSE))
				to_chat(H, span_warning("You drop [right_item] as your hands shake!"))

	// Apply temporary inability to grip
	H.apply_status_effect(/datum/status_effect/tremor_grip_loss)

	// Shake the screen slightly for immersion
	if(H.client)
		animate(H.client, pixel_x = rand(-2, 2), pixel_y = rand(-2, 2), time = 2)
		addtimer(CALLBACK(src, PROC_REF(reset_screen_shake), H), 2)

/datum/charflaw/tremors/proc/reset_screen_shake(mob/living/carbon/human/H)
	if(H?.client)
		animate(H.client, pixel_x = 0, pixel_y = 0, time = 2)

/datum/status_effect/tremor_grip_loss
	id = "tremor_grip_loss"
	duration = 6 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/tremor_grip_loss

/datum/status_effect/tremor_grip_loss/on_apply()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/H = owner
	to_chat(H, span_warning("Your hands are shaking too much to grip anything!"))

	// Periodic shaking during the effect
	addtimer(CALLBACK(src, PROC_REF(shake_hands)), 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(shake_hands)), 4 SECONDS)

	return TRUE

/datum/status_effect/tremor_grip_loss/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	to_chat(H, span_notice("Your hands steady themselves."))

/datum/status_effect/tremor_grip_loss/proc/shake_hands()
	if(!owner)
		return
	var/mob/living/carbon/human/H = owner
	H.visible_message(span_warning("[H]'s hands continue to tremble."), \
					  span_warning("Your hands continue to shake..."))

/atom/movable/screen/alert/status_effect/tremor_grip_loss
	name = "Trembling Hands"
	desc = "My hands are shaking uncontrollably! I can't grip anything!"

/datum/charflaw/nightmares
	name = "Nightmares (+1 TRI)"
	desc = "I suffer terrible nightmares. While sleeping, I periodically scream and strain, making it harder to get restful sleep. +1 TRI"
	var/next_scream = 0

/datum/charflaw/nightmares/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	user.adjust_triumphs(1)
	next_scream = world.time + rand(2 MINUTES, 25 MINUTES)

/datum/charflaw/nightmares/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(H.IsSleeping())
		if(world.time >= next_scream)
			next_scream = world.time + rand(2 MINUTES, 5 MINUTES)
			// Check if character has Baotha's mark - if so, wet lewd nightmares
			if(H.has_flaw(/datum/charflaw/marked_by_baotha))
				var/list/lewd_nightmare_emotes = list("nightmare_moan","nightmare_groan")
				H.emote(pick(lewd_nightmare_emotes))
			else
				H.emote("nightmare_scream")

/datum/charflaw/chronic_arthritis
	name = "Chronic Arthritis (+2 TRI)"
	desc = "My joints ache constantly. Every 2-25 minutes, I suffer pain flares that drain stamina (5 points). Weather can trigger additional pain between flares. +2 TRI"
	needs_life_tick = TRUE
	var/next_pain_flare = 0

/datum/charflaw/chronic_arthritis/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	to_chat(H, span_warning("Your joints feel stiff and painful - a reminder of your chronic arthritis."))
	H.adjust_triumphs(2)
	next_pain_flare = world.time + rand(2 MINUTES, 25 MINUTES)

/datum/charflaw/chronic_arthritis/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(world.time >= next_pain_flare)
		var/pain_msg = pick("Your joints throb with arthritic pain!",
						   "A sharp ache shoots through your limbs!",
						   "Your joints feel stiff and painful!")
		to_chat(H, span_warning(pain_msg))
		H.adjustStaminaLoss(5)
		next_pain_flare = world.time + rand(2 MINUTES, 25 MINUTES)

	// Weather can still trigger between scheduled flares
	if(prob(1) && H.loc)
		if(SSParticleWeather.runningWeather && SSParticleWeather.runningWeather.can_weather(H) && prob(30))
			H.adjustStaminaLoss(3)
			to_chat(H, span_warning("The weather makes your arthritis act up."))

/datum/charflaw/chronic_back_pain
	name = "Chronic Back Pain (+1 TRI)"
	desc = "My back hurts constantly. Every 2-25 minutes I suffer pain that drains stamina (3-8 points depending on armor weight). Running triggers additional pain. Heavy armor (8 stamina) worsens pain significantly. +1 TRI"
	needs_life_tick = TRUE
	var/next_back_pain = 0

/datum/charflaw/chronic_back_pain/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	to_chat(H, span_warning("Your lower back aches with familiar, persistent pain."))
	H.adjust_triumphs(1)
	next_back_pain = world.time + rand(2 MINUTES, 25 MINUTES)

/datum/charflaw/chronic_back_pain/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	// Running can still trigger between scheduled pains
	if(H.m_intent == MOVE_INTENT_RUN && prob(5))
		H.adjustStaminaLoss(3)
		to_chat(H, span_warning("Running aggravates your chronic back pain!"))

	if(world.time >= next_back_pain)
		// Check for actual armor weight by AC
		var/has_heavy_armor = FALSE
		var/has_medium_armor = FALSE
		
		if(H.wear_armor)
			switch(H.wear_armor.armor_class)
				if(ARMOR_CLASS_HEAVY)
					has_heavy_armor = TRUE
				if(ARMOR_CLASS_MEDIUM)
					has_medium_armor = TRUE
		
		if(H.wear_shirt && !has_heavy_armor) // Only check shirt if not already heavy
			switch(H.wear_shirt.armor_class)
				if(ARMOR_CLASS_HEAVY)
					has_heavy_armor = TRUE
				if(ARMOR_CLASS_MEDIUM)
					has_medium_armor = TRUE
		
		// Always trigger a message and effect
		if(has_heavy_armor)
			H.adjustStaminaLoss(8)
			to_chat(H, span_warning("Your heavy armour puts severe strain on your already painful back!"))
		else if(has_medium_armor)
			H.adjustStaminaLoss(5)
			to_chat(H, span_warning("The weight of your equipment aggravates your chronic back pain!"))
		else
			H.adjustStaminaLoss(3)
			to_chat(H, span_warning(pick("Your lower back aches painfully.", "A sharp pain shoots through your back.", "Your chronic back pain flares up.")))
		
		next_back_pain = world.time + rand(2 MINUTES, 25 MINUTES)

/datum/charflaw/old_war_wound
	name = "Old War Wound (+1 TRI)"
	desc = "An old injury haunts me. Every 2-25 minutes, the wound flares up causing stamina loss (3-5 points). Low health (<70%) or high stress (10+) triggers more severe flare-ups. I start with 3-8 brute damage. +1 TRI"
	needs_life_tick = TRUE
	var/next_wound_pain = 0

/datum/charflaw/old_war_wound/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/wound_desc = pick("shrapnel wound", "old arrow wound", "deep scar", "poorly healed fracture")
	to_chat(H, span_warning("You feel the familiar ache of your old [wound_desc]."))
	H.adjustBruteLoss(rand(3, 8))
	H.adjust_triumphs(1)
	next_wound_pain = world.time + rand(2 MINUTES, 25 MINUTES)

/datum/charflaw/old_war_wound/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(world.time >= next_wound_pain)
		// Stress-triggered pain flares
		if(H.health < (H.maxHealth * 0.7) || H.get_stress_amount() > 10)
			H.adjustStaminaLoss(5)
			to_chat(H, span_warning("Your old war wound flares up from the stress!"))
		else
			// Random phantom pain
			var/pain_type = pick("sharp", "throbbing", "burning", "aching")
			H.adjustStaminaLoss(3)
			to_chat(H, span_warning("A [pain_type] pain shoots through your old wound."))
		next_wound_pain = world.time + rand(2 MINUTES, 25 MINUTES)

/datum/charflaw/hard_of_hearing
	name = "Hard of Hearing (+2 TRI)"
	desc = "My hearing is severely impaired. I can only hear people clearly if they're very close, or if they yell. Distant conversations are muffled or inaudible. +2 TRI"

/datum/charflaw/hard_of_hearing/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_PARTIAL_DEAF, TRAIT_GENERIC)
	H.adjust_triumphs(2)

/datum/charflaw/hard_of_hearing/on_removal(mob/user)
	if(!ishuman(user))
		return
	REMOVE_TRAIT(user, TRAIT_PARTIAL_DEAF, TRAIT_GENERIC)

// Status effects for character flaws
/datum/status_effect/moon_touched
	id = "moon_touched"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/moon_touched

/datum/status_effect/bigearsannoy_cd
	id = "bigearsannoy_cd"
	duration = 8 SECONDS
	alert_type = null

/datum/status_effect/moon_touched/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_SILVER_WEAK, "moon_touched")
	ADD_TRAIT(owner, TRAIT_NOCSIGHT, "moon_touched")
	return TRUE

/datum/status_effect/moon_touched/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SILVER_WEAK, "moon_touched")
	REMOVE_TRAIT(owner, TRAIT_NOCSIGHT, "moon_touched")

/atom/movable/screen/alert/status_effect/moon_touched
	name = "Moon-Touched"
	desc = "The moonlight has awakened something primal in me. My night vision sharpens but my body burns and my mind is slipping..."
	icon_state = "nite_bad"

// ============ BIG EARS ============

/datum/charflaw/big_ears
	name = "Big Ears"
	desc = "I'm extremely sensitive to loud noises. Yelling and shouts near me cause stress. However, I have enhanced hearing and can hear better than most. +1 TRI"

/datum/charflaw/big_ears/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_BIG_EARS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KEENEARS, TRAIT_GENERIC)


/datum/charflaw/big_ears/on_removal(mob/user)
	if(!ishuman(user))
		return
	REMOVE_TRAIT(user, TRAIT_BIG_EARS, TRAIT_GENERIC)
	REMOVE_TRAIT(user, TRAIT_KEENEARS, TRAIT_GENERIC)

// ============ DISGRACED NOBLE ============

/datum/charflaw/disgraced_noble
	name = "Disgraced Noble"
	desc = "Requires a noble character. My house has fallen from grace. Other nobles recognize my shame, I lose all estate income from the treasury, and my title is merely ceremonial. I retain the title in name only."
	var/applied = FALSE

/datum/charflaw/disgraced_noble/apply_post_equipment(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	// Requirement: must be a noble job or have TRAIT_NOBLE
	if(!H.is_noble())
		to_chat(H, span_warning("The Disgraced Noble vice requires a noble character. It has been removed without effect."))
		return

	applied = TRUE
	ADD_TRAIT(H, TRAIT_DISGRACED_NOBLE, TRAIT_GENERIC)
	// Strip noble income from the treasury subsystem
	SStreasury.noble_incomes -= H
	to_chat(H, span_warning("Your house's fall from grace is a weight you carry every day. Your estate income is forfeit."))

/datum/charflaw/disgraced_noble/on_removal(mob/user)
	if(!ishuman(user))
		return
	if(applied)
		REMOVE_TRAIT(user, TRAIT_DISGRACED_NOBLE, TRAIT_GENERIC)

// ============ LIGHT SENSITIVITY ============

/datum/charflaw/light_sensitive
	name = "Light Sensitivity"
	desc = "Bright lights (luminosity >4) cause me stress. I do best in dim, candlelit spaces or darkness."
	var/last_light_check = 0

/datum/charflaw/light_sensitive/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_LIGHT_SENSITIVE, TRAIT_GENERIC)

/datum/charflaw/light_sensitive/on_removal(mob/user)
	if(!ishuman(user))
		return
	REMOVE_TRAIT(user, TRAIT_LIGHT_SENSITIVE, TRAIT_GENERIC)
	user.remove_stress(/datum/stressevent/vice/light_sensitive)

/datum/charflaw/light_sensitive/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	if(world.time < last_light_check + 5 SECONDS)
		return
	last_light_check = world.time
	var/mob/living/carbon/human/H = user
	if(!H.loc)
		return
	if(H.loc.luminosity > 4)
		H.add_stress(/datum/stressevent/vice/light_sensitive)
		if(prob(20))
			var/light_msg = pick(
				"The brightness is unbearable - your eyes ache and your head throbs!",
				"All this light makes your skin crawl...",
				"You squint painfully against the glare.",
				"Even the torchlight feels like daggers in your eyes.")
			to_chat(H, span_warning(light_msg))
	if(H.loc.luminosity <= 4)
		H.remove_stress(/datum/stressevent/vice/light_sensitive)

//SPURNED - Healing miracles doesn't work
/datum/charflaw/spurned
	name = "Spurned"
	desc = "The gods have forsaken me. Healing miracles and divine magic have no beneficial effect on me. +2 TRI"

/datum/charflaw/spurned/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_SPURNED, TRAIT_GENERIC)
	to_chat(H, span_warning("The divine has turned its back on me. Healing miracles will not save me."))
	H.adjust_triumphs(2)

/datum/charflaw/spurned/on_removal(mob/user)
	if(!ishuman(user))
		return
	REMOVE_TRAIT(user, TRAIT_SPURNED, TRAIT_GENERIC)

//ILLITERATE - Cannot read or train reading
/datum/charflaw/illiterate
	name = "Illiterate"
	desc = "I never learned to read and never will. All Reading skills are removed and set to 0, and cannot be trained or improved."

/datum/charflaw/illiterate/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_ILLITERATE, TRAIT_GENERIC)
	// Set reading skill to 0 and remove all experience
	H.adjust_skillrank(/datum/skill/misc/reading, -6, TRUE)
	if(H.skills && H.skills.skill_experience)
		var/datum/skill/reading_skill = SSskills.all_skills[/datum/skill/misc/reading]
		if(reading_skill)
			H.skills.skill_experience[reading_skill] = 0
	to_chat(H, span_warning("I never learned to read, and I never will. The written word is forever beyond me."))

/datum/charflaw/illiterate/on_removal(mob/user)
	if(!ishuman(user))
		return
	REMOVE_TRAIT(user, TRAIT_ILLITERATE, TRAIT_GENERIC)

/datum/charflaw/carnivore
	name = "Carnivore"
	desc = "I can only digest meat. Plant-based foods like berries, fruits, and vegetables make me ill. Eating too much will poison me."

/datum/charflaw/carnivore/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_CARNIVORE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NASTY_EATER, TRAIT_GENERIC) // Can eat raw meat

/datum/charflaw/herbivore
	name = "Herbivore"
	desc = "I can only digest plant-based foods. Meat and animal products make me sick. Eating too much will poison me."

/datum/charflaw/herbivore/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_HERBIVORE, TRAIT_GENERIC)

/datum/charflaw/lithovore
	name = "Lithovore"
	desc = "My unique physiology allows me to consume and digest rocks and gems for nutrition. However, I can't gain nutrition from regular food."

/datum/charflaw/lithovore/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_LITHOVORE, TRAIT_GENERIC)
