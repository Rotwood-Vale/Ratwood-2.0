// Alchemy Component System
// This datum can be added to any item to make it usable in KCD-style alchemy

/datum/alchemy_component
	var/name = "unknown ingredient"
	var/description = "An alchemical ingredient."
	
	// Properties copied to resulting reagent
	var/herb_color = "#FFFFFF"
	var/herb_smell = "herbs"
	var/herb_taste = "botanical"
	
	// For traditional potion system compatibility
	var/major_pot = null
	var/med_pot = null
	var/minor_pot = null
	
	// Cached values (set automatically during New())
	var/major_smell
	var/med_smell
	var/minor_smell
	var/major_name
	var/med_name
	var/minor_name

/datum/alchemy_component/New(herb_name, herb_col, herb_sm, herb_tst, maj_pot, md_pot, min_pot)
	. = ..()
	
	// Set properties from constructor if provided
	if(herb_name)
		name = herb_name
	if(herb_col)
		herb_color = herb_col
	if(herb_sm)
		herb_smell = herb_sm
	if(herb_tst)
		herb_taste = herb_tst
	if(maj_pot)
		major_pot = maj_pot
	if(md_pot)
		med_pot = md_pot
	if(min_pot)
		minor_pot = min_pot
	
	// Cache potion names and smells for traditional system
	if(!isnull(major_pot))
		var/datum/alch_cauldron_recipe/rec = locate(major_pot) in GLOB.alch_cauldron_recipes
		if(rec)
			major_smell = rec.smells_like
			major_name = rec.name
	if(!isnull(med_pot))
		var/datum/alch_cauldron_recipe/rec = locate(med_pot) in GLOB.alch_cauldron_recipes
		if(rec)
			med_smell = rec.smells_like
			med_name = rec.name
	if(!isnull(minor_pot))
		var/datum/alch_cauldron_recipe/rec = locate(minor_pot) in GLOB.alch_cauldron_recipes
		if(rec)
			minor_smell = rec.smells_like
			minor_name = rec.name

// Helper proc to add alchemy component to an item
/obj/item/proc/set_alchemy_component(datum/alchemy_component/comp)
	alchemy_component = comp

// Add the component variable to all items
/obj/item
	var/datum/alchemy_component/alchemy_component = null
