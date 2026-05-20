/datum/advclass/wretch/ancientchampion
	name = "Ancient Champion"
	tutorial = "In life, you were a mortal warrior shedding blood for Her Majesty, a veteran of countless battles and razings. In death, you have been rewarded with a privilege to serve Her forever more. You awaken once again, wielding blade and arcyne, to complete Her Grandest Work."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_SHUNNED_UP //Can't be Revenant (because bugs) and can't be Construct (also bugs). You get force-set to Skeleton Human anyway.
	outfit = /datum/outfit/job/roguetown/wretch/ancientchampion
	cmode_music = 'sound/music/combat_ancient.ogg'
	class_select_category = CLASS_CAT_ACCURSED
	category_tags = list(CTAG_WRETCH)
	maximum_possible_slots = 1 //Spellcaster in Luxarmour, with Master in swords. Zizo's top skeleton.
	applies_post_equipment = TRUE
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_OVERTHERETIC, TRAIT_ARCYNE_T2)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = -3, //Slow as molasses. Weighted stat total of +8 without "The Path of Might", +17 with it.
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER, //Master of Avantyne Longsword
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT, //Can side-spec into maces, but not desirable.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	) //No Swimming because skeletons in water is bad.

/datum/outfit/job/roguetown/wretch/ancientchampion
	has_loadout = TRUE

/datum/outfit/job/roguetown/wretch/ancientchampion/pre_equip(mob/living/carbon/human/H)
	..()

	if(H.mind)
		H.become_skeleton()
		H.set_patron(/datum/patron/inhumen/zizo) //Your entire purpose.
		H.adjust_blindness(-3)
		H.mind.add_antag_datum(new /datum/antagonist/skeleton())
	neck = /obj/item/clothing/neck/roguetown/bevor
	mask = /obj/item/flowercrown/rosa //Worn by Her champions. Bring death to bring forth new life.
	cloak = /obj/item/clothing/cloak/half
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy //We don't want to get bodyshot to death by archers
	pants = /obj/item/clothing/under/roguetown/platelegs/zizo
	gloves = /obj/item/clothing/gloves/roguetown/plate/zizo
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo
	belt = /obj/item/storage/belt/rogue/leather/black
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
	backr = /obj/item/rogueweapon/shield/tower/metal
	backl = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/rogueweapon/sword/long/zizo
	beltl = /obj/item/rogueweapon/scabbard/sword
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic) //Voluntary conversion.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/zizo_snuff/champion) //Champion-variant of Snuff Lights. Non-miracle, static range of 7, but much longer CD.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending) //You can't take off your armour or do rites, so that's your only way of repairing your armour.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/deathgrasp) //GET OVER HERE. Fetch that also applies -4 Speed, but with a longer CD.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/churnliving) //Repulse variant. Get out of dorpels. Longer charge time and CD, but greater push range (2 tiles) and affected targets lose some stamina.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/profane) //Non-miracle version, your only way of dealing ranged damage without The Path of Magic.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonemend) //Awkward-to-use self-heal.
		H.dna.species.soundpack_m = new /datum/voicepack/male/evil() //Normal Skeleton voice is funny rather than menacing.
		H.dna.species.soundpack_f = new /datum/voicepack/female/haughty()
	H.set_blindness(0)
	H.energy = H.max_energy //Just in case.
	REMOVE_TRAIT(H, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	to_chat(H, span_danger("You are an ancient warrior risen from death, not a comedic skeleton. Be menacing and play with gravitas rather than humour."))
	var/helmets = list("BARBUTE - VISORED", "FROGMOUTH - NECK PROTECTION")
	var/helmet_choice = input(H, "Choose your helmet.", "PROTECTION FROM THE LADY") as anything in helmets
	switch(helmet_choice)
		if("BARBUTE - VISORED")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
		if("FROGMOUTH - NECK PROTECTION")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/zizo

/datum/outfit/job/roguetown/wretch/ancientchampion/choose_loadout(mob/living/carbon/human/H)
	if(H.mind)
		var/paths = list("The Path of Might (+1 ALL STATS)", "The Path of Magic (More Spells)")
		var/path_choice = input(H, "What did you excel at in life?", "IN HER NAME.") as anything in paths
		switch(path_choice)
			if("The Path of Might (+1 ALL STATS)") //Omnistat for maximum bounty. You are already supervalid.
				H.change_stat("strength", 1)
				H.change_stat("perception", 1)
				H.change_stat("intelligence", 1)
				H.change_stat("constitution", 1)
				H.change_stat("willpower", 1)
				H.change_stat("speed", 1)
				H.change_stat("fortune", 1)
			if("The Path of Magic (More Spells)") //Silence & Raise Deadite, plus choice between Bolt of Lightning and Ensnare.
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/silence)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_deadite)
				var/extraspell = list("Bolt of Lightning", "Ensnare")
				var/spell_choice = input(H,"Choose your offensive spell.", "INEVITABILITY OF PROGRESS") as anything in extraspell
				switch(spell_choice)
					if("Bolt of Lightning")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt)
					if("Ensnare")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/ensnare)


/obj/effect/proc_holder/spell/invoked/bonemend
	name = "Bone Mend"
	desc = "Mend the chosen target's bones with a burst of necrotic magick. Requires standing still for a few seconds"
	cost = 3
	overlay_state = "rituos"
	releasedrain = 50
	chargetime = 5 SECONDS // Make in combat usage harder
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/magic/woundheal_crunch.ogg'
	spell_tier = 2
	chargedloop = /datum/looping_sound/invokeascendant
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS
	miracle = FALSE
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/bonemend/cast(list/targets, mob/living/user)
	..()
	if(!isliving(targets[1]))
		return FALSE

	var/mob/living/target = targets[1]
	if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(user.zone_selected))
		if(affecting && (affecting.heal_damage(50, 50) || affecting.heal_wounds(50)))
			target.update_damage_overlays()
		target.visible_message(span_danger("[target] reforms under the vile energy!"), span_notice("I'm remade by dark magic!"))
		return TRUE
	return TRUE
