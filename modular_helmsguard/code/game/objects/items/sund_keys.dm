// This file is for creating custom keys that will belong to the Sundmark map. Use sund_ as the prefix to all lockids made here and on the Sundmark map.
// Each faction will have its own keys so this anticipates the overlap we would otherwise have, that is, orc keys unlocking human doors.


// Sundmark's clockwork key replaces the old Master key with something with an in-world logic.

/obj/item/roguekey/sund/clockwork
	name = "发条钥匙"
	desc = "一把精巧绝伦的矮人钥匙，以巧妙机括制成，靠弹簧与发条的精妙构造几乎能开启任何门扉或箱柜。"
	icon_state = "bosskey"
	lockid = "sund_clockwork"

// This sets the clockwork key's lockhash to whatever closet or mineral_door it is used on. Note this doesn't work on machines, etc.

/obj/item/roguekey/sund/clockwork/pre_attack(target, user, params)
	. = ..()
	if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/C = target
		if(C.masterkey)
			lockhash = C.lockhash
	if(istype(target, /obj/structure/mineral_door))
		var/obj/structure/mineral_door/D = target
		if(D.masterkey)
			lockhash = D.lockhash

// The merchant key unlocks the merchantvend. Merchantvend lockid is set in machine's code; do not sund_ the lockid UNLESS we need multiple machines on multiple maps.

/obj/item/roguekey/sund/sund_merchant
	name = "廉价镀金钥匙"
	desc = "贪婪与盘剥早已磨去了它曾有的那点光彩。"
	icon_state = "cheesekey"
	lockid = "merchant" // DO NOT TOUCH

// The nightman key unlocks the bathvend and drugmachine. Their lockid is set in their code, see above.

/obj/item/roguekey/sund/sund_nightman
	name = "廉价黄铜钥匙"
	desc = "污损又磕碰累累，这把钥匙连最后那点体面也已黯淡无光。"
	icon_state = "cheesekey"
	lockid = "nightman" // DO NOT TOUCH

// Castle and Retinue keys.

/obj/item/roguekey/sund/sund_ruler
	name = "城主钥匙"
	desc = "这把钥匙上以金饰镌着桑德马克的纹章。"
	icon_state = "bosskey"
	lockid = "sund_ruler"

/obj/item/roguekey/sund/sund_family
	name = "饰纹钥匙"
	desc = "这把钥匙上饰有城主家族的徽记。"
	icon_state = "bosskey"
	lockid = "sund_family"

/obj/item/roguekey/sund/sund_secret
	name = "精致镀金钥匙"
	desc = "戴着手套的轻柔双手未曾磨损它表面的金箔。"
	icon_state = "cheesekey"
	lockid = "sund_secret"

/obj/item/roguekey/sund/sund_steward
	name = "沉重金钥匙"
	desc = "这把奢华的钥匙因黄铜柄上那颗纯金匙首而分外沉重。"
	icon_state = "cheesekey"
	lockid = "sund_steward"

/obj/item/roguekey/sund/sund_noble
	name = "鹿角钥匙"
	desc = "某头高贵雄鹿的鹿角装点着这把精巧的黄铜钥匙。"
	icon_state = "hornkey"
	lockid = "sund_noble"

/obj/item/roguekey/sund/sund_knight
	name = "闪亮钥匙"
	desc = "这把钥匙由粗犷钢材打磨出银亮光泽而成。"
	icon_state = "ekey"
	lockid = "sund_knight"

/obj/item/roguekey/sund/sund_castle
	name = "铸铁钥匙"
	desc = "这把钥匙做工廉价却结实耐用，想必还有一大群一模一样的兄弟。"
	icon_state = "rustkey"
	lockid = "sund_castle"

/obj/item/roguekey/sund/sund_arms
	name = "黑铁钥匙"
	desc = "这把铁钥匙上泛着硬蜂蜡的光泽，以防其锈蚀。"
	icon_state = "rustkey"
	lockid = "sund_arms"

/obj/item/roguekey/sund/sund_butler
	name = "白镴钥匙"
	desc = "这把钥匙由朴素的白镴制成，却被细心擦拭得干干净净。"
	icon_state = "ekey"
	lockid = "sund_butler"

/obj/item/roguekey/sund/sund_ladymaid
	name = "亮银钥匙"
	desc = "这把精美的银钥匙上没有半点失色污痕。"
	icon_state = "ekey"
	lockid = "sund_ladymaid"

/obj/item/roguekey/sund/sund_servant
	name = "失色青铜钥匙"
	desc = "这泛着青绿的青铜仿佛和城堡深处一样古老而疲惫。"
	icon_state = "greenkey"
	lockid = "sund_servant"

// Watch keys.

/obj/item/roguekey/sund/sund_watch
	name = "沉重青铜钥匙"
	desc = "这把粗犷的钥匙上带有卫队的印记。"
	icon_state = "mazekey"
	lockid = "sund_watch"

/obj/item/roguekey/sund/sund_gaol
	name = "血锈钥匙"
	desc = "这把钥匙显然属于某个苦难之地。"
	icon_state = "rustkey"
	lockid = "sund_gaol"

/obj/item/roguekey/sund/sund_wall
	name = "朴素青铜钥匙"
	desc = "这把钥匙结实耐用、磨损明显，其上带有桑德马克的城镇印记。"
	icon_state = "brownkey"
	lockid = "sund_wall"

// Church keys.

/obj/item/roguekey/sund/sund_priest
	name = "十字形钥匙"
	desc = "这把钥匙的匙柄由金色的凡俗十字构成。"
	icon_state = "bosskey"
	lockid = "sund_priest"

/obj/item/roguekey/sund/sund_church
	name = "抛光黄铜钥匙"
	desc = "这把钥匙材质朴素，却被主人打理得十分妥帖。"
	icon_state = "cheesekey"
	lockid = "sund_church"

/obj/item/roguekey/sund/sund_churchm
	name = "朴素铜钥匙"
	desc = "这把小钥匙还没有男人的一根手指长。"
	icon_state = "brownkey"
	lockid = "sund_churchm"

/obj/item/roguekey/sund/sund_churchf
	name = "小巧铜钥匙"
	desc = "这把纤小钥匙还没有女士的一根拇指长。"
	icon_state = "rustkey"
	lockid = "sund_churchf"

/obj/item/roguekey/sund/sund_inquisitor
	name = "山羊角钥匙"
	desc = "左行之路，向下之路。"
	icon_state = "rustkey"
	lockid = "sund_inquisitor"

// Chapter House Keys

/obj/item/roguekey/sund/sund_chapmaster
	name = "十字封印钥匙"
	desc = "这把明亮的黄铜钥匙上印着礼拜堂长的封印。"
	icon_state = "cheesekey"
	lockid = "sund_chapmaster"

/obj/item/roguekey/sund/sund_chapter
	name = "结实青铜钥匙"
	desc = "这把厚实的钥匙由坚实却失色的青铜打造而成。"
	icon_state = "greenkey"
	lockid = "sund_chapter"

/obj/item/roguekey/sund/sund_chapterm
	name = "厚重青铜钥匙"
	desc = "这是教堂的总钥匙。"
	icon_state = "greenkey"
	lockid = "sund_chapterm"

/obj/item/roguekey/sund/sund_chapterf
	name = "雅致青铜钥匙"
	desc = "这把钥匙做工精良，只是握柄略显纤细。"
	icon_state = "greenkey"
	lockid = "sund_chapterf"

// Merchants and Shops

/obj/item/roguekey/sund/sund_shop
	name = "暗银钥匙"
	desc = "虽然由上好金属制成，这把钥匙摸起来却带着一股油腻感。"
	icon_state = "ekey"
	lockid = "sund_shop"

/obj/item/roguekey/sund/sund_smith
	name = "锻铁钥匙"
	desc = "这把锤锻而成的钥匙有着扭曲的匙柄与繁复铁饰。"
	icon_state = "rustkey"
	lockid = "sund_smith"

/obj/item/roguekey/sund/sund_tailor
	name = "缎带钥匙"
	desc = "这把钥匙的握柄上系着一条白色缎带。"
	icon_state = "hornkey"
	lockid = "sund_tailor"

/obj/item/roguekey/sund/sund_apoth
	name = "染痕黄铜钥匙"
	desc = "这把钥匙散发着烟气与草药的味道。"
	icon_state = "cheesekey"
	lockid = "sund_apoth"

/obj/item/roguekey/sund/sund_butcher
	name = "牛角钥匙"
	desc = "雕刻过的牛角装饰着这把钥匙的匙首。"
	icon_state = "hornkey"
	lockid = "sund_butcher"

/obj/item/roguekey/sund/sund_innkeep
	name = "雕鹿角钥匙"
	desc = "一小段雕刻过的鹿角让这把钥匙摸起来格外独特。"
	icon_state = "hornkey"
	lockid = "sund_innkeep"

/obj/item/roguekey/sund/sund_inn
	name = "暗铜钥匙"
	desc = "这把钥匙上沾着油脂与煤灰。"
	icon_state = "brownkey"
	lockid = "sund_inn"

/obj/item/roguekey/sund/sund_parlor
	name = "亮铜钥匙"
	desc = "这把钥匙干净体面，保养得很好，几乎没有经年磨损。"
	icon_state = "brownkey"
	lockid = "sund_parlor"

/obj/item/roguekey/sund/sund_bawdymaster
	name = "华饰黑钥匙"
	desc = "这把黑色钥匙握在手里，沉得像一个见不得光的秘密。"
	icon_state = "mazekey"
	lockid = "sund_bawdymaster"

/obj/item/roguekey/sund/sund_bawdy
	name = "污秽黑钥匙"
	desc = "这把钥匙脏污得彻底，似乎再也洗不干净了。"
	icon_state = "rustkey"
	lockid = "sund_bawdy"

/obj/item/roguekey/sund/sund_bawdyroom
	name = "闪亮黄铜钥匙"
	desc = "这种二流金属被人拼命擦洗过，好让它看起来比实际更体面。"
	icon_state = "cheesekey"
	lockid = "sund_bawdyroom"

// Inn rooms.

/obj/item/roguekey/sund/sund_innroom1
	name = "I号钥匙"
	desc = "这把朴素的钥匙上刻着数字“I”。"
	icon_state = "brownkey"
	lockid = "sund_innroom1"

/obj/item/roguekey/sund/sund_innroom2
	name = "II号钥匙"
	desc = "这把朴素的钥匙上刻着数字“II”。"
	icon_state = "brownkey"
	lockid = "sund_innroom2"

/obj/item/roguekey/sund/sund_innroom3
	name = "III号钥匙"
	desc = "这把朴素的钥匙上刻着数字“III”。"
	icon_state = "brownkey"
	lockid = "sund_innroom3"

/obj/item/roguekey/sund/sund_innroom4
	name = "IV号钥匙"
	desc = "这把朴素的钥匙上刻着数字“IV”。"
	icon_state = "brownkey"
	lockid = "sund_innroom4"

/obj/item/roguekey/sund/sund_innroom5
	name = "V号钥匙"
	desc = "这把朴素的钥匙上刻着数字“V”。"
	icon_state = "brownkey"
	lockid = "sund_innroom5"

/obj/item/roguekey/sund/sund_innroom6
	name = "VI号钥匙"
	desc = "这把朴素的钥匙上刻着数字“VI”。"
	icon_state = "brownkey"
	lockid = "sund_innroom6"

/obj/item/roguekey/sund/sund_innroom7
	name = "VII号钥匙"
	desc = "这把朴素的钥匙上刻着数字“VII”。"
	icon_state = "brownkey"
	lockid = "sund_innroom7"


// Town Houses

/obj/item/roguekey/sund/sund_house1
	name = "屋舍I号钥匙"
	desc = "这把家常钥匙上刻着数字“I”。"
	icon_state = "greenkey"
	lockid = "sund_house1"

/obj/item/roguekey/sund/sund_house2
	name = "屋舍II号钥匙"
	desc = "这把家常钥匙上刻着数字“II”。"
	icon_state = "greenkey"
	lockid = "sund_house2"

/obj/item/roguekey/sund/sund_house3
	name = "屋舍III号钥匙"
	desc = "这把家常钥匙上刻着数字“III”。"
	icon_state = "greenkey"
	lockid = "sund_house3"

/obj/item/roguekey/sund/sund_house4
	name = "屋舍IV号钥匙"
	desc = "这把家常钥匙上刻着数字“IV”。"
	icon_state = "greenkey"
	lockid = "sund_house4"

/obj/item/roguekey/sund/sund_house5
	name = "屋舍V号钥匙"
	desc = "这把家常钥匙上刻着数字“V”。"
	icon_state = "greenkey"
	lockid = "sund_house5"

/obj/item/roguekey/sund/sund_house6
	name = "屋舍VI号钥匙"
	desc = "这把家常钥匙上刻着数字“VI”。"
	icon_state = "greenkey"
	lockid = "sund_house6"

/obj/item/roguekey/sund/sund_house7
	name = "屋舍VII号钥匙"
	desc = "这把家常钥匙上刻着数字“VII”。"
	icon_state = "greenkey"
	lockid = "sund_house7"

/obj/item/roguekey/sund/sund_house8
	name = "屋舍VIII号钥匙"
	desc = "这把家常钥匙上刻着数字“VIII”。"
	icon_state = "greenkey"
	lockid = "sund_house8"

/obj/item/roguekey/sund/sund_house9
	name = "屋舍IX号钥匙"
	desc = "这把家常钥匙上刻着数字“IX”。"
	icon_state = "greenkey"
	lockid = "sund_house9"

/obj/item/roguekey/sund/sund_house10
	name = "屋舍X号钥匙"
	desc = "这把家常钥匙上刻着数字“X”。"
	icon_state = "greenkey"
	lockid = "sund_house10"

// Farms and other tenancies.

/obj/item/roguekey/sund/sund_westfarm
	name = "鸡首青铜钥匙"
	desc = "这把钥匙结实而磨损明显，匙首被铸成了一只母鸡的形状。"
	icon_state = "brownkey"
	lockid = "sund_westfarm"

/obj/item/roguekey/sund/sund_eastfarm
	name = "牛首青铜钥匙"
	desc = "这把钥匙结实而磨损明显，匙首被铸成了一头公牛的形状。"
	icon_state = "brownkey"
	lockid = "sund_eastfarm"
