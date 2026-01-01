//Nomad is a combination subclass.
//They choose between shield + spear, or miraclist flagellant. Flagellant stuff isn't done, but, whatever...
/datum/advclass/foreigner/dunewell
	name = "Dunewell Nomad"
	tutorial = "Dunewell, deep in the Zybantu deserts, is a place of madness. A region of faith and heresy alike. \
	For yils, many have fought over the riches and ruins of the old Psydonian holdout. Those who come from it are typically nomads of either party. \
	Missionary and killer, one in the same. To have ventured as far as Ferentia, you've either escaped the cycle, or intend to repeat it."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/dnomad
	subclass_languages = list(/datum/language/celestial)
	cmode_music = 'sound/music/horror.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DECEIVING_MEEKNESS)
	subclass_stats = list(//Stats handled by loadout, beyond these two.
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(//Other skills handled by loadout.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy,
		"Token of Home" = /obj/item/clothing/neck/roguetown/psicross,
	)
	extra_context = "This subclass, exclusive to Psydonites and Inhumen, focuses on two styles of gameplay. \
	You can choose a martial loadout, for: +2PER/+1STR, JMAN spears, EXPT shields. \
	Alternatively, neglect your martial, for: +2PER/+1SPD, JMAN holy, EXPT staves, T2 miracles."

//This is gross, but it works. Better than a new define.
/datum/outfit/job/roguetown/adventurer/dnomad
	allowed_patrons = list(/datum/patron/inhumen/baotha, /datum/patron/inhumen/graggar,
	/datum/patron/inhumen/zizo, /datum/patron/inhumen/matthios, /datum/patron/old_god)

/datum/outfit/job/roguetown/adventurer/dnomad/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/ragmask/nomad
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/nomad
	wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	neck = /obj/item/clothing/neck/roguetown/coif/padded/nomad
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron
	gloves = /obj/item/clothing/gloves/roguetown/bandages
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/nomad
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/nomad
	cloak = /obj/item/clothing/cloak/cape/nomad
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/reagent_containers/glass/bottle/waterskin
	backpack_contents = list(/obj/item/recipe_book/survival = 1,
							/obj/item/rogueweapon/huntingknife = 1,
							/obj/item/rogueweapon/scabbard/sheath = 1)

	if(H.mind)
		var/nomad_purpose = list("Escape the Cycle | Shield and Spear","Perpetuate the Cycle | Miraclist")
		var/purpose_choice = input(H, "Choose your PURPOSE", "WHY YOU WANDER") as anything in nomad_purpose
		switch(purpose_choice)
			if("Escape the Cycle | Shield and Spear")
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_STR, 1)//Total of 6 stats, as 1 STR/SPD counts for 2.
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)//Only adventurer, as of adding, to have expert shields. Wild.
				r_hand = /obj/item/rogueweapon/spear/nomad
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				backr = /obj/item/rogueweapon/shield/iron/nomad
			if("Perpetuate the Cycle | Miraclist")
				var/datum/devotion/C = new /datum/devotion(H, H.patron)
				C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_SPD, 1)//As above, 6 stats total.
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/magic/holy, 3, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				backl = /obj/item/storage/backpack/rogue/satchel
				backr = /obj/item/rogueweapon/scabbard/gwstrap

//Just the nomad clothes.
/obj/item/clothing/cloak/cape/nomad
	color = "#7c6d5c"

/obj/item/clothing/neck/roguetown/coif/padded/nomad
	color = "#7c6d5c"

/obj/item/clothing/suit/roguetown/shirt/undershirt/nomad
	color = "#7c6d5c"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/nomad
	name = "nomad shawl"
	desc = "Thick and protective while remaining light and breezy. A staple of Zybantu nomads. Distinctly Dunewell..."
	color = "#7c6d5c"

/obj/item/clothing/head/roguetown/roguehood/shalal/nomad
	color = "#7c6d5c"

/obj/item/clothing/mask/rogue/ragmask/nomad
	color = "#7c6d5c"
