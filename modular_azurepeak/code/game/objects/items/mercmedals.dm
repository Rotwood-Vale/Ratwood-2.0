/obj/item/merctoken
	name = "嘉奖状"
	desc = "一卷小巧到足以置于掌中的装订卷轴，是授予王国佣兵的嘉奖文书。"
	icon_state = "merctoken"
	icon = 'modular_azurepeak/icons/clothing/mercmedals.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.5
	firefuel = 30 SECONDS
	sellprice = 2
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	var/signee = null
	var/signeejob = null
	var/signed = 0

/obj/item/merctoken/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!user.can_read(src))
			to_chat(user, "<span class='warning'>就算识字之人也会觉得这些词句难以理解。</span>")
			return
		if(signed == 1)
			to_chat(user, "<span class='warning'>这份文书已经签过名了。</span>")
			return
		if(user.can_read(src))
			if(user.mind.assigned_role == "Mercenary")
				to_chat(user, "<span class='warning'>......我竟然已经沦落到给自己的嘉奖状签名了吗？</span>")
				return
			if(user.mind.assigned_role != "Mercenary") // AZURE: anyone can hire a mercenary
				signee = user.real_name
				signeejob = user.mind.assigned_role
				visible_message("<span class='warning'>[user]在凭证上写下了自己的名字。</span>")
				playsound(src, 'sound/items/write.ogg', 100, FALSE)
				desc = "一卷小巧到足以置于掌中的装订卷轴，可通过邮递送往公会。大部分细则都难以辨认，唯有一行粗体签署人清晰可见：[signee]，[signeejob]，王国所属。"
				signed = 1
				return
		else
			if(signed == 0)
				to_chat(user, "<span class='warning'>这东西可以用羽笔签署......若实在没办法，用刺也行。</span>")
				return
			return


/obj/item/clothing/neck/roguetown/luckcharm/mercmedal
	name = "佣兵勋章"
	desc = "一枚纪念某份“圆满”差事的勋章。"
	icon = 'modular_azurepeak/icons/clothing/mercmedals.dmi'
	icon_state = "gryphon"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	sellprice = 15

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grenzelhoft
	name = "帝国狮鹫"
	desc = "这是对授予格伦泽尔霍夫特荣耀名将之黄铜勋章的一种戏仿。经稍加改动后，它常被普赛多尼亚佣兵中的其他新兴公会拿来作为自家勋章。"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/blackoak
	name = "守望者种囊"
	desc = "一个被严密封好的小囊，装着谷地本土橡树的橡果。愿你的终结成为王国新的开始。"
	icon_state = "blackoak_pouch"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/condottiero
	name = "佣兵队长剑柄"
	desc = "一条精美的银项链，镶着豌豆大小的隆兹石。每一颗本身都是艺术品，出自伊特鲁斯卡珠宝大师之手。这便是佣兵队长誓以性命追随的剑之象征。"
	icon_state = "condo_blade"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/desertrider
	name = "沙漠骑手绶带"
	desc = "一条奢华的金链，可披在肩头或绕于颈间，是遥远兹班图的崇高荣誉象征。有人说它见证了沙漠骑手源自遥远奴隶斗坑的出身，也有人认为这是帝国上层授予宠信的标志。沙漠骑手本人对此两不承认。"
	icon_state = "rider_sash"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/forlorn
	name = "笑狼勋章"
	desc ="一枚饰有怒嚎沃尔夫与闪电纹样的小饰物，是死士先锋中的荣誉标识。它们常从死者身上取下，再颁给生者，每一枚都带着经年累月留下的磕痕与刮痕。"
	icon_state = "forlorn_dogmedal"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/freifechter
	name = "自由斗剑团钱币"
	desc = "一种久已几近被遗忘的普西伦古币后裔，一端穿有孔洞，可系绳佩戴。随着玛门成为西大陆通行的主要货币，这类旧币又以自由斗剑团技艺标识的身份获得了新生。"
	icon_state = "freif_obol"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/atgervi
	name = "北地人的偶像"
	desc = "一枚以紧缠帆布、毛皮与木料制成的朴素护符。那是故乡的一角，被人紧紧按在胸前。感受它的心跳与你自身同拍。纵在这片遥远异域，诸神仍在行走，而他们也与你同在。"
	icon_state = "atgervi_idol"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grudgebearer
	name = "怨仇负者遗物"
	desc = "“原谅？忘掉？呸！下地狱去吧！”"
	icon_state = "grudge_keepsake"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/underdweller
	name = "地下居者的破损罗盘"
	desc = "地底住民声称，这东西总会精准指向你该去的地方。要是没用，那问题只在于你的技艺与心境。"
	icon_state = "under_compass"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/kazengun
	// NOT CURRENTLY IMPLEMENTED

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/routier
	name = "奥塔万镀银光环"
	desc = "一块受祝福的奥塔万钢片，被精心锻成异样的光环形制。它或许挡不住维尔沃夫或恶魔，却能提醒远行的巡战骑士他们为何而战：家乡、受福的奥塔瓦，以及他们哭泣的神，普赛顿。"
	icon_state = "routier_halo"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/steppesman
	name = "草原人的土瓶"
	desc = "一支严密封好的泥土小瓶。泥土取自草原人的科扎克故土，在他们离乡服役时由至亲赠予。若他们能活到役满归来，便可将瓶中泥土倾洒、再将玻璃捏碎，这便是终点，传说如是。"
	icon_state = "steppe_ungent"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/vaquero
	name = "牧侠之戒"
	desc = "一枚由黄金与隆兹石打造的美丽戒指，是伊特鲁斯卡珠宝工艺的杰作。它不仅证明你是真正的牧侠，也昭示着你既美丽又危险，那颗猩红宝石在黄金映衬下尤为醒目。去危险地活着吧，\
	但无论如何，仍要活下去。"
	icon_state = "vaquero_ring"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/warscholar
	name = "纳莱迪十字"
	desc = "“如风恒常雕琢纳莱迪那般去雕刻它吧，向一块白石低语，其余白石便会记得自己该立于何处。”\
	普赛顿如是说。<br>在普赛圣十字分裂的臂枝之间，嵌着一枚大理石般洁白的金中碎片。\
	那是陨落大城纳莱迪的一道裂片；也是千代哀号之众于衰朽将死之息中留下的记忆，提醒你自己是谁。"
	icon_state = "naledian_psycross"//Temp sprite. Just the Astratan Psyscross, with lower limbs removed.

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/anthrax
	name = "石化幼虫护符"
	desc = "一具干枯蜂蛛幼体的空壳，在那些姓名已被黑暗精灵历史抹去者之间代代相传。推翻旧日暴政，将成为他们最后一次真正的壮举。"
	icon_state = "spider"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/oathmarked
	name = "服役文书"
	desc = "一卷某种古老而腐朽的卷轴。其上布满怪异污渍，稍一用力就可能撕裂。"
	icon_state = "oathmarked_writ"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>With the destruction of an old empire, came a great sadness. A profound longing for what was lost. \
		No greater is this felt than by those who'd lyved it, such as the ones who carry this now. A relic of daes gone by. \
		<br>Where were you, when it all came to an end? Are you not the <b>hero</b>?</small>"
