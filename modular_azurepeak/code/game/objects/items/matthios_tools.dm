GLOBAL_LIST_INIT(da_bubbles, list(
	'sound/foley/bubb (1).ogg',
	'sound/foley/bubb (2).ogg',
	'sound/foley/bubb (3).ogg',
	'sound/foley/bubb (4).ogg',
	'sound/foley/bubb (5).ogg',
))

/obj/item
	var/aura_color

/obj/item/Initialize(mapload)
	. = ..()
	if(aura_color)
		apply_aura()

/obj/item/proc/apply_aura()
	if(!aura_color)
		return
	remove_aura()
	add_filter("matthios_aura", 2, list("type" = "outline", "color" = "[aura_color]40", "size" = 2))

/obj/item/proc/remove_aura()
	remove_filter("matthios_aura")

/obj/item/proc/refresh_aura()
	if(aura_color)
		apply_aura()

/obj/item/alchserum
	var/current_color = "#ffffff"

/obj/item/alchserum/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/alchserum/update_icon()
	. = ..()
	cut_overlays()

/proc/funny_smoke(atom/source, radius = 0, sound_vol = 50)
	var/turf/source_turf = get_turf(source)
	if(!source_turf)
		return
	playsound(source_turf, 'sound/items/smokebomb.ogg', sound_vol)
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(radius, source_turf)
	smoke.start()

/obj/item/matthios_canister
	name = "gilded alchemical canister"
	desc = "A strange, fragile alchemical vessel housing a silent power beyond human comprehension."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	w_class = WEIGHT_CLASS_TINY
	var/current_color = "#ffffff"
	var/list/required_ingredients = list()
	var/list/inserted_ingredients = list()
	var/list/ingredient_colors = list()
	var/result_path

/obj/item/matthios_canister/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/matthios_canister/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_COMMIE))
		. += span_notice("[freeman_truth()]")
		. += span_warning("[freeman_progress(user)]")

/obj/item/matthios_canister/proc/freeman_truth()
	return "..."

/obj/item/matthios_canister/proc/freeman_progress(mob/user)
	return "..."

/obj/item/matthios_canister/update_icon()
	. = ..()
	cut_overlays()
	var/mutable_appearance/fluid = mutable_appearance(icon, "canister_fluid")
	fluid.color = current_color
	add_overlay(fluid)

/obj/item/matthios_canister/attackby(obj/item/item, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The principle behind this vial escapes me."))
	return TRUE

/obj/item/matthios_canister/proc/finish_recipe(mob/user, result_type)
	if(!result_type)
		return FALSE
	var/turf/result_turf = get_turf(src)
	if(!result_turf)
		return FALSE
	to_chat(user, span_notice("The mixture stabilizes successfully."))
	new result_type(result_turf)
	funny_smoke(src)
	qdel(src)
	return TRUE

/obj/item/matthios_canister/firstlaw
	name = "vial of firstlaw"
	desc = "The contents weigh upon reality itself, as though value has been forced into too small a space."
	current_color = "#e100ff"
	aura_color = "#ff00b3"
	var/stored_value = 0

/obj/item/matthios_canister/firstlaw/freeman_truth()
	return "All things bend to the First Law. Nothing is created. Nothing is lost. Value merely changes shape."

/obj/item/matthios_canister/firstlaw/freeman_progress(mob/user)
	return "Stored Value: [stored_value]"

/obj/item/matthios_canister/firstlaw/proc/get_value(obj/item/item)
	if(istype(item, /obj/item/roguecoin) || istype(item, /obj/item/rogueore) || istype(item, /obj/item/roguegem) || istype(item, /obj/item/riddleofsteel))
		return item.get_real_price()
	if(istype(item, /obj/item/natural/stone) || istype(item, /obj/item/natural/clay) || istype(item, /obj/item/natural/dirtclod) || istype(item, /obj/item/natural/glass_shard))
		return 1
	if(istype(item, /obj/item/natural/rock))
		return 4
	if(istype(item, /obj/item/scrap) || istype(item, /obj/item/natural/glass))
		return 10
	return 0

/obj/item/matthios_canister/firstlaw/attackby(obj/item/item, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The principle behind this vial escapes me."))
		return TRUE
	var/value = get_value(item)
	if(value <= 0)
		to_chat(user, span_warning("This is worthless."))
		return TRUE
	if(!do_after(user, 0.75 SECONDS, target = user))
		return TRUE
	stored_value += value
	qdel(item)
	to_chat(user, span_notice("The contents compress into entropic dust. (Current value: [stored_value])"))
	playsound(user, 'sound/misc/smelter_sound.ogg', 50, FALSE)
	return TRUE

/obj/item/matthios_canister/firstlaw/afterattack(atom/target, mob/user, proximity_flag, params)
	if(!proximity_flag || !HAS_TRAIT(user, TRAIT_MATTHIOS_EYES) || !isturf(target))
		return
	var/turf/target_turf = target
	var/batch_size = 2 + (user.get_skill_level(/datum/skill/magic/holy) * 2)
	var/processed = 0
	for(var/obj/item/item in target_turf)
		var/value = get_value(item)
		if(value <= 0 || processed >= batch_size)
			continue
		if(!do_after(user, 1 SECONDS, target = user))
			break
		stored_value += value
		qdel(item)
		processed++
	if(processed)
		playsound(user, 'sound/misc/smelter_sound.ogg', 25, FALSE)
		to_chat(user, span_notice("The materials collapse into entropic dust. (Current value: [stored_value])"))

/obj/item/matthios_canister/firstlaw/attack_self(mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES) || stored_value <= 0)
		to_chat(user, span_warning("The vial contains no transactable value."))
		return
	var/choice = input(user, "How shall the First Law resolve?", "First Law") as null|anything in list("Coin begets Coin!", "Return as Stones", "Cancel")
	if(!choice || choice == "Cancel" || !do_after(user, 2 SECONDS, target = user))
		return
	var/turf/result_turf = get_turf(src)
	if(choice == "Return as Stones")
		var/batch_size = 2 + (user.get_skill_level(/datum/skill/magic/holy) * 2)
		while(stored_value > 0)
			if(!do_after(user, 1 SECONDS, target = user))
				break
			var/count = min(batch_size, stored_value)
			for(var/i in 1 to count)
				new /obj/item/natural/stone(result_turf)
			stored_value -= count
			playsound(user, 'sound/misc/smelter_sound.ogg', 20, FALSE)
		to_chat(user, span_notice("The First Law loosens its grip. (Remaining value: [stored_value])"))
	else
		var/efficiency = min(100, 20 + (user.get_skill_level(/datum/skill/magic/holy) * 20))
		var/coin_value = round(stored_value * efficiency / 100)
		var/gold_count = round(coin_value / 10)
		coin_value -= gold_count * 10
		var/silver_count = round(coin_value / 5)
		coin_value -= silver_count * 5
		while(gold_count > 0)
			var/stack_size = min(gold_count, 20)
			var/obj/item/roguecoin/gold/gold_stack = new(result_turf)
			gold_stack.set_quantity(stack_size)
			gold_count -= stack_size
		while(silver_count > 0)
			var/stack_size = min(silver_count, 20)
			var/obj/item/roguecoin/silver/silver_stack = new(result_turf)
			silver_stack.set_quantity(stack_size)
			silver_count -= stack_size
		while(coin_value > 0)
			var/stack_size = min(coin_value, 20)
			var/obj/item/roguecoin/copper/copper_stack = new(result_turf)
			copper_stack.set_quantity(stack_size)
			coin_value -= stack_size
		stored_value = 0
	if(stored_value > 0)
		update_icon()
		return
	funny_smoke(src)
	qdel(src)

/obj/item/matthios_canister/kingsfeast
	name = "vial of kingsfeast base"
	desc = "A foul brew that dissolves organic matter into its nutritional essence."
	aura_color = "#d67a4a"
	var/max_ingredients = 10
	var/ingredient_count = 0

/obj/item/matthios_canister/kingsfeast/freeman_truth()
	return "Organic matter is stripped to its nutritional essence and recomposed as sustenance."

/obj/item/matthios_canister/kingsfeast/freeman_progress(mob/user)
	return "It needs [max(0, max_ingredients - ingredient_count)] more organic offerings."

/obj/item/matthios_canister/kingsfeast/attackby(obj/item/item, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("This is no alchemy!"))
		return TRUE
	if(!(istype(item, /obj/item/reagent_containers/food) || istype(item, /obj/item/natural/bone) || istype(item, /obj/item/natural/fibers) || istype(item, /obj/item/alch/sinew) || istype(item, /obj/item/reagent_containers/powder/salt)))
		return TRUE
	if(ingredient_count >= max_ingredients)
		to_chat(user, span_warning("The canister refuses to take more."))
		return TRUE
	if(!do_after(user, 1.5 SECONDS))
		return TRUE
	ingredient_count++
	qdel(item)
	current_color = "#d67a4a"
	update_icon()
	playsound(user, pick(GLOB.da_bubbles), 30, FALSE)
	check_completion(user)
	return TRUE

/obj/item/matthios_canister/kingsfeast/proc/check_completion(mob/user)
	if(ingredient_count < max_ingredients)
		return
	var/list/food_options = list(
		"Meat Tomatoplate" = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate,
		"Chocolate" = /obj/item/reagent_containers/food/snacks/chocolate,
		"Meat Handpie" = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat,
		"Bread" = /obj/item/reagent_containers/food/snacks/rogue/bread,
	)
	var/food_choice = tgui_input_list(user, "What form shall your offering take?", "Kingsfeast", food_options)
	if(!food_choice)
		return
	var/result_type = food_options[food_choice]
	var/is_hungry = user.nutrition < NUTRITION_LEVEL_HUNGRY
	var/skill_bonus = 10 * user.get_skill_level(/datum/skill/magic/holy)
	if(prob(25) && !is_hungry)
		new /obj/item/reagent_containers/food/snacks/badrecipe(get_turf(src))
	else if(!is_hungry && prob(80 - skill_bonus))
		new /obj/item/reagent_containers/food/snacks/rogue/bread(get_turf(src))
	else
		new result_type(get_turf(src))
	funny_smoke(src)
	qdel(src)

/obj/item/matthios_canister/kingsfeast/attack_self(mob/user)
	if(ingredient_count < max_ingredients)
		to_chat(user, span_warning("The mixture is not ready yet."))
		return
	check_completion(user)

/obj/item/matthios_canister/goodnite
	name = "vial of goodnite base"
	desc = "A dim, cloudy fluid that draws the eyes toward sleep."
	aura_color = "#5e53ff"
	var/max_ingredients = 5
	var/ingredient_count = 0

/obj/item/matthios_canister/goodnite/freeman_truth()
	return "Condensed stellar residue that entrains the body to a universal resting cadence."

/obj/item/matthios_canister/goodnite/freeman_progress(mob/user)
	return "It requires [max(0, max_ingredients - ingredient_count)] more powdered or alchemical offerings."

/obj/item/matthios_canister/goodnite/attackby(obj/item/item, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return TRUE
	if(!(istype(item, /obj/item/alch/bonemeal) || istype(item, /obj/item/alch/mentha) || istype(item, /obj/item/alch/manabloompowder) || istype(item, /obj/item/reagent_containers/powder) || istype(item, /obj/item/natural/bone)))
		return TRUE
	if(ingredient_count >= max_ingredients || !do_after(user, 1.5 SECONDS))
		return TRUE
	ingredient_count++
	qdel(item)
	update_icon()
	playsound(user, pick(GLOB.da_bubbles), 30, FALSE)
	if(ingredient_count >= max_ingredients)
		finish_recipe(user, /obj/item/alchserum/matthios_goodnite)
	return TRUE

/obj/item/alchserum/matthios_goodnite
	name = "vial of goodnite"
	desc = "A soft-glowing concoction that induces restorative sleep."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#5c6fb2"
	aura_color = "#5e53ff"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_goodnite/attack(mob/living/target, mob/user)
	if(HAS_TRAIT(target, TRAIT_NOSLEEP))
		to_chat(user, span_warning("[target] resists the effects entirely."))
		return TRUE
	if(!do_after(user, 6 SECONDS, target))
		return TRUE
	to_chat(target, span_notice("A heavy calm overtakes your body."))
	target.SetSleeping(600)
	target.SetUnconscious(0)
	target.apply_status_effect(/datum/status_effect/buff/matthios_restful_sleep)
	qdel(src)
	return TRUE

/datum/status_effect/buff/matthios_restful_sleep
	id = "matthios_restful_sleep"
	duration = 60 SECONDS
	tick_interval = 5 SECONDS

/datum/status_effect/buff/matthios_restful_sleep/tick()
	. = ..()
	if(!owner.IsSleeping())
		owner.remove_status_effect(src)
		return
	owner.energy_add(50)
	if(owner.nutrition > 0)
		owner.adjustBruteLoss(-2)
		owner.adjustFireLoss(-2)
	if(owner.hydration > 0)
		owner.adjustOxyLoss(-4)
		owner.adjustToxLoss(-2)

/obj/item/matthios_canister/warsmith
	name = "vial of warsmith base"
	desc = "A biting liquor that reduces metal and fiber to their first truths."
	aura_color = "#ffe4b9"
	var/current_scrap = 0
	var/current_fibers = 0
	var/has_needle = FALSE

/obj/item/matthios_canister/warsmith/freeman_truth()
	return "Metal and fiber are undone so they may be rewrought toward their perfect shape."

/obj/item/matthios_canister/warsmith/freeman_progress(mob/user)
	return "Scrap: [current_scrap]/3; fiber: [current_fibers]/6; needle: [has_needle ? "bound" : "needed"]."

/obj/item/matthios_canister/warsmith/attackby(obj/item/item, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return TRUE
	if(istype(item, /obj/item/scrap) || istype(item, /obj/item/rogueore/iron))
		if(current_scrap >= 3 || !do_after(user, 2 SECONDS))
			return TRUE
		current_scrap++
	else if(istype(item, /obj/item/natural/fibers) || istype(item, /obj/item/natural/bundle/fibers))
		if(current_fibers >= 6 || !do_after(user, 2 SECONDS))
			return TRUE
		var/amount = 1
		if(istype(item, /obj/item/natural/bundle/fibers))
			var/obj/item/natural/bundle/fibers/bundle = item
			amount = min(bundle.amount, 6 - current_fibers)
			bundle.amount -= amount
			if(bundle.amount <= 0)
				qdel(bundle)
			else
				bundle.update_icon()
		else
			qdel(item)
		current_fibers += amount
		item = null
	else if(istype(item, /obj/item/needle))
		if(has_needle || !do_after(user, 2 SECONDS))
			return TRUE
		has_needle = TRUE
	else
		to_chat(user, span_warning("This does not belong in the canister."))
		return TRUE
	if(item && !QDELETED(item))
		qdel(item)
	current_color = "#9c7b45"
	update_icon()
	if(current_scrap >= 3 && current_fibers >= 6 && has_needle)
		finish_recipe(user, /obj/item/alchserum/matthios_warsmith)
	return TRUE

/obj/item/alchserum/matthios_warsmith
	name = "vial of warsmith"
	desc = "A volatile fusion of textile and metal-binding alchemy."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#9c7b45"
	aura_color = "#ffe4b9"
	w_class = WEIGHT_CLASS_TINY
	var/uses = 4

/obj/item/alchserum/matthios_warsmith/attack_obj(obj/target, mob/living/user)
	if(!isitem(target))
		return
	var/obj/item/item = target
	if(!item.max_integrity || item.obj_integrity >= item.max_integrity)
		to_chat(user, span_warning("This is not broken."))
		return
	if(!do_after(user, 6 SECONDS, target = item))
		return
	if(item.body_parts_covered != item.body_parts_covered_dynamic)
		item.repair_coverage()
	item.obj_integrity = item.max_integrity
	if(item.obj_broken)
		item.obj_fix()
	uses--
	if(uses <= 0)
		qdel(src)
	return TRUE

/obj/item/matthios_canister/kingswine
	name = "vial of kingswine base"
	desc = "A foul slurry that ferments fruit or blood into a stolen draught."
	aura_color = "#9c3b1f"
	var/current_liquid = 0
	var/needed_liquid = 10
	var/path

/obj/item/matthios_canister/kingswine/freeman_truth()
	if(path == "blood")
		return "The path of Kingsblood is set. The vial craves vital inputs."
	return "A base eager to take on character; it accepts fruit or liquid."

/obj/item/matthios_canister/kingswine/freeman_progress(mob/user)
	return "Progress: [current_liquid]/[needed_liquid]. Path: [path ? uppertext(path) : "UNFORMED"]"

/obj/item/matthios_canister/kingswine/attackby(obj/item/item, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return TRUE
	if(current_liquid >= needed_liquid)
		return TRUE
	if(istype(item, /obj/item/reagent_containers/food/snacks/grown/fruit))
		if(path && path != "wine")
			to_chat(user, span_warning("The mixture has already chosen blood."))
			return TRUE
		if(!do_after(user, 2 SECONDS))
			return TRUE
		path = "wine"
		current_liquid++
		current_color = "#9c3b1f"
		qdel(item)
	else if(istype(item, /obj/item/organ) || istype(item, /obj/item/alch/viscera))
		if(user.get_skill_level(/datum/skill/magic/holy) < SKILL_LEVEL_JOURNEYMAN || (path && path != "blood"))
			to_chat(user, span_warning("I lack the insight to work with this."))
			return TRUE
		if(!do_after(user, 2 SECONDS))
			return TRUE
		path = "blood"
		current_liquid++
		current_color = "#5c0a0a"
		qdel(item)
	else
		return TRUE
	update_icon()
	if(current_liquid >= needed_liquid)
		var/result_type = path == "blood" ? /obj/item/alchserum/matthios_kingsblood : /obj/item/reagent_containers/glass/bottle/rogue/wine
		finish_recipe(user, result_type)
	return TRUE

/obj/item/matthios_canister/kingswine/attack(atom/target, mob/user)
	if(!ishuman(target) || current_liquid >= needed_liquid || !HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return ..()
	if(user.get_skill_level(/datum/skill/magic/holy) < SKILL_LEVEL_JOURNEYMAN || (path && path != "blood"))
		to_chat(user, span_warning("I lack the divine insight to work with blood."))
		return TRUE
	var/mob/living/carbon/human/victim = target
	if(!victim.get_bleed_rate() || !do_after(user, 2 SECONDS, target = victim))
		to_chat(user, span_warning("There is no open wound to draw from."))
		return TRUE
	path = "blood"
	current_liquid++
	current_color = "#5c0a0a"
	victim.blood_volume -= round(BLOOD_VOLUME_NORMAL * 0.05)
	update_icon()
	if(current_liquid >= needed_liquid)
		finish_recipe(user, /obj/item/alchserum/matthios_kingsblood)
	return TRUE

/obj/item/matthios_canister/kingswine/afterattack(atom/target, mob/user, proximity_flag, params)
	if(!proximity_flag || !istype(target, /turf/open/water) || current_liquid >= needed_liquid || !HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return
	var/is_bloodwater = istype(target, /turf/open/water/bloody)
	if(is_bloodwater && user.get_skill_level(/datum/skill/magic/holy) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I lack the divine insight to work with blood."))
		return
	if(path && path != (is_bloodwater ? "blood" : "wine"))
		to_chat(user, span_warning("The mixture rejects this offering."))
		return
	path = is_bloodwater ? "blood" : "wine"
	current_liquid = needed_liquid
	current_color = is_bloodwater ? "#5c0a0a" : "#7a2f1b"
	update_icon()
	finish_recipe(user, is_bloodwater ? /obj/item/alchserum/matthios_kingsblood : /obj/item/reagent_containers/glass/bottle/rogue/wine)

/obj/item/alchserum/matthios_kingsblood
	name = "vial of kingsblood"
	desc = "A dense crimson tincture that forces lost blood back into the body."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff0000"
	aura_color = "#8a0f0f"
	w_class = WEIGHT_CLASS_TINY
	var/uses = 4

/obj/item/alchserum/matthios_kingsblood/attack(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target))
		return ..()
	var/is_vampire = target.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/is_blood_drinker = is_vampire || HAS_TRAIT(target, TRAIT_HEMOPHAGE) || HAS_TRAIT(target, TRAIT_ORGAN_EATER)
	if(target == user && user.zone_selected == BODY_ZONE_PRECISE_MOUTH && is_blood_drinker)
		if(!do_after(user, 2 SECONDS, target = target))
			return TRUE
		if(is_vampire)
			target.adjust_bloodpool(75)
			target.apply_status_effect(/datum/status_effect/buff/vitae)
		for(var/datum/wound/wound as anything in target.get_wounds())
			if(wound && wound.bleed_rate > 0)
				wound.set_bleed_rate(0)
		playsound(user, 'sound/misc/drink_blood.ogg', 100)
	else
		if(!target.get_bleed_rate())
			to_chat(user, span_warning("[target] is not bleeding."))
			return TRUE
		if(!do_after(user, 2 SECONDS, target = target))
			return TRUE
		for(var/datum/wound/wound as anything in target.get_wounds())
			if(wound && wound.bleed_rate > 0)
				wound.set_bleed_rate(0)
		target.blood_volume = min(target.blood_volume + round(BLOOD_VOLUME_NORMAL * 0.2), BLOOD_VOLUME_NORMAL)
	uses--
	if(uses <= 0)
		qdel(src)
	return TRUE

/obj/item/matthios_canister/lyfestruth
	name = "vial of lyfestruth base"
	desc = "A searing draught that churns like molten gold."
	aura_color = "#fffaad"
	var/route
	var/list/required_herbs = list(
		/obj/item/alch/atropa,
		/obj/item/alch/matricaria,
		/obj/item/alch/symphitum,
		/obj/item/alch/taraxacum,
		/obj/item/alch/euphrasia,
		/obj/item/alch/paris,
		/obj/item/alch/calendula,
		/obj/item/alch/mentha,
		/obj/item/alch/urtica,
		/obj/item/alch/salvia,
		/obj/item/alch/hypericum,
		/obj/item/alch/benedictus,
		/obj/item/alch/valeriana,
		/obj/item/alch/artemisia,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/alch/rosa,
	)
	var/coin_value = 0
	var/lux_count = 0
	var/impure_lux_count = 0
	var/lux_blood = 0
	var/blood_uses = 0

/obj/item/matthios_canister/lyfestruth/Initialize(mapload)
	. = ..()
	required_herbs = required_herbs.Copy()

/obj/item/matthios_canister/lyfestruth/freeman_truth()
	return "The draught can be completed through herbs, mammon, or Lux, but its first offering fixes the path."

/obj/item/matthios_canister/lyfestruth/freeman_progress(mob/user)
	if(route == "coin")
		return "Mammon bound: [coin_value]/500."
	if(route == "lux")
		return "Lux: [lux_count]/1 purified; impure Lux: [impure_lux_count]/2; heartblood: [lux_blood]/5."
	return "Herbs remaining: [required_herbs.len]. Blood can replace up to [5 - blood_uses] missing herbs."

/obj/item/matthios_canister/lyfestruth/proc/set_route(new_route, mob/user)
	if(route && route != new_route)
		to_chat(user, span_warning("The brew resists. Its path is already set."))
		return FALSE
	route = new_route
	return TRUE

/obj/item/matthios_canister/lyfestruth/proc/check_completion(mob/user)
	if((route == "herb" && !required_herbs.len) || (route == "coin" && coin_value >= 500) || (route == "lux" && (lux_count >= 1 || (impure_lux_count >= 2 && lux_blood >= 5))))
		if(route == "lux" && lux_count >= 1 && impure_lux_count)
			new /obj/item/reagent_containers/lux_impure(get_turf(src))
		finish_recipe(user, /obj/item/alchserum/matthios_lyfestruth)

/obj/item/matthios_canister/lyfestruth/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/alch) || istype(item, /obj/item/reagent_containers/food/snacks/grown/manabloom))
		if(!required_herbs.Find(item.type) || !set_route("herb", user) || !do_after(user, 1 SECONDS))
			return TRUE
		required_herbs -= item.type
		qdel(item)
	else if(istype(item, /obj/item/roguecoin))
		if(!set_route("coin", user) || !do_after(user, 1 SECONDS))
			return TRUE
		var/obj/item/roguecoin/coin = item
		var/value = coin.get_real_price()
		if(value <= 0)
			return TRUE
		coin_value += value
		qdel(coin)
	else if(istype(item, /obj/item/reagent_containers/lux))
		if(!set_route("lux", user) || !do_after(user, 1 SECONDS))
			return TRUE
		lux_count++
		qdel(item)
	else if(istype(item, /obj/item/reagent_containers/lux_impure))
		if(!set_route("lux", user) || !do_after(user, 1 SECONDS))
			return TRUE
		impure_lux_count++
		qdel(item)
	else
		return TRUE
	check_completion(user)
	return TRUE

/obj/item/matthios_canister/lyfestruth/afterattack(atom/target, mob/user, proximity_flag, params)
	if(!proximity_flag || !ishuman(target) || (route && route != "herb" && route != "lux"))
		return
	var/mob/living/carbon/human/victim = target
	if(!victim.get_bleed_rate() || !do_after(user, 2 SECONDS, target = victim))
		return
	if(!route)
		route = "herb"
	if(route == "herb")
		if(blood_uses >= 5)
			return
		blood_uses++
		if(required_herbs.len)
			required_herbs -= pick(required_herbs)
	else if(route == "lux" && impure_lux_count)
		if(lux_blood >= 5)
			return
		lux_blood++
	else
		return
	victim.blood_volume -= round(BLOOD_VOLUME_NORMAL * 0.05)
	check_completion(user)

/obj/item/alchserum/matthios_lyfestruth
	name = "vial of lyfestruth"
	desc = "A volatile orange-gold fluid that burns with molten intensity."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff9d00"
	aura_color = "#fffaad"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_lyfestruth/attack(mob/living/target, mob/user)
	if(target.stat != DEAD || !target.mind || !target.mind.active || HAS_TRAIT(target, TRAIT_DNR))
		to_chat(user, span_warning("The draught refuses to take hold."))
		return TRUE
	if(!do_after(user, 6 SECONDS, target))
		return TRUE
	var/accepted = target.client ? alert(target, "You feel divine warmth offering freedom from Necra's shackles.", "Revival", "Wake me!", "Let me rest.") : null
	if(accepted == "Wake me!")
		target.revive(full_heal = TRUE)
		target.adjust_fire_stacks(5)
		target.ignite_mob()
		target.emote("superagony", forced = TRUE)
	else
		to_chat(target, span_warning("You refuse the call, and the warmth curdles into something volatile."))
	var/turf/target_turf = get_turf(target)
	if(target_turf)
		explosion(target_turf, light_impact_range = 4, flame_range = 8, smoke = TRUE)
	qdel(src)
	return TRUE

/obj/item/impact_grenade/pocketsand
	name = "pocket sand"
	desc = "A fistful of fine, irritating sand."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "clod1"

/obj/item/impact_grenade/pocketsand/explodes()
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/explosion_turf = get_turf(src)
	if(explosion_turf)
		for(var/mob/living/target in explosion_turf)
			if(!target.mind || istype(target, /mob/living/simple_animal))
				target.adjustBruteLoss(5)
			if(iscarbon(target))
				target.blur_eyes(5)
				target.adjust_blurriness(10)
				target.blind_eyes(1.5)
			target.visible_message(span_warning("[target] is blasted with a cloud of sand!"), span_warning("Sand gets in my eyes!"))
			target.emote("pain")
			target.apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)
		qdel(src)

/datum/component/storage/concrete/roguetown/pouch/matthios
	screen_max_rows = 4
	screen_max_columns = 2

/obj/item/storage/belt/rogue/pouch/matthios
	desc = "A small gilded sack, blessed to protect its owner's goods."
	aura_color = "#fff385"
	component_type = /datum/component/storage/concrete/roguetown/pouch/matthios

/obj/item/storage/belt/rogue/pouch/matthios/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "BLESSED POUCH")

/obj/item/storage/backpack/rogue/backpack/matthios
	name = "smuggling bag"
	desc = "A gilded sack tied with blessed rope."
	aura_color = "#fff385"
	icon_state = "rucksack_untied"
	item_state = "rucksack"
	component_type = /datum/component/storage/concrete/roguetown/backpack
	max_integrity = 100

/obj/item/storage/backpack/rogue/backpack/matthios/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "BLESSED RUCKSACK")

/obj/item/melee/touch_attack/lesserknock/matthios
	name = "gilded lockpick"
	desc = "A golden lockpick held together by the truth of Matthios."
	catchphrase = null
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"
	color = "#eeff00"
	max_integrity = 20
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF
	aura_color = "#ffe761"

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios
	name = "gilded fingerless gloves"
	desc = "Gilded gloves that help their wearer work unseen."
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fce517"
	aura_color = "#fff385"

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES && HAS_TRAIT(user, TRAIT_COMMIE))
		ADD_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthios_tools")

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthios_tools")

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios
	name = "gilded leather boots"
	desc = "Gilded boots that muffle their wearer's steps."
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fff9c0"
	aura_color = "#ffe600"

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_SHOES && HAS_TRAIT(user, TRAIT_COMMIE))
		ADD_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthios_tools")
		ADD_TRAIT(user, TRAIT_LIGHT_STEP, "matthios_tools")

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(user.shoes != src)
		REMOVE_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthios_tools")
		REMOVE_TRAIT(user, TRAIT_LIGHT_STEP, "matthios_tools")

/obj/item/clothing/mask/rogue/spectacles/matthios
	name = "gilded spectacles"
	desc = "Gilded lenses that reveal the hidden workings of a lock."
	color = "#faf5cb"
	aura_color = "#fffb00"

/obj/item/clothing/mask/rogue/spectacles/matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if((slot == SLOT_WEAR_MASK || slot == SLOT_HEAD) && HAS_TRAIT(user, TRAIT_COMMIE))
		user.apply_status_effect(/datum/status_effect/buff/matthios_vision)

/obj/item/clothing/mask/rogue/spectacles/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	user.remove_status_effect(/datum/status_effect/buff/matthios_vision)

/atom/movable/screen/alert/status_effect/buff/matthios_vision
	name = "Gilded True Sight"
	desc = "Through Matthios, all is seen."
	icon_state = "darkvision"
	color = "#ffe600"

/datum/status_effect/buff/matthios_vision
	id = "matthios_vision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/matthios_vision
	duration = -1
	tick_interval = 20 SECONDS

/datum/status_effect/buff/matthios_vision/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_GILDED_SIGHT, "matthios_vision")
	ADD_TRAIT(owner, TRAIT_NIGHT_VISION, "matthios_vision")
	ADD_TRAIT(owner, TRAIT_PSYCHOSIS, "matthios_vision")
	owner.update_sight()

/datum/status_effect/buff/matthios_vision/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_GILDED_SIGHT, "matthios_vision")
	REMOVE_TRAIT(owner, TRAIT_NIGHT_VISION, "matthios_vision")
	REMOVE_TRAIT(owner, TRAIT_PSYCHOSIS, "matthios_vision")
	owner.update_sight()

/datum/status_effect/buff/matthios_vision/tick()
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!user)
		return
	var/weighted_skill = (user.get_skill_level(/datum/skill/magic/holy) * 0.8) + (user.get_skill_level(/datum/skill/misc/lockpicking) * 0.2)
	var/hallucination_chance = clamp(100 - (weighted_skill * (100 / 6)), 0, 100)
	if(prob(hallucination_chance) && user.hallucination < 400)
		user.hallucination = min(400, user.hallucination + rand(5, 15))

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded
	name = "ornate amulet of Matthios"
	desc = "A gilded amulet bearing the sigil of the Free God."
	icon_state = "matthios"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK | ITEM_SLOT_RING
	aura_color = "#ffe761"
	var/active_item = FALSE
	var/grant_chant = FALSE
	var/swap_type = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/attack_self(mob/living/carbon/human/user)
	if(!HAS_TRAIT(user, TRAIT_COMMIE) || !do_after(user, 1 SECONDS))
		return
	var/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/replacement = new swap_type(get_turf(user))
	if(user.is_holding(src))
		user.temporarilyRemoveItemFromInventory(src)
		user.put_in_hands(replacement)
	qdel(src)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata
	name = "ornate amulet of Astrata"
	desc = "A stolen fragment of Astrata's fyre, turned toward Matthios."
	icon_state = "astrata_g"
	aura_color = null
	swap_type = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(active_item || obj_broken || !(slot == SLOT_NECK || slot == SLOT_RING) || !user.patron || !(user.patron.type in ALL_INHUMEN_PATRONS))
		return
	active_item = TRUE
	if(!istype(src, /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata) && HAS_TRAIT(user, TRAIT_COMMIE))
		user.change_stat(STATKEY_LCK, 1, "matthios_boldness")
	if(!user.has_language(/datum/language/thievescant))
		user.grant_language(/datum/language/thievescant)
		grant_chant = TRUE

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/dropped(mob/living/carbon/human/user)
	. = ..()
	if(active_item)
		active_item = FALSE
		if(!istype(src, /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata) && HAS_TRAIT(user, TRAIT_COMMIE))
			user.change_stat(STATKEY_LCK, 0, "matthios_boldness")
		if(grant_chant)
			user.remove_language(/datum/language/thievescant)
			grant_chant = FALSE

/obj/item/rope/chain/matthios
	name = "gilded chain"
	desc = "A heavy, gilded chain that thrums with latent divine power."
	color = "#fdff86"
	aura_color = "#fff385"
	smeltresult = /obj/item/ash

/obj/effect/proc_holder/spell/self/freemans_tools
	name = "Freeman's Tools"
	desc = "Pray to Matthios for a tool of liberation, a gilded implement, or a base of Malchem."
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "lockpick"
	human_req = TRUE
	clothes_req = FALSE
	associated_skill = /datum/skill/magic/holy
	invocation_type = "none"
	antimagic_allowed = FALSE
	releasedrain = 5
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 0
	var/list/options = list(
		"Pocket Sand" = list("path" = /obj/item/impact_grenade/pocketsand, "cooldown" = 60 SECONDS, "devotion" = 10, "rank" = SKILL_LEVEL_NOVICE, "category" = "Rogue Arts", "lines" = list("Dust to blind thee!", "A handful of freedom!", "Mind yer eyes!")),
		"Gilded Lockpick" = list("path" = /obj/item/melee/touch_attack/lesserknock/matthios, "cooldown" = 5 SECONDS, "devotion" = 10, "rank" = SKILL_LEVEL_NOVICE, "category" = "Gilded Tools", "lines" = list("#By thine hands...", "#No locks shall bar the free!")),
		"Pouch of Smuggling" = list("path" = /obj/item/storage/belt/rogue/pouch/matthios, "cooldown" = 10 MINUTES, "devotion" = 100, "rank" = SKILL_LEVEL_NOVICE, "category" = "Rogue Arts", "lines" = list("#Matthios, protect my goods!")),
		"Bag of Smuggling" = list("path" = /obj/item/storage/backpack/rogue/backpack/matthios, "cooldown" = -1, "devotion" = 200, "rank" = SKILL_LEVEL_APPRENTICE, "category" = "Rogue Arts", "lines" = list("#Matthios, ordain me your blessed storage!")),
		"Gilded Dexterous Gloves" = list("path" = /obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios, "cooldown" = 5 MINUTES, "devotion" = 100, "rank" = SKILL_LEVEL_JOURNEYMAN, "category" = "Gilded Tools", "lines" = list("#Hands of trade, be silent.")),
		"Gilded Muffled Boots" = list("path" = /obj/item/clothing/shoes/roguetown/boots/muffle_matthios, "cooldown" = 5 MINUTES, "devotion" = 100, "rank" = SKILL_LEVEL_APPRENTICE, "category" = "Gilded Tools", "lines" = list("#Steps unheard, as I walk in thy shadow.")),
		"Gilded Lockpicking Specs" = list("path" = /obj/item/clothing/mask/rogue/spectacles/matthios, "cooldown" = -1, "devotion" = 200, "rank" = SKILL_LEVEL_EXPERT, "category" = "Gilded Tools", "lines" = list("#Guide my sight, O Matthios.")),
		"Gilded Chains" = list("path" = /obj/item/rope/chain/matthios, "cooldown" = 10 MINUTES, "devotion" = 200, "rank" = SKILL_LEVEL_JOURNEYMAN, "category" = "Gilded Tools", "lines" = list("Matthios! Chains for the tyrants!")),
		"Gilded Amulet of Matthios" = list("path" = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded, "cooldown" = 1 MINUTES, "devotion" = 50, "rank" = SKILL_LEVEL_NONE, "category" = "Gilded Tools", "lines" = list("#Matthios, let thine will be done.")),
		"Vial of Firstlaw" = list("path" = /obj/item/matthios_canister/firstlaw, "cooldown" = 1 MINUTES, "devotion" = 75, "rank" = SKILL_LEVEL_NOVICE, "category" = "Malchem Vials", "lines" = list("#Matthios, provide the base!")),
		"Vial of Kingsfeast Base" = list("path" = /obj/item/matthios_canister/kingsfeast, "cooldown" = 2 MINUTES, "devotion" = 25, "rank" = SKILL_LEVEL_NOVICE, "category" = "Malchem Vials", "lines" = list("#Matthios, provide the base!")),
		"Vial of Kingswine Base" = list("path" = /obj/item/matthios_canister/kingswine, "cooldown" = 2 MINUTES, "devotion" = 25, "rank" = SKILL_LEVEL_NOVICE, "category" = "Malchem Vials", "lines" = list("#Matthios, provide the base!")),
		"Vial of Goodnite Base" = list("path" = /obj/item/matthios_canister/goodnite, "cooldown" = 2 MINUTES, "devotion" = 50, "rank" = SKILL_LEVEL_APPRENTICE, "category" = "Malchem Vials", "lines" = list("#Matthios, provide the base!")),
		"Vial of Warsmith Base" = list("path" = /obj/item/matthios_canister/warsmith, "cooldown" = 2 MINUTES, "devotion" = 50, "rank" = SKILL_LEVEL_JOURNEYMAN, "category" = "Malchem Vials", "lines" = list("#Matthios, provide the base!")),
		"Vial of Lyfestruth Base" = list("path" = /obj/item/matthios_canister/lyfestruth, "cooldown" = 30 MINUTES, "devotion" = 100, "rank" = SKILL_LEVEL_EXPERT, "category" = "Malchem Vials", "lines" = list("#Matthios, provide the base!")),
	)
	var/list/item_cooldowns = list()

/obj/effect/proc_holder/spell/self/freemans_tools/cast(mob/living/carbon/human/user = usr)
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/human = user
	var/skill = human.get_skill_level(associated_skill)
	var/list/categories = list("Rogue Arts", "Gilded Tools", "Malchem Vials")
	var/category = tgui_input_list(human, "Choose your path", name, categories)
	if(!category)
		return FALSE

	var/list/available = list()
	for(var/option_name in options)
		var/list/entry = options[option_name]
		if(skill < entry["rank"] || entry["category"] != category)
			continue
		var/cooldown_end = item_cooldowns[option_name]
		var/devotion = entry["devotion"]
		var/display_name = option_name
		if(cooldown_end == -1)
			display_name += " (UNAVAILABLE)"
		else if(cooldown_end && world.time < cooldown_end)
			display_name += " ([round((cooldown_end - world.time) / 10, 1)]s | [devotion] Devotion)"
		else
			display_name += " ([devotion] Devotion)"
		available[display_name] = option_name
	if(!available.len)
		to_chat(human, span_warning("Nothing is available in this category."))
		return FALSE

	var/selected_display = tgui_input_list(human, "Choose your tool", name, available)
	if(!selected_display)
		return FALSE
	var/selected = available[selected_display]
	var/list/entry = options[selected]
	var/cooldown = item_cooldowns[selected]
	if(cooldown == -1 || (cooldown && world.time < cooldown))
		to_chat(human, span_warning("[selected] is not ready to be called again."))
		return FALSE

	var/cost = entry["devotion"]
	if(cost)
		if(!human.devotion)
			to_chat(human, span_warning("Your connection to Matthios is too faint to grant this tool."))
			return FALSE
		devotion_cost = cost
		var/can_pay = human.devotion.check_devotion(src)
		devotion_cost = 0
		if(!can_pay)
			to_chat(human, span_warning("Your connection to Matthios is too faint to grant this tool."))
			return FALSE
	var/item_path = entry["path"]
	var/obj/item/item = new item_path(human.drop_location())
	if(!item)
		return FALSE
	human.put_in_hands(item)
	var/list/lines = entry["lines"]
	human.say(pick(lines), language = /datum/language/common)
	if(cost)
		human.devotion.update_devotion(-cost)
	var/cooldown_duration = entry["cooldown"]
	item_cooldowns[selected] = cooldown_duration == -1 ? -1 : world.time + cooldown_duration
	return TRUE
