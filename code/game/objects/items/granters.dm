
///books that teach things (intrinsic actions like bar flinging, spells like fireball or smoke, or martial arts)///

/obj/item/book/granter
	due_date = 0 // Game time in deciseconds
	unique = 1   // 0  Normal book, 1  Should not be treated as normal book, unable to be copied, unable to be modified
	var/list/remarks = list() //things to read about while learning.
	var/pages_to_mastery = 3 //Essentially controls how long a mob must keep the book in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form book
	var/used = FALSE //only really matters if oneuse but it might be nice to know if someone's used it for admin investigations perhaps

/obj/item/book/granter/proc/turn_page(mob/user)
	playsound(user, pick('sound/blank.ogg'), 30, TRUE)
	if(do_after(user,50, user))
		if(remarks.len)
			to_chat(user, span_notice("[pick(remarks)]"))
		else
			to_chat(user, span_notice("我继续读了下去……"))
		return TRUE
	return FALSE

/obj/item/book/granter/proc/recoil(mob/user) //nothing so some books can just return

/obj/item/book/granter/proc/already_known(mob/user)
	return FALSE

/obj/item/book/granter/proc/on_reading_start(mob/user)
	to_chat(user, span_notice("我开始阅读[name]……"))

/obj/item/book/granter/proc/on_reading_stopped(mob/user)
	to_chat(user, span_notice("我停止了阅读……"))

/obj/item/book/granter/proc/on_reading_finished(mob/user)
	to_chat(user, span_notice("我读完了[name]！"))

/obj/item/book/granter/proc/onlearned(mob/user)
	used = TRUE


/obj/item/book/granter/attack_self(mob/living/user)
	if(reading)
		to_chat(user, span_warning("我已经在读这本了！"))
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(already_known(user))
		return FALSE
/*	AZURE PEAK REMOVAL -- UNUSED ANYWAY
	if(user.STAINT < 12)
			to_chat(user, span_warning("这些蔓延交错的符文我根本无法理解！"))
			return FALSE */
	if(used && oneuse)
		to_chat(user, span_warning("这眼知识之泉本就不是为让人啜饮两次而存在的！"))
		recoil(user)
		return FALSE
	on_reading_start(user)
	reading = TRUE
	for(var/i=1, i<=pages_to_mastery, i++)
		if(!turn_page(user))
			reading = FALSE
			on_reading_stopped()
			return FALSE
	if(do_after(user, 50, user))
		reading = FALSE
		on_reading_finished(user)
		return TRUE
	reading = FALSE //failsafe
	return FALSE

/obj/item/book/granter/spell
	grid_width = 64
	grid_height = 32

	var/spell
	var/spellname = "召来虫群"

/obj/item/book/granter/spell/already_known(mob/user)
	if(!spell)
		return TRUE
	for(var/obj/effect/proc_holder/spell/knownspell in user.mind.spell_list)
		if(knownspell.type == spell)
			if(user.mind)
				to_chat(user,span_warning("这本我已经读过了！"))
			return TRUE
	return FALSE

/obj/item/book/granter/spell/on_reading_start(mob/user)
	to_chat(user, span_notice("我开始阅读有关施放[spellname]的内容……"))

/obj/item/book/granter/spell/on_reading_finished(mob/user)
	to_chat(user, span_notice("我感觉自己已经掌握了足够的心得，能够施放[spellname]了！"))
	var/obj/effect/proc_holder/spell/S = new spell
	user.mind.AddSpell(S)
	user.log_message("learned the spell [spellname] ([S])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/spell/random
	icon_state = "random_book"

/obj/item/book/granter/spell/random/Initialize(mapload)
	. = ..()
	var/static/banned_spells = list(/obj/item/book/granter/spell/mimery_blockade)
	var/real_type = pick(subtypesof(/obj/item/book/granter/spell) - banned_spells)
	new real_type(loc)
	return INITIALIZE_HINT_QDEL

///ACTION BUTTONS///

/obj/item/book/granter/action
	var/granted_action
	var/actionname = "抓虫" //might not seem needed but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps

/obj/item/book/granter/action/already_known(mob/user)
	if(!granted_action)
		return TRUE
	for(var/datum/action/A in user.actions)
		if(A.type == granted_action)
			to_chat(user, span_warning("关于[actionname]的内容我早就全都懂了！"))
			return TRUE
	return FALSE

/obj/item/book/granter/action/on_reading_start(mob/user)
	to_chat(user, span_notice("我开始阅读有关[actionname]的内容……"))

/obj/item/book/granter/action/on_reading_finished(mob/user)
	to_chat(user, span_notice("我感觉自己已经把[actionname]掌握得相当不错了！"))
	var/datum/action/G = new granted_action
	G.Grant(user)
	onlearned(user)

//Crafting Recipe books

/obj/item/book/granter/crafting_recipe
	var/list/crafting_recipe_types = list()

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,span_notice("我学会了如何制作[initial(R.name)]。"))


/obj/item/book/granter/trait
	var/granted_trait = null
	var/required_language = null

/obj/item/book/granter/trait/attack_self(mob/living/user)
	if(required_language && !user.has_language(required_language))
		to_chat(user, span_warning("这本书里的文字我完全看不明白。"))
		return FALSE
	return ..()

/obj/item/book/granter/trait/already_known(mob/user)
	if(!granted_trait)
		return TRUE
	if(HAS_TRAIT(user, granted_trait))
		to_chat(user, span_warning("这些技法我已经会了！"))
		return TRUE
	return FALSE

/obj/item/book/granter/trait/on_reading_start(mob/user)
	to_chat(user, span_notice("我开始钻研其中的图示与书写技法……"))

/obj/item/book/granter/trait/on_reading_finished(mob/user)
	to_chat(user, span_notice("我感觉自己已经掌握了[name]中记述的技法。"))
	ADD_TRAIT(user, granted_trait, TRAIT_GENERIC)
	onlearned(user)


/obj/item/book/granter/trait/kazengunite_smith
	name = "风间锻造传书"
	desc = "一本磨损严重的风间锻造技法手册，满布图示与文字。封面印有Kouken流派的标记。需要懂得风间语才能解读。"
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "basic_book_0"
	granted_trait = TRAIT_KAZENGUNITE_SMITH
	required_language = /datum/language/kazengunese
	pages_to_mastery = 10
	remarks = list(
		"开篇章节讲述了玉钢的冶炼法：将富含铁质的砂矿缓缓投入粘土炉中，让炉火三昼夜不熄，炼出块炼钢。唯有如此，才称得上真正的风间钢。",
		"接下来一大段都在解释锻炼法：先将钢块打碎，按含碳量分类，再在锤下反复折叠。每折一次，层数便翻倍。书中警告不可过度折叠，因为次数太多反会烧掉工匠苦苦追求的品质。",
		"书里详细图解了甲伏锻法：以较硬的钢包裹较软的钢芯，再用锤锻焊合。硬刃负责持锋，软背负责吸震。两者缺一不可。",
		"另有数页专讲覆土工序，即淬火前将黏土与木炭调成的糊料涂在刀身上。刀背涂厚，刃口涂薄。正是这种差异冷却塑造了硬化区，也就是刃纹。",
		"关于烧入的记述尤为生动：刀身加热至不再吸附磁石后，便将刃口先行投入水中。作者告诫铁匠，要相信钢色，而非心跳的次数。",
		"护甲章节先从小札讲起：每一片甲片都不过拇指大小，却要在组装前反复打孔、上漆。书中特意强调，漆并非装饰，而是防锈的护甲。",
		"随后便是威毛的详细说明：用丝绳或皮绳把小札交错串连成排。这种编法能把冲击分散到整片甲面。作者指出，只要有一排系得不正，经不起一下重击便会垮掉。",
		"兜盔部分讲的是钵体的成形：以三角形钢板沿边铆接，再收出向上的峰形。每一枚铆钉都必须铆平后再上漆。只要有一颗翘起，便会勾住来刃。",
		"还有一段虽短却精确地讲解了籠手的结构：手背与手指处以小块长方钢板配合链甲铆接，手腕内侧则衬以软垫布料。钢铁只该保护真正需要保护的地方。",
		"最后一章论及护喉，即以细小链环配合加硬护领制成，并用丝绳在喉前系紧。作者说，这是最常被忽视的一件护具，也往往是最致命的疏漏。",
	)

//! --BLACKSTONE SCROLLS-- !/
/obj/item/book/granter/spell/blackstone/
	desc = "一卷蕴藏潜能的卷轴，唯有能解读其秘密之人方知其价值。"
	icon = 'icons/roguetown/items/misc.dmi'
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/book/granter/spell/blackstone/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		name = "被抽空的卷轴"
		desc = "这张卷轴曾写满魔法经文，如今其中知识已被他人抽走，表面空空如也。它已经毫无用处。"
		icon_state = "scroll"
		user.visible_message(span_warning("[src]上的魔法墨迹被硬生生抽离了！"))

/obj/item/book/granter/spell/blackstone/fireball
	name = "火球术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/fireball
	spellname = "火球术"
	icon_state ="scrollred"
	remarks = list("Ignis et oleum..", "Flammam continere ad momentum..", "Flammam iactare..", "Sit flamma constructum..")

/obj/item/book/granter/spell/blackstone/greaterfireball
	name = "高等火球术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/fireball/greater
	spellname = "高等火球术"
	icon_state ="scrollred"
	remarks = list("Ignis et oleum..", "Flammam continere ad momentum..", "Flammam iactare..", "Sit flamma constructum..")

/obj/item/book/granter/spell/blackstone/lightning
	name = "闪电术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt
	spellname = "闪电术"
	icon_state ="scrollyellow"
	remarks = list("Essentia fulgurum digitorum..", "Fulgur de nubibus desuper..", "Fulgur eiecit digitos..", "Praecipe intus aedificatur..")

/obj/item/book/granter/spell/blackstone/fetch
	name = "摄物术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/fetch
	spellname = "摄物术"
	icon_state ="scrollpurple"
	remarks = list("Returnus Revico..", "Manus de reverti..", "Menus de returnus..")

/obj/item/book/granter/spell/blackstone/invisibility
	name = "隐形术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/invisibility
	spellname = "隐形术"
	icon_state ="scrollpurple"
	remarks = list("Pallium nihilum..", "Occultare veritatem..", "Veritatem removan menor..")

/obj/item/book/granter/spell/blackstone/skeleton//BEWARE this is the super powerful LICH player skeleton spawner
	name = "唤骷卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/raise_undead
	spellname = "唤骷"
	icon_state ="scrolldarkred"
	remarks = list("Redi damnatos..", "Exitio ad Necram scriptor exolvuntur..", "Ossa in propinquus..")

/obj/item/book/granter/spell/blackstone/sicknessray
	name = "病蚀射线卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/sickness
	spellname = "病蚀射线"
	icon_state ="scrollgreen"
	remarks = list("Foe rubiginem meam..", "Pestilentia in terris..", "Trabes putrida..")

/obj/item/book/granter/spell/blackstone/bonechill
	name = "蚀骨寒意卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/bonechill
	spellname = "蚀骨寒意"
	icon_state ="scrolldarkred"
	remarks = list("Mediolanum ventis..", "Sana damnatorum..", "Frigidus ossa mortuorum..")

/obj/item/book/granter/spell/blackstone/acidsplash
	name = "酸液飞溅卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/acidsplash
	spellname = "酸液飞溅"
	icon_state ="scrolldarkred"
	remarks = list("Lapides corrodunt..", "Spuma venenosa..", "Guttae flavescentes..")

/obj/item/book/granter/spell/blackstone/spitfire
	name = "吐焰术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/spitfire
	spellname = "吐焰术"
	icon_state ="scrollred"
	remarks = list("Ignis et oleum..", "Flammam continere ad momentum..", "Flammam iactare..", "Sit flamma constructum..")

/obj/item/book/granter/spell/blackstone/lesserknock
	name = "次级开锁术卷轴"
	spell = /obj/effect/proc_holder/spell/targeted/touch/lesserknock
	spellname = "次级开锁术"
	icon_state ="scrollred"
	remarks = list("Clavis vetusta portam..", "Perdita numquam..", "Manus tremens..")

/obj/item/book/granter/spell/blackstone/repel
	name = "斥退术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/repel
	spellname = "斥退术"
	icon_state ="scrolldarkred"
	remarks = list("Ventos adversos..", "Terra sibilat..", "Lapides vetusti..")


/obj/item/book/granter/spell/blackstone/aerosolize
	name = "雾化术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/aerosolize
	spellname = "雾化术"
	icon_state ="scrolldarkred"
	remarks = list("Lapides corrodunt..", "Spuma venenosa..", "Guttae flavescentes..")


/obj/item/book/granter/spell/blackstone/guidance
	name = "指引术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/guidance
	spellname = "指引术"
	icon_state ="scrolldarkred"
	remarks = list("Lux in tenebris..", "Passus certus umbras non timet..", "Anima viam scit..")

/obj/item/book/granter/spell/blackstone/frostbolt
	name = "寒霜箭卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/frostbolt
	spellname = "寒霜箭"
	icon_state ="scrolldarkred"
	remarks = list("Gelum serpentibus..", "Crystallum in silentio..", "Nullum ardor glaciem..")

/obj/item/book/granter/spell/blackstone/fortitude
	name = "坚韧术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/fortitude
	spellname = "坚韧术"
	icon_state ="scrolldarkred"
	remarks = list("Animus in adversis..", "Gravitas oneris..", "Vita renascitur..")

/obj/item/book/granter/spell/blackstone/message
	name = "传讯术卷轴"
	spell = /obj/effect/proc_holder/spell/self/message
	spellname = "传讯术"
	icon_state ="scrolldarkred"
	remarks = list("Verba volant..", "Vincula inter mentes..", "Inter verba et silentium..")

/obj/item/book/granter/spell/blackstone/ensnare
	name = "缠缚术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/ensnare
	spellname = "缠缚术"
	icon_state ="scrolldarkred"
	remarks = list("Qui intrat..", "Radices in tenebris..", "Nexus occultus..")

/obj/item/book/granter/spell/blackstone/forcewall_weak
	name = "力墙术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/forcewall
	spellname = "力墙术"
	icon_state ="scrolldarkred"
	remarks = list("Murus non solum hostem..", "Manus invisibiles saxa invicem..", "Infracta moenia..")

/obj/item/book/granter/spell/blackstone/featherfall
	name = "羽落术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/featherfall
	spellname = "羽落术"
	icon_state ="scrolldarkred"
	remarks = list("In silentio cadit..", "Alis levitas..", "Plumis taciti dolores..")

/obj/item/book/granter/spell/blackstone/enlarge
	name = "巨化术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/enlarge
	spellname = "巨化术"
	icon_state ="scrolldarkred"
	remarks = list("Immensum agitur..", "Montes tremunt..", "Quantitas expanditur..")

/obj/item/book/granter/spell/blackstone/leap
	name = "腾跃术卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/leap
	spellname = "腾跃术"
	icon_state ="scrolldarkred"
	remarks = list("Altitudinem revelat..", "Cuius pedes in aere volant..", "In levitate audacia..")

/obj/item/book/granter/spell/blackstone/familiar //Find Familiar Scroll
	name = "寻得魔宠卷轴"
	spell = /obj/effect/proc_holder/spell/self/findfamiliar
	spellname = "寻得魔宠"
	icon_state ="scrolldarkred"
	oneuse = FALSE

/obj/item/book/granter/spell/blackstone/mirror_transform
	name = "镜像变形卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/mirror_transform
	spellname = "镜像变形"
	icon_state ="scrolldarkred"
	remarks = list("Aspectum rebis adopta..", "Fac me novum..", "Pulcher ero..")

//scroll for giving the reader 3 spell points, this should be dungeon loot
/obj/item/book/granter/spell_points
	name = "奥术洞见"
	icon_state = "scrollpurple"
	icon = 'icons/roguetown/items/misc.dmi'
	oneuse = TRUE
	var/spellpoints = 3
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/book/granter/spell_points/on_reading_finished(mob/user)
	var/arcaneskill = user.get_skill_level(/datum/skill/magic/arcane)
	if(arcaneskill >= SKILL_LEVEL_NOVICE) //Required arcane skill of NOVICE or higher to use the granter
		to_chat(user, span_notice("我吸收了卷轴中的感悟，感觉自己对施法更娴熟了！"))
		user.mind.adjust_spellpoints(spellpoints)
		onlearned(user)
	else
		to_chat(user, span_notice("我完全弄不明白这上面写了什么。"))

/obj/item/book/granter/spell_points/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		name = "被抽空的卷轴"
		desc = "这张卷轴曾写满魔法经文，如今其中知识已被他人抽走，表面空空如也。它已经毫无用处。"
		icon_state = "scroll"
		user.visible_message(span_warning("[src]上的魔法墨迹被硬生生抽离了！"))

/obj/item/book/granter/spell_points/voiddragon
	name = "虚空奥术洞见"
	spellpoints = 6

/obj/item/book/granter/spell/blackstone/skeleton/lesser
	name = "次级唤骷卷轴"
	spell = /obj/effect/proc_holder/spell/invoked/raise_undead_formation
	spellname = "次级唤骷"
	icon_state ="scrolldarkred"
	remarks = list("Redi damnatos..", "Exitio ad Necram scriptor exolvuntur..", "Ossa in propinquus..")
