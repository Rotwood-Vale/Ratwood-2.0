//// Sleep Specials
//// these should still be in the round-start/late join specials as well! It's just these are contextually fitting for Sleep Specials as well!
/datum/special_trait/nothing
	name = "并无特别"
	greet_text = span_notice("我并没有什么特别之处。")
	weight = 7 //As rare as Vengant Bum, just to remind you it could have been it

/datum/special_trait/nightvision
	name = "夜视"
	greet_text = span_notice("我在黑暗中也能轻易看清。")
	weight = 100

/datum/special_trait/nightvision/on_apply(mob/living/carbon/human/character, silent)
	var/obj/item/organ/eyes/eyes = character.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	eyes.see_in_dark = 3
	eyes.lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
	character.update_sight()

/datum/special_trait/thickskin
	name = "坚韧"
	greet_text = span_notice("我能感觉到。皮糙肉厚，筋骨结实。我简直就是个挨打机器。")
	weight = 100

/datum/special_trait/thickskin/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_BREADY, "[type]")
	character.change_stat(STATKEY_CON, 2)

/datum/special_trait/curseofcain
	name = "残缺的不朽"
	greet_text = span_notice("我感觉自己似乎再也不需要进食了，血管里也空空荡荡……这正常吗？")
	weight = 25

/datum/special_trait/curseofcain/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_NOHUNGER, "[type]")
	ADD_TRAIT(character, TRAIT_NOBREATH, "[type]")

/datum/special_trait/deadened
	name = "麻木"
	greet_text = span_notice("自从<b>那件事</b>发生后，我就再也感受不到任何东西了。无论内心还是身体。")
	weight = 25

/datum/special_trait/deadened/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_NOMOOD, "[type]")
	ADD_TRAIT(character, TRAIT_CRITICAL_RESISTANCE, "[type]")

/datum/special_trait/latentmagic
	name = "潜藏魔力"
	greet_text = span_notice("我天生就有施法的潜质。")
	weight = 25

/datum/special_trait/latentmagic/on_apply(mob/living/carbon/human/character, silent)
	character.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)

/datum/special_trait/value
	name = "识价者"
	greet_text = span_notice("我知道该如何估算一件物品的价值。")
	weight = 100
	restricted_traits = list(TRAIT_SEEPRICES)

/datum/special_trait/value/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_SEEPRICES, "[type]")

/datum/special_trait/lightstep
	name = "轻步"
	greet_text = span_notice("我行动悄无声息，没人能听见我的脚步。")
	weight = 100

/datum/special_trait/lightstep/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_LIGHT_STEP, "[type]")

/datum/special_trait/night_owl
	name = "夜枭"
	greet_text = span_notice("比起祂的另一半，我始终更偏爱 Noc。")
	weight = 100

/datum/special_trait/night_owl/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_NIGHT_OWL, "[type]")

/datum/special_trait/beautiful
	name = "美貌"
	greet_text = span_notice("我的脸庞简直就是件艺术品。")
	weight = 100

/datum/special_trait/beautiful/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_BEAUTIFUL, "[type]")

//positive
/datum/special_trait/duelist
	name = "剑术大师学徒"
	greet_text = span_notice("我曾是传奇剑术大师的弟子，能与我匹敌的人寥寥无几！我还藏了一把刺剑。")
	weight = 50

/datum/special_trait/duelist/on_apply(mob/living/carbon/human/character, silent)
	character.cmode_music = 'sound/music/cmode/adventurer/combat_outlander4.ogg'
	character.change_stat(STATKEY_SPD, 2)
	character.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE) //will make a unique trait later on
	character.mind.special_items["Rapier"] = /obj/item/rogueweapon/sword/rapier

/datum/special_trait/eagle_eyed
	name = "鹰眼"
	greet_text = span_notice("凭借我精准的瞄准，我总能命中远处的目标。我还藏了一把十字弓和几支弩箭。")
	weight = 50

/datum/special_trait/eagle_eyed/on_apply(mob/living/carbon/human/character, silent)
	character.change_stat(STATKEY_PER, 2)
	character.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 5, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
	character.mind.special_items["Crossbow"] = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	character.mind.special_items["Bolts"] = /obj/item/quiver/bolts

/datum/special_trait/mule
	name = "驮骡"
	greet_text = span_notice("我一直在倒卖药物，还藏了一处私货。")
	weight = 100

/datum/special_trait/mule/on_apply(mob/living/carbon/human/character, silent)
	character.mind.special_items["Stash One"] = /obj/item/storage/backpack/rogue/satchel/mule
	character.mind.special_items["Stash Two"] = /obj/item/storage/backpack/rogue/satchel/mule
	character.mind.special_items["Dagger"] = /obj/item/rogueweapon/huntingknife/idagger
	character.adjust_skillrank_up_to(/datum/skill/combat/knives, 2, TRUE)

/datum/special_trait/cunning_linguist
	name = "狡黠语者"
	greet_text = span_notice("我多懂一门语言，而且还挺会勾人。")
	weight = 100

/datum/special_trait/cunning_linguist/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_GOODLOVER, "[type]")
	switch(rand(1,3))
		if(1)
			character.grant_language(/datum/language/elvish)
		if(2)
			character.grant_language(/datum/language/hellspeak)
		if(3)
			character.grant_language(/datum/language/draconic)

/datum/special_trait/corn_fed
	name = "玉米养大"
	greet_text = span_notice("我从小吃了不少玉米长大。")
	weight = 100

/datum/special_trait/corn_fed/on_apply(mob/living/carbon/human/character, silent)
	character.change_stat(STATKEY_CON, 2)
	character.change_stat(STATKEY_INT, -2)

/datum/special_trait/bookworm
	name = "书虫"
	greet_text = span_notice("我热爱书籍，也常常乐在其中地阅读。")
	weight = 100

/datum/special_trait/bookworm/on_apply(mob/living/carbon/human/character, silent)
	character.adjust_skillrank_up_to(/datum/skill/misc/reading, 4, TRUE)

/datum/special_trait/limpdick
	name = "懒散士兵"
	greet_text = span_crit("我那“小士兵”怎么都立不起正！可恶！")
	weight = 100

/datum/special_trait/screenshake
	name = "颤抖"
	greet_text = span_crit("我现在已经没法稳住自己了……")
	weight = 100

/datum/special_trait/maniac_awoken
	name = "救救我"
	greet_text = span_cult("祂们要来抓我了")
	weight = 100

/datum/special_trait/schizo_ambience
	name = "精神分裂"
	greet_text = span_suicide("我的肿瘤让我看见了帷幕彼端！")
	weight = 100

/datum/special_trait/arsonist
	name = "纵火犯"
	greet_text = span_notice("我喜欢看东西燃烧起火。我还藏了两枚燃烧弹。")
	weight = 100

/datum/special_trait/arsonist/on_apply(mob/living/carbon/human/character, silent)
	character.mind.special_items["Firebomb One"] = /obj/item/bomb
	character.mind.special_items["Firebomb Two"] = /obj/item/bomb
	character.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 1, TRUE)

/datum/special_trait/pineapple
	name = "安全词是“Pineapple”"
	greet_text = span_notice("我喜欢把人抽打到扭动呻吟，他们的痛苦便是我的欢愉。我还藏了一根鞭子。")
	weight = 50

/datum/special_trait/pineapple/on_apply(mob/living/carbon/human/character, silent)
	character.mind.special_items["Whip"] = /obj/item/rogueweapon/whip
	character.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 6, TRUE)

/datum/special_trait/psydons_rider
	name = "Psydon 最醉的骑手"
	greet_text = span_notice("我要骑！任何律法都拦不住我，因为这就是 Psydon 的神圣意志！")
	req_text = "信奉 Psydon"
	allowed_patrons = list(/datum/patron/old_god)
	weight = 100

/datum/special_trait/psydons_rider/on_apply(mob/living/carbon/human/character, silent)
	character.drunkenness = 50
	for(var/i in 1 to 2)
		var/obj/item/bottle = new /obj/item/reagent_containers/glass/bottle/rogue/wine(get_turf(character))
		character.put_in_hands(bottle, forced = TRUE)

	character.adjust_skillrank_up_to(/datum/skill/misc/riding, 4, TRUE)
	new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(get_turf(character))

/datum/special_trait/spring_in_my_step
	name = "步履轻快"
	greet_text = span_notice("我的双腿十分有力，别人得攀爬的地方，我一跃就能过去。")
	weight = 25

/datum/special_trait/spring_in_my_step/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_ZJUMP, "[type]")

/datum/special_trait/tolerant
	name = "宽容"
	greet_text = span_notice("我梦想着一个理想的未来，一个万族和平共处的未来。")
	weight = 100

/datum/special_trait/tolerant/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_TOLERANT, "[type]")

/datum/special_trait/thief
	name = "盗贼"
	greet_text = span_notice("这地方的日子不好过，不过我靠拿走别人的东西，让自己过得轻松了些。")
	weight = 100

/datum/special_trait/thief/on_apply(mob/living/carbon/human/character, silent)
	character.adjust_skillrank_up_to(/datum/skill/misc/stealing, 5, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/misc/sneaking, 4, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/misc/climbing, 3, TRUE)

/datum/special_trait/languagesavant
	name = "通晓百语"
	greet_text = span_notice("我总能轻易学会各种语言，哪怕是凡人不该掌握的那些……除了那该死的野兽低语。那到底算什么胡言乱语？")
	weight = 100

/datum/special_trait/languagesavant/on_apply(mob/living/carbon/human/character, silent)
	character.grant_language(/datum/language/dwarvish)
	character.grant_language(/datum/language/elvish)
	character.grant_language(/datum/language/hellspeak)
	character.grant_language(/datum/language/celestial)
	character.grant_language(/datum/language/orcish)
	character.grant_language(/datum/language/draconic)

/datum/special_trait/civilizedbarbarian
	name = "酒馆斗士"
	greet_text = span_notice("我感觉自己的拳头更沉了！")
	weight = 100

/datum/special_trait/civilizedbarbarian/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC) //Need to make trait improve hitting people with chairs, mugs, goblets.

/datum/special_trait/mastercraftsmen
	name = "工艺大师"
	greet_text = "我年轻时便立志精通百工，于是追逐起工艺的十门技艺。"
	req_text = "中年或年老"
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	weight = 100

/datum/special_trait/mastercraftsmen/on_apply(mob/living/carbon/human/character)
	character.adjust_skillrank_up_to(/datum/skill/craft/crafting, 2, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, 2, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, 2, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, 2, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 2, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/craft/masonry, 2, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/craft/cooking, 2, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/craft/engineering, 2, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/craft/tanning, 2, TRUE)

/datum/special_trait/bleublood
	name = "贵胄血统"
	greet_text = span_notice("我出身于高贵的血脉。")
	restricted_traits = list(TRAIT_NOBLE)
	weight = 100

/datum/special_trait/bleublood/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_NOBLE, "[type]")
	character.adjust_skillrank_up_to(/datum/skill/misc/reading, 2, TRUE)

/datum/special_trait/richpouch
	name = "富足钱袋"
	greet_text = span_notice("我最近捡到了一只装满 mammons 的钱袋，多半是哪位贵族丢的。")
	weight = 100

/datum/special_trait/richpouch/on_apply(mob/living/carbon/human/character, silent)
	var/obj/item/pouch = new /obj/item/storage/belt/rogue/pouch/coins/rich(get_turf(character))
	character.put_in_hands(pouch, forced = TRUE)

/datum/special_trait/swift
	name = "迅捷者"
	greet_text = span_notice("我感觉自己是世上跑得最快的人，只要不被中甲或重甲拖累，恐怕什么都能躲开。")
	weight = 50

/datum/special_trait/swift/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_DODGEEXPERT, "[type]")
	character.adjust_skillrank(/datum/skill/misc/athletics, 6, TRUE)
	character.change_stat(STATKEY_SPD, 3)

/datum/special_trait/gourmand
	name = "饕客"
	greet_text = span_notice("哪怕是最腐坏、生冷，甚至有毒的食物和水，我也能像品尝佳肴一样吃下去……")
	weight = 100

/datum/special_trait/gourmand/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_NASTY_EATER, "[type]")

/datum/special_trait/lucky
	name = "幸运眷顾"
	greet_text = span_notice("Xylix 眷顾着我，我的运气好得惊人。")
	req_text = "以 Xylix 为你的 Patron"
	allowed_patrons = list(/datum/patron/divine/xylix)
	weight = 7

/datum/special_trait/lucky/on_apply(mob/living/carbon/human/character, silent)
	character.STALUC = rand(15, 20) //In other words, In the next round following the special, you are effectively lucky.

//neutral
/datum/special_trait/backproblems
	name = "巨人"
	greet_text = span_notice("别人一直都叫我巨人。我的体格让我受到重视，但这个为矮小种族打造的世界，也逼得我只能谨慎行动。")
	req_text = "不能是 kobold、verminvolk 或 dwarf"
	restricted_races = list(/datum/species/anthromorphsmall, /datum/species/dwarf/mountain, /datum/species/kobold)
	weight = 50

/datum/special_trait/backproblems/on_apply(mob/living/carbon/human/character)
	character.change_stat(STATKEY_STR, 2)
	character.change_stat(STATKEY_CON, 1)
	character.change_stat(STATKEY_SPD, -2)
	character.transform = character.transform.Scale(1.25, 1.25)
	character.transform = character.transform.Translate(0, (0.25 * 16))
	character.update_transform()

/datum/special_trait/atheism
	name = "无神者"
	greet_text = span_notice("诸神也许确实存在，但那又怎样？我毫不在乎。")
	req_text = "非教会职业"
	restricted_jobs = list(CHURCH_ROLES)
	weight = 100

/datum/special_trait/atheism/on_apply(mob/living/carbon/human/character, silent)
	character.set_patron(/datum/patron/godless)

//negative
/datum/special_trait/nimrod
	name = "愚钝"
	greet_text = span_boldwarning("我从前学东西就比同伴慢，也总是笨手笨脚。")
	weight = 100

/datum/special_trait/nimrod/on_apply(mob/living/carbon/human/character, silent)
	character.change_stat(STATKEY_SPD, -2)
	character.change_stat(STATKEY_INT, -4)

/datum/special_trait/nopouch
	name = "没了钱袋"
	greet_text = span_boldwarning("我最近把钱袋弄丢了，现在一个 zenny 都没有……")
	weight = 200

/datum/special_trait/nopouch/on_apply(mob/living/carbon/human/character, silent)
	var/obj/item/pouch = locate(/obj/item/storage/belt/rogue/pouch) in character
	if(character.wear_neck == pouch)
		character.wear_neck = null
	if(character.beltl == pouch)
		character.beltl = null
	if(character.beltr == pouch)
		character.beltr = null
	qdel(pouch)

/datum/special_trait/hussite
	name = "知名异端"
	greet_text = span_boldwarning("不管理由是否正当，我都已经被教会公开斥为异端了！")
	req_text = "非教会职业"
	weight = 20
	restricted_jobs = list(CHURCH_ROLES)

/datum/special_trait/hussite/on_apply(mob/living/carbon/human/character, silent)
	GLOB.excommunicated_players += character.real_name

/datum/special_trait/bounty
	name = "被悬赏者"
	greet_text = span_boldwarning("有人悬赏要我的命！")
	weight = 20

/datum/special_trait/bounty/on_apply(mob/living/carbon/human/character, silent)
	var/reason = ""
	var/employer = "不明雇主"
	var/employer_gender
	if(prob(65))
		employer_gender = MALE
	else
		employer_gender = FEMALE
	if(employer_gender == MALE)
		employer = pick(list("男爵", "领主", "贵族老爷", "王子"))
	else
		employer = pick(list("女公爵", "贵妇", "贵族小姐", "公主"))
	employer = "[employer] [random_human_name(employer_gender, FALSE, FALSE)]"
	var/amount = rand(40,100)
	switch(rand(1,7))
		if(1)
			reason = "谋杀"
		if(2)
			reason = "弑亲"
		if(3)
			reason = "玷污贵族名声"
		if(4)
			reason = "叛国"
		if(5)
			reason = "纵火"
		if(6)
			reason = "异端罪"
		if(7)
			reason = "打劫贵族"
	add_bounty(character.real_name, amount, FALSE, reason, employer)
	if(!silent)
		to_chat(character, span_notice("不论事情是不是我干的，我都已被指控犯下[reason]，[employer]还悬赏买我的脑袋！"))

/datum/special_trait/outlaw
	name = "知名法外之徒"
	greet_text = span_boldwarning("无论那些罪真是我犯下的，还是只是被人栽赃，我都已经被宣布为法外之徒了！")
	weight = 20

/datum/special_trait/outlaw/on_apply(mob/living/carbon/human/character, silent)
	make_outlaw(character.real_name, TRUE)

/datum/special_trait/unlucky
	name = "霉运缠身"
	greet_text = span_boldwarning("自从我打翻了那个玻璃花瓶之后，就总觉得……哪里不对劲。")
	weight = 100

/datum/special_trait/unlucky/on_apply(mob/living/carbon/human/character, silent)
	character.STALUC = rand(1, 10)


/datum/special_trait/jesterphobia
	name = "小丑恐惧症"
	greet_text = span_boldwarning("我对 Jesters 怀有一种严重而毫无道理的恐惧。")
	weight = 50

/datum/special_trait/jesterphobia/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_JESTERPHOBIA, "[type]")

/datum/special_trait/wild_night
	name = "疯狂一夜"
	greet_text = span_boldwarning("我完全不记得昨晚干了什么，而现在我迷路了！")
	weight = 200

/datum/special_trait/wild_night/on_apply(mob/living/carbon/human/character, silent)
	var/turf/location = get_spawn_turf_for_job("Pilgrim")
	character.forceMove(location)
	grant_lit_torch(character)

/datum/special_trait/atrophy
	name = "萎缩"
	greet_text = span_boldwarning("我长大时连填饱自己都很困难……这让我变得虚弱又脆弱。")
	weight = 50

/datum/special_trait/atrophy/on_apply(mob/living/carbon/human/character)
	character.change_stat(STATKEY_STR, -2)
	character.change_stat(STATKEY_CON, -2)
	character.change_stat(STATKEY_WIL, -1)

/datum/special_trait/lazy
	name = "懒惰"
	greet_text = span_boldwarning("我不在乎，从来都不在乎。")
	weight = 50

/datum/special_trait/lazy/on_apply(mob/living/carbon/human/character)
	character.change_stat(STATKEY_STR, -1)
	character.change_stat(STATKEY_CON, -1)
	character.change_stat(STATKEY_WIL, -1)
	character.change_stat(STATKEY_SPD, -1)
	character.change_stat(STATKEY_PER, -1)

/datum/special_trait/bad_week
	name = "糟糕的一周"
	greet_text = span_boldwarning("不知为何，什么事都让我火大。")
	weight = 100

/datum/special_trait/bad_week/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_BAD_MOOD, "[type]")

/datum/special_trait/nude_sleeper
	name = "挑剔睡客"
	greet_text = span_boldwarning("除非我感到<i>真正</i>舒服，否则就是睡不着……")
	weight = 25

/datum/special_trait/nude_sleeper/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_NUDE_SLEEPER, "[type]")

//job specials
/datum/special_trait/punkprincess //I think everyone will like the Rebellous Prince-Like Princess. I'd love to do one for the prince as well that gives him princess loadout, but, up to you!
	name = "叛逆之女"
	greet_text = span_notice("就一个公主来说，我可算相当叛逆了。去他的贵族规矩！")
	req_text = "成为公主"
	allowed_sexes = list(FEMALE)
	allowed_jobs = list(/datum/job/roguetown/prince)
	weight = 50

/datum/special_trait/punkprincess/on_apply(mob/living/carbon/human/character, silent)
	QDEL_NULL(character.wear_pants)
	QDEL_NULL(character.wear_shirt)
	QDEL_NULL(character.wear_armor)
	QDEL_NULL(character.shoes)
	QDEL_NULL(character.belt)
	QDEL_NULL(character.beltl)
	QDEL_NULL(character.beltr)
	QDEL_NULL(character.backr)
	QDEL_NULL(character.head)
	character.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/tights/random(character), SLOT_PANTS)
	character.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/shirt/undershirt/guard(character), SLOT_SHIRT)
	character.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail(character), SLOT_ARMOR)
	character.equip_to_slot_or_del(new /obj/item/storage/belt/rogue/leather(character), SLOT_BELT)
	character.equip_to_slot_or_del(new /obj/item/storage/belt/rogue/pouch/coins/rich(character), SLOT_BELT_R)
	character.equip_to_slot_or_del(new /obj/item/storage/backpack/rogue/satchel(character), SLOT_BACK_R)
	character.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/nobleboot(character), SLOT_SHOES)
	character.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
	character.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	character.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
	character.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	character.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	character.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	character.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	character.adjust_skillrank(/datum/skill/misc/reading, -2, TRUE)
	character.adjust_skillrank(/datum/skill/misc/sneaking, -2, TRUE)
	character.adjust_skillrank(/datum/skill/misc/stealing, -2, TRUE)

/datum/special_trait/vengantbum
	name = "复仇流民"
	greet_text = span_notice("我曾是个贵族，意气风发，直到父亲在我眼前被人杀害。所幸导师把我带到了安全之处，并教会了我在这片肮脏土地上活下去所需的一切。他们以为我是个下等人，但那恰恰是我的优势。")
	req_text = "成为乞丐"
	allowed_jobs = list(/datum/job/roguetown/beggar)
	weight = 7

/datum/special_trait/vengantbum/on_apply(mob/living/carbon/human/character, silent)
	ADD_TRAIT(character, TRAIT_DECEIVING_MEEKNESS, "[type]")
	character.adjust_skillrank(/datum/skill/combat/wrestling, 6, TRUE)
	character.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
	character.adjust_skillrank_up_to(/datum/skill/misc/reading, 3, TRUE)
	character.STASTR = 20
	character.STACON = 20
	character.STAWIL = 20

/datum/special_trait/my_precious
	name = "我的宝贝"
	greet_text = span_notice("那枚戒指，它是那么闪亮……那么珍贵，我能感受到它的力量。它全都是我的！")
	req_text = "成为乞丐"
	allowed_jobs = list(/datum/job/roguetown/beggar)
	weight = 50

/datum/special_trait/my_precious/on_apply(mob/living/carbon/human/character, silent)
	QDEL_NULL(character.wear_pants)
	QDEL_NULL(character.wear_shirt)
	QDEL_NULL(character.wear_armor)
	QDEL_NULL(character.shoes)
	QDEL_NULL(character.head)
	var/obj/item/ring = new /obj/item/clothing/ring/dragon_ring(get_turf(character))
	character.put_in_hands(ring, forced = TRUE)

/datum/special_trait/illicit_merchant
	name = "私商"
	greet_text = span_notice("我已经受够了给别人打下手，我要开创属于自己的商路。我弄到了一把藏起来的商人钥匙，还有一件奇妙的魔法装置。")
	req_text = "成为店员"
	allowed_jobs = list(/datum/job/roguetown/shophand)
	weight = 50

/datum/special_trait/illicit_merchant/on_apply(mob/living/carbon/human/character, silent)
	character.mind.special_items["Merchant Key"] = /obj/item/roguekey/merchant
	character.mind.special_items["GOLDFACE Gem"] = /obj/item/gem_device/goldface
