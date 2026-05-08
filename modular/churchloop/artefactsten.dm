//chat gpt 5 narrator mode explain in 5 paragraphs why should anime protagonist sparkle dog with blue custom fart cloud role spawn with it
//you cannot get it why cant they have it my John Sniffa my fursona must have it
#define MALUM_ALLOWED_INGOTS list( \
	/obj/item/ingot/steel, \
	/obj/item/ingot/iron, \
	/obj/item/ingot/aalloy, \
	/obj/item/ingot/purifiedaalloy \
)

var/global/list/EORA_PARTNERS_BY_ID = list()
var/global/list/EORA_ID_NAME = list()

GLOBAL_LIST_INIT(generated_reliquary_codes, list())

#define RELIQUARY_CODE_LEN 4

/proc/generate_reliquary_code()
	var/tries = 0
	while(tries < 200)
		var/code = ""
		for(var/i = 1, i <= RELIQUARY_CODE_LEN, i++)
			code += "[rand(0,9)]"
		if(!(code in GLOB.generated_reliquary_codes))
			GLOB.generated_reliquary_codes += code
			return code
		tries++

	for(var/n = 0, n < 10000, n++)
		var/code2 = "[n]"
		while(length(code2) < RELIQUARY_CODE_LEN)
			code2 = "0[code2]"
		if(!(code2 in GLOB.generated_reliquary_codes))
			GLOB.generated_reliquary_codes += code2
			return code2

	return "0000"

/*============
Malum's tool
============*/
/*
- A universal hammer-tool that can do everything. Blacksmiths will kill you for this.
*/

/obj/item/rogueweapon/hammer/artefact/malum
	force = 21
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/forge, /datum/intent/smelt)
	name = "Malum's tool"
	desc = "A blessed hammer that forges fate as it pleases."
	icon = 'icons/roguetown/items/artefactsten.dmi'
	icon_state = "malumartefact"
	sharpness = IS_BLUNT
	wlength = 10
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	associated_skill = /datum/skill/combat/maces
	smeltresult = /obj/item/ash
	grid_width = 32
	grid_height = 64

/datum/intent/forge
	name = "forge"
	icon_state = "inforge"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/datum/intent/smelt
	name = "smelt"
	icon_state = "insmelt"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/proc/_malum_recipe_requires_extras(datum/anvil_recipe/R)
	if(!R)
		return FALSE
	if(ispath(R:needed_item))
		return TRUE
	var/ai = R:additional_items
	if(ispath(ai))
		return TRUE
	if(islist(ai) && length(ai) > 0)
		return TRUE
	return FALSE

/obj/item/rogueweapon/hammer/artefact/malum/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag || !user || !user.used_intent)
		return

	if(istype(user.used_intent, /datum/intent/forge))
		if(istype(target, /obj/machinery/anvil))
			var/obj/machinery/anvil/A = target
			var/obj/item/ingot/ing_on_anvil = A.vars["hingot"]
			if(istype(ing_on_anvil, /obj/item/ingot))
				A.vars["hingot"] = null
				A.update_icon()
				ing_on_anvil.forceMove(src)
				forge_open_category_menu(user, ing_on_anvil)
				return

			to_chat(user, span_warning("Place an ingot on the anvil or click an ingot directly."))
			return

		if(!isitem(target))
			to_chat(user, span_warning("I need to click an ingot to forge."))
			return

		var/obj/item/ingot/ing = target
		if(!istype(ing, /obj/item/ingot))
			to_chat(user, span_warning("[target] is not an ingot."))
			return

		ing.forceMove(src)
		forge_open_category_menu(user, ing)
		return

	if(istype(user.used_intent, /datum/intent/smelt))
		if(!isitem(target))
			to_chat(user, span_warning("I need an item to smelt down."))
			return

		var/obj/item/I2 = target
		var/ok_surface = isturf(I2.loc) || istype(I2.loc, /obj/machinery/anvil)
		if(!ok_surface)
			to_chat(user, span_warning("Place [I2] down on the ground or an anvil first."))
			return

		var/smeltpath = I2.smeltresult
		if(!ispath(smeltpath))
			to_chat(user, span_warning("[I2] cannot be smelted."))
			return

		var/list/allowed = list(
			/obj/item/ingot/steel,
			/obj/item/ingot/iron,
			/obj/item/ingot/aalloy,
			/obj/item/ingot/purifiedaalloy
		)
		if(!(smeltpath in allowed))
			to_chat(user, span_warning("[I2] is not suitable for this hammer's smelting."))
			return

		var/yield = 1
		if("smeltamount" in I2.vars)
			var/sa = I2.vars["smeltamount"]
			if(isnum(sa) && sa > 0)
				yield = sa
		else if("smelt_yield" in I2.vars)
			var/sy = I2.vars["smelt_yield"]
			if(isnum(sy) && sy > 0)
				yield = sy

		user.visible_message(
			span_info("[user] begins smelting down \the [I2] with [src]."),
			span_info("I start smelting \the [I2]...")
		)
		playsound(get_turf(I2), 'sound/items/bsmith3.ogg', 70, FALSE)

		if(!do_after(user, 10 SECONDS, target = I2))
			to_chat(user, span_warning("The smelting is interrupted!"))
			return

		if(QDELETED(I2) || (!isturf(I2.loc) && !istype(I2.loc, /obj/machinery/anvil)))
			to_chat(user, span_warning("The smelting cannot be completed."))
			return

		var/turf/T = get_turf(I2)
		if(!T)
			to_chat(user, span_warning("There is nowhere for the smelted metal to go."))
			return

		qdel(I2)

		var/obj/item/last_ingot = null
		for(var/i = 1, i <= yield, i++)
			last_ingot = new smeltpath(T)

		if(last_ingot && yield == 1 && hascall(user, "put_in_hands"))
			var/success = call(user, "put_in_hands")(last_ingot)
			if(!success)
				last_ingot.forceMove(T)

		playsound(T, 'sound/items/bsmith2.ogg', 70, FALSE)

		if(last_ingot)
			if(yield == 1)
				to_chat(user, span_notice("I smelt [last_ingot.name]."))
			else
				to_chat(user, span_notice("I smelt [yield] [last_ingot.name]\s."))
		else
			to_chat(user, span_warning("The smelting failed."))
		return

// CRAFT STARTTS HERE //

/obj/item/rogueweapon/hammer/artefact/malum/proc/forge_open_category_menu(mob/user, obj/item/ingot/ing)
	var/list/by_cat = list(
		"Armor"     = list(),
		"Weapons"   = list(),
		"Tools"     = list(),
		"Valuables" = list()
	)

	for(var/datum/anvil_recipe/R in GLOB.anvil_recipes)
		if(!ispath(R.req_bar) || !istype(ing, R.req_bar))
			continue

		if(_malum_recipe_requires_extras(R))
			continue

		if(!ispath(R.created_item))
			continue

		var/name = R.name ? R.name : "[R.created_item]"
		if(istype(R, /datum/anvil_recipe/armor))
			by_cat["Armor"][name] = R.type
		else if(istype(R, /datum/anvil_recipe/weapons))
			by_cat["Weapons"][name] = R.type
		else if(istype(R, /datum/anvil_recipe/tools))
			by_cat["Tools"][name] = R.type
		else if(istype(R, /datum/anvil_recipe/valuables))
			by_cat["Valuables"][name] = R.type

	var/total = 0
	for(var/k in by_cat)
		total += length(by_cat[k])

	if(total <= 0)
		ing.forceMove(get_turf(src))
		to_chat(user, span_warning("No single-bar recipes for [ing.name]."))
		return

	var/contents = "<center><b>Malum's Tool ——— Instant Forge</b><br>Consumed: [ing.name]</center><hr>"

	for(var/section in list("Armor","Weapons","Tools","Valuables"))
		var/list/map = by_cat[section]
		if(!length(map))
			continue

		contents += "<b>[section]</b><br>"

		var/list/names = list()
		for(var/n in map)
			names += n
		names = sortList(names)

		for(var/n in names)
			var/rec_type = map[n]
			var/href_make = "?src=[REF(src)];forgemake=[rec_type];ing=[REF(ing)]"
			contents += "<a href='[href_make]'>[n]</a><br>"

		contents += "<br>"

	var/datum/browser/popup = new(user, "MALUMFORGE", "", 460, 560)
	popup.set_content(contents)
	popup.open()

/obj/item/rogueweapon/hammer/artefact/malum/proc/forge_do_craft(mob/user, obj/item/ingot/ing, rec_type)
	if(!istype(ing) || QDELETED(ing))
		to_chat(user, span_warning("Where did the ingot go?"))
		return
	if(!ispath(rec_type, /datum/anvil_recipe))
		to_chat(user, span_warning("That recipe is broken."))
		return

	var/datum/anvil_recipe/R = new rec_type

	if(!ispath(R.req_bar) || !istype(ing, R.req_bar) || _malum_recipe_requires_extras(R) || !ispath(R.created_item))
		qdel(R)
		to_chat(user, span_warning("This recipe cannot be made from [ing]."))
		return

	user.visible_message(
		span_info("[user] starts shaping \the [ing] with [src]."),
		span_info("I begin crafting with [ing]...")
	)
	playsound(get_turf(ing), 'sound/items/bsmith3.ogg', 70, FALSE)

	if(!do_after(user, 10 SECONDS, target = ing))
		to_chat(user, span_warning("The crafting is interrupted!"))
		qdel(R)
		return
	if(QDELETED(ing) || !ing.loc)
		to_chat(user, span_warning("The ingot is no longer suitable."))
		qdel(R)
		return

	var/turf/T = get_turf(ing)
	qdel(ing)
	var/obj/item/product = new R.created_item(T)

	user.visible_message(
		span_notice("[user] completes the craft, producing \the [product]."),
		span_notice("I finish crafting.")
	)
	playsound(T, 'sound/items/bsmith4.ogg', 70, FALSE)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	qdel(R)

/obj/item/rogueweapon/hammer/artefact/malum/Topic(href, href_list)
	. = ..()
	if(!usr || !usr.canUseTopic(src, BE_CLOSE))
		return


	if(href_list["forgemake"])
		var/obj/item/ingot/ing = locate(href_list["ing"])
		var/rec_type = text2path(href_list["forgemake"])
		if(ing && ispath(rec_type, /datum/anvil_recipe))
			forge_do_craft(usr, ing, rec_type)
		return

/*============
Necra's Censer (by ARefrigerator)
============*/
/*
- Cleans in an area around the person after
  a do_after call, infinite uses. Should aid
  the morticians with cleaning the town.
*/
/obj/item/artefact/necra_censer
	name = "Necra's censer"
	desc = "A small bronze censer that expels an otherworldly mist."
	icon = 'icons/roguetown/items/artefactsten.dmi'
	icon_state = "necraartefact"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	item_state = "necra_censer"
	throw_speed = 3
	throw_range = 7
	throwforce = 4
	//hitsound = 'sound/blank.ogg'
	sellprice = 10 // Shouldn't be worth a lot in world
	dropshrink = 0.6
	grid_width = 32
	grid_height = 64

/obj/item/artefact/necra_censer/attack_self(mob/user)
	if(do_after(user, 3 SECONDS))
		playsound(user.loc,  'sound/items/censer_use.ogg', 100)
		user.visible_message(span_info("[user.name] lifts up their arm and swings the chain on \the [name] around lightly."))
		var/datum/effect_system/smoke_spread/smoke/necra_censer/S = new
		S.set_up(3, user.loc)
		S.start()

/*=========================================
  Dendor’s Endless Hose - additive mode
  Click soil to add ±100 water/nutrition,
  optional bless, and growth modes incl. KILL
=========================================*/

/obj/item/artefact/dendor_hose //bless your tree with its piss
	name = "Dendor's Endless Hose"
	desc = "A living crook of wood that bends soil to the Treefather’s will. Click soil to add ±100 water/nutriment, bless, or affect growth." //Dendor's piss
	icon = 'icons/roguetown/items/artefactsten.dmi'
	icon_state = "dendorartefact"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	grid_width = 32
	grid_height = 64

	//  -1 = -100, 0 = off, 1 = +100
	var/water_step_state = 1
	var/nutri_step_state = 1
	var/next_use_time = 0
	var/use_cooldown = 60*10

	var/auto_bless = TRUE

	// its "none" | "mature" | "produce" | "kill", retard (produce is hidden)
	var/growth_mode = "none"

/obj/item/artefact/dendor_hose/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'><b>Additive settings</b></span><br>"
	. += "Water: <b>[hose_state_text(water_step_state)]</b> per click<br>"
	. += "Nutrition: <b>[hose_state_text(nutri_step_state)]</b> per click<br>"
	. += "Bless: <b>[auto_bless ? "ON" : "OFF"]</b><br>"
	. += "Growth: <b>[uppertext(growth_mode)]</b><br>"
	. += "<span class='info'>Use in hand to configure.</span>"

/obj/item/artefact/dendor_hose/proc/hose_state_text(state)
	if(state == 1)  return "+100"
	if(state == -1) return "-100"
	return "OFF"

/obj/item/artefact/dendor_hose/attack_self(mob/user)
	open_config_ui(user)

/obj/item/artefact/dendor_hose/proc/open_config_ui(mob/user)
	var/contents = "<center><b> — Dendor’s Endless Hose Settings — </b></center><hr>"

	contents += "<b>Water delta per click</b><br>"
	contents += "<a href='?src=[REF(src)];cyclestep=water'>[hose_state_text(water_step_state)]</a><br><br>"

	contents += "<b>Nutrition delta per click</b><br>"
	contents += "<a href='?src=[REF(src)];cyclestep=nutri'>[hose_state_text(nutri_step_state)]</a><br><br>"

	contents += "<b>Bless</b>: <a href='?src=[REF(src)];toggle=bless'>[auto_bless ? "ON" : "OFF"]</a><br><br>"

	contents += "<b>Growth</b><br>"
	contents += "Mode: "
	var/list/modes = list("none","mature","kill") //produce is hidden, sorry my man
	for(var/m in modes)
		if(m == growth_mode)
			contents += " <b>[uppertext(m)]</b> "
		else
			contents += " <a href='?src=[REF(src)];mode=[m]'>[uppertext(m)]</a> "
	contents += "<hr><center><i>Click soil to apply.</i></center>"

	var/datum/browser/popup = new(user, "DENDOR_HOSE", "", 420, 340)
	popup.set_content(contents)
	popup.open()

/obj/item/artefact/dendor_hose/Topic(href, href_list)
	. = ..()
	if(!usr || !usr.canUseTopic(src, BE_CLOSE))
		return

	// im going to keep a comment here because i know some of you stupid retards that going to numberfuck everything +1 -> 0 -> -1 -> +1
	if(href_list["cyclestep"])
		var/what = href_list["cyclestep"]
		if(what == "water")
			if(water_step_state == 1) water_step_state = 0
			else if(water_step_state == 0) water_step_state = -1
			else water_step_state = 1
		else if(what == "nutri")
			if(nutri_step_state == 1) nutri_step_state = 0
			else if(nutri_step_state == 0) nutri_step_state = -1
			else nutri_step_state = 1
		open_config_ui(usr)
		return

	if(href_list["toggle"] == "bless")
		auto_bless = !auto_bless
		open_config_ui(usr)
		return

	if(href_list["mode"])
		var/m = lowertext(href_list["mode"])
		if(m in list("none","mature","produce","kill"))
			growth_mode = m
		open_config_ui(usr)
		return

/obj/item/artefact/dendor_hose/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag || !istype(target, /obj/structure/soil))
		return

	if(world.time < next_use_time)
		var/time_left = max(1, round((next_use_time - world.time) / 10))
		to_chat(user, span_warning("The Endless Hose must rest for [time_left] more seconds."))
		return

	var/obj/structure/soil/S = target
	apply_additives_to_soil(S, user)
	next_use_time = world.time + use_cooldown

/obj/item/artefact/dendor_hose/proc/apply_additives_to_soil(obj/structure/soil/S, mob/user)
	var/w_delta = water_step_state * 100
	if(w_delta)
		S.adjust_water(w_delta)

	var/n_delta = nutri_step_state * 100
	if(n_delta)
		S.adjust_nutrition(n_delta)

	if(auto_bless)
		S.bless_soil()

	if(S.plant)
		switch(growth_mode)
			if("mature")
				if(!S.plant_dead && !S.matured)
					var/miss = max(S.plant.maturation_time - S.growth_time, 0)
					if(miss > 0)
						S.add_growth(miss)
			if("produce") //mayhaps too op will see so its hidden you will be punished for html
				if(!S.plant_dead)
					if(!S.matured)
						var/miss2 = max(S.plant.maturation_time - S.growth_time, 0)
						if(miss2 > 0)
							S.add_growth(miss2)
					if(!S.produce_ready)
						var/miss_prod = max(S.plant.produce_time - S.produce_time, 0)
						if(miss_prod > 0)
							S.add_growth(miss_prod)
			if("kill")
				S.plant_dead = TRUE
				S.plant_health = 0
				S.produce_ready = FALSE
				S.update_icon()
				user.visible_message(
					span_warning("[user] withers the crop with a grim decree."),
					span_warning("The life is snuffed out.")
				)

	if(growth_mode != "kill")
		user.visible_message(
			span_green("[user] tends the soil with the Endless Hose."),
			span_good("The soil yields to my will.")
		)
	playsound(S, 'sound/foley/waterwash (1).ogg', 80, FALSE)

/*==============================
  Noc's Phylactery
  - Binds to a target by sampling blood (30s) but honestly its just scan_process
  - Use in hand: shows target & your XYZ + distance
==============================*/

/obj/item/artefact/noc_phylactery
	name = "Noc's Phylactery"
	desc = "A lunar phylactery of Noc: a crystal vessel that binds a drop of blood to a path under the moon's gaze. In elder nights, mages used such vessels to hunt apostates who abused or stole arcane knowledge."
	icon = 'icons/roguetown/items/artefactsten.dmi'
	icon_state = "nocartefact"
	w_class = WEIGHT_CLASS_TINY
	var/bound = FALSE
	var/target_ref = null
	var/target_name = null
	var/bound_time = 0
	var/binding = FALSE
	var/pending_target_name = null

/obj/item/artefact/noc_phylactery/examine(mob/user)
	. = ..()
	if(bound)
		. += "<hr><span class='notice'>It hums softly - someone's blood is bound within.</span><br>"
		. += "Bound to: <b>[target_name ? target_name : "unknown"]</b><br>"
	else if(binding)
		. += "<hr><span class='warning'>The glass warms in your hand - attunement in progress...</span><br>"
	else
		. += "<hr><span class='info'>Use on a living being to attune by blood (30 seconds).</span><br>"


/obj/item/artefact/noc_phylactery/attack_self(mob/user)
	if(!bound)
		to_chat(user, span_info("The phylactery is inert. Bind it to someone first."))
		return

	var/mob/living/T = get_target_mob()
	var/turf/ut = get_turf(user)
	if(!ut)
		to_chat(user, span_warning("I cannot sense my own footing."))
		return

	var/tx = "?"
	var/ty = "?"
	var/tz = "?"
	var/distance_tiles = -1

	if(T && !QDELETED(T))
		var/turf/tt = get_turf(T)
		if(tt)
			tx = "[tt.x]"
			ty = "[tt.y]"
			tz = "[tt.z]"
			distance_tiles = get_dist(ut, tt)
		else
			to_chat(user, span_warning("The phylactery finds the blood, but not the ground beneath them..."))
	else
		to_chat(user, span_warning("The blood-sample feels dull - perhaps the vessel is gone."))

	to_chat(user, span_notice("— Noc's Phylactery —"))
	to_chat(user, span_info("Target [target_name ? target_name : "unknown"]: X=[tx], Y=[ty], Z=[tz]"))
	to_chat(user, span_info("You: X=[ut.x], Y=[ut.y], Z=[ut.z]"))
	if(distance_tiles >= 0)
		to_chat(user, span_info("Approx. distance: [distance_tiles] tiles"))
	playsound(user, 'sound/magic/churn.ogg', 50, FALSE)

/obj/item/artefact/noc_phylactery/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return
	if(binding)
		to_chat(user, span_warning("It is already drawing a sample..."))
		return
	if(!isliving(target))
		to_chat(user, span_warning("It needs living blood to bind."))
		return

	var/mob/living/L = target
	start_binding(L, user)

/obj/item/artefact/noc_phylactery/proc/start_binding(mob/living/L, mob/user)
	if(binding)
		return
	binding = TRUE

	pending_target_name = get_true_name(L) //John Unknown Unknown

	user.visible_message(
		span_info("[user] presses the phylactery to [pending_target_name]; dim runes kindle along the filigree."),
		span_notice("I begin the attunement, drawing a blood sample from [pending_target_name]...")
	)
	playsound(get_turf(user), 'sound/magic/churn.ogg', 60, FALSE)

	if(!do_after(user, 30 SECONDS, target = L))
		to_chat(user, span_warning("The attunement is interrupted. The glass cools down."))
		binding = FALSE
		pending_target_name = null
		return

	if(QDELETED(src) || QDELETED(L) || QDELETED(user))
		binding = FALSE
		pending_target_name = null
		return
	if(get_dist(user, L) > 1) // yes im aware but no Adjacent()
		to_chat(user, span_warning("The subject slipped away at the final step."))
		binding = FALSE
		pending_target_name = null
		return

	var/success = bind_to_target(L, pending_target_name)
	if(success)
		user.visible_message(
			span_notice("A crimson thread curls into the crystal; the phylactery thrums softly."),
			span_good("It is done. The blood remembers.")
		)
		playsound(get_turf(user), 'sound/magic/whiteflame.ogg', 60, FALSE)
	else
		to_chat(user, span_warning("The charm fizzles and fails to hold."))
	binding = FALSE
	pending_target_name = null

/obj/item/artefact/noc_phylactery/proc/bind_to_target(mob/living/L, cached_name = null)
	target_ref = REF(L)
	target_name = cached_name ? cached_name : get_true_name(L)
	bound_time = world.time
	bound = TRUE
	return TRUE

/obj/item/artefact/noc_phylactery/proc/get_target_mob()
	if(!target_ref)
		return null
	var/mob/living/L = locate(target_ref)
	return L

/obj/item/artefact/noc_phylactery/proc/get_true_name(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		return H.real_name ? H.real_name : (H.name ? H.name : "someone")
	return L.name ? L.name : "someone"

/obj/item/artefact/noc_phylactery/attack(mob/living/M, mob/user)
	if(isliving(M))
		start_binding(M, user)
	return


/*========================================
  Eora's Heart
  -----------------------------------------
  • Use on self: shows your unique partners (names) this week
  • Use on target: shows their unique partners (names) this week
========================================*/

/obj/item/artefact/eora_heart
	name = "Eora's Heart"
	desc = "A velvet heart dedicated to Eora. It remembers the names of bonds formed."
	icon = 'icons/roguetown/items/artefactsten.dmi'
	icon_state = "eoraartefact"
	w_class = WEIGHT_CLASS_TINY

/obj/item/artefact/eora_heart/examine(mob/user)
	. = ..()
	. += "<hr><span class='info'>Use in hand: show your sex partners you had this week.</span><br>"
	. += "<span class='info'>Use on a player: asks their permission, then shows their unique partners this round.</span><br>"

/obj/item/artefact/eora_heart/attack_self(mob/user)
	if(world.time < last_used + 300)
		to_chat(user, span_warning("The heart is quiet. Give it a moment."))
		return

	if(!ishuman(user) || !user.client)
		to_chat(user, span_warning("The heart needs a living player to answer."))
		return

	last_used = world.time

	var/mob/living/carbon/human/H = user
	var/cnt = eora_get_partner_count(H)
	var/list/names = eora_get_partner_names(H)

	to_chat(user, span_notice("Eora's Whisper: You have <b>[cnt]</b> unique partner[cnt == 1 ? "" : "s"] this round."))
	if(names && names.len)
		to_chat(user, "<span class='info'>Names:</span>")
		for(var/N in names)
			to_chat(user, " • [html_encode(N)]")
	else
		to_chat(user, "<span class='info'>No names to show.</span>")

	playsound(user, 'sound/magic/whiteflame.ogg', 50, FALSE)

/obj/item/artefact/eora_heart/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return

	if(!isliving(target))
		to_chat(user, span_warning("The heart only answers for living beings."))
		return

	if(!ishuman(target) || !target:client)
		to_chat(user, span_warning("The heart only tallies beings."))
		return

	var/mob/living/carbon/human/H = target

	if(H == user)
		attack_self(user)
		return

	if(world.time < last_used + 300)
		to_chat(user, span_warning("The heart is quiet. Give it a moment."))
		return

	var/consent = alert(H, "[user.name] wants to use Eora's Heart on you and see your sex partners this week. Allow it?", "Eora's Heart", "Allow", "Deny")
	if(consent != "Allow")
		to_chat(user, span_warning("[H.name] refuses to answer the heart."))
		to_chat(H, span_notice("You refuse Eora's Heart."))
		return

	if(!src || !user || !H)
		return
	if(get_dist(user, H) > 1)
		to_chat(user, span_warning("Too far away."))
		return

	last_used = world.time

	var/cnt = eora_get_partner_count(H)
	var/list/names = eora_get_partner_names(H)

	to_chat(user, span_notice("Eora's Whisper: [html_encode(H.name)] has <b>[cnt]</b> unique partner[cnt == 1 ? "" : "s"] this round."))
	if(names && names.len)
		to_chat(user, "<span class='info'>Names:</span>")
		for(var/N in names)
			to_chat(user, " • [html_encode(N)]")
	else
		to_chat(user, "<span class='info'>No names to show.</span>")

	to_chat(H, span_notice("Eora's Heart answers [user.name]."))

	playsound(user, 'sound/magic/whiteflame.ogg', 50, FALSE)


/proc/eora_get_round_id(mob/living/carbon/human/H)
	if(!H) return null
	if(H.mind) return REF(H.mind)
	return REF(H)

/proc/eora_update_name(mob/living/carbon/human/H)
	if(!H) return
	var/id = eora_get_round_id(H)
	if(!id) return
	var/display = H.real_name ? H.real_name : H.name
	if(display && length(display))
		EORA_ID_NAME[id] = "[display]"

/proc/eora_lookup_name_by_id(id)
	if(!id) return "Unknown"

	if(islist(GLOB?.human_list))
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(eora_get_round_id(H) == id)
				return H.real_name ? H.real_name : H.name
	else
		for(var/mob/living/carbon/human/H in world)
			if(eora_get_round_id(H) == id)
				return H.real_name ? H.real_name : H.name

	if(EORA_ID_NAME[id])
		return "[EORA_ID_NAME[id]]"

	return "Unknown"

/proc/eora_register_consensual_pair(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!A || !B) return
	if(!A.client || !B.client) return
	if(A == B) return

	var/idA = eora_get_round_id(A)
	var/idB = eora_get_round_id(B)
	if(!idA || !idB) return

	if(!EORA_PARTNERS_BY_ID[idA]) EORA_PARTNERS_BY_ID[idA] = list()
	if(!EORA_PARTNERS_BY_ID[idB]) EORA_PARTNERS_BY_ID[idB] = list()

	var/list/LA = EORA_PARTNERS_BY_ID[idA]
	var/list/LB = EORA_PARTNERS_BY_ID[idB]

	LA[idB] = TRUE
	LB[idA] = TRUE

	eora_update_name(A)
	eora_update_name(B)

/proc/eora_get_partner_count(mob/living/carbon/human/H)
	if(!H || !H.client) return 0
	var/id = eora_get_round_id(H)
	if(!id) return 0
	var/list/L = EORA_PARTNERS_BY_ID[id]
	if(!islist(L)) return 0
	var/c = 0
	for(var/_ in L) c++
	return c

/proc/eora_get_partner_names(mob/living/carbon/human/H)
	var/list/names = list()
	if(!H || !H.client) return names
	var/id = eora_get_round_id(H)
	if(!id) return names

	var/list/L = EORA_PARTNERS_BY_ID[id]
	if(!islist(L)) return names

	for(var/pid in L)
		var/n = eora_lookup_name_by_id(pid)
		if(n && !names.Find(n))
			names += n

	return sortList(names)

/*=================================
  PESTRA PERSTRA
======================================*/

#define SURGERY_STAPLE_LIFETIME (60 SECONDS)


// STAPLES

/obj/item/surgery_staple
	name = "surgical staple"
	desc = "A tiny surgical staple holding tissues."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "staples"
	item_flags = ABSTRACT
	sharpness = IS_BLUNT
	anchored = TRUE

	embedding = list(
		"embed_chance" = 100,
		"embedded_fall_chance" = 0,
		"embedded_pain_chance" = 0,
		"embedded_pain_multiplier" = 0,
		"embedded_fall_pain_multiplier" = 0,
		"embedded_impact_pain_multiplier" = 0,
		"embedded_unsafe_removal_pain_multiplier" = 0,
		"embedded_unsafe_removal_time" = 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,
		"embedded_bloodloss" = 0,
		"retract_limbs" = FALSE,
		"clamp_limbs" = FALSE
	)

	var/tmp/_pending_delete = FALSE
	var/tmp/_staple_timer = null


/obj/item/surgery_staple/proc/start_staple_timer()
	if(_staple_timer)
		deltimer(_staple_timer)

	_staple_timer = addtimer(CALLBACK(src, PROC_REF(expire_staple)), SURGERY_STAPLE_LIFETIME, TIMER_STOPPABLE)

	return TRUE


/obj/item/surgery_staple/proc/expire_staple()
	if(_pending_delete)
		return

	if(QDELETED(src))
		return

	_pending_delete = TRUE
	qdel(src)


/obj/item/surgery_staple/Moved(oldloc, dir, forced = FALSE)
	. = ..()

	if(_pending_delete)
		return

	if(isnull(loc))
		return

	if(!istype(loc, /obj/item/bodypart))
		_pending_delete = TRUE
		qdel(src)


/obj/item/surgery_staple/attack_hand(mob/living/user)
	if(!_pending_delete)
		_pending_delete = TRUE
		qdel(src)

	return


/obj/item/surgery_staple/Destroy()
	if(_staple_timer)
		deltimer(_staple_timer)
		_staple_timer = null

	return ..()


/obj/item/surgery_staple/hemostat
	name = "hemostat staple"
	tool_behaviour = TOOL_HEMOSTAT


/obj/item/surgery_staple/retractor
	name = "retractor staple"
	tool_behaviour = TOOL_RETRACTOR



// MULTITOOL

/obj/item/rogueweapon/surgery/multitool
	name = "surgical multitool"
	desc = "A compact, blessed device that unfolds into whatever the surgeon needs."
	icon = 'icons/roguetown/items/artefactsten.dmi'
	icon_state = "scalpelpestra"
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	force = 10
	throwforce = 10
	wdefense = 2
	wbalance = WBALANCE_SWIFT
	max_blade_int = 100
	max_integrity = 200
	thrown_bclass = BCLASS_CUT
	associated_skill = /datum/skill/misc/medicine
	item_flags = SURGICAL_TOOL
	grid_width = 32
	grid_height = 64

	var/current_mode = "scalpel"
	var/tmp/obj/item/needle/pestra/_pestra_needle = null

	var/list/_modes_order = list(
		"scalpel",
		"saw",
		"hemostat",
		"retractor",
		"bonesetter",
		"suture",
		"cautery"
	)

	var/list/_mode_labels = list(
		"scalpel" = "Scalpel",
		"saw" = "Saw",
		"hemostat" = "Hemostat",
		"retractor" = "Retractor",
		"bonesetter" = "Bonesetter",
		"suture" = "Suture",
		"cautery" = "Cautery"
	)

	var/list/_mode_params = list(
		"scalpel" = list(
			"tool_behaviour" = TOOL_SCALPEL,
			"sharpness" = IS_SHARP,
			"damtype" = BRUTE,
			"force" = 12,
			"intents" = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust),
			"icon_state" = "scalpelpestra"
		),
		"saw" = list(
			"tool_behaviour" = TOOL_SAW,
			"sharpness" = IS_SHARP,
			"damtype" = BRUTE,
			"force" = 16,
			"intents" = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver),
			"icon_state" = "sawpestra"
		),
		"hemostat" = list(
			"tool_behaviour" = TOOL_HEMOSTAT,
			"sharpness" = IS_BLUNT,
			"damtype" = BRUTE,
			"force" = 6,
			"intents" = list(/datum/intent/use),
			"icon_state" = "hemostatpestra"
		),
		"retractor" = list(
			"tool_behaviour" = TOOL_RETRACTOR,
			"sharpness" = IS_BLUNT,
			"damtype" = BRUTE,
			"force" = 6,
			"intents" = list(/datum/intent/use),
			"icon_state" = "retractorpestra"
		),
		"bonesetter" = list(
			"tool_behaviour" = TOOL_BONESETTER,
			"sharpness" = IS_BLUNT,
			"damtype" = BRUTE,
			"force" = 8,
			"intents" = list(/datum/intent/use),
			"icon_state" = "bonesetterpestra"
		),
		"suture" = list(
			"tool_behaviour" = TOOL_SUTURE,
			"sharpness" = IS_BLUNT,
			"damtype" = BRUTE,
			"force" = 6,
			"intents" = list(/datum/intent/use),
			"icon_state" = "needlepestra"
		),
		"cautery" = list(
			"tool_behaviour" = TOOL_CAUTERY,
			"sharpness" = IS_BLUNT,
			"damtype" = BURN,
			"force" = 8,
			"intents" = list(/datum/intent/use, /datum/intent/mace/strike, /datum/intent/mace/smash),
			"icon_state" = "cauterypestra"
		)
	)



/proc/_is_use_intent(mob/living/user)
	return istype(user?.a_intent, /datum/intent/use)


/proc/_get_target_bodypart(mob/living/carbon/human/H, mob/living/user)
	if(!H || !user)
		return null

	return H.get_bodypart(check_zone(user.zone_selected))


/obj/item/rogueweapon/surgery/multitool/Initialize()
	. = ..()
	_apply_mode(current_mode, TRUE)


/obj/item/rogueweapon/surgery/multitool/Destroy()
	QDEL_NULL(_pestra_needle)
	return ..()


/obj/item/rogueweapon/surgery/multitool/attack_self(mob/living/user)
	_open_mode_radial(user)
	return TRUE


/obj/item/rogueweapon/surgery/multitool/AltClick(mob/living/user)
	_open_mode_radial(user)
	return TRUE


/obj/item/rogueweapon/surgery/multitool/proc/_get_pestra_needle()
	if(!_pestra_needle || QDELETED(_pestra_needle))
		_pestra_needle = new /obj/item/needle/pestra(src)

	return _pestra_needle

/obj/item/rogueweapon/surgery/multitool/proc/_open_mode_radial(mob/living/user)
	if(!user)
		return FALSE

	if(QDELETED(src) || QDELETED(user))
		return FALSE

	if(!(src in user.contents))
		return FALSE

	var/list/choices = list()
	var/list/mode_by_label = list()

	for(var/mode in _modes_order)
		var/list/P = _mode_params[mode]
		if(!islist(P))
			continue

		var/label = _mode_labels[mode] || mode
		var/image/I = image(icon = icon, icon_state = P["icon_state"])

		choices[label] = I
		mode_by_label[label] = mode

	var/choice = show_radial_menu(
		user,
		src,
		choices,
		custom_check = CALLBACK(src, PROC_REF(_radial_can_use), user),
		radius = 42,
		require_near = TRUE
	)

	if(!choice)
		return FALSE
	var/selected_mode = mode_by_label[choice]
	if(!selected_mode)
		return FALSE
	if(selected_mode == current_mode)
		return TRUE
	_apply_mode(selected_mode)

	to_chat(user, span_notice("Multitool mode: [uppertext(current_mode)]."))
	return TRUE



/obj/item/rogueweapon/surgery/multitool/proc/_radial_can_use(mob/living/user)
	if(!user)
		return FALSE
	if(QDELETED(src) || QDELETED(user))
		return FALSE
	if(!(src in user.contents))
		return FALSE
	return TRUE



/obj/item/rogueweapon/surgery/multitool/proc/_apply_mode(mode as text, silent = FALSE)
	if(!(mode in _modes_order))
		return

	var/list/P = _mode_params[mode]
	if(!islist(P))
		return

	current_mode = mode

	force = P["force"]
	sharpness = P["sharpness"]
	damtype = P["damtype"]
	possible_item_intents = P["intents"]
	icon_state = P["icon_state"]
	tool_behaviour = P["tool_behaviour"]

	update_icon()

	if(!silent)
		playsound(src, 'sound/foley/equip/swordsmall2.ogg', 50, FALSE)



/obj/item/rogueweapon/surgery/multitool/proc/_cycle_mode(mob/user)
	var/i = _modes_order.Find(current_mode) || 0
	i++

	if(i > _modes_order.len)
		i = 1

	_apply_mode(_modes_order[i])

	if(user)
		to_chat(user, span_notice("Multitool mode: [uppertext(current_mode)]."))



/obj/item/rogueweapon/surgery/multitool/get_temperature()
	if(current_mode == "cautery")
		return FIRE_MINIMUM_TEMPERATURE_TO_SPREAD

	return ..()



/obj/item/rogueweapon/surgery/multitool/proc/_is_passive_surgery_mode()
	return current_mode in list("hemostat", "retractor", "bonesetter", "suture")



/obj/item/rogueweapon/surgery/multitool/attack_obj(obj/O, mob/living/user)
	if(current_mode == "suture" && _is_use_intent(user) && isitem(O))
		var/obj/item/needle/pestra/N = _get_pestra_needle()

		if(N)
			N.attack_obj(O, user)

		return TRUE

	return ..()



/obj/item/rogueweapon/surgery/multitool/pre_attack(atom/A, mob/living/user, params)
	if(current_mode == "suture" && _is_use_intent(user) && istype(A, /mob/living))
		var/mob/living/L = A
		var/obj/item/needle/pestra/N = _get_pestra_needle()

		if(N)
			N.sew(L, user)

		return TRUE

	if(ishuman(A) && (current_mode == "hemostat" || current_mode == "retractor"))
		var/mob/living/carbon/human/H = A
		var/obj/item/bodypart/part = _get_target_bodypart(H, user)

		if(!part)
			return TRUE

		if(!(part.get_surgery_flags() & SURGERY_INCISED))
			to_chat(user, span_warning("I need an incision first."))
			return TRUE

		if(_zone_has_same_staple(part))
			to_chat(user, span_info("Staples are already set here."))
			return TRUE

		var/obj/item/surgery_staple/S

		if(current_mode == "hemostat")
			S = new /obj/item/surgery_staple/hemostat(get_turf(H))
		else
			S = new /obj/item/surgery_staple/retractor(get_turf(H))

		if(part.add_embedded_object(S, TRUE))
			S.start_staple_timer()

			if(current_mode == "hemostat")
				user.visible_message(
					span_info("[user] sets hemostat staples in [H]'s [part.name]."),
					span_info("I set hemostat staples in [H]'s [part.name].")
				)
			else
				user.visible_message(
					span_info("[user] sets retractor staples in [H]'s [part.name]."),
					span_info("I set retractor staples in [H]'s [part.name].")
				)
			playsound(H, 'sound/foley/equip/swordsmall2.ogg', 50, FALSE)
		else
			qdel(S)
		return TRUE
	if(!_is_use_intent(user) || !ishuman(A))
		return ..()
	return ..()



/obj/item/rogueweapon/surgery/multitool/proc/_zone_has_same_staple(obj/item/bodypart/part)
	if(!part)
		return FALSE
	for(var/obj/item/embedded as anything in part.embedded_objects)
		if(!istype(embedded, /obj/item/surgery_staple))
			continue
		if(current_mode == "hemostat" && embedded.tool_behaviour == TOOL_HEMOSTAT)
			return TRUE
		if(current_mode == "retractor" && embedded.tool_behaviour == TOOL_RETRACTOR)
			return TRUE
	return FALSE

/*=========================================================
  RAVOX TRACE LENS
=========================================================*/

#define SAY_INFO(msg)  to_chat(user, span_info(msg))
#define SAY_WARN(msg)  to_chat(user, span_warning(msg))

/obj/item/artifact/ravox_lens
	name = "Ravox trace lens"
	desc = "A fearless god's lens that reveals the truth."
	icon = 'icons/roguetown/items/artefactsten.dmi'
	icon_state = "ravoxartefact"
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	var/range = 8
	var/view_check = TRUE

/obj/item/artifact/ravox_lens/Initialize()
	. = ..()

/obj/item/artifact/ravox_lens/afterattack(atom/target, mob/living/user, params)
	. = ..()
	if(!target || !user)
		return FALSE
	if((get_dist(target, user) > range) || (!(target in view(range, user)) && view_check) || (loc != user))
		return FALSE

	playsound(src, 'sound/foley/equip/swordsmall2.ogg', 50, FALSE)
	_ravox_scan_and_report(target, user)
	return TRUE

/proc/_ravox_scan_and_report(atom/target, mob/living/user)
	var/list/species_counts = list()
	var/found = FALSE

	found |= _ravox_collect_from_atom(target, species_counts)

	if(isturf(target))
		for(var/obj/O in target)
			found |= _ravox_collect_from_atom(O, species_counts)

	if(!found || !length(species_counts))
		SAY_WARN("Ravox’s gaze finds no readable traces on [target].")
		return

	var/list/parts = list()
	for(var/race_name in species_counts)
		var/num = max(1, species_counts[race_name])
		parts += (num > 1) ? "[race_name] ([num])" : "[race_name]"
	SAY_INFO("Ravox’s gaze reveals: [english_list(parts)].")

/proc/_ravox_collect_from_atom(atom/A, list/species_counts)
	if(!A) return FALSE
	var/found = FALSE

	var/list/blood = A.return_blood_DNA()
	if(length(blood))
		found |= _ravox_add_from_dna_map(blood, species_counts)

	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(!H.gloves && H?.dna?.uni_identity)
			var/hash = md5(H.dna.uni_identity)
			var/r = _ravox_guess_species_by_hash(hash)
			_ravox_bump_species(species_counts, r); found = TRUE
	else if(!ismob(A))
		var/list/fps = A.return_fingerprints()
		if(length(fps))
			found |= _ravox_add_from_prints(fps, species_counts)

		if(A.reagents && A.reagents.reagent_list.len)
			for(var/datum/reagent/R in A.reagents.reagent_list)
				if(istype(R, /datum/reagent/blood))
					var/bdna = R.data["blood_DNA"]
					if(bdna)
						var/list/tmp = list(); tmp[bdna] = TRUE
						found |= _ravox_add_from_dna_map(tmp, species_counts)

	return found

/proc/_ravox_add_from_dna_map(list/dna_map, list/species_counts)
	if(!islist(dna_map) || !dna_map.len) return FALSE
	var/added = FALSE
	for(var/hash in dna_map)
		var/r = _ravox_guess_species_by_hash("[hash]")
		_ravox_bump_species(species_counts, r); added = TRUE
	return added

/proc/_ravox_add_from_prints(list/prints, list/species_counts)
	if(!islist(prints) || !prints.len) return FALSE
	var/added = FALSE
	for(var/thing in prints)
		var/hash = "[thing]"
		if(!length(hash)) continue
		var/r = _ravox_guess_species_by_hash(hash)
		_ravox_bump_species(species_counts, r); added = TRUE
	return added

/proc/_ravox_bump_species(list/species_counts, race_name)
	if(!race_name || !length(race_name)) race_name = "Unknown"
	species_counts[race_name] = (species_counts[race_name] || 0) + 1


/proc/_ravox_guess_species_by_hash(hash as text)
	if(!length(hash)) return "Unknown"
	for(var/mob/living/carbon/human/H in world)
		if(H?.dna?.uni_identity)
			var/fp = md5(H.dna.uni_identity)
			if(fp == hash)
				return _ravox_species_name(H)
	return "Unknown"


/proc/_ravox_species_name(mob/living/carbon/human/H)
	if(!H) return "Unknown"
	var/name = H.dna?.species?.name
	if(!name) name = H.dna?.species?.id
	if(!name) name = "Humanoid"
	return "[name]"


/************************
/obj/item/artifact/fishingrod/abyssoid
 * Дроп только рыбы + не нужен bait.
 **************************************************/

/obj/item/fishingrod/abyssoid
    name = "Abyssor's rod"
    desc = "A rod blessed by Abyssor. It needs no bait."
    icon = 'icons/roguetown/items/artefactsten.dmi'
    icon_state = "abyssorartefact"

    var/static/list/_abyssor_loot = list(
        /obj/item/reagent_containers/food/snacks/fish/cod       = 230,
        /obj/item/reagent_containers/food/snacks/fish/plaice    = 180,
        /obj/item/reagent_containers/food/snacks/fish/sole      = 250,
        /obj/item/reagent_containers/food/snacks/fish/angler    = 170,
        /obj/item/reagent_containers/food/snacks/fish/lobster   = 180,
        /obj/item/reagent_containers/food/snacks/fish/bass      = 230,
        /obj/item/reagent_containers/food/snacks/fish/clam      = 50,
        /obj/item/reagent_containers/food/snacks/fish/clownfish = 40,
    )

/obj/item/fishingrod/abyssoid/attackby(obj/item/I, mob/user, params)
    to_chat(user, span_notice("This rod needs no bait."))
    return

/obj/item/fishingrod/abyssoid/afterattack(obj/target, mob/user, proximity)
	if(user?.used_intent?.type == SPEAR_BASH)
		return ..()

	if(!check_allowed_items(target, target_self = 1))
		return ..()

	if(!proximity || !(target in range(user, 5)))
		return

	if(user.used_intent.type != ROD_CAST)
		return

	if(user.doing)
		to_chat(user, "<span class='warning'>I must stand still to fish.</span>")
		return

	var/sl = user.get_skill_level(/datum/skill/labor/fishing)
	var/ft = 120
	ft -= (sl * 20)
	ft = max(20, ft)

	user.visible_message("<span class='warning'>[user] casts a line!</span>",
	                     "<span class='notice'>I cast a line.</span>")
	playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)

	if(!do_after(user, ft, target = target))
		to_chat(user, "<span class='warning'>I must stand still to fish.</span>")
		update_icon()
		return

	var/mob/living/fisherman = user
	var/A = pickweight(_abyssor_loot)

	var/ow = 30 + (sl * 10)
	to_chat(user, "<span class='notice'>Something tugs the line!</span>")
	playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)

	do_after(user, ow, target = target)

	if(ismob(A))
		var/mob/M = A
		if(M.type in subtypesof(/mob/living/simple_animal/hostile))
			new M(target)
		else
			new M(user.loc)
		if(user?.mind)
			user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2)
	else
		new A(user.loc)
		to_chat(user, "<span class='notice'>Reel 'em in!</span>")
		if(user?.mind)
			user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE)
		record_featured_stat(FEATURED_STATS_FISHERS, fisherman)

	playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)

	user.changeNext_move(CLICK_CD_INTENTCAP)
	update_icon()
	return

/*******************************************
 * XYLIXSOID STUFF
 ***************************************************/

/datum/element/xylix_theft_mods
	element_flags = ELEMENT_BESPOKE

	var/chance_bonus_pct = 25
	var/range_bonus_tiles = 1

/datum/element/xylix_theft_mods/Attach(datum/target, chance_b = 25, range_b = 1)
	. = ..()

	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE

	chance_bonus_pct = chance_b
	range_bonus_tiles = range_b

	RegisterSignal(target, COMSIG_HUMAN_PRE_STEAL, PROC_REF(_on_mods_query))

/datum/element/xylix_theft_mods/Detach(datum/target)
	UnregisterSignal(target, COMSIG_HUMAN_PRE_STEAL)
	return ..()

/datum/element/xylix_theft_mods/proc/_on_mods_query(datum/source, list/mods)
	SIGNAL_HANDLER

	if(!islist(mods))
		return

	mods["chance_add"] = (mods["chance_add"] || 0) + chance_bonus_pct
	mods["range_add"] = (mods["range_add"] || 0) + range_bonus_tiles


/************************
 * Gloves
 **************************************************/

/obj/item/clothing/gloves/xylix
	name = "Pickpocket gloves"
	desc = "Gloves favored by Xylix's acolytes. Fingers feel lighter, reach seems longer."
	icon = 'icons/roguetown/items/artefactsten.dmi'
	icon_state = "xylixartefact"

	slot_flags = ITEM_SLOT_GLOVES
	w_class = WEIGHT_CLASS_SMALL

	body_parts_covered = HANDS
	body_parts_inherent = HANDS

	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	bloody_icon_state = "bloodyhands"
	sleevetype = "shirt"

	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = 300

	sellprice = 12
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	anvilrepair = null
	sewrepair = TRUE
	salvage_result = /obj/item/natural/fur

	var/mob/living/_buff_owner
	var/chance_bonus_pct = 25
	var/range_bonus_tiles = 1

/obj/item/clothing/gloves/xylix/equipped(mob/living/user, slot)
	. = ..()

	if(!isliving(user))
		return

	if(slot == SLOT_GLOVES)
		_buff_apply(user)
	else if(_buff_owner)
		_buff_remove(_buff_owner)

/obj/item/clothing/gloves/xylix/dropped(mob/user)
	. = ..()

	if(_buff_owner)
		_buff_remove(_buff_owner)

/obj/item/clothing/gloves/xylix/Destroy()
	if(_buff_owner)
		_buff_remove(_buff_owner)

	_buff_owner = null
	return ..()

/obj/item/clothing/gloves/xylix/proc/_buff_apply(mob/living/user)
	if(!isliving(user))
		return

	if(_buff_owner == user)
		return

	if(_buff_owner)
		_buff_remove(_buff_owner)

	_buff_owner = user
	user.AddElement(/datum/element/xylix_theft_mods, chance_bonus_pct, range_bonus_tiles)

/obj/item/clothing/gloves/xylix/proc/_buff_remove(mob/living/user)
	if(!isliving(user))
		return

	user.RemoveElement(/datum/element/xylix_theft_mods, chance_bonus_pct, range_bonus_tiles)

	if(_buff_owner == user)
		_buff_owner = null

// ASS TRATA

/obj/item/artifact/astrata_star
	name = "Star of Astrata"
	desc = "An artifact used to help the lost find the true light."
	icon = 'icons/roguetown/items/artefactsten.dmi'
	icon_state = "astrataartefact"
	force = 0

/obj/item/artifact/astrata_star/attack(mob/living/target, mob/user)
	if(!istype(target, /mob/living/carbon/human))
		return

	if(!user || !user.client)
		return

	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, span_warning("The Star rejects an unworthy bearer."))
		return
	if(!target.client)
		to_chat(user, span_warning("[target.name] cannot accept the rite without a soul to answer (no client)."))
		return

	var/mob/living/carbon/human/C = user

	var/cost = HAS_TRAIT(target, TRAIT_CLERGYRADICAL) ? 1000 : 0

	if(cost > 0 && C.church_favor < cost)
		to_chat(C, span_warning("Your faith lacks the strength. ([cost] Favor required, you have [C.church_favor].)"))
		return

	user.visible_message(
		span_notice("[user] holds the Star of Astrata before [target.name]."),
		span_notice("I hold the Star of Astrata before [target.name], letting its light flood their soul.")
	)

	if(!do_after(user, 300, target = target))
		user.visible_message(
			span_warning("[user] stops the ritual with the Star of Astrata for [target.name]."),
			span_warning("I break the ritual early.")
		)
		to_chat(target, span_notice("The light fades as the ritual is broken."))
		return

	var/list/divine_options = list()
	for(var/path in ALL_DIVINE_PATRONS)
		var/datum/patron/divine/instance = new path
		if(instance && instance.name)
			divine_options[instance.name] = path
		qdel(instance)

	if(!divine_options || !divine_options.len)
		to_chat(user, span_warning("No divine patrons are available."))
		return

	var/choice = input(target, "The star opens your soul. Choose your patron, or refuse.", "The Ten") as null|anything in divine_options
	if(!choice)
		to_chat(target, span_danger("You turn away from the light."))
		to_chat(user, span_danger("[target.name] rejects the offered path."))
		return

	if(cost > 0 && C.church_favor < cost)
		to_chat(C, span_warning("In that moment of revelation, your Favor has run dry. The rite fizzles."))
		to_chat(target, span_warning("The light flickers and dies before the vow can take hold."))
		return

	var/patron_path = divine_options[choice]
	if(patron_path)
		if(hascall(target, "set_patron"))
			call(target, "set_patron")(patron_path)
		else
			to_chat(user, span_warning("This soul cannot be marked (set_patron not found).")) //dont blame me for this whole thing im a retard
			return

		if(cost > 0)
			C.church_favor = max(0, C.church_favor - cost)

		user.visible_message(
			span_notice("[target.name] accepts the mark of [choice]."),
			span_notice("[target.name] accepts the mark of [choice]. The ritual is sealed[cost > 0 ? ", costing you [cost] Favor" : ""].")
		)
		to_chat(target, span_notice("You feel the mark of [choice] settle in your soul."))
