

/obj/item/clothing/ring
	name = "戒指"
	desc = ""
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/roguetown/clothing/rings.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/rings.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/rings.dmi'
	sleevetype = "shirt"
	icon_state = ""
	slot_flags = ITEM_SLOT_RING|ITEM_SLOT_GLOVES
	resistance_flags = FIRE_PROOF | ACID_PROOF
	anvilrepair = /datum/skill/craft/armorsmithing
	experimental_inhand = FALSE
	drop_sound = 'sound/foley/coinphy (1).ogg'
	nudist_approved = TRUE
	sewrepair = FALSE
	dropshrink = 0.4

/obj/item/clothing/ring/silver
	name = "银戒指"
	icon_state = "ring_s"
	sellprice = 33
	is_silver = TRUE

/obj/item/clothing/ring/decrepit
	name = "破旧戒指"
	desc = "一圈磨损的青铜环。"
	icon_state = "ring_a"
	sellprice = 11


/obj/item/clothing/ring/gold
	name = "金戒指"
	icon_state = "ring_g"
	sellprice = 45

/obj/item/clothing/ring/blacksteel
	name = "黑钢戒指"
	icon_state = "ring_bs"
	sellprice = 70

/obj/item/clothing/ring/jade
	name = "玉戒指"
	icon_state = "ring_jade"
	sellprice = 60

/obj/item/clothing/ring/coral
	name = "心石戒指"
	icon_state = "ring_coral"
	sellprice = 70

/obj/item/clothing/ring/onyxa
	name = "缟玛瑙戒指"
	icon_state = "ring_onyxa"
	sellprice = 40

/obj/item/clothing/ring/shell
	name = "贝壳戒指"
	icon_state = "ring_shell"
	sellprice = 20

/obj/item/clothing/ring/amber
	name = "琥珀戒指"
	icon_state = "ring_amber"
	sellprice = 20

/obj/item/clothing/ring/turq
	name = "天青石戒指"
	icon_state = "ring_turq"
	sellprice = 85

/obj/item/clothing/ring/rose
	name = "玫瑰石戒指"
	icon_state = "ring_rose"
	sellprice = 25

/obj/item/clothing/ring/chitin
	name = "甲壳戒指"
	icon_state = "ring_shell"
	color = "#7B8C5E"
	sellprice = 20

/obj/item/clothing/ring/opal
	name = "欧泊戒指"
	icon_state = "ring_opal"
	sellprice = 90

/obj/item/clothing/ring/active
	var/active = FALSE
	desc = "很遗憾，和大多数魔法戒指一样，它也必须谨慎使用。（右键点击我即可激活）"
	var/cooldowny
	var/cdtime
	var/activetime
	var/activate_sound

/obj/item/clothing/ring/active/attack_right(mob/user)
	if(loc != user)
		return
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, span_warning("什么也没发生。"))
			return
	user.visible_message(span_warning("[user]拧动了[src]！"))
	if(activate_sound)
		playsound(user, activate_sound, 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src, PROC_REF(demagicify)), activetime)
	active = TRUE
	update_icon()
	activate(user)

/obj/item/clothing/ring/active/proc/activate(mob/user)
	user.update_inv_wear_id()

/obj/item/clothing/ring/active/proc/demagicify()
	active = FALSE
	update_icon()
	if(ismob(loc))
		var/mob/user = loc
		user.visible_message(span_warning("戒指平静了下来。"))
		user.update_inv_wear_id()


/obj/item/clothing/ring/active/nomag
	name = "反魔之戒"
	icon_state = "ruby"
	activate_sound = 'sound/magic/antimagic.ogg'
	cdtime = 10 MINUTES
	activetime = 30 SECONDS
	sellprice = 100

/obj/item/clothing/ring/active/nomag/update_icon()
	..()
	if(active)
		icon_state = "rubyactive"
	else
		icon_state = "ruby"

/obj/item/clothing/ring/active/nomag/activate(mob/user)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, FALSE, FALSE, ITEM_SLOT_RING, ITEM_SLOT_HANDS, INFINITY, FALSE)

/obj/item/clothing/ring/active/nomag/demagicify()
	. = ..()
	var/datum/component/magcom = GetComponent(/datum/component/anti_magic)
	if(magcom)
		magcom.ClearFromParent()

//gold rings
/obj/item/clothing/ring/emerald
	name = "金绿宝石戒指"
	icon_state = "g_ring_emerald"
	desc = "一枚精美的金戒指，上面镶着一颗打磨光洁的绿宝石。"
	smeltresult = /obj/item/roguegem/green
	sellprice = 195

/obj/item/clothing/ring/ruby
	name = "金红宝石戒指"
	icon_state = "g_ring_ruby"
	desc = "一枚精美的金戒指，上面镶着一颗打磨光洁的红宝石。"
	smeltresult = /obj/item/roguegem/ruby
	sellprice = 255

/obj/item/clothing/ring/topaz
	name = "金黄宝石戒指"
	icon_state = "g_ring_topaz"
	desc = "一枚精美的金戒指，上面镶着一颗打磨光洁的黄宝石。"
	smeltresult = /obj/item/roguegem/yellow
	sellprice = 180

/obj/item/clothing/ring/quartz
	name = "金布洛兹戒指"
	icon_state = "g_ring_quartz"
	desc = "一枚精美的金戒指，上面镶着一颗打磨光洁的布洛兹。"
	smeltresult = /obj/item/roguegem/blue
	sellprice = 245

/obj/item/clothing/ring/sapphire
	name = "金紫宝石戒指"
	icon_state = "g_ring_sapphire"
	desc = "一枚精美的金戒指，上面镶着一颗打磨光洁的紫宝石。"
	smeltresult = /obj/item/roguegem/violet
	sellprice = 200

/obj/item/clothing/ring/diamond
	name = "金多佩尔戒指"
	icon_state = "g_ring_diamond"
	desc = "一枚精美的金戒指，上面镶着一颗打磨光洁的多佩尔。"
	smeltresult = /obj/item/roguegem/diamond
	sellprice = 270

/obj/item/clothing/ring/signet
	name = "金印戒"
	icon_state = "signet"
	desc = "一枚奢华的金戒指，上面刻有普希顿的符号。将其浸入熔化的红脂后，便可为宗教文书盖印密封，这类门道通常更为宗教裁判所所熟知，而非教会或王室。"
	sellprice = 135
	var/tallowed = FALSE
	var/seal_label = "Otavan驻河谷地带代表团大审判官"
	var/seal_color = "#6b0000"
	var/seal_is_official = TRUE

/obj/item/clothing/ring/signet/silver
	name = "银印戒"
	icon_state = "signet_silver"
	desc = "一枚受祝福的银戒指，上面刻有大主教的徽记。将其浸入熔化的红脂后，便可为宗教文书盖印密封。"
	sellprice = 90
	is_silver = TRUE

/obj/item/clothing/ring/signet/attack_right(mob/user)
	. = ..()
	if(tallowed)
		if(alert(user, "要刮掉这层牛脂吗？", "印戒", "是", "否") != "否")
			tallowed = FALSE
			update_icon()

/obj/item/clothing/ring/signet/update_icon()
	. = ..()
	if(tallowed)
		icon_state = "[icon_state]_stamp"
	else
		icon_state = initial(icon_state)

//silver rings
/obj/item/clothing/ring/emeralds
	name = "银绿宝石戒指"
	icon_state = "s_ring_emerald"
	smeltresult = /obj/item/roguegem/green
	sellprice = 155

/obj/item/clothing/ring/rubys
	name = "银红宝石戒指"
	icon_state = "s_ring_ruby"
	smeltresult = /obj/item/roguegem/ruby
	sellprice = 215

/obj/item/clothing/ring/topazs
	name = "银黄宝石戒指"
	icon_state = "s_ring_topaz"
	smeltresult = /obj/item/roguegem/yellow
	sellprice = 140

/obj/item/clothing/ring/quartzs
	name = "银布洛兹戒指"
	icon_state = "s_ring_quartz"
	smeltresult = /obj/item/roguegem/blue
	sellprice = 205

/obj/item/clothing/ring/sapphires
	name = "银紫宝石戒指"
	icon_state = "s_ring_sapphire"
	smeltresult = /obj/item/roguegem/violet
	sellprice = 160

/obj/item/clothing/ring/diamonds
	name = "银多佩尔戒指"
	icon_state = "s_ring_diamond"
	smeltresult = /obj/item/roguegem/diamond
	sellprice = 230

/obj/item/clothing/ring/duelist
	name = "决斗者戒指"
	desc = "这枚戒指出自决斗者对戏剧感的偏爱，它象征着一项提议: 一场赌注高悬的荣誉决斗。\n若双方决斗者都佩戴此戒，成功的诱招会让他们失去平衡，而对拼时缴械的概率也绝不会低。\n<i>'你会知道他的名字。你会知道他的目的。然后，你会死。'</i>"
	icon_state = "ring_duel"
	sellprice = 10

/obj/item/clothing/ring/fate_weaver
	name = "命织戒"
	desc = "一件奥术造物，最初由一些对赛利克斯戏剧结局不满的人构想出来。它会轻轻扭转事态，将佩戴者推向不那么致命的可能性。"
	icon_state = "ring_s"
	max_integrity = 50
	body_parts_covered = COVERAGE_FULL | COVERAGE_HEAD_NOSE | NECK | HANDS | FEET //field covers the whole body
	armor = ARMOR_FATEWEAVER //even protection against most damage types
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PIERCE, BCLASS_PICK, BCLASS_BLUNT)
	blade_dulling = DULLING_BASHCHOP
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	armor_class = ARMOR_CLASS_NONE

/obj/item/clothing/ring/fate_weaver/proc/dispel()
	if(!QDELETED(src))
		src.visible_message(span_warning("[src]的边缘开始闪烁并渐渐褪去，随后彻底消失了！"))
		qdel(src)

/obj/item/clothing/ring/fate_weaver/obj_break()
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/ring/fate_weaver/attack_hand(mob/user)
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/ring/fate_weaver/dropped()
	. = ..()
	if(!QDELETED(src))
		dispel()

/////////////////////////
// Wedding Rings/Bands //
/////////////////////////

// These are meant to not be smelted down for anything or sell for much. Loadout items for roleplay, kinda simple.
// Also, can rename their name/desc to put parnters name in it and stuff. Some customization. TODO: allow sprite selection between 2-3 types of wedding band sprites.
/obj/item/clothing/ring/band
	name = "银婚戒"
	desc = "一枚朴素的银婚戒，上面刻着恋人的华美名字纹样。"
	icon_state = "s_ring_wedding"
	sellprice = 3	//You don't get to smelt this down or sell it. No free mams for a loadout item.
	is_silver = TRUE
	var/choicename = FALSE
	var/choicedesc = FALSE

/obj/item/clothing/ring/band/attack_right(mob/user)
	if(choicename)
		return
	if(choicedesc)
		return
	var/current_time = world.time
	var/namechoice = input(user, "输入新名称", "重命名物品")
	var/descchoice = input(user, "输入新描述", "描述物品")
	if(namechoice)
		name = namechoice
		choicename = TRUE
	if(descchoice)
		desc = descchoice
		choicedesc = TRUE
	else
		return
	if(world.time > (current_time + 30 SECONDS))
		return


//blacksteel rings
/obj/item/clothing/ring/emeraldbs
	name = "黑钢绿宝石戒指"
	icon_state = "bs_ring_emerald"
	desc = "一枚精美的黑钢戒指，上面镶着一颗打磨光洁的绿宝石。"
	sellprice = 295

/obj/item/clothing/ring/rubybs
	name = "黑钢红宝石戒指"
	icon_state = "bs_ring_ruby"
	desc = "一枚精美的黑钢戒指，上面镶着一颗打磨光洁的红宝石。"
	sellprice = 355

/obj/item/clothing/ring/topazbs
	name = "黑钢黄宝石戒指"
	icon_state = "bs_ring_topaz"
	desc = "一枚精美的黑钢戒指，上面镶着一颗打磨光洁的黄宝石。"
	sellprice = 380

/obj/item/clothing/ring/quartzbs
	name = "黑钢布洛兹戒指"
	icon_state = "bs_ring_quartz"
	desc = "一枚精美的黑钢戒指，上面镶着一颗打磨光洁的布洛兹。"
	sellprice = 345

/obj/item/clothing/ring/sapphirebs
	name = "黑钢紫宝石戒指"
	icon_state = "bs_ring_sapphire"
	desc = "一枚精美的黑钢戒指，上面镶着一颗打磨光洁的紫宝石。"
	sellprice = 300

/obj/item/clothing/ring/diamondbs
	name = "黑钢多佩尔戒指"
	icon_state = "bs_ring_diamond"
	desc = "一枚精美的黑钢戒指，上面镶着一颗打磨光洁的多佩尔。"
	sellprice = 370
/////////////////////////
// Stat-Boosting Rings //
/////////////////////////

//Anything above +1 that bestows positive traits or has no downsides should be restricted to higher-tier dungeons and loot pools.
//Anything below that - either a +1, or anything that comes with a negative trait or malus - should be acceptable for lower-tier dungeons and loot pools.
//These rings shouldn't be craftable under any circumstance, unless it involves combining multiple rings or rare components. Don't add recipes unless you absolutely know what you're doing.

/obj/item/clothing/ring/statgemerald
	name = "迅捷之戒"
	desc = "一枚绿宝石戒指，闪耀着青翠的辉光。你的手越靠近它，风声便呼啸得越猛烈。"
	icon_state = "ring_emerald"
	icon = 'icons/roguetown/items/misc.dmi'
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statgemerald/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_green("'……生命之道，丰饶却短暂……'"))
		user.change_stat(STATKEY_SPD, 1)
		user.change_stat(STATKEY_LCK, 1)
	return

/obj/item/clothing/ring/statgemerald/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_green("'……若旅途永无尽头，生命又何来意义？'"))
		user.change_stat(STATKEY_SPD, -1)
		user.change_stat(STATKEY_LCK, -1)
		active_item = FALSE
	return

/obj/item/clothing/ring/statonyx
	name = "活力之戒"
	desc = "一枚缟玛瑙戒指，闪耀着紫色的决意。你的手越靠近它，心跳便跳得越快。"
	icon_state = "ring_onyx"
	icon = 'icons/roguetown/items/misc.dmi'
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statonyx/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_purple("'……鲜血之道，自你身上徒然流尽……'"))
		user.change_stat(STATKEY_CON, 1)
		user.change_stat(STATKEY_WIL, 1)
	return

/obj/item/clothing/ring/statonyx/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_purple("'……若你不为那些无法挺身而出的人而战，又还能指望谁呢？'"))
		user.change_stat(STATKEY_CON, -1)
		user.change_stat(STATKEY_WIL, -1)
		active_item = FALSE
	return

/obj/item/clothing/ring/statamythortz
	name = "智慧之戒"
	desc = "一枚阿密索兹戒指，跃动着湛蓝而迷人的电芒。你的手越靠近它，思绪便越发清明。"
	icon_state = "ring_spinel"
	icon = 'icons/roguetown/items/misc.dmi'
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statamythortz/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_rose("'……知识之道，以疯狂诅咒每一个追逐者……'"))
		user.change_stat(STATKEY_INT, 1)
		user.change_stat(STATKEY_PER, 1)
	return

/obj/item/clothing/ring/statamythortz/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_rose("'……可若我们扎根于盲昧，又该如何继续前行？'"))
		user.change_stat(STATKEY_INT, -1)
		user.change_stat(STATKEY_PER, -1)
		active_item = FALSE
	return

/obj/item/clothing/ring/statrontz
	name = "勇气之戒"
	desc = "一枚龙红石戒指，散发着猩红的威势。你的手越靠近它，指节便攥得越紧。"
	icon_state = "ring_ruby"
	icon = 'icons/roguetown/items/misc.dmi'
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statrontz/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_red("'……死亡之道，无差别而彻底……'"))
		user.change_stat(STATKEY_STR, 1)
		ADD_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	return

/obj/item/clothing/ring/statrontz/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_red("'……但若没有暴力，又该如何阻止邪恶得胜？'"))
		user.change_stat(STATKEY_STR, -1)
		REMOVE_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
		active_item = FALSE
	return

///

/obj/item/clothing/ring/statdorpel
	name = "全能之戒"
	desc = "一枚多佩尔戒指，辉映着灿烂夺目的美感。你的手越靠近它，心中的恐惧便消融得越多。"
	icon_state = "ring_sapphire"
	icon = 'icons/roguetown/items/misc.dmi'
	smeltresult = /obj/item/riddleofsteel
	is_silver = TRUE
	sellprice = 777
	var/active_item

/obj/item/clothing/ring/statdorpel/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_blue("'……希望之道，不可摧折，亦能凝聚众人……'"))
		user.change_stat(STATKEY_SPD, 1)
		user.change_stat(STATKEY_LCK, 1)
		user.change_stat(STATKEY_INT, 1)
		user.change_stat(STATKEY_PER, 1)
		user.change_stat(STATKEY_CON, 1)
		user.change_stat(STATKEY_WIL, 1)
		user.change_stat(STATKEY_STR, 1)
		ADD_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	return

/obj/item/clothing/ring/statdorpel/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_blue("'……我知善意存在，因为我心怀善意……'</br>'……我知希望存在，因为我仍怀希望……'</br>'……而我知爱存在，因为我仍会去爱。'"))
		user.change_stat(STATKEY_SPD, -1)
		user.change_stat(STATKEY_LCK, -1)
		user.change_stat(STATKEY_INT, -1)
		user.change_stat(STATKEY_PER, -1)
		user.change_stat(STATKEY_CON, -1)
		user.change_stat(STATKEY_WIL, -1)
		user.change_stat(STATKEY_STR, -1)
		REMOVE_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
		active_item = FALSE
	return

///

/obj/item/clothing/ring/dragon_ring
	name = "龙石戒指"
	icon_state = "dragonring"
	desc = "一枚鎏金黑钢戒指，其龙首以白银雕成。嵌在眼窝中的布洛兹与萨菲拉各自跃动着烈火倒映般的光芒。"
	smeltresult = /obj/item/ingot/draconic
	sellprice = 666
	var/active_item

/obj/item/clothing/ring/dragon_ring/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_suicide("龙焰在我血脉中奔涌！我感到力量充盈！"))
		user.change_stat(STATKEY_STR, 2)
		user.change_stat(STATKEY_CON, 2)
		user.change_stat(STATKEY_WIL, 2)
	return

/obj/item/clothing/ring/dragon_ring/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_suicide("一股寒意流遍我的全身，而戒指残留的热度依旧令人迷醉……</br>……但也不禁让人思索……这般炽烈的力量，能否经受熔炉之火？"))
		user.change_stat(STATKEY_STR, -2)
		user.change_stat(STATKEY_CON, -2)
		user.change_stat(STATKEY_WIL, -2)
		active_item = FALSE
	return

//Oathmarked's fluff ring. Don't lose this!!!
/obj/item/clothing/ring/oathmarked
	name = "誓印者的印戒"
	icon_state = "ring_oath"
	desc = "这枚戒指曾蕴藏强大力量，如今却只余一缕火花。漫长岁月里，它想必一直被利爪紧紧攥握着。"
	smeltresult = /obj/item/ash//You've ruined it. Good going, champ.
	sellprice = 125
	var/active_item

/obj/item/clothing/ring/oathmarked/equipped(mob/living/user, slot)
	. = ..()
	if(ishuman(user))
		if(active_item)
			return
		else if(slot == SLOT_RING)
			var/mob/living/carbon/human/H = user
			if(H.merctype == 16) //Oathmarked
				active_item = TRUE
				//The bad.
				H.remove_status_effect(/datum/status_effect/debuff/lost_oath_ring)
				H.remove_stress(/datum/stressevent/oath_ring_lost)
				//The good.
				H.add_stress(/datum/stressevent/oath_ring)
				H.apply_status_effect(/datum/status_effect/buff/oath_ring)

/obj/item/clothing/ring/oathmarked/dropped(mob/living/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.merctype == 16 || active_item) //Oathmarked
			//The bad.
			H.apply_status_effect(/datum/status_effect/debuff/lost_oath_ring)
			H.add_stress(/datum/stressevent/oath_ring_lost)
			//More bad.
			H.remove_stress(/datum/stressevent/oath_ring)
			H.remove_status_effect(/datum/status_effect/buff/oath_ring)
			active_item = FALSE

/obj/item/clothing/ring/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>他们永远无法理解，这对你究竟意味着什么。\
		即便佩戴它的人并不是你，它对你的族群仍有着旁人早已遗忘的深重意义。\
		因为这是侍奉的印记，是承担此责之人必须不惜一切守住的誓言。\
		凡是胆敢威胁暴君阿斯特拉塔秩序之物，都必须被彻底毁灭。</small>"
