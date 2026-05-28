/* Tools for using with Pottery */

/* Items made from Pottery */

/obj/item/proc/pottery_throw_shatter(atom/hit_atom, datum/thrownthing/thrownthing)
	if(!pottery_fragile)
		return FALSE
	if(!prob(pottery_shatter_chance))
		return FALSE
	visible_message(span_warning("[src] shatters on impact!"))
	new /obj/effect/decal/cleanable/debris/glassy(get_turf(src))
	playsound(get_turf(src), 'sound/foley/glassbreak.ogg', 75, TRUE)
	qdel(src)
	return TRUE

// Uncooked items -- Still need to be brought to a kiln
// Those are all children of natural/clay so that they can inherit the Glaze method.

//Bottle - subtype of glass bottle
/obj/item/natural/clay/claybottle
	name = "unglazed clay bottle"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottleraw"
	desc = "A bottle fashioned from clay. Still needs to be glazed to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/claybottle

/obj/item/natural/clay/claybottleclassic
	name = "unglazed clay bottle"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottleraw"
	desc = "A bottle fashioned from clay. Still needs to be glazed to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/claybottleclassic

/obj/item/reagent_containers/glass/bottle/claybottle
	name = "clay bottle"
	desc = "A ceramic bottle." //The sprite was anything but small
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottlecook"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	volume = 75 // Larger than glass bottle
	sellprice = 5
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/bottle/claybottleclassic
	name = "clay bottle"
	desc = "A ceramic bottle. Tyme caresses its curves and cracks with a faint, ethereal glimmer."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottlebaked"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	volume = 75 // Larger than glass bottle
	sellprice = 5
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/bottle/claybottle/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/bottle/claybottleclassic/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()


/obj/item/reagent_containers/glass/bottle/claybottle/examine(mob/user)
	. = ..()
	. += span_info("Clay pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

/obj/item/reagent_containers/glass/bottle/claybottle/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("I can't glaze this while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/bottle/claybottleclassic/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("I can't glaze this while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return
	. = ..()

//Vase - bigger bottle
/obj/item/natural/clay/clayvase
	name = "unglazed clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvaseraw"
	desc = "A vase fashioned from clay. Still needs to be glazed to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayvase

/obj/item/natural/clay/clayvaseclassic
	name = "unglazed clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvaseraw"
	desc = "A vase fashioned from clay. Still needs to be glazed to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayvaseclassic

/obj/item/reagent_containers/glass/bottle/clayvase
	name = "ceramic vase"
	desc = "A large sized ceramic vase."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvasecook"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	volume = 65 // Larger than glass bottle
	sellprice = 7
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/bottle/clayvaseclassic
	name = "ceramic vase"
	desc = "A large sized ceramic vase. Tyme caresses its curves and cracks with a faint, ethereal glimmer."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvasebaked"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	volume = 65 // Larger than glass bottle
	sellprice = 7
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/bottle/clayvase/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/bottle/clayvaseclassic/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/bottle/clayvase/examine(mob/user)
	. = ..()
	. += span_info("Clay pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

/obj/item/reagent_containers/glass/bottle/clayvase/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("I can't glaze this while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/bottle/clayvaseclassic/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("I can't glaze this while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return
	. = ..()

//Fancy vase - bigger bottle + fancy
/obj/item/natural/clay/clayfancyvase
	name = "unglazed fancy clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvaseraw"
	desc = "A fancy vase fashioned from clay. Still needs to be glazed to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayfancyvase

/obj/item/natural/clay/clayfancyvaseclassic
	name = "unglazed fancy clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvaseraw"
	desc = "A fancy vase fashioned from clay. Still needs to be glazed to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic

/obj/item/reagent_containers/glass/bottle/clayfancyvase
	name = "fancy ceramic vase"
	desc = "A large sized fancy ceramic vase."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvasecook"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	volume = 65 // Larger than glass bottle
	sellprice = 15
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic
	name = "fancy ceramic vase"
	desc = "A large sized fancy ceramic vase. Tyme caresses its curves and cracks with a faint, ethereal glimmer."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvasebaked"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	volume = 65 // Larger than glass bottle
	sellprice = 15
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/bottle/clayfancyvase/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/bottle/clayfancyvase/examine(mob/user)
	. = ..()
	. += span_info("Clay pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

/obj/item/reagent_containers/glass/bottle/clayfancyvase/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("I can't glaze this while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("I can't glaze this while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return
	. = ..()

//Flask (was a cup) - subtype of regular cup but can shatter.
/obj/item/natural/clay/claycup
	name = "unglazed clay canister"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupraw"
	desc = "A small canister fashioned from clay. Still needs to be glazed to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/cup/claycup

/obj/item/natural/clay/claycupclassic
	name = "unglazed clay canister"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupraw"
	desc = "A small canister fashioned from clay. Still needs to be glazed to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/cup/claycupclassic

/obj/item/reagent_containers/glass/cup/claycup
	name = "clay canister"
	desc = "A small ceramic canister."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupcook"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	sellprice = 2
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/cup/claycupclassic
	name = "clay canister"
	desc = "A small ceramic canister. Tyme caresses its curves and cracks with a faint, ethereal glimmer."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupbaked"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	sellprice = 2
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/cup/claycup/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/cup/claycupclassic/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/cup/ceramic
	pottery_fragile = TRUE

/obj/item/reagent_containers/glass/cup/ceramic/fancy
	pottery_fragile = TRUE

/obj/item/reagent_containers/glass/cup/ceramic/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/cup/claycup/examine(mob/user)
	. = ..()
	. += span_info("Clay pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

/obj/item/reagent_containers/glass/cup/claycup/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("I can't glaze this while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/cup/claycupclassic/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("I can't glaze this while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return
	. = ..()

// Raw teapot
/obj/item/natural/clay/rawteapot
	name = "raw teapot"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_raw"
	desc = "A teapot fashioned from clay. Still needs to be baked to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot

// Raw teacup
/obj/item/natural/clay/rawteacup
	name = "raw teacup"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "teacup_raw"
	desc = "A teacup fashioned from clay. Still needs to be baked to be useful."
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/cup/ceramic

//Bricks - Makes bricks which are used for building. (Need brick-wall sprites for this.. augh..)
/obj/item/natural/clay/claybrick
	name = "uncooked clay brick"
	desc = "An uncooked clay brick. It still needs to be cooked in a kiln."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybrickraw"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/natural/brick

//Statues - Basically cheapest version of the metal-made statues, but way easier to make given no rare material usage. Just skill. Plus, dyeable.
/obj/item/natural/clay/claystatue
	name = "uncooked clay statue"
	desc = "An uncooked clay statue. It still needs to be cooked in a kiln."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claystatueraw"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/roguestatue/clay

// Named design subtypes — each produces a specific cooked statue variant
/obj/item/natural/clay/claystatue/design1
	icon_state = "claystatueraw"
	cooked_type = /obj/item/roguestatue/clay/design1

/obj/item/natural/clay/claystatue/design2
	icon_state = "claystatueraw2"
	cooked_type = /obj/item/roguestatue/clay/design2

/obj/item/natural/clay/claystatue/design3
	icon_state = "claystatueraw3"
	cooked_type = /obj/item/roguestatue/clay/design3

/obj/item/natural/clay/claystatue/design4
	icon_state = "claystatueraw4"
	cooked_type = /obj/item/roguestatue/clay/design4

/obj/item/natural/clay/claystatue/design5
	icon_state = "claystatueraw5"
	cooked_type = /obj/item/roguestatue/clay/design5

/obj/item/roguestatue/clay
	name = "ceramic statue"
	desc = "A ceramic statue, shining in its elegance!"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claystatuecooked1"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	smeltresult = null	//No resource return
	sellprice = 25 //Expert-tier Clay recipe. Skillgated to Towners, or those that take the 'Homesteader Expert' virtue. Let 'em cook.

/obj/item/roguestatue/clay/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/roguestatue/clay/Initialize(mapload)
	. = ..(mapload)
	icon_state = "claystatuecooked[pick(1,2,3,4,5)]"

/obj/item/roguestatue/clay/design1
	icon_state = "claystatuecooked1"

/obj/item/roguestatue/clay/design1/Initialize(mapload)
	. = ..(mapload)
	icon_state = "claystatuecooked1"

/obj/item/roguestatue/clay/design2
	icon_state = "claystatuecooked2"

/obj/item/roguestatue/clay/design2/Initialize(mapload)
	. = ..(mapload)
	icon_state = "claystatuecooked2"

/obj/item/roguestatue/clay/design3
	icon_state = "claystatuecooked3"

/obj/item/roguestatue/clay/design3/Initialize(mapload)
	. = ..(mapload)
	icon_state = "claystatuecooked3"

/obj/item/roguestatue/clay/design4
	icon_state = "claystatuecooked4"

/obj/item/roguestatue/clay/design4/Initialize(mapload)
	. = ..(mapload)
	icon_state = "claystatuecooked4"

/obj/item/roguestatue/clay/design5
	icon_state = "claystatuecooked5"

/obj/item/roguestatue/clay/design5/Initialize(mapload)
	. = ..(mapload)
	icon_state = "claystatuecooked5"

/obj/item/roguestatue/clay/examine(mob/user)
	. = ..()
	. += span_info("Clay pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

/obj/item/roguestatue/clay/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return
	. = ..()

/obj/item/roguestatue/glass
	name = "glass statue"
	desc = "A statue made of fine glass. An incredible amount of skill must have went into this fragile masterpiece!"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "statueglass1"
	smeltresult = null	//No resource return
	sellprice = 55		//Quality scales from here. Skill-gated artisan luxury.

/obj/item/roguestatue/glass/Initialize(mapload)
	. = ..(mapload)
	icon_state = "statueglass[pick(1,2,3,4,5)]"

// Named glass statue designs — each locks to a specific icon state
/obj/item/roguestatue/glass/design1
	icon_state = "statueglass1"

/obj/item/roguestatue/glass/design1/Initialize(mapload)
	. = ..(mapload)
	icon_state = "statueglass1"

/obj/item/roguestatue/glass/design2
	icon_state = "statueglass2"

/obj/item/roguestatue/glass/design2/Initialize(mapload)
	. = ..(mapload)
	icon_state = "statueglass2"

/obj/item/roguestatue/glass/design3
	icon_state = "statueglass3"

/obj/item/roguestatue/glass/design3/Initialize(mapload)
	. = ..(mapload)
	icon_state = "statueglass3"

/obj/item/roguestatue/glass/design4
	icon_state = "statueglass4"

/obj/item/roguestatue/glass/design4/Initialize(mapload)
	. = ..(mapload)
	icon_state = "statueglass4"

/obj/item/roguestatue/glass/design5
	icon_state = "statueglass5"

/obj/item/roguestatue/glass/design5/Initialize(mapload)
	. = ..(mapload)
	icon_state = "statueglass5"

/obj/item/roguestatue/glass/examine(mob/user)
	. = ..()
	. += span_info("Glassed pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

// -------------------- Porcelain --------------------

/obj/item/natural/clay/porcelain
	name = "raw porcelain piece"
	desc = "A carefully shaped porcelain piece. It needs firing in a kiln."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincupraw"
	dropshrink = 1
	obj_flags = UNIQUE_RENAME

/obj/item/natural/clay/porcelain/Initialize(mapload)
	. = ..()
	if(cooked_type)
		cooktime = 45 SECONDS

/obj/item/natural/clay/porcelain/cameo
	name = "raw porcelain cameo"
	icon_state = "clayporcelaincameoraw"
	cooked_type = /obj/item/carvedgem/porcelain/cameo

/obj/item/natural/clay/porcelain/figurine
	name = "raw porcelain figurine"
	icon_state = "clayporcelainfigurineraw"
	cooked_type = /obj/item/carvedgem/porcelain/figurine

/obj/item/natural/clay/porcelain/fish
	name = "raw porcelain fish figurine"
	icon_state = "clayporcelainfishraw"
	cooked_type = /obj/item/carvedgem/porcelain/fish

/obj/item/natural/clay/porcelain/tablet
	name = "raw porcelain tablet"
	icon_state = "clayporcelaintabletraw"
	cooked_type = /obj/item/carvedgem/porcelain/tablet

/obj/item/natural/clay/porcelain/vase
	name = "raw porcelain vase"
	icon_state = "clayporcelainvaseraw"
	dropshrink = 1
	cooked_type = /obj/item/carvedgem/porcelain/vase

/obj/item/natural/clay/porcelain/bust
	name = "raw porcelain bust"
	icon_state = "clayporcelainbustraw"
	cooked_type = /obj/item/carvedgem/porcelain/bust

/obj/item/natural/clay/porcelain/fancyvase
	name = "raw fancy porcelain vase"
	icon_state = "clayporcelainfancyvaseraw"
	dropshrink = 1
	cooked_type = /obj/item/carvedgem/porcelain/fancyvase

/obj/item/natural/clay/porcelain/comb
	name = "raw porcelain comb"
	icon_state = "clayporcelaincombraw"
	cooked_type = /obj/item/carvedgem/porcelain/comb

/obj/item/natural/clay/porcelain/duck
	name = "raw porcelain duck"
	icon_state = "clayporcelainduckraw"
	cooked_type = /obj/item/carvedgem/porcelain/duck

/obj/item/natural/clay/porcelain/mask
	name = "raw porcelain mask"
	icon_state = "clayporcelainmaskraw"
	cooked_type = /obj/item/clothing/mask/rogue/facemask/carved/porcelainmask

/obj/item/natural/clay/porcelain/urn
	name = "raw porcelain urn"
	icon_state = "clayporcelainurnraw"
	cooked_type = /obj/item/carvedgem/porcelain/urn

/obj/item/natural/clay/porcelain/statue
	name = "raw porcelain statue"
	icon_state = "clayporcelainstatueraw"
	cooked_type = /obj/item/carvedgem/porcelain/statue

/obj/item/natural/clay/porcelain/obelisk
	name = "raw porcelain obelisk"
	icon_state = "clayporcelainobeliskraw"
	cooked_type = /obj/item/carvedgem/porcelain/obelisk

/obj/item/natural/clay/porcelain/turtle
	name = "raw porcelain turtle carving"
	icon_state = "clayporcelainturtleraw"
	cooked_type = /obj/item/carvedgem/porcelain/turtle

/obj/item/natural/clay/porcelain/rungu
	name = "raw porcelain rungu"
	icon_state = "clayporcelainrunguraw"
	cooked_type = /obj/item/rogueweapon/mace/cudgel/porcelainrungu

/obj/item/natural/clay/porcelain/bauble
	name = "raw porcelain bauble"
	icon_state = "clayporcelainbaubleraw"
	cooked_type = /obj/item/carvedgem/porcelain/bauble

/obj/item/natural/clay/porcelain/fork
	name = "raw porcelain fork"
	icon_state = "clayporcelainforkraw"
	cooked_type = /obj/item/kitchen/fork/carved/porcelain

/obj/item/natural/clay/porcelain/spoon
	name = "raw porcelain spoon"
	icon_state = "clayporcelainspoonraw"
	cooked_type = /obj/item/kitchen/spoon/carved/porcelain

/obj/item/natural/clay/porcelain/bowl
	name = "raw porcelain bowl"
	icon_state = "clayporcelainbowlraw"
	cooked_type = /obj/item/reagent_containers/glass/bowl/carved/porcelain

/obj/item/natural/clay/porcelain/cup
	name = "raw porcelain teacup"
	icon_state = "clayporcelaincupraw"
	dropshrink = 1
	cooked_type = /obj/item/reagent_containers/glass/cup/porcelain

/obj/item/natural/clay/porcelain/fancycup
	name = "raw fancy porcelain cup"
	icon_state = "clayporcelaincupfancyraw"
	dropshrink = 1
	cooked_type = /obj/item/reagent_containers/glass/cup/porcelain/fancy

/obj/item/natural/clay/porcelain/fancyteacup
	name = "raw fancy teacup"
	icon_state = "clayporcelaincupraw"
	cooked_type = /obj/item/reagent_containers/glass/cup/ceramic/fancy

/obj/item/natural/clay/porcelain/platter
	name = "raw porcelain platter"
	icon_state = "clayporcelainplatterraw"
	cooked_type = /obj/item/cooking/platter/carved/porcelain

/obj/item/natural/clay/porcelain/teapot
	name = "raw porcelain teapot"
	icon_state = "clayporcelainteapotraw"
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain

/obj/item/natural/clay/porcelain/fancyteapot
	name = "raw fancy teapot"
	icon_state = "clayporcelainfancyteapot2"
	dropshrink = 1
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot/fancy

/obj/item/natural/clay/porcelain/decorativeteapot
	name = "raw decorative teapot"
	icon_state = "clayporcelainteapotraw"
	dropshrink = 1
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/decorative

/obj/item/carvedgem/porcelain
	name = "porcelain base"
	desc = "A porcelain artwork fired from refined clay."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincup"
	dropshrink = 1
	pottery_fragile = TRUE
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME

/obj/item/carvedgem/porcelain/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/carvedgem/porcelain/examine(mob/user)
	. = ..()
	. += span_info("Porcelain pottery can be glazed with a dye brush.")

/obj/item/carvedgem/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return

/obj/item/carvedgem/porcelain/cameo
	name = "porcelain cameo"
	icon_state = "clayporcelaincameo"
	sellprice = 25

/obj/item/carvedgem/porcelain/figurine
	name = "porcelain figurine"
	icon_state = "clayporcelainfigurine"
	sellprice = 30

/obj/item/carvedgem/porcelain/fish
	name = "porcelain fish figurine"
	icon_state = "clayporcelainfish"
	sellprice = 30

/obj/item/carvedgem/porcelain/vase
	name = "porcelain vase"
	icon_state = "clayporcelainvase"
	dropshrink = 1
	sellprice = 30

/obj/item/carvedgem/porcelain/tablet
	name = "porcelain tablet"
	icon_state = "clayporcelaintablet"
	sellprice = 30

/obj/item/carvedgem/porcelain/bust
	name = "porcelain bust"
	icon_state = "clayporcelainbust"
	sellprice = 40

/obj/item/carvedgem/porcelain/fancyvase
	name = "fancy porcelain vase"
	icon_state = "clayporcelian_fancyvase"
	dropshrink = 1
	sellprice = 40

/obj/item/carvedgem/porcelain/comb
	name = "porcelain comb"
	icon_state = "clayporcelaincomb"
	sellprice = 40

/obj/item/carvedgem/porcelain/duck
	name = "porcelain duck"
	icon_state = "clayporcelainduck"
	sellprice = 40

/obj/item/carvedgem/porcelain/urn
	name = "porcelain urn"
	icon_state = "clayporcelainurn"
	sellprice = 45

/obj/item/carvedgem/porcelain/statue
	name = "porcelain statue"
	icon_state = "clayporcelainstatue"
	sellprice = 45

/obj/item/carvedgem/porcelain/obelisk
	name = "porcelain obelisk"
	icon_state = "clayporcelainobelisk"
	sellprice = 45

/obj/item/carvedgem/porcelain/turtle
	name = "porcelain turtle carving"
	icon_state = "clayporcelainturtle"
	sellprice = 55

/obj/item/carvedgem/porcelain/bauble
	name = "porcelain bauble"
	icon_state = "clayporcelainbauble"
	sellprice = 30

/obj/item/reagent_containers/glass/cup/porcelain
	name = "porcelain teacup"
	desc = "A fine porcelain teacup."
	icon = 'modular/Neu_Food/icons/cookware/cup.dmi'
	icon_state = "cup_porcelain"
	dropshrink = 1
	pottery_fragile = TRUE
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	sellprice = 25
	var/porcelain_fill_icon_state = "cup_porcelainfilling"

/obj/item/reagent_containers/glass/cup/porcelain/update_icon(dont_fill=FALSE)
	testing("cupupdate")

	cut_overlays()

	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, porcelain_fill_icon_state)

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		add_overlay(filling)
	if(max_dice)
		var/dice_count = 0
		for(var/obj/item/dice/D in contents)
			dice_count++
		if(dice_count)
			dice_count = min(3, dice_count)
		add_overlay(mutable_appearance(icon, "[icon_state]dice[dice_count]"))

/obj/item/reagent_containers/glass/cup/porcelain/examine()
	. = ..()
	. += span_info("It can be brushed with a dye brush to glaze it.")

/obj/item/reagent_containers/glass/cup/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents.total_volume)
			to_chat(user, span_notice("I can't glaze the cup while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze the cup with the dye brush."))
			color = brush.dye
		return

/obj/item/reagent_containers/glass/cup/porcelain/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/cup/porcelain/fancy
	name = "fancy porcelain teacup"
	icon_state = "fancycup_porcelain"
	dropshrink = 1
	sellprice = 40

/obj/item/reagent_containers/glass/cup/ceramic/fancy/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		to_chat(user, span_notice("This finished teacup can't be glazed any further."))
		return
	. = ..()

/obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain
	name = "porcelain teapot"
	desc = "A dainty porcelain teapot used to serve tea."
	icon = 'modular/Neu_Food/icons/cookware/pot.dmi'
	icon_state = "teapot_porcelain"
	dropshrink = 1
	pottery_fragile = TRUE
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	sellprice = 30

/obj/item/reagent_containers/glass/bucket/pot/teapot/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/examine()
	. = ..()
	. += span_info("It can be brushed with a dye brush to glaze it.")

/obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(reagents.total_volume)
			to_chat(user, span_notice("I can't glaze the teapot while it has liquid in it."))
			return
		if(do_after(user, 3 SECONDS, target = src))
			to_chat(user, span_notice("I glaze the teapot with the dye brush."))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/fancy
	name = "fancy porcelain teapot"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainfancyteapot2"
	dropshrink = 1
	sellprice = 35

/obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/decorative
	name = "decorative porcelain teapot"
	desc = "An ornate porcelain teapot with a decorative finish."
	icon = 'modular/Neu_Food/icons/cookware/pot.dmi'
	icon_state = "teapot_porcelain"
	dropshrink = 1
	sellprice = 35

/obj/item/reagent_containers/glass/bucket/pot/teapot/fancy/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		to_chat(user, span_notice("This finished teapot can't be glazed any further."))
		return
	. = ..()

/obj/item/kitchen/fork/carved/porcelain
	name = "porcelain fork"
	icon = 'modular/Neu_Food/icons/cookware/fork.dmi'
	icon_state = "fork_porcelain"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	sellprice = 25

/obj/item/kitchen/fork/carved/porcelain/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/kitchen/fork/carved/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return

/obj/item/kitchen/spoon/carved/porcelain
	name = "porcelain spoon"
	icon = 'modular/Neu_Food/icons/cookware/spoon.dmi'
	icon_state = "spoon_porcelain"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	sellprice = 25

/obj/item/kitchen/spoon/carved/porcelain/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/kitchen/spoon/carved/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return

/obj/item/reagent_containers/glass/bowl/carved/porcelain
	name = "porcelain bowl"
	desc = "A bowl fired from refined porcelain clay."
	icon = 'modular/Neu_Food/icons/cookware/bowl.dmi'
	icon_state = "bowl_porcelain"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	sellprice = 25

/obj/item/reagent_containers/glass/bowl/carved/porcelain/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/bowl/carved/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return

/obj/item/cooking/platter/carved/porcelain
	name = "porcelain platter"
	desc = "A porcelain serving platter."
	icon = 'modular/Neu_Food/icons/cookware/platter.dmi'
	icon_state = "platter_porcelain"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	sellprice = 30

/obj/item/cooking/platter/carved/porcelain/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/cooking/platter/carved/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return

/obj/item/clothing/mask/rogue/facemask/carved/porcelainmask
	name = "porcelain mask"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainmask"
	desc = "A porcelain mask that conceals and protects the face."
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	pottery_fragile = TRUE
	sellprice = 45

/obj/item/clothing/mask/rogue/facemask/carved/porcelainmask/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/clothing/mask/rogue/facemask/carved/porcelainmask/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return

/obj/item/rogueweapon/mace/cudgel/porcelainrungu
	name = "porcelain rungu"
	desc = "A ceremonial rungu fired from porcelain."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainrungu"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	sellprice = 55

/obj/item/rogueweapon/mace/cudgel/porcelainrungu/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/rogueweapon/mace/cudgel/porcelainrungu/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("The dye brush has no dye loaded."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze [src] with the dye brush."))
			color = brush.dye
		return

/* Blown Glass Items — produced by the glass blowing rod, dyeable in the dye bin */

/obj/item/reagent_containers/glass/bottle/blown
	name = "blown glass bottle"
	desc = "A small bottle carefully shaped from molten glass. Its surface can be glazed with pigment in a dye bin."
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	sellprice = 4

/obj/item/reagent_containers/glass/bottle/blown/examine(mob/user)
	. = ..()
	. += span_info("Blown glass can be tinted in a dye bin.")

/obj/item/reagent_containers/glass/bottle/alchemical/blown
	name = "blown alchemical vial"
	desc = "A small vial carefully shaped from molten glass by a skilled glassblower. Its surface can be glazed with pigment in a dye bin."
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	sellprice = 2

/obj/item/reagent_containers/glass/bottle/alchemical/blown/examine(mob/user)
	. = ..()
	. += span_info("Blown glass can be tinted in a dye bin.")
