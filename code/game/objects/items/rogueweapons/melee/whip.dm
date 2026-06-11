/obj/item/rogueweapon/whip
	force = 21
	possible_item_intents = list(/datum/intent/whip/lash, /datum/intent/whip/crack, /datum/intent/whip/punish)
	name = "皮鞭"
	desc = "一条皮制长鞭，末端系着打制燧石。它本是拿来驱赶不听话牲畜的，可那锯齿般的尖端同样足以在袭击者身上留下可怖裂伤。"
	icon_state = "whip"
	icon = 'icons/roguetown/weapons/whips32.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.75
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BELT
	associated_skill = /datum/skill/combat/whipsflails
	sewrepair = TRUE //Whips are mostly leather, with only a bit of metal or stone at the end. Should hopefully make more sense.
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = WHIPWOOSH
	throwforce = 5
	wdefense = 0
	minstr = 6
	grid_width = 32
	grid_height = 64
	special = /datum/special_intent/whip_coil
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/whip/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//Lash = default, can't dismember, so more range and some pen.
/datum/intent/whip/lash
	name = "鞭挞"
	blade_class = BCLASS_LASHING
	attack_verb = list("鞭挞", "抽裂")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 7
	penfactor = 30
	reach = 3
	icon_state = "inlash"
	item_d_type = "slash"

//Crack = cut damage, can dismember, so lower range.
/datum/intent/whip/crack
	name = "裂击"
	blade_class = BCLASS_CUT				//Lets you dismember
	attack_verb = list("抽裂", "击打") //something something dwarf fotresss
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 10
	damfactor = 1.1
	penfactor = 20
	reach = 2
	icon_state = "incrack"
	item_d_type = "slash"

//Punish = Non-lethal sorta damage.
/datum/intent/whip/punish
	name = "惩戒"
	blade_class = BCLASS_PUNISH
	attack_verb = list("鞭挞", "抽裂")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 5
	damfactor = 1.2							//No range, gets bonus damage - using this even on weak SHOULD let you get perma-scars then.
	penfactor = BLUNT_DEFAULT_PENFACTOR		//No pen cus punishment intent.
	reach = 1								//No range, cus not meant to be a flat-out combat intent.
	icon_state = "inpunish"
	item_d_type = "slash"

//Holy Lash = 1:1 to the Lash, but permits dismemberment. Partially functions like the original whip. Keep this restricted to whips with high strength requirements and alloyed tips.
/datum/intent/whip/lash/holy
	name = "圣鞭"
	blade_class = BCLASS_CUT
	attack_verb = list("鞭挞", "抽裂")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 7
	penfactor = 30 // Total AP potential of 53-55, discounting strength bonuses. Will likely penetrate non-slash resistant light armor, but fail to chunk through maille and plate.
	reach = 3
	icon_state = "inlash"
	item_d_type = "slash"

//Ranged mace-like mode - merc unique for Nagaika (steppesman)
/datum/intent/whip/crack/blunt
	name = "钝击"
	blade_class = BCLASS_BLUNT
	penfactor = BLUNT_DEFAULT_PENFACTOR
	recovery = 6
	reach = 2			//Less range than a normal whip by 1 compared to crack.
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/obj/item/rogueweapon/whip/nagaika
	name = "纳盖卡鞭"
	desc = "一条短而沉重的皮鞭，配有钝头加固的鞭梢和更长的握柄。"
	icon_state = "nagaika"
	force = 25		//Same as a cudgel/sword for intent purposes. Basically a 2 range cudgel while one-handing.
	possible_item_intents = list(/datum/intent/whip/crack/blunt, /datum/intent/whip/lash, /datum/intent/sword/strike)
	wdefense = 1	//Akin to a cudgel, still terrible at parrying though. Better than nothing I guess; thing is used irl as a counter-weapon to knives.

/obj/item/rogueweapon/whip/xylix
	name = "咯笑之鞭"
	desc = "据说这条鞭子鸣响时，听起来就像戏弄者本人的笑声。"
	icon_state = "xylixwhip"
	force = 24

/obj/item/rogueweapon/whip/antique
	name = "Repenta En"
	desc = "一条保养得极好的多尾鞭。那鎏金握柄先以异乎寻常的重量压住手掌，继而又让心头浮起一阵不安的明悟：这绝不是荣誉之器。 </br>“拉沃克斯捍卫的是正义，而非谋杀。”"
	force = 25
	minstr = 11
	icon_state = "gwhip"

/obj/item/rogueweapon/whip/antique/psywhip
	name = "“破晓”"
	desc = "一条链节相扣的长鞭，由上百片受祝圣的白银精心拼接而成。它的来历浸透了神话色彩：多数人相信它源自某支古老的吸血鬼猎人血脉，那一族曾从一位强大的 Lyckerlorde 手中拯救了普赛顿尼亚。至于究竟是偶然还是命运本身，才最终让它落入你手中，还是不要深究为好。 </br>“在大教堂的穹顶之上，曾绘着一幕极美的景象：披袍的普赛顿立于大魔之前，以燃火长鞭一击裂开夜空。正如祂曾做到的那样，如今你也必须将曙光带入黑暗。”"
	icon_state = "psywhip"
	is_silver = TRUE
	force = 25
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish)
	minstr = 12
	wdefense = 0
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/silver
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/whip/antique/psywhip/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 0,\
	)

/obj/item/rogueweapon/whip/silver
	name = "银鞭"
	desc = "一条分量十足的银制长鞭。舒展开来的皮鞭末端嵌着白银倒刺，能在相当惊人的距离外撕开污秽之物。 </br>“去死吧，怪物！这个世界不属于你！”"
	icon_state = "silverwhip"
	force = 23 //Experimental change - adds a +2 to force, as a bridge between handweapons and blunt weapons. Higher strength minimum. Do not raise above 25, unless you want to resurrect maille-shatterers.
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish)
	minstr = 12 //Locks 100% effectiveness - and partially disables ranged dismemberment - unless you either have a +2 STR statpack or are a dedicated melee combatant.
	wdefense = 0
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/whip/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/whip/psywhip_lesser
	name = "普赛顿长鞭"
	desc = "一条装饰华美的长鞭，表面覆有礼仪性的银层薄镀。只需甩响皮鞭，便可看着叛教者仓皇退散。"
	icon_state = "psywhip_lesser"
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish)
	force = 23
	minstr = 6 // makes it so psyaltrist can actually use it properly
	wdefense = 0
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/whip/psywhip_lesser/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/whip/spiderwhip
	name = "鞭吻"
	desc = "一条卓尔长鞭，以深红绳索编成，末端装着一枚凶相毕露的黑钢刃片。握柄上还有金属护拳，正适合狠狠干在地表住民的下巴上。"
	icon_state = "spiderwhip"
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish, /datum/intent/dagger/sucker_punch) // sucker as a little flavor and bonus. 
	force = 22
	minstr = 10 //meant for a medium armor mounted soldier. With the +2 from the drow merc statspread, it should cover most statpack silliness save for Wary.  

/obj/item/rogueweapon/whip/bronze
	name = "青铜鞭"
	desc = "一条沉重长鞭，以厚实皮革绞成，末端饰有锋锐无比的青铜鞭头。在古老年代，这件牧人的武器曾用来逼退嗜血夜兽的獠牙；而如今，它只会伴着雷鸣般的爆响将肢体与躯干分离。 </br>握住这条鞭子，会让你心中涌起决意……以及一种相当古怪的、想吃火鸡大餐的冲动。"
	icon_state = "silverwhip"
	force = 21 //Same damage as the leathers.
	color = "#f9d690"
	minstr = 13 //Dodgemasters need-not apply. Intended for the 'Belmont'-esque archetype of Barbarians, and greatly punishes those who would try and take it for the sake of non-thematic cheesing.
	wdefense = 0
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish) //Able to dismember at range. 'Holy' is a catchall term, in this case.
	smeltresult = /obj/item/ingot/bronze
	wbalance = WBALANCE_HEAVY
