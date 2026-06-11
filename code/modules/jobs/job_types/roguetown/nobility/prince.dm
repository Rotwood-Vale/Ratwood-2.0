/datum/job/roguetown/prince
	title = "Prince"
	display_title = "王子"
	f_title = "Princess"
	flag = PRINCE
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	f_title = "Princess"
	allowed_races = RACES_TOLERATED_UP //the duke isn't giving up their throne to a goblin
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_HEIR = 20)

	tutorial = "你从未体会过寒冬噬骨的滋味，从未知晓饥饿如何啃咬，更别提什么叫真正辛劳一日。你像天上的飞鸟那样自由，只要父母仍坐在王座上，便可尽情沉溺于放纵享乐之中：但终有一天你必须长大，而到了那天，你的轻率将让你付出的代价远不止几枚马蒙。"

	display_order = JDO_PRINCE
	give_bank_account = 30
	noble_income = 20
	min_pq = 1
	max_pq = null
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_ROYAL
	cmode_music = 'sound/music/combat_noble.ogg'
	job_traits = list(TRAIT_NOBLE)
	job_subclasses = list(
		/datum/advclass/heir/daring,
		/datum/advclass/heir/bookworm,
		/datum/advclass/heir/aristocrat,
		/datum/advclass/heir/inbred,
		/datum/advclass/heir/scamp
	)

/datum/outfit/job/roguetown/heir/pre_equip(mob/living/carbon/human/H)
	..()
	H.verbs |= /mob/living/carbon/human/proc/declarechampion

/datum/advclass/heir/daring
	name = "莽撞少君"
	tutorial = "你是个大人物，至少你自己一直这么认为。既然如此，想靠自己的本事闯出名声、挣来荣耀，让人们看见你并非只仰仗血统，也算理所当然。再说了，要是你的壮举真能讨得民心，说不定以后真会被选上呢！大概吧。可惜，抛开你的妄想不谈，你的本事和才能其实也就跟侍从差不多。"
	outfit = /datum/outfit/job/roguetown/heir/daring
	category_tags = list(CTAG_HEIR)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/heir/daring/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/heir
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/heiress
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/tights
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather
	l_hand = /obj/item/rogueweapon/sword/sabre
	beltl = /obj/item/rogueweapon/scabbard/sword/royal
	beltr = /obj/item/storage/keyring/heir
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel
	if(SSmapping.current_map.map_name == "Desert Town")
		cloak = /obj/item/clothing/cloak/raincloak/amir
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
		if(should_wear_masc_clothes(H))
			head = /obj/item/clothing/head/roguetown/sultan/amir
			mask = /obj/item/clothing/head/roguetown/circlet
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			belt = /obj/item/storage/belt/rogue/leather/cloth/sash/yellow
			pants = /obj/item/clothing/under/roguetown/sirwal/fancy/red
		if(should_wear_femme_clothes(H))
			shirt = /obj/item/clothing/suit/roguetown/shirt/dress/amiradress
			pants = /obj/item/clothing/under/roguetown/thong
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
			head = /obj/item/clothing/head/roguetown/circlet

/datum/advclass/heir/bookworm
	name = "孤僻书痴"
	tutorial = "尽管你身份尊贵，交际却从来不是你的长处，你大多时候都只与自己和书卷作伴。这自然让你很难成为宫廷诸位贵胄眼中的宠儿，而你偶尔踏出房门，也往往只会换来贵族和仆从的取笑。至少，法师高塔永远欢迎你。"
	outfit = /datum/outfit/job/roguetown/heir/bookworm
	traits_applied = list(TRAIT_ARCYNE_T2, TRAIT_MAGEARMOR, TRAIT_GOODWRITER)
	category_tags = list(CTAG_HEIR)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = -1,
		STATKEY_LCK = 2,
	)
	subclass_spellpoints = 9
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/heir/bookworm/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
		shirt = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/heir
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/heiress
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	head = /obj/item/clothing/head/roguetown/circlet
	belt = /obj/item/storage/belt/rogue/leather/cloth/lady
	beltr = /obj/item/storage/keyring/heir
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff/royal
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	mask = /obj/item/clothing/mask/rogue/spectacles
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message) // so you can order a maid to bring you lunch from your library/room/the tower. Or just broadcast your fanfiction into someone's head aggressively.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt) // So bookworms don't feel pressured to grab only spells for shenanigans / to ONLY take Arcane Potential. If battlemage princess becomes a problem, axe this.

	if(SSmapping.current_map.map_name == "Desert Town")
		cloak = /obj/item/clothing/cloak/raincloak/amir
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
		if(should_wear_masc_clothes(H))
			head = /obj/item/clothing/head/roguetown/sultan/amir
			mask = /obj/item/clothing/head/roguetown/circlet
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			belt = /obj/item/storage/belt/rogue/leather/cloth/sash/yellow
			pants = /obj/item/clothing/under/roguetown/sirwal/fancy/red
		if(should_wear_femme_clothes(H))
			armor = /obj/item/clothing/suit/roguetown/shirt/dress/amiradress
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
			pants = /obj/item/clothing/under/roguetown/thong
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
			head = /obj/item/clothing/head/roguetown/circlet

/datum/advclass/heir/aristocrat
	name = "受护贵胄"
	tutorial = "命运一向待你不薄；整座城堡任你取用，仆从侍立左右，还有整支卫队专门护着你。你无需向任何人证明自己，只要安安稳稳过好日子，将来总也会轮到你坐上领主的位置。不过，没有野心也意味着你除了受过的那些教养外并无多少真本事，而你打发无聊的方式，也不过是扮作娇客或在宫廷里搬弄闲话。"
	outfit = /datum/outfit/job/roguetown/heir/aristocrat
	traits_applied = list(TRAIT_SEEPRICES_SHITTY, TRAIT_GOODLOVER, TRAIT_SEWING_EXPERT)
	category_tags = list(CTAG_HEIR)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_INT = 2,
		STATKEY_LCK = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/heir/aristocrat/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/heir
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/ring/signet
	if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
		belt = /obj/item/storage/belt/rogue/leather
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	if(should_wear_femme_clothes(H))
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/hennin
		armor = /obj/item/clothing/suit/roguetown/armor/silkcoat
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	if(SSmapping.current_map.map_name == "Desert Town")
		cloak = /obj/item/clothing/cloak/raincloak/amir
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
		if(should_wear_masc_clothes(H))
			head = /obj/item/clothing/head/roguetown/sultan/amir
			mask = /obj/item/clothing/head/roguetown/circlet
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			belt = /obj/item/storage/belt/rogue/leather/cloth/sash/yellow
			pants = /obj/item/clothing/under/roguetown/sirwal/fancy/red
		if(should_wear_femme_clothes(H))
			armor = /obj/item/clothing/suit/roguetown/shirt/dress/amiradress
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
			pants = /obj/item/clothing/under/roguetown/thong
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
			head = /obj/item/clothing/head/roguetown/circlet

/datum/advclass/heir/inbred
	name = "近亲废裔"
	tutorial = "按理说，你的血统本该让 普赛顿 因神授正统而向你微笑，这便是贵族的祝福……至少在你出生之前一直如此。你是被命运遗弃的孩子，纵然你终日病骨缠身、脊背咯吱作响、涎水横流，还得让人不知疲倦地伺候着，你在地位上依旧比那些让城镇吃饱穿暖的农民更重要。等你今天咳得没那么厉害时，记得把这点提醒给他们。"
	outfit = /datum/outfit/job/roguetown/heir/inbred
	traits_applied = list(TRAIT_CRITICAL_WEAKNESS, TRAIT_NORUN, TRAIT_GOODLOVER)
	category_tags = list(CTAG_HEIR)
	//They already can't run, no need to do speed and torture their move speed.
	subclass_stats = list(
		STATKEY_STR = -2,
		STATKEY_PER = -2,
		STATKEY_INT = -2,
		STATKEY_CON = -2,
		STATKEY_WIL = -2,
		STATKEY_LCK = -2
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/heir/inbred/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/heir
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/ring/decrepit
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/berrypoison = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongstampoison = 1,
		/obj/item/reagent_containers/glass/mortar = 1,
		/obj/item/pestle = 1)
	if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
		shirt = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/heir
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	if(should_wear_femme_clothes(H))
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/hennin
		armor = /obj/item/clothing/suit/roguetown/armor/silkcoat
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
		shirt = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/heiress
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	if(SSmapping.current_map.map_name == "Desert Town")
		cloak = /obj/item/clothing/cloak/raincloak/amir
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
		if(should_wear_masc_clothes(H))
			head = /obj/item/clothing/head/roguetown/sultan/amir
			mask = /obj/item/clothing/head/roguetown/circlet
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			belt = /obj/item/storage/belt/rogue/leather/cloth/sash/yellow
			pants = /obj/item/clothing/under/roguetown/sirwal/fancy/red
			armor = null
		if(should_wear_femme_clothes(H))
			armor = /obj/item/clothing/suit/roguetown/shirt/dress/amiradress
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
			pants = /obj/item/clothing/under/roguetown/thong
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
			head = /obj/item/clothing/head/roguetown/circlet


/datum/advclass/heir/scamp
	name = "恼人顽少"
	tutorial = "你床边故事里总讲着那些胆大包天、却心怀金子的浪荡侠盗如何拯救世界。那些不被理解的英雄。骑士的喧嚣、奥术与贤者那些乏味书本，从来都勾不起你的兴趣。于是你披上斗篷，用你那略显圆润的身躯学起了潜行之道。想来百姓总会宽恕你这些胡闹把戏的。"
	outfit = /datum/outfit/job/roguetown/heir/scamp
	traits_applied = list(TRAIT_SEEPRICES_SHITTY)
	category_tags = list(CTAG_HEIR)
	//Not standard weighted. Not intended to be considering the stat ceilings. -F
	subclass_stats = list(
	STATKEY_STR = -3,
	STATKEY_CON = -3,
	STATKEY_SPD = 4,
	STATKEY_PER = 2,
	STATKEY_INT = 2,
	STATKEY_WIL = 1,
	STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 8, STAT_CONSTITUTION = 8, STAT_SPEED = 15)	//don't get caught

/datum/outfit/job/roguetown/heir/scamp/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	neck = /obj/item/storage/keyring/heir
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/quiver/sling/iron
	beltr = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
	backr = /obj/item/storage/backpack/rogue/satchel
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/heir
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/heiress
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	armor = /obj/item/clothing/suit/roguetown/armor/longcoat
	cloak = /obj/item/clothing/cloak/shadowcloak
	if(SSmapping.current_map.map_name == "Desert Town")
		cloak = /obj/item/clothing/cloak/raincloak/amir
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
		if(should_wear_masc_clothes(H))
			head = /obj/item/clothing/head/roguetown/sultan/amir
			mask = /obj/item/clothing/head/roguetown/circlet
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			belt = /obj/item/storage/belt/rogue/leather/cloth/sash/yellow
			pants = /obj/item/clothing/under/roguetown/sirwal/fancy/red
		if(should_wear_femme_clothes(H))
			armor = /obj/item/clothing/suit/roguetown/shirt/dress/amiradress
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
			pants = /obj/item/clothing/under/roguetown/thong
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
			head = /obj/item/clothing/head/roguetown/circlet
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/lockpickring/mundane = 1)



/mob/living/carbon/human/proc/declarechampion()
	set name = "册立冠军"
	set category = "贵族"


	if(stat)
		return
	if(!mind)
		return

	if(!src.mind.champion)
		var/list/folksnearby = list()
		for(var/mob/living/carbon/human/newchampionpotential in (view(1)))
			folksnearby += newchampionpotential
		var/target = input(src, "选择一位冠军") as null|anything in folksnearby
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/guy = target
			if(!guy)
				return
			if(guy == src)
				return
			if(!guy.mind)
				return
			src.say("做我的冠军吧，[guy]！")
			var/prompt = alert(guy, "你愿意成为[src]的冠军吗？", "冠军", "愿意", "不愿")
			if(prompt == "不愿")
				return

			guy.say("我愿为你效力，[src]！")
			src.visible_message(span_warning("[src]开始把金色缎带系到[guy]的手腕上。"))
			if(do_after(src, 10 SECONDS))
				src.visible_message(span_warning("[src]把一条金色缎带系在了[guy]的手腕上。"))
				guy.mind.ward = src
				src.mind.champion = guy
				var/datum/status_effect/buff/champion/new_champion = guy.apply_status_effect(/datum/status_effect/buff/champion)
				var/datum/status_effect/buff/ward/new_ward = src.apply_status_effect(/datum/status_effect/buff/ward)
				new_champion.ward = src
				new_ward.champion = guy

	else
		var/list/folksnearby = list()
		for(var/mob/living/carbon/human/championremoval in (view(1)))
			if(championremoval == src.mind.champion)
				folksnearby += championremoval
		var/mob/living/target = input(src, "选择一位冠军") as null|anything in folksnearby
		if(!target)
			return

		else
			src.visible_message(span_warning("[src]开始解下[src.mind.champion]手腕上的金色缎带。"))
			if(do_after(src, 10 SECONDS))
				src.visible_message(span_warning("[src]解下了[src.mind.champion]手腕上的金色缎带。"))
				src.say("我撤销你的冠军之名，[target]！")
				src.mind.champion = null
				if(target.has_status_effect(/datum/status_effect/buff/champion))
					target.remove_status_effect(/datum/status_effect/buff/champion)
				if(src.has_status_effect(/datum/status_effect/buff/ward))
					src.remove_status_effect(/datum/status_effect/buff/ward)


/datum/status_effect/buff/champion
	alert_type = /atom/movable/screen/alert/status_effect/buff/champion
	var/mob/living/carbon/ward = null
	effectedstats = list(STATKEY_CON = 1, STATKEY_WIL = 1)
	duration = -1

/atom/movable/screen/alert/status_effect/buff/champion
	name = "冠军"
	desc = "我已被一位继承人选为冠军！"
	icon_state = "buff"


/datum/status_effect/buff/champion/on_creation()
	spawn(5) // sob doesnt work without this??
		examine_text = "<font color='yellow'>SUBJECTPRONOUN是[owner.mind.ward.real_name]的冠军！</font>"
	return ..()

/datum/status_effect/buff/champion/tick()
	for (var/mob/living/carbon/H in view(5, owner))
		if(H == ward)
			if (!owner.has_stress_event(/datum/stressevent/champion))
				owner.add_stress(/datum/stressevent/champion)

/datum/status_effect/buff/champion/on_remove()
	ward.add_stress(/datum/stressevent/lostchampion)
	owner.mind.ward = null
	owner.remove_status_effect(/datum/status_effect/buff/champion)
	if(ward && ward.mind)
		ward.mind.champion = null
		ward.remove_status_effect(/datum/status_effect/buff/ward)


/datum/status_effect/buff/ward
	alert_type = /atom/movable/screen/alert/status_effect/buff/ward
	var/mob/living/carbon/champion = null
	effectedstats = list(STATKEY_LCK = 1, STATKEY_WIL = 1)
	duration = -1

/atom/movable/screen/alert/status_effect/buff/ward
	name = "受护者"
	desc = "我已册立了一位冠军。"
	icon_state = "buff"

/datum/status_effect/buff/ward/tick()
	for (var/mob/living/carbon/H in view(5, owner))
		if(H == champion)
			if(!owner.has_stress_event(/datum/stressevent/ward))
				owner.add_stress(/datum/stressevent/ward)

/datum/status_effect/buff/ward/on_remove()
	champion.add_stress(/datum/stressevent/lostward)
	owner.mind.champion = null
	owner.remove_status_effect(/datum/status_effect/buff/ward)
	if(champion && champion.mind)
		champion.mind.ward = null
		champion.remove_status_effect(/datum/status_effect/buff/champion)
