/// Reusable seal items for sealing letters and documents
/// Seals work like signet rings: dipped into heated tallow, then pressed onto paper
/// Only the tallow is consumed; the seal item remains for reuse

/obj/item/seal
	name = "wax seal"
	desc = "A small seal for marking official documents. It has a small loop to attach it to a keyring. A small magical charm lets it tint the wax when heated."
	icon = 'icons/roguetown/items/stamps.dmi'
	icon_state = "stamp"
	item_state = "stamp"
	w_class = WEIGHT_CLASS_TINY
	var/tallowed = FALSE
	var/seal_label = "Official Seal"
	var/seal_color = "#8b6914"
	var/seal_is_official = TRUE
	var/cap_uses_color = TRUE

/obj/item/seal/attack_right(mob/user)
	if(is_blind(user))
		return TRUE
	user.visible_message(span_notice("[user] scrapes the tallow off of [src]."))
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
	. += "<span style='color:[seal_color]'>It imprints a seal of [seal_label].</span>"

/obj/item/seal/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/inqarticles/tallowpot))
		var/obj/item/inqarticles/tallowpot/pot = I
		if(!pot.loaded_tallow)
			to_chat(user, span_warning("The [pot] has no tallow in it."))
			return
		if(!pot.heatedup)
			to_chat(user, span_warning("The [pot.loaded_tallow] in [pot] is hardened. I need to heat it first."))
			return
		tallowed = TRUE
		update_icon()
		to_chat(user, span_notice("I coat [src] with melted [pot.loaded_tallow]."))
		return

	return ..()

/obj/item/seal/custom
	name = "blank custom seal"
	desc = "A blank seal head ready to be engraved once."
	seal_label = "Custom Seal"
	seal_color = "#8b6914"
	seal_is_official = FALSE
	cap_uses_color = FALSE
	var/customized = FALSE

/obj/item/seal/custom/attack_self(mob/user)
	if(customized)
		to_chat(user, span_warning("[src] is already engraved and cannot be changed."))
		return
	if(is_blind(user))
		return
	var/new_label = stripped_input(user, "Engrave your seal text (format, 'a seal of <name>):", "Custom Seal Engraving", "", 64)
	if(!new_label)
		return
	new_label = trim(STRIP_HTML_SIMPLE(new_label, 64))
	if(!length(new_label))
		to_chat(user, span_warning("The engraving must contain text."))
		return
	var/new_color = sanitize_hexcolor(color_pick_sanitized(user, "Choose wax color:", "Custom Seal Color", seal_color, 0.2, 1), 6, TRUE)
	if(!new_color)
		new_color = "#8b6914"
	seal_label = new_label
	seal_color = new_color
	customized = TRUE
	cap_uses_color = TRUE
	name = "custom seal"
	desc = "A personalized wax seal with a unique engraving."
	update_icon()
	to_chat(user, span_notice("I engrave [src] and set its wax color."))

/datum/crafting_recipe/roguetown/survival/custom_seal
	name = "Blank Custom Seal (1 Small Log)"
	result = /obj/item/seal/custom
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
	)
	time = 8 SECONDS
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3
	verbage_simple = "carve"
	verbage = "carves"

// Seal of the Crown
/obj/item/seal/crown
	name = "crown seal"
	seal_label = "The Crown of Rotwood Vale"
	seal_color = "#d4a62f"

// Steward's seal
/obj/item/seal/steward
	name = "steward's seal"
	seal_label = "The Steward of Rotwood Vale"
	seal_color = "#a07d26"

// Marshal's seal
/obj/item/seal/marshal
	name = "marshal's seal"
	seal_label = "The Marshal's Office"
	seal_color = "#790000"

// Councillor's seal
/obj/item/seal/councillor
	name = "councillor's seal"
	seal_label = "The Royal Council"
	seal_color = "#7e243f"

// Merchant's seal
/obj/item/seal/merchant
	name = "merchant's seal"
	seal_label = "The Rotwood Vale Guild Merchant"
	seal_color = "#11269c"

// Nightmaster/Mistress seal
/obj/item/seal/nightmaster
	name = "night seal"
	seal_label = "The Nightmaster's Authority"
	seal_color = "#5c5c5c"

// Guildmaster's seal
/obj/item/seal/guildmaster
	name = "guild master's seal"
	seal_label = "The Guildmaster of Rotwood Vale"
	seal_color = "#552600"

// Prelate's seal
/obj/item/seal/prelate
	name = "prelate's seal"
	seal_label = "High Prelate of Rotwood Vale"
	seal_color = "#f8e7b0"

// Court Magos seal
/obj/item/seal/court_magos
	name = "court magos seal"
	seal_label = "The Court Magos"
	seal_color = "#6b0099"

// Master Warden's seal
/obj/item/seal/master_warden
	name = "master warden's seal"
	seal_label = "Master of the Wardens of Rotwood Vale"
	seal_color = "#0d530d"

// Seneschal's seal
/obj/item/seal/seneschal
	name = "seneschal's seal"
	seal_label = "The Seneschal of The Keep of Rotwood Vale"
	seal_color = "#5f70a7"

// Hand of the Ruler seal
/obj/item/seal/hand
	name = "hand's seal"
	seal_label = "The Hand of the Crown of Rotwood Vale"
	seal_color = "#169921"

// Knight Captain's seal
/obj/item/seal/knight_captain
	name = "knight captain's seal"
	seal_label = "The Knight Captain of Rotwood Vale"
	seal_color = "#7e1111"

// Watch Captain's seal
/obj/item/seal/watchcaptain
	name = "watch captain's seal"
	seal_label = "The Watch Captain of Rotwood Vale"
	seal_color = "#1e4a7e"
