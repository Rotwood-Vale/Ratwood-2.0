/obj/item/rogueore
	name = "矿石"
	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ore"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	experimental_inhand = FALSE
	grid_width = 64
	grid_height = 32

/obj/item/rogueore/gold
	name = "金矿石"
	desc = "一团沾满泥土却依旧闪亮的金色矿块！"
	icon_state = "oregold1"
	smeltresult = /obj/item/ingot/gold
	sellprice = 10

/obj/item/rogueore/gold/Initialize(mapload)
	icon_state = "oregold[rand(1,3)]"
	..()


/obj/item/rogueore/silver
	name = "银矿石"
	desc = "一块泛着月光色泽的闪亮矿石。"
	icon_state = "oresilv1"
	smeltresult = /obj/item/ingot/silver
	sellprice = 8

/obj/item/rogueore/silver/Initialize(mapload)
	icon_state = "oresilv[rand(1,3)]"
	..()


/obj/item/rogueore/iron
	name = "铁矿石"
	desc = "一块深色而坚实的矿石。"
	icon_state = "oreiron1"
	smeltresult = /obj/item/ingot/iron
	sellprice = 5

/obj/item/rogueore/iron/Initialize(mapload)
	icon_state = "oreiron[rand(1,3)]"
	..()


/obj/item/rogueore/copper
	name = "铜矿石"
	desc = "一块泛着暗红光泽的磨亮矿石。"
	icon_state = "orecop1"
	smeltresult = /obj/item/ingot/copper
	sellprice = 3

/obj/item/rogueore/copper/Initialize(mapload)
	icon_state = "orecop[rand(1,3)]"
	..()

/obj/item/rogueore/tin
	name = "锡矿石"
	desc = "一团柔软得近乎可塑的白色矿石。"
	icon_state = "oretin1"
	smeltresult = /obj/item/ingot/tin
	sellprice = 4

/obj/item/rogueore/tin/Initialize(mapload)
	icon_state = "oretin[rand(1,3)]"
	..()

/obj/item/rogueore/coal
	name = "煤炭"
	desc = "漆黑的块状燃料，终会化作闷烧的余烬。"
	icon_state = "orecoal1"
	firefuel = 30 MINUTES
	smeltresult = /obj/item/rogueore/coal
	sellprice = 1

//Dolls/Constructs eating coal for fuel.
/obj/item/rogueore/coal/attack(mob/living/M, mob/user)
	testing("attack")
	if(!user.cmode)

		if(M.construct)//This is slop. Why do we use this?
			if(M == user)
				user.visible_message(span_notice("[user]将[src]贴在[user.p_their()]的躯架上并将其吸收。"), span_notice("我吸收了[src]，感到能量重新回流。"))
			else
				user.visible_message(span_notice("[user]试图将[src]按向[M]。"), span_notice("我试图将[src]按向[M]。"))
				if(!do_mob(user, M, 30))
					return
				user.visible_message(span_notice("[user]将[src]按在了[M]身上。"), span_notice("我将[src]按在了[M]身上。"))
				to_chat(M, span_notice("我吸收了[src]，感到能量重新回流。"))
			M.energy_add(250)
			playsound(M.loc,'sound/items/flint.ogg', rand(30,60), TRUE)
			qdel(src)

		else
			return ..()
	else
		return ..()

/obj/item/rogueore/coal/Initialize(mapload)
	icon_state = "orecoal[rand(1,3)]"
	..()

/obj/item/rogueore/coal/charcoal
	name = "木炭"
	icon_state = "oreada"
	desc = "木材燃烧后转化而成的木炭。可以用来生火，也可以用来冶炼铁器。"
	dropshrink = 0.8
	color = "#929292"
	firefuel = 15 MINUTES
	smeltresult = /obj/item/rogueore/coal/charcoal
	sellprice = 1

/obj/item/rogueore/cinnabar
	name = "辰砂"
	desc = "蕴藏着水银精华的红色矿晶。"
	icon_state = "orecinnabar"
	grind_results = list(/datum/reagent/mercury = 15)
	sellprice = 5

/obj/item/ingot
	name = "锭块"
	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ingot"
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = null
	resistance_flags = FIRE_PROOF
	smelted = TRUE
	var/datum/anvil_recipe/currecipe
	var/quality = SMELTERY_LEVEL_NORMAL
	grid_width = 64
	grid_height = 32
	dropshrink = 0.8

/obj/item/ingot/examine()
	. += ..()
	if(currecipe)
		. += "<span class='warning'>它当前正被加工成[currecipe.name]。</span>"

/obj/item/ingot/Initialize(mapload, smelt_quality)
	. = ..()
	if(!smelt_quality)
		return
	quality = smelt_quality
	switch(quality)
		if(SMELTERY_LEVEL_SPOIL)
			name = "报废的[name]"
			desc += " 它几乎就是一堆废料。"
			sellprice *= 0.5
		if(SMELTERY_LEVEL_POOR)
			name = "劣质[name]"
			desc += " 它的品质相当可疑。" // EA NASSIR, WHEN I GET YOU...
			sellprice *= 0.8
		if(SMELTERY_LEVEL_GOOD)
			name = "优质[name]"
			desc += " 它的品质颇为出众。"
			sellprice *= 1.1
		if(SMELTERY_LEVEL_GREAT)
			name = "精良[name]"
			desc += " 它的品质相当卓越，足以胜任更具野心的用途。"
			sellprice *= 1.2
		if(SMELTERY_LEVEL_EXCELLENT)
			name = "卓越[name]"
			desc += " 它的品质精妙绝伦，简直[pick("渴望着","央求着","要求着")]被铸造成一件杰作。"
			sellprice *= 1.3

/obj/item/ingot/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/tongs))
		var/obj/item/rogueweapon/tongs/T = I
		if (loc in user.contents)
			to_chat(user, span_warning("我没法把[src]从里面取出来。"))
			return
		if(!T.hingot)
			forceMove(T)
			T.hingot = src
			T.hott = null
			T.update_icon()
			return
	..()

/obj/item/ingot/Destroy()
	if(currecipe)
		QDEL_NULL(currecipe)
	if(istype(loc, /obj/machinery/anvil))
		var/obj/machinery/anvil/A = loc
		A.current_workpiece = null
		A.update_icon()
	..()

/obj/item/ingot/gold
	name = "金锭"
	desc = "沉甸甸的财富，就握在你手中。"
	icon_state = "ingotgold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 100

/obj/item/ingot/iron
	name = "铁锭"
	desc = "锻成的力量，制作时不可或缺。"
	icon_state = "ingotiron"
	smeltresult = /obj/item/ingot/iron
	sellprice = 15

/obj/item/ingot/copper
	name = "铜锭"
	desc = "触碰这块锭时，会感到一阵轻微的刺痒。"
	icon_state = "ingotcop"
	smeltresult = /obj/item/ingot/copper
	sellprice = 10

/obj/item/ingot/tin
	name = "锡锭"
	desc = "一块异常柔软、近乎可塑的金属锭。"
	icon_state = "ingottin"
	smeltresult = /obj/item/ingot/tin
	sellprice = 15

/obj/item/ingot/bronze
	name = "青铜锭"
	desc = "一种坚硬耐久的合金，深受工程师与 拉沃克斯 信徒喜爱。"
	icon_state = "ingotbronze"
	smeltresult = /obj/item/ingot/bronze
	sellprice = 25

/obj/item/ingot/silver
	name = "银锭"
	desc = "这块锭散发着纯净气息，为诸国所珍视。"
	icon_state = "ingotsilv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 80

/obj/item/ingot/steel
	name = "钢锭"
	desc = "这块钢锭宛如王国坚定不移的卫士。"
	icon_state = "ingotsteel"
	smeltresult = /obj/item/ingot/steel
	sellprice = 20

/obj/item/ingot/blacksteel
	name = "黑钢锭"
	desc = "它舍弃了银所具备的圣洁特质，只为换取纯粹力量；这块奇异而强大的锭块，其来源伴随着黑暗流言。"
	icon_state = "ingotblacksteel"
	smeltresult = /obj/item/ingot/blacksteel
	sellprice = 100

//Blessed Ingots
/obj/item/ingot/steelholy/
	name = "圣钢锭"
	desc = "这块钢锭曾受 玛勒姆 触碰。即使不在熔炉中，它也在持续散发热量。"
	icon_state = "ingotsteelholy"
	smeltresult = /obj/item/ingot/steel //Smelting it removes the blessing
	sellprice = 20

/obj/item/ingot/silverblessed/
	name = "祝圣银锭"
	desc = "这块锭散发着神圣的纯净气息，为诸国所珍视，也常见于 普赛顿式 武装之中。"
	icon_state = "ingotsilvblessed"
	smeltresult = /obj/item/ingot/silver //Smelting it removes the blessing
	sellprice = 100

/obj/item/ingot/silverblessed/bullion
	name = "祝圣银条"
	desc = "这块银条散发着神圣的纯净气息。表面的 普赛圣十字 与铸字表明，它出自 奥塔万 宗教裁判所。"
	icon_state = "ingotsilvblessed_psy"
	smeltresult = /obj/item/ingot/silver //Smelting it removes the blessing
	sellprice = 100

/obj/item/ingot/decrepit
	name = "朽败锭"
	desc = "一块朽败的锻造青铜板，触感冷得令人不适。握得足够久时，风声会化作低语：‘野心命令牺牲’。"
	icon_state = "ingotancient"
	smeltresult = /obj/item/ingot/aaslag
	color = "#bb9696"
	sellprice = 33

/obj/item/ingot/gilbranze
	name = "吉尔青铜锭"
	desc = "一种由黄金与青铜构成的永恒合金，因此得名吉尔青铜。它表面的倒影并不是你自己；那张脸正带着永恒的恶意朝你微笑。"
	icon_state = "ingotancient"
	smeltresult = /obj/item/ingot/gilbranze
	sellprice = 111

/obj/item/ingot/gilbranze/eahasir
	name = "艾亚-哈希尔 高品质金锭"
	desc = "沉甸甸的财富就在你手中......等等，这根本不是金子！"

/obj/item/ingot/aaslag
	name = "闪光炉渣"
	desc = "一团锻造青铜，在熔炉高热下彻底废掉了。有时候，死了反而更好。"
	icon_state = "ancientslag"
	smeltresult = /obj/item/ingot/aaslag
	sellprice = 1

//Anomalous Smeltings
/obj/item/ingot/weeping
	name = "恒久锭"
	desc = "一块历经岁月、毫无修饰的金属板。你终于知道它是什么了，却找不到任何词语来描述它。 </br>'..无人会真正知晓最伟大的真相；永世 的掌控，阿多奈 的存在，以及 普赛顿 的命运..' </br>'..但也许，这样反而更好。病灶虽已消散，可这世上的邪恶依旧真实存在..' </br>'..去设法让残骸获得新的 lyfe；一具或许仍能令 大魔君 落泪的新容器..'"
	icon_state = "ingotsilv"
	smeltresult = /obj/item/ingot/weeping
	color = "#CECA9C"
	sellprice = 222

/obj/item/ingot/weeping/Initialize(mapload)
	. = ..()
	filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(64,65),rand(1,5),rand(1,5)))

/obj/item/ingot/draconic
	name = "龙铸锭"
	desc = "一块噼啪作响、充盈着能量的黑曜石板。它玻璃般的表面持续辐出骇人高热，令你的手指灼起水泡。 </br>'..无论圣徒还是罪人，都无法真正承受这等力量..' </br>'..但也许，你是不同的..' </br>'..去设法让残骸获得新的 lyfe；一具或许仍能令 大魔君 落泪的新容器..'"
	icon_state = "ingotblacksteel"
	smeltresult = /obj/item/ingot/draconic
	color = "#70b8ff"
	sellprice = 333
