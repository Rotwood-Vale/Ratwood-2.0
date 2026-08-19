
/obj/item/roguestatue
	icon = 'icons/roguetown/items/valuable.dmi'
	name = "statue"
	icon_state = ""
	w_class = WEIGHT_CLASS_NORMAL
	experimental_inhand = FALSE
	smeltresult = null
	grid_width = 32
	grid_height = 64

/obj/item/roguestatue/gold
	name = "gold statue"
	desc = "A statue made of heavy, gleaming gold!"
	icon_state = "gstatue1"
	smeltresult = /obj/item/ingot/gold
	sellprice = 120

/obj/item/roguestatue/gold/Initialize(mapload)
	. = ..()
	icon_state = "gstatue[pick(1,2)]"

/obj/item/roguestatue/gold/loot
	name = "gold statuette"
	desc = "A statue made of heavy, gleaming gold!"
	icon_state = "lstatue1"
	sellprice = 45

/obj/item/roguestatue/gold/loot/Initialize(mapload)
	. = ..()
	sellprice = rand(45,150)
	icon_state = "lstatue[pick(1,2,3,4)]"

/obj/item/roguestatue/silver
	name = "silver statue"
	desc = "A statue made of pure, shimmering silver!"
	icon_state = "sstatue1"
	smeltresult = /obj/item/ingot/silver
	sellprice = 90

/obj/item/roguestatue/silver/Initialize(mapload)
	. = ..()
	icon_state = "sstatue[pick(1,2)]"

/obj/item/roguestatue/steel
	name = "steel statue"
	desc = "An unyielding statue of resilient steel."
	icon_state = "ststatue1"
	smeltresult = /obj/item/ingot/steel
	sellprice = 40

/obj/item/roguestatue/steel/Initialize(mapload)
	. = ..()
	icon_state = "ststatue[pick(1,2)]"

/obj/item/roguestatue/decrepit
	name = "decrepit statue"
	desc = "A statue of wrought bronze, forged to venerate an ancient champion."
	icon_state = "astatue1"
	smeltresult = /obj/item/ingot/aaslag
	sellprice = 77
	color = "#bb9696"

/obj/item/roguestatue/decrepit/Initialize(mapload)
	. = ..()
	icon_state = "astatue[pick(1,2)]"

/obj/item/roguestatue/iron
	name = "iron statue"
	desc = "A forged statue of cast iron!"
	icon_state = "istatue1"
	smeltresult = /obj/item/ingot/iron
	sellprice = 20

/obj/item/roguestatue/iron/Initialize(mapload)
	. = ..()
	icon_state = "istatue[pick(1,2)]"

/obj/item/roguestatue/bronze
	name = "bronze statue"
	desc = "A statue of sculpted bronze, forged in the visage of an ancient hero."
	icon_state = "bronzestatue1"
	smeltresult = /obj/item/ingot/bronze

/obj/item/roguestatue/bronze/Initialize(mapload)
	. = ..()
	icon_state = "bronzestatue[pick(1,2,3)]"

/obj/item/roguestatue/blacksteel
	name = "blacksteel statue"
	desc = "A dark statue of glimmering, resilient blacksteel."
	icon_state = "bsstatue1"
	smeltresult = /obj/item/ingot/blacksteel
	sellprice = 160

/obj/item/roguestatue/blacksteel/Initialize(mapload)
	. = ..()
	icon_state = "bsstatue[pick(1,2)]"
//000000000000000000000000000--

/obj/item/var/polished = FALSE
/obj/item/var/polish_bonus = 0
/obj/item/var/pottery_quality = 0
/obj/item/var/creator_skill = 0
/obj/item/var/pottery_fragile = FALSE
/obj/item/var/pottery_baked_at = 0
/obj/item/var/pottery_shatter_chance = 100

/obj/item/examine(mob/user)
	. = ..()
	switch(polished)
		if(1)
			. += span_info("It has some polishing compound on it.")
		if(2, 3)
			. += span_info("It's been thoroughly brushed.")
		if(4)
			. += span_green("It's been nicely polished.")
	if(shoddy_repair)
		. += span_warning("This item has been field-repaired and needs to be fixed by a proper craftsman.")

/obj/item/polishing_cream
	icon = 'icons/roguetown/items/misc.dmi'
	name = "polishing cream"
	desc = "A pure silver compound made for making the best metals shine."
	icon_state = "cream"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.8
	var/uses = 12
	grid_width = 32
	grid_height = 32

/obj/item/polishing_cream/examine(mob/user)
	. = ..()
	. += span_info("It has [uses] uses left.")

/obj/item/polishing_cream/attack_obj(obj/O, mob/living/user)
	if(!isitem(O) || !uses)
		return ..()
	var/obj/item/thing = O
	if(!thing.anvilrepair)
		return ..()
	if((HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE) || user.get_skill_level(thing.anvilrepair)) && (!thing.polished || (thing.polished == 4 && !thing.polish_bonus)) && obj_integrity <= max_integrity)//split polish 4 and polish_bonus so we can polish masterworks
		to_chat(user, span_info("I start applying some compound to \the [thing]..."))
		if(do_after(user, 50 - user.STASPD*2, target = O))
			thing.polished = 1
			uses--
			thing.remove_atom_colour(FIXED_COLOUR_PRIORITY)
			thing.add_atom_colour("#635e65", FIXED_COLOUR_PRIORITY)
			thing.RegisterSignal(thing, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(remove_polish))
			if(uses <= 8)
				smeltresult = null
				icon_state = "low_cream"
			if(!uses)
				icon_state = "empty_cream"

/obj/item/armor_brush
	icon = 'icons/roguetown/items/misc.dmi'
	name = "fine brush"
	desc = "A coarse brush for scrubbing armor thoroughly. Made of the finest Lupin hair."
	icon_state = "brush_0"
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = null
	dropshrink = 0.6
	grid_width = 32
	grid_height = 64
	var/roughness = 0 // 0  for a fine brush, 1 for a coarse brush

/obj/item/armor_brush/examine()
	. = ..()
	. += span_info("To polish a weapon or a piece of armor, you must have the knowledge of a squire or how to repair the item. Follow the following steps:")
	. += span_info("I. Apply polishing cream to the item.")
	. += span_info("II. Use the coarse side (use the item to flip it) to scrub the item roughly.")
	. += span_info("III. Use the fine side to gently polish the item.")
	. += span_info("IV. Wash the item in a wooden bin with water to polish it.")
	. += span_info("A fully polished item will be slightly stronger and or more durable.")

/obj/item/armor_brush/attack_self(mob/user)
	roughness = 1 - roughness
	if(roughness)
		to_chat(user, span_info("I flip the brush to the coarse side."))
		name = "coarse brush"
	else
		to_chat(user, span_info("I flip the brush to the fine side."))
		name = "fine brush"
	icon_state = "brush_[roughness]"

/obj/item/armor_brush/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return ..()
	var/obj/item/thing = O
	if(thing.polished == 1 && roughness)
		if((HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE) || user.get_skill_level(thing.anvilrepair)))
			to_chat(user, span_info("I start roughly scrubbing the compound on \the [thing]..."))
			playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 100, TRUE)
			if(do_after(user, 50 - user.STASTR*1.5, target = O))
				thing.polished = 2
				thing.remove_atom_colour(FIXED_COLOUR_PRIORITY)
				thing.add_atom_colour("#9e9e9e", FIXED_COLOUR_PRIORITY)

	else if(thing.polished == 2 && !roughness)
		if((HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE) || user.get_skill_level(thing.anvilrepair)))
			to_chat(user, span_info("I start gently scrubbing the edges of \the [thing]..."))
			playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 100, TRUE)
			if(do_after(user, 50 - user.STASTR*1.5, target = O))
				thing.polished = 3
				thing.remove_atom_colour(FIXED_COLOUR_PRIORITY)
				thing.add_atom_colour("#cccccc", FIXED_COLOUR_PRIORITY)

/obj/item/proc/lose_polish()//called when item's break, if said item is polished, it proceeds.
	if(!polished)
		return

	if(polished == 4 && polish_bonus)//require both so we dont remove force from a masterwork item that has polished == 4 but not a polish bonus
		force -= 2
		force_wielded -= 3
		max_integrity -= polish_bonus
		obj_integrity = min(obj_integrity, max_integrity)
		update_force_dynamic()
	else if(polished >= 1 && polished <= 3)//remove partially polished stages if we break the item and its, for some reason, only halfway polished
		UnregisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT)

	polished = 0
	polish_bonus = 0
	remove_atom_colour(FIXED_COLOUR_PRIORITY)
	var/datum/component/silverbless/silver_blessing = GetComponent(/datum/component/silverbless)
	var/datum/component/psyblessed/psy_blessing = GetComponent(/datum/component/psyblessed)
//dont delete glint from blessed silver since it's inate unlike masterwork and polish cream
	if(!silver_blessing?.is_blessed && !psy_blessing?.is_blessed)
		var/datum/component/glint = GetComponent(/datum/component/metal_glint)
		qdel(glint)

//below adds polish buff but is called remove_polish because it lowers the amount of polishing cream uses. name sucks and i hate it but it is what it is. proc/lose_polish() is what actually removes the polish buffs and glint.
/obj/item/proc/remove_polish(datum/source, strength) // kill polska
	if(polished == 3 && obj_integrity >= max_integrity)
		polished = 4
		remove_atom_colour(FIXED_COLOUR_PRIORITY)
		add_atom_colour("#ffffff", FIXED_COLOUR_PRIORITY)
		polish_bonus = ceil(max_integrity * 0.10)
		max_integrity += polish_bonus
		obj_integrity += polish_bonus
		force += 2
		force_wielded += 3
		update_force_dynamic()
		AddComponent(/datum/component/metal_glint)
		UnregisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT)

	else if(polished < 4)
		polished = 0
		polish_bonus = 0
		remove_atom_colour(FIXED_COLOUR_PRIORITY)
		UnregisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT)

/obj/effect/temp_visual/armor_glint
	name = "glint"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "glint"
	alpha = 200
	duration = 13
	plane = -1

/obj/effect/temp_visual/armor_glint/Initialize(mapload, extra_rand = 1)
	. = ..()
	pixel_x = extra_rand * rand(-5,5)
	pixel_y = extra_rand * rand(-5,5)
	animate(src, alpha = 0, time = duration)

/datum/component/metal_glint/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, list(COMSIG_QDELETING), PROC_REF(stop_process))
	START_PROCESSING(SSobj, src)

/datum/component/metal_glint/process()
	var/atom/current_parent = parent
	if(istype(current_parent.loc, /turf))
		if(prob(25))
			new /obj/effect/temp_visual/armor_glint(current_parent.loc)
		if(prob(15))
			new /obj/effect/temp_visual/armor_glint(current_parent.loc, 2)
		if(prob(5))
			new /obj/effect/temp_visual/armor_glint(current_parent.loc, 3)
	else if(istype(current_parent.loc, /mob/living) && istype(current_parent, /obj/item/clothing/suit/roguetown/armor))
		var/mob/M = current_parent.loc
		var/turf/T = get_turf(M)
		if(prob(8))
			new /obj/effect/temp_visual/armor_glint(T)
		if(prob(4))
			new /obj/effect/temp_visual/armor_glint(T, 2)
		if(prob(2))
			new /obj/effect/temp_visual/armor_glint(T, 3)

/datum/component/metal_glint/proc/stop_process()
	STOP_PROCESSING(SSobj, src)
