/datum/migrant_role/czwarteki/lord
	name = "Czwarteki领主"
	greet_text = "你是 Czwarteki Commonwealth 的众多领主之一，无论是为外交、战争，还是仅仅路过以援助旧日盟约。你要率领自己的随员，为 Commonwealth 带来荣耀。"
	advclass_cat_rolls = list(CTAG_CZWAR_LORD = 20)
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman)
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE

/datum/migrant_role/czwarteki/heir
	name = "Czwarteki继承人"
	greet_text = "你是 Czwarteki 领主的继承人，也可能只是其中之一。你的父母带着你踏上这场远行，让你在家园之外的国度积累历练。"
	advclass_cat_rolls = list(CTAG_CZWAR_HEIR = 20)
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman)
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE

/datum/migrant_role/czwarteki/hussar
	name = "Czwarteki翼骑兵"
	greet_text = "你是 Czwarteki 的翼骑兵，立誓效忠于自己的领主。你召集了扈从，随你一同穿越这片土地。"
	advclass_cat_rolls = list(CTAG_CZWAR_HUSSAR = 20)
	outfit = /datum/outfit/job/roguetown/cloak/tabard
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman,/datum/species/tieberian, /datum/species/lizardfolk,/datum/species/anthromorph,/datum/species/dracon, /datum/species/tabaxi)
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE

/datum/migrant_role/czwarteki/hussar/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "翼骑兵罩袍([index])"
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "爵士"
		if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
			honorary = "女爵"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/migrant_role/czwarteki/retainer
	name = "Czwarteki扈从"
	greet_text = "你是翼骑兵的扈从，应召而来。你精于骑术，也负责照料翼骑兵的各种所需。"
	advclass_cat_rolls = list(CTAG_CZWAR_RETAINER = 20)
	outfit = /datum/outfit/job/roguetown/cloak/surcoat
	allowed_races = RACES_NO_CONSTRUCT
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE

/datum/migrant_role/czwarteki/retainer/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/stabard/surcoat))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "扈从罩袍([index])"

/datum/migrant_role/czwarteki/servant
	name = "Czwarteki仆从"
	greet_text = "你是领主的仆从，随同这支随员队伍一同穿越谷地。你唯一的目标，就是确保领主及其继承人在旅途中的安康。"
	advclass_cat_rolls = list(CTAG_CZWAR_SERVANT = 20)
	allowed_races = RACES_NO_CONSTRUCT
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE
