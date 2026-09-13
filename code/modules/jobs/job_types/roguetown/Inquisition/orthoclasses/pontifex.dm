/datum/advclass/pontifex
    name = "Pontifex"
    tutorial = "You are a Naledi Pontifex, magick, blood and sand is wrapped between your fingertips. Otava's Inquisition admires your faith and Will, even if they don't fully understand you, For your land fell before your order ever did. The time to ENDURE has come to pass, it is time you AVENGE what was done to Him and your Land. Utilize the art of MOMENTUM, motion in every strike, to slowly but surely overwhelm your opponent. The Heretic will seek to lay waste to the legacy of PSYDON and Naledi, but you've known this all your LYFE, so raise your fist and channel your spells, AVENGER, the time of reckoning, is at hand."
    outfit = /datum/outfit/job/roguetown/mercenary/warscholar_pontifex
    subclass_languages = list(/datum/language/celestial, /datum/language/otavan)
    category_tags = list(CTAG_INQUISITION)
    traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_CIVILIZEDBARBARIAN, TRAIT_ARCYNE_T1, TRAIT_NALEDI)
    subclass_stats = list(
        STATKEY_STR = 2,
        STATKEY_WIL = 3,
		STATKEY_SPD = 2,
        STATKEY_CON = -2
    )
    subclass_skills = list(
        /datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, // THEY ARE NOT GRAPPLERS
        /datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
        /datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
        /datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
        /datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
        /datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
        /datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
        /datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
        /datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
        /datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
        /datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
    )
    subclass_spellpoints = 0
    subclass_stashed_items = list(
        "Tome of Psydon" = /obj/item/book/rogue/bibble/psy
    )

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex
    var/detailcolor
    job_bitflag = BITFLAG_HOLY_WARRIOR
    allowed_patrons = list(/datum/patron/old_god)
    
    head = /obj/item/clothing/head/roguetown/roguehood/pontifex
    gloves = /obj/item/clothing/gloves/roguetown/angle/pontifex
    armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
    shirt = /obj/item/clothing/suit/roguetown/shirt/robe/pointfex
    pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex
    mask = /obj/item/clothing/mask/rogue/lordmask/naledi
    wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
    belt = /obj/item/storage/belt/rogue/leather/black
    beltl = /obj/item/flashlight/flare/torch
    shoes = /obj/item/clothing/shoes/roguetown/sandals
    backr = /obj/item/storage/backpack/rogue/satchel/black
    id = /obj/item/clothing/ring/signet/silver
    
    backpack_contents = list(
        /obj/item/lockpick = 1,
        /obj/item/roguekey/inquisition = 1,
        /obj/item/paper/inqslip/arrival/ortho = 1,
        /obj/item/storage/belt/rogue/pouch/coins/mid = 1
    )

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex/pre_equip(mob/living/carbon/human/H)
    ..()
    var/devotion_gain = CLERIC_REGEN_WEAK
    var/devotion_limit = CLERIC_REQ_1

    var/list/naledicolors = sortList(list(
        "GOLD" = "#C8BE6D",
        "PALE PURPLE" = "#9E93FF",
        "BLUE" = "#A7B4F6",
        "BRICK BROWN" = "#773626",
        "PURPLE" = "#B542AC",
        "GREEN" = "#62a85f",
        "BLUE" = "#A9BFE0",
        "RED" = "#ED6762",
        "ORANGE" = "#EDAF6D",
        "PINK" = "#EDC1D5",
        "MAROON" = "#5F1F34",
        "BLACK" = "#242526"
    ))

    var/datum/devotion/C = new /datum/devotion(H, H.patron)
    C.grant_miracles(
        H,
        cleric_tier = CLERIC_T2,
        passive_gain = devotion_gain,
        devotion_limit = devotion_limit,
    )

    if(H.mind)
        detailcolor = input("Choose a color.", "NALEDIAN COLORPLEX") as anything in naledicolors
        detailcolor = naledicolors[detailcolor]
        H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/bladeofpsydon)
        H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadowstep)
        H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/spellfist/fist_of_psydon)
        H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/spellfist/grasp_of_psydon)
        H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/spellfist/storm_of_psydon)
        H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)
        H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/create_campfire)
        H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)
        H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
        
        var/weapons = list("Path of War","Path of Control","Path of Shadows","Path of Survival")
        var/weapon_choice = input(H, "Choose your path.", "WHAT PATH DO YOU WALK?") as anything in weapons
        switch(weapon_choice)
            if("Path of War")
                H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/airblade)
                H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
            if("Path of Control")
                H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/counterspell)
                H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
            if("Path of Shadows")
                H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/lesserknock)
                H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/invisibility)
                H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blindness/warscholar)
            if("Path of Survival")
                H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 4, TRUE)
                H.adjust_skillrank_up_to(/datum/skill/craft/cooking, 3, TRUE)
                H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)
                H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 5, TRUE)
                H.adjust_skillrank_up_to(/datum/skill/misc/swimming, 3, TRUE)
                H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)


