/// Reusable seal items for sealing letters and documents
/// Seals work like signet rings: dipped into heated tallow, then pressed onto paper
/// Only the tallow is consumed; the seal item remains for reuse

/obj/item/seal
	name = "蜡封印"
	desc = "一枚用于标记正式文书的小印封。它带有一个小环，可以挂在钥匙环上。上面附着的小型魔法护符能在受热时为蜡赋予颜色。"
	icon = 'icons/roguetown/items/stamps.dmi'
	icon_state = "stamp"
	item_state = "stamp"
	w_class = WEIGHT_CLASS_TINY
	var/tallowed = FALSE
	var/seal_label = "正式印记"
	var/seal_color = "#8b6914"
	var/seal_is_official = TRUE
	var/cap_uses_color = TRUE

/obj/item/seal/attack_right(mob/user)
	if(is_blind(user))
		return TRUE
	user.visible_message(span_notice("[user] 刮掉了 [src] 上的蜡脂。"))
	tallowed = FALSE
	update_icon()
	return TRUE

/obj/item/seal/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/seal/update_icon()
	icon_state = "stamp"
	cut_overlays()
	var/image/cap
	if(cap_uses_color)
		cap = image(icon, icon_state = "stamp_cap")
		cap.color = seal_color
	else
		cap = image(icon, icon_state = "stamp_plain_cap")
	add_overlay(cap)
	if(tallowed)
		var/image/wax = image(icon, icon_state = "stamp_wax")
		wax.color = seal_color
		add_overlay(wax)
	else
		add_overlay(image(icon, icon_state = "stamp_bottom"))

/obj/item/seal/examine(mob/user)
	. = ..()
	. += "<span style='color:[seal_color]'>它会压出“[seal_label]”的印记。</span>"

/obj/item/seal/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/inqarticles/tallowpot))
		var/obj/item/inqarticles/tallowpot/pot = I
		if(!pot.loaded_tallow)
			to_chat(user, span_warning("[pot] 里面没有蜡脂。"))
			return
		if(!pot.heatedup)
			to_chat(user, span_warning("[pot] 里的 [pot.loaded_tallow] 已经凝固了。我得先把它加热。"))
			return
		tallowed = TRUE
		update_icon()
		to_chat(user, span_notice("我把熔化的 [pot.loaded_tallow] 涂在了 [src] 上。"))
		return

	return ..()

/obj/item/seal/custom
	name = "空白定制印封"
	desc = "一枚空白的印封头，可供雕刻一次。"
	seal_label = "定制印记"
	seal_color = "#8b6914"
	seal_is_official = FALSE
	cap_uses_color = FALSE
	var/customized = FALSE

/obj/item/seal/custom/attack_self(mob/user)
	if(customized)
		to_chat(user, span_warning("[src] 已经雕刻过了，无法再更改。"))
		return
	if(is_blind(user))
		return
	var/new_label = stripped_input(user, "输入你的印封文字（格式如“某某之印”）：", "定制印封雕刻", "", 64)
	if(!new_label)
		return
	new_label = trim(STRIP_HTML_SIMPLE(new_label, 64))
	if(!length(new_label))
		to_chat(user, span_warning("雕刻内容不能为空。"))
		return
	var/new_color = sanitize_hexcolor(color_pick_sanitized(user, "选择蜡的颜色：", "定制印封颜色", seal_color, 0.2, 1), 6, TRUE)
	if(!new_color)
		new_color = "#8b6914"
	seal_label = new_label
	seal_color = new_color
	customized = TRUE
	cap_uses_color = TRUE
	name = "定制印封"
	desc = "一枚带有独特雕刻的专属蜡封印。"
	update_icon()
	to_chat(user, span_notice("我雕刻好了 [src]，并设定了它的蜡色。"))

/datum/crafting_recipe/roguetown/survival/custom_seal
	name = "空白定制印封（1根小原木）"
	result = /obj/item/seal/custom
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
	)
	time = 8 SECONDS
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3
	verbage_simple = "雕刻"
	verbage = "雕刻"

// Seal of the Crown
/obj/item/seal/crown
	name = "王冠印封"
	seal_label = "腐木谷之冠"
	seal_color = "#d4a62f"

// Steward's seal
/obj/item/seal/steward
	name = "总管印封"
	seal_label = "腐木谷总管"
	seal_color = "#a07d26"

// Marshal's seal
/obj/item/seal/marshal
	name = "执法官印封"
	seal_label = "执法官官署"
	seal_color = "#790000"

// Councillor's seal
/obj/item/seal/councillor
	name = "议员印封"
	seal_label = "王室议会"
	seal_color = "#7e243f"

// Merchant's seal
/obj/item/seal/merchant
	name = "商人印封"
	seal_label = "腐木谷公会商人"
	seal_color = "#11269c"

// Nightmaster/Mistress seal
/obj/item/seal/nightmaster
	name = "夜主印封"
	seal_label = "夜主权柄"
	seal_color = "#5c5c5c"

// Guildmaster's seal
/obj/item/seal/guildmaster
	name = "公会长印封"
	seal_label = "腐木谷公会长"
	seal_color = "#552600"

// Prelate's seal
/obj/item/seal/prelate
	name = "大主教印封"
	seal_label = "腐木谷大主教"
	seal_color = "#f8e7b0"

// Court Magos seal
/obj/item/seal/court_magos
	name = "宫廷魔导士印封"
	seal_label = "宫廷魔导士"
	seal_color = "#6b0099"

// Master Warden's seal
/obj/item/seal/master_warden
	name = "守林总长印封"
	seal_label = "腐木谷守林总长"
	seal_color = "#0d530d"

// Seneschal's seal
/obj/item/seal/seneschal
	name = "总管家印封"
	seal_label = "腐木谷要塞总管家"
	seal_color = "#5f70a7"

// Hand of the Ruler seal
/obj/item/seal/hand
	name = "王冠之手印封"
	seal_label = "腐木谷王冠之手"
	seal_color = "#169921"

// Knight Captain's seal
/obj/item/seal/knight_captain
	name = "骑士队长印封"
	seal_label = "腐木谷骑士队长"
	seal_color = "#7e1111"

// Watch Captain's seal
/obj/item/seal/watchcaptain
	name = "守望队长印封"
	seal_label = "腐木谷守望队长"
	seal_color = "#1e4a7e"
