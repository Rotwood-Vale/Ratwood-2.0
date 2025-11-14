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
	var/col = isnum(r) ? get_ratworld_rarity_color(r) : null
	// Replace the name segment (position 3) and append a gem star cue if present
	// override = [article, spacer/before-adjectives, name]
	var/display_name = "[I.name]"
	var/gem_label = I.vars?["rw_socket_gem"]
	var/gem_color = I.vars?["rw_socket_gem_color"]
	var/gem_suffix = ""
	if(istext(gem_label) && length(gem_label))
		if(!istext(gem_color) || !length(gem_color)) gem_color = "#cccccc"
		gem_suffix = " <span style='color: [gem_color]; font-weight:700'>(★-[gem_label])</span>"
	override.len = max(override.len, 3)
	if(istext(col) && length(col))
		override[3] = "<span style='color: [col]; font-weight:700'>[display_name]</span>[gem_suffix]"
	else
		override[3] = "[display_name][gem_suffix]"
	return COMPONENT_EXNAME_CHANGED
