/datum/virtue/utility/noble
	name = "Nobility (-4 TRI)"
	desc = "By birth, blade or brain, I am a titled noble known to the royalty of these lands, supported by an estate and enjoying the standing of my peers. \
			I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom."
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list("Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
								"Hefty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch)
	triumph_cost = 4

/datum/virtue/utility/noble/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15
	recipient.social_rank = max(recipient.social_rank, SOCIAL_RANK_NOBLE)

/datum/virtue/utility/socialite
	name = "Socialite"
	desc = "I thrive in social settings, easily reading the emotions of others and charming those around me. My presence is always felt at any gathering."
	custom_text = "Incompatible with Ugly quirk. Grants empathic insight."
	added_traits = list(TRAIT_BEAUTIFUL, TRAIT_GOODLOVER, TRAIT_EMPATH)
	added_stashed_items = list(
		"Hand Mirror" = /obj/item/handmirror)

/datum/virtue/utility/socialite/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_UNSEEMLY))
		to_chat(recipient, "Your attractiveness is cancelled out! You become normal.")
		if(HAS_TRAIT(recipient, TRAIT_BEAUTIFUL))
			REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
		REMOVE_TRAIT(recipient, TRAIT_UNSEEMLY, TRAIT_VIRTUE)

/datum/virtue/utility/deadened
	name = "Deadened"
	desc = "Some terrible incident colours my past, and now, I feel nothing."
	added_traits = list(TRAIT_NOMOOD, TRAIT_DETACHED)

//VALMORIAN: Light Steps retired and moved to background.dm (background/light_steps) - see
//modular_azurepeak/virtues/retired.dm for the stub that keeps old saves resolving.

/datum/virtue/utility/resident
	name = "Resident"
	desc = "I'm a resident of these lands. I have an account in the city's treasury and a home in the city."
	added_traits = list(TRAIT_RESIDENT)

/datum/virtue/utility/resident/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient?.mind)
		return

	var/assigned_role = recipient.mind.assigned_role
	if(!(assigned_role in list("Adventurer", "Mercenary", "Court Agent")))
		return

	sync_towner_knowledge(recipient)
	SSjob.sync_resident_wanderer_knowledge(recipient, TRUE)

/datum/virtue/utility/resident/proc/sync_towner_knowledge(mob/living/carbon/human/recipient)
	if(!recipient?.mind)
		return

	var/datum/job/roguetown/villager/towner_job = SSjob.GetJob("Towner")
	if(!towner_job)
		return

	for(var/X in towner_job.peopleknowme)
		for(var/datum/mind/MF in get_minds(X))
			if(isnull(recipient.mind?.special_role) && (MF?.special_role in list(ROLE_VAMPIRE, ROLE_NBEAST, ROLE_BANDIT, ROLE_LICH, ROLE_WRETCH, ROLE_UNBOUND_DEATHKNIGHT)))
				continue
			recipient.mind.person_knows_me(MF)

	for(var/X in towner_job.peopleiknow)
		for(var/datum/mind/MF in get_minds(X))
			if(isnull(recipient.mind?.special_role) && (MF?.special_role in list(ROLE_VAMPIRE, ROLE_NBEAST, ROLE_BANDIT, ROLE_LICH, ROLE_WRETCH, ROLE_UNBOUND_DEATHKNIGHT)))
				continue
			recipient.mind.i_know_person(MF)

/datum/virtue/utility/failed_squire
	name = "Failed Squire"
	desc = "I was once a squire in training, but failed to achieve knighthood. Though my dreams of glory were dashed, I retained my knowledge of equipment maintenance and repair, including how to polish arms and armor."
	added_traits = list(TRAIT_SQUIRE_REPAIR)
	added_stashed_items = list(
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Polishing Cream" = /obj/item/polishing_cream,
		"Fine Brush" = /obj/item/armor_brush,
		"Armor Plates" = /obj/item/repair_kit/metal,
		"Sewing Kit" = /obj/item/repair_kit,
	)

/datum/virtue/utility/failed_squire/apply_to_human(mob/living/carbon/human/recipient)
	to_chat(recipient, span_notice("Though you failed to become a knight, your training in equipment maintenance and repair remains useful."))
	to_chat(recipient, span_notice("You can retrieve your hammer and polishing tools from a tree, statue, or clock."))

//VALMORIAN: Intellectual retired and moved to background.dm (background/linguist) - see
//modular_azurepeak/virtues/retired.dm for the stub that keeps old saves resolving.

/datum/virtue/utility/deathless
	name = "Deathless"
	desc = "Some fell magick has rendered me inwardly unliving - I do not hunger, and I do not breathe."
	added_traits = list(TRAIT_NOHUNGER, TRAIT_NOBREATH)

/datum/virtue/utility/deathless/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_HEMOPHAGE))
		to_chat(recipient, "My reliance on lyfeblood cannot be severed!")
		REMOVE_TRAIT(recipient, TRAIT_NOHUNGER, TRAIT_VIRTUE)

/datum/virtue/utility/feral_appetite
	name = "Feral Appetite"
	desc = "I can eat just about ANYTHING, rotten or poisonous food and tainted water, even entrails..."
	added_traits = list(TRAIT_NASTY_EATER, TRAIT_ORGAN_EATER)

/datum/virtue/utility/feral_appetite/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_HEMOPHAGE))
		to_chat(recipient, "My reliance on lyfeblood cannot be severed!")
		REMOVE_TRAIT(recipient, TRAIT_NASTY_EATER, TRAIT_VIRTUE)

/datum/virtue/utility/night_vision
	name = "Night-eyed"
	desc = "I have eyes able to see through cloying darkness. Incompatible with the vice Colorblind."
	added_traits = list(TRAIT_DARKVISION)
	custom_text = "Adds a button to toggle colorblindness to aid seeing in the dark. Taking this with the Colorblind vice will permanently colorblind you."
	incompatible_vices = list(/datum/charflaw/colorblind)

/datum/virtue/utility/night_vision/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/colorblind)
			to_chat(recipient, "Your eyes have become permanently colorblind.")
		else
			recipient.verbs += /mob/living/carbon/human/proc/toggleblindness

//VALMORIAN: Performer retired and moved to background.dm (background/performer) - see
//modular_azurepeak/virtues/retired.dm for the stub that keeps old saves resolving.

/datum/virtue/utility/larcenous
	name = "Larcenous"
	desc = "Whether it was asked of you, or by a calling for the rush deep within your hollow heart, you seek things that don't belong you. You know how to work a lock, and have stashed a ring of them, for just the occasion."
	added_stashed_items = list("Lockpick Ring" = /obj/item/lockpickring/mundane)
	added_skills = list(list(/datum/skill/misc/lockpicking, 3, 6))

//VALMORIAN: Cunning Provisioner and Forester retired and moved to background.dm
//(background/granary, background/forester) - see modular_azurepeak/virtues/retired.dm for the stubs
//that keep old saves resolving.

/datum/virtue/utility/homesteader
	name = "Pilgrim (-2 TRI)"
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	desc= "As they say, 'hearth is where the heart is'. You are intimately familiar with the labors of lyfe, and have stowed away everything necessary to start anew: a hunting dagger, your trusty hoe, and a sack of assorted supplies."
	triumph_cost = 2
	added_stashed_items = list(
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Bag of Food" = /obj/item/storage/roguebag/food,
		"Hunting Knife" = /obj/item/rogueweapon/huntingknife
	)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 3),
						list(/datum/skill/misc/athletics, 2, 2),
						list(/datum/skill/labor/farming, 3, 3),
						list(/datum/skill/labor/fishing, 3, 3),
						list(/datum/skill/labor/lumberjacking, 2, 2),
						list(/datum/skill/combat/knives, 2, 2)
	)

/datum/virtue/utility/keenears
	name = "Keen Ears"
	desc = "Cowering from authorities, loved ones or by a generous gift of the gods, you've adapted a keen sense of hearing, and can identify the speakers even when they are out of sight, their whispers ringing louder."
	added_traits = list(TRAIT_KEENEARS)
	custom_text = "You can identify known people who speak even when they are out of sight. You can hear people speaking normally above and below you, regardless of obstacles in the way. You can hear whispers from one tile further."

//VALMORIAN: Sleuth retired and moved to background.dm (background/tracker) - see
//modular_azurepeak/virtues/retired.dm for the stub that keeps old saves resolving.

/datum/virtue/utility/bronzearm_r
	name = "Bronze Arm (R)"
	desc = "Through connections or wealth, my arm had been replaced by one of bronze and gears, that can grip and hold onto things. I've learned just a bit of Engineering as a result."
	custom_text = "Replaces your Right arm with a prosthetic Bronze one. Incompatible with Wood Arm (R) vice"
	added_skills = list(list(/datum/skill/craft/engineering, 1, 6))
	incompatible_vices = list(/datum/charflaw/limbloss/arm_r)
	incompatible_virtues = list(/datum/virtue/utility/bronzearm_l)

/datum/virtue/utility/bronzearm_r/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/obj/item/bodypart/O = recipient.get_bodypart(BODY_ZONE_R_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/limbloss/arm_r)
			to_chat(recipient, span_info("In my foolishness I believed a sharlatan who wished to trade in my wooden arm for one of bronze. It fell apart. Now I've no arm at all."))
		else
			var/obj/item/bodypart/r_arm/prosthetic/bronzeright/L = new()
			L.attach_limb(recipient)

/datum/virtue/utility/bronzearm_l
	name = "Bronze Arm (L)"
	desc = "Through connections or wealth, my arm had been replaced by one of bronze and gears, that can grip and hold onto things. I've learned just a bit of Engineering as a result."
	custom_text = "Replaces your Left arm with a prosthetic Bronze one. Incompatible with Wood Arm (L) vice"
	added_skills = list(list(/datum/skill/craft/engineering, 1, 6))
	incompatible_vices = list(/datum/charflaw/limbloss/arm_l)
	incompatible_virtues = list(/datum/virtue/utility/bronzearm_r)

/datum/virtue/utility/bronzearm_l/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/obj/item/bodypart/O = recipient.get_bodypart(BODY_ZONE_L_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/limbloss/arm_l)
			to_chat(recipient, span_info("In my foolishness I believed a sharlatan who wished to trade in my wooden arm for one of bronze. It fell apart. Now I've no arm at all."))
		else
			var/obj/item/bodypart/l_arm/prosthetic/bronzeleft/L = new()
			L.attach_limb(recipient)

/datum/virtue/utility/bronzeleg_r
	name = "Bronze Leg (R)"
	desc = "Through connections or wealth, my leg had been replaced by one of bronze and gears, that can move and hold your weight. I've learned just a bit of Engineering as a result."
	custom_text = "Replaces your Right leg with a prosthetic Bronze one."
	added_skills = list(list(/datum/skill/craft/engineering, 1, 6))
	incompatible_virtues = list(/datum/virtue/utility/bronzearm_l, /datum/virtue/utility/bronzearm_r, /datum/virtue/utility/bronzeleg_l)

/datum/virtue/utility/bronzeleg_r/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/obj/item/bodypart/O = recipient.get_bodypart(BODY_ZONE_R_LEG)
	if(O)
		O.drop_limb()
		qdel(O)
	var/obj/item/bodypart/r_leg/prosthetic/bronzeright/L = new()
	L.attach_limb(recipient)

/datum/virtue/utility/bronzeleg_l
	name = "Bronze Leg (L)"
	desc = "Through connections or wealth, my leg had been replaced by one of bronze and gears, that can move and hold your weight. I've learned just a bit of Engineering as a result."
	custom_text = "Replaces your Left leg with a prosthetic Bronze one."
	added_skills = list(list(/datum/skill/craft/engineering, 1, 6))
	incompatible_virtues = list(/datum/virtue/utility/bronzearm_l, /datum/virtue/utility/bronzearm_r, /datum/virtue/utility/bronzeleg_r)

/datum/virtue/utility/bronzeleg_l/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/obj/item/bodypart/O = recipient.get_bodypart(BODY_ZONE_L_LEG)
	if(O)
		O.drop_limb()
		qdel(O)
	var/obj/item/bodypart/l_leg/prosthetic/bronzeleft/L = new()
	L.attach_limb(recipient)

/datum/virtue/utility/woodwalker
	name = "Woodwalker"
	desc = "After years of training in the wilds, I've learned to traverse the woods confidently, without breaking any twigs. I can even step lightly on leaves without falling, and I can gather twice as many things from bushes. I can also sleep comfortably on a tree branch."
	added_traits = list(TRAIT_WOODWALKER, TRAIT_OUTDOORSMAN)

/datum/virtue/utility/zchurch_keyholder
	name = "Defiled Keyholder"
	desc = "The 'Holy' See has their blood-stained grounds, and so do we. Underneath their noses, we pray to the true gods - I know the locations of the local heretic conclave and the bandit hideout. Secrecy is paramount. If found out, I will surely be killed."
	added_traits = list(TRAIT_ZURCH, TRAIT_BANDITCAMP)

/datum/virtue/utility/mountable
	name = "Mountable"
	desc = "You have trained or been trained into a suitable mount. People may ride you as they would a saiga."
	added_traits = list(TRAIT_PONYGIRL_RIDEABLE)

/datum/virtue/utility/tolerant
	name = "Tolerant"
	desc = "Whether fostered through travel or care, you just don't see an issue with certain folks."
	custom_text = "Prevents you from experiencing negative stress events when looking at select species."
	added_traits = list(TRAIT_TOLERANT)

// Apprentice-level virtues - provide broad skill sets without traits or items
// Max skill level is Apprentice (level 2), allowing varied work without full progression

/datum/virtue/utility/survivalist_novice
	name = "Novice Survivalist"
	desc = "I've lived in the wilds and learned to survive off the land. I can hunt, track, fish, trap, and butcher game - all the skills needed to live beyond civilization's walls."
	added_skills = list(
		list(/datum/skill/misc/tracking, 1, 2),
		list(/datum/skill/labor/butchering, 1, 2),
		list(/datum/skill/craft/tanning, 1, 2),
		list(/datum/skill/combat/polearms, 1, 2),
		list(/datum/skill/combat/slings, 1, 2),
		list(/datum/skill/craft/crafting, 1, 2),
		list(/datum/skill/craft/cooking, 1, 2),
		list(/datum/skill/labor/lumberjacking, 1, 2),
		list(/datum/skill/misc/climbing, 1, 2),
		list(/datum/skill/misc/swimming, 1, 2),
		list(/datum/skill/misc/sneaking, 1, 2),
		list(/datum/skill/misc/medicine, 1, 1)
	)

/datum/virtue/utility/homesteader_novice
	name = "Novice Homesteader"
	desc = "I know how to maintain a homestead - farming the land, cooking meals, chopping wood, and all the daily labors needed to be self-sufficient."
	added_skills = list(
		list(/datum/skill/labor/farming, 1, 2),
		list(/datum/skill/craft/cooking, 1, 2),
		list(/datum/skill/labor/lumberjacking, 1, 2),
		list(/datum/skill/misc/lockpicking, 1, 2),
		list(/datum/skill/misc/climbing, 1, 2),
		list(/datum/skill/misc/athletics, 1, 2),
		list(/datum/skill/labor/fishing, 1, 2),
		list(/datum/skill/craft/masonry, 1, 2),
		list(/datum/skill/craft/carpentry, 1, 2),
		list(/datum/skill/craft/crafting, 1, 2),
		list(/datum/skill/combat/maces, 1, 2),
		list(/datum/skill/combat/axes, 1, 2)
	)

/datum/virtue/utility/artisan_novice
	name = "Novice Artisan"
	desc = "I've learned the fundamentals of crafting - working with metal, fabric, and clay. I'm a jack of all trades in the workshop, though master of none."
	added_skills = list(
		list(/datum/skill/craft/crafting, 1, 2),
		list(/datum/skill/craft/blacksmithing, 1, 2),
		list(/datum/skill/craft/sewing, 1, 2),
		list(/datum/skill/craft/smelting, 1, 2),
		list(/datum/skill/craft/weaponsmithing, 1, 2),
		list(/datum/skill/craft/armorsmithing, 1, 2),
		list(/datum/skill/combat/knives, 1, 2),
		list(/datum/skill/craft/ceramics, 1, 2),
		list(/datum/skill/craft/engineering, 1, 2)
	)

/datum/virtue/utility/healer_novice
	name = "Novice Healer"
	desc = "I've studied the healing arts - tending wounds, brewing remedies, and understanding the basics of medicine and alchemy."
	added_skills = list(
		list(/datum/skill/misc/medicine, 1, 2),
		list(/datum/skill/craft/alchemy, 1, 2),
		list(/datum/skill/misc/reading, 1, 2),
		list(/datum/skill/craft/crafting, 1, 2),
		list(/datum/skill/craft/sewing, 1, 2),
		list(/datum/skill/craft/cooking, 1, 2),
		list(/datum/skill/combat/knives, 1, 2)
	)

/datum/virtue/heretic
