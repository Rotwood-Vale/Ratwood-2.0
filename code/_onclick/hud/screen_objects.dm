/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/atom/movable/screen
	name = ""
	icon = 'icons/mob/screen_gen.dmi'
	layer = HUD_LAYER
	plane = HUD_PLANE
	appearance_flags = APPEARANCE_UI
	blockscharging = TRUE
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.
	var/datum/hud/hud = null // A reference to the owner HUD, if any.
	var/lastclick
	var/category

/atom/movable/screen/Destroy()
	if(hud)
		UnregisterSignal(hud, COMSIG_QDELETING)
	master = null
	hud = null
	return ..()

/atom/movable/screen/proc/get_roguehud_icon(datum/preferences/prefs)
	if(!prefs)
		prefs = hud?.mymob?.client?.prefs
	if(prefs)
		return prefs.get_roguehud_icon()
	return 'icons/mob/roguehud.dmi'

/atom/movable/screen/proc/get_rogueheat_icon(datum/preferences/prefs)
	if(!prefs)
		prefs = hud?.mymob?.client?.prefs
	if(prefs)
		return prefs.get_rogueheat_icon()
	return 'icons/mob/rogueheat.dmi'

/atom/movable/screen/proc/apply_colorblind_hud_palette(datum/preferences/prefs)
	if(!prefs)
		prefs = hud?.mymob?.client?.prefs
	if(!prefs)
		return
	if(is_roguehud_palette_icon(icon))
		icon = prefs.get_roguehud_icon()
	else if(is_rogueheat_palette_icon(icon))
		icon = prefs.get_rogueheat_icon()
	// Preallocated vis_contents layers carry their own palette icon, so refresh them alongside our own.
	for(var/atom/movable/screen/hud_component/layer/component in vis_contents)
		if(is_roguehud_palette_icon(component.icon))
			component.icon = prefs.get_roguehud_icon()
		else if(is_rogueheat_palette_icon(component.icon))
			component.icon = prefs.get_rogueheat_icon()

/atom/movable/screen/Click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	var/mob/user = usr
	var/paramslist = params2list(params)
	if(paramslist["shift"] && paramslist["left"]) // screen objects don't do the normal Click() stuff so we'll cheat
		examine_ui(user)
		return FALSE

/atom/movable/screen/proc/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")


/atom/movable/screen/orbit()
	return

/atom/movable/screen/proc/component_click(atom/movable/screen/component_button/component, params)
	return

/atom/movable/screen/proc/set_new_hud(datum/hud/new_hud)
	if(hud)
		UnregisterSignal(hud, COMSIG_QDELETING)
	hud = new_hud
	if(hud)
		RegisterSignal(hud, COMSIG_QDELETING, PROC_REF(clear_hud))

/atom/movable/screen/proc/clear_hud(datum/source)
	SIGNAL_HANDLER
	set_new_hud(null)

/atom/movable/screen/proc/get_human_owner()
	return hud?.get_human_owner()

/atom/movable/screen/proc/create_hud_component_layer(icon_file = null, icon_state = null, layer_offset = 0, plane_offset = 0)
	var/atom/movable/screen/hud_component/layer/layer_object = new(src)
	if(icon_file)
		layer_object.icon = icon_file
	if(!isnull(icon_state))
		layer_object.icon_state = icon_state
	layer_object.layer = layer + layer_offset
	layer_object.plane = plane + plane_offset
	vis_contents += layer_object
	return layer_object

/atom/movable/screen/proc/create_hud_component_layer_pool(count, icon_file = null, layer_offset = 0, plane_offset = 0)
	. = list()
	for(var/i in 1 to count)
		. += create_hud_component_layer(icon_file, null, layer_offset, plane_offset)

/atom/movable/screen/proc/reset_hud_component_layer(atom/movable/screen/hud_component/layer/layer_object)
	if(!layer_object)
		return
	animate(layer_object, flags = ANIMATION_END_NOW)
	layer_object.alpha = 0
	layer_object.color = null
	layer_object.maptext = null
	layer_object.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer_object.transform = null

/atom/movable/screen/hud_component
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER

/atom/movable/screen/hud_component/layer
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_PLANE
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER

/atom/movable/screen/text
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480

/atom/movable/screen/swap_hand
	layer = HUD_LAYER
	plane = HUD_PLANE
	name = "swap hand"

/atom/movable/screen/swap_hand/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return 1

	if(ismob(usr))
		var/mob/M = usr
		M.swap_hand()
	return 1

/atom/movable/screen/skills
	name = "skills"
	icon_state = "skills"
	screen_loc = ui_skill_menu

/atom/movable/screen/skills/Click(location, control, params)
	var/list/modifiers = params2list(params)

	if(modifiers["right"])
		var/ht
		var/mob/living/L = usr
		to_chat(L, "*----*")
		if(ishuman(usr))
			var/mob/living/carbon/human/M = usr
			if(length(M.vices))
				for(var/datum/charflaw/vice in M.vices)
					to_chat(M, "<span class='info'><small>[vice.desc]</small></span>")
				to_chat(M, "*----*")
			else if(M.charflaw)
				to_chat(M, "<span class='info'>[M.charflaw.desc]</span>")
				to_chat(M, "*----*")
			if(M.mind)
				if(M.mind.language_holder)
					var/finn
					for(var/X in M.mind.language_holder.languages)
						if(!X || !ispath(X, /datum/language))
							continue
						var/datum/language/LA = new X()
						finn = TRUE
						to_chat(M, "<span class='info'>[LA.name] - ,[LA.key]</span>")
					if(!finn)
						to_chat(M, "<span class='warning'>I don't know any languages.</span>")
					else // open_language_menu
						to_chat(M, "<a href='?src=[REF(M)];task=open_language_menu;'>Language Menu</a>")
					to_chat(M, "*----*")
		for(var/X in GLOB.roguetraits)
			if(HAS_TRAIT(L, X))
				to_chat(L, "[X] - <span class='info'>[GLOB.roguetraits[X]]</span>")
				ht = TRUE
		if(!ht)
			to_chat(L, "<span class='warning'>I have no special traits.</span>")
		to_chat(L, "*----*")
		return

	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.print_levels(H)

/atom/movable/screen/craft
	name = "crafting menu"
	icon_state = "craft"
	screen_loc = rogueui_craft
	var/last_craft

/atom/movable/screen/craft/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(world.time < lastclick + 3 SECONDS)
		return
	lastclick = world.time

	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(modifiers["right"])
			var/area/A = get_area(H)
			if(!A.can_craft_here())
				to_chat(H, span_warning("You cannot craft here."))
				return
			if(H.craftingthing && (H.mind?.lastrecipe != null))
				last_craft = world.time
				var/datum/component/personal_crafting/C = H.craftingthing
				to_chat(H, span_warning("I am crafting \a [H.mind?.lastrecipe] again."))
				C.construct_item(H, H.mind?.lastrecipe)
		else
			H.playsound_local(H, 'sound/misc/click.ogg', 100)
			if(H.craftingthing)
				last_craft = world.time
				var/datum/component/personal_crafting/C = H.craftingthing
				if(H.client.legacycraft)
					C.roguecraft(location, control, params, H)
				else
					C.ui_interact(H)
			else
				testing("what")

/atom/movable/screen/area_creator
	name = "create new area"
	icon_state = "area_edit"
	screen_loc = ui_building

/atom/movable/screen/area_creator/Click()
	if(usr.incapacitated() || (isobserver(usr) && !IsAdminGhost(usr)))
		return TRUE
	var/area/A = get_area(usr)
	if(!A.outdoors)
		to_chat(usr, "<span class='warning'>There is already a defined structure here.</span>")
		return TRUE
	create_area(usr)

/atom/movable/screen/language_menu
	name = "language menu"
	icon_state = "talk_wheel"
	screen_loc = ui_language_menu

/atom/movable/screen/language_menu/Click()
	var/mob/M = usr
	var/datum/language_holder/H = M.get_language_holder()
	H.open_language_menu(usr)

/atom/movable/screen/inventory
	/// The identifier for the slot. It has nothing to do with ID cards.
	var/slot_id
	/// Icon when empty. For now used only by humans.
	var/icon_empty
	/// Icon when contains an item. For now used only by humans.
	var/icon_full = "genslot"
	/// Preview layer shown when hovering over the slot with an item in hand.
	var/atom/movable/screen/hud_component/layer/hover_preview_layer
	layer = HUD_LAYER
	plane = HUD_PLANE
	nomouseover = FALSE

/atom/movable/screen/inventory/New()
	. = ..()
	hover_preview_layer = create_hud_component_layer(null, null, 0.01)
	clear_hover_overlay()

/atom/movable/screen/inventory/Destroy()
	if(hud?.overlay_curloc == src)
		hud.overlay_curloc = null
	QDEL_NULL(hover_preview_layer)
	return ..()

/atom/movable/screen/inventory/proc/clear_hover_overlay()
	if(hover_preview_layer)
		reset_hud_component_layer(hover_preview_layer)

/atom/movable/screen/inventory/proc/update_hover_overlay(obj/item/holding, can_equip)
	if(!hover_preview_layer || !holding)
		return
	hover_preview_layer.appearance = holding.appearance
	hover_preview_layer.appearance_flags = APPEARANCE_UI | KEEP_TOGETHER
	hover_preview_layer.layer = layer + 0.01
	hover_preview_layer.plane = plane
	hover_preview_layer.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	hover_preview_layer.alpha = 92
	hover_preview_layer.color = can_equip ? "#c5c5c5" : "#fd0279"


/atom/movable/screen/inventory/Click(location, control, params)
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return TRUE

	if(usr.incapacitated())
		return TRUE

	if(hud?.mymob && slot_id)
		var/obj/item/inv_item = hud.mymob.get_item_by_slot(slot_id)
		if(inv_item)
			return inv_item.Click(location, control, params)

	if(usr.attack_ui(slot_id, params))
		usr.update_inv_hands()
	return TRUE

/atom/movable/screen/inventory/MouseEntered(location, control, params)
	. = ..()
	add_overlays()

/atom/movable/screen/inventory/MouseExited()
	..()
	if(hud)
		cut_overlay(hud.object_overlay)
		hud.object_overlay = null

/atom/movable/screen/inventory/update_icon_state()
	if(!icon_empty)
		icon_empty = icon_state

	if(hud?.mymob && slot_id && icon_full)
		var/obj/item/I = hud.mymob.get_item_by_slot(slot_id)
		if(I)
			icon_state = icon_full
			if(I.max_integrity)
				if(I.obj_integrity < I.max_integrity)
					icon_state = "slotdmg"
					if(I.integrity_failure)
						if((I.obj_integrity / I.max_integrity) <= I.integrity_failure)
							icon_state = "slotbroke"
		else
			icon_state = icon_empty

/atom/movable/screen/inventory/proc/add_overlays()
	var/mob/user = hud?.mymob

	if(hud?.overlay_curloc && hud.overlay_curloc != src)
		var/atom/movable/screen/inventory/previous_slot = hud.overlay_curloc
		previous_slot?.clear_hover_overlay()

	if(!user || !slot_id)
		if(hud?.overlay_curloc == src)
			clear_hover_overlay()
			hud.overlay_curloc = null
		return

	var/obj/item/holding = user.get_active_held_item()

	if(!holding || user.get_item_by_slot(slot_id))
		if(hud?.overlay_curloc == src)
			clear_hover_overlay()
			hud.overlay_curloc = null
		return

	if(hud)
		hud.overlay_curloc = src
	update_hover_overlay(holding, user.can_equip(holding, slot_id, disable_warning = TRUE, bypass_equip_delay_self = TRUE))


/atom/movable/screen/inventory/hand
	nomouseover =  TRUE
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER
	var/atom/movable/screen/hud_component/layer/handcuff_layer
	var/atom/movable/screen/hud_component/layer/blocked_layer
	var/atom/movable/screen/hud_component/layer/grabbed_layer
	var/atom/movable/screen/hud_component/layer/active_layer
	var/held_index = 0

/atom/movable/screen/inventory/hand/New()
	. = ..()
	handcuff_layer = create_hud_component_layer('icons/mob/screen_gen.dmi', null, 0.01)
	blocked_layer = create_hud_component_layer('icons/mob/screen_gen.dmi', "blocked", 0.02)
	grabbed_layer = create_hud_component_layer('icons/mob/screen_gen.dmi', "grabbed", 0.03)
	active_layer = create_hud_component_layer(icon, "hand_active", 0.04)
	reset_hud_component_layer(handcuff_layer)
	reset_hud_component_layer(blocked_layer)
	reset_hud_component_layer(grabbed_layer)
	reset_hud_component_layer(active_layer)

/atom/movable/screen/inventory/hand/Destroy()
	QDEL_NULL(handcuff_layer)
	QDEL_NULL(blocked_layer)
	QDEL_NULL(grabbed_layer)
	QDEL_NULL(active_layer)
	return ..()

/atom/movable/screen/inventory/hand/update_overlays()
	. = ..()
	update_hand_vis()

/atom/movable/screen/inventory/hand/proc/update_hand_vis()
	if(!handcuff_layer || !blocked_layer || !grabbed_layer || !active_layer)
		return

	var/mark_state = (!(held_index % 2)) ? "markus" : "gabrielle"
	if(handcuff_layer.icon_state != mark_state)
		handcuff_layer.icon_state = mark_state

	var/mob/owner = hud?.mymob
	if(!owner)
		reset_hud_component_layer(handcuff_layer)
		reset_hud_component_layer(blocked_layer)
		reset_hud_component_layer(grabbed_layer)
		reset_hud_component_layer(active_layer)
		return

	if(active_layer.icon != icon)
		active_layer.icon = icon
	if(active_layer.icon_state != "hand_active")
		active_layer.icon_state = "hand_active"
	active_layer.alpha = held_index == owner.active_hand_index ? 255 : 0

	var/show_handcuff = FALSE
	var/show_blocked = FALSE
	var/show_grabbed = FALSE
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		show_handcuff = !!C.handcuffed
		if(held_index)
			show_grabbed = !!C.check_arm_grabbed(held_index)
			show_blocked = !C.has_hand_for_held_index(held_index)

	handcuff_layer.alpha = show_handcuff ? 255 : 0
	blocked_layer.alpha = show_blocked ? 255 : 0
	grabbed_layer.alpha = show_grabbed ? 255 : 0

/atom/movable/screen/inventory/hand/add_overlays()
	return

/atom/movable/screen/inventory/hand/Click(location, control, params)
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	var/mob/user = hud?.mymob
	if(usr != user)
		return TRUE
	if(world.time <= user.next_move)
		return TRUE

	if(user.active_hand_index == held_index)
		var/obj/item/I = user.get_active_held_item()
		if(I)
			I.Click(location, control, params)
	else
		user.swap_hand(held_index)
	return TRUE

/atom/movable/screen/close
	name = "close"
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE
	icon_state = "backpack_close"

/atom/movable/screen/close/Initialize(mapload, new_master)
	. = ..()
	master = new_master

/atom/movable/screen/close/Click()
	var/datum/component/storage/S = master
	S.hide_from(usr)
	return TRUE

/atom/movable/screen/drop
	name = "drop"
	icon_state = "act_drop"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/drop/Click()
	if(ismob(usr))
		var/mob/M = usr
		M.playsound_local(M, 'sound/misc/click.ogg', 100)
	if(usr.stat == CONSCIOUS)
		usr.dropItemToGround(usr.get_active_held_item())

/atom/movable/screen/act_intent
	name = "intent"
	icon_state = "help"
	screen_loc = ui_acti

/atom/movable/screen/act_intent/Click(location, control, params)
	usr.a_intent_change(INTENT_HOTKEY_RIGHT)

/atom/movable/screen/act_intent/segmented/Click(location, control, params)
	if(usr.client.prefs.toggles & INTENT_STYLE)
		var/_x = text2num(params2list(params)["icon-x"])
		var/_y = text2num(params2list(params)["icon-y"])

		if(_x<=16 && _y<=16)
			usr.a_intent_change(INTENT_HARM)

		else if(_x<=16 && _y>=17)
			usr.a_intent_change(INTENT_HELP)

		else if(_x>=17 && _y<=16)
			usr.a_intent_change(INTENT_GRAB)

		else if(_x>=17 && _y>=17)
			usr.a_intent_change(INTENT_DISARM)
	else
		return ..()

/atom/movable/screen/act_intent/proc/switch_intent(index as num)
	return



/atom/movable/screen/act_intent/rogintent
	name = ""
	desc = ""
	icon = 'icons/mob/rogueintentbase.dmi'
	icon_state = "intentbase"
	screen_loc = rogueui_intents
	var/list/atom/movable/screen/hud_component/layer/intent_slots
	var/list/atom/movable/screen/hud_component/layer/border_slots

/atom/movable/screen/act_intent/rogintent/New()
	. = ..()
	intent_slots = create_hud_component_layer_pool(4, 'icons/mob/roguehud.dmi', 0.02)
	border_slots = create_hud_component_layer_pool(2, 'icons/mob/roguehud.dmi', 0.01)
	for(var/atom/movable/screen/hud_component/layer/slot as anything in intent_slots)
		reset_hud_component_layer(slot)
	for(var/atom/movable/screen/hud_component/layer/slot as anything in border_slots)
		reset_hud_component_layer(slot)

/atom/movable/screen/act_intent/rogintent/Destroy()
	QDEL_LIST(intent_slots)
	QDEL_LIST(border_slots)
	intent_slots = null
	border_slots = null
	return ..()

/atom/movable/screen/act_intent/rogintent/proc/reset_rogintent_layers()
	if(intent_slots)
		for(var/atom/movable/screen/hud_component/layer/slot as anything in intent_slots)
			reset_hud_component_layer(slot)
	if(border_slots)
		for(var/atom/movable/screen/hud_component/layer/slot as anything in border_slots)
			reset_hud_component_layer(slot)

/atom/movable/screen/act_intent/rogintent/proc/set_rogintent_slot(atom/movable/screen/hud_component/layer/slot, new_state, slot_index, layer_offset, icon_file = 'icons/mob/roguehud.dmi')
	if(!slot || !new_state || slot_index < 1 || slot_index > 4)
		return
	if(slot.icon != icon_file)
		slot.icon = icon_file
	if(slot.icon_state != new_state)
		slot.icon_state = new_state
	slot.alpha = 255
	switch(slot_index)
		if(1)
			slot.pixel_x = 64
			slot.pixel_y = 16
		if(2)
			slot.pixel_x = 96
			slot.pixel_y = 16
		if(3)
			slot.pixel_x = 64
			slot.pixel_y = 0
		if(4)
			slot.pixel_x = 96
			slot.pixel_y = 0
	slot.layer = layer + layer_offset

/atom/movable/screen/act_intent/rogintent/update_icon(list/intentsl,list/intentsr, oactive = FALSE)
	..()
	reset_rogintent_layers()
	if(!intentsl || !intentsr)
		return
	else
		var/lol = 0
		var/list/used = intentsr
		var/roguehud_icon = get_roguehud_icon()
		if(hud.mymob.active_hand_index == 1)
			used = intentsl
		for(var/datum/intent/intenty in used)
			lol++
			if(lol > length(intent_slots))
				break
			set_rogintent_slot(intent_slots[lol], intenty.icon_state, lol, 0.02, roguehud_icon)
		var/mob/living/owner = hud?.mymob
		if(owner)
			switch_intent(owner.r_index, owner.l_index, oactive)

/atom/movable/screen/act_intent/rogintent/switch_intent(r_index, l_index, oactive = FALSE)
	if(border_slots)
		for(var/atom/movable/screen/hud_component/layer/slot as anything in border_slots)
			reset_hud_component_layer(slot)
	var/used = "offintent"
	if(oactive)
		used = "offintentselected"
	if(!r_index || !l_index)
		return
	else
		var/roguehud_icon = get_roguehud_icon()
		var/used_index = r_index
		var/other = l_index
		if(hud.mymob.active_hand_index == 1)
			used_index = l_index
			other = r_index
		if(length(border_slots) >= 2)
			set_rogintent_slot(border_slots[1], "intentselected", used_index, 0.01, roguehud_icon)
			set_rogintent_slot(border_slots[2], used, other, 0.01, roguehud_icon)

/atom/movable/screen/act_intent/rogintent/Click(location, control, params)

	var/list/modifiers = params2list(params)

	var/mob/user = hud?.mymob
	if(usr != user)
		return TRUE

	user.playsound_local(user, 'sound/misc/click.ogg', 100)

	if(usr.client.prefs.toggles & INTENT_STYLE)
		var/_x = text2num(params2list(params)["icon-x"])
		var/_y = text2num(params2list(params)["icon-y"])
		var/clicked = get_index_at_loc(_x, _y)
		if(!clicked)
			return
/*		if(_x<=64)
			if(user.active_hand_index == 2)
				if(modifiers["right"])
					if(clicked != user.l_index)
						user.rog_intent_change(clicked,1)
					else
						if(user.oactive)
							user.oactive = FALSE
//						else
//							user.oactive = TRUE
						switch_intent(user.r_index, user.l_index, user.oactive)
					return
				if(!user.swap_hand(1))
					return
			if(modifiers["left"])
				if(modifiers["shift"])
					user.examine_intent(clicked, FALSE)
					return
			user.rog_intent_change(clicked)
		else*/
//			if(user.active_hand_index == 1)
//				if(modifiers["right"])
//					if(clicked != user.r_index)
//						user.rog_intent_change(clicked,1)
//					else
//						if(user.oactive)
//							user.oactive = FALSE
//						else
//							user.oactive = TRUE
//						switch_intent(user.r_index, user.l_index, user.oactive)
//					return
//				if(!user.swap_hand(2))
//					return
		if(modifiers["left"])
			if(modifiers["shift"])
				user.examine_intent(clicked, FALSE)
				return
		user.rog_intent_change(clicked)

/atom/movable/screen/act_intent/rogintent/proc/get_index_at_loc(xl, yl)
/*	if(xl<=64)
		if(xl<32)
			if(yl>16)
				return 1
			else
				return 3
		else
			if(yl>16)
				return 2
			else
				return 4
	else*/
	if(xl > 64)
		if(xl<96)
			if(yl>16)
				return 1
			else
				return 3
		else
			if(yl>16)
				return 2
			else
				return 4

//

/atom/movable/screen/quad_intents
	name = "mmb intents"
	icon_state = "mmbintents0"
	icon = 'icons/mob/roguehud.dmi'
	screen_loc = rogueui_quad

/atom/movable/screen/quad_intents/proc/switch_intent(input)
	icon_state = "mmbintents0"
	if(input in 1 to 4)
		icon_state = "mmbintents[input]"

/atom/movable/screen/quad_intents/Click(location, control, params)
	if(ismob(usr))
		var/mob/M = usr
		M.playsound_local(M, 'sound/misc/click.ogg', 100)

	var/_y = text2num(params2list(params)["icon-y"])

	if(_y<=9)
		usr.mmb_intent_change(QINTENT_STEAL)

	else if(_y>=9 && _y<=16)
		usr.mmb_intent_change(QINTENT_KICK)

	else if(_y>=17 && _y<=24)
		usr.mmb_intent_change(QINTENT_JUMP)

	else if(_y>=24 && _y<=32)
		usr.mmb_intent_change(QINTENT_BITE)


/atom/movable/screen/give_intent
	name = "give/take"
	icon_state = "take0"
	icon = 'icons/mob/roguehud.dmi'
	screen_loc = rogueui_give
	var/giving = 0

/atom/movable/screen/give_intent/proc/switch_intent(ass)
	if(ass == QINTENT_GIVE)
		giving = 1
	else
		giving = 0
	update_icon()

/atom/movable/screen/give_intent/Click(location, control, params)
	if(ismob(usr))
		var/mob/M = usr
		M.playsound_local(M, 'sound/misc/click.ogg', 100)
	usr.mmb_intent_change(QINTENT_GIVE)

/atom/movable/screen/give_intent/update_icon()
	..()
	if(ismob(usr))
		var/mob/M = usr
		if(M.get_active_held_item())
			icon_state = "give[giving]"
		else
			icon_state = "take[giving]"

//

/atom/movable/screen/def_intent
	name = "defense intent"
	icon_state = "def1n"
	icon = 'icons/mob/roguehud.dmi'
	screen_loc = rogueui_def

/atom/movable/screen/def_intent/update_icon()
	icon_state = "def[hud.mymob.d_intent]n"

/atom/movable/screen/def_intent/Click(location, control, params)
	var/_y = text2num(params2list(params)["icon-y"])

	if(_y>=0 && _y<17)
		usr.def_intent_change(INTENT_DODGE)
	else if(_y>16 && _y<=32)
		usr.def_intent_change(INTENT_PARRY)


/atom/movable/screen/cmode
	name = "combat mode"
	icon_state = "combat0"
	icon = 'icons/mob/roguehud.dmi'
	screen_loc = rogueui_cmode

/atom/movable/screen/cmode/update_icon()
	icon_state = "combat[hud.mymob.cmode]"

/atom/movable/screen/cmode/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(isliving(usr))
		var/mob/living/L = usr
		if(modifiers["right"])
			L.playsound_local(L, 'sound/misc/click.ogg', 100)
			L.submit()
		else if(modifiers["middle"])
			if(L.mob_timers["complybutton"]) // I am fed up with trying to triage issues that new middle click code has. Here, have hacky workaround. - Zoktiik
				if(world.time < (L.mob_timers["complybutton"] + 0.5 SECONDS))
					return
			L.mob_timers["complybutton"] = world.time
			L.playsound_local(L, 'sound/misc/click.ogg', 100)
			L.toggle_compliance()
		else if(modifiers["shift"] && modifiers["left"])
			to_chat(usr, span_info("* --- *\n\
			Combat mode button.\n\
			<b>Left click:</b> toggles combat mode at-will, allowing you to parry or dodge attacks. Usually costs energy (blue stamina) to keep active. Also allows some more destructive interactions with objects.\n\
			<b>Right click:</b> makes you visibly surrender, showing a white flag above your head and rendering you temporarily unable to move or fight.\n\
			<b>Middle click:</b> toggles compliance mode at-will, removing your defense against grapples and tackles. Also makes it faster to restrain and strip you.\n\
			All of these have configurable keybinds; see the Keybinds settings in your preferences window."))
		else
			L.playsound_local(L, 'sound/misc/click.ogg', 100)
			L.toggle_cmode()
			update_icon()

/atom/movable/screen/mov_intent
	name = "run/walk toggle"
	icon_state = "running"

/atom/movable/screen/mov_intent/Click(location, control, params)
	toggle(usr)

/atom/movable/screen/mov_intent/update_icon_state()
	switch(hud?.mymob?.m_intent)
		if(MOVE_INTENT_WALK)
			icon_state = "walking"
		if(MOVE_INTENT_RUN)
			icon_state = "running"

/atom/movable/screen/mov_intent/proc/toggle(mob/user)
	if(isobserver(user))
		return
	user.toggle_move_intent(user)

/atom/movable/screen/rogmove
	name = "sneak mode"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "sneak0"
	screen_loc = rogueui_moves

/atom/movable/screen/rogmove/Click(location, control, params)
	var/mob/M = usr
	toggle(M)

/atom/movable/screen/rogmove/proc/toggle(mob/user)
	if(isobserver(user))
		return
	if(user.m_intent == MOVE_INTENT_SNEAK)
		user.toggle_rogmove_intent(MOVE_INTENT_WALK)
	else
		user.toggle_rogmove_intent(MOVE_INTENT_SNEAK)
	update_icon_state()
	user.update_sneak_invis()

/atom/movable/screen/rogmove/update_icon_state()
	if(hud?.mymob?.m_intent == MOVE_INTENT_SNEAK)
		icon_state = "sneak1"
	else
		icon_state = "sneak0"

/atom/movable/screen/rogmove/sprint
	name = "sprint mode"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "sprint0"
	screen_loc = rogueui_moves

/atom/movable/screen/rogmove/sprint/toggle(mob/user)
	if(isobserver(user))
		return
	if(user.m_intent == MOVE_INTENT_RUN)
		user.toggle_rogmove_intent(MOVE_INTENT_WALK)
	else
		user.toggle_rogmove_intent(MOVE_INTENT_RUN)
	update_icon_state()

/atom/movable/screen/rogmove/sprint/update_icon_state()
	if(hud?.mymob?.m_intent == MOVE_INTENT_RUN)
		icon_state = "sprint1"
	else
		icon_state = "sprint0"



/atom/movable/screen/advsetup
	name = ""
	icon = null
	icon_state = ""

/atom/movable/screen/advsetup/New(client/C) //TODO: Make this use INITIALIZE_IMMEDIATE, except its not easy
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_mob)), 30)

/atom/movable/screen/advsetup/Destroy()
	hud.static_inventory -= src
	return ..()

/atom/movable/screen/advsetup/proc/check_mob()
	if(QDELETED(src))
		return
	if(!hud)
		qdel(src)
		return
	if(!ishuman(hud.mymob))
		qdel(src)
		return
	var/mob/living/carbon/human/H = hud.mymob
	if(H.advsetup)
		alpha = 0
		icon = 'icons/mob/advsetup.dmi'
		animate(src, alpha = 255, time = 30)

/atom/movable/screen/advsetup/Click(location,control,params)
	if(!hud)
		qdel(src)
		return
	if(!ishuman(hud.mymob))
		qdel(src)
		return
	var/mob/living/carbon/human/H = hud.mymob
	if(!H.advsetup)
		qdel(src)
		return
	else
		SSrole_class_handler.setup_class_handler(H)

/atom/movable/screen/eye_intent
	name = "eye intent"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "eye"

/atom/movable/screen/eye_intent/Click(location,control,params)
	var/list/modifiers = params2list(params)
	var/_y = text2num(params2list(params)["icon-y"])

	hud.mymob.playsound_local(hud.mymob, 'sound/misc/click.ogg', 100)
	if(isliving(hud?.mymob))
		var/mob/living/L = hud.mymob
		if(L.eyesclosed)
			L.eyesclosed = 0
			L.cure_blind("eyelids")

	if(modifiers["left"])
		if(_y>=29 || _y<=4)
			if(isliving(hud.mymob))
				var/mob/living/L = hud.mymob
				L.eyesclosed = 1
				L.become_blind("eyelids")
		else
			toggle(usr)

	if(modifiers["middle"])
		if(isliving(hud.mymob))
			var/mob/living/L = hud.mymob
			L.look_up()
	update_icon()

	if(modifiers["right"])
		if(isliving(hud.mymob))
			var/mob/living/L = hud.mymob
			L.look_around()

/atom/movable/screen/eye_intent/update_icon_state()
	. = ..()
	var/mob/living/L = hud.mymob
	if(!istype(L))
		icon_state = "eye"
		return
	if(L.eyesclosed)
		icon_state = "eye_closed"
	else if(L.tempfixeye)
		icon_state = "eye_target"
	else if(L.fixedeye)
		icon_state = "eye_fixed"
	else
		icon_state = "eye"

/atom/movable/screen/eye_intent/update_overlays()
	. = ..()
	var/mob/living/carbon/human/human = hud.mymob
	if(!istype(human))
		return
	var/mutable_appearance/iris = mutable_appearance(src.icon, "oeye")
	switch(icon_state)
		if("eye_closed")
			iris.icon_state = "oeye_closed"
		if("eye_target")
			iris.icon_state = "oeye_target"
		if("eye_fixed")
			iris.icon_state = "oeye_fixed"
		else
			iris.icon_state = "oeye"
	iris.color = human.get_eye_color()
	. += iris

/atom/movable/screen/eye_intent/proc/toggle(mob/user)
	if(isobserver(user))
		return
	user.toggle_eye_intent(user)

/atom/movable/screen/pull
	name = "stop pulling"
	icon_state = "pull"

/atom/movable/screen/pull/Click()
	if(isobserver(usr))
		return
	usr.stop_pulling()

/atom/movable/screen/pull/update_icon_state()
	if(hud?.mymob?.pulling)
		icon_state = "pull"
	else
		icon_state = "pull0"

/atom/movable/screen/rest
	name = "rest"
	icon_state = "act_rest"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/rest/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		L.lay_down()

/atom/movable/screen/rest/update_icon_state()
	var/mob/living/user = hud?.mymob
	if(!istype(user))
		return

	if(!user.resting)
		icon_state = "act_rest"
	else
		icon_state = "act_rest0"

/atom/movable/screen/restup
	name = "stand up"
	icon_state = "act_rest_up"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/restup/Click(location, control, params)
	var/paramslist = params2list(params)

	if(isliving(usr))
		var/mob/living/L = usr
		if(paramslist["right"])
			L.look_up()
		else
			L.stand_up()

/atom/movable/screen/restdown
	name = "lay down"
	icon_state = "act_rest_down"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/restdown/Click(location, control, params)
	var/paramslist = params2list(params)

	if(isliving(usr))
		var/mob/living/L = usr
		if(paramslist["right"])
			var/turf/O
			for(var/turf/T in range(1, L))
				if(istransparentturf(T))
					O = T
					break
			L.look_down(O)
		else
			L.lay_down()

/atom/movable/screen/storage
	name = "storage"
	icon_state = "block"
	screen_loc = "7,7 to 10,8"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/storage/Initialize(mapload, new_master)
	. = ..()
	master = new_master

/atom/movable/screen/storage/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		if(master)
			var/obj/item/flipper = usr.get_active_held_item()
			if(!flipper)
				return
			if((!usr.Adjacent(flipper) && !usr.IsDirectlyAccessible(flipper)) || !isliving(usr) || usr.incapacitated())
				return
			var/old_width = flipper.grid_width
			var/old_height = flipper.grid_height
			flipper.grid_height = old_width
			flipper.grid_width = old_height
			update_hovering(location, control, params)
			return

	if(world.time <= usr.next_move)
		return TRUE
	if(usr.incapacitated())
		return TRUE
	if(master)
		var/obj/item/I = usr.get_active_held_item()
		if(I)
			master.attackby(src, I, usr, params, TRUE)
	return TRUE

/atom/movable/screen/throw_catch
	name = "throw/catch"
	icon_state = "catch0"
	var/throwy = 0

/atom/movable/screen/throw_catch/Click()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.toggle_throw_mode()

/atom/movable/screen/throw_catch/update_icon()
	..()
	if(ismob(usr))
		var/mob/M = usr
		if(M.get_active_held_item())
			icon_state = "throw[throwy]"
		else
			icon_state = "catch[throwy]"

/atom/movable/screen/zone_sel
	name = "damage zone"
	icon = 'icons/mob/roguehud64.dmi' // The m-/f-zone_sel base doll states only exist here, not in the regular HUD style.
	icon_state = "m-zone_sel"
	screen_loc = rogueui_targetdoll
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER
	var/overlay_icon = 'icons/mob/roguehud64.dmi'
	var/list/atom/movable/screen/hud_component/layer/zone_overlay_slots
	var/list/atom/movable/screen/hud_component/layer/highlight_slots
	var/atom/movable/screen/hud_component/layer/hover_preview_layer
	var/list/highlight_tokens
	var/zone_overlay_count = 0
	var/zone_overlay_cursor = 1
	var/next_highlight_slot = 1
	var/hovering_zone

#define ZONE_SELECTOR_SLOT_COUNT 48
#define ZONE_SELECTOR_HIGHLIGHT_SLOTS 4

/atom/movable/screen/zone_sel/New()
	. = ..()
	zone_overlay_slots = create_hud_component_layer_pool(ZONE_SELECTOR_SLOT_COUNT, overlay_icon, 0.05)
	highlight_slots = create_hud_component_layer_pool(ZONE_SELECTOR_HIGHLIGHT_SLOTS, overlay_icon, 0.9, 1)
	hover_preview_layer = create_hud_component_layer(overlay_icon, null, 0.85)
	highlight_tokens = list()
	for(var/atom/movable/screen/hud_component/layer/slot as anything in zone_overlay_slots)
		reset_hud_component_layer(slot)
	for(var/atom/movable/screen/hud_component/layer/highlight as anything in highlight_slots)
		reset_hud_component_layer(highlight)
	reset_hud_component_layer(hover_preview_layer)
	for(var/i in 1 to length(highlight_slots))
		highlight_tokens += 0

/atom/movable/screen/zone_sel/Destroy()
	QDEL_LIST(zone_overlay_slots)
	QDEL_LIST(highlight_slots)
	QDEL_NULL(hover_preview_layer)
	zone_overlay_slots = null
	highlight_slots = null
	hover_preview_layer = null
	highlight_tokens = null
	return ..()

/atom/movable/screen/zone_sel/Click(location, control,params)
	if(isobserver(usr))
		return

	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/choice = resolve_zone_choice(icon_x, icon_y)
	if (!choice)
		return 1

	if(PL["right"] && ishuman(hud.mymob))
		var/mob/living/carbon/human/H = hud.mymob
		return H.check_limb_for_injuries(H, choice = check_zone(choice))
	else
		return set_selected_zone(choice, usr)

/atom/movable/screen/zone_sel/MouseEntered(location, control, params)
	. = ..()
	MouseMove(location, control, params)

/atom/movable/screen/zone_sel/MouseMove(location, control, params)
	if(isobserver(usr))
		return

	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	update_hover_preview(resolve_zone_choice(icon_x, icon_y))

/atom/movable/screen/zone_sel/MouseExited(location, control, params)
	..()
	update_hover_preview(null)

/atom/movable/screen/zone_sel/proc/update_hover_preview(choice)
	if(hovering_zone == choice)
		return

	hovering_zone = choice
	if(!hover_preview_layer || !choice || !hud?.mymob)
		reset_hud_component_layer(hover_preview_layer)
		return

	var/gender_prefix = hud.mymob.gender == FEMALE ? "f" : "m"
	if(hover_preview_layer.icon != overlay_icon)
		hover_preview_layer.icon = overlay_icon
	hover_preview_layer.icon_state = "[gender_prefix]_[choice]"
	hover_preview_layer.color = null
	hover_preview_layer.alpha = 128
	hover_preview_layer.layer = layer + 0.85

/atom/movable/screen/zone_sel/proc/resolve_zone_choice(icon_x, icon_y)
	var/gender = MALE
	if(ismob(hud?.mymob))
		var/mob/M = hud.mymob
		if(M.gender == FEMALE)
			gender = FEMALE
	return get_zone_at(icon_x, icon_y, gender)

/atom/movable/screen/zone_sel/proc/get_zone_at(icon_x, icon_y, gender = MALE)
	if(gender == MALE)
		switch(icon_y)
			if(1 to 3)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(17 to 28)
						return BODY_ZONE_PRECISE_R_FOOT
					if(38 to 49)
						return BODY_ZONE_PRECISE_L_FOOT
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(4 to 5)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(17 to 28)
						return BODY_ZONE_PRECISE_R_FOOT
					if(38 to 49)
						return BODY_ZONE_PRECISE_L_FOOT
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(6 to 15)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(20 to 29)
						return BODY_ZONE_R_LEG
					if(37 to 46)
						return BODY_ZONE_L_LEG
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(16 to 21)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(12 to 18)
						return BODY_ZONE_PRECISE_R_HAND
					if(20 to 29)
						return BODY_ZONE_R_LEG
					if(37 to 46)
						return BODY_ZONE_L_LEG
					if(48 to 54)
						return BODY_ZONE_PRECISE_L_HAND
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(22 to 24)
				switch(icon_x)
					if(5 to 7)
						return BODY_ZONE_PRECISE_R_INHAND
					if(12 to 18)
						return BODY_ZONE_PRECISE_R_HAND
					if(20 to 29)
						return BODY_ZONE_R_LEG
					if(30 to 36)
						return BODY_ZONE_PRECISE_GROIN
					if(37 to 46)
						return BODY_ZONE_L_LEG
					if(48 to 54)
						return BODY_ZONE_PRECISE_L_HAND
					if(59 to 61)
						return BODY_ZONE_PRECISE_L_INHAND
			if(25 to 29)
				switch(icon_x)
					if(16 to 22)
						return BODY_ZONE_R_ARM
					if(27 to 39)
						return BODY_ZONE_PRECISE_STOMACH
					if(44 to 50)
						return BODY_ZONE_L_ARM
			if(30 to 38)
				switch(icon_x)
					if(16 to 22)
						return BODY_ZONE_R_ARM
					if(24 to 42)
						return BODY_ZONE_CHEST
					if(44 to 50)
						return BODY_ZONE_L_ARM
			if(39)
				switch(icon_x)
					if(29 to 37)
						return BODY_ZONE_PRECISE_NECK
			if(40 to 46)
				switch(icon_x)
					if(27 to 39)
						if(icon_y in 40 to 41)
							if(icon_x in 29 to 37)
								return BODY_ZONE_PRECISE_NECK
						if(icon_y in 42 to 44)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_MOUTH
						if(icon_y == 46)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_NOSE
						return BODY_ZONE_HEAD
			if(47 to 50)
				switch(icon_x)
					if(24 to 26)
						return BODY_ZONE_PRECISE_EARS
					if(27 to 39)
						if(icon_y in 49 to 50)
							if(icon_x in 30 to 32)
								return BODY_ZONE_PRECISE_R_EYE
							if(icon_x in 34 to 36)
								return BODY_ZONE_PRECISE_L_EYE
						if(icon_y in 47 to 48)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_NOSE
						return BODY_ZONE_HEAD
					if(40 to 42)
						return BODY_ZONE_PRECISE_EARS
			if(51 to 55)
				switch(icon_x)
					if(27 to 39)
						if(icon_y == 51)
							if(icon_x in 30 to 32)
								return BODY_ZONE_PRECISE_R_EYE
							if(icon_x in 34 to 36)
								return BODY_ZONE_PRECISE_L_EYE
						if(icon_y in 53 to 55)
							if(icon_x in 29 to 37)
								return BODY_ZONE_PRECISE_SKULL
						return BODY_ZONE_HEAD
	else
		switch(icon_y)
			if(1 to 7)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(26 to 32)
						return BODY_ZONE_PRECISE_R_FOOT
					if(34 to 40)
						return BODY_ZONE_PRECISE_L_FOOT
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(8 to 16)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(24 to 31)
						return BODY_ZONE_R_LEG
					if(35 to 42)
						return BODY_ZONE_L_LEG
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(17 to 20)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(20 to 23)
						return BODY_ZONE_PRECISE_R_HAND
					if(24 to 31)
						return BODY_ZONE_R_LEG
					if(35 to 42)
						return BODY_ZONE_L_LEG
					if(43 to 46)
						return BODY_ZONE_PRECISE_L_HAND
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(21)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(20 to 23)
						return BODY_ZONE_PRECISE_R_HAND
					if(30 to 36)
						return BODY_ZONE_PRECISE_GROIN
					if(43 to 46)
						return BODY_ZONE_PRECISE_L_HAND
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(22 to 23)
				switch(icon_x)
					if(12 to 14)
						return BODY_ZONE_PRECISE_R_INHAND
					if(20 to 25)
						return BODY_ZONE_R_ARM
					if(30 to 36)
						return BODY_ZONE_PRECISE_GROIN
					if(41 to 46)
						return BODY_ZONE_L_ARM
					if(52 to 54)
						return BODY_ZONE_PRECISE_L_INHAND
			if(24 to 29)
				switch(icon_x)
					if(20 to 25)
						return BODY_ZONE_R_ARM
					if(28 to 38)
						return BODY_ZONE_PRECISE_STOMACH
					if(41 to 46)
						return BODY_ZONE_L_ARM
			if(30 to 37)
				switch(icon_x)
					if(20 to 25)
						return BODY_ZONE_R_ARM
					if(27 to 39)
						return BODY_ZONE_CHEST
					if(41 to 46)
						return BODY_ZONE_L_ARM
			if(38 to 39)
				switch(icon_x)
					if(30 to 36)
						return BODY_ZONE_PRECISE_NECK
			if(40 to 43)
				switch(icon_x)
					if(28 to 38)
						if(icon_y == 40)
							if(icon_x in 30 to 36)
								return BODY_ZONE_PRECISE_NECK
						if(icon_y in 41 to 43)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_MOUTH
						return BODY_ZONE_HEAD
			if(44 to 47)
				switch(icon_x)
					if(26 to 27)
						return BODY_ZONE_PRECISE_EARS
					if(28 to 38)
						if(icon_y in 44 to 46)
							if(icon_x in 32 to 34)
								return BODY_ZONE_PRECISE_NOSE
						if(icon_y == 47)
							if(icon_x in 30 to 32)
								return BODY_ZONE_PRECISE_R_EYE
							if(icon_x in 34 to 36)
								return BODY_ZONE_PRECISE_L_EYE
						return BODY_ZONE_HEAD
					if(39 to 40)
						return BODY_ZONE_PRECISE_EARS
			if(48 to 51)
				switch(icon_x)
					if(28 to 38)
						if(icon_y in 48 to 49)
							if(icon_x in 30 to 32)
								return BODY_ZONE_PRECISE_R_EYE
							if(icon_x in 34 to 36)
								return BODY_ZONE_PRECISE_L_EYE
						if(icon_y in 50 to 51)
							if(icon_x in 30 to 36)
								return BODY_ZONE_PRECISE_SKULL
						return BODY_ZONE_HEAD
			if(52)
				if(icon_x in 30 to 36)
					return BODY_ZONE_PRECISE_SKULL

/atom/movable/screen/zone_sel/proc/set_selected_zone(choice, mob/user)
	if(user != hud?.mymob)
		return

	if(choice != hud.mymob.zone_selected)
		hud.mymob.select_zone(choice)
		update_zone_layers()

	return TRUE

/atom/movable/screen/zone_sel/update_overlays()
	. = ..()
	update_zone_layers()

/atom/movable/screen/zone_sel/proc/update_zone_layers()
	zone_overlay_cursor = 1

	if(!hud?.mymob)
		finalize_zone_overlay_update()
		return

	var/gender_prefix = hud.mymob.gender == FEMALE ? "f" : "m"
	var/base_state = "[gender_prefix]-zone_sel"
	if(icon_state != base_state)
		icon_state = base_state

	var/mob/living/carbon/human/H = get_human_owner()
	if(hud.mymob.stat != DEAD && H)
		var/list/missing_bodyparts_zones = H.get_missing_limbs()
		if(H.get_bodypart(BODY_ZONE_TAUR))
			missing_bodyparts_zones -= BODY_ZONE_L_LEG
			missing_bodyparts_zones -= BODY_ZONE_R_LEG
		var/nopain = HAS_TRAIT(H, TRAIT_NOPAIN)
		for(var/X in H.bodyparts)
			var/obj/item/bodypart/BP = X
			if(BP.body_zone in missing_bodyparts_zones)
				continue
			var/damage = min(BP.burn_dam + BP.brute_dam, BP.max_damage)
			var/comparison = BP.max_damage ? (damage / BP.max_damage) : 0
			var/wound_alpha = clamp(round((comparison * 255) * 2), 0, 255)
			var/has_bleed = BP.get_hud_bleed_rate() > 0
			// NO_PAIN: blue tint only when there is actual damage or visible bleed,
			// otherwise an undamaged limb would falsely show as injured.
			var/nopain_color = (nopain && (damage || has_bleed)) ? "#78a8ba" : null
			if(BP.body_zone == BODY_ZONE_TAUR)
				for(var/_z in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
					push_zone_overlay("[gender_prefix]-[_z]", nopain_color)
					if(!nopain && wound_alpha)
						push_zone_overlay("[gender_prefix]w-[_z]", null, wound_alpha)
					if(has_bleed)
						push_zone_overlay("[gender_prefix]-[_z]-bleed")
			else
				push_zone_overlay("[gender_prefix]-[BP.body_zone]", nopain_color)
				if(!nopain && wound_alpha)
					push_zone_overlay("[gender_prefix]w-[BP.body_zone]", null, wound_alpha)
				if(has_bleed)
					push_zone_overlay("[gender_prefix]-[BP.body_zone]-bleed")
		for(var/X in missing_bodyparts_zones)
			push_zone_overlay("[gender_prefix]-[X]", "#2f002f")

	push_zone_overlay("[gender_prefix]_[hud.mymob.zone_selected]")
	finalize_zone_overlay_update()

/atom/movable/screen/zone_sel/proc/push_zone_overlay(new_icon_state, new_color = null, new_alpha = 255)
	if(zone_overlay_cursor > length(zone_overlay_slots))
		return
	var/atom/movable/screen/hud_component/layer/slot = zone_overlay_slots[zone_overlay_cursor]
	var/new_layer = layer + 0.05 + (zone_overlay_cursor * 0.001)
	if(slot.icon != overlay_icon)
		slot.icon = overlay_icon
	if(slot.icon_state != new_icon_state)
		slot.icon_state = new_icon_state
	if(slot.alpha != new_alpha)
		slot.alpha = new_alpha
	if(slot.color != new_color)
		slot.color = new_color
	if(slot.layer != new_layer)
		slot.layer = new_layer
	zone_overlay_cursor++

/atom/movable/screen/zone_sel/proc/finalize_zone_overlay_update()
	if(zone_overlay_cursor <= zone_overlay_count)
		for(var/i in zone_overlay_cursor to zone_overlay_count)
			var/atom/movable/screen/hud_component/layer/slot = zone_overlay_slots[i]
			if(slot.alpha)
				slot.alpha = 0
			if(slot.color)
				slot.color = null
			if(slot.icon_state)
				slot.icon_state = null
	zone_overlay_count = zone_overlay_cursor - 1

/atom/movable/screen/zone_sel/proc/flash_limb(zone, limb_color="#FF0000") //Flashes when an attack hits a limb
	if(!zone || !hud?.mymob || !length(highlight_slots))
		return

	var/gender_prefix = hud.mymob.gender == FEMALE ? "f" : "m"
	var/slot_index = next_highlight_slot
	next_highlight_slot = slot_index % length(highlight_slots) + 1
	highlight_tokens[slot_index] += 1
	var/current_token = highlight_tokens[slot_index]
	var/atom/movable/screen/hud_component/layer/highlight = highlight_slots[slot_index]
	animate(highlight, flags = ANIMATION_END_NOW)
	highlight.icon = overlay_icon
	highlight.icon_state = "[gender_prefix]-[zone]"
	highlight.color = limb_color
	highlight.alpha = 180
	highlight.layer = ABOVE_HUD_LAYER + 0.9 + (slot_index * 0.001)
	highlight.plane = ABOVE_HUD_PLANE
	animate(highlight, alpha = 0, time = 20, easing = EASE_IN)
	spawn(20)
		if(highlight_tokens[slot_index] == current_token)
			highlight.color = null

/atom/movable/screen/zone_sel/robot
	icon = 'icons/mob/screen_cyborg.dmi'

#undef ZONE_SELECTOR_SLOT_COUNT
#undef ZONE_SELECTOR_HIGHLIGHT_SLOTS

/atom/movable/screen/flash
	name = "flash"
	icon_state = "blank"
	blend_mode = BLEND_ADD
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	layer = FLASH_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/damageoverlay
	icon = 'icons/mob/screen_full.dmi'
	icon_state = "oxydamageoverlay0"
	name = "dmg"
	blend_mode = BLEND_MULTIPLY
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/healths
	name = "health"
	icon_state = "health0"
	screen_loc = ui_health

/atom/movable/screen/healths/construct
	icon = 'icons/mob/screen_construct.dmi'
	icon_state = "artificer_health0"
	screen_loc = ui_construct_health
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/healthdoll
	name = "health doll"
	screen_loc = rogueui_targetdoll

/atom/movable/screen/healthdoll/Click(location, control, params)
	if (ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.check_for_injuries(H)

/atom/movable/screen/mood
	name = "mood"
	icon_state = "mood5"
	screen_loc = null

/atom/movable/screen/healths/blood
	name = "life"
	icon_state = "blood100"
	screen_loc = rogueui_blood
	icon = 'icons/mob/rogueheat.dmi'
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER
	var/atom/movable/screen/hud_component/layer/tox_layer
	var/atom/movable/screen/hud_component/layer/oxy_layer
	var/atom/movable/screen/hud_component/layer/pain_layer

/atom/movable/screen/healths/blood/New()
	. = ..()
	tox_layer = create_hud_component_layer(icon, null, 0.01)
	oxy_layer = create_hud_component_layer(icon, null, 0.02)
	pain_layer = create_hud_component_layer(icon, null, 0.03)
	reset_hud_component_layer(tox_layer)
	reset_hud_component_layer(oxy_layer)
	reset_hud_component_layer(pain_layer)

/atom/movable/screen/healths/blood/Destroy()
	QDEL_NULL(tox_layer)
	QDEL_NULL(oxy_layer)
	QDEL_NULL(pain_layer)
	return ..()

/atom/movable/screen/healths/blood/proc/update_indicator_states(tox_state, oxy_state, pain_state)
	update_indicator_layer(tox_layer, tox_state)
	update_indicator_layer(oxy_layer, oxy_state)
	update_indicator_layer(pain_layer, pain_state)

/atom/movable/screen/healths/blood/proc/update_indicator_layer(atom/movable/screen/hud_component/layer/indicator, new_state)
	if(!indicator)
		return
	if(!new_state)
		if(indicator.alpha)
			indicator.alpha = 0
		if(indicator.color)
			indicator.color = null
		return
	if(indicator.icon != icon)
		indicator.icon = icon
	if(indicator.icon_state != new_state)
		indicator.icon_state = new_state
	if(indicator.alpha != 255)
		indicator.alpha = 255
	if(indicator.color)
		indicator.color = null

/atom/movable/screen/healths/blood/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(modifiers["left"])
			H.check_for_injuries(H)
		if(modifiers["right"])
			if(!H.mind)
				return
			if(length(H.mind.known_people))
				H.mind.display_known_people(H)
			else
				to_chat(H, "<span class='warning'>I don't know anyone.</span>")

/atom/movable/screen/splash
	icon = 'icons/blank_title.png'
	icon_state = ""
	screen_loc = "1,1"
	layer = SPLASHSCREEN_LAYER+1
	plane = SPLASHSCREEN_PLANE
	var/client/holder
	var/fucme = TRUE

/atom/movable/screen/splash/credits
	icon = 'icons/fullblack.dmi'
	icon_state = ""
	screen_loc = ui_backhudl
	layer = SPLASHSCREEN_LAYER
	fucme = FALSE

/atom/movable/screen/splash/New(client/C, visible, use_previous_title) //TODO: Make this use INITIALIZE_IMMEDIATE, except its not easy
	. = ..()

	holder = C

	if(!visible)
		alpha = 0

	if(fucme)
		if(!use_previous_title)
			if(SStitle.icon)
				icon = SStitle.icon
		else
			if(!SStitle.previous_icon)
				qdel(src)
				return
			icon = SStitle.previous_icon

	holder.screen += src

/atom/movable/screen/splash/proc/Fade(out, qdel_after = TRUE)
	if(QDELETED(src))
		return
	if(out)
		animate(src, alpha = 0, time = 30)
	else
		alpha = 0
		animate(src, alpha = 255, time = 30)
	if(qdel_after)
		QDEL_IN(src, 30)

/atom/movable/screen/splash/Destroy()
	if(holder)
		holder.screen -= src
		holder = null
	return ..()

/atom/movable/screen/gameover
	icon = 'icons/gameover.dmi'
	icon_state = ""
	screen_loc = ui_backhudl
	layer = SPLASHSCREEN_LAYER
	plane = SPLASHSCREEN_PLANE

/atom/movable/screen/gameover/proc/Fade(out = FALSE, qdel_after = FALSE)
	if(QDELETED(src))
		return
	if(out)
		animate(src, alpha = 0, time = 30, flags = ANIMATION_PARALLEL)
	else
		alpha = 0
		animate(src, alpha = 255, time = 30, flags = ANIMATION_PARALLEL)
	if(qdel_after)
		QDEL_IN(src, 30)


/atom/movable/screen/gameover/hog
	icon_state = "hog"
	alpha = 0

/atom/movable/screen/gameover/hog/Fade(out = FALSE, qdel_after = FALSE)
	if(QDELETED(src))
		return
//	icon_state = "blank"
//	var/image/MA = image(icon, "hog")
//	MA.alpha = 0
//	add_overlay(MA)
//	animate(MA, alpha = 255, time = 30)
	if(!out)
		animate(src, alpha = 255, time = 30, flags = ANIMATION_PARALLEL)
	else
		animate(src, alpha = 0, time = 30, flags = ANIMATION_PARALLEL)
		QDEL_IN(src, 30)

/atom/movable/screen/component_button
	var/atom/movable/screen/parent

/atom/movable/screen/component_button/Initialize(mapload, atom/movable/screen/parent)
	. = ..()
	src.parent = parent

/atom/movable/screen/component_button/Click(location, control, params)
	if(parent)
		parent.component_click(src, params)

//Roguehud objects

/atom/movable/screen/backhudl
	icon = 'icons/mob/roguehudback2.dmi'
	icon_state = ""
	name = " "
	screen_loc = ui_backhudl
	layer = BACKHUD_LAYER
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/backhudl/Click()
	return

/atom/movable/screen/backhudl/ghost
	icon_state = "dead"
	icon = 'icons/mob/roguehudbackghost.dmi'

/atom/movable/screen/backhudl/obs
	icon_state = "obs"
	icon = 'icons/mob/roguehudbackghost.dmi'

/atom/movable/screen/aim
	name = ""
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "aimbg"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/aim/boxaim
	name = "tile selection indicator"
	icon_state = "boxoff"

/atom/movable/screen/aim/boxaim/Click()
	if(ismob(usr))
		var/mob/M = usr
		if(M.boxaim == TRUE)
			M.boxaim = FALSE
		else
			M.boxaim = TRUE
		update_icon()

/atom/movable/screen/aim/boxaim/update_icon()
	if(ismob(usr))
		var/mob/living/M = usr
		if(M.boxaim == TRUE)
			icon_state = "boxon"
		else
			icon_state = "boxoff"
			if(M.client)
				M.client.mouseoverbox.screen_loc = null
	..()


/atom/movable/screen/stress
	name = "sanity"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "stressback"
	var/atom/movable/screen/hud_component/layer/stress_state_layer

/atom/movable/screen/stress/New()
	. = ..()
	stress_state_layer = create_hud_component_layer(icon, null, 0.01)
	reset_hud_component_layer(stress_state_layer)

/atom/movable/screen/stress/Destroy()
	QDEL_NULL(stress_state_layer)
	return ..()

/atom/movable/screen/stress/update_icon()
	var/state2use = "stress1"
	var/mob/living/carbon/human/H = get_human_owner()
	if(H)
		if(!HAS_TRAIT(H, TRAIT_NOMOOD))
			var/stress_amt = H.get_stress_amount()
			if(stress_amt > 0)
				state2use = "stress2"
			if(stress_amt >= 5)
				state2use = "stress3"
			if(stress_amt >= 15)
				state2use = "stress4"
			if(stress_amt >= 25)
				state2use = "stress5"
		if(H.has_status_effect(/datum/status_effect/buff/drunk))
			state2use = "mood_drunk"
		if(H.has_status_effect(/datum/status_effect/buff/druqks))
			state2use = "mood_drunk"
		if(H.InFullCritical())
			state2use = "stress4"
		if(H.mind)
			if(H.mind.has_antag_datum(/datum/antagonist/zombie))
				state2use = "stress4"
		if(H.stat == DEAD)
			state2use = "mood_dead"
	if(stress_state_layer)
		if(stress_state_layer.icon != icon)
			stress_state_layer.icon = icon
		if(stress_state_layer.icon_state != state2use)
			stress_state_layer.icon_state = state2use
		if(stress_state_layer.alpha != 255)
			stress_state_layer.alpha = 255
		if(stress_state_layer.color)
			stress_state_layer.color = null


/atom/movable/screen/stress/Click(location,control,params)
	var/list/modifiers = params2list(params)

	if(ishuman(usr))
		var/mob/living/carbon/human/M = usr
		if(modifiers["left"])
			if(length(M.vices))
				to_chat(M, "*----*")
				for(var/datum/charflaw/vice in M.vices)
					to_chat(M, span_info("<small>[vice.desc]</small>"))
			else if(M.charflaw)
				to_chat(M, "*----*")
				to_chat(M, span_info("[M.charflaw.desc]"))
			to_chat(M, "*--------*")
			var/list/already_printed = list()
			var/list/pos_stressors = M.get_positive_stressors()
			for(var/datum/stressevent/S in pos_stressors)
				if(S in already_printed)
					continue
				var/cnt = 1
				for(var/datum/stressevent/CS in pos_stressors)
					if(CS == S)
						continue
					if(CS.type == S.type)
						cnt++
						already_printed += CS
				var/ddesc = S.desc
				if(islist(S.desc))
					ddesc = pick(S.desc)
				if(cnt > 1)
					to_chat(M, "[ddesc] (x[cnt])")
				else
					to_chat(M, "[ddesc]")
			var/list/neg_stressors = M.get_negative_stressors()
			for(var/datum/stressevent/S in neg_stressors)
				if(S in already_printed)
					continue
				var/cnt = 1
				for(var/datum/stressevent/CS in neg_stressors)
					if(CS == S)
						continue
					if(CS.type == S.type)
						cnt++
						already_printed += CS
				var/ddesc = S.desc
				if(islist(S.desc))
					ddesc = pick(S.desc)
				if(cnt > 1)
					to_chat(M, "[ddesc] (x[cnt])")
				else
					to_chat(M, "[ddesc]")
			already_printed = list()
			to_chat(M, "*--------*")
		if(modifiers["right"])
			if(M.get_triumphs() <= 0)
				to_chat(M, span_warning("I haven't TRIUMPHED."))
				return
			if(alert("Do you want to remember a TRIUMPH?", "", "Yes", "No") == "Yes")
				M.add_stress(/datum/stressevent/triumph)
				M.adjust_triumphs(-1)
				M.playsound_local(M, 'sound/misc/notice (2).ogg', 100, FALSE)
				if(M.sexcon)
					var/datum/sex_controller/sexo = M.sexcon
					sexo.set_charge(sexo.get_max_charge())


/atom/movable/screen/rmbintent
	name = "alt intents"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "rmbintent"
	var/list/shown_intents = list()
	var/showing = FALSE
	var/atom/movable/screen/hud_component/layer/current_intent_layer

/atom/movable/screen/rmbintent/New()
	. = ..()
	current_intent_layer = create_hud_component_layer(icon, null, 0.01)
	reset_hud_component_layer(current_intent_layer)

/atom/movable/screen/rmbintent/Destroy()
	QDEL_NULL(current_intent_layer)
	QDEL_LIST(shown_intents)
	return ..()

/atom/movable/screen/rmbintent/update_icon()
	if(current_intent_layer)
		reset_hud_component_layer(current_intent_layer)
	name = initial(name)
	desc = initial(desc)
	if(isliving(hud?.mymob))
		var/mob/living/L = hud.mymob
		if(L.rmb_intent)
			if(current_intent_layer)
				if(current_intent_layer.icon != icon)
					current_intent_layer.icon = icon
				current_intent_layer.icon_state = "[L.rmb_intent.icon_state]_x"
				current_intent_layer.alpha = 255
			name = L.rmb_intent.name
			desc = L.rmb_intent.desc

/atom/movable/screen/rmbintent/Click(location,control,params)
	var/list/modifiers = params2list(params)

	if(isliving(usr))
		var/mob/living/M = usr
		if(modifiers["left"])
			if(showing)
				collapse_intents()
			else
				show_intents(M)
		if(modifiers["right"])
			if(M.rmb_intent)
				to_chat(M, "<span class='info'>* --- *</span>")
				to_chat(M, "<span class='info'>[name]: [desc]</span>")
				to_chat(M, "<span class='info'>* --- *</span>")

/atom/movable/screen/rmbintent/proc/collapse_intents()
	if(!showing)
		return
	showing = FALSE
	QDEL_LIST(shown_intents)
	update_icon()

/atom/movable/screen/rmbintent/proc/show_intents(mob/living/M)
	if(showing)
		return
	if(!M)
		return
	showing = TRUE
	var/cnt
	var/i = 15
	var/they = 0.02
	for(var/X in M.possible_rmb_intents)
		if(M.rmb_intent?.type == X)
			continue
		var/atom/movable/screen/rintent_selection/R = new(M.client)
		var/datum/rmb_intent/RI = new X
		R.stored_intent = X
		R.icon_state = RI.icon_state
		R.name = RI.name
		R.desc = RI.desc
		shown_intents += R
		R.screen_loc = "WEST-4:0,SOUTH+8:[i]"
		R.layer = layer+they
		i += 15
		they += 0.01
		cnt++
	if(!cnt)
		showing = FALSE

/atom/movable/screen/rintent_selection
	name = "rmb intent"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "rmbaimed"
	var/stored_intent
	var/stored_name
	var/client/holder

/atom/movable/screen/rintent_selection/New(client/C)
	if(C)
		holder = C
	. = ..()
	if(holder?.prefs)
		icon = holder.prefs.get_roguehud_icon()
	holder.screen += src

/atom/movable/screen/rintent_selection/Destroy()
	if(holder)
		holder.screen -= src
		holder = null
	return ..()

/atom/movable/screen/rintent_selection/Click(location,control,params)
	var/list/modifiers = params2list(params)

	if(isliving(usr))
		var/mob/living/M = usr
		if(modifiers["left"])
			if(stored_intent)
				M.swap_rmb_intent(type = stored_intent)
		if(modifiers["right"])
			to_chat(M, "<span class='info'>* --- *</span>")
			to_chat(M, "<span class='info'>[name]: [desc]</span>")
			to_chat(M, "<span class='info'>* --- *</span>")

/mob/living/proc/swap_rmb_intent(type, num)
	if(!possible_rmb_intents?.len)
		return
	if(type)
		if(type in possible_rmb_intents)
			rmb_intent = new type()
			if(hud_used?.rmb_intent)
				hud_used.rmb_intent.update_icon()
				hud_used.rmb_intent.collapse_intents()
	if(num)
		if(possible_rmb_intents.len < num)
			return
		var/A = possible_rmb_intents[num]
		if(A)
			rmb_intent = new A()
			if(hud_used?.rmb_intent)
				hud_used.rmb_intent.update_icon()
				hud_used.rmb_intent.collapse_intents()

/mob/living/proc/cycle_rmb_intent()
	if(!possible_rmb_intents?.len)
		return

	// Find the index of the current intent
	var/index = possible_rmb_intents.Find(rmb_intent?.type)

	index == -1 ? swap_rmb_intent(possible_rmb_intents[1]) : swap_rmb_intent(possible_rmb_intents[(index % possible_rmb_intents.len) + 1])

/atom/movable/screen/time
	name = "Sir Sun"
	icon = 'icons/time.dmi'
	icon_state = "day"
	var/atom/movable/screen/hud_component/layer/cloud_layer
	var/atom/movable/screen/hud_component/layer/rain_layer

/atom/movable/screen/time/New()
	. = ..()
	cloud_layer = create_hud_component_layer(icon, "clouds", 0.01)
	rain_layer = create_hud_component_layer(icon, "rainlay", 0.02)
	reset_hud_component_layer(cloud_layer)
	reset_hud_component_layer(rain_layer)

/atom/movable/screen/time/Destroy()
	QDEL_NULL(cloud_layer)
	QDEL_NULL(rain_layer)
	return ..()

/atom/movable/screen/time/update_icon()
	var/show_clouds = FALSE
	var/show_rain = FALSE
	switch(GLOB.tod)
		if("day")
			icon_state = "day"
			name = "Sir Sun"
		if("dusk")
			icon_state = "dusk"
			name = "Sir Sun - Dusk"
		if("night")
			icon_state = "night"
			name = "Miss Moon"
		if("dawn")
			icon_state = "dawn"
			name = "Sir Sun - Dawn"
	for(var/datum/weather/rain/R in SSweather.curweathers)
		if(R.stage < 2)
			show_clouds = TRUE
		if(R.stage == 2)
			show_rain = TRUE
	if(cloud_layer)
		if(cloud_layer.icon != icon)
			cloud_layer.icon = icon
		if(cloud_layer.icon_state != "clouds")
			cloud_layer.icon_state = "clouds"
		cloud_layer.alpha = show_clouds ? 255 : 0
	if(rain_layer)
		if(rain_layer.icon != icon)
			rain_layer.icon = icon
		if(rain_layer.icon_state != "rainlay")
			rain_layer.icon_state = "rainlay"
		rain_layer.alpha = show_rain ? 255 : 0

/**
 * Renders a vertical bar filled to `ratio` (0-1) by masking a sprite. The `mid_state` and `low_state`
 * are a separate animated icon state in place of `full_state` at low levels.
 * args:
 * 	meter_bar_fill_height: the height of the fill sprite in pixels
 * 	meter_bar_mid_fraction: the fraction of the bar at which we swap to a mid-warning icon state
 * 	meter_bar_low_fraction: the fraction of the bar at which we swap to a low-warning icon state
 * 	meter_bar_fill_anim_time: the base time in deciseconds for the masked fill to slide to a new level
 * 	meter_bar_fill_anim_scale: extra time in deciseconds added at a full-range change, scaled by how far the fill moves
 */
/atom/movable/screen/proc/set_meter_fill(
	ratio,
	full_state,
	mid_state,
	low_state,
	meter_bar_fill_height = 47,
	meter_bar_mid_fraction = 0.2,
	meter_bar_low_fraction = 0.1,
	meter_bar_fill_anim_time = 2,
	meter_bar_fill_anim_scale = 0.4 SECONDS,
)
	ratio = clamp(ratio, 0, 1)
	if(ratio <= meter_bar_low_fraction)
		icon_state = low_state
	else if(ratio <= meter_bar_mid_fraction)
		icon_state = mid_state
	else
		icon_state = full_state
	var/offset = -round((1 - ratio) * meter_bar_fill_height)
	var/list/existing = filter_data?["meter_fill"]
	if(existing)
		var/time = meter_bar_fill_anim_time + round(abs(offset - existing["y"]) / meter_bar_fill_height * meter_bar_fill_anim_scale)
		transition_filter("meter_fill", list("y" = offset), time, SINE_EASING)
	else
		add_filter("meter_fill", 1, alpha_mask_filter(y = offset, icon = icon(icon, full_state)))

/atom/movable/screen/stamina
	name = "stamina"
	icon_state = "stam100"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = rogueui_fat

/atom/movable/screen/energy
	name = "energy"
	icon_state = "energy100"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = rogueui_fat

/atom/movable/screen/heatstamover
	name = ""
	mouse_opacity = 0
	icon_state = "heatstamover"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = rogueui_fat
	layer = HUD_LAYER+0.1

/atom/movable/screen/tempbase
	name = ""
	mouse_opacity = 0
	icon_state = "tempbase"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = rogueui_temperature


/atom/movable/screen/temperature
	name = "Temperature"
	icon_state = "tempnormal"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = rogueui_temperature
	layer = HUD_LAYER+0.1

/atom/movable/screen/temperature/Click(location, control, params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.check_temperature_state(H)

/atom/movable/screen/grain
	icon = 'icons/grain.dmi'
	icon_state = "grain"
	name = ""
	screen_loc = "1,1"
	mouse_opacity = 0
	alpha = 0
	layer = 13
	plane = 0
	blend_mode = 4

/atom/movable/screen/scannies
	icon = 'icons/mob/roguehudback2.dmi'
	icon_state = "crt"
	name = ""
	screen_loc = ui_backhudl
	mouse_opacity = 0
	alpha = 0
	layer = 24
	plane = 24
	blend_mode = BLEND_MULTIPLY

/atom/movable/screen/char_preview
	name = "Me."
	icon_state = ""
//	var/list/prevcolors = list("background-color=#000000","background-color=#242f28","background-color=#302323","background-color=#999a63","background-color=#7e7e7e")

//atom/movable/screen/char_preview/Click()
//	winset(usr.client, "preferencess_window.character_preview_map", pick(prevcolors))

#define READ_RIGHT 1
#define READ_LEFT 2
#define READ_BOTH 3

/atom/movable/screen/read
	icon = 'icons/roguetown/hud/read.dmi'
	icon_state = ""
	name = ""
	screen_loc = "1,1"
	layer = HUD_LAYER+0.01
	plane = HUD_PLANE
	alpha = 0
	var/atom/movable/screen/readtext/textright
	var/atom/movable/screen/readtext/textleft
	var/reading

/atom/movable/screen/read/Click(location, control, params)
	. = ..()
	destroy_read()
	if(!usr || !usr.client)
		return FALSE
	var/mob/user = usr
	user << browse(null, "window=reading")

/atom/movable/screen/read/proc/destroy_read()
	if(textright)
		textright.alpha = 0
		textleft.maptext = null
	if(textleft)
		textleft.alpha = 0
		textleft.maptext = null
	alpha = 0
	icon_state = ""
	reading = FALSE

/atom/movable/screen/read/proc/show()
	alpha = 255
	reading = TRUE

/atom/movable/screen/read/proc/show_text(input)
	reading = TRUE
	animate(src, alpha = 255, time = 5, easing = EASE_IN)
	if(input == READ_RIGHT)
		animate(textright, alpha = 255, time = 5, easing = EASE_IN)
		textleft.alpha = 0
	if(input == READ_LEFT)
		textright.alpha = 0
		animate(textleft, alpha = 255, time = 5, easing = EASE_IN)
	if(input == READ_BOTH)
		animate(textleft, alpha = 255, time = 5, easing = EASE_IN)
		animate(textright, alpha = 255, time = 5, easing = EASE_IN)

/atom/movable/screen/readtext
	name = ""
	icon = null
	icon_state = ""
	screen_loc = "5,5"
	layer = HUD_LAYER+0.02
	plane = HUD_PLANE

/atom/movable/screen/area_text
	icon = null
	icon_state = ""
	name = ""
	screen_loc = "5,5"
	layer = HUD_LAYER+0.02
	plane = HUD_PLANE
	alpha = 0
	var/reading

/atom/movable/screen/daynight
	icon = 'icons/time.dmi'
	icon_state = ""
	screen_loc = "EAST-2:-14,CENTER-6:16"

/atom/movable/screen/daynight/New(client/C) //TODO: Make this use INITIALIZE_IMMEDIATE, except its not easy
	. = ..()
	icon_state = GLOB.tod

/atom/movable/screen/bloodpool
	appearance_flags = KEEP_TOGETHER
	icon_state = "empty"
	icon = 'icons/mob/rogueheat.dmi'
	screen_loc = rogueui_vitae
	var/width = 4
	var/height = 43
	var/orientation = NORTH
	var/atom/movable/screen/bloodpool_maskpart/background
	var/atom/movable/screen/bloodpool_maskpart/foreground
	var/atom/movable/screen/bloodpool_maskpart/fill
	var/atom/movable/screen/bloodpool_maskpart/mask

/atom/movable/screen/bloodpool/Initialize(mapload, ...)
	. = ..()
	foreground = new /atom/movable/screen/bloodpool_maskpart/foreground(null, icon, src)
	background = new /atom/movable/screen/bloodpool_maskpart/background(null, icon, src)
	fill = new /atom/movable/screen/bloodpool_maskpart/fill(null, icon, src)
	mask = new /atom/movable/screen/bloodpool_maskpart/mask(null, icon, src)

	background.vis_contents += fill
	mask.vis_contents += background
	vis_contents.Add(mask, foreground)

/atom/movable/screen/bloodpool/Destroy()
	QDEL_NULL(background)
	QDEL_NULL(foreground)
	QDEL_NULL(fill)
	QDEL_NULL(mask)
	return ..()

/atom/movable/screen/bloodpool/apply_colorblind_hud_palette(datum/preferences/prefs)
	..()
	var/rogueheat_icon = get_rogueheat_icon(prefs)
	if(background)
		background.icon = rogueheat_icon
	if(foreground)
		foreground.icon = rogueheat_icon
	if(fill)
		fill.icon = rogueheat_icon
	if(mask)
		mask.icon = rogueheat_icon

/atom/movable/screen/bloodpool/proc/set_fill_color(new_color = "#ffffff")
	fill.color = new_color

/atom/movable/screen/bloodpool/proc/set_value(ratio = 1.0, duration = 0)
	//constrain the ratio between 0 and 1
	ratio = min(max(ratio,0),1)

	//apply orientation factors for fill bar offsets
	var/fx = 0, fy = 0
	switch(orientation)
		if(EAST)
			fx = -1
		if(WEST)
			fx = 1
		if(SOUTH)
			fy = 1
		if(NORTH)
			fy = -1

	//calculate the offset of the fill bar.
	var/invratio = 1-ratio
	var/epx = width * invratio * fx
	var/epy = height * invratio * fy

	//apply the offset to the fill bar
	if(duration)
		//if a time value has been supplied, animate the transition from the current position
		animate(fill, pixel_w = epx,pixel_z = epy, time = duration)
	else
		//if a time value has not been supplied, instantly set to the new position
		fill.pixel_w = epx
		fill.pixel_z = epy

	animate(fill, time = duration)

/atom/movable/screen/bloodpool/Click(location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["left"] && modifiers["shift"])
		examine_ui(usr)
		return FALSE
	if(!modifiers["left"])
		return
	if(usr.next_click > world.time)
		return
	usr.next_click = world.time + 1
	if(!ismob(usr))
		return
	// If the fill color is the devotion-blue, trigger the cleric prayer verb.
	var/col = fill.color
	if(col == "#3C41A4" || col == "#3c41a4")
		if(istype(usr, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			H.clericpray()
		return TRUE
	return

/atom/movable/screen/bloodpool_maskpart
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE
	/// Ref to our parent screem, purely for examine purposes
	var/atom/movable/screen/parent_screen

/atom/movable/screen/bloodpool_maskpart/Initialize(mapload, icon, parent_screen)
	. = ..()
	src.icon = icon
	src.parent_screen = parent_screen

/atom/movable/screen/bloodpool_maskpart/Click(location, control, params)
	if(parent_screen)
		return parent_screen.Click(location, control, params)
	return FALSE

/atom/movable/screen/bloodpool_maskpart/examine_ui(mob/user)
	return parent_screen?.examine_ui(user)

/atom/movable/screen/bloodpool_maskpart/Destroy()
	parent_screen = null
	return ..()

/atom/movable/screen/bloodpool_maskpart/background
	icon_state = "mana_bg"
	appearance_flags = KEEP_TOGETHER
	blend_mode = BLEND_MULTIPLY

/atom/movable/screen/bloodpool_maskpart/foreground
	icon_state = "mana_fg"

/atom/movable/screen/bloodpool_maskpart/fill
	icon_state = "mana_fill"

/atom/movable/screen/bloodpool_maskpart/mask
	icon_state = "mana_mask"
