/obj/structure/telescope
	name = "望远镜"
	desc = "一架神秘的望远镜，正指向群星。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "telescope"
	density = TRUE
	anchored = FALSE

/obj/structure/telescope/attack_hand(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/random_message = pick("你看见诺克正在缓缓转动！", "凝视阿斯特拉塔让你双目刺痛！", "群星正向你微笑。", "今天的内波尔克斯格外赤红。", "受祝福的黄色纷争。", "你看见了一颗星星！")
	to_chat(H, span_notice("[random_message]"))

	if(random_message == "凝视阿斯特拉塔让你双目刺痛！")
		if(do_after(H, 25, target = src))
			var/obj/item/bodypart/affecting = H.get_bodypart("head")
			to_chat(H, span_warning("那炫目的光芒令你痛苦不堪！"))
			if(affecting && affecting.receive_damage(0, 5))
				H.update_damage_overlays()
	if(random_message == "你看见诺克正在缓缓转动！")
		if(do_after(H, 2.5 SECONDS, target = src))
			to_chat(H, span_warning("诺克的辉光似乎让我的思绪清明了几分。"))
			H.apply_status_effect(/datum/status_effect/buff/nocblessing)

/obj/structure/globe
	name = "地球仪"
	desc = "一只神秘的地球仪，象征着整个世界。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "globe"
	density = FALSE
	anchored = FALSE

/obj/structure/globe/attack_hand(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/random_message = pick("你转动了地球仪！", "你停在了谷地！", "你停在了岩丘！", "你停在了阿尔-阿舒尔！", "你停在了阿瓦尔！", "你停在了兹班图！", "你停在了冰方港！", "你停在了棘谷港！", "你停在了格伦泽尔霍夫特！", "你停在了格隆恩！", "你停在了奥塔瓦！", "你停在了吉萨！", "你停在了铁锤堡！", "你停在了王田！", "你停在了寓言田！", "你停在了阿瓦尔！", "你停在了伊特鲁斯卡！", "你停在了风郡！大概吧。")
	to_chat(H, span_notice("[random_message]"))
