/* Tools for using with Pottery */

/* Items made from Pottery */

/obj/item/proc/pottery_throw_shatter(atom/hit_atom, datum/thrownthing/thrownthing)
	if(!pottery_fragile)
		return FALSE
	if(!prob(pottery_shatter_chance))
		return FALSE
	visible_message(span_warning("[src]撞得粉碎！"))
	new /obj/effect/decal/cleanable/debris/glassy(get_turf(src))
	playsound(get_turf(src), 'sound/foley/glassbreak.ogg', 75, TRUE)
	qdel(src)
	return TRUE

// Uncooked items -- Still need to be brought to a kiln
// Those are all children of natural/clay so that they can inherit the Glaze method.

//Bottle - subtype of glass bottle
/obj/item/natural/clay/claybottle
	name = "未上釉陶瓶"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottleraw"
	desc = "以黏土制成的瓶子。仍需上釉后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/claybottle

/obj/item/natural/clay/claybottleclassic
	name = "未上釉素陶瓶"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottleraw"
	desc = "以黏土制成的素陶瓶。仍需上釉后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/claybottleclassic

/obj/item/reagent_containers/glass/bottle/claybottle
	name = "陶瓶"
	desc = "一只陶制瓶子。" //The sprite was anything but small
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottlecook"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	volume = 75 // Larger than glass bottle
	sellprice = 5
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/bottle/claybottleclassic
	name = "素陶瓶"
	desc = "一只陶制瓶子。Tyme 轻抚其曲线与裂纹，泛着淡淡空灵微光。"
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
	. += span_info("黏土陶器不同于金属同类，可在染缸中染色。")

/obj/item/reagent_containers/glass/bottle/claybottle/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("里面有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/bottle/claybottleclassic/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("里面有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return
	. = ..()

//Vase - bigger bottle
/obj/item/natural/clay/clayvase
	name = "未上釉陶花瓶"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvaseraw"
	desc = "以黏土制成的花瓶。仍需上釉后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayvase

/obj/item/natural/clay/clayvaseclassic
	name = "未上釉素陶花瓶"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvaseraw"
	desc = "以黏土制成的素陶花瓶。仍需上釉后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayvaseclassic

/obj/item/reagent_containers/glass/bottle/clayvase
	name = "陶花瓶"
	desc = "一只大型陶花瓶。"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvasecook"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	volume = 65 // Larger than glass bottle
	sellprice = 7
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/bottle/clayvaseclassic
	name = "素陶花瓶"
	desc = "一只大型陶花瓶。Tyme 轻抚其曲线与裂纹，泛着淡淡空灵微光。"
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
	. += span_info("黏土陶器不同于金属同类，可在染缸中染色。")

/obj/item/reagent_containers/glass/bottle/clayvase/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("里面有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/bottle/clayvaseclassic/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("里面有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return
	. = ..()

//Fancy vase - bigger bottle + fancy
/obj/item/natural/clay/clayfancyvase
	name = "未上釉华美陶花瓶"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvaseraw"
	desc = "以黏土制成的华美花瓶。仍需上釉后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayfancyvase

/obj/item/natural/clay/clayfancyvaseclassic
	name = "未上釉华美素陶花瓶"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvaseraw"
	desc = "以黏土制成的华美素陶花瓶。仍需上釉后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic

/obj/item/reagent_containers/glass/bottle/clayfancyvase
	name = "华美陶花瓶"
	desc = "一只大型华美陶花瓶。"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvasecook"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	volume = 65 // Larger than glass bottle
	sellprice = 15
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic
	name = "华美素陶花瓶"
	desc = "一只大型华美陶花瓶。Tyme 轻抚其曲线与裂纹，泛着淡淡空灵微光。"
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
	. += span_info("黏土陶器不同于金属同类，可在染缸中染色。")

/obj/item/reagent_containers/glass/bottle/clayfancyvase/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("里面有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("里面有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return
	. = ..()

//Flask (was a cup) - subtype of regular cup but can shatter.
/obj/item/natural/clay/claycup
	name = "未上釉陶罐"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupraw"
	desc = "以黏土制成的小罐。仍需上釉后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/cup/claycup

/obj/item/natural/clay/claycupclassic
	name = "未上釉素陶罐"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupraw"
	desc = "以黏土制成的小型素陶罐。仍需上釉后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/cup/claycupclassic

/obj/item/reagent_containers/glass/cup/claycup
	name = "陶罐"
	desc = "一个小巧的陶罐。"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupcook"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	pottery_fragile = TRUE
	sellprice = 2
	reagent_flags = OPENCONTAINER	//So it doesn't appear through

/obj/item/reagent_containers/glass/cup/claycupclassic
	name = "素陶罐"
	desc = "一个小巧的陶罐。Tyme 轻抚其曲线与裂纹，泛着淡淡空灵微光。"
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
	. += span_info("黏土陶器不同于金属同类，可在染缸中染色。")

/obj/item/reagent_containers/glass/cup/claycup/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("里面有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/cup/claycupclassic/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents?.total_volume)
			to_chat(user, span_notice("里面有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return
	. = ..()

// Raw teapot
/obj/item/natural/clay/rawteapot
	name = "生坯茶壶"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_raw"
	desc = "以黏土制成的茶壶。仍需烧制后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot

// Raw teacup
/obj/item/natural/clay/rawteacup
	name = "生坯茶杯"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "teacup_raw"
	desc = "以黏土制成的茶杯。仍需烧制后才算堪用。"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/reagent_containers/glass/cup/ceramic

//Bricks - Makes bricks which are used for building. (Need brick-wall sprites for this.. augh..)
/obj/item/natural/clay/claybrick
	name = "未烧制黏土砖"
	desc = "一块未烧制的黏土砖。仍需放入窑中烧制。"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybrickraw"
	obj_flags = UNIQUE_RENAME
	cooked_type = /obj/item/natural/brick

//Statues - Basically cheapest version of the metal-made statues, but way easier to make given no rare material usage. Just skill. Plus, dyeable.
/obj/item/natural/clay/claystatue
	name = "未烧制黏土雕像"
	desc = "一尊未烧制的黏土雕像。仍需放入窑中烧制。"
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
	name = "陶制雕像"
	desc = "一尊陶制雕像，优雅生辉！"
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
	. += span_info("黏土陶器不同于金属同类，可在染缸中染色。")

/obj/item/roguestatue/clay/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return
	. = ..()

/obj/item/roguestatue/glass
	name = "玻璃雕像"
	desc = "一尊由精美玻璃制成的雕像。如此脆弱的杰作，想必倾注了非凡技艺！"
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
	. += span_info("玻璃陶器不同于金属同类，可在染缸中染色。")

// -------------------- Porcelain --------------------

/obj/item/natural/clay/porcelain
	name = "生坯瓷件"
	desc = "一件精心塑形的瓷器坯件。它需要放入窑中烧制。"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincupraw"
	dropshrink = 1
	obj_flags = UNIQUE_RENAME

/obj/item/natural/clay/porcelain/Initialize(mapload)
	. = ..()
	if(cooked_type)
		cooktime = 45 SECONDS

/obj/item/natural/clay/porcelain/cameo
	name = "生坯瓷浮雕"
	icon_state = "clayporcelaincameoraw"
	cooked_type = /obj/item/carvedgem/porcelain/cameo

/obj/item/natural/clay/porcelain/figurine
	name = "生坯瓷小像"
	icon_state = "clayporcelainfigurineraw"
	cooked_type = /obj/item/carvedgem/porcelain/figurine

/obj/item/natural/clay/porcelain/fish
	name = "生坯瓷鱼像"
	icon_state = "clayporcelainfishraw"
	cooked_type = /obj/item/carvedgem/porcelain/fish

/obj/item/natural/clay/porcelain/tablet
	name = "生坯瓷板"
	icon_state = "clayporcelaintabletraw"
	cooked_type = /obj/item/carvedgem/porcelain/tablet

/obj/item/natural/clay/porcelain/vase
	name = "生坯瓷花瓶"
	icon_state = "clayporcelainvaseraw"
	dropshrink = 1
	cooked_type = /obj/item/carvedgem/porcelain/vase

/obj/item/natural/clay/porcelain/bust
	name = "生坯瓷半身像"
	icon_state = "clayporcelainbustraw"
	cooked_type = /obj/item/carvedgem/porcelain/bust

/obj/item/natural/clay/porcelain/fancyvase
	name = "生坯华美瓷花瓶"
	icon_state = "clayporcelainfancyvaseraw"
	dropshrink = 1
	cooked_type = /obj/item/carvedgem/porcelain/fancyvase

/obj/item/natural/clay/porcelain/comb
	name = "生坯瓷梳"
	icon_state = "clayporcelaincombraw"
	cooked_type = /obj/item/carvedgem/porcelain/comb

/obj/item/natural/clay/porcelain/duck
	name = "生坯瓷鸭"
	icon_state = "clayporcelainduckraw"
	cooked_type = /obj/item/carvedgem/porcelain/duck

/obj/item/natural/clay/porcelain/mask
	name = "生坯瓷面具"
	icon_state = "clayporcelainmaskraw"
	cooked_type = /obj/item/clothing/mask/rogue/facemask/carved/porcelainmask

/obj/item/natural/clay/porcelain/urn
	name = "生坯瓷瓮"
	icon_state = "clayporcelainurnraw"
	cooked_type = /obj/item/carvedgem/porcelain/urn

/obj/item/natural/clay/porcelain/statue
	name = "生坯瓷雕像"
	icon_state = "clayporcelainstatueraw"
	cooked_type = /obj/item/carvedgem/porcelain/statue

/obj/item/natural/clay/porcelain/obelisk
	name = "生坯瓷方尖碑"
	icon_state = "clayporcelainobeliskraw"
	cooked_type = /obj/item/carvedgem/porcelain/obelisk

/obj/item/natural/clay/porcelain/turtle
	name = "生坯瓷龟雕"
	icon_state = "clayporcelainturtleraw"
	cooked_type = /obj/item/carvedgem/porcelain/turtle

/obj/item/natural/clay/porcelain/rungu
	name = "生坯瓷伦古棍"
	icon_state = "clayporcelainrunguraw"
	cooked_type = /obj/item/rogueweapon/mace/cudgel/porcelainrungu

/obj/item/natural/clay/porcelain/bauble
	name = "生坯瓷饰物"
	icon_state = "clayporcelainbaubleraw"
	cooked_type = /obj/item/carvedgem/porcelain/bauble

/obj/item/natural/clay/porcelain/fork
	name = "生坯瓷叉"
	icon_state = "clayporcelainforkraw"
	cooked_type = /obj/item/kitchen/fork/carved/porcelain

/obj/item/natural/clay/porcelain/spoon
	name = "生坯瓷匙"
	icon_state = "clayporcelainspoonraw"
	cooked_type = /obj/item/kitchen/spoon/carved/porcelain

/obj/item/natural/clay/porcelain/bowl
	name = "生坯瓷碗"
	icon_state = "clayporcelainbowlraw"
	cooked_type = /obj/item/reagent_containers/glass/bowl/carved/porcelain

/obj/item/natural/clay/porcelain/cup
	name = "生坯瓷茶杯"
	icon_state = "clayporcelaincupraw"
	dropshrink = 1
	cooked_type = /obj/item/reagent_containers/glass/cup/porcelain

/obj/item/natural/clay/porcelain/fancycup
	name = "生坯华美瓷杯"
	icon_state = "clayporcelaincupfancyraw"
	dropshrink = 1
	cooked_type = /obj/item/reagent_containers/glass/cup/porcelain/fancy

/obj/item/natural/clay/porcelain/fancyteacup
	name = "生坯华美茶杯"
	icon_state = "clayporcelaincupraw"
	cooked_type = /obj/item/reagent_containers/glass/cup/ceramic/fancy

/obj/item/natural/clay/porcelain/platter
	name = "生坯瓷托盘"
	icon_state = "clayporcelainplatterraw"
	cooked_type = /obj/item/cooking/platter/carved/porcelain

/obj/item/natural/clay/porcelain/teapot
	name = "生坯瓷茶壶"
	icon_state = "clayporcelainteapotraw"
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain

/obj/item/natural/clay/porcelain/fancyteapot
	name = "生坯华美茶壶"
	icon_state = "clayporcelainfancyteapot2"
	dropshrink = 1
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot/fancy

/obj/item/natural/clay/porcelain/decorativeteapot
	name = "生坯装饰茶壶"
	icon_state = "clayporcelainteapotraw"
	dropshrink = 1
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/decorative

/obj/item/carvedgem/porcelain
	name = "瓷器底坯"
	desc = "一件由精炼瓷土烧制而成的瓷艺品。"
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
	. += span_info("瓷器可用染刷上釉。")

/obj/item/carvedgem/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return

/obj/item/carvedgem/porcelain/cameo
	name = "瓷浮雕"
	icon_state = "clayporcelaincameo"
	sellprice = 25

/obj/item/carvedgem/porcelain/figurine
	name = "瓷小像"
	icon_state = "clayporcelainfigurine"
	sellprice = 30

/obj/item/carvedgem/porcelain/fish
	name = "瓷鱼像"
	icon_state = "clayporcelainfish"
	sellprice = 30

/obj/item/carvedgem/porcelain/vase
	name = "瓷花瓶"
	icon_state = "clayporcelainvase"
	dropshrink = 1
	sellprice = 30

/obj/item/carvedgem/porcelain/tablet
	name = "瓷板"
	icon_state = "clayporcelaintablet"
	sellprice = 30

/obj/item/carvedgem/porcelain/bust
	name = "瓷半身像"
	icon_state = "clayporcelainbust"
	sellprice = 40

/obj/item/carvedgem/porcelain/fancyvase
	name = "华美瓷花瓶"
	icon_state = "clayporcelian_fancyvase"
	dropshrink = 1
	sellprice = 40

/obj/item/carvedgem/porcelain/comb
	name = "瓷梳"
	icon_state = "clayporcelaincomb"
	sellprice = 40

/obj/item/carvedgem/porcelain/duck
	name = "瓷鸭"
	icon_state = "clayporcelainduck"
	sellprice = 40

/obj/item/carvedgem/porcelain/urn
	name = "瓷瓮"
	icon_state = "clayporcelainurn"
	sellprice = 45

/obj/item/carvedgem/porcelain/statue
	name = "瓷雕像"
	icon_state = "clayporcelainstatue"
	sellprice = 45

/obj/item/carvedgem/porcelain/obelisk
	name = "瓷方尖碑"
	icon_state = "clayporcelainobelisk"
	sellprice = 45

/obj/item/carvedgem/porcelain/turtle
	name = "瓷龟雕"
	icon_state = "clayporcelainturtle"
	sellprice = 55

/obj/item/carvedgem/porcelain/bauble
	name = "瓷饰物"
	icon_state = "clayporcelainbauble"
	sellprice = 30

/obj/item/reagent_containers/glass/cup/porcelain
	name = "瓷茶杯"
	desc = "一只精致的瓷茶杯。"
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
	. += span_info("它可以用染刷上釉。")

/obj/item/reagent_containers/glass/cup/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents.total_volume)
			to_chat(user, span_notice("杯中有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给茶杯上釉。"))
			color = brush.dye
		return

/obj/item/reagent_containers/glass/cup/porcelain/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(pottery_throw_shatter(hit_atom, thrownthing))
		return
	return ..()

/obj/item/reagent_containers/glass/cup/porcelain/fancy
	name = "华美瓷茶杯"
	icon_state = "fancycup_porcelain"
	dropshrink = 1
	sellprice = 40

/obj/item/reagent_containers/glass/cup/ceramic/fancy/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		to_chat(user, span_notice("这只成品茶杯不能再继续上釉了。"))
		return
	. = ..()

/obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain
	name = "瓷茶壶"
	desc = "一把用于奉茶的秀雅瓷茶壶。"
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
	. += span_info("它可以用染刷上釉。")

/obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		var/obj/item/dye_brush/brush = I
		if(!brush.dye)
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(reagents.total_volume)
			to_chat(user, span_notice("壶里有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 3 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给茶壶上釉。"))
			color = brush.dye
		return
	. = ..()

/obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/fancy
	name = "华美瓷茶壶"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainfancyteapot2"
	dropshrink = 1
	sellprice = 35

/obj/item/reagent_containers/glass/bucket/pot/teapot/porcelain/decorative
	name = "装饰瓷茶壶"
	desc = "一把带有装饰性釉面的华丽瓷茶壶。"
	icon = 'modular/Neu_Food/icons/cookware/pot.dmi'
	icon_state = "teapot_porcelain"
	dropshrink = 1
	sellprice = 35

/obj/item/reagent_containers/glass/bucket/pot/teapot/fancy/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		to_chat(user, span_notice("这把成品茶壶不能再继续上釉了。"))
		return
	. = ..()

/obj/item/kitchen/fork/carved/porcelain
	name = "瓷叉"
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
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return

/obj/item/kitchen/spoon/carved/porcelain
	name = "瓷匙"
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
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return

/obj/item/reagent_containers/glass/bowl/carved/porcelain
	name = "瓷碗"
	desc = "一只由精炼瓷土烧制而成的瓷碗。"
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
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return

/obj/item/cooking/platter/carved/porcelain
	name = "瓷托盘"
	desc = "一个瓷制上菜托盘。"
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
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return

/obj/item/clothing/mask/rogue/facemask/carved/porcelainmask
	name = "瓷面具"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainmask"
	desc = "一副能遮掩并保护面部的瓷面具。"
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
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return

/obj/item/rogueweapon/mace/cudgel/porcelainrungu
	name = "瓷伦古棍"
	desc = "一柄以瓷烧制而成的礼仪用伦古棍。"
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
			to_chat(user, span_warning("染刷里没有装入染料。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染刷给[src]上釉。"))
			color = brush.dye
		return

/* Blown Glass Items — produced by the glass blowing rod, dyeable in the dye bin */

/obj/item/reagent_containers/glass/bottle/blown
	name = "吹制玻璃瓶"
	desc = "一个由熔融玻璃精心吹制成的小瓶。其表面可在染缸中覆上色釉。"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	sellprice = 4

/obj/item/reagent_containers/glass/bottle/blown/examine(mob/user)
	. = ..()
	. += span_info("吹制玻璃可在染缸中染色。")

/obj/item/reagent_containers/glass/bottle/alchemical/blown
	name = "吹制炼金小瓶"
	desc = "一个由熟练玻璃工匠以熔融玻璃精心吹制的小瓶。其表面可在染缸中覆上色釉。"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	sellprice = 2

/obj/item/reagent_containers/glass/bottle/alchemical/blown/examine(mob/user)
	. = ..()
	. += span_info("吹制玻璃可在染缸中染色。")
