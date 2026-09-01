/obj/item/codpiece
	name = "codpiece"
	icon = 'icons/roguetown/clothing/codpieces.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/codpieces.dmi'
	icon_state = "codpiece"
	item_state = "codpiece"
	desc = "A leather codpiece that fits snugly (for most, save the elves) around the groin. Considered to be the height of fashion in Drow high society."
	color = "#66584c"
	dropshrink = 0.5
	var/is_attached_to_pants = FALSE
	var/draws_above_clothing = TRUE
	var/detail_suffix_after_tag = FALSE

/obj/item/codpiece/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/codpiece/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][get_detail_tag()]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/codpiece/proc/get_onmob_suffix(mob/living/carbon/human/wearer)
	if(!wearer?.dna?.species)
		return ""

	var/datum/species/species = wearer.dna.species
	if(species.clothes_id == "dwarf")
		return wearer.gender == FEMALE ? "_df" : "_d"
// i hate having to do this make sprite accessories look half decent
	var/limb_icon = wearer.gender == FEMALE ? species.limbs_icon_f : species.limbs_icon_m
	switch(limb_icon)
		if('icons/roguetown/mob/bodies/f/fm.dmi')
			return "_f"
		if('icons/roguetown/mob/bodies/m/mem.dmi', 'icons/roguetown/mob/bodies/m/met.dmi')
			return "_me"
		if('icons/roguetown/mob/bodies/m/md.dmi')
			return "_d"
		if('icons/roguetown/mob/bodies/f/fd.dmi')
			return "_df"
		if('icons/roguetown/mob/bodies/m/mt_muscular.dmi')
			return "_mt"
		if('icons/roguetown/mob/bodies/f/ft_muscular.dmi')
			return "_ft"

	return wearer.gender == FEMALE ? "_f" : ""

/obj/item/codpiece/proc/build_worn_codpiece_icon(mob/living/carbon/human/wearer, default_layer, use_under_sprite = FALSE)
	var/suffix = get_onmob_suffix(wearer)
	var/state = icon_state
	if(use_under_sprite && draws_above_clothing)
		state += "_under"
	state += suffix

	var/mutable_appearance/standing = mutable_appearance(mob_overlay_icon, state, -default_layer)
	if(get_detail_tag())
		var/detail_state
		if(detail_suffix_after_tag)
			detail_state = "[icon_state][get_detail_tag()][suffix]"
		else
			detail_state = "[state][get_detail_tag()]"
		var/mutable_appearance/detail = mutable_appearance(mob_overlay_icon, detail_state, -default_layer)
		detail.appearance_flags = RESET_COLOR
		if(get_detail_color())
			detail.color = get_detail_color()
		standing.overlays.Add(detail)

	standing = center_image(standing, worn_x_dimension, worn_y_dimension)
	standing.alpha = alpha
	standing.color = color
	return standing

/obj/item/codpiece/foppish
	name = "foppish codpiece"
	icon_state = "foppish"
	detail_tag = "_detail"
	desc = "A large and ostentatious codpiece patterned with two-tone stripes. The bright dye and elaborate curve is sure to turn heads, be it in court, the tavern, or church."
	color = "#bb0a1e"
	detail_color = "#264d26"

/obj/item/codpiece/metal
	name = "metal codpiece"
	icon_state = "metalcod"
	desc = "A steeled codpiece jutting out from the groin. While this piece is rather long, it's said the Ferentian King has one 3 times it's length!"
	color = "#ffffff"

/obj/item/codpiece/froggemund
	name = "froggemund codpiece"
	icon_state = "frogge"
	desc = "An upturned Froggemund jousting helm somehow fashioned into an ungaitly codpiece. The garb of a madman."
	color = "#ffffff"
	dropshrink = 1

/obj/item/codpiece/flap
	name = "flap codpiece"
	icon_state = "flap"
	detail_tag = "_detail"
	draws_above_clothing = FALSE
	detail_suffix_after_tag = TRUE
	color = "#66584c"
	detail_color = "#c1b144"
	desc = "A simple and austere flap of leather that covers the groin. This humble skin can be seen adorning the hosen of many a peasant."

/obj/item/clothing/under/roguetown
	var/obj/item/codpiece/attached_codpiece

/obj/item/clothing/under/roguetown/Destroy()
	if(attached_codpiece)
		var/obj/item/codpiece/codpiece = attached_codpiece
		vis_contents -= codpiece
		codpiece.forceMove(drop_location())
		codpiece.update_icon()
		codpiece.is_attached_to_pants = FALSE
		attached_codpiece = null
	refresh_codpiece_overlay()
	return ..()

/obj/item/clothing/under/roguetown/examine(mob/user)
	. = ..()
	if(attached_codpiece)
		. += span_notice("\An [attached_codpiece] appears attached to \the [initial(name)]. Alt+RMB to remove it.")

/obj/item/clothing/under/roguetown/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/codpiece))
		return ..()
	var/obj/item/codpiece/held_codpiece = I
	if(held_codpiece.is_attached_to_pants)
		return
	if(attached_codpiece)
		to_chat(user, span_info("\The [initial(name)] already has a codpiece attached! Remove it first."))//requires padded bra infra first, trust
		return
	if(!user.transferItemToLoc(held_codpiece, null))
		to_chat(user, span_warning("\The [held_codpiece] is stuck to your hand!"))//how did you get your codpiece sticky? :)
		return
	held_codpiece.is_attached_to_pants = TRUE
	user.visible_message(span_warning("[user] equips \the [held_codpiece] onto \the [initial(name)]."))
	attached_codpiece = held_codpiece
	playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
	vis_contents += attached_codpiece
	update_icon()
	refresh_codpiece_overlay()
	return TRUE

/obj/item/clothing/under/roguetown/AltRightClick(mob/user)
	if(!attached_codpiece)
		return
	if(!isliving(user) || !user.TurfAdjacent(src))
		return
	if(user.get_active_held_item())
		to_chat(user, span_info("I can't do that with my hand full!"))//you have too many ribs to remove handsfree
		return
	var/obj/item/codpiece/codpiece = attached_codpiece
	user.visible_message(span_warning("[user] removes \the [codpiece] from \the [initial(name)]."))
	vis_contents -= codpiece
	if(!user.put_in_hands(codpiece))
		codpiece.forceMove(get_turf(src))
	codpiece.update_icon()
	codpiece.is_attached_to_pants = FALSE
	attached_codpiece = null
	update_icon()
	refresh_codpiece_overlay()

/obj/item/clothing/under/roguetown/proc/refresh_codpiece_overlay()
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/H = loc
	if(H.wear_pants != src)
		return
	H.update_inv_pants()


/// Codpiece crafting

/datum/crafting_recipe/roguetown/survival/froggecodpiece
	name = "metal codpiece"
	result = list(/obj/item/codpiece/froggemund)
	reqs = list(/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth = 1)
	craftdiff = 0
