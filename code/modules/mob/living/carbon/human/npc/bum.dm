GLOBAL_LIST_INIT(bum_quotes, world.file2list("strings/rt/bumlines.txt"))
GLOBAL_LIST_INIT(bum_aggro, world.file2list("strings/rt/bumaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/bum
	aggressive=0
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("bums", "station")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	possible_rmb_intents = list()
	wander = FALSE
	var/bum_boss = FALSE//If you ever want a bum boss to spawn without his outfit, for some reason.

//Special types.
/mob/living/carbon/human/species/human/northern/bum/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/human/northern/bum/boss
	aggressive=1
	flee_in_pain = FALSE
	bum_boss = TRUE

/mob/living/carbon/human/species/human/northern/bum/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(target != newtarg)
			say(pick(GLOB.bum_aggro))
			linepoint(target)

/mob/living/carbon/human/species/human/northern/bum/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/human/northern/bum/Initialize(mapload)
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/bum/after_creation()
	..()
	job = "Beggar"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/vagrantnpc)
	if(!bum_boss)
		equipOutfit(new /datum/outfit/job/roguetown/vagrantnpc)
		
/mob/living/carbon/human/species/human/northern/bum/boss/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
	if(bum_boss)
		equipOutfit(new /datum/outfit/job/roguetown/vagrant_boss)

/datum/outfit/job/roguetown/vagrantnpc/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	if(prob(20))
		head = /obj/item/clothing/head/roguetown/knitcap
	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/brown
	if(prob(10))
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	if(prob(33))
		cloak = /obj/item/clothing/cloak/raincloak/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
	if(prob(5))
		r_hand = /obj/item/rogueweapon/mace/woodclub
	else if(prob(5))
		r_hand = /obj/item/rogueweapon/huntingknife/stoneknife
	else if(prob(5))
		r_hand = /obj/item/rogueweapon/woodstaff
	else if(prob(5))
		r_hand = /obj/item/rogueweapon/mace/wsword

	H.STASPD = 6
	H.STACON = 12
	H.STAWIL = 12
	H.STAINT = 1

//The KING
/datum/outfit/job/roguetown/vagrant_boss/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(25))
		head = /obj/item/clothing/head/roguetown/knitcap
	else
		head = /obj/item/clothing/head/roguetown/helmet/leather

	if(prob(50))
		cloak = /obj/item/clothing/cloak/raincloak/brown
	else
		cloak = /obj/item/clothing/cloak/raincloak/furcloak/crafted

	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/leather
	else
		armor = /obj/item/clothing/suit/roguetown/armor/leather/hide

	if(prob(80))
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
	else//Proper gloves!
		gloves = null

	if(prob(80))
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	else//Stole a pair of bracers!
		wrists = /obj/item/clothing/wrists/roguetown/bracers

//Again, roll for weapon. If any.
	if(prob(25))
		r_hand = /obj/item/rogueweapon/mace/spiked
		l_hand = /obj/item/rogueweapon/shield/wood/crafted
	else if(prob(25))
		r_hand = /obj/item/rogueweapon/sword/iron
		l_hand = /obj/item/rogueweapon/shield/wood/crafted

	H.STASTR = 14
	H.STASPD = 8
	H.STACON = 14
	H.STAWIL = 14
	H.STAINT = 1


/mob/living/carbon/human/species/human/northern/bum/npc_idle()
	if(m_intent == MOVE_INTENT_SNEAK)
		return
	if(world.time < next_idle)
		return
	next_idle = world.time + rand(30, 70)
	if((mobility_flags & MOBILITY_MOVE) && isturf(loc) && wander)
		if(prob(20))
			var/turf/T = get_step(loc,pick(GLOB.cardinals))
			if(!istype(T, /turf/open/transparent/openspace))
				Move(T)
		else
			face_atom(get_step(src,pick(GLOB.cardinals)))
	if(!wander && prob(10))
		face_atom(get_step(src,pick(GLOB.cardinals)))
	if(prob(3))
		say(pick(GLOB.bum_quotes))
	if(prob(3))
		emote(pick("laugh","burp","yawn","grumble","mumble","blink_r","clap"))
