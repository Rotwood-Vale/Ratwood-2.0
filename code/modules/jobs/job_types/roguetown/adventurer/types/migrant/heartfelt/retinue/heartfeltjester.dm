
/datum/advclass/heartfelt/retinue/jester
	name = "赤心 弄臣"
	tutorial = "你是 赤心 的弄臣，曾在更明亮的年月里为众人带来欢笑，如今却只能徘徊在故乡的灰烬之间。\
	纵使涂彩笑容之下尽是沉重哀伤，你仍踏上前往此地的路，希望凭机敏、魅力与狡黠，在废墟之中再为欢乐留出一席之地。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/jester
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	subclass_social_rank = SOCIAL_RANK_NOBLE
	class_select_category = CLASS_CAT_HFT_COURT
	traits_applied = list(TRAIT_ZJUMP, TRAIT_LEAPER, TRAIT_NUTCRACKER, TRAIT_NOFALLDAMAGE1, TRAIT_HEARTFELT)


// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.

/datum/outfit/job/roguetown/heartfelt/retinue/jester/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/jester
	pants = /obj/item/clothing/under/roguetown/tights
	armor = /obj/item/clothing/suit/roguetown/shirt/jester
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/rich
	head = /obj/item/clothing/head/roguetown/jester
	neck = /obj/item/clothing/neck/roguetown/coif
	H.adjust_skillrank(/datum/skill/combat/knives, rand(2,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, rand(1,6), TRUE) 
	H.adjust_skillrank(/datum/skill/misc/sneaking, rand(2,6), TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, rand(1,6), TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, rand(2,6), TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, rand(4,6), TRUE) //a showman like no other. you need to be fit to perform.
	H.adjust_skillrank(/datum/skill/misc/music, rand(4,6), TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, rand(1,5), TRUE) // is this a good idea? Probably not, but the idea of a master fighter jester with 20 str is too good to pass on, this can only go well
	H.adjust_skillrank(/datum/skill/combat/wrestling, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, rand(1,4), TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, rand(1,3), TRUE)
	H.STASTR = rand(3, 21) //Slightly better odds for a Heartfelter AKA a migrant
	H.STAWIL = rand(3, 21)
	H.STACON = rand(3, 21)
	H.STAINT = rand(3, 21)
	H.STAPER = rand(3, 21)
	H.STALUC = rand(3, 21)
	H.cmode_music = 'sound/music/combat_jester.ogg'
	if(H.mind)
		// Mime vs Jester. 
		// As a mute jester you cannot cast Tell Joke/Tragedy, so why even have them?
		if(HAS_TRAIT(H, TRAIT_PERMAMUTE)) // I considered adding a check for Xylix patron but in the off chance there's a mute non-xylix jester I don't want to fuck them over.
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair)
		else
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/telljoke)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/telltragedy)
	H.verbs |= /mob/living/carbon/human/proc/ventriloquate
	H.verbs |= /mob/living/carbon/human/proc/ear_trick
	if(!istype(H.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		H.internal_organs_slot[ORGAN_SLOT_TONGUE] = new /obj/item/organ/tongue/wild_tongue
	if(prob(50))
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC) // Jester :3
	else
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC) // Joker >:(
