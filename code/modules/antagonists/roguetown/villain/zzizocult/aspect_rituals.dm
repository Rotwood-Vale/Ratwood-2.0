GLOBAL_LIST_EMPTY(zizo_portals)
GLOBAL_LIST_EMPTY(gate_targets)
GLOBAL_LIST_EMPTY(cult_robes)

GLOBAL_LIST_INIT(zizo_researchable, list(
	/datum/ritual/servantry/convert, /datum/ritual/servantry/sacrifice,
	/datum/ritual/servantry/heartache, /datum/ritual/servantry/marktargets,
	/datum/ritual/servantry/gutted, /datum/ritual/transmutation/cross,
	/datum/ritual/transmutation/criminalstool, /datum/ritual/transmutation/invademind,
	/datum/ritual/transmutation/summonoutfit, /datum/ritual/servantry/aspect,
	/datum/ritual/transmutation/allseeingeye,
	/datum/ritual/fleshcrafting/bunnylegs, /datum/ritual/fleshcrafting/fleshmend,
	/datum/ritual/fleshcrafting/fleshmend/greater, /datum/ritual/fleshcrafting/darkeyes,
	/datum/ritual/fleshcrafting/nopain, /datum/ritual/fleshcrafting/immortality,
	/datum/ritual/transmutation/summonarmor, /datum/ritual/transmutation/summonweapon,
	/datum/ritual/transmutation/summonfuge,
	/datum/ritual/transmutation/summonpylon, /datum/ritual/transmutation/summonraver,
	/datum/ritual/transmutation/propaganda, /datum/ritual/servantry/sleepcurse,
	/datum/ritual/strand/dream_jaunt, /datum/ritual/strand/strandsend,
	/datum/ritual/strand/strandrecall, /datum/ritual/toil/progress,
	/datum/ritual/toil/summonysis, /datum/ritual/toil/fulmenor,
	/datum/ritual/bite/necromancy, /datum/ritual/bite/resurrection,
	/datum/ritual/bite/thanatophobia,
	/datum/ritual/rot/transfuse, /datum/ritual/rot/blight,
	/datum/ritual/rot/plague, /datum/ritual/noise/thermalvis,
	/datum/ritual/noise/forgettongue, /datum/ritual/noise/witchery,
	/datum/ritual/pitch/fireresist, /datum/ritual/pitch/shadowform,
	/datum/ritual/pitch/lightcurse, /datum/ritual/blood/transfuse,
	/datum/ritual/blood/bloodsnare, /datum/ritual/blood/bloodbond,
	/datum/ritual/transmutation/raiseshrine, /datum/ritual/servantry/guidance,
	))

GLOBAL_LIST_INIT(zizo_goals, list(
	/datum/zizogoal/worshipzizo, /datum/zizogoal/worshipzizo_church,
	/datum/zizogoal/profaneshrine_church, /datum/zizogoal/profaneshrine_tavern,
	/datum/zizogoal/profaneshrine_bath, /datum/zizogoal/profaneshrine_academy,
	/datum/zizogoal/profaneshrine_graveyard,
	))

GLOBAL_LIST_EMPTY(zizo_bestowed)
GLOBAL_DATUM_INIT(zizo_research, /datum/zizo_research, new)

#define TIER_TWO_GATEROLES \
	/datum/job/roguetown/warden,\
	/datum/job/roguetown/watchcaptain,\
	/datum/job/roguetown/wardenmaster,\
	/datum/job/roguetown/sergeant,\
	/datum/job/roguetown/veteran,\
	/datum/job/roguetown/dungeoneer,\
	/datum/job/roguetown/manorguard,\
	/datum/job/roguetown/squire,\
	/datum/job/roguetown/guardsman,\
	/datum/job/roguetown/janissary,\
	/datum/job/roguetown/janissarysergeant,\
	/datum/job/roguetown/azeb,\
	/datum/job/roguetown/slavemaster,\
	/datum/job/roguetown/guardsman,\
	/datum/job/roguetown/jester,\
	/datum/job/roguetown/clerk,\
	/datum/job/roguetown/wapprentice,\
	/datum/job/roguetown/butler,\
	/datum/job/roguetown/apothecary,\
	/datum/job/roguetown/chaplain,\
	/datum/job/roguetown/dtchaplain,\
	/datum/job/roguetown/churchling,\
	/datum/job/roguetown/druid,\
	/datum/job/roguetown/niteman,\
	/datum/job/roguetown/archivist,\
	/datum/job/roguetown/monk,\
	/datum/job/roguetown/templar,\
	/datum/job/roguetown/orthodoxist

#define TIER_THREE_GATEROLES \
	/datum/job/roguetown/prince,\
	/datum/job/roguetown/councillor,\
	/datum/job/roguetown/physician,\
	/datum/job/roguetown/marshal,\
	/datum/job/roguetown/captain,\
	/datum/job/roguetown/hand,\
	/datum/job/roguetown/knight,\
	/datum/job/roguetown/puritan,\
	/datum/job/roguetown/steward,\
	/datum/job/roguetown/cataphract,\
	/datum/job/roguetown/magician,\
	/datum/job/roguetown/priest

// HELPERS !!!

/proc/is_zizo(mob/M)
	return M && (is_zizocultist(M.mind) || is_zizolackey(M.mind))

/proc/absorb_lux(mob/living/carbon/human/target, turf/T, give_crystal = TRUE)
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || target.has_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped))
		return FALSE
	target.apply_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped)
	target.Unconscious(4 MINUTES)
	target.Jitter(4)
	target.emote("scream")
	target.visible_message(span_danger("[target]'s memory is wiped clean! They will completely forget what happened and who did it to them. In 4 minutes, they shall wake."))
	var/obj/item/bodypart/chest/torso = target.get_bodypart(BODY_ZONE_CHEST)
	if(torso)
		torso.receive_damage(85)
		torso.add_wound(/datum/wound/fracture)
	playsound(target, 'sound/gore/flesh_eat_04.ogg', 60, TRUE)
	target.purity = FALSE
	to_chat(target, span_danger("THE LUX IS TORN FROM YOUR SOUL. YOUR MEMORY BECOMES A BLUR. YOU CAN'T REMEMBER WHO DID THIS TO YOU, OR ANY DETAILS ABOUT HOW IT HAPPENED."))
	if(give_crystal)
		new /obj/item/necro_relics/necro_crystal(T)
	return TRUE

/proc/find_remnant(mob/user, turf/center)
	for(var/obj/item/natural/worms/leech/L in center)
		if(L.fed_from && !QDELETED(L.fed_from) && L.fed_from.stat != DEAD)
			if(istype(L.fed_from.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
				to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
				return FALSE
			return L
	to_chat(user, span_warning("Empty."))

/datum/status_effect/buff/curse_immunity
	id = "curse_immunity"
	duration = 30 MINUTES
	alert_type = null

/proc/curse_target(mob/living/target)
	if(!target || target.has_status_effect(/datum/status_effect/buff/curse_immunity))
		return FALSE
	target.apply_status_effect(/datum/status_effect/buff/curse_immunity, 30 MINUTES)
	return TRUE

/proc/recolor_accessory(accessory_type, hex)
	var/datum/sprite_accessory/A = SPRITE_ACCESSORY(accessory_type)
	var/list/colors = list()
	for(var/i in 1 to A.color_keys)
		colors += "#[hex]"
	return color_list_to_string(colors)


/datum/ritual/strand
	abstract_type = /datum/ritual/strand
	needs_aspect = "STRAND"

/datum/ritual/pitch
	abstract_type = /datum/ritual/pitch
	needs_aspect = "PITCH"

/datum/ritual/toil
	abstract_type = /datum/ritual/toil
	needs_aspect = "TOIL"

/datum/ritual/bite
	abstract_type = /datum/ritual/bite
	needs_aspect = "BITE"

/datum/ritual/rot
	abstract_type = /datum/ritual/rot
	needs_aspect = "ROT"

/datum/ritual/noise
	abstract_type = /datum/ritual/noise
	needs_aspect = "NOISE"

/datum/ritual/blood
	abstract_type = /datum/ritual/blood
	needs_aspect = "BLOOD"

GLOBAL_LIST_EMPTY(zizo_bestow_areas)

/proc/refill_bestow_areas()
	if(!GLOB.zizo_bestow_areas)
		GLOB.zizo_bestow_areas = list()
	var/list/pool = list(
		/area/rogue/indoors/town/shop,
		/area/rogue/indoors/town/tavern,
		/area/rogue/indoors/town/church,
		/area/rogue/indoors/town/bath,
		/area/rogue/indoors/town/physician,
		/area/rogue/indoors/town/magician,
		/area/rogue/indoors/town/garrison,
		/area/rogue/indoors/town/warden,
		/area/rogue/outdoors/town/graveyard,
	) - GLOB.zizo_bestow_areas
	while(GLOB.zizo_bestow_areas.len < 3 && pool.len)
		var/chosen = pick(pool)
		GLOB.zizo_bestow_areas += chosen
		pool -= chosen

/proc/zizo_bestow_alert(area/where)
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.mind && H.get_skill_level(/datum/skill/magic/arcane) > 0)
			to_chat(H, span_userdanger("Vile magick ripples out from [where.name]! Something evil has happened!"))
	priority_announce("An inhumen ritual has been completed! Vile cultists seek the power of the Gods!", title = "Omen", sound = 'sound/villain/dreamer_warning.ogg')
	var/datum/particle_weather/gentle = new /datum/particle_weather/blood_rain_gentle
	SSParticleWeather.runningWeather = gentle
	gentle.start()

/obj/structure/reality_rend
	name = "reality rend"
	desc = "A wound in the world."
	icon = 'icons/obj/tesla_engine/energy_ball.dmi'
	icon_state = "energy_ball"
	color = "#000000"
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/radius = 2
	var/list/turf_data = list()

/datum/stressevent/saw_wonder/cult
	timer = 1 MINUTES

/obj/structure/reality_rend/examine(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	H.overlay_fullscreen("cult", /atom/movable/screen/fullscreen/druqks)
	H.add_stress(/datum/stressevent/saw_wonder/cult)
	H.emote("scream")
	H.Paralyze(2 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(clear_cult_fullscreen), H), 2 SECONDS)

/proc/clear_cult_fullscreen(mob/user)
	user.clear_fullscreen("cult")

/turf/closed/wall/mineral/rogue/stone/unbreakable/space
	name = "???"
	desc = "???"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "undervoid"

/turf/open/floor/rogue/underworld/space/quiet/cult
	slowdown = 0

/obj/structure/reality_rend/Initialize(mapload)
	. = ..()
	var/turf/center = get_turf(src)
	for(var/turf/T in range(radius, center))
		if(isclosedturf(T) && !istype(T, /turf/closed/indestructible))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/closed/wall/mineral/rogue/stone/unbreakable/space, flags = CHANGETURF_IGNORE_AIR)
		else if(isopenturf(T) && !istype(T, /turf/open/floor/rogue/underworld/space/quiet/cult))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/open/floor/rogue/underworld/space/quiet/cult, flags = CHANGETURF_IGNORE_AIR)

/obj/structure/reality_rend/Destroy()
	for(var/turf/T in turf_data)
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	visible_message(span_danger("Lux fills the barren stone and returns lyfe to the land!"))
	playsound(src, 'sound/foley/breaksound.ogg', 50, TRUE)
	return ..()

/datum/ritual/servantry/aspect
	name = "Open Gate"
	desc = "REQUIRED TO UNLOCK ASCENSION. Activate the ritual to learn the locations it must be performed. Requires a dark crystal. It unlocks an Aspect that grants new research for the cult. MUST BE PERFORMED 3 TIMES TO UNLOCK ASCENSION."
	n_req = /obj/item/necro_relics/necro_crystal
	is_cultist_ritual = TRUE
	var/gate_count

/obj/effect/temp_visual/opengate
	icon = 'icons/effects/clan.dmi'
	icon_state = "summoning"
	dir = SOUTH
	randomdir = FALSE
	duration = 15 SECONDS
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/opengate/fivesec
	duration = 5 SECONDS

/proc/print_gate_sacrifice_info(mob/user)
	refill_bestow_areas()
	to_chat(user, span_warning("PERFORM THE RITE AT:"))
	for(var/atype in GLOB.zizo_bestow_areas)
		var/area/A = atype
		to_chat(user, span_notice("- [initial(A.name)]"))
	if(GLOB.gate_targets.len)
		to_chat(user, span_warning("SHE HUNGERS FOR:"))
		for(var/mob/living/carbon/human/H in GLOB.gate_targets)
			to_chat(user, span_notice("- [H.real_name]"))
	else
		to_chat(user, span_warning("NO SUITABLE SACRIFICE CAN BE FOUND YET."))

/datum/ritual/servantry/aspect/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(gate_count > 0)
		if(!target || target == user)
			to_chat(user, span_warning("A sacrifice must lie in the center."))
			print_gate_sacrifice_info(user)
			new /obj/item/necro_relics/necro_crystal(center)
			return
		if(is_zizo(target))
			to_chat(user, span_warning("This is a cultist."))
			new /obj/item/necro_relics/necro_crystal(center)
			return
		if(!(target in GLOB.gate_targets))
			to_chat(user, span_warning("She does not want this one."))
			new /obj/item/necro_relics/necro_crystal(center)
			return
		if(istype(target.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
			to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
			new /obj/item/necro_relics/necro_crystal(center)
			return
	refill_bestow_areas()
	var/area/here = get_area(center)
	var/valid_area = FALSE
	for(var/atype in GLOB.zizo_bestow_areas)
		if(istype(here, atype))
			valid_area = TRUE
			break

	if(!valid_area)
		to_chat(user, span_warning("THIS PLACE IS NOT RIGHT. SEEK:"))
		for(var/atype in GLOB.zizo_bestow_areas)
			var/area/A = atype
			to_chat(user, span_notice("- [initial(A.name)]"))
		new /obj/item/necro_relics/necro_crystal(center)
		return
	var/list/choices = list("PITCH", "TOIL", "STRAND", "ROT", "BLOOD", "NOISE", "BITE")
	var/choice = tgui_input_list(user, "CHOOSE AN ASPECT TO BRING FORTH.","ZIZO", choices)
	to_chat(user, span_notice("The rite begins. Remain still.<BR>Some may be alerted to your location after it is complete."))
	var/poo = new /obj/effect/temp_visual/opengate(center)
	playsound(user, 'sound/villain/littlescary.ogg', 100, TRUE)
	if(!do_after(user, 15 SECONDS))
		qdel(poo)
		new /obj/item/necro_relics/necro_crystal(center)
		return
	GLOB.zizo_bestowed += choice
	to_chat(user, span_boldnotice("The [choice] aspect has been unleashed upon Grimoria! Its rites may now be researched."))
	user.Jitter(4)
	gate_count++

	if(gate_count > 0)
		center_requirement = /mob/living/carbon/human

	if(gate_count < 3)
		to_chat(user, span_boldnotice("Gate opened! [3 - gate_count] more to unlock Ascension!"))
	if(gate_count == 3)
		GLOB.zizo_researchable |= /datum/ritual/fleshcrafting/ascend
		for(var/obj/item/clothing/cloak/cultrobe/robe as anything in GLOB.cult_robes)
			robe.empower()

	if(gate_count > 0)
		reroll_gate_targets(gate_count)

	if(gate_count == 1)
		to_chat(user, span_userdanger("SHE DEMANDS A SACRIFICE FOR THE NEXT GATE."))
		print_gate_sacrifice_info(user)

	if(target && !is_zizo(target))
		absorb_lux(target, get_turf(target), FALSE)

	for(var/datum/mind/M in SSmapping.retainer.cultists)
		if(M.current)
			zizo_award(M.current, 5)
	zizo_award(user, 5)
	playsound(user, 'sound/villain/hall_attack4.ogg', 100, TRUE)
	new /obj/structure/reality_rend(center)
	GLOB.zizo_bestow_areas -= here.type
	refill_bestow_areas()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(zizo_bestow_alert), here), 30 SECONDS)

// WEAPONS

/datum/component/soulbound_weapon
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/weakref/owner_ref
	var/skill_path

/datum/component/soulbound_weapon/Initialize(skill_path_type)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	skill_path = skill_path_type
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/component/soulbound_weapon/proc/on_equip(datum/source, mob/user, slot)
	SIGNAL_HANDLER
	if(slot != ITEM_SLOT_HANDS || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/weapon = parent
	if(!owner_ref)
		owner_ref = WEAKREF(H)
		if(skill_path)
			H.adjust_skillrank_up_to(skill_path, SKILL_LEVEL_MASTER)
		to_chat(H, span_danger("I feel [weapon] bind itself to me!"))
		return
	if(owner_ref.resolve() == H)
		return
	to_chat(H, span_danger("[uppertext(weapon)] HATES ME!"))
	H.dropItemToGround(weapon)

/datum/intent/dagger/thrust/cult
	penfactor = 100

/datum/intent/dagger/cut/cult
	penfactor = 100

/datum/intent/sword/cut/sabre/cult
	penfactor = 100

/datum/intent/sword/thrust/sabre/cult
	penfactor = 100

/obj/item/rogueweapon/sword/long/noise
	name = "madman blade"
	desc = ""
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "hagsword"
	max_integrity = 9999
	max_blade_int = 9999
	force = 25
	force_wielded = 35
	smeltresult = null
	sheathe_icon = "hagsword"
	special = /datum/special_intent/madman_delusion

/obj/item/rogueweapon/sword/long/noise/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/swords)

/datum/special_intent/madman_delusion
	name = "Cruelty"
	desc = "Induce a maddened state in the foe. It drives them to commit unspeakable violence against ally and foe alike."
	tile_coordinates = list(list(0,0))
	use_clickloc = TRUE
	respect_adjacency = FALSE
	range = 6
	post_icon_state = "strike"
	pre_icon_state = "trap"
	delay = 0.5 SECONDS
	cooldown = 30 SECONDS
	stamcost = 20
	var/dam = 15
	var/frenzy_duration = 8 SECONDS

/datum/special_intent/madman_delusion/apply_hit(turf/T)
	for(var/mob/living/carbon/human/L in get_hearers_in_view(0, T))
		if(L != howner)
			apply_generic_weapon_damage(L, dam, "slash", BODY_ZONE_HEAD, bclass = BCLASS_CUT)
			L.enter_frenzymod()
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/carbon, exit_frenzymod)), frenzy_duration)
	..()

/obj/item/rogueweapon/huntingknife/idagger/steel/blood
	name = "slave knife"
	desc = "A blade wielded by blood-pit slaves in the chaotic age after PSYDON's death. This one is permanently wet with blood."
	icon_state = "graggardagger"
	sheathe_icon = "graggardagger"
	force = 15
	max_integrity = 9999
	max_blade_int = 9999
	smeltresult = null
	special = /datum/special_intent/ignite_dagger
	possible_item_intents =	list(/datum/intent/dagger/thrust/cult,/datum/intent/dagger/cut/cult)

/obj/item/rogueweapon/huntingknife/idagger/steel/blood/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/knives)

/obj/item/rogueweapon/huntingknife/idagger/steel/pitch
	name = "astrata-touched dagger"
	desc = "This dagger once pierced the Sun Queen's heart."
	icon_state = "fdagger"
	sheathe_icon = "fdagger"
	force = 20
	max_integrity = 9999
	max_blade_int = 9999
	smeltresult = null
	special = /datum/special_intent/ignite_dagger
	var/active_intents =	list(/datum/intent/dagger/thrust/cult,/datum/intent/dagger/cut/cult)
	var/inactive_intents = list()

/obj/item/rogueweapon/huntingknife/idagger/steel/pitch/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/knives)

/datum/special_intent/ignite_dagger
	name = "Ignite Dagger"
	desc = "Channel the power of Pitch within the dagger to heat it to an incredible degree."
	cooldown = 120 SECONDS
	stamcost = 25

/datum/special_intent/ignite_dagger/on_create()
	. = ..()
	howner.visible_message(span_warning("[iparent]'s blade begins to glow intensely in [howner]'s grasp!"))
	var/obj/item/rogueweapon/huntingknife/idagger/steel/pitch/W = iparent
	active_timer = addtimer(CALLBACK(src, PROC_REF(effect_expire)), 30 SECONDS, TIMER_STOPPABLE)
	W.damtype = BURN
	W.icon_state = "fdagger_active"
	W.inactive_intents = W.possible_item_intents
	W.possible_item_intents = W.active_intents
	howner.update_a_intents()
	howner.regenerate_icons()
	playsound(W.loc, 'sound/items/firelight.ogg', 100)

/datum/special_intent/ignite_dagger/proc/effect_expire()
	howner.visible_message(span_warning("[iparent]'s blade cools down!"))
	var/obj/item/rogueweapon/huntingknife/idagger/steel/pitch/W = iparent
	W.damtype = BRUTE
	W.icon_state = "fdagger"
	W.possible_item_intents = W.inactive_intents
	howner.update_a_intents()
	howner.regenerate_icons()
	playsound(W.loc, 'sound/items/firesnuff.ogg', 100)

/obj/item/rogueweapon/sword/sabre/rot
	name = "mortal blade"
	desc = "Once a righteous blade wielded by a fair maiden. No longer."
	icon_state = "poisonsabre"
	force = 30
	max_integrity = 9999
	max_blade_int = 9999
	var/active_intents =	list(/datum/intent/sword/cut/sabre/cult, /datum/intent/sword/thrust/sabre/cult)
	var/inactive_intents = list()
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	sellprice = 50
	smeltresult = null
	special = /datum/special_intent/coat_blade

/obj/item/rogueweapon/sword/sabre/rot/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/swords)

/datum/special_intent/coat_blade
	name = "Coat Blade"
	desc = "Channel the power of Rot within this sabre to render it as toxic as it once was."
	cooldown = 120 SECONDS
	stamcost = 25

/datum/special_intent/coat_blade/on_create()
	. = ..()
	howner.visible_message(span_warning("[iparent]'s blade forms a solid layer of poison in [howner]'s grasp!"))
	var/obj/item/rogueweapon/sword/sabre/rot/W = iparent
	active_timer = addtimer(CALLBACK(src, PROC_REF(effect_expire)), 30 SECONDS, TIMER_STOPPABLE)
	W.damtype = TOX
	W.force -= 20
	W.update_force_dynamic()
	W.possible_item_intents = W.active_intents
	howner.update_a_intents()
	W.icon_state = "poisonsabre_active"
	howner.regenerate_icons()
	playsound(W.loc, 'sound/misc/lava_death.ogg', 100)

/datum/special_intent/coat_blade/proc/effect_expire()
	howner.visible_message(span_warning("[iparent]'s coating of toxins falls to the dirt!"))
	var/obj/item/rogueweapon/sword/sabre/rot/W = iparent
	W.damtype = BRUTE
	W.force += 20
	W.possible_item_intents = W.inactive_intents
	howner.update_a_intents()
	W.update_force_dynamic()
	W.icon_state = "poisonsabre"
	playsound(W.loc, 'sound/magic/bladescrape.ogg', 100)

/obj/item/rogueweapon/mace/maul/toil
	name = "forgotten tool"
	desc = "A wrench used by an artificer-thief in the the ancient age of Aeon."
	icon_state = "bronzewrench"
	icon = 'icons/roguetown/weapons/blunt64.dmi'
	force = 25
	force_wielded = 35
	minstr = 8
	max_integrity = 9999
	w_class = WEIGHT_CLASS_BULKY
	swingsound = BLUNTWOOSH_LARGE
	gripsprite = TRUE
	wlength = WLENGTH_LONG
	wbalance = WBALANCE_HEAVY
	grid_width = null
	grid_height = null
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	walking_stick = TRUE
	special = /datum/special_intent/deploy_turret
	var/list/obj/structure/toilturret/turrets = list()
	var/max_turrets = 3

/obj/item/rogueweapon/mace/maul/toil/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/maces)

/obj/item/rogueweapon/mace/maul/toil/equipped(mob/user, slot, initial)
	. = ..()
	if(slot != ITEM_SLOT_HANDS || !user.mind)
		return
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/direct_turrets)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/scrap_turrets)

/obj/item/rogueweapon/mace/maul/toil/dropped(mob/user, silent)
	. = ..()
	if(!user.mind)
		return
	user.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/direct_turrets)
	user.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/scrap_turrets)

/obj/effect/proc_holder/spell/self/direct_turrets
	name = "Direct Turrets"
	desc = "Target a specific person with your turrets!"
	recharge_time = 10 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/direct_turrets/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/obj/item/rogueweapon/mace/maul/toil/W = user.get_active_held_item()
	if(!istype(W))
		to_chat(user, span_warning("I must hold the Tool."))
		revert_cast()
		return FALSE
	var/list/possible = list()
	for(var/mob/living/carbon/human/H in oview(7, user))
		possible += H
	if(!length(possible))
		to_chat(user, span_warning("No one detected."))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/target = input(user, "TARGET", "ZIZO") as null|anything in possible
	if(!target)
		revert_cast()
		return FALSE
	for(var/obj/structure/toilturret/existing as anything in W.turrets.Copy())
		if(QDELETED(existing))
			W.turrets -= existing
			continue
		existing.forced_target = target
	to_chat(user, span_notice("TURRET LOCK: [target]."))
	return TRUE

/obj/effect/proc_holder/spell/self/scrap_turrets
	name = "Scrap Turrets"
	desc = "Disassemble all sentries."
	recharge_time = 5 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/scrap_turrets/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/obj/item/rogueweapon/mace/maul/toil/W = user.get_active_held_item()
	if(!istype(W))
		to_chat(user, span_warning("I must hold the Tool."))
		revert_cast()
		return FALSE
	for(var/obj/structure/toilturret/existing as anything in W.turrets.Copy())
		qdel(existing)
	W.turrets = list()
	to_chat(user, span_notice("My sentries have disassembled."))
	return TRUE

/datum/special_intent/deploy_turret
	name = "Deploy Turret"
	desc = "Buildin' a Sentry."
	tile_coordinates = list(list(0,0))
	post_icon_state = "strike"
	pre_icon_state = "trap"
	delay = 4 SECONDS
	cooldown = 20 SECONDS
	stamcost = 20
	use_doafter = TRUE

/datum/special_intent/deploy_turret/apply_hit(turf/T)
	..()
	var/obj/item/rogueweapon/mace/maul/toil/W = iparent
	if(!istype(W))
		return
	for(var/obj/structure/toilturret/existing as anything in W.turrets.Copy())
		if(QDELETED(existing))
			W.turrets -= existing
	if(length(W.turrets) >= W.max_turrets)
		to_chat(howner, span_warning("I can only have [W.max_turrets] sentries!."))
		return
	if(T.density)
		to_chat(howner, span_warning("There's no room for a sentry there."))
		return
	var/obj/structure/toilturret/turret = new(T, howner, W)
	W.turrets += turret
	to_chat(howner, span_notice("The turret whirs to life!"))

/obj/structure/toilturret
	name = "cog turret"
	desc = "There's a horrible familiarity to its shape. You swore you haven't seen it before."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "ocular_warden"
	density = TRUE
	anchored = TRUE
	max_integrity = 150
	var/mob/living/carbon/human/owner
	var/obj/item/rogueweapon/mace/maul/toil/source_wrench
	var/range = 5
	var/cooldown = 0
	var/active = TRUE
	var/mob/living/carbon/human/forced_target

/obj/structure/toilturret/Initialize(mapload, mob/living/carbon/human/builder, obj/item/rogueweapon/mace/maul/toil/wrench)
	. = ..()
	owner = builder
	source_wrench = wrench
	START_PROCESSING(SSobj, src)

/obj/structure/toilturret/Destroy()
	STOP_PROCESSING(SSobj, src)
	source_wrench?.turrets -= src
	source_wrench = null
	owner = null
	forced_target = null
	return ..()

/obj/structure/toilturret/attack_right(mob/living/user, params)
	. = ..()
	if(!istype(user.get_active_held_item(), /obj/item/rogueweapon/mace/maul/toil))
		return
	active = !active
	if(active)
		icon_state = "ocular_warden"
	else
		icon_state = "ocular_warden_unwrenched"

/obj/structure/toilturret/process()
	if(!active)
		return
	if(world.time < cooldown)
		return
	if(!owner)
		qdel(src)
		return
	var/mob/living/carbon/human/target
	if(forced_target && !QDELETED(forced_target) && forced_target.stat != DEAD && (forced_target in view(range, src)))
		target = forced_target
	else
		for(var/mob/living/carbon/human/H in view(range, src))
			if(H == owner || is_zizo(H) || H.stat == DEAD)
				continue
			target = H
			break
	if(!target)
		return
	cooldown = world.time + 20
	visible_message(span_danger("[src] takes aim at [target]!"))
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new /obj/projectile/toilbolt(startloc)
	playsound(src, 'sound/combat/hits/onmetal/metalimpact (1).ogg', 60, TRUE)
	P.starting = startloc
	P.fired_from = src
	P.yo = target.y - startloc.y
	P.xo = target.x - startloc.x
	P.original = target
	P.preparePixelProjectile(target, src)
	P.fire()

/obj/projectile/toilbolt
	name = "bolt"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"
	damage = 15
	damage_type = BRUTE
	armor_penetration = 10
	range = 15
	hitsound = 'sound/combat/hits/hi_bolt (1).ogg'
	flag = "piercing"
	speed = 2

/obj/item/rogueweapon/contraption/linker/mace/big/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6, "sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/datum/intent/spear/cut/scythe
	reach = 3
	damfactor = 1

/obj/item/rogueweapon/spear/bite
	force = 20
	force_wielded = 30
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/cut/scythe, SPEAR_BASH, MACE_STRIKE)
	name = "snow scythe"
	desc = "An oversized scythe used to harvest giant mushrooms. Born to underdark farmers, she explored every nook and cranny of the ancient caverns."
	icon_state = "silverpeasantscythe"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_integrity = 9999
	max_blade_int = 9999
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = null
	walking_stick = TRUE
	wdefense = 6
	thrown_bclass = BCLASS_BLUNT
	throwforce = 10
	special = /datum/special_intent/scythe_cone

/obj/item/rogueweapon/spear/bite/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/polearms)

/datum/special_intent/scythe_cone
	name = "Snow Stance"
	desc = "Use a strong attack to coat the earth with running frost."
	tile_coordinates = list(
		list(0,0),
		list(-1,1), list(0,1), list(1,1),
		list(-2,2), list(-1,2), list(0,2), list(1,2), list(2,2)
	)
	post_icon_state = "shieldsparkles"
	pre_icon_state = "frost"
	delay = 0.6 SECONDS
	cooldown = 25 SECONDS
	stamcost = 20
	var/dam = 15

/datum/special_intent/scythe_cone/apply_hit(turf/T)
	for(var/mob/living/carbon/human/L in get_hearers_in_view(0, T))
		if(L != howner)
			apply_generic_weapon_damage(L, dam, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CUT)
			L.apply_status_effect(/datum/status_effect/buff/frostbite)
	..()

/obj/item/rogueweapon/scythe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

// STRAND

/obj/effect/proc_holder/spell/invoked/dream_jaunt
	name = "Dream Jaunt"
	desc = "Bring yourself and whoever you hold into the dream."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "jaunt"
	range = 0
	movement_interrupt = FALSE
	chargedloop = null
	recharge_time = 60 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/dream_jaunt/cast(list/targets, mob/living/user)
	. = ..()
	if(!ishuman(user))
		return FALSE
	send_to_dream(user)
	if(ishuman(user.pulling))
		send_to_dream(user.pulling)
	return TRUE

/proc/send_to_dream(mob/living/carbon/human/target, status_type = /datum/status_effect/dream_teleport/strand)
	var/area/dream_area = GLOB.areas_by_type[/area/rogue/underworld/dream]
	var/turf/origin = get_turf(target)
	if(!dream_area || !origin)
		return
	var/list/safe_turfs = list()
	for(var/turf/T in get_area_turfs(dream_area))
		if(!T.density)
			safe_turfs += T
	if(!safe_turfs.len || !do_teleport(target, pick(safe_turfs)))
		return
	GLOB.players_in_dream |= target
	origin.visible_message(span_danger("[target] vanishes!"))
	playsound(origin, 'sound/misc/area.ogg')
	target.apply_status_effect(status_type, origin)

/datum/status_effect/dream_teleport/strand
	duration = 30 SECONDS

/datum/status_effect/dream_teleport/recall
	duration = 3 MINUTES

/datum/ritual/strand/dream_jaunt
	name = "Dream Jaunt"
	desc = "Learn a spell to teleport yourself and whoever you're holding into a pocket dimension for 30 seconds."
	passive = TRUE
	research_cost = 3

/datum/ritual/strand/dream_jaunt/apply_passive(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dream_jaunt)
	return

/datum/ritual/strand/strandsend
	name = "Passage"
	desc = "Perform a rite to create a teleportation sigil. Activating it will teleport everything on the sigil to another teleportation sigil."
	center_requirement = /mob/living/carbon/human

/datum/ritual/strand/strandsend/invoke(mob/living/user, turf/center)
	var/obj/effect/decal/cleanable/sigil/S = locate() in center
	if(!S)
		return
	var/poo = new /obj/effect/temp_visual/opengate/fivesec(center)
	playsound(user, 'sound/villain/littlescary2.ogg', 60, TRUE)
	if(!do_after(user, 5 SECONDS))
		qdel(poo)
		return
	S.set_sigil_type("Portal")
	to_chat(user, span_notice("AN EYE IS A PASSAGE."))

/datum/ritual/strand/strandrecall
	name = "Curse of Recall"
	desc = "Teleport yourself and your target into a pocket dimension for 3 minutes. Anyone you or your target grabs is brought with. Requires a leech that fed from your target."
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/strand/strandrecall/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!curse_target(victim))
		to_chat(user, span_warning("THEY ARE PROTECTED FROM FURTHER CURSES."))
		return
	qdel(remnant)
	to_chat(user, span_notice("ALL MEN OBEY THE DREAMCALL. I HAVE 1 MINUTE TO PREPARE. ANYONE I AM GRABBING WILL BE BROUGHT WITH ME."))
	to_chat(victim, span_userdanger("I FEEL SOMETHING HORRIBLE COMING. I HAVE 1 MINUTE TO PREPARE. ANYONE I AM GRABBING WILL BE BROUGHT WITH ME."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(dreamcall), user, victim), 1 MINUTES)

/proc/dreamcall(mob/living/user, mob/living/victim)
	for(var/mob/living/M in list(user, victim))
		if(QDELETED(M) || !ishuman(M))
			continue
		send_to_dream(M, /datum/status_effect/dream_teleport/recall)
		if(ishuman(M.pulling))
			send_to_dream(M.pulling, /datum/status_effect/dream_teleport/recall)

// TOIL

/obj/effect/proc_holder/spell/invoked/projectile/toil_mend
	name = "Mend"
	desc = "Shoot mending lightning that heals the target and fixes their equipment."
	clothes_req = FALSE
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "toil"
	sound = 'sound/magic/lightning.ogg'
	range = 7
	projectile_type = /obj/projectile/magic/mendbolt
	chargetime = 15
	recharge_time = 10 SECONDS
	chargedloop = null

/obj/projectile/magic/mendbolt
	name = "bolt of mending"
	tracer_type = /obj/effect/projectile/tracer/stun
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	light_color = "#00ff00"
	damage = 0
	nodamage = TRUE
	speed = 0.3
	flag = "magic"
	light_outer_range = 7

/obj/projectile/magic/mendbolt/on_hit(target)
	. = ..()
	if(ismob(target) && isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		L.apply_status_effect(/datum/status_effect/buff/healing, 10, TRUE)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			for(var/obj/item/I in H.get_equipped_items())
				I.obj_integrity = min(I.obj_integrity + (I.max_integrity * 0.2), I.max_integrity)
		to_chat(L, span_notice("I AM MENDED!"))
	qdel(src)

/datum/ritual/toil/progress
	name = "Mend"
	desc = "Learn a spell that heals others and repairs their equipment. Does not work on yourself."
	passive = TRUE
	research_cost = 3

/datum/ritual/toil/progress/apply_passive(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/toil_mend)
	return

/datum/ritual/toil/summonysis
	name = "Summon Ysis"
	desc = "Summon a machine that heals and mends the equipment of anyone who activates it."
	center_requirement = /obj/item/bedsheet
	research_cost = 5

/datum/ritual/toil/summonysis/invoke(mob/living/user, turf/center)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	new /obj/structure/ysis(center)
	to_chat(user, span_notice("Erectin' a Ysis."))

/obj/structure/ysis
	name = "Ysis"
	desc = "It feels good to touch!"
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "hierophant_ansible"
	density = TRUE
	anchored = TRUE
	max_integrity = 200

/obj/structure/ysis/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user) || user.stat == DEAD)
		return
	var/mob/living/carbon/human/H = user
	to_chat(H, span_notice("THE YSIS WORKS UPON ME..."))
	if(!do_after(H, 5 SECONDS, target = src))
		return
	var/datum/status_effect/buff/healing/heal = H.apply_status_effect(/datum/status_effect/buff/healing, 10, TRUE)
	if(heal)
		heal.duration = world.time + 5 SECONDS
	for(var/obj/item/I in H.get_equipped_items())
		I.obj_integrity = min(I.obj_integrity + (I.max_integrity * 0.2), I.max_integrity)
	to_chat(H, span_notice("YSIS MENDS ME."))
	playsound(src, 'sound/magic/lightning.ogg', 60, TRUE)

/datum/ritual/toil/fulmenor
	name = "Curse of Fulmenor"
	desc = "Transform the target into a horrific, yet extremely strong and regenerative monster. It attacks people at random. Lasts one minute. Requires a leech that fed from your target."
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE
	research_cost = 5

/datum/ritual/toil/fulmenor/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!curse_target(victim))
		to_chat(user, span_warning("THEY ARE PROTECTED FROM FURTHER CURSES."))
		return
	qdel(remnant)
	victim.apply_status_effect(/datum/status_effect/fulmenor)
	victim.emote("scream")
	to_chat(victim, span_userdanger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	to_chat(user, span_notice("THEY SHALL WRECK HAVOC."))

/datum/status_effect/fulmenor
	id = "fulmenor"
	duration = 1 MINUTES
	tick_interval = 5 SECONDS
	alert_type = null

/datum/status_effect/fulmenor/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.change_stat(STATKEY_STR, 6)
	H.change_stat(STATKEY_CON, 6)
	ADD_TRAIT(H, TRAIT_MONSTROUS, TRAIT_GENERIC)
	H.enter_frenzymod()
	to_chat(H, span_notice("I WANT TO HURT PEOPLE!"))
	return TRUE

/datum/status_effect/fulmenor/tick()
	var/mob/living/carbon/human/H = owner
	H.heal_overall_damage(10, 10)

/datum/status_effect/fulmenor/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.exit_frenzymod()
	H.change_stat(STATKEY_STR, -6)
	H.change_stat(STATKEY_CON, -6)
	REMOVE_TRAIT(H, TRAIT_MONSTROUS, TRAIT_GENERIC)
	to_chat(H, span_notice("THE MONSTROUS HUNGER FADES FROM ME."))

// BITE

/datum/ritual/bite/necromancy
	name = "Necromancy"
	desc = "Learn necromancy spells and the ability to use dark crystals to summon sentient skeletons."
	passive = TRUE

/datum/ritual/bite/necromancy/apply_passive(mob/living/carbon/human/H)
	H.mind.current.faction += "[H.name]_faction"
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/command_undead)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer)
	return

/datum/ritual/bite/resurrection
	name = "Resurrection"
	desc = "Place the target on the middle sigil to revive them. Requires a dark crystal on the north sigil, or else they come back as a Greater Deadite. Greater deadites are intelligent and capable of using items and weaponry, but suffer all the other drawbacks of being a deadite. They are not guaranteed to be loyal."
	center_requirement = /mob/living/carbon/human
	research_cost = 5

/datum/ritual/bite/resurrection/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/corpse = locate() in center.contents
	if(!corpse || corpse.stat != DEAD || !corpse.mind)
		to_chat(user, span_warning("YOU NEED A CORPSE."))
		return
	if(HAS_TRAIT(corpse, TRAIT_ZOMBIE_IMMUNE))
		to_chat(user, span_warning("THEY SHALL NOT RISE."))
		return
	playsound(get_turf(corpse), 'sound/magic/magnet.ogg', 80, TRUE)
	var/obj/item/necro_relics/necro_crystal/crystal = locate() in get_step(center, NORTH)
	if(crystal)
		qdel(crystal)
		corpse.revive(full_heal = TRUE, admin_revive = TRUE)
		ADD_TRAIT(corpse, TRAIT_ROTMAN, TRAIT_GENERIC)
		corpse.visible_message(span_notice("[corpse] is returned to lyfe!"))
		return
	corpse.set_blood_volume(BLOOD_VOLUME_NORMAL)
	corpse.setOxyLoss(0, updating_health = FALSE, forced = TRUE)
	corpse.setToxLoss(0, updating_health = FALSE, forced = TRUE)
	corpse.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
	corpse.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
	corpse.heal_wounds(INFINITY)
	corpse.zombie_check_can_convert()
	var/datum/antagonist/zombie/Z = corpse.mind.has_antag_datum(/datum/antagonist/zombie)
	if(Z)
		Z.wake_zombie(TRUE)
	REMOVE_TRAIT(corpse, TRAIT_CHUNKYFINGERS, "/datum/antagonist/zombie")
	REMOVE_TRAIT(corpse, TRAIT_ZOMBIE_SPEECH, "/datum/antagonist/zombie")
	corpse.emote("scream")
	to_chat(corpse, span_userdanger("I FEEL MORE COMPETENT THAN THE AVERAGE DEADITE."))

/datum/ritual/bite/thanatophobia
	name = "Curse of Thanatophobia"
	desc = "The target becomes extremely afraid of skeletons and corpses. Lasts 10 minutes. Requires a leech that fed from your target."
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE
	research_cost = 5

/datum/ritual/bite/thanatophobia/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	if(!curse_target(remnant.fed_from))
		to_chat(user, span_warning("THEY ARE PROTECTED FROM FURTHER CURSES."))
		return
	remnant.fed_from.apply_status_effect(/datum/status_effect/debuff/thanatophobia)
	to_chat(remnant.fed_from, span_danger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("THEY SHALL FEAR MY DOMAIN!"))

/datum/status_effect/debuff/thanatophobia
	id = "thanatophobia"
	duration = 10 MINUTES
	tick_interval = 10 SECONDS
	alert_type = null

/datum/status_effect/debuff/thanatophobia/tick()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H))
		return
	for(var/mob/living/L in view(5, H))
		if(L == H)
			continue
		if(L.stat == DEAD || L.mind?.has_antag_datum(/datum/antagonist/skeleton))
			to_chat(H, span_userdanger("I MUST NOT DIE! I CAN NOT BEAR TO SEE THE DEAD!"))
			H.emote("scream")
			H.adjustStaminaLoss(10)
			step_away(H, L, 10)
			break

// ROT

/obj/effect/proc_holder/spell/self/rot_transfuse
	name = "Transfuse"
	desc = "Transfuse all reagents in your bloodstream to the target you're holding."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "transfuse"
	recharge_time = 5 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/rot_transfuse/cast(list/targets, mob/user = usr)
	. = ..()
	var/obj/item/grabbing/G = user.get_active_held_item()
	if(!istype(G) || !isliving(G.grabbed))
		return FALSE
	if(!G)
		to_chat(user, span_warning("I need to be grabbing someone."))
		revert_cast()
		return FALSE
	var/mob/living/victim = G.grabbed
	if(user.reagents && victim.reagents && user.reagents.total_volume)
		user.reagents.trans_to(victim, user.reagents.total_volume, method = INJECT)
	to_chat(user, span_notice("I transfuse into [victim]."))
	return TRUE

/datum/ritual/rot/transfuse
	name = "Transfuse"
	desc = "Learn a spell to transfuse all reagents in your bloodstream to whoever you're grabbing. Makes you immune to poison."
	passive = TRUE
	research_cost = 3

/datum/ritual/rot/transfuse/apply_passive(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rot_transfuse)
	ADD_TRAIT(H, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	return

/turf/open/floor/rogue/naturalstone/rot
	color = "#30c307"

/turf/open/floor/rogue/naturalstone/rot/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!ishuman(AM) || is_zizo(AM))
		return
	var/mob/living/carbon/human/H = AM
	H.apply_status_effect(/datum/status_effect/debuff/rotground)

/datum/status_effect/debuff/rotground
	id = "rotground"
	duration = -1
	tick_interval = 3 SECONDS
	alert_type = null

/datum/status_effect/debuff/rotground/tick()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H) || is_zizo(H) || !istype(get_turf(H), /turf/open/floor/rogue/naturalstone/rot))
		qdel(src)
		return
	H.adjustToxLoss(5)
	H.adjustStaminaLoss(10)

/obj/structure/blight_pillar
	name = "rotting pillar"
	desc = "A pillar of fused bone and diseased flesh. Destroy it!"
	icon = 'icons/roguetown/maniac/creations.dmi'
	icon_state = "creation1"
	anchored = TRUE
	density = TRUE
	max_integrity = 300
	var/radius = 3
	var/list/turf_data = list()

/obj/structure/blight_pillar/Initialize(mapload)
	. = ..()
	var/turf/center = get_turf(src)
	for(var/turf/T in range(radius, center))
		if(isclosedturf(T) && !istype(T, /turf/closed/indestructible))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/closed/mineral/rogue, flags = CHANGETURF_IGNORE_AIR)
		else if(isopenturf(T) && !istype(T, /turf/open/floor/rogue/naturalstone/rot))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/open/floor/rogue/naturalstone/rot, flags = CHANGETURF_IGNORE_AIR)

/obj/structure/blight_pillar/Destroy()
	for(var/turf/T in turf_data)
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	visible_message(span_danger("Lux fills the barren stone and returns lyfe to the land!"))
	playsound(src, 'sound/foley/breaksound.ogg', 50, TRUE)
	return ..()

/datum/ritual/rot/blight
	name = "Blight"
	desc = "Perform a rite that petrifies the area around you. Non-cultists will take damage when stepping upon the petrified land. It transforms walls into mineable rock."
	center_requirement = /mob/living/carbon/human

/datum/ritual/rot/blight/invoke(mob/living/user, turf/center)
	var/poo = new /obj/effect/temp_visual/opengate/fivesec(center)
	playsound(user, 'sound/villain/littlescary2.ogg', 60, TRUE)
	if(!do_after(user, 5 SECONDS))
		qdel(poo)
		return
	new /obj/structure/blight_pillar(center)
	to_chat(user, span_notice("THE LAND ROTS."))

/datum/ritual/rot/plague
	name = "Curse of Black Rot"
	desc = "Curse your target with the black rot. Requires a leech that fed from your target."
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/rot/plague/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	if(!curse_target(remnant.fed_from))
		to_chat(user, span_warning("THEY ARE PROTECTED FROM FURTHER CURSES."))
		return
	remnant.fed_from.apply_status_effect(/datum/status_effect/black_rot)
	to_chat(remnant.fed_from, span_danger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("THEY HAVE THE ROT WITHIN THEM, NOW."))

// NOISE

/mob/living/proc/end_jaunt(obj/effect/dummy/phased_mob/slaughter/holder, turf/return_turf)
	if(QDELETED(holder))
		return
	forceMove(return_turf || get_turf(holder))
	qdel(holder)

/mob/living/simple_animal/spook_spirit
	name = "???"
	desc = "Don't look at this."
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	invisibility = INVISIBILITY_OBSERVER
	density = FALSE
	incorporeal_move = TRUE
	health = 500
	maxHealth = 500
	AIStatus = AI_OFF
	can_have_ai = FALSE

/mob/living/simple_animal/spook_spirit/ex_act()
	return

/mob/living/simple_animal/spook_spirit/bullet_act()
	return BULLET_ACT_FORCE_PIERCE

/mob/living/simple_animal/spook_spirit/fire_act()
	return

/datum/ritual/noise/thermalvis
	name = "Spook"
	desc = "Learn a spell to phase-walk through walls, leaving your body behind. Your eyes now see the living through walls."
	passive = TRUE
	research_cost = 3

/datum/ritual/noise/thermalvis/apply_passive(mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/spook_scry)
	return

/obj/effect/proc_holder/spell/self/spook_scry
	name = "Spook"
	desc = "Leave your body behind and observe the world unhindered for 20 seconds."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "zizocloud"
	recharge_time = 30 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/spook_scry/charge_check(mob/user)
	return charge_counter >= recharge_time

/obj/effect/proc_holder/spell/self/spook_scry/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		revert_cast()
		return FALSE
	var/mob/living/simple_animal/spook_spirit/spirit = new(get_turf(H))
	H.visible_message(span_warning("[H] falls limp!"))
	H.mind.transfer_to(spirit)
	addtimer(CALLBACK(src, PROC_REF(end_spook), H, spirit), 20 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/self/spook_scry/proc/end_spook(mob/living/carbon/human/H, mob/living/simple_animal/spook_spirit/spirit)
	if(QDELETED(H))
		qdel(spirit)
		return
	if(spirit.mind)
		spirit.mind.transfer_to(H)
	qdel(spirit)

/obj/effect/proc_holder/spell/self/witch_possess
	name = "Witchery"
	desc = "Possess cat, or return to body."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "tame_deadite"
	recharge_time = 10 SECONDS
	chargedloop = null
	var/mob/living/simple_animal/pet/cat/rogue/black/cat
	var/mob/living/carbon/human/body

/obj/effect/proc_holder/spell/self/witch_possess/cast(list/targets, mob/user = usr)
	. = ..()
	if(user == cat)
		if(body && cat.mind)
			cat.mind.transfer_to(body)
		return TRUE
	if(!ishuman(user))
		revert_cast()
		return FALSE
	if(!cat || QDELETED(cat))
		cat = new(get_turf(user))
	if(cat.mind)
		to_chat(user, span_warning("NOT WORKING."))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	body = H
	H.mind.transfer_to(cat)
	return TRUE

/datum/ritual/noise/witchery
	name = "Witchery"
	desc = "Summon a black cat. You are able to remotely possess it at any time and see through its eyes."
	passive = TRUE
	research_cost = 3

/datum/ritual/noise/witchery/apply_passive(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/witch_possess)
	return

/datum/ritual/noise/forgettongue
	name = "Curse of Babel"
	desc = "Curse your target to forget the common tongue and become illiterate. Requires a leech that fed from your target."
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/noise/forgettongue/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	if(!curse_target(remnant.fed_from))
		to_chat(user, span_warning("THEY ARE PROTECTED FROM FURTHER CURSES."))
		return
	remnant.fed_from.remove_language(/datum/language/common, source = LANGUAGE_SOURCE_ALL)
	remnant.fed_from.adjust_skillrank(/datum/skill/misc/reading, -6, TRUE)
	to_chat(remnant.fed_from, span_danger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("IT EATS AWAY MEANING AND LEAVES NOTHING BUT NOISE."))

// PITCH

/datum/component/light_vulnerability
	var/burn_damage = 5

/datum/component/light_vulnerability/Initialize(damage = 5, duration = 0)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	burn_damage = damage
	if(duration)
		QDEL_IN(src, duration)
	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(check_light))

/datum/component/light_vulnerability/proc/check_light(mob/living/carbon/human/H)
	if(!ishuman(H) || H.stat == DEAD)
		return
	var/turf/T = get_turf(H)
	if(T && T.get_lumcount() >= 0.75)
		H.adjustFireLoss(burn_damage)
		if(prob(30))
			to_chat(H, span_danger("THE LIGHT BURNS!"))

/datum/status_effect/shadowform
	id = "shadowform"
	duration = -1
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/shadowform

/datum/status_effect/shadowform/tick()
	var/turf/T = get_turf(owner)
	if(T && T.get_lumcount() < 0.75)
		owner.adjustBruteLoss(-5)
		owner.adjustFireLoss(-5)
	for(var/obj/item/I in owner.get_equipped_items() + owner.held_items)
		I.fire_act()
	for(var/obj/item/grabbing/G in owner.held_items)
		if(isliving(G.grabbed))
			var/mob/living/victim = G.grabbed
			victim.fire_act(2, 20)
			victim.adjustFireLoss(10)

/atom/movable/screen/alert/status_effect/shadowform
	name = "SCADUFORM"
	desc = ""
	icon_state = "buff"

/obj/effect/proc_holder/spell/invoked/shadow_snuff
	name = "Snuff"
	desc = "Snuff out a fire or light."
	range = 7
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "zizocandle"
	recharge_time = 2 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/invoked/shadow_snuff/cast(list/targets, mob/living/user)
	. = ..()
	var/atom/target = targets[1]
	if(!target)
		return FALSE
	if(isobj(target))
		var/obj/O = target
		O.extinguish()
	for(var/obj/O in target.contents)
		O.extinguish()
	return TRUE

/obj/effect/dummy/phased_mob/slaughter/shadow/relaymove(mob/user, direction)
	var/turf/dest = get_step(src, direction)
	if(!dest || dest.get_lumcount() >= 0.75)
		to_chat(user, span_warning("THERE IS LIGHT THERE."))
		return
	forceMove(dest)

/obj/effect/proc_holder/spell/self/shadow_jaunt
	name = "Scadu Jaunt"
	desc = "Turn invisible and move through walls. Only functions in darkness."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "zizocloud"
	recharge_time = 1 MINUTES
	chargedloop = null

/obj/effect/proc_holder/spell/self/shadow_jaunt/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/turf/T = get_turf(user)
	if(T.get_lumcount() >= 0.75)
		to_chat(user, span_warning("IT'S TOO BRIGHT!"))
		revert_cast()
		return FALSE
	var/obj/effect/dummy/phased_mob/slaughter/shadow/holder = new(T)
	user.visible_message(span_warning("[user] melts into the shadows."))
	user.forceMove(holder)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, end_jaunt), holder), 5 SECONDS)
	return TRUE

/datum/ritual/pitch/fireresist
	name = "Fire Resistance"
	desc = "Become immune to fire."
	passive = TRUE
	research_cost = 3

/datum/ritual/pitch/fireresist/apply_passive(mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_NOFIRE, TRAIT_GENERIC)
	return

/datum/ritual/pitch/shadowform
	name = "Scaduform"
	desc = "Transform into a dark shadow that takes damage in the light. You can jaunt through darkness and remotely snuff lights. Your body becomes inhumen, recognizably monstrous, but non-living and immune to bloodloss. Anything you touch is lit aflame, including equipment on the body. And people you grab."
	center_requirement = /mob/living/carbon/human

/datum/ritual/pitch/shadowform/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		to_chat(user, span_warning("NOT FOR THEM."))
		return
	if(target.has_status_effect(/datum/status_effect/shadowform))
		return
	if(!target.dna)
		return
	var/poo = new /obj/effect/temp_visual/opengate/fivesec(center)
	playsound(user, 'sound/villain/littlescary2.ogg', 60, TRUE)
	if(!do_after(user, 5 SECONDS))
		qdel(poo)
		return
	target.dna.species.species_traits |= MUTCOLORS
	target.dna.species.fixed_mut_color = "000000"
	target.dna.features["mcolor"] = "000000"
	target.update_body()
	target.update_hair()
	for(var/obj/item/bodypart/BP in target.bodyparts)
		for(var/datum/bodypart_feature/F in BP.bodypart_features)
			if(F.accessory_type)
				F.accessory_colors = recolor_accessory(F.accessory_type, "000000")
		BP.invalidate_limb_cache()
	for(var/obj/item/organ/O in target.internal_organs)
		if(O.accessory_type)
			O.accessory_colors = recolor_accessory(O.accessory_type, "000000")
	target.icon_render_key = null
	target.update_body_parts()
	target.apply_status_effect(/datum/status_effect/shadowform)
	target.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadow_snuff)
	target.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/shadow_jaunt)
	target.AddComponent(/datum/component/light_vulnerability)
	for(var/obj/item/I in target.get_equipped_items() + target.held_items)
		I.fire_act()
	var/obj/item/organ/eyes/eyes = target.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(target, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision
	eyes.Insert(target)
	ADD_TRAIT(target, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOMETABOLISM, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_MONSTROUS, TRAIT_GENERIC)
	target.dna.species.name = "???"
	target.emote("scream")
	target.Knockdown(5 SECONDS)
	to_chat(target, span_danger("IT BURNS! IT BURNS! IT STICKS TO MY FLESH AND BURNS!"))

/datum/ritual/pitch/lightcurse
	name = "Curse of Radiance"
	desc = "Curse a target to burn in the light. Requires a leech that fed from your target."
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/pitch/lightcurse/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	if(!curse_target(remnant.fed_from))
		to_chat(user, span_warning("THEY ARE PROTECTED FROM FURTHER CURSES."))
		return
	remnant.fed_from.AddComponent(/datum/component/light_vulnerability, 10, 10 MINUTES)
	to_chat(remnant.fed_from, span_danger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("THEY SHALL KNOW MY HATRED OF HIS LIGHT."))

// BLOOD

/obj/structure/trap/zizo
	name = "bloody sigil"
	desc = "Strange runics smeared in blood."
	icon = 'icons/obj/sigils.dmi'
	icon_state = "center"
	alpha = 45
	charges = 3
	var/effect = "bleed"

/obj/structure/trap/zizo/Crossed(atom/movable/AM)
	if(is_zizo(AM))
		return
	. = ..()

/obj/structure/trap/zizo/trap_effect(mob/living/L)
	switch(effect)
		if("poison")
			if(L.reagents)
				L.reagents.add_reagent(/datum/reagent/berrypoison, 15)
			L.emote("scream")
			L.Jitter(4)
			L.visible_message(span_danger("THE SIGIL SPRAYS [L] WITH FOUL BLOOD!"))
		if("stun")
			L.electrocute_act(20, src)
			L.Paralyze(60)
			L.emote("scream")
		else
			L.adjustBruteLoss(125)
			L.emote("scream")
			L.Jitter(4)
			L.visible_message(span_danger("BLOODY BLADES RISE FROM THE GROUND AND REND [L]!"))

/datum/ritual/blood/transfuse
	name = "Sigil Expertise"
	desc = "Draw sigils much faster, and without bloody hands."
	passive = TRUE
	research_cost = 2

/datum/ritual/blood/transfuse/apply_passive(mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_BLOODBOUND, TRAIT_GENERIC)
	return

/datum/ritual/blood/bloodsnare
	name = "Blood Snare"
	desc = "Create a translucent sigil trap that harms whoever steps onto it. Organs create a poison trap, weapons create a stunning trap, and anything else creates a bleeding trap."
	center_requirement = /obj/item
	keep_center = TRUE

/datum/ritual/blood/bloodsnare/invoke(mob/living/user, turf/center)
	var/effect = "bleed"
	if(locate(/obj/structure/trap/zizo) in center)
		return FALSE
	if(locate(/obj/item/organ) in center)
		effect = "poison"
	else if(locate(/obj/item/rogueweapon) in center)
		effect = "stun"
	for(var/obj/item/I in center)
		qdel(I)
	for(var/obj/effect/decal/cleanable/sigil/sig in range(1, center))
		qdel(sig)
	var/obj/structure/trap/zizo/T = new(center)
	T.effect = effect
	to_chat(user, span_notice("THE SIGIL FADES. IT IS READY."))

/datum/status_effect/bloodlink
	id = "bloodlink"
	duration = 10 MINUTES
	tick_interval = 5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/bloodlink
	var/mob/living/carbon/human/partner

/datum/status_effect/bloodlink/on_creation(mob/living/new_owner, mob/living/carbon/human/linked)
	partner = linked
	. = ..()

/datum/status_effect/bloodlink/on_apply()
	. = ..()
	to_chat(owner, span_danger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	owner.emote("scream")

/datum/status_effect/bloodlink/tick()
	if(QDELETED(partner) || partner.stat == DEAD)
		qdel(src)
		return
	if(get_dist(owner, partner) > 7)
		owner.adjustOxyLoss(4)
		owner.Jitter(4)
		if(prob(30))
			to_chat(owner, span_danger("My chest aches! Where is [partner.real_name]?!"))

/atom/movable/screen/alert/status_effect/bloodlink
	name = "Blood Bond"
	desc = "OUR HEARTS BEAT AS ONE. I MUST BE NEAR THEM."
	icon_state = "debuff"

/datum/ritual/blood/bloodbond
	name = "Curse of Blood"
	desc = "Curse two targets to slowly die when apart from each other. Requires two leeches that fed from separate targets."
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/blood/bloodbond/invoke(mob/living/user, turf/center)
	var/list/found = list()
	for(var/obj/item/natural/worms/leech/L in center)
		if(L.fed_from && L.blood_storage > 0 && !QDELETED(L.fed_from) && L.fed_from.stat != DEAD)
			found += L
	if(found.len < 2)
		to_chat(user, span_warning("This rite needs two leeches."))
		return
	var/obj/item/natural/worms/leech/L1 = found[1]
	var/obj/item/natural/worms/leech/L2 = found[2]
	var/mob/living/carbon/human/A = L1.fed_from
	var/mob/living/carbon/human/B = L2.fed_from
	if(A == B)
		to_chat(user, span_warning("You can not bind someone to theirself. Fool!"))
		return
	if(A.has_status_effect(/datum/status_effect/buff/curse_immunity) || B.has_status_effect(/datum/status_effect/buff/curse_immunity))
		to_chat(user, span_warning("THEY ARE PROTECTED FROM FURTHER CURSES."))
		return
	curse_target(A)
	curse_target(B)
	A.apply_status_effect(/datum/status_effect/bloodlink, B)
	B.apply_status_effect(/datum/status_effect/bloodlink, A)
	qdel(L1)
	qdel(L2)
	to_chat(user, span_notice("I BIND [A] AND [B], THEIR HEARTS BEAT AS ONE."))
