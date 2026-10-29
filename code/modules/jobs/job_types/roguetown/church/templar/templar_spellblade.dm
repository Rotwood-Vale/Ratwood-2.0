/datum/advclass/templar/noc_spellblade
	name = "Noccite Warmage"
	tutorial = "You are a Noccite Warmage - A devotee of the Holy Church. While other templars don blessed heavy armor and clerical teachings, you chose a different path Wielder of both Blessed Blades and Magycks, you are an Warmage, the Will of the Tutor-God. You swore a sacred covenant, to Protect the Church and it's acolytes. Be a reminder that the night is full of stars and that fear is a blade dulled by knowledge."
	outfit = /datum/outfit/job/roguetown/templar/noc_spellblade
	category_tags = list(CTAG_TEMPLAR)
	allowed_patrons = list(/datum/patron/divine/noc)
	maximum_possible_slots = 2
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ARCYNE, TRAIT_UNCONVERTIBLE)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 8)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/templar/noc_spellblade
	var/tmp/subclass_selected = null

/datum/outfit/job/roguetown/templar/noc_spellblade/Topic(href, href_list)
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
		return TRUE
	return ..()

/datum/outfit/job/roguetown/templar/noc_spellblade/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/tabard/crusader/noc
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/rogueweapon/shield/heater
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/clothing/neck/roguetown/psicross/noc
	beltr = /obj/item/rogueweapon/scabbard/sword
	id = /obj/item/clothing/ring/silver
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/ritechalk = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/churchie = 1,
		/obj/item/rogueweapon/spellbook = 1
	)

	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "noccite", "Moonlight Khopesh")
	H << browse(selection_html, "window=spellblade_chant;size=1100x900")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellblade_chant")

	if(!subclass_selected)
		subclass_selected = "blade"

	var/spellblade_chant_selected = subclass_selected

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = spellblade_chant_selected

	if(H.mind)
		switch(spellblade_chant_selected)
			if("blade")
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	var/helmets = list(
		"Noc Helmet"            = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm,
		"Snouted Noc Helmet"    = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm/snouted
	)
	var/helmchoice = input(H, "Choose your Helm.", "REFLECTION OF PALE LIGHT") as anything in helmets
	head = helmets[helmchoice]
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2, start_maxed = TRUE)

/datum/outfit/job/roguetown/templar/noc_spellblade/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/datum/status_effect/buff/arcyne_momentum/momentum = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	var/spellblade_chant_selected = momentum?.chant

	var/obj/item/rogueweapon/granted_weapon = null
	switch(spellblade_chant_selected)
		if("blade")
			var/list/weapons = list("Moonlight Khopesh", "Longsword", "Rapier", "Sabre", "Steel Arming Sword", "Steel Greatsword", "Steel Dagger")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Moonlight Khopesh")
					granted_weapon = new /obj/item/rogueweapon/sword/sabre/nockhopesh(H)
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
				if("Longsword")
					granted_weapon = new /obj/item/rogueweapon/sword/long/church(H)
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
				if("Rapier")
					granted_weapon = new /obj/item/rogueweapon/sword/rapier(H)
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
				if("Sabre")
					granted_weapon = new /obj/item/rogueweapon/sword/sabre(H)
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
				if("Steel Arming Sword")
					granted_weapon = new /obj/item/rogueweapon/sword(H)
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
				if("Steel Greatsword")
					granted_weapon = new /obj/item/rogueweapon/greatsword(H)
					qdel(H.get_item_by_slot(SLOT_BACK_R))
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
				if("Steel Dagger")
					granted_weapon = new /obj/item/rogueweapon/huntingknife/idagger/steel(H)
		if("phalangite")
			var/polearm_weapons = list("Halberd", "Bardiche", "Dory")
			var/polearm_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in polearm_weapons
			switch(polearm_choice)
				if("Halberd")
					granted_weapon = new /obj/item/rogueweapon/halberd(H)
					qdel(H.get_item_by_slot(SLOT_BACK_R))
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
				if("Bardiche")
					granted_weapon = new /obj/item/rogueweapon/halberd/bardiche(H)
					qdel(H.get_item_by_slot(SLOT_BACK_R))
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
				if("Dory")
					granted_weapon = new /obj/item/rogueweapon/spear/spellblade(H)
		if("macebearer")
			var/mace_weapons = list("Steel Mace", "Steel Warhammer", "Grand Mace", "Battle Axe", "Steel Greataxe")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			switch(mace_choice)
				if("Steel Mace")
					granted_weapon = new /obj/item/rogueweapon/mace/steel(H)
				if("Steel Warhammer")
					granted_weapon = new /obj/item/rogueweapon/mace/warhammer/steel(H)
				if("Grand Mace")
					granted_weapon = new /obj/item/rogueweapon/mace/goden/steel(H)
					qdel(H.get_item_by_slot(SLOT_BACK_R))
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
				if("Battle Axe")
					granted_weapon = new /obj/item/rogueweapon/stoneaxe/battle(H)
				if("Steel Greataxe")
					granted_weapon = new /obj/item/rogueweapon/greataxe/steel(H)
					qdel(H.get_item_by_slot(SLOT_BACK_R))
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
	if(granted_weapon)
		H.put_in_hands(granted_weapon)
		H.adjust_skillrank_up_to(granted_weapon.associated_skill, SKILL_LEVEL_EXPERT, TRUE)
