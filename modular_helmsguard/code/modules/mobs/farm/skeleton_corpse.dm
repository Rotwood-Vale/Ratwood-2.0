// SKELETONS

//Mob

/mob/living/carbon/human/species/skeleton/dead

/mob/living/carbon/human/species/skeleton/dead/after_creation()
	..()
	death()

/mob/living/carbon/human/species/skeleton/dead/adventurer
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/dead/adventurer

/mob/living/carbon/human/species/skeleton/dead/manatarms
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/dead/manatarms

/mob/living/carbon/human/species/skeleton/dead/knight
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/dead/knight

/mob/living/carbon/human/species/skeleton/dead/noble
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/dead/noble

/mob/living/carbon/human/species/skeleton/dead/peasant
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/dead/peasant

/mob/living/carbon/human/species/skeleton/dead/freitrupp
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/dead/freitrupp


// OUTFIT DEAD ADVENTURER
/datum/outfit/job/roguetown/npc/skeleton/dead/adventurer/pre_equip(mob/living/carbon/human/H)


	shirt = pick(
		/obj/item/clothing/suit/roguetown/shirt/tunic/random,
		/obj/item/clothing/suit/roguetown/shirt/freishirt,
		/obj/item/clothing/suit/roguetown/shirt/rags,
		/obj/item/clothing/suit/roguetown/shirt/shortshirt/random,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/random,
		/obj/item/clothing/suit/roguetown/armor/gambeson,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
		)

	pants = pick(
		/obj/item/clothing/under/roguetown/trou/leather,
		/obj/item/clothing/under/roguetown/chainlegs/iron,
		/obj/item/clothing/under/roguetown/chainlegs,
		/obj/item/clothing/under/roguetown/tights/random,
		/obj/item/clothing/under/roguetown/tights/vagrant,
		/obj/item/clothing/under/roguetown/heavy_leather_pants,
		/obj/item/clothing/under/roguetown/heavy_leather_pants/deerskinpants,
		/obj/item/clothing/under/roguetown/trou/shadowpants,
		/obj/item/clothing/under/roguetown/trou/beltpants,
		/obj/item/clothing/under/roguetown/trou/padleatherpants,
		/obj/item/clothing/under/roguetown/splintlegs,
		/obj/item/clothing/under/roguetown/brayette,
		/obj/item/clothing/under/roguetown/freipants,
		/obj/item/clothing/under/roguetown/trou/leather/nordman,
		)

	armor = pick(
		/obj/item/clothing/suit/roguetown/armor/leather/cuirass,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
		/obj/item/clothing/suit/roguetown/armor/chainmail,
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron,
		/obj/item/clothing/suit/roguetown/armor/plate/half/iron,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk,
		/obj/item/clothing/suit/roguetown/armor/plate/half,
		/obj/item/clothing/suit/roguetown/armor/brigandine/light,
		/obj/item/clothing/suit/roguetown/armor/leather/hide,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket,
		/obj/item/clothing/suit/roguetown/armor/leather/vest,
		/obj/item/clothing/suit/roguetown/armor/plate/scale,
		/obj/item/clothing/suit/roguetown/armor/armordress,
		/obj/item/clothing/suit/roguetown/armor/armordress/alt,
		/obj/item/clothing/suit/roguetown/armor/leather,
		/obj/item/clothing/suit/roguetown/armor/leather/studded,
		)

	if(prob(70))
		head = pick(
			/obj/item/clothing/head/roguetown/helmet/kettle,
			/obj/item/clothing/head/roguetown/helmet/leather,
			/obj/item/clothing/head/roguetown/helmet/horned,
			/obj/item/clothing/head/roguetown/helmet/skullcap,
			/obj/item/clothing/head/roguetown/helmet/winged,
			/obj/item/clothing/head/roguetown/antlerhood,
			/obj/item/clothing/head/roguetown/roguehood,
			/obj/item/clothing/head/roguetown/roguehood/shalal,
			/obj/item/clothing/head/roguetown/roguehood/shalal/black,
			/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood,
			/obj/item/clothing/head/roguetown/fisherhat,
			/obj/item/clothing/head/roguetown/paddedcap,
			/obj/item/clothing/head/roguetown/armingcap,
			/obj/item/clothing/head/roguetown/helmet/bascinet/nordman,
			/obj/item/clothing/head/roguetown/helmet/leather/saiga/nordman,
			/obj/item/clothing/head/roguetown/hatfur,
			/obj/item/clothing/head/roguetown/papakha,
			/obj/item/clothing/head/roguetown/helmet/bascinet,
			/obj/item/clothing/head/roguetown/helmet/kettle/wide,
			/obj/item/clothing/head/roguetown/helmet/sallet,
			/obj/item/clothing/head/roguetown/helmet/otavan,
			/obj/item/clothing/head/roguetown/helmet/sallet/visored,
			/obj/item/clothing/head/roguetown/headband,
			/obj/item/clothing/head/roguetown/headband/red,
			/obj/item/clothing/head/roguetown/helmet/leather/advanced,
		)
	if(prob(50))
		cloak = pick(
			/obj/item/clothing/cloak/darkcloak,
			/obj/item/clothing/cloak/stabard/bog,
			/obj/item/clothing/cloak/darkcloak/bear,
			/obj/item/clothing/cloak/darkcloak/bear/light,
			/obj/item/clothing/cloak/raincloak,
			/obj/item/clothing/cloak/raincloak/mortus,
			/obj/item/clothing/cloak/raincloak/furcloak,
			/obj/item/clothing/cloak/raincloak/furcloak/brown,
			/obj/item/clothing/cloak/raincloak/furcloak/purple,
			/obj/item/clothing/cloak/raincloak/furcloak/black,
			/obj/item/clothing/cloak/raincloak/furcloak/red,
			/obj/item/clothing/cloak/raincloak/furcloak/darkgreen,
			/obj/item/clothing/cloak/raincloak/furcloak/woad,
			/obj/item/clothing/cloak/cape/fur,
			/obj/item/clothing/cloak/black_cloak,
			/obj/item/clothing/cloak/heartfelt,
			/obj/item/clothing/cloak/tabard/random,
			/obj/item/clothing/cloak/stabard/random,
			/obj/item/clothing/cloak/stabard/surcoat/random,
		)
	if(prob(60))
		neck = pick(/obj/item/clothing/neck/roguetown/gorget,
		/obj/item/clothing/neck/roguetown/chaincoif/iron,
		/obj/item/clothing/neck/roguetown/leather,
		/obj/item/clothing/neck/roguetown/coif,
		/obj/item/clothing/neck/roguetown/fencerguard,
		/obj/item/clothing/neck/roguetown/psicross,
		/obj/item/clothing/neck/roguetown/shalal,
		/obj/item/clothing/neck/roguetown/ornateamulet,
		)



	if(prob(70))
		gloves = pick(
			/obj/item/clothing/gloves/roguetown/leather,
			/obj/item/clothing/gloves/roguetown/deerskin,
			/obj/item/clothing/gloves/roguetown/freigloves,
			/obj/item/clothing/gloves/roguetown/angle/nordman,
			/obj/item/clothing/gloves/roguetown/plate/nordman,
			/obj/item/clothing/gloves/roguetown/angle,
			/obj/item/clothing/gloves/roguetown/chain,
			/obj/item/clothing/gloves/roguetown/chain/iron,
		)
	if(prob(70))
		wrists = pick(
		/obj/item/clothing/wrists/roguetown/bracers/leather,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/wrists/roguetown/splintarms,
		)

	shoes = pick(
		/obj/item/clothing/shoes/roguetown/boots/leather,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron,
		/obj/item/clothing/shoes/roguetown/boots/armor,
		/obj/item/clothing/shoes/roguetown/shalal,
		/obj/item/clothing/shoes/roguetown/boots/deerskin,
		/obj/item/clothing/shoes/roguetown/freiboots,
		/obj/item/clothing/shoes/roguetown/boots/leather/nordman,
		/obj/item/clothing/shoes/roguetown/boots,
	)
	if(prob(70))
		belt = pick(/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/belt/rogue/leather/shalal,
		/obj/item/storage/belt/rogue/leather/black,
		/obj/item/storage/belt/rogue/leather/steel,
		/obj/item/storage/belt/rogue/leather/plaquesilver,
		/obj/item/storage/belt/rogue/leather/rope,
		/obj/item/storage/belt/rogue/leather/cloth,
		/obj/item/storage/belt/rogue/leather/cloth/bandit,
		/obj/item/storage/belt/rogue/leather/knifebelt,
		)
	if(prob(70))
		belt = pick(/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/belt/rogue/leather/black,
		/obj/item/storage/belt/rogue/leather/knifebelt,
		)
		if((belt)&& prob(60))
			beltr = pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/storage/belt/rogue/pouch/coins/mid,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/flint,
			/obj/item/needle,
			/obj/item/bomb,
			/obj/item/bomb/smoke,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			/obj/item/flashlight/flare/torch,
			)
			beltl =  pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/storage/belt/rogue/pouch/coins/mid,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/flint,
			/obj/item/needle,
			/obj/item/bomb,
			/obj/item/bomb/smoke,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			/obj/item/flashlight/flare/torch,
			)


// OUTFIT DEAD SOLDIER
/datum/outfit/job/roguetown/npc/skeleton/dead/manatarms/pre_equip(mob/living/carbon/human/H)


	shirt = pick(
		/obj/item/clothing/suit/roguetown/shirt/tunic/random,
		/obj/item/clothing/suit/roguetown/shirt/shortshirt/random,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/random,
		/obj/item/clothing/suit/roguetown/armor/gambeson,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
		)

	pants = pick(
		/obj/item/clothing/under/roguetown/trou/leather,
		/obj/item/clothing/under/roguetown/chainlegs/iron,
		/obj/item/clothing/under/roguetown/chainlegs,
		/obj/item/clothing/under/roguetown/tights/random,
		/obj/item/clothing/under/roguetown/heavy_leather_pants,
		/obj/item/clothing/under/roguetown/trou/padleatherpants,
		/obj/item/clothing/under/roguetown/splintlegs,
		/obj/item/clothing/under/roguetown/chainlegs/skirt,
		/obj/item/clothing/under/roguetown/platelegs/skirt,
		)

	armor = pick(
		/obj/item/clothing/suit/roguetown/armor/leather/cuirass,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
		/obj/item/clothing/suit/roguetown/armor/chainmail,
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron,
		/obj/item/clothing/suit/roguetown/armor/plate/half/iron,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk,
		/obj/item/clothing/suit/roguetown/armor/plate/half,
		/obj/item/clothing/suit/roguetown/armor/brigandine/light,
		/obj/item/clothing/suit/roguetown/armor/leather/hide,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket,
		/obj/item/clothing/suit/roguetown/armor/plate/scale,
		/obj/item/clothing/suit/roguetown/armor/leather,
		/obj/item/clothing/suit/roguetown/armor/leather/studded,
		)

	if(prob(70))
		head = pick(
			/obj/item/clothing/head/roguetown/helmet/leather/advanced,
			/obj/item/clothing/head/roguetown/helmet/kettle,
			/obj/item/clothing/head/roguetown/helmet/leather,
			/obj/item/clothing/head/roguetown/helmet/horned,
			/obj/item/clothing/head/roguetown/helmet/skullcap,
			/obj/item/clothing/head/roguetown/helmet/kettle/wide,
			/obj/item/clothing/head/roguetown/helmet/sallet,
			/obj/item/clothing/head/roguetown/helmet/sallet/visored,
		)
	cloak = pick(
			/obj/item/clothing/cloak/stabard/bog,
			/obj/item/clothing/cloak/tabard/random,
			/obj/item/clothing/cloak/stabard/random,
			/obj/item/clothing/cloak/stabard/guard,
			/obj/item/clothing/cloak/stabard/surcoat/random,
			/obj/item/clothing/cloak/stabard/surcoat/guard,
			/obj/item/clothing/cloak/stabard/guard,
			/obj/item/clothing/cloak/tabard/crusader,
			/obj/item/clothing/cloak/tabard/hospitaler,
		)
	if(prob(80))
		neck = pick(
		/obj/item/clothing/neck/roguetown/gorget,
		/obj/item/clothing/neck/roguetown/chaincoif/iron,
		/obj/item/clothing/neck/roguetown/leather,
		/obj/item/clothing/neck/roguetown/coif,
		/obj/item/clothing/neck/roguetown/psicross,
		)

	if(prob(70))
		gloves = pick(
			/obj/item/clothing/gloves/roguetown/leather,
			/obj/item/clothing/gloves/roguetown/angle,
			/obj/item/clothing/gloves/roguetown/chain,
			/obj/item/clothing/gloves/roguetown/chain/iron,
		)
	if(prob(70))
		wrists = pick(
		/obj/item/clothing/wrists/roguetown/bracers/leather,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/wrists/roguetown/splintarms,
		)

	shoes = pick(
		/obj/item/clothing/shoes/roguetown/boots/leather,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron,
		/obj/item/clothing/shoes/roguetown/boots/armor,
		/obj/item/clothing/shoes/roguetown/boots/leather/nordman,
		/obj/item/clothing/shoes/roguetown/boots,
			)
	if(prob(70))
		belt = pick(/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/belt/rogue/leather/black,
		/obj/item/storage/belt/rogue/leather/knifebelt,
		)
		if((belt)&& prob(60))
			beltr = pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/storage/belt/rogue/pouch/coins/mid,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/flint,
			/obj/item/needle,
			/obj/item/bomb,
			/obj/item/bomb/smoke,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			/obj/item/flashlight/flare/torch,
			)
			beltl =  pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/storage/belt/rogue/pouch/coins/mid,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/flint,
			/obj/item/needle,
			/obj/item/bomb,
			/obj/item/bomb/smoke,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			/obj/item/flashlight/flare/torch,
			)




// OUTFIT KNIGHT

/datum/outfit/job/roguetown/npc/skeleton/dead/knight/pre_equip(mob/living/carbon/human/H)

	if(prob(80))
		head = pick(/obj/item/clothing/head/roguetown/helmet/heavy/guard,
					/obj/item/clothing/head/roguetown/helmet/heavy/knight,
					/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
					/obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
					/obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
					/obj/item/clothing/head/roguetown/helmet/heavy/bucket,
					/obj/item/clothing/head/roguetown/helmet/sallet/visored,
					/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
					/obj/item/clothing/head/roguetown/helmet/bascinet/klappvisier,
					)
	armor = pick(
				/obj/item/clothing/suit/roguetown/armor/brigandine,
				/obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
				/obj/item/clothing/suit/roguetown/armor/plate/half,
				/obj/item/clothing/suit/roguetown/armor/plate/full,
				)
	if(prob(40))
		pants =	/obj/item/clothing/under/roguetown/platelegs
	else
		pants = pick(
				/obj/item/clothing/under/roguetown/chainlegs/iron,
				/obj/item/clothing/under/roguetown/chainlegs,
				/obj/item/clothing/under/roguetown/trou/padleatherpants,
				/obj/item/clothing/under/roguetown/splintlegs,
				/obj/item/clothing/under/roguetown/chainlegs/skirt,
				/obj/item/clothing/under/roguetown/platelegs/skirt,
				)
	cloak = pick(
		/obj/item/clothing/cloak/stabard/surcoat/guard,
		/obj/item/clothing/cloak/tabard/hospitaler,
		/obj/item/clothing/cloak/tabard/crusader,
		/obj/item/clothing/cloak/cape/knight,
		/obj/item/clothing/cloak/tabard/knight/guard,
	)
	if(prob(80))
		gloves = pick(
			/obj/item/clothing/gloves/roguetown/plate,
			/obj/item/clothing/gloves/roguetown/chain,
			/obj/item/clothing/gloves/roguetown/chain/iron,
					)
	shoes = pick(
	/obj/item/clothing/shoes/roguetown/boots/armor/iron,
	/obj/item/clothing/shoes/roguetown/boots/armor,
	/obj/item/clothing/shoes/roguetown/boots,
	)
	if(prob(70))
		belt = pick(/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/belt/rogue/leather/black,
		/obj/item/storage/belt/rogue/leather/knifebelt,
		)
		if((belt)&& prob(60))
			beltr = pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/storage/belt/rogue/pouch/coins/mid,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/flint,
			/obj/item/needle,
			/obj/item/bomb,
			/obj/item/bomb/smoke,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			)
			beltl =  pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/storage/belt/rogue/pouch/coins/mid,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/flint,
			/obj/item/needle,
			/obj/item/bomb,
			/obj/item/bomb/smoke,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			)


/datum/outfit/job/roguetown/npc/skeleton/dead/noble/pre_equip(mob/living/carbon/human/H)

	if(H.gender == MALE)
		if(prob(60))
			head = pick(
				/obj/item/clothing/head/roguetown/fancyhat,
				/obj/item/clothing/head/roguetown/chaperon/councillor,
				/obj/item/clothing/head/roguetown/papakha,
				/obj/item/clothing/head/roguetown/smokingcap,
				/obj/item/clothing/head/roguetown/bardhat,
				/obj/item/clothing/head/roguetown/puritan,
			)
		
		pants = pick(
			/obj/item/clothing/under/roguetown/trou,
			/obj/item/clothing/under/roguetown/tights/random,
		)
		shirt = pick(
			/obj/item/clothing/suit/roguetown/shirt/tunic/random,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random,
			/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic,
			/obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan,
		)
	else
		if(prob(60))
			head = pick(
				/obj/item/clothing/head/roguetown/hennin,
				/obj/item/clothing/head/roguetown/fancyhat,
				/obj/item/clothing/head/roguetown/chaperon/councillor,
				/obj/item/clothing/head/roguetown/papakha,
			)
		
		pants =	/obj/item/clothing/under/roguetown/tights/stockings/random
		shirt = pick(
				/obj/item/clothing/suit/roguetown/shirt/dress/silkydress,
				/obj/item/clothing/suit/roguetown/shirt/dress/gown,
				/obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown,
				/obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown,
				/obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown,
				/obj/item/clothing/suit/roguetown/shirt/dress/gen/random,
				/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/random,
				/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress,
				)


	shoes = pick(
		/obj/item/clothing/shoes/roguetown/boots/leather,
		/obj/item/clothing/shoes/roguetown/shalal,
		/obj/item/clothing/shoes/roguetown/boots/deerskin,
		/obj/item/clothing/shoes/roguetown/freiboots,
		/obj/item/clothing/shoes/roguetown/boots,
		/obj/item/clothing/shoes/roguetown/boots/nobleboot,
		/obj/item/clothing/shoes/roguetown/ridingboots,
	)

	if(prob(70))
		cloak = pick(
		/obj/item/clothing/cloak/half/random,
		/obj/item/clothing/cloak/heartfelt,
		/obj/item/clothing/cloak/stole/red,
		/obj/item/clothing/cloak/black_cloak,
		/obj/item/clothing/cloak/stole/purple,
		/obj/item/clothing/cloak/cape/random,
		)
	if(prob(70))
		belt = pick(
		/obj/item/storage/belt/rogue/leather,
		/obj/item/storage/belt/rogue/leather/shalal,
		/obj/item/storage/belt/rogue/leather/black,
		/obj/item/storage/belt/rogue/leather/plaquesilver,
		/obj/item/storage/belt/rogue/leather/cloth,
		)
		if((belt)&& prob(60))
			beltr = pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			)
			beltl =  pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			)



// OUTFIT DEAD PEASANT
/datum/outfit/job/roguetown/npc/skeleton/dead/peasant/pre_equip(mob/living/carbon/human/H)

	if(H.gender == MALE)
		head = pick(
			/obj/item/clothing/head/roguetown/roguehood,
			/obj/item/clothing/head/roguetown/fisherhat,
			/obj/item/clothing/head/roguetown/armingcap,
			/obj/item/clothing/head/roguetown/hatfur,
			/obj/item/clothing/head/roguetown/papakha,
			/obj/item/clothing/head/roguetown/headband,
			)
		pants = pick(
			/obj/item/clothing/under/roguetown/trou/leather,
			/obj/item/clothing/under/roguetown/tights/random,
			/obj/item/clothing/under/roguetown/tights/vagrant,
			)
	else
		head = pick(
			/obj/item/clothing/head/roguetown/armingcap,
			/obj/item/clothing/head/roguetown/shawl,
			/obj/item/clothing/head/roguetown/hatfur,
			)
		
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random

	shirt = pick(
		/obj/item/clothing/suit/roguetown/shirt/rags,
		/obj/item/clothing/suit/roguetown/shirt/shortshirt/random,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/random,
		)

	if(prob(70))
		neck = /obj/item/clothing/neck/roguetown/psicross

	shoes = pick(
		/obj/item/clothing/shoes/roguetown/shalal,
		/obj/item/clothing/shoes/roguetown/boots/deerskin,
		/obj/item/clothing/shoes/roguetown/boots,
		/obj/item/clothing/shoes/roguetown/shortboots,
		/obj/item/clothing/shoes/roguetown/simpleshoes,
			)
	if(prob(70))
		belt =	/obj/item/storage/belt/rogue/leather/rope
		if((belt)&& prob(60))
			beltr = pick(
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/flint,
			/obj/item/needle,
			)
			beltl =  pick(
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/flint,
			/obj/item/needle,
			)



// OUTFIT DEAD FREITRUPP
/datum/outfit/job/roguetown/npc/skeleton/dead/freitrupp/pre_equip(mob/living/carbon/human/H)

	wrists = /obj/item/clothing/wrists/roguetown/bracers
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/shirt/freishirt
	head = /obj/item/clothing/head/roguetown/freihat
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate
	pants = /obj/item/clothing/under/roguetown/freipants
	shoes = /obj/item/clothing/shoes/roguetown/freiboots
	gloves = /obj/item/clothing/gloves/roguetown/freigloves
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/gwstrap
	belt = /obj/item/storage/belt/rogue/leather
	if(belt && prob(60))
		beltr = pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/storage/belt/rogue/pouch/coins/mid,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/flint,
			/obj/item/needle,
			/obj/item/bomb,
			/obj/item/bomb/smoke,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			/obj/item/flashlight/flare/torch,)
		beltl =  pick(
			/obj/item/storage/belt/rogue/pouch/coins/rich,
			/obj/item/storage/belt/rogue/pouch/coins/mid,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/huntingknife/idagger,
			/obj/item/rogueweapon/huntingknife/idagger/steel,
			/obj/item/flint,
			/obj/item/needle,
			/obj/item/bomb,
			/obj/item/bomb/smoke,
			/obj/item/clothing/mask/cigarette/rollie/nicotine,
			/obj/item/clothing/mask/cigarette/rollie/cannabis,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
			/obj/item/flashlight/flare/torch,)


	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC);
	H.grant_language(/datum/language/grenzelhoftian)
