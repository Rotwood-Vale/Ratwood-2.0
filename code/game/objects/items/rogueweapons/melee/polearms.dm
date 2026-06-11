//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/spear/thrust
	name = "突刺"
	blade_class = BCLASS_STAB
	attack_verb = list("突刺")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	clickcd = CLICK_CD_CHARGED
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 50
	item_d_type = "stab"
	effective_range = 2
	effective_range_type = EFF_RANGE_EXACT

/datum/intent/spear/thrust/oneh
	name = "单手突刺"
	reach = 1
	swingdelay = 4
	penfactor = 45
	clickcd = CLICK_CD_RESIST
	effective_range = null
	effective_range_type = EFF_RANGE_NONE
	sharpness_penalty = 3

/datum/intent/spear/thrust/militia
	penfactor = 40

/datum/intent/spear/thrust/blunted
	penfactor = BLUNT_DEFAULT_PENFACTOR
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/spear/bash
	name = "猛砸"
	blade_class = BCLASS_BLUNT
	penfactor = BLUNT_DEFAULT_PENFACTOR
	icon_state = "inbash"
	attack_verb = list("猛砸", "打击")
	damfactor = NONBLUNT_BLUNT_DAMFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

// Eaglebeak has a decent bash with range
/datum/intent/spear/bash/eaglebeak
	name = "鹰喙猛砸"
	damfactor = 1
	reach = 2
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_STRONG

/datum/intent/spear/bash/ranged
	reach = 2

/datum/intent/spear/cut
	name = "劈斩"
	blade_class = BCLASS_CUT
	attack_verb = list("切开", "挥斩")
	icon_state = "incut"
	damfactor = 0.8
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	reach = 2
	item_d_type = "slash"

/datum/intent/spear/cut/oneh
	name = "单手劈斩"
	reach = 1
	swingdelay = 4
	sharpness_penalty = 2

/datum/intent/spear/cut/halberd
	damfactor = 1.2

/datum/intent/spear/cut/scythe
	reach = 3
	damfactor = 1
	effective_range = 2
	effective_range_type = EFF_RANGE_ABOVE

/datum/intent/spear/cut/bardiche
	damfactor = 1.2
	chargetime = 0

/datum/intent/spear/cut/glaive
	damfactor = 1.2
	chargetime = 0

/datum/intent/spear/cast
	name = "投掷"
	chargetime = 0
	noaa = TRUE
	misscost = 0
	icon_state = "inuse"
	no_attack = TRUE

/datum/intent/spear/cut/naginata
	damfactor = 1.2
	chargetime = 0

/datum/intent/sword/cut/zwei
	reach = 2

/datum/intent/sword/thrust/zwei
	reach = 2

/datum/intent/sword/thrust/estoc
	name = "突刺"
	penfactor = 57	//At 57 pen + 25 base (82 total), you will always pen 80 stab armor, but you can't do it at range unlike a spear.
	clickcd = CLICK_CD_CHARGED

/datum/intent/sword/lunge
	name = "突进"
	icon_state = "inimpale"
	attack_verb = list("突进")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	reach = 2
	damfactor = 1.3	//Zwei will still deal ~7-10 more damage at the same range, depending on user's STR.
	swingdelay = 8
	effective_range = 2
	effective_range_type = EFF_RANGE_EXACT

/datum/intent/sword/lunge/estoc
	damfactor = 1.2
	penfactor = 37//25 base, +5, at 67. More for applying bleed through armour, since it's a needle.
	swingdelay = 0
	clickcd = CLICK_CD_CHARGED

/datum/intent/sword/bash
	name = "十字护手砸击"
	blade_class = BCLASS_BLUNT
	icon_state = "inbash"
	attack_verb = list("猛砸", "打击")
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = 1.1
	clickcd = 15
	swingdelay = 2
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_MINUSCULE

/datum/intent/rend
	name = "撕裂"
	icon_state = "inrend"
	attack_verb = list("撕裂")
	animname = "cut"
	blade_class = BCLASS_CHOP
	reach = 1
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = 2.5
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_d_type = "slash"
	misscost = 10
	intent_intdamage_factor = 0.25
	sharpness_penalty = 2

/datum/intent/rend/reach
	name = "长距撕裂"
	penfactor = BLUNT_DEFAULT_PENFACTOR
	misscost = 5
	clickcd = CLICK_CD_HEAVY
	damfactor = 2
	reach = 2
	effective_range = 2
	effective_range_type = EFF_RANGE_EXACT

/datum/intent/rend/reach/partizan
	name = "撕裂突刺"
	attack_verb = list("刺穿")
	blade_class = BCLASS_STAB
	damfactor = 1.8//It's a heavy stab. Not a chop.
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	item_d_type = "stab"
	intent_intdamage_factor = 0.1//You're not chopping, unlike a standard rend.

/datum/intent/partizan/peel
	name = "剥甲"
	icon_state = "inpeel"
	attack_verb = list("<font color ='#e7e7e7'>剥甲</font>")
	animname = "cut"
	blade_class = BCLASS_PEEL
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	clickcd = CLICK_CD_CHARGED
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 0
	damfactor = 0.01
	item_d_type = "slash"
	peel_divisor = 4
	reach = 2

//Old partizan peel, for the naginata.
/datum/intent/partizan/peel/nag
	attack_verb = list("<font color ='#e7e7e7'>轻剥甲</font>")
	swingdelay = 5
	peel_divisor = 5

/datum/intent/spear/bash/ranged/quarterstaff
	damfactor = 1
	//We want chipping, m'lord.
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_WEAK//Use this instead of thrust for chip damage.

/datum/intent/spear/thrust/quarterstaff
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = 1.3 // Adds up to be slightly stronger than an unenhanced ebeak strike.
	clickcd = CLICK_CD_CHARGED
	//We want chipping, m'lord.
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_MINUSCULE//See above.

/datum/intent/spear/thrust/lance
	damfactor = 1.5 // Turns its base damage into 30 on the 2hand thrust. It keeps the spear thrust one handed.

/datum/intent/lance
	name = "骑枪冲刺"
	icon_state = "inlance"
	attack_verb = list("骑枪冲刺", "贯穿", "刺穿")
	animname = "stab"
	item_d_type = "stab"
	penfactor = BLUNT_DEFAULT_PENFACTOR // Not a mistake, to prevent it from nuking through armor.
	chargetime = 4 SECONDS
	damfactor = 4 // 80 damage on hit. It is gonna hurt.
	reach = 3 // Yep! 3 tiles
	effective_range = 2
	effective_range_type = EFF_RANGE_ABOVE

/datum/intent/lance/onehand
	chargetime = 5 SECONDS

//polearm objs ฅ^•ﻌ•^ฅ

/obj/item/rogueweapon/woodstaff
	force = 10
	force_wielded = 15
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(SPEAR_BASH,/datum/intent/mace/smash/wood)
	name = "木杖"
	desc = "一根结实可靠的手杖，能让人轻松穿越崎岖地形、减轻伤腿负担，或稳稳挡开来袭打击。很适合乞丐、朝圣者和法师。"
	icon_state = "woodstaff"
	icon = 'icons/roguetown/weapons/64.dmi'
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	sharpness = IS_BLUNT
	walking_stick = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wdefense = 5
	wdefense_wbonus = 8	//13 when wielded.
	bigboy = TRUE
	gripsprite = TRUE
	associated_skill = /datum/skill/combat/polearms
	anvilrepair = /datum/skill/craft/carpentry
	resistance_flags = FLAMMABLE

// Allows blind carbons to examine if they click on an object using a wooden staff
/obj/item/rogueweapon/woodstaff/pre_attack(atom/A, mob/living/user, params)
	if(HAS_TRAIT(user, TRAIT_BLIND) && !user.cmode) //if is not used by a blind mob in combat mode it won't examine
		var/list/exam = A.examine(user) //directly extracts the examine string without using the examinate proc
		if(A != user) // avoids the message of user poking themselves
			src.visible_message(span_notice("[user]用[user.p_their()]木杖轻轻探了探[A]。"))
		if(exam)
			to_chat(user, exam.Join("\n"))//relays the examine string to the user
		return TRUE

/obj/item/rogueweapon/woodstaff/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/woodstaff/wise
	name = "智者法杖"
	desc = "一根用来驱赶荒狼的法杖……"

/obj/item/rogueweapon/woodstaff/aries
	name = "牧者权杖"
	desc = "这根法杖会让任何农夫都觉得你是个大人物。"
	force = 25
	force_wielded = 28
	icon_state = "aries"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	pixel_y = 0
	pixel_x = 0
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = FALSE
	gripsprite = FALSE
	gripped_intents = null

/obj/item/rogueweapon/woodstaff/aries/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/rogueweapon/spear
	force = 20
	force_wielded = 30
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_CUT_1H)
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, SPEAR_BASH)
	name = "长矛"
	desc = "这是至今仍在使用的最古老武器之一，仅次于棍棒。由于矛杆缺乏加固，它很容易被硬生生劈断。"
	icon_state = "spear"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_blade_int = 180
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 5
	thrown_bclass = BCLASS_STAB
	throwforce = 25
	resistance_flags = FLAMMABLE
	special = /datum/special_intent/polearm_backstep

/obj/item/rogueweapon/spear/ancient
	name = "远古长矛"
	desc = "一根扭曲虬结的长杆，顶端镶着打磨光亮的 gilbranze。你的呼吸一滞，指节也不自觉攥紧了矛杆；你仿佛窥见了尚未来临之事，却又无法将其留在脑海。若真知晓这个垂死世界的命运，任何人都会为之发狂。"
	icon_state = "ancient_spear"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/spear/ancient/decrepit
	name = "朽败长矛"
	desc = "一根腐朽的长杆，末端装着磨损开裂的青铜矛头。它诞生于石器之后、剑刃之前，是那场即将吞没祂之世界的暴力序章。"
	force = 13
	force_wielded = 22
	max_integrity = 120
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/spear/trident
	// Better one handed & throwing weapon, flimsier.
	name = "青铜三叉戟"
	desc = "一柄来自海上的青铜三叉戟，带钩的尖齿正是为了刺穿游鱼而造。握在手里重心平衡，仿佛随时都能轻松掷出。"
	icon_state = "bronzetri"
	force = 25
	force_wielded = 20
	wdefense = 4
	max_blade_int = 175
	max_integrity = 225
	throwforce = 30
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_BASH, SPEAR_CAST)
	fishingMods=list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1.4,
		"treasureFishingMod" = 0,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 0.9,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
	)

/obj/item/rogueweapon/spear/trident/afterattack(obj/target, mob/user, proximity)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing)
	var/ft = 150
	var/fpp =  130 - (40 + (sl * 15))
	var/frwt = list(/turf/open/water/river, /turf/open/water/cleanshallow, /turf/open/water/pond)
	var/salwt_coast = list(/turf/open/water/ocean)
	var/salwt_deep = list(/turf/open/water/ocean/deep)
	var/mud = list(/turf/open/water/swamp, /turf/open/water/swamp/deep)
	if(istype(target, /turf/open/water))
		if(user.used_intent.type == SPEAR_CAST && !user.doing)
			if(target in range(user,3))
				user.visible_message("<span class='warning'>[user]开始寻找鱼了！</span>", \
									"<span class='notice'>我开始寻找能用叉刺中的鱼。</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 20)
				ft = max(20,ft)
				if(do_after(user,ft, target = target))
					var/fishchance = 100
					if(user.mind)
						if(!sl)
							fishchance -= 50
						else
							fishchance -= fpp
					var/mob/living/fisherman = user
					if(prob(fishchance))
						var/A
						if(target.type in frwt)
							A = pickweightAllowZero(createFreshWaterFishWeightListModlist(fishingMods))
						else if(target.type in salwt_coast)
							A = pickweightAllowZero(createCoastalSeaFishWeightListModlist(fishingMods))
						else if(target.type in salwt_deep)
							A = pickweightAllowZero(createDeepSeaFishWeightListModlist(fishingMods))
						else if(target.type in mud)
							A = pickweightAllowZero(createMudFishWeightListModlist(fishingMods))
						if(A)
							var/ow = 30 + (sl * 10)
							to_chat(user, "<span class='notice'>你看见有什么东西了！</span>")
							playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
							if(!do_after(user,ow, target = target))
								if(ismob(A))
									var/mob/M = A
									if(M.type in subtypesof(/mob/living/simple_animal/hostile))
										new M(target)
									else
										new M(user.loc)
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2)
								else
									new A(user.loc)
									teleport_to_dream(user, 10000, 1)
									to_chat(user, "<span class='warning'>快把它拉上来！</span>")
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE)
									record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
									GLOB.azure_round_stats[STATS_FISH_CAUGHT]++
									playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
							else
								to_chat(user, "<span class='warning'>该死，让它跑了……下次我得记得<b>猛地一拉</b>。</span>")
					else
						to_chat(user, "<span class='warning'>连一条鱼都没有……</span>")
						user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT/2)
				else
					to_chat(user, "<span class='warning'>想叉鱼就得站着别动。</span>")
			update_icon()

/obj/item/rogueweapon/spear/psyspear
	name = "普希顿银矛"
	desc = "一柄装饰华美的长矛，表面覆着用于礼仪的银层。倒钩轻刺你的掌心，而在那一瞬间，你仿佛看见了满目猩红。永远别忘了，普希顿为何而泣。"
	icon_state = "psyspear"
	force = 20
	force_wielded = 30
	minstr = 11
	wdefense = 6
	resistance_flags = FIRE_PROOF	//It's meant to be smacked by a "lamptern", and is special enough to warrant overriding the spear weakness
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/spear/psyspear/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/spear/psyspear/old
	name = "坚忍长矛"
	desc = "一柄华美长矛，表面的银饰已因久置而失去光泽。即便这柄武器不再受祂眷顾，祂仍会引导信徒的手。"
	icon_state = "psyspear"
	force = 15
	force_wielded = 25
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/rogueweapon/spear/psyspear/old/ComponentInitialize()
	return

/obj/item/rogueweapon/spear/silver
	name = "银矛"
	desc = "一根带翼横档的长杆，顶端装着银制矛头。它与“猎猪矛”颇为相似，但关键差别在于，它拦下的不是野猪，而是那些冲锋而来的活尸与它们扩散的恶疾。"
	icon_state = "silverspear"
	force = 15
	force_wielded = 25
	minstr = 11
	wdefense = 6
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/spear/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/spear/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/spear/bonespear
	force = 18
	force_wielded = 22
	name = "骨矛"
	desc = "一柄由骸骨拼成的长矛……"
	icon_state = "bonespear"
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 6
	max_blade_int = 80
	smeltresult = null
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 4
	max_integrity = 60
	throwforce = 20
	special = null

/obj/item/rogueweapon/spear/billhook
	name = "钩镰枪"
	desc = "一把利落的钩刃长杆兵器。它既能把骑手从马背上拽下，也能在严整阵型中用来对抗冲来的战马。杆身上的加固结构让它更不容易被打断。"
	icon_state = "billhook"
	smeltresult = /obj/item/ingot/steel
	max_blade_int = 200
	minstr = 8
	wdefense = 6
	throwforce = 15
	special = null

/obj/item/rogueweapon/spear/improvisedbillhook
	force = 12
	force_wielded = 25
	name = "简制钩镰枪"
	desc = "看起来做得很仓促，甚至有点单薄。"
	icon_state = "billhook"
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 100
	wdefense = 4
	throwforce = 10

/obj/item/rogueweapon/spear/stone
	force = 15
	force_wielded = 18
	name = "石矛"
	desc = "这柄手工长矛虽简陋，却也够用。"
	icon_state = "stonespear"
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	minstr = 6
	max_blade_int = 70
	smeltresult = null
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 4
	max_integrity = 50
	throwforce = 20

// Copper spear, no point to adjust force just slightly better integrity
/obj/item/rogueweapon/spear/stone/copper
	name = "铜矛"
	desc = "一柄装着铜制矛头的简易长矛。比石矛更耐用些，但也强不了太多。"
	pixel_y = 0
	pixel_x = 0
	max_integrity = 100
	icon = 'icons/roguetown/weapons/misc32.dmi'
	dam_icon = 'icons/effects/item_damage32.dmi'
	icon_state = "cspear"
	smeltresult = null

/obj/item/rogueweapon/fishspear
	force = 20
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_BASH, SPEAR_CAST) //bash is for nonlethal takedowns, only targets limbs
	name = "渔叉"
	desc = "这柄带倒刺的双尖长矛就是专门拿来对付那些难缠游鱼的。"
	icon_state = "fishspear"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 4
	thrown_bclass = BCLASS_STAB
	throwforce = 35
	resistance_flags = FLAMMABLE
	fishingMods=list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1.4,
		"treasureFishingMod" = 0,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
	)

/obj/item/rogueweapon/fishspear/depthseek //DO NOT ADD RECIPE. MEANT TO BE AN ABYSSORITE RELIC. IDEA COURTESY OF LORDINQPLAS
	force = 45
	name = "受祝深寻者"
	desc = "一把打造精美的武器，握柄以某种巨兽骨骼雕成，尾端与首部嵌着光滑海玻璃，双叉则由精良的矮人钢锻成。顶端那枚海玻璃雕饰本身就是杰作，你能从中感到深渊般的力量正缓缓外溢。"
	icon_state = "depthseek"
	smeltresult = /obj/item/ingot/blacksteel
	max_blade_int = 2600
	wdefense = 8
	throwforce = 50

/obj/item/rogueweapon/fishspear/attack_self(mob/user)
	if(user.used_intent.type == SPEAR_CAST)
		if(user.doing)
			user.doing = 0

/obj/item/rogueweapon/fishspear/afterattack(obj/target, mob/user, proximity)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing) // User's skill level
	var/ft = 160 //Time to get a catch, in ticks
	var/fpp =  130 - (40 + (sl * 15)) // Fishing power penalty based on fishing skill level
	var/frwt = list(/turf/open/water/river, /turf/open/water/cleanshallow, /turf/open/water/pond)
	var/salwt_coast = list(/turf/open/water/ocean)
	var/salwt_deep = list(/turf/open/water/ocean/deep)
	var/mud = list(/turf/open/water/swamp, /turf/open/water/swamp/deep)
	if(istype(target, /turf/open/water))
		if(user.used_intent.type == SPEAR_CAST && !user.doing)
			if(target in range(user,3))
				user.visible_message("<span class='warning'>[user]开始寻找鱼了！</span>", \
									"<span class='notice'>我开始寻找能用叉刺中的鱼。</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 20) //every skill lvl is -2 seconds
				ft = max(20,ft) //min of 2 seconds
				if(do_after(user,ft, target = target))
					var/fishchance = 100 // Total fishing chance, deductions applied below
					if(user.mind)
						if(!sl) // If we have zero fishing skill...
							fishchance -= 50 // 50% chance to fish base
						else
							fishchance -= fpp // Deduct a penalty the lower our fishing level is (-0 at legendary)
					var/mob/living/fisherman = user
					if(prob(fishchance)) // Finally, roll the dice to see if we fish.
						var/A
						if(target.type in frwt)
							A = pickweightAllowZero(createFreshWaterFishWeightListModlist(fishingMods))
						else if(target.type in salwt_coast)
							A = pickweightAllowZero(createCoastalSeaFishWeightListModlist(fishingMods))
						else if(target.type in salwt_deep)
							A = pickweightAllowZero(createDeepSeaFishWeightListModlist(fishingMods))
						else if(target.type in mud)
							A = pickweightAllowZero(createMudFishWeightListModlist(fishingMods))
						if(A)
							var/ow = 30 + (sl * 10) // Opportunity window, in ticks. Longer means you get more time to cancel your bait
							to_chat(user, "<span class='notice'>你看见有什么东西了！</span>")
							playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
							if(!do_after(user,ow, target = target))
								if(A in subtypesof(/mob/living))
									var/mob/M = A
									new M(target)
									if (!(M.type == /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab))
										user.playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2) // High risk high reward
								else
									new A(user.loc)
									teleport_to_dream(user, 10000, 1)
									to_chat(user, "<span class='warning'>快把它拉上来！</span>")
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE) // Level up!
									record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
									record_round_statistic(STATS_FISH_CAUGHT)
									playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
							else
								to_chat(user, "<span class='warning'>该死，让它跑了……下次我得记得<b>猛地一拉</b>。</span>")
					else
						to_chat(user, "<span class='warning'>连一条鱼都没有……</span>")
						user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT/2) // Pity XP.
				else
					to_chat(user, "<span class='warning'>想叉鱼就得站着别动。</span>")
			update_icon()

/obj/item/rogueweapon/fishspear/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -6,
					"sy" = 7,
					"nx" = 6,
					"ny" = 8,
					"wx" = 0,
					"wy" = 6,
					"ex" = -1,
					"ey" = 8,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -50,
					"sturn" = 40,
					"wturn" = 50,
					"eturn" = -50,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0,
					)
			if("wielded")
				return list(
					"shrink" = 0.6,
					"sx" = 3,
					"sy" = 1,
					"nx" = -3,
					"ny" = 1,
					"wx" = -9,
					"wy" = 1,
					"ex" = 9,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -30,
					"sturn" = 30,
					"wturn" = -30,
					"eturn" = 30,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 8,
					"eflip" = 0,
					)

/obj/item/rogueweapon/halberd
	force = 15
	force_wielded = 30
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_BASH)
	gripped_intents = list(SPEAR_THRUST, /datum/intent/spear/cut/halberd, /datum/intent/sword/chop, SPEAR_BASH)
	name = "戟斧"
	desc = "一柄钢制戟斧，几乎凝聚了长柄近战武器的全部智慧。它唯一的缺点就是昂贵，因此多半只会出现在卫兵手中。杆身加固让它格外耐用。"
	icon_state = "halberd"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 9
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 6
	special = /datum/special_intent/polearm_backstep

/obj/item/rogueweapon/halberd/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/spear/holysee
	name = "圣座长矛"
	desc = "一柄受过祝圣的长矛，由圣座的圣堂武士挥舞，用以将邪恶之力拒于外。它的设计平衡得近乎完美，因此即使搭配盾牌单手使用也十分高效。矛翼仿佛能捕捉最微弱的一缕日光，并将其放大成刺目的辉耀。</br>“我的诸神啊，我不惧邪恶，因为祢与我同在！”"
	icon_state = "gsspear"
	force = 25 // better in one hand. Use it with the shield.
	max_blade_int = 225
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/halberd/bardiche
	possible_item_intents = list(/datum/intent/spear/thrust/eaglebeak/oneh, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/thrust/eaglebeak, /datum/intent/spear/cut/bardiche, /datum/intent/axe/chop, SPEAR_BASH)
	name = "长柄战斧"
	desc = "一种优美的戟斧变体。加固过的长杆让它在对抗打击时更为耐久。"
	icon_state = "bardiche"
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 200

/obj/item/rogueweapon/halberd/bardiche/ancient
	name = "远古长柄战斧"
	desc = "一柄骇人的长柄巨斧，由打磨光亮的吉尔布兰兹锻成。当她升格之时，这些失去主人的兵器一同沉入大地深处。阴影中的手在数个世纪里守护着这些斧刃，最终铸出了它的钢刃后继者：偃月刀。"
	icon_state = "ancient_bardiche"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/halberd/bardiche/ancient/decrepit
	name = "朽败长柄战斧"
	desc = "一柄气势逼人的长柄巨斧，以磨损残旧的青铜铸成。它昔日承载的崇高意义早已腐朽，如今仍存于世，只为劈碎这垂死世界上仍顽固附着的糟粕。"
	force = 12
	force_wielded = 22
	max_integrity = 180
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/halberd/bardiche/scythe
	name = "盛夏镰戟"
	desc = "夏日的繁盛生机流淌在这柄镰戟的刃首之中，也正因此，它更适合播种与收割。"
	icon_state = "dendorscythe"
	gripped_intents = list(/datum/intent/spear/thrust/eaglebeak, /datum/intent/spear/cut/bardiche, /datum/intent/axe/chop/scythe, SPEAR_BASH)
	force_wielded = 33 // +3
	max_integrity = 300 // +50

/obj/item/rogueweapon/halberd/psyhalberd/relic
	name = "圣痕"
	desc = "它在利尔瓦斯围城战中得名。彼时，一支由圣艾欧拉圣骑士组成的孤军手持这些银尖长柄斧，将群魔阻挡了整整四十昼夜。如今这件自废墟中寻回的圣遗物，再次成为无助者的壁垒。"
	icon_state = "psyhalberd"

/obj/item/rogueweapon/halberd/psyhalberd/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/halberd/psyhalberd
	name = "普希顿戟斧"
	desc = "这是一种久经考验的设计，曾协助人类斩倒敌人、守护普希顿的羊群，而今又装上了更长的刃部与一对银尖鹰喙。"
	icon_state = "silverhalberd"
	force = 10//Use the spear instead if you're going to one-hand this.
	minstr = 11
	wdefense = 7
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/halberd/psyhalberd/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/halberd/glaive
	possible_item_intents = list(/datum/intent/spear/thrust/eaglebeak/oneh, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/thrust/glaive, /datum/intent/spear/cut/glaive, /datum/intent/axe/chop/scythe, SPEAR_BASH)
	name = "偃月刀"
	desc = "一柄装在长杆上的弧刃武器，尤其擅长防守，但制造成本不低。"
	icon_state = "glaive"
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	max_blade_int = 160
	wdefense = 9

/obj/item/rogueweapon/halberd/glaive/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/eaglebeak
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/spear/thrust/eaglebeak/oneh)
	gripped_intents = list(/datum/intent/spear/bash/eaglebeak, /datum/intent/mace/smash/eaglebeak, /datum/intent/spear/thrust/eaglebeak)
	name = "鹰喙锤"
	desc = "一根加固长杆，顶端装着华丽的钢制鹰首，而那只鹰喙正是用来狠狠凿穿敌人的。"
	icon_state = "eaglebeak"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 11
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/polearms
	sharpness = IS_BLUNT
	max_blade_int = 0
	walking_stick = TRUE
	wdefense = 5
	wbalance = WBALANCE_HEAVY
	sellprice = 60

/obj/item/rogueweapon/eaglebeak/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/rogueweapon/eaglebeak/lucerne
	name = "卢塞恩锤"
	desc = "一柄朴素的铁制长柄锤。只需纯粹而直接的蛮力，便能粉碎骨头与反抗。杆身上的铆钉让它略微更加结实。"
	force = 12
	force_wielded = 25
	icon_state = "polehammer"
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 150
	sellprice = 40

// A worse thrust for weapons specialized in other damage type like cut or blunt
/datum/intent/spear/thrust/eaglebeak
	penfactor = 20
	damfactor = 0.9

/datum/intent/spear/thrust/eaglebeak/oneh
	name = "单手突刺"
	reach = 1
	swingdelay = 4
	clickcd = CLICK_CD_RESIST
	effective_range = null
	effective_range_type = EFF_RANGE_NONE
	sharpness_penalty = 3

/datum/intent/spear/thrust/glaive
	penfactor = 50
	damfactor = 1.1
	chargetime = 0

/datum/intent/mace/smash/eaglebeak
	reach = 2
	clickcd = CLICK_CD_HEAVY // Slightly longer since it has RANGE. Don't want to increase charge time more since it is unreliable.
	blunt_chip_strength = BLUNT_CHIP_ABSURD

/obj/item/rogueweapon/spear/bronze
	name = "青铜矛"
	desc = "一根古风十足的长杆，顶端饰有青铜矛头。无论设计还是用途都十分古老，它轻盈的重量曾与前文明军团士兵高耸的巨盾相得益彰。如今虽少见于死地之外，但这种轻巧的平衡依旧让它很适合单手突刺与投掷。"
	force = 25
	force_wielded = 28
	throwforce = 30
	icon_state = "bronzespear"
	smeltresult = /obj/item/ingot/bronze
	armor_penetration = 22 //In-between a spear and javelin.
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 33, "embedded_fall_chance" = 2)
	max_blade_int = 225
	max_integrity = 155

/obj/item/rogueweapon/greatsword
	force = 14
	force_wielded = 35
	possible_item_intents = list(/datum/intent/sword/chop,/datum/intent/sword/strike) //bash is for nonlethal takedowns, only targets limbs
	// Design Intent: I have a big fucking sword and I want to rend people in half.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/rend, /datum/intent/sword/thrust/zwei, /datum/intent/sword/strike/bad)
	alt_intents = list(/datum/intent/effect/daze, /datum/intent/sword/strike, /datum/intent/sword/bash)
	name = "大剑"
	desc = "说不定真能把什么东西都一剑劈成两半！"
	icon_state = "gsw"
	parrysound = list(
		'sound/combat/parry/bladed/bladedlarge (1).ogg',
		'sound/combat/parry/bladed/bladedlarge (2).ogg',
		'sound/combat/parry/bladed/bladedlarge (3).ogg',
		)
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 9
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 300
	wdefense = 5
	smelt_bar_num = 3
	special = /datum/special_intent/greatsword_swing

/obj/item/rogueweapon/greatsword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = 4,"sy" = 0,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)

/obj/item/rogueweapon/greatsword/ancient
	name = "远古大剑"
	desc = "一柄由打磨光亮的 gilbranze 锻成的巨刃。你的族类终会在狂怒与毁灭中认清自身本性。你们将踏上群星之路，把它们一颗接一颗燃尽。直到最后一颗星辰也化作尘埃，你才会明白，祂试图将你们从人类最大的敌人手中拯救出来；那便是虚无。"
	icon_state = "ancient_gsw"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/greatsword/ancient/decrepit
	name = "朽败大剑"
	desc = "一柄以残旧青铜铸成的巨刃。它大得已经不能称作剑了；它庞大、厚重、沉猛，而且粗糙得过了头。说到底，这玩意更像是一大块尚未锻好的生铁。"
	force = 10
	force_wielded = 25
	max_integrity = 150
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/greatsword/iron
	name = "铁制大剑"
	desc = "以铁锻成。比钢制同类更沉，也没那么结实，但该干的活它照样能干。"
	icon_state = "igsw"
	max_blade_int = 200
	max_integrity = 200
	wdefense = 4
	smelt_bar_num = 3
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/greatsword/zwei
	name = "克莱摩大剑"
	desc = "这把剑比寻常大剑长得多，而且平衡也相当不错！"
	icon_state = "claymore"
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 3
	max_blade_int = 220
	wdefense = 4
	force = 12
	force_wielded = 30

/obj/item/rogueweapon/greatsword/grenz
	name = "钢制双手剑"
	icon_state = "steelzwei"
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 3
	max_blade_int = 240
	wdefense = 4
	force = 14
	force_wielded = 35

/obj/item/rogueweapon/greatsword/grenz/flamberge
	name = "钢制焰形剑"
	desc = "这是格伦泽尔霍夫式“双手剑”的近亲，深受奥塔瓦贵族青睐。其名源自那独特的火焰形剑身；这种工艺唯有普希顿最出色的武匠方能驾驭。"
	icon_state = "steelflamberge"
	max_blade_int = 200
	max_integrity = 180
	wdefense = 6
	force = 14
	force_wielded = 35

/obj/item/rogueweapon/greatsword/grenz/flamberge/ravox
	name = "箴罚"
	desc = "一柄会令人联想到希望的剑。仿佛能看见那些披着碎裂板甲、肩披焦黑肩甲的人，\
	侍立在祂身侧。为纠正祂犯下的过错，他们曾试图向神圣暴政降下谴罚。\
	<small>即便到了现在，它仍带着灰烬的气味。</small>"
	icon_state = "ravoxflamberge"
	max_integrity = 240
	max_blade_int = 240
	wdefense = 7//You are truly unique, m'lord.

/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	name = "黑钢焰形剑"
	desc = "这是一种并不常见的剑，拥有标志性的波浪形剑身，而铸造它的金属同样稀有。\
	人们认为剑刃上的起伏让它呈现出火焰般的姿态，使其看上去格外骇人。\
	“燃火之剑”常常是奥塔瓦史诗与其他骑士故事中的主角。"
	icon_state = "blackflamb"
	force = 25
	force_wielded = 40
	max_blade_int = 200
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/greatsword/psygsword
	name = "普希顿大剑"
	desc = "据说，一位普希顿铁匠曾在圣玛卢姆亲自引导下锻出这柄可怖巨刃，并受命去斩杀那头盘踞奥塔瓦农地的恶魔。后来人们寻回了它的设计、加以研究，却只打造了寥寥几件仿品，因为他们相信复制会令其锋芒减退。"
	icon_state = "silverexealt"
	minstr = 11//+2, in exchange for the better defense. Is this really a problem? C'mon. It didn't need -5 force.
	wdefense = 6
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/greatsword/psygsword/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/psygsword/relic
	name = "伪经"
	desc = "在奥塔瓦的镶嵌画中，圣拉沃克斯除鹰喙头盔与裹裆布外几乎一丝不挂，常被描绘成手执这般骇人大兵器，对抗黑暗之星格拉格。无论这件圣遗物是否真由神明亲手挥舞，它无可比拟的力量都足以命令最强大的敌人倒下。"
	icon_state = "psygsword"
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/rend, /datum/intent/sword/thrust/exe, /datum/intent/sword/strike/bad)

/obj/item/rogueweapon/greatsword/psygsword/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy
	name = "被遗忘之刃"
	desc = "“愿祂之名终归无人再记。”"
	icon_state = "oldpsybroadsword"
	force = 20
	force_wielded = 25
	minstr = 11
	wdefense = 6
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/chop, /datum/intent/sword/thrust, /datum/intent/rend/krieg)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop, /datum/intent/sword/lunge, /datum/intent/sword/thrust/estoc)
	alt_intents = list(/datum/intent/effect/daze, /datum/intent/sword/strike, /datum/intent/sword/bash)
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy/relic
	name = "信条"
	desc = "普希顿的祈祷与忒尼斯人铁匠齐心协力，只为铸成一把足以诛灭四魔的兵器。圣拉沃克斯偏爱这种沉重巨刃，用它去毁灭那些威胁祂羊群之人。护手上的普希圣徽连诺克最微弱的一缕光都能映出。你就是那道光，去为他们指路吧。"
	icon_state = "psybroadsword"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback") return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt") return list("shrink" = 0.3, "sx" = -4, "sy" = -6, "nx" = 5, "ny" = -6, "wx" = 0, "wy" = -6, "ex" = -1, "ey" = -6, "nturn" = 100, "sturn" = 156, "wturn" = 90, "eturn" = 180, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)

/obj/item/rogueweapon/greatsword/bsword/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten
	name = "未被遗忘之刃"
	desc = "大审判官阿奇博尔德曾记下这样一次远征：七名勇敢的裁决者深入格朗尼亚积雪覆顶的荒原，只为根除邪恶。据说他们的领袖、神圣教令官吉耶曼，披甲与黑钢异端苦战了七天七夜，直到普希顿认可了他的坚忍。最终留下的只有他的剑，而那枚普希圣徽仍缠在剑柄上，以作追念。"
	icon_state = "forgottenblade"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/estoc
	name = "穿甲刺剑"
	desc = "这把剑拥有一段相当修长而尖细的剑身，专门用于刺入敌人护甲的\
	缝隙之间。它的剑柄紧紧缠着黑色皮革。"
	icon_state = "estoc"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 12
	force_wielded = 25
	possible_item_intents = list(
		/datum/intent/sword/thrust,
		/datum/intent/sword/strike,
	)
	gripped_intents = list(
		/datum/intent/sword/thrust/estoc,
		/datum/intent/sword/lunge/estoc,
		/datum/intent/sword/peel/big,
		/datum/intent/sword/strike,
	)
	bigboy = TRUE
	gripsprite = TRUE
	special = /datum/special_intent/piercing_lunge
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 400
	max_integrity = 300
	wdefense = 3
	wdefense_wbonus = 6
	smelt_bar_num = 2

/obj/item/rogueweapon/estoc/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -6,
					"sy" = 7,
					"nx" = 6,
					"ny" = 8,
					"wx" = 0,
					"wy" = 6,
					"ex" = -1,
					"ey" = 8,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -50,
					"sturn" = 40,
					"wturn" = 50,
					"eturn" = -50,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0,
					)
			if("wielded")
				return list(
					"shrink" = 0.6,
					"sx" = 3,
					"sy" = 5,
					"nx" = -3,
					"ny" = 5,
					"wx" = -9,
					"wy" = 4,
					"ex" = 9,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 15,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 8,
					"eflip" = 0,
					)

/obj/item/rogueweapon/woodstaff/naledi
	name = "纳勒迪战杖"
	desc = "这根法杖上承载着普希顿智慧的新月徽记，以及战学者所用的黑金纹章。"
	icon_state = "naledistaff"
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(/datum/intent/spear/bash/ranged, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood/ranged)
	force = 18
	force_wielded = 22
	max_integrity = 250

/obj/item/rogueweapon/woodstaff/naledi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -9,"sy" = 5,"nx" = 9,"ny" = 5,"wx" = -4,"wy" = 4,"ex" = 4,"ey" = 4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 8,"sy" = 0,"nx" = -1,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

// Decorative Naledi staff for loadout - regular staff with Naledi appearance
/obj/item/rogueweapon/woodstaff/decorative
	name = "装饰纳勒迪法杖"
	desc = "这根法杖仿照战学者的新月式样打造。虽然外观上颇有纳勒迪战杖的神韵，却缺少真品那种精妙平衡与奥术调谐。"
	icon_state = "naledistaff"
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/mace/strike/wood)
	force = 10
	force_wielded = 15
	max_integrity = 150

//Only a 'woodenstaff' for the purpose of CDR on spells.
/obj/item/rogueweapon/woodstaff/sojourner
	name = "行旅者法杖"
	desc = "这是一柄旧普希顿长矛残留下来的部分。它的矛尖已经磨钝，倒刺和三叉形矛首也全被拆去。\
	如今它承担着更高贵的使命，成了行旅者施法用的法杖。不过若力气够大，仍能把钝尖狠狠干出去。"
	icon_state = "psystaff"//Temp
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(/datum/intent/spear/thrust/blunted, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood/ranged)
	force = 18
	force_wielded = 20//Worse than just using a knife, really, despite the range.
	thrown_bclass = BCLASS_STAB
	throwforce = 20
	max_integrity = 150
	max_blade_int = 180
	smeltresult = /obj/item/ingot/silverblessed
	is_silver = TRUE

/obj/item/rogueweapon/woodstaff/sojourner/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/woodstaff/quarterstaff
	name = "木制长杖"
	desc = "这根长杖能让任何旅途都轻松些。它结实又灵便，不论是游荡的荒狼还是街头恶棍都能一并痛打。它的长度也足以拿来施展戳刺。"
	force = 15
	force_wielded = 20
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 150

/obj/item/rogueweapon/woodstaff/quarterstaff/iron
	name = "铁头长杖"
	desc = "一根以铁制端头加固的长杖。它比木杖更能打出伤害，而钝头也让它成了相当像样的钝击突刺兵器。还能拿来把对手的武器砸开。"
	force = 16
	force_wielded = 22
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff_iron"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 200

/obj/item/rogueweapon/woodstaff/quarterstaff/steel
	name = "钢头长杖"
	desc = "一根以钢制端头与钢环加固的长杖，使它介于轻型长柄锤与强化长杖之间。它极为耐用，足以把匪徒活活打死；也结实到足以砸断对手的武器。"
	force = 18
	force_wielded = 25
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff_steel"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 200

/obj/item/rogueweapon/woodstaff/quarterstaff/silver
	name = "银头长杖"
	desc = "一根以银制端头加固的长杖。这是相当新的设计，据说灵感来自纳勒迪战学者常携带的战杖。人们说它结实到连 avantyne 砍在杖身上都不会崩出一根木刺。"
	force = 20
	force_wielded = 27
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff_silver"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 250
	is_silver = TRUE

/obj/item/rogueweapon/woodstaff/quarterstaff/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/woodstaff/quarterstaff/psy
	name = "普希顿长杖"
	desc = "一根以银制端头加固的长杖。这是相当新的设计，据说灵感来自纳勒迪战学者常携带的战杖。人们说它结实到连 avantyne 砍在杖身上都不会崩出一根木刺。"
	force = 20
	force_wielded = 27
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff_silver"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 250
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/woodstaff/quarterstaff/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/spear/partizan
	name = "帕提赞长戟"
	desc = "一种起源说法不一的沉重加固长杆兵器，形似长矛。它装有带钉杆身、钢制矛头，以及便于格挡招架的侧突结构。"
	force = 8	//Not a possible one-handed weapon. Also too heavy!
	force_wielded = 30
	possible_item_intents = list(SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(SPEAR_THRUST, PARTIZAN_REND, PARTIZAN_PEEL, SPEAR_BASH)
	icon_state = "partizan"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 12//Easily hit by knights and other dedicated combat roles
	max_blade_int = 200
	wdefense = 6
	wdefense_wbonus = 3	//9 when wielded. Identical to glaive.
	throwforce = 12	//Not a throwing weapon. Too heavy!
	icon_angle_wielded = 50
	wbalance = WBALANCE_HEAVY
	minstr_req = TRUE//No more speed partizan.
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/partizan/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/spear/boar
	name = "猎猪矛"
	desc = "一柄带宽大矛头、且在矛头下方装有一对横翼的长矛。这对矛翼就是为了防止野猪顺着矛身继续猛冲越过矛尖。\
	它在格挡与拦停冲锋敌人时也同样好用。"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "boarspear"
	force_wielded = 33 // 10% base damage increase
	wdefense = 6 // A little bit extra
	max_blade_int = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/otava
	name = "奥塔瓦战旗"
	desc = "一面承载奥塔瓦公国色彩的旗帜，被改造成了一柄可怖的钢制长枪。\
	只有奥塔瓦圣座麾下最忠诚的人才会手持此物。"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "standard"
	force = 15	//ideally, two-hands
	force_wielded = 33 // It's basically a boar spear
	wdefense = 6 // A little bit extra
	max_blade_int = 230
	max_integrity = 280	//-20 than the actual ducal standard
	smeltresult = /obj/item/ingot/steel
	resistance_flags = FIRE_PROOF

/obj/item/rogueweapon/spear/otava/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		pic.color = "#FFA500"
		add_overlay(pic)

/obj/item/rogueweapon/spear/otava/Initialize(mapload)
	. = ..()
	// toying a bit to see if i can make it be orange
	detail_tag = "_det"
	detail_color = "#FFA500"
	update_icon()
	GLOB.lordcolor += src

/obj/item/rogueweapon/spear/otava/lordcolor(primary,secondary)
	// Ignore incoming colors, always use orange
	detail_tag = "_det"
	detail_color = "#FFA500"
	update_icon()

/obj/item/rogueweapon/spear/otava/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/rogueweapon/spear/boar/frei
	name = "阿夫尼克长枪"
	desc = "一种地区性的耳匙形骑枪，握柄雕工精细，并饰有自由剑士的旗色。它们由维什沃的传奇甲匠锻造，并在骑枪手完成训练时授予其中最杰出者。"
	icon_state = "praguespear"

/obj/item/rogueweapon/spear/boar/aav
	name = "阿夫尼克长枪"//I'm creatively bankrupt.
	desc = "一种地区性的耳匙形骑枪，握柄雕工精细，并饰有一面草原民旗帜的色彩。"
	icon_state = "avspear"

/obj/item/rogueweapon/spear/lance
	name = "骑枪"
	desc = "一种专为骑乘作战设计的长杆武器，使用时需夹在腋下平持。它装有护臂托，防止手臂在撞击时顺着\
	枪杆向前滑去。"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "lance"
	force = 15 // Its gonna sucks for 1 handed use
	force_wielded = 20 // Lower damage because a 3 tiles thrust without full charge time still deal base damage.
	wdefense = 4 // 2 Lower than spear
	max_integrity = 200
	max_blade_int = 200 // Better sharpness
	possible_item_intents = list(SPEAR_THRUST_1H, /datum/intent/lance/onehand, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/thrust/lance, /datum/intent/lance, SPEAR_BASH)
	resistance_flags = null
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/naginata
	name = "薙刀"
	desc = "一种传统的风军长柄兵器，兼具长矛的攻击距离与弯刃的斩切威力。由于风军锻刃工艺较为脆弱，武匠们让它的刀刃能通过杆端木楔轻松拆换，以便在折断后迅速更替。"
	force = 16
	force_wielded = 30
	possible_item_intents = list(/datum/intent/spear/cut/naginata, SPEAR_BASH) // no stab for you little chuddy, it's a slashing weapon
	gripped_intents = list(/datum/intent/rend/reach, /datum/intent/spear/cut/naginata, PARTIZAN_PEEL_BAD, SPEAR_BASH)
	icon_state = "naginata"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 7
	max_blade_int = 150 //Nippon suteeru (dogshit)
	wdefense = 5
	throwforce = 12	//Not a throwing weapon.
	icon_angle_wielded = 50
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/naginata/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/halberd/capglaive
	possible_item_intents = list(/datum/intent/spear/thrust/eaglebeak/oneh, SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/thrust/glaive, /datum/intent/spear/cut/glaive, /datum/intent/axe/chop/scythe, SPEAR_BASH)
	name = "“裁决者”"
	desc = "偃月刀本就已经够难打造了，而这把偏偏还是用黑钢制成。它是为卫队长量身铸造的艺术品，也是用来伸张正义、庇护弱者的兵器。"
	force = 17
	force_wielded = 35
	icon = 'icons/roguetown/weapons/special/captainglaive.dmi'
	icon_state = "capglaive"
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/blacksteel
	blade_dulling = DULLING_SHAFT_METAL
	max_integrity = 290 //blacksteel, so its gotta be more durable
	max_blade_int = 200
	sellprice = 250
	wdefense = 12

/obj/item/rogueweapon/halberd/capglaive/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/spear/assegai/iron
	name = "铁制阿塞盖"
	desc = "一种源自纳勒迪南方地区的长矛。居住在比洛马里大河沿岸的平民自幼便会学习使用阿塞盖，以便抵御精怪的侵袭。"
	icon = 'icons/roguetown/weapons/64.dmi'
	max_integrity = 150
	max_blade_int = 150
	icon_state = "assegai_iron"
	gripsprite = FALSE

/obj/item/rogueweapon/spear/assegai
	name = "钢制阿塞盖"
	desc = "一种源自纳勒迪南方地区的长矛。居住在比洛马里大河沿岸的平民自幼便会学习使用阿塞盖，以便抵御精怪的侵袭。"
	icon = 'icons/roguetown/weapons/64.dmi'
	max_integrity = 250
	max_blade_int = 200
	icon_state = "assegai_steel"
	gripsprite = FALSE

/obj/item/rogueweapon/spear/nomad
	name = "游牧矛"
	desc = "这是一种颇为古怪的长矛。你单手便已足够掌控它，再怎么借力也无济于事。\
	对尚未习惯它的人来说，它的配重可谓相当别扭。\
	即便如此，它依旧是沙井游牧民战斗方式的延伸：臂上架盾，手中持矛。"
	icon_state = "nomadspear"//Temp sprite.
	force = 25
	minstr = 6//-2
	max_blade_int = 230
	max_integrity = 250
	possible_item_intents = list(SPEAR_THRUST, SPEAR_CUT, SPEAR_BASH)
	gripped_intents = null
	gripsprite = FALSE
	smeltresult = /obj/item/ingot/steel

/////////////////////
// Special Weapon! //
/////////////////////


/datum/intent/sword/thrust/estoc/dragonslayer
	name = "穿刺"
	icon_state = "inimpale"
	penfactor = 55
	attack_verb = list("刺穿", "贯穿")
	reach = 3
	damfactor = 1.25
	clickcd = 55
	swingdelay = 15

/datum/intent/sword/chop/dragonslayer
	name = "开膛"
	icon_state = "inrend"
	blade_class = BCLASS_CHOP
	attack_verb = list("劈开", "开膛")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 40
	damfactor = 2
	swingdelay = 15
	reach = 2
	clickcd = 55
	item_d_type = "slash"

/datum/intent/sword/smash/dragonslayer
	name = "粉碎"
	blade_class = BCLASS_SMASH
	attack_verb = list("铿然重击", "粉碎")
	hitsound = list('sound/combat/hits/blunt/frying_pan(1).ogg', 'sound/combat/hits/blunt/frying_pan(2).ogg', 'sound/combat/hits/blunt/frying_pan(3).ogg', 'sound/combat/hits/blunt/frying_pan(4).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	reach = 2
	damfactor = 2.5
	swingdelay = 25
	clickcd = 55
	icon_state = "insmash"
	item_d_type = "blunt"

/datum/intent/sword/sucker_punch/dragonslayer
	name = "避无可避的重拳"
	icon_state = "inpunch"
	attack_verb = list("重拳猛击", "掐扼", "狠狠干中")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg', 'sound/combat/hits/kick/kick.ogg')
	damfactor = 4
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = 55
	recovery = 15
	item_d_type = "blunt"
	canparry = FALSE
	candodge = FALSE

/datum/intent/sword/flay/dragonslayer
	name = "剥皮"
	icon_state = "inpeel"
	attack_verb = list("<font color ='#e7e7e7'>剥皮</font>")
	animname = "cut"
	blade_class = BCLASS_PEEL
	hitsound = list('sound/combat/hits/blunt/frying_pan(1).ogg', 'sound/combat/hits/blunt/frying_pan(2).ogg', 'sound/combat/hits/blunt/frying_pan(3).ogg', 'sound/combat/hits/blunt/frying_pan(4).ogg')
	reach = 2
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 15
	clickcd = 50
	damfactor = 0.5
	item_d_type = "slash"
	peel_divisor = 1

//

/obj/item/rogueweapon/greatsword/psygsword/dragonslayer
	name = "\"屠魔者\""
	desc = "“那东西已经大得不能称作剑了。太大、太厚、太重，也太粗糙。不，它更像是一大块银锭。”</br>它庞大得令人胆寒，强大得难以想象，而最重要的是，它本身就是勇气的证明。"
	icon_state = "machaslayer"
	icon = 'icons/roguetown/weapons/64.dmi'
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	possible_item_intents = list(/datum/intent/sword/thrust/estoc/dragonslayer, /datum/intent/sword/sucker_punch/dragonslayer)
	gripped_intents = list(/datum/intent/sword/chop/dragonslayer, /datum/intent/sword/thrust/estoc/dragonslayer, /datum/intent/sword/smash/dragonslayer, /datum/intent/sword/flay/dragonslayer)
	force = 35
	force_wielded = 55
	minstr = 15
	minstr_req = TRUE//You MUST have the required strength. No exceptions.
	wdefense = 15
	max_integrity = 555
	max_blade_int = 555
	alt_intents = null
	is_silver = TRUE
	smeltresult = /obj/item/rogueweapon/sword/long/kriegmesser/silver //Too thick to completely melt.

/obj/item/rogueweapon/greatsword/psygsword/dragonslayer/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 0,\
		added_def = 0,\
	)


//Elven weapons sprited and added by Jam

/obj/item/rogueweapon/greatsword/elf
	possible_item_intents = list(/datum/intent/sword/chop,/datum/intent/sword/strike) //bash is for nonlethal takedowns, only targets limbs
	// Design Intent: It is pretty purely a two-handed weapon. In one hand it's a bit clumsy.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/rend, /datum/intent/sword/thrust/zwei, /datum/intent/sword/strike/bad)
	alt_intents = list(null)//can't be alt-gripped. Ought to compensate for that.
	name = "精灵弯刃"
	desc = "精灵弯刃是一种传统兵器，运用它既像起舞，也像施以死亡。顺着流水般的轨迹，让它的锋路直抵敌人的喉咙。"
	icon_state = "elfcurveblade"
	wlength = WLENGTH_LONG//less reach than greatsword!
	minstr = 7//lighter
	wdefense = 8//better defence than greatsword
	sellprice = 60


/obj/item/rogueweapon/spear/naginata/elf
	name = "精灵枪刃"
	desc = "一种精灵兵器，将精灵式优雅流畅的长刃与修长握柄结合在一起。它才是森林国度真正的守望者。"
	icon_state = "elfglaive"
	sellprice = 60
