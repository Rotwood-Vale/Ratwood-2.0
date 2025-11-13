// Component to color the examine name-line based on Ratworld rarity

/datum/component/ratworld_rarity_namecolor
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/ratworld_rarity_namecolor/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ATOM_GET_EXAMINE_NAME, PROC_REF(on_get_name))

/datum/component/ratworld_rarity_namecolor/Destroy()
	if(parent)
		UnregisterSignal(parent, COMSIG_ATOM_GET_EXAMINE_NAME)
	return ..()

// Override the name segment (index 3) with a colored span matching rarity
/datum/component/ratworld_rarity_namecolor/proc/on_get_name(datum/source, mob/user, list/override)
	SIGNAL_HANDLER
	var/obj/item/I = parent
	if(!I) return
	var/r = I.vars?["rw_rarity"]
	if(!isnum(r)) return
	var/col = get_ratworld_rarity_color(r)
	if(!istext(col) || !length(col)) return
	// Replace the name segment (position 3) with a colored, bold span
	// override = [article, spacer/before-adjectives, name]
	var/display_name = "[I.name]"
	override.len = max(override.len, 3)
	override[3] = "<span style='color: [col]; font-weight:700'>[display_name]</span>"
	return COMPONENT_EXNAME_CHANGED
