/*
 * Paper
 * also scraps of paper
 *
 * lipstick wiping is in code/game/objects/items/weapons/cosmetics.dm!
 */

#ifdef TESTSERVER

/client/verb/textperp()
	set category = "PAPER"
	set name = "textper+"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(istype(I,/obj/item/paper))
			var/obj/item/paper/P = I
			P.textper++
			P.read(mob)
		if(istype(I,/obj/item/book))
			var/obj/item/book/P = I
			P.textper++
			P.read(mob)

/client/verb/textperm()
	set category = "PAPER"
	set name = "textper-"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(istype(I,/obj/item/paper))
			var/obj/item/paper/P = I
			P.textper--
			P.read(mob)
		if(istype(I,/obj/item/book))
			var/obj/item/book/P = I
			P.textper--
			P.read(mob)

#endif

/obj/item/paper
	name = "parchment"
	gender = NEUTER
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = HEAD
	resistance_flags = FLAMMABLE
	max_integrity = 30
	dog_fashion = /datum/dog_fashion/head
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'
	grind_results = list(/datum/reagent/cellulose = 3)


	var/extra_headers //For additional styling or other js features.

	var/info		//What's actually written on the paper.
	var/info_links	//A different version of the paper which includes html links at fields and EOF
	var/stamps		//The (text for the) stamps on the paper.
	var/fields = 0	//Amount of user created fields
	var/list/stamped
	var/seal_label	//The label of the seal applied to this document (for examine text)
	var/seal_color = "#8b6914"	//The color used for the seal examine text
	var/seal_is_official = TRUE	//Official seals are rendered underlined on examine text
	var/seal_broken = FALSE	//Whether the seal has been broken (opened)
	var/rigged = 0
	var/spam_flag = 0
	var/contact_poison // Reagent ID to transfer on contact
	var/contact_poison_volume = 0
	dropshrink = 0.5
	var/textper = 100
	var/maxlen = 2000
	var/folded = FALSE
	var/open_empty_icon_state = "paper"
	var/open_written_icon_state = "paperwrite"
	var/folded_icon_state = "parchment_folded"
	var/sealed_icon_state = "parchment_sealed"
	var/sealed_tint_icon_state = "parchment_sealed_tint"
	var/mutable_appearance/seal_tint_overlay
	///CSS applied to <body> when reading — used by fax letters to show a rim on the window border.
	var/window_rim_style

	var/cached_mailer
	var/cached_mailedto
	var/trapped
	/// Append-only draft text used by the tgui writer panel input box.
	var/writer_draft = ""
	/// Optional font override selected in the tgui writer panel.
	var/writer_font = "default"
	/// Latest accepted writer action sequence from tgui; older actions are ignored.
	var/writer_action_seq = 0

/obj/item/paper/proc/get_writer_action_seq(list/params)
	var/seq = text2num("[params["seq"]]")
	if(!isnum(seq) || seq < 0)
		return 0
	return round(seq)

/obj/item/paper/proc/get_writer_tool(mob/living/carbon/human/user)
	if(!user)
		return null
	var/obj/item/P = user.get_active_held_item()
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		return P
	return null

/obj/item/paper/proc/sanitize_writer_font(font_name)
	if(!istext(font_name))
		return "default"
	var/list/allowed_fonts = list(
		"default",
		FOUNTAIN_PEN_FONT,
		"Times New Roman",
		"Garamond",
		"Book Antiqua",
		"Courier New",
		"Verdana",
	)
	if(!(font_name in allowed_fonts))
		return "default"
	return font_name

/obj/item/paper/proc/append_writer_chunk(mob/living/carbon/human/user, sign_after = FALSE)
	var/obj/item/P = get_writer_tool(user)
	if(!can_use_writer(user, P))
		to_chat(user, span_warning("I need a feather or thorn in hand to write."))
		return FALSE

	var/chunk_input = writer_draft || ""

	if(!length(chunk_input) && !sign_after)
		to_chat(user, span_warning("I have nothing to add."))
		return FALSE

	var/chunk_html = null
	if(length(chunk_input))
		chunk_html = parsepencode(chunk_input, P, user, FALSE, sanitize_writer_font(writer_font))
		if(!chunk_html)
			to_chat(user, span_warning("I have nothing to add."))
			return FALSE

	if(chunk_html)
		var/new_len = length(info) + length(chunk_html)
		if(info)
			new_len += 4 // <br>
		if(new_len > maxlen)
			to_chat(user, span_warning("Too long. Try again."))
			return FALSE

	if(chunk_html)
		if(info)
			info += "<br>[chunk_html]"
		else
			info = chunk_html

	writer_draft = ""

	updateinfolinks()
	update_icon_state()
	playsound(src, 'sound/items/write.ogg', 100, FALSE)
	if(sign_after)
		to_chat(user, span_notice("I sign [src]."))
	else
		to_chat(user, span_notice("I add writing to [src]."))
	return TRUE

/obj/item/paper/proc/build_writer_preview(mob/living/carbon/human/user)
	var/preview = info || ""
	if(!length(writer_draft))
		return preview

	var/obj/item/P = get_writer_tool(user)
	var/saved_fields = fields
	var/chunk_preview = parsepencode(writer_draft, P, user, FALSE, sanitize_writer_font(writer_font))
	fields = saved_fields
	if(!chunk_preview)
		return preview

	if(length(preview))
		return "[preview]<br>[chunk_preview]"
	return chunk_preview

/obj/item/paper/proc/can_use_writer(mob/living/carbon/human/user, obj/item/P)
	if(!user)
		return FALSE
	if(is_blind(user))
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(mailer)
		return FALSE
	if(!in_range(src, user) && loc != user && loc.loc != user)
		return FALSE
	if(!P)
		P = user.get_active_held_item()
	if(!istype(P, /obj/item/natural/thorn) && !istype(P, /obj/item/natural/feather))
		return FALSE
	if(istype(src, /obj/item/paper/scroll))
		var/obj/item/paper/scroll/S = src
		if(!S.open)
			return FALSE
	else if(folded)
		return FALSE
	return TRUE

/obj/item/paper/proc/open_writer_panel(mob/living/carbon/human/user, obj/item/P)
	if(!can_use_writer(user, P))
		return FALSE
	ui_interact(user)
	return TRUE

/obj/item/paper/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PaperWriterPanel", "Letter Editor")
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/item/paper/ui_static_data(mob/user)
	var/list/data = list()
	data["maxlen"] = maxlen
	data["font"] = writer_font
	data["standard_font"] = FOUNTAIN_PEN_FONT
	data["fonts"] = list("default", FOUNTAIN_PEN_FONT, "Times New Roman", "Garamond", "Book Antiqua", "Courier New", "Verdana")
	return data

/obj/item/paper/ui_data(mob/user)
	var/list/data = list()
	data["draft"] = writer_draft
	data["font"] = writer_font
	data["preview_html"] = build_writer_preview(user)
	return data

/obj/item/paper/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	var/mob/living/carbon/human/user = ui.user
	if(!user)
		return TRUE

	switch(action)
		if("update_draft")
			var/client_seq = get_writer_action_seq(params)
			if(client_seq < writer_action_seq)
				return TRUE
			writer_action_seq = client_seq
			var/new_draft = params["draft"] || ""
			writer_draft = copytext(new_draft, 1, maxlen + 1)
			writer_font = sanitize_writer_font(params["font"])
			return TRUE

		if("sign")
			var/client_seq = get_writer_action_seq(params)
			if(client_seq < writer_action_seq)
				return TRUE
			writer_action_seq = client_seq
			// Accept draft/font inline so the tgui client can send a single atomic
			// action instead of a separate update_draft + sign (avoids the race under
			// server time dilation where the debounce timer fires in between).
			if(!isnull(params["draft"]))
				writer_draft = copytext(params["draft"], 1, maxlen + 1)
			if(!isnull(params["font"]))
				writer_font = sanitize_writer_font(params["font"])
			append_writer_chunk(user, TRUE)
			return TRUE

		if("clear")
			var/client_seq = get_writer_action_seq(params)
			if(client_seq < writer_action_seq)
				return TRUE
			writer_action_seq = client_seq
			writer_draft = ""
			return TRUE

		if("help")
			openhelp(user)
			return TRUE

		if("close")
			ui.close()
			return TRUE

	return FALSE

/obj/item/paper/examine()
	. = ..()
	. += span_info("Use a feather to write on it. You can create a two-page manuscript that can be turned into a book by writing on it and applying it to another piece of paper that also have something written on it.")

/obj/item/paper/get_real_price()
	if(info)
		return 0
	else
		return sellprice

/obj/item/paper/spark_act()
	fire_act()

/obj/item/paper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.3,"sx" = 0,"sy" = -1,"nx" = 13,"ny" = -1,"wx" = 4,"wy" = 0,"ex" = 7,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 2,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/paper/pickup(user)
	if(contact_poison && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		if(!istype(G) || G.transfer_prints)
			H.reagents.add_reagent(contact_poison,contact_poison_volume)
			contact_poison = null
	..()

/obj/item/paper/update_icon()
	. = ..()
	update_icon_state()

/obj/item/paper/Initialize(mapload)
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	update_icon_state()
	updateinfolinks()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/sigsweet,
		/datum/crafting_recipe/roguetown/survival/sigdry,
		/datum/crafting_recipe/roguetown/survival/rocknutdry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/paper/proc/apply_seal_tint()
	if(!seal_color)
		clear_seal_tint()
		return
	if(!seal_tint_overlay)
		seal_tint_overlay = mutable_appearance(icon, sealed_tint_icon_state)
		seal_tint_overlay.color = seal_color
		add_overlay(seal_tint_overlay)
		return
	if(seal_tint_overlay.color != seal_color)
		seal_tint_overlay.color = seal_color
		cut_overlay(seal_tint_overlay)
		add_overlay(seal_tint_overlay)

/obj/item/paper/proc/clear_seal_tint()
	if(seal_tint_overlay)
		cut_overlay(seal_tint_overlay)
		seal_tint_overlay = null

/obj/item/paper/update_icon_state()
	if(mailer)
		icon_state = sealed_icon_state
		folded = TRUE
		name = "letter"
		throw_range = 7
		apply_seal_tint()
		return
	name = initial(name)
	throw_range = initial(throw_range)
	if(seal_label && !seal_broken)
		icon_state = sealed_icon_state
		folded = TRUE
		apply_seal_tint()
		return
	clear_seal_tint()
	if(folded)
		icon_state = folded_icon_state
		name = "folded parchment"
		return
	if(info)
		icon_state = open_written_icon_state
		return
	icon_state = open_empty_icon_state

/obj/item/paper/examine(mob/user)
	. = ..()
	var/admin_observer = isobserver(user) && IsAdminGhost(user)
	var/is_scroll = istype(src, /obj/item/paper/scroll)
	if(seal_label)
		var/seal_style = "color:[seal_color]"
		if(seal_is_official)
			seal_style += ";text-decoration:underline"
		if(seal_broken)
			. += "<span style='[seal_style]'>It bears a broken wax seal of [seal_label].</span>"
		else
			. += "<span style='[seal_style]'>It bears an unbroken wax seal of [seal_label].</span>"
	if(mailer)
		. += "It's from [mailer], addressed to [mailedto]."
	if(admin_observer)
		. += "<a href='?src=[REF(src)];read=1'>Read</a>"
	else if(!mailer && !is_scroll)
		if(info && !folded)
			. += "<a href='?src=[REF(src)];read=1'>Read</a>"

/obj/item/paper/proc/read(mob/user)
	if(!user.client)
		return
	var/admin_observer = isobserver(user) && IsAdminGhost(user)
	if(!user.hud_used)
		if(!admin_observer)
			return
	else if(!admin_observer && !user.hud_used.reads)
		return
	if(!admin_observer && !user.can_read(src))
		if(info)
			user.adjust_experience(/datum/skill/misc/reading, 2, FALSE)
		return
	if(!admin_observer && mailer)
		return
	if(!admin_observer && folded)
		to_chat(user, span_warning("I need to unfold [src] first."))
		return
	if(!admin_observer && seal_label && !seal_broken)
		to_chat(user, span_warning("The wax seal is still intact. I need to unseal it first."))
		return
	if(in_range(user, src) || isobserver(user))
		user << browse_rsc('html/book.png')
		var/body_border_css = window_rim_style ? "box-sizing:border-box;[window_rim_style]" : ""
		var/rendered_info = build_read_info(TRUE)
		var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head><meta charset=\"utf-8\"><style type=\"text/css\">
			html, body { height:100%; margin:0; padding:0; }
			body { background-image:url('book.png');background-repeat: repeat;[body_border_css] }</style></head><body scroll=yes>"}
		dat += rendered_info
		dat += "<br>"
		dat += "</body></html>"
		user << browse(dat, "window=reading;size=500x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1;border=0")
		onclose(user, "reading", src)
	else
		return span_warning("I'm too far away to read it.") 

/obj/item/paper/proc/format_browse(t, mob/user)
	user << browse_rsc('html/book.png')
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head><meta charset=\"utf-8\"><style type=\"text/css\">
			body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
	dat += "[t]<br>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=500x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1;border=0")

/obj/item/paper/proc/build_read_info(include_field_links = TRUE)
	var/rendered = info || ""
	var/laststart = 1
	var/field_id = 0
	while(field_id < 15)
		var/istart = findtext(rendered, "<span class=\"paper_field\">", laststart)
		if(!istart)
			break
		var/content_start = istart + length("<span class=\"paper_field\">")
		var/iend = findtext(rendered, "</span>", content_start)
		if(!iend)
			break
		field_id++
		if(iend == content_start)
			var/fill_text = "_____"
			if(include_field_links)
				fill_text = "<A href='?src=[REF(src)];write=[field_id]'>_____</A>"
			rendered = copytext(rendered, 1, content_start) + fill_text + copytext(rendered, content_start)
			laststart = content_start + length(fill_text)
		else
			laststart = iend + 1
	return rendered

/obj/item/paper/proc/has_empty_fields()
	if(!info)
		return FALSE
	return !!findtext(info, "<span class=\"paper_field\"></span>")

/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set hidden = 1
	set src in usr

	if(usr.incapacitated() || !usr.is_literate())
		return
	var/n_name = stripped_input(usr, "What would you like to label the paper?", "Paper Labelling", null, MAX_NAME_LEN)
	if((loc == usr && usr.stat == CONSCIOUS))
		name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(usr)


/obj/item/paper/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] scratches a grid on [user.p_their()] wrist with the paper! It looks like [user.p_theyre()] trying to commit sudoku...</span>")
	return (BRUTELOSS)

/obj/item/paper/proc/reset_spamflag()
	spam_flag = FALSE

/obj/item/paper/attack_self(mob/user)
	if(mailer)
		user.visible_message("<span class='notice'>[user] opens the letter from [mailer].</span>")
		cached_mailer = mailer
		cached_mailedto = mailedto
		mailer = null
		mailedto = null
		folded = FALSE
		update_icon()
		return
	if(trapped)
		var/mob/living/victim = user
		victim.visible_message(span_notice("[user] opens the [src]."))
		to_chat(user, span_warning("This parchment is full of strange symbols that start to glow. How odd. Wait-"))
		sleep(5)
		victim.adjust_fire_stacks(15)
		victim.ignite_mob()
		victim.visible_message(span_danger("[user] bursts into flames upon reading [src]!"))
	if(seal_label && !seal_broken)
		seal_broken = TRUE
		update_icon_state()
		to_chat(user, span_notice("I break the wax seal on [src]."))
		return
	if(folded)
		attack_right(user)
		return
	read(user)
	if(rigged && (SSevents.holidays && SSevents.holidays[APRIL_FOOLS]))
		if(!spam_flag)
			spam_flag = TRUE
			playsound(loc, 'sound/blank.ogg', 50, TRUE)
			addtimer(CALLBACK(src, PROC_REF(reset_spamflag)), 20)

/obj/item/paper/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/paper/attack_right(mob/user)
	if(mailer)
		to_chat(user, span_warning("This letter is sealed for delivery and must be opened first."))
		return
	if(seal_label && !seal_broken)
		to_chat(user, span_warning("The wax seal is still intact. I need to unseal it first."))
		return
	folded = !folded
	playsound(src, folded ? 'sound/items/scroll_close.ogg' : 'sound/items/scroll_open.ogg', 100, FALSE)
	update_icon_state()
	user.update_inv_hands()

/obj/item/paper/proc/addtofield(id, text, links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(locid < 15)	//hey whoever decided a while(1) was a good idea here, i hate you
		var/istart = 0
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart == 0)
			return	//No field found with matching id

		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			//textindex = istart+26
			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()


/obj/item/paper/proc/updateinfolinks()
	info_links = info
	for(var/i in 1 to min(fields, 15))
		addtofield(i, "<A href='?src=[REF(src)];write=[i]'>write</A> (<A href='?src=[REF(src)];help=1'>\[?\]</A>)", 1)


/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	seal_label = null
	seal_color = initial(seal_color)
	seal_is_official = initial(seal_is_official)
	seal_broken = initial(seal_broken)
	folded = initial(folded)
	LAZYCLEARLIST(stamped)
	cut_overlays()
	updateinfolinks()
	update_icon_state()


/obj/item/paper/proc/parsepencode(t, obj/item/P, mob/user, iscrayon = 0, custom_font = null)
	if(length(t) < 1)		//No input means nothing needs to be parsed
		return

	// Writer panel no longer supports large (^text^) tokens.
	t = replacetext(t, "^", "")

	t = parsemarkdown(t, user, iscrayon)
	var/pen_font = FOUNTAIN_PEN_FONT
	if(custom_font && custom_font != "default")
		pen_font = custom_font

	if(istype(P, /obj/item/natural/thorn))
		t = "<font face=\"[pen_font]\" color=#862f20>[t]</font>"
	else if(istype(P, /obj/item/natural/feather))
		t = "<font face=\"[pen_font]\" color=#14103f>[t]</font>"

	// Count the fields
	var/laststart = 1
	while(fields < 15)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++

	return t

/obj/item/paper/proc/reload_fields() // Useful if you made the paper programicly and want to include fields. Also runs updateinfolinks() for you.
	fields = 0
	var/laststart = 1
	while(fields < 15)
		var/i = findtext(info, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++
	updateinfolinks()


/obj/item/paper/proc/openhelp(mob/user)
	user << browse({"<HTML><HEAD><TITLE>Paper Help</TITLE></HEAD>
	<BODY>
		You can use backslash (\\) to escape special characters.<br>
		<br>
		# text : Defines a header.<br>
		|text| : Centers the text.<br>
		**text** : Makes the text <b>bold</b>.<br>
		*text* : Makes the text <i>italic</i>.<br>
		%s : Inserts a signature of your name in a foolproof way.<br>
		((text)) : Decreases the <font size = \"1\">size</font> of the text.<br>
		%f or %field : Creates a blank write-in field in the final letter.<br>
		* item : An unordered list item.<br>
		&nbsp;&nbsp;* item: An unordered list child item.<br>
		1. item : An ordered list item.<br>
		--- : Adds a horizontal rule.<br>
		-=862F20text=- : Adds a specific <font color = '#862F20'>colour</font> to text.
	</BODY></HTML>"}, "window=paper_help")


/obj/item/paper/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["close"])
		var/mob/user = usr
		if(user?.client && user.hud_used)
			if(user.hud_used.reads)
				user.hud_used.reads.destroy_read()
			user << browse(null, "window=reading")

	var/literate = usr.is_literate()
	var/admin_observer = isobserver(usr) && IsAdminGhost(usr)
	if(!admin_observer && !usr.canUseTopic(src, BE_CLOSE, literate))
		return

	if(href_list["read"])
		if(trapped)
			var/mob/living/victim = usr
			victim.visible_message(span_notice("[usr] opens the [src]."))
			to_chat(usr, span_warning("This parchment is full of strange symbols that start to glow. How odd. Wait-"))
			sleep(5)
			victim.adjust_fire_stacks(15)
			victim.ignite_mob()
			victim.visible_message(span_danger("[usr] bursts into flames upon reading [src]!"))
		read(usr)

	if(href_list["help"])
		openhelp(usr)
		return

	if(href_list["write"])
		var/id = href_list["write"]
		var/field_num = text2num(id)
		if(!field_num || field_num < 1 || field_num > min(fields, 15))
			to_chat(usr, span_warning("That field cannot be written to."))
			return
		var/obj/item/i = usr.get_active_held_item()	// Check implement first so the prompt only opens when write-capable.
		if(!istype(i, /obj/item/natural/thorn) && !istype(i, /obj/item/natural/feather))
			to_chat(usr, span_warning("I need a feather or thorn in hand to write."))
			return
		var/t =  stripped_multiline_input("Enter what you want to write:", "Write", no_trim=TRUE)
		if(!t || !usr.canUseTopic(src, BE_CLOSE, literate))
			return

		if(!in_range(src, usr) && loc != usr && loc.loc != usr && usr.get_active_held_item() != i)	//Some check to see if he's allowed to write
			return

		log_paper("[key_name(usr)] writing to paper [t]")
		t = parsepencode(t, i, usr, FALSE) // Encode everything from pencode to html

		if(t != null)	//No input from the user means nothing needs to be added
			if((length(info) + length(t)) > maxlen)
				to_chat(usr, "<span class='warning'>Too long. Try again.</span>")
				return
			addtofield(field_num, t) // Field-only writing via read links.
			playsound(src, 'sound/items/write.ogg', 100, FALSE)
			format_browse(build_read_info(TRUE), usr)
			update_icon_state()

/obj/item/paper/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(resistance_flags & ON_FIRE)
		return ..()

	if(mailer)
		return ..()

	if(is_blind(user))
		return ..()

	if(istype(P, /obj/item/natural/feather/infernal))
		if(trapped)
			to_chat(user, span_warning("[src] is already trapped."))
		else
			to_chat(user, span_warning("I draw infernal symbols on this [src], rigging it to explode."))
			trapped = TRUE

	if(istype(P, /obj/item/natural/thorn)|| istype(P, /obj/item/natural/feather))
		if(length(info) > maxlen)
			to_chat(user, "<span class='warning'>[src] is full of verba.</span>")
			return
		if(user.can_read(src))
			if(has_empty_fields())
				format_browse(build_read_info(TRUE), user)
			else
				open_writer_panel(user, P)
			return
		else
			to_chat(user, "<span class='warning'>I can't write.</span>")
			return

	// Sealing logic for seal items
	if(istype(P, /obj/item/seal))
		var/obj/item/seal/seal = P
		if(istype(seal, /obj/item/seal/custom))
			var/obj/item/seal/custom/custom_seal = seal
			if(!custom_seal.customized)
				to_chat(user, span_warning("This custom seal is blank. Use it in-hand first to engrave text and pick a color."))
				return
		if(seal.tallowed && info && !seal_label)
			seal.tallowed = FALSE
			seal.update_icon()
			seal_label = seal.seal_label
			seal_color = seal.seal_color
			seal_is_official = seal.seal_is_official
			seal_broken = FALSE
			update_icon()
			user.visible_message(span_notice("[user] seals [src] with [seal]."))
			return
		else
			if(!seal.tallowed)
				to_chat(user, span_warning("[seal] has no tallow on it. Dip it in a heated tallowpot first."))
			else if(!info)
				to_chat(user, span_warning("The [src] has nothing written on it to seal."))
			else if(seal_label)
				to_chat(user, span_warning("[src] is already sealed."))
			return

	// Sealing logic for signet rings
	if(istype(P, /obj/item/clothing/ring/signet))
		var/obj/item/clothing/ring/signet/ring = P
		if(ring.tallowed && info && !seal_label)
			ring.tallowed = FALSE
			ring.update_icon()
			seal_label = ring.seal_label
			seal_color = ring.seal_color
			seal_is_official = ring.seal_is_official
			seal_broken = FALSE
			update_icon()
			user.visible_message(span_notice("[user] seals [src] with [ring]."))
			return
		else
			if(!ring.tallowed)
				to_chat(user, span_warning("[ring] has no tallow on it. Dip it in a heated tallowpot first."))
			else if(!info)
				to_chat(user, span_warning("The [src] has nothing written on it to seal."))
			else if(seal_label)
				to_chat(user, span_warning("[src] is already sealed."))
			return
	
	if(istype(P, /obj/item/paper))
		var/obj/item/paper/p = P
		if(info && p.info)
			var/obj/item/manuscript/M = new /obj/item/manuscript(get_turf(P.loc))
			M.page_texts = list(src.info, p.info)
			M.compiled_pages = "<p>[src.info]</p><p>[p.info]</p>"
			qdel(p)
			if(user.Adjacent(M))
				M.add_fingerprint(user)
				user.update_inv_hands()
				user.put_in_active_hand(src)
				user.put_in_inactive_hand(M)
			. = ..()
			return qdel(src)
	if(!P.can_be_package_wrapped())
		return ..()

	if(!istype(src, /obj/item/paper/inqslip))
		to_chat(user, span_info("I start to wrap [P] in [src]..."))
		if(do_after(user, 30, 0, target = src))
			if(user.is_holding(P))
				if(!user.dropItemToGround(P))
					return
			else if(!isturf(P.loc))
				return
			var/obj/item/smallDelivery/D = new /obj/item/smallDelivery(get_turf(P.loc))
			if(user.Adjacent(D))
				D.add_fingerprint(user)
				P.add_fingerprint(user)
				user.put_in_hands(D)
			P.forceMove(D)
			var/size = round(P.w_class)
			D.name = "[weightclass2text(size)] package"
			D.w_class = size
			size = min(size, 5)
			D.grid_height = P.grid_height
			D.grid_width = P.grid_width
			D.icon_state = "deliverypackage[size]"
			D.note = src
			forceMove(D)

		add_fingerprint(user)
		return ..()
	else
		return ..()	

/obj/item/paper/fire_act(added, maxstacks)
	..()
	if(!(resistance_flags & FIRE_PROOF))
		add_overlay("paper_onfire_overlay")
		info = "[stars(info)]"


/obj/item/paper/extinguish()
	..()
	cut_overlay("paper_onfire_overlay")

/*
 * Construction paper
 */

/obj/item/paper/construction

/obj/item/paper/construction/Initialize(mapload)
	. = ..()
	color = pick("FF0000", "#33cc33", "#ffb366", "#551A8B", "#ff80d5", "#4d94ff")

/*
 * Natural paper
 */

/obj/item/paper/natural/Initialize(mapload)
	. = ..()
	color = "#FFF5ED"

/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"
	slot_flags = null

/obj/item/paper/crumpled/update_icon_state()
	return

/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"

/obj/item/paper/crumpled/muddy
	icon_state = "scrap_mud"

/obj/item/smallDelivery
	name = "package"
	desc = ""
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "deliverypackage3"
	item_state = "deliverypackage"
	var/giftwrapped = 0
	var/sortTag = 0
	var/obj/item/paper/note

/obj/item/smallDelivery/contents_explosion(severity, target)
	for(var/atom/movable/AM in contents)
		AM.ex_act()

/obj/item/smallDelivery/attack_self(mob/user)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	for(var/X in contents)
		var/atom/movable/AM = X
		user.put_in_hands(AM)
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	user.visible_message(span_warning("[user] opens [src]."))
	if(note)
		note.forceMove(user.loc)
	qdel(src)

/obj/item/smallDelivery/attack_self_tk(mob/user)
	if(ismob(loc))
		var/mob/M = loc
		M.temporarilyRemoveItemFromInventory(src, TRUE)
		for(var/X in contents)
			var/atom/movable/AM = X
			M.put_in_hands(AM)
	else
		for(var/X in contents)
			var/atom/movable/AM = X
			AM.forceMove(src.loc)
	if(note)
		note.forceMove(user.loc)
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	qdel(src)

/obj/item/smallDelivery/examine(mob/user)
	. = ..()
	if(note && length(note.info))
		if(!in_range(user, src))
			. += "There's a [note.name] attached to it. You can't read it from here."
		else
			. += "There's a [note.name] attached to it..."
			. += note.examine(user)
	if(mailer)
		. += "It's from [mailer], addressed to [mailedto].</a>"

/obj/item/smallDelivery/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/natural/feather))
		if(!user.is_literate())
			to_chat(user, span_notice("I scribble illegibly on the side of [src]!"))
			return
		var/str = copytext(sanitize(input(user,"Label text?","Set label","")),1,MAX_NAME_LEN)
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(!str || !length(str))
			to_chat(user, span_warning("Invalid text!"))
			return
		user.visible_message(span_notice("[user] labels [src] as [str]."))
		name = "[name] ([str])"

/obj/item/proc/can_be_package_wrapped() //can the item be wrapped with package wrapper into a delivery package
	return 1

/obj/item/storage/can_be_package_wrapped()
	return 0

/obj/item/storage/box/can_be_package_wrapped()
	return 1

/obj/item/storage/belt/rogue/pouch/can_be_package_wrapped()
	return 1

/obj/item/smallDelivery/can_be_package_wrapped()
	return 0

/obj/item/inqarticles/indexer/can_be_package_wrapped()
	return 0
