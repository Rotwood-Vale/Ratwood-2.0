#define QDEL_LIST_CONTENTS(L) if(L) { for(var/I in L) qdel(I); L.Cut(); }
/obj/effect/decal/cleanable/roguerune	// basis for all rituals
	name = "仪式符文"
	desc = "奇异的符号在地面上脉动闪烁……"
	anchored = TRUE
	icon = 'icons/obj/rune.dmi'
	icon_state = "6"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER
	color = null
	var/magictype = "arcyne"//"arcyne", "divine", "druid", "blood"
	var/runesize = 0	//Used to determine range of 'range' of the rune when counting for invokers. Should correspond to rune size. EX: 32x32 and 96x96 should be size 1. Increase each size by one for every tile radius increase after.
	var/invoker_name = "basic rune"

	/// The description of the ritual rune shown to those who have knowledge to examine it
	var/invoker_desc = "a basic rune with no function."

	/// This is said by those when the rune is invoked.
	var/invocation = "Aiy ele-mayo!"
	/// The amount of invokers required around the rune to invoke it.
	var/req_invokers = 1

	/// If we have a description override for required invokers to invoke
	var/req_invokers_text
	/// Used for some runes, this is for when you want a rune to not be usable when in use.
	var/rune_in_use = FALSE

	/// Used when you want to keep track of who erased the rune
	var/log_when_erased = FALSE
	/// If has more then one ritual associated, TRUE. Else, FALSE
	var/ritual_number = FALSE
	/// Whether this rune can be scribed or if it's admin only / special spawned / whatever
	var/can_be_scribed = TRUE
	/// How long the rune takes to erase
	var/erase_time = 1.5 SECONDS
	/// How long the rune takes to create
	var/scribe_delay = 4 SECONDS
	/// If a rune cannot be speed boosted while scribing on certain turfs
	var/no_scribe_boost = FALSE
	/// If a rune provides a bonus to a spell, or spellbook reading.
	var/spellbonus = 0
	/// Hhow much damage you take doing it
	var/scribe_damage = 0.1
	/// How much damage invokers take when invoking it
	var/invoke_damage = 0
	/// If the rune requires a keyword when scribed
	var/req_keyword = FALSE
	/// The actual keyword for the rune
	var/keyword
	/// Global proc to call while the rune is being created
	var/started_creating
	/// Global proc to call if the rune fails to be created
	var/failed_to_create
	var/active = FALSE
	/// Tier var is used for 'tier' of rune, if the rune has tiers. EX: Summoning runes. If it doesn't have tiers, set tier to 0.
	var/tier = 1
	/// ritual result is the result of a ritual!
	var/ritual_result
	//atoms in ranges
	var/list/atom/movable/atoms_in_range	//list for atoms in range of rune
	var/datum/runeritual/pickritual		//selected
	var/list/selected_atoms
	var/associated_ritual = null	//Associated ritual for runes with only 1 ritual. Use in tandom with ritual_number

/proc/isarcyne(mob/living/carbon/human/A)
	return istype(A) && A.mind && (A.get_skill_level(/datum/skill/magic/arcane) > SKILL_LEVEL_NONE)	//checks if person has arcane skill

/proc/isdivine(mob/living/carbon/human/A)
	return istype(A) && A.mind && (A.get_skill_level(/datum/skill/magic/holy) > SKILL_LEVEL_NONE)	//checks if person has holy/divine skill

/proc/isdruid(mob/living/carbon/human/A)
	return istype(A) && A.mind && (A.get_skill_level(/datum/skill/magic/druidic) > SKILL_LEVEL_NONE)	//checks if person has druidic skill

/proc/isblood(mob/living/carbon/human/A)
	return istype(A) && A.mind && (A.get_skill_level(/datum/skill/magic/blood) > SKILL_LEVEL_NONE)		//checks if person has blood magic skill

GLOBAL_LIST_INIT(rune_types, generate_rune_types())
GLOBAL_LIST_INIT(t1rune_types, generate_t1rune_types())
GLOBAL_LIST_INIT(t2rune_types, generate_t2rune_types())
GLOBAL_LIST_INIT(t3rune_types, generate_t3rune_types())
GLOBAL_LIST_INIT(t4rune_types, generate_t4rune_types())

/// List of all teleport runes
GLOBAL_LIST(teleport_runes)

/// Returns an associated list of rune types. [rune.cultist_name] = [typepath]
/proc/generate_rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes

/proc/generate_t1rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(rune.tier > 1)
			continue
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes
/proc/generate_t2rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(rune.tier > 2)
			continue
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes
/proc/generate_t3rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(rune.tier > 3)
			continue
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes

/proc/generate_t4rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes


/obj/effect/decal/cleanable/roguerune/Initialize(mapload, set_keyword)
	. = ..()
	if(set_keyword)
		keyword = set_keyword

/obj/effect/decal/cleanable/roguerune/proc/do_invoke_glow()
	set waitfor = FALSE
	animate(src, transform = matrix()*2, alpha = 0, time = 5, flags = ANIMATION_END_NOW) //fade out
	sleep(0.5 SECONDS)
	animate(src, transform = matrix(), alpha = 255, time = 0, flags = ANIMATION_END_NOW)

/obj/effect/decal/cleanable/roguerune/proc/fail_invoke()
	//This proc contains the effects of a rune if it is not invoked correctly, through either invalid wording or not enough cultists. By default, it's just a basic fizzle.
	visible_message(span_warning("这些印记闪过一丝微光，然后又归于黯淡。"))
	var/oldcolor = color
	color = rgb(255, 0, 0)
	animate(src, color = oldcolor, time = 5)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)

/obj/effect/decal/cleanable/roguerune/attack_hand(mob/living/user)
	if(rune_in_use)
		to_chat(user, span_notice("已经有人在使用这枚符文了。"))
		return
	if(.)
		return
	if(!ritual_number )					//Only one option of ritual for this rune
		var/list/invokers = can_invoke(user)
		if(length(invokers) >= req_invokers)		//Enough invokers? If Yes, invoke
			invoke(invokers)
		else
			to_chat(user, span_danger("你还需要 [req_invokers - length(invokers)] 名相邻的施术者，才能以这种方式使用这枚符文。"))	//Needs more invokers, fails invoke
			fail_invoke()
	else
		var/list/invokers = can_invoke(user)
		if(length(invokers) >= req_invokers)
			var/list/rituals = list()
			if(istype(src,/obj/effect/decal/cleanable/roguerune/arcyne/summoning))
				var/tier = src.tier
				if(tier >= 4)
					rituals += GLOB.t4summoningrunerituallist
				else if(tier == 3)
					rituals += GLOB.t3summoningrunerituallist
				else if(tier == 2)
					rituals += GLOB.t2summoningrunerituallist
				else if(tier == 1)
					rituals += GLOB.t1summoningrunerituallist
			else if(istype(src,/obj/effect/decal/cleanable/roguerune/arcyne/wall))
				var/tier = src.tier
				if(tier >= 3)
					rituals += GLOB.t4wallrunerituallist
				else
					rituals += GLOB.t2wallrunerituallist
			else if(istype(src,/obj/effect/decal/cleanable/roguerune/arcyne/empowerment))
				var/tier = src.tier
				if(tier == 1)
					rituals += GLOB.buffrunerituallist
				else
					rituals+= GLOB.t2buffrunerituallist
			else if(istype(src,/obj/effect/decal/cleanable/roguerune/arcyne/enchantment))
				if(tier >= 3)
					rituals += GLOB.t4enchantmentrunerituallist
				else
					rituals += GLOB.t2enchantmentrunerituallist
			else if(istype(src,/obj/effect/decal/cleanable/roguerune/arcyne))
				rituals += GLOB.allowedrunerituallist
			var/ritualnameinput = input(user, "仪式", "") as null|anything in rituals
			var/datum/runeritual/pickritual1
			pickritual1 = rituals[ritualnameinput]
			if(!pickritual1 || pickritual1 == null)
				rune_in_use = FALSE
				return
			if(pickritual1.tier > src.tier)
				to_chat(user, span_hierophant_warning("你的仪式符文还不够强，无法施展这个仪式。"))
				rune_in_use = FALSE
				return
			invoke(invokers, pickritual1)
		else
			to_chat(user, span_danger("你还需要 [req_invokers - length(invokers)] 名相邻的施术者，才能以这种方式使用这枚符文。"))	//Needs more invokers, fails invoke
			rune_in_use = FALSE
			fail_invoke()
	. = ..()


/obj/effect/decal/cleanable/roguerune/proc/can_invoke(mob/living/user=null)
	rune_in_use = TRUE
	//This proc determines if the rune can be invoked at the time. If there are multiple required invokers, it will find all nearby invokers.
	var/list/invokers = list() //people eligible to invoke the rune
	if(user)
		invokers += user
	if(req_invokers > 1)
		for(var/mob/living/invoker in range(runesize, src))
			if(invoker == user)
				continue
			if(!invoker.can_speak())
				continue
			if(invoker.stat != CONSCIOUS)
				continue
			if(magictype == "arcyne")
				if(isarcyne(invoker))
					invokers += invoker
			if(magictype == "divine")
				if(isdivine(invoker))
					invokers += invoker
			if(magictype == "druid")
				if(isdruid(invoker))
					invokers += invoker
			if(magictype == "blood")
				if(isblood(invoker))
					invokers += invoker


	return invokers

/obj/effect/decal/cleanable/roguerune/proc/invoke(list/invokers, datum/runeritual/ritual)		//Generic invoke proc. This will be defined on every rune, along with effects.If you want to make an object, or provide a buff, do so through this proc., have both here.
	rune_in_use = FALSE
	atoms_in_range = list()
	for(var/atom/close_atom as anything in range(runesize, src))
		if(iswallturf(close_atom))
			to_chat(usr, span_hierophant_warning("仪式失败，[src]被[close_atom]挡住了！"))
			fail_invoke()
			return
		if(!ismovable(close_atom))
			continue
		if(isitem(close_atom))
			var/obj/item/close_item = close_atom
			if(close_item.item_flags & ABSTRACT) //woops sacrificed your own head
				continue
		if(close_atom.invisibility)
			continue
		if(close_atom == usr)
			continue
		if(close_atom == src)
			continue
		atoms_in_range += close_atom
	pickritual = new ritual
	if(!islist(pickritual.required_atoms))
		return

	// A copy of our requirements list.
	// We decrement the values of to determine if enough of each required item is present.

	var/list/requirements_list = pickritual.required_atoms.Copy()
	var/list/banned_atom_types = pickritual.banned_atom_types.Copy()
	// A list of all atoms we've selected to use in this recipe.
	selected_atoms = list()
	for(var/atom/nearby_atom as anything in atoms_in_range)
		// Go through all of our required atoms
		if(istype(nearby_atom, /obj/item/reagent_containers))
			var/obj/item/reagent_containers/RC = nearby_atom
			if(RC.is_drainable())
				for(var/req_type in requirements_list)
					var/datum/reagent/A = RC.reagents.get_reagent(req_type)
					if(A && A.volume >= 15)
						requirements_list[req_type] -= A.volume
						selected_atoms |= nearby_atom

		for(var/req_type in requirements_list)
			// We already have enough of this type, skip
			if(requirements_list[req_type] <= 0)
				continue
			// If req_type is a list of types, check all of them for one match.
			if(islist(req_type))
				if(!(is_type_in_list(nearby_atom, req_type)))
					continue
			else if(!istype(nearby_atom, req_type))
				continue
			// if list has items, check if the strict type is banned.
			if(length(banned_atom_types))
				if(nearby_atom.type in banned_atom_types)
					continue
			// This item is a valid type. Add it to our selected atoms list.
			selected_atoms |= nearby_atom
			requirements_list[req_type]--
	var/list/what_are_we_missing = list()
	for(var/req_type in requirements_list)
		var/number_of_things = requirements_list[req_type]
		// <= 0 means it's fulfilled, skip
		if(number_of_things <= 0)
			continue
		// > 0 means it's unfilfilled - the ritual has failed, we should tell them why
		// Lets format the thing they're missing and put it into our list
		var/formatted_thing = "[number_of_things] "
		if(islist(req_type))
			var/list/req_type_list = req_type
			var/list/req_text_list = list()
			for(var/atom/possible_type as anything in req_type_list)
				req_text_list += pickritual.parse_required_item(possible_type)
			formatted_thing += english_list(req_text_list, and_text = "or")

		else
			formatted_thing = pickritual.parse_required_item(req_type)

		what_are_we_missing += formatted_thing
	if(length(what_are_we_missing))
		// Let them know it screwed up
		to_chat(usr, span_hierophant_warning("仪式失败，缺少材料！"))
		// Then let them know what they're missing
		to_chat(usr, span_hierophant_warning("你还缺少 [english_list(what_are_we_missing)]，才能完成仪式“[pickritual.name]”。"))
		fail_invoke()
		return FALSE

	playsound(usr, 'sound/magic/teleport_diss.ogg', 75, TRUE)

	ritual_result = pickritual.on_finished_recipe(usr, selected_atoms, loc)

	return TRUE

/obj/effect/decal/cleanable/roguerune/arcyne	//arcane
	name = "奥术仪式符文"
	desc = "用于奥术仪式的子类型，你本不该看到这段。"
	magictype = "arcyne"
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/roguerune/arcyne/attack_hand(mob/living/user)
	if(!isarcyne(user))
		to_chat(user, span_warning("你无法理解[src]上的文字。"))
		return
	. = ..()


/obj/effect/decal/cleanable/roguerune/arcyne/knowledge
	name = "知识符文"
	desc = "奥术符号在地面上脉动闪烁……"
	icon_state = "6"
	invocation = "Thal’ un’vethar!"
	color = "#3A0B61"
	spellbonus = 15
	scribe_damage = 10
	can_be_scribed = TRUE
	associated_ritual = /datum/runeritual/knowledge
	var/buffed = FALSE

/obj/effect/decal/cleanable/roguerune/arcyne/knowledge/attack_hand(mob/living/user)
	. = ..()
/obj/effect/decal/cleanable/roguerune/arcyne/knowledge/invoke(list/invokers, datum/runeritual/runeritual)
	runeritual = associated_ritual
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
//	if(!buffed)
	var/mob/living/user = usr
	user.apply_status_effect(/datum/status_effect/buff/magicknowledge)
	buffed = TRUE
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,  span_italics("[src]正在抽取你的力量！"))
	do_invoke_glow()


/obj/effect/decal/cleanable/roguerune/arcyne/empowerment
	name = "赋能法阵"
	desc = "奥术符号在地面上脉动闪烁……"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "empowerment"
	tier = 2
	runesize = 1
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
	invocation = "Thal’miren vek’laris un’vethar!"
	layer = SIGIL_LAYER
	can_be_scribed = TRUE
	ritual_number = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/empowerment/invoke(list/invokers, datum/runeritual/buff/runeritual)
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return

	var/buffedstat = runeritual.buff
	for(var/mob/living/invoker in range(runesize, src))
		invoker.apply_status_effect(buffedstat)
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,  span_italics("[src]正在抽取你的力量！"))
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/enchantment
	name = "灌注法阵"
	desc = "奥术符号在地面上脉动闪烁……"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "imbuement"
	tier = 2
	runesize = 1
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
	invocation = "Ral’kor vek’varun eyn’torath!"
	layer = SIGIL_LAYER
	can_be_scribed = TRUE
	ritual_number = TRUE


/obj/effect/decal/cleanable/roguerune/arcyne/enchantment/invoke(list/invokers, datum/runeritual/runeritual)
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,  span_italics("[src]正在抽取你的力量！"))
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/enchantment/greater	//used for better quality of learning, grants temporary 2 minute INT bonus.
	name = "高阶灌注法阵"
	desc = "奥术符号在地面上脉动闪烁……"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "imbuement"
	tier = 4
	runesize = 2
	pixel_x = -64 //So the big ol' 96x96 sprite shows up right
	pixel_y = -64
	invocation = "Zar’kalthra ul’norak ven’thelis!"


/obj/effect/decal/cleanable/roguerune/arcyne/wall
	name = "墙体构筑矩阵"
	desc = "奥术符号布满地面——那看起来像是某种墙体？"
	icon_state = "wall"
	tier = 2
	invocation = "Fren’aleth ar’quor!"
	ritual_number = TRUE
	can_be_scribed = TRUE
	color = "#184075"
	var/list/barriers = list()

/obj/effect/decal/cleanable/roguerune/arcyne/wall/Destroy()
	QDEL_LIST_CONTENTS(barriers)
	barriers = null
	return ..()

/obj/effect/decal/cleanable/roguerune/arcyne/wall/attack_hand(mob/living/user)
	if(active)
		QDEL_LIST_CONTENTS(barriers)
		to_chat(user, span_warning("你解除了[src]！"))
		playsound(usr, 'sound/magic/teleport_diss.ogg', 75, TRUE)
		active = FALSE
		return
	. = ..()
/obj/effect/decal/cleanable/roguerune/arcyne/wall/invoke(list/invokers, datum/runeritual/runeritual)
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
	if(pickritual.tier == 1)
		var/mob/living/user = usr
		var/turf/target_turf = get_step(get_step(src, user.dir), user.dir)
		var/turf/target_turf_two = get_step(target_turf, turn(user.dir, 90))
		var/turf/target_turf_three = get_step(target_turf, turn(user.dir, -90))
		var/turf/target_turf_four = get_step(target_turf_two, turn(user.dir, 90))
		var/turf/target_turf_five = get_step(target_turf_three, turn(user.dir, -90))
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_two)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_two, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_three)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_three, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_four)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_four, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_five)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_five, user)
			src.barriers += newbarrier
		active = TRUE
	else
		var/mob/living/user = usr
		var/turf/target_turf = get_step(get_step(src, user.dir), user.dir)
		var/turf/target_turf_two = get_step(target_turf, turn(user.dir, 90))
		var/turf/target_turf_three = get_step(target_turf, turn(user.dir, -90))
		var/turf/target_turf_four = get_step(target_turf_two, turn(user.dir, 90))
		var/turf/target_turf_five = get_step(target_turf_three, turn(user.dir, -90))
		var/turf/target_turfline2 = get_step(target_turf, user.dir)
		var/turf/target_turfline2_two = get_step(target_turfline2, turn(user.dir, 90))
		var/turf/target_turfline2_three = get_step(target_turfline2, turn(user.dir, -90))
		var/turf/target_turfline2_four = get_step(target_turfline2_two, turn(user.dir, 90))
		var/turf/target_turfline2_five = get_step(target_turfline2_three, turn(user.dir, -90))
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_two)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_two, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_three)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_three, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_four)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_four, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_five)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_five, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2_two)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2_two, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2_three)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2_three, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2_four)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2_four, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2_five)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2_five, user)
			src.barriers += newbarrier
		active = TRUE

	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,  span_italics("[src]正在抽取你的力量！"))
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/wallgreater
	name = "堡垒构筑矩阵"
	desc = "一道巨大的印记——中央那是墙体吗？"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "wall"
	tier = 3
	invocation = "Thar’morak dul’vorr keth’alor!"
	ritual_number = FALSE
	runesize = 2
	pixel_x = -64 //So the big ol' 96x96 sprite shows up right
	pixel_y = -64
	pixel_z = 0
	can_be_scribed = TRUE
//	var/id = "arcyne_fortress"
	var/datum/map_template/template
	var/fortress = /datum/map_template/arcyne_fortress
	var/list/barriers = list()
	associated_ritual = /datum/runeritual/other/wall/t3

/obj/effect/decal/cleanable/roguerune/arcyne/wallgreater/proc/clear_fortress_area(turf/deploy_location)
	if(!template)
		return

	// Load parsed map (same way load() does)
	var/datum/parsed_map/parsed = template.cached_map || new(file(template.mappath))
	if(!parsed?.bounds)
		return

	var/list/b = parsed.bounds

	var/z_offset_min = b[MAP_MINZ]
	var/z_offset_max = b[MAP_MAXZ]

	var/half_w = round(template.width / 2)
	var/half_h = round(template.height / 2)

	var/start_x = max(1, deploy_location.x - half_w - 6)
	var/end_x   = min(world.maxx, deploy_location.x + half_w + 6)
	var/start_y = max(1, deploy_location.y - half_h - 6)
	var/end_y   = min(world.maxy, deploy_location.y + half_h + 6)

	// Iterate exact Z range the template will use
	for(var/z_offset in z_offset_min to z_offset_max)
		var/z = deploy_location.z + (z_offset - z_offset_min)

		if(z < 1 || z > world.maxz)
			continue

		for(var/x in start_x to end_x)
			for(var/y in start_y to end_y)
				var/turf/T = locate(x, y, z)
				if(!T)
					continue

				// Delete structures
				for(var/obj/structure/S in T)
					qdel(S)

				// Delete dense blockers
				for(var/obj/O in T)
					if(O.density && !istype(O, /obj/effect))
						qdel(O)

/obj/effect/decal/cleanable/roguerune/arcyne/wallgreater/proc/get_template(/datum/map_template/arcyne_fortress/fortress)

	to_chat(usr, span_hierophant_warning("模板检索中"))
	var/datum/map_template/temporary = new fortress
	template = SSmapping.map_templates[temporary.id]
	if(!template)
		WARNING("Shelter template ([template.id]) not found!")
		qdel(src)


/obj/effect/decal/cleanable/roguerune/arcyne/wallgreater/invoke(list/invokers, datum/runeritual/ritual)
	ritual = associated_ritual
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
	if(QDELETED(src))
		return
	var/turf/deploy_location = get_turf(src)
	get_template(template)
	clear_fortress_area(deploy_location)
	template.load(deploy_location, centered = TRUE)
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,  span_italics("[src]正在抽取你的力量！"))
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/teleport
	name = "位面汇聚矩阵"
	desc = "一道巨大的螺旋印记，似乎正因力量而低鸣。"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "portal"
	tier = 2
	invocation = "Xel’tharr un’korel!"
	ritual_number = FALSE
	req_keyword = TRUE
	runesize = 2
	pixel_x = -64 //So the big ol' 96x96 sprite shows up right
	pixel_y = -64
	pixel_z = 0
	can_be_scribed = TRUE
	associated_ritual = /datum/runeritual/teleport
	var/listkey
/obj/effect/decal/cleanable/roguerune/arcyne/teleport/Initialize(mapload, set_keyword)
	. = ..()
	var/area/A = get_area(src)
	var/locname = initial(A.name)
	listkey = set_keyword ? "[set_keyword] [locname]":"[locname]"
	LAZYADD(GLOB.teleport_runes, src)

/obj/effect/rune/teleport/Destroy()
	LAZYREMOVE(GLOB.teleport_runes, src)
	return ..()

/obj/effect/decal/cleanable/roguerune/arcyne/teleport/invoke(list/invokers, datum/runeritual/runeritual)
	runeritual = associated_ritual
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
	var/mob/living/user = invokers[1] //the first invoker is always the user
	var/list/potential_runes = list()
	var/list/teleportnames = list()
	for(var/obj/effect/decal/cleanable/roguerune/arcyne/teleport/teleport_rune as anything in GLOB.teleport_runes)
		if(teleport_rune != src)
			potential_runes[avoid_assoc_duplicate_keys(teleport_rune.listkey, teleportnames)] = teleport_rune

	if(!length(potential_runes))
		to_chat(user, span_warning("没有可供传送的有效符文！"))
		log_game("Teleport rune activated by [user] at [COORD(src)] failed - no other teleport runes.")
		fail_invoke()
		return

	var/input_rune_key = input(user, "Rune to teleport to", "Teleportation Target") as null|anything in potential_runes //we know what key they picked
	if(isnull(input_rune_key))
		return
	if(isnull(potential_runes[input_rune_key]))
		fail_invoke()
		return
	var/obj/effect/rune/teleport/actual_selected_rune = potential_runes[input_rune_key] //what rune does that key correspond to?
	if(!Adjacent(user) || QDELETED(src) || !actual_selected_rune)
		fail_invoke()
		return

	var/turf/target = get_turf(actual_selected_rune)
	if(target.is_blocked_turf(TRUE))
		to_chat(user, span_warning("目标符文被阻挡了。试图传送过去将是极其愚蠢的行为。"))
		log_game("Teleport rune activated by [user] at [COORD(src)] failed - destination blocked.")
		fail_invoke()
		return
	var/movedsomething = FALSE
	var/moveuserlater = FALSE
	var/movesuccess = FALSE
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	for(var/atom/movable/A in range(runesize, src))
		if(istype(A, /obj/effect/dummy/phased_mob))
			continue
		if(ismob(A))
			if(!isliving(A)) //Let's not teleport ghosts and AI eyes.
				continue
		if(A == user)
			moveuserlater = TRUE
			movedsomething = TRUE
			continue
		if(!A.anchored)
			movedsomething = TRUE
			if(do_teleport(A, target, channel = TELEPORT_CHANNEL_CULT))
				movesuccess = TRUE
	if(movedsomething)
		//..()
		playsound(src, 'sound/magic/cosmic_expansion.ogg', 50, TRUE)
		playsound(target, 'sound/magic/cosmic_expansion.ogg', 50, TRUE)
		if(moveuserlater)
			if(do_teleport(user, target, channel = TELEPORT_CHANNEL_CULT))
				movesuccess = TRUE
		if(movesuccess)
			visible_message(span_warning("空气猛然炸裂，上方的一切都从符文上消失了！"), null, "<i>你听见了一声锐响。</i>")
			to_chat(user, span_cult("你[moveuserlater ? "眼前一阵模糊，伴着坠落感突然出现在别处":"将符文上方的一切传送走了"]。"))
		else
			to_chat(user, span_cult("你[moveuserlater ? "眼前短暂模糊了一下，但什么都没发生":"试着将符文上方的一切送走，但传送失败了"]。"))
		if(movesuccess)
			target.visible_message(span_warning("There is a boom of outrushing air as something appears above the rune!"), null, "<i>You hear a boom.</i>")
		for(var/atom/invoker in invokers)
			if(!isliving(invoker))
				continue
			var/mob/living/living_invoker = invoker
			if(invocation)
				living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
			if(invoke_damage)
				living_invoker.apply_damage(invoke_damage, BRUTE)
				to_chat(living_invoker,  span_italics("[src]正在抽取你的力量！"))
	else
		fail_invoke()

/obj/effect/decal/cleanable/roguerune/arcyne/summoning	//32x32 rune t1(one tile)
	name = "拘束矩阵"
	desc = "一种相对基础的拘束矩阵，用来在召唤时囚禁较小的目标。"
	ritual_number = TRUE
	icon_state = "summon"
	invocation = "Rhegal vex'ultraa!"
	max_integrity = 0
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	tier = 1
	can_be_scribed = TRUE
	var/summoning = FALSE
	var/mob/living/simple_animal/summoned_mob

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/ex_act(severity, target)
	return

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/Destroy()
	if(summoning)
		REMOVE_TRAIT(summoned_mob, TRAIT_PACIFISM, TRAIT_GENERIC)	//can't kill while planar bound.
		summoned_mob.status_flags -= GODMODE//remove godmode
		summoned_mob.candodge = TRUE
		summoned_mob.binded = FALSE
		summoned_mob.move_resist = MOVE_RESIST_DEFAULT
		summoned_mob.SetParalyzed(0)
		summoned_mob = null
		summoning = FALSE
	.=..()

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/attack_hand(mob/living/user)
	if(summoning && isarcyne(user))
		to_chat(user, span_warning("你把召唤物从拘束中释放了！"))
		playsound(usr, 'sound/magic/teleport_diss.ogg', 75, TRUE)
		do_invoke_glow()
		clear_obstacles(user)
		sleep(20)
		animate(summoned_mob, color = null,time = 5)
		REMOVE_TRAIT(summoned_mob, TRAIT_PACIFISM, TRAIT_GENERIC)	//can't kill while planar bound.
		summoned_mob.status_flags -= GODMODE//remove godmode
		summoned_mob.candodge = TRUE
		summoned_mob.binded = FALSE
		summoned_mob.move_resist = MOVE_RESIST_DEFAULT
		summoned_mob.SetParalyzed(0)
		summoned_mob = null
		summoning = FALSE
		return
	. = ..()

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/invoke(list/invokers, datum/runeritual/runeritual)
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
	// All the components have been invisibled, time to actually do the ritual. Call on_finished_recipe
	// (Note: on_finished_recipe may sleep in the case of some rituals like summons, which expect ghost candidates.)
	// - If the ritual was success (Returned TRUE), proceede to clean up the atoms involved in the ritual. The result has already been spawned by this point.
	// - If the ritual failed for some reason (Returned FALSE), likely due to no ghosts taking a role or an error, we shouldn't clean up anything, and reset.
	if(ismob(ritual_result))
		summoned_mob = ritual_result
		src.summoning = TRUE
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,  span_italics("[src]正在抽取你的力量！"))
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/proc/clear_obstacles(mob/living/user)
	for(var/turf/closed/wall/anticheese in range(loc, runesize))
		anticheese.visible_message(span_warning("[anticheese] crumbles under the force of the releasing wards."))
		anticheese.ChangeTurf(/turf/open/floor/rogue/blocks)
		continue

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/mid// 96x96 rune t2(3x3 tile)
	name = "海印石 拘束矩阵"
	desc = "一座通过加入 海印石 矩阵改良过的娴熟拘束矩阵，用于在召唤时囚禁目标。"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "sealate"
	runesize = 1
	tier = 2
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
	pixel_z = 0
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/adv	//160x160 rune t2(5x5 tile)
	name = "warded 海印石 拘束矩阵"
	desc = "一座以 海印石 矩阵强化、且被充分施加结界的拘束矩阵，用于在召唤时囚禁更大、更危险的目标。"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "warded"
	runesize = 2
	tier = 3
	pixel_x = -64 //So the big ol' 160x160 sprite shows up right
	pixel_y = -64
	pixel_z = 0
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/max	//224x224 rune t3(7x7 tile)
	name = "诺克之眼 warded 海印石 拘束矩阵"
	desc = "一座以 诺克之眼 封印与 海印石 矩阵双重强化、并施加了重重结界的拘束矩阵，用于囚禁可召唤出的最大、最危险之物。"
	icon = 'icons/effects/224x224.dmi'
	icon_state = "huge_runeblued"
	runesize = 3
	req_invokers = 3
	tier = 4
	pixel_x = -96 //So the big ol' 96x96 sprite shows up right
	pixel_y = -96
	pixel_z = 0
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/roguerune/divine	//To be used for divine rituals.
	magictype = "divine"
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/roguerune/divine/attack_hand(mob/living/user)
	if(!isdivine(user))
		to_chat(user, span_warning("你无法理解[src]上的文字。"))
		return
	. = ..()


/obj/effect/decal/cleanable/roguerune/druid		//to be used with druid magick
	magictype = "druid"
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/roguerune/druid/attack_hand(mob/living/user)
	if(!isdruid(user))
		to_chat(user, span_warning("你无法理解[src]上的文字。"))
		return
	. = ..()

/obj/effect/decal/cleanable/roguerune/blood		//to be used with blood magick
	magictype = "blood"
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/roguerune/blood/attack_hand(mob/living/user)
	if(!isblood(user))
		to_chat(user, span_warning("你无法理解[src]上的文字。"))
		return
	. = ..()
