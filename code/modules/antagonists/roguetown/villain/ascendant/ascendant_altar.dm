// OH GOD IT'S SO SHITTY IM SO SORRY PLEASE PLEAS EPLEASEP ELEA

GLOBAL_LIST_INIT(psydon_pool, list(
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk,  //todo: items lol
	/obj/item/clothing/suit/roguetown/armor/gambeson,
	/obj/item/clothing/suit/roguetown/armor/leather,
	/obj/item/reagent_containers/glass/bottle/waterskin,
	/obj/item/natural/cloth,
	/obj/item/natural/fur,
	/obj/item/reagent_containers/food/snacks/grown/berries/rogue
))

//doing it this way came to me in a dream. find out which items ASCENDANT will be getting today
GLOBAL_LIST_INIT(capstone_pool, list(
	/obj/item/rogueore/coal, //= "minecraft item",
	/obj/item/rogueore/gold,
	/obj/item/rogueore/iron
))


/datum/crafting_recipe/roguetown/structure/ascendant
	name = "飞升者祭坛"
	result = /obj/structure/ascendant_altar
	reqs = list(
		/obj/item/bodypart = 2,
		/obj/item/organ/stomach = 1,
	)
	verbage_simple = "构筑"
	verbage = "构筑"
	craftsound = 'sound/foley/Building-01.ogg'
	skillcraft = null
	always_availible = FALSE
	subtype_reqs = TRUE

// Altar, sacrifice the right on this to
/obj/structure/ascendant_altar
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "alch"
	var/ascend_stage = 0 //stages - 0 is base, 1 is 1st capstone, 2 is 2nd capstone, 3 is full ascension
	var/ascendpoints = 0 //artefact points

/obj/structure/ascendant_altar/examine(mob/user)
	. = ..()
	if(!user.mind?.has_antag_datum(/datum/antagonist/ascendant))
		. += "它看起来几乎像是在等待什么 - 但我不知道那是什么。"
		return

	var/obj/item/next_artefact = LAZYACCESS(GLOB.psydon_pool, 1)
	var/obj/item/next_capstone = LAZYACCESS(GLOB.psydon_pool, 1)
	if(next_artefact)
		. += "我必须找到的下一件圣物是 \a [initial(next_artefact.name)]。"
	else
		. += span_danger("我已经集齐了所需的全部圣物！")
	if(next_capstone)
		. += "让我力量再度升华的下一块基石是 \a [initial(next_capstone.name)]。"
	else
		. += span_danger("我已经集齐了所需的全部基石！")

/obj/structure/ascendant_altar/proc/consume_artefact(obj/item/I, mob/living/user)
	var/next_artefact = LAZYACCESS(GLOB.psydon_pool, 1)
	if(!next_artefact)
		return FALSE
	if(!istype(I, next_artefact))
		return FALSE
	. = TRUE
	if(ascendpoints >= 4) // we already have 4 points, stop already!
		to_chat(user, span_danger("已经没有更多圣物可供收集了。现在该去完成我的大业了。"))
		return
	ascendpoints++

	user.STASTR += 2
	user.STAPER += 2
	user.STAINT += 2
	user.STACON += 2
	user.STAWIL += 2
	user.STASPD += 2
	user.STALUC += 2

	//check what ascendpoint they are on and add that trait
	switch(ascendpoints)
		if(1)
			ADD_TRAIT(user, TRAIT_DECEIVING_MEEKNESS, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_EMPATH, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_STEELHEARTED, TRAIT_GENERIC)
			to_chat(user, span_userdanger("我在启程之初谦卑地低下头。大阿卡纳：节制，正位。"))
		if(2)
			to_chat(user, span_userdanger("我周围的世界变得越来越无足轻重 - 我意识到万物是多么渺小。大阿卡纳：圣杯王后，逆位。"))
			ADD_TRAIT(user, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_NOMOOD, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
		if(3)
			ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball)
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt)
			to_chat(user, span_userdanger("我有许多敌人 - 而他们一无所有。宝剑十，正位。"))
		if(4)
			ADD_TRAIT(user, TRAIT_STABLEHEART, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_STABLELIVER, TRAIT_GENERIC)
			to_chat(user, span_userdanger("我的内里化作怪异之石。缕缕蒸汽穿过我的身躯。我不可能仍是凡人，我已超越凡人，我正在、正在、正在、正在接近完成。大阿卡纳：力量"))
	GLOB.psydon_pool.Cut(1, 2) // remove the first item
	qdel(I)


/obj/structure/ascendant_altar/attackby(obj/item/I, mob/living/user)

//todo: this is garbage, break this into multiple procs, fucking please??
//basically- stuff in artefacts, get traits. stuff in capstone to actually get the next stage
	// first, if we're not an ascendant, we can't do ANYTHING here!
	if(!user.mind?.has_antag_datum(/datum/antagonist/ascendant))
		return ..()
	// second, if this is an artifact, and not a capstone...
	if(consume_artefact(I, user))
		return
	//handles capstones
	else if(consume_capstone(I, user))
		return
	else
		to_chat(user, span_userdanger("这件物品对我毫无用处……"))

/obj/structure/ascendant_altar/proc/consume_capstone(obj/item/I, mob/living/user)
	var/obj/item/next_capstone = LAZYACCESS(GLOB.capstone_pool, 1)
	if(!next_capstone)
		return FALSE
	if(!istype(I, next_capstone))
		return FALSE
	. = TRUE
	QDEL_NULL(I)
	GLOB.capstone_pool.Cut(1,2) // remove first item
	ascend(user)

// This proc sleeps. Call it at your own peril.
/obj/structure/ascendant_altar/proc/ascend(mob/living/user)
	set waitfor = FALSE
	ascend_stage++

	user.STASTR += 2
	user.STAPER += 2
	user.STAINT += 2
	user.STACON += 2
	user.STAWIL += 2
	user.STASPD += 2
	user.STALUC += 2

	switch(ascend_stage)
		if(1)
			ADD_TRAIT(user, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
			to_chat(user, span_danger("第一块基石。我的心智豁然开启。周遭的世界仿佛变小了。一具尸体。我们活在一具尸体之上。而这个死物也必须像其他一切那样被处理掉。我的步伐变得僵硬。"))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/churn)
			addomen(ASCEND_FIRST)
			priority_announce("地脉开始以反常扭曲的方式震颤 - 大阿卡纳：愚者，正位。", "梦者", 'sound/villain/dreamer_warning.ogg')
		if(2)
			to_chat(user, span_danger("第二块基石。陷在污秽里 - 污秽与粪秽！我抓住那腐烂、发臭之物，开始将它一层层剥开。彗星西昂。那位大魔。祂是死了，还是在沉睡？……"))
			sleep(30)
			to_chat(user, span_userdanger("祂是虚弱 - 还是怯懦？？"))
			sleep(20)
			to_chat(user, span_userdanger("神要来了。"))
			sleep(10)
			to_chat(user, span_userdanger("神要来了神要来了"))
			new /obj/item/rogueweapon/sword/long/judgement/ascendant
			addomen(ASCEND_WAKENING)
			ADD_TRAIT(user, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_ANTIMAGIC, TRAIT_GENERIC)
			priority_announce("天空开始转得更快了 - 大阿卡纳：倒吊人，逆位", "梦者", 'sound/villain/dreamer_warning.ogg')
		if(3)
			to_chat(user, span_danger("剧痛。撕裂般的头痛。灵魂在搏动。"))
			user.flash_fullscreen("redflash3")
			user.emote("agony", forced = TRUE)
			sleep(20)
			to_chat(user, span_userdanger("这世W界并不真实。我的呼吸消失了。我的心脏几乎不再跳动。我的血脉空空如也。"))
			sleep(50)
			to_chat(user, span_userdanger("我是神。 我是神。 我是神。 我是神。 我是神。 我是神。 我是神。 我是神。 我是神。 我是神。 我是神。 我是神。"))
			sleep(30)
			to_chat(user, span_userdanger("我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神"))
			user.flash_fullscreen("redflash3")
			user.emote("agony", forced = TRUE)
			user.Stun(30)
			user.Knockdown(30)
			sleep(30)
			to_chat(user, span_userdanger("我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神"))
			user.flash_fullscreen("redflash3")
			user.emote("agony", forced = TRUE)
			user.Stun(100)
			user.Knockdown(100)
			for(var/i = 1, i <= 10, i++)
				spawn((i - 1) * 5)
					to_chat(user, span_userdanger("我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 我是神 "))
			sleep(30)
			user.flash_fullscreen("redflash3")

//all goes dark. tp them over. give them their stats.
			user.emote("agony", forced = TRUE)
			user.SetSleeping(10 SECONDS)
			to_chat(user, span_reallybig("世界陷入黑暗！"))
			var/turf/location = get_spawn_turf_for_job("Pilgrim")
			user.forceMove(location)
			user.Stun(50)
			user.cmode_music = 'sound/music/combat_ascended.ogg'
			user.STASTR += 10
			user.STAPER += 10
			user.STAINT += 10
			user.STACON += 10
			user.STAWIL += 10
			user.STASPD += 10
			user.STALUC += 6

			heavensaysdanger() //Roger, our deal is honored; you will be rewarded in heaven.
			addomen(ASCEND_ASCENDANT)
			sleep(15 SECONDS)
			to_chat(user, span_mind_control("我必S须前往王O座。王座。王座。我的王国在等待。普赛多尼亚 已死。我必须升 asc "))

			qdel(src)

/obj/structure/ascendant_altar/attack_right(mob/living/user)
	if(!user.mind?.has_antag_datum(/datum/antagonist/ascendant))
		to_chat(user, span_userdanger("我完全不知道这是什么。"))
		return
	to_chat(user, span_userdanger("我已经收集了 [ascend_stage] 块基石与 [ascendpoints] 件圣物。"))

/obj/structure/ascendant_altar/proc/heavensaysdanger()
	priority_announce("梦者 已然升格 - MAJOR ARCANA : T$yh3 TOW##ER, RE v3RSED", "神要来了", 'sound/villain/ascendant_intro.ogg')
	sleep(15 SECONDS)
	to_chat(world, span_danger("王座下方的大地在震动。天空正在裂开。"))
