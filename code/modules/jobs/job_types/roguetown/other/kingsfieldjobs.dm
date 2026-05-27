// Add Kingsfield category tag for joinlate menu section
#define CTAG_KINGSFIELD "ctag_kingsfield"
#define KINGSFIELD_PACIFISM_TRAIT "kingsfield_pacifism"
#define KINGSFIELD_WELCOME_TEXT "Kingsfield is an area that exists 'outside' of the current round. It IS however, still expected that you will remain IN character and not break our normal server rules. You are allowed to join/fartravel to and from Kingsfield as much as you wish, you do not need to ask permission, to allow you to try loadouts, clothing etc. Once you arrive here, DO NOT then rejoin the main game as the same character if you were in the round previously.\n\n\n\
Upstairs in the tavern there is a dedicated dressing room with free silverfaces and similar, feel free to try different outfits! There are also free silverfaces for the various merchants in appropriate locations, as well as a vomitorium in the tavern kitchen, if you wish to experiment with cooking and serving.\n\n\n\
Combat of any kind is NOT allowed anywhere in Kingsfield EXCEPT for in the duelling arena beneath the street. A pacifism trait is applied to all visitors, but within the duel arena (only the actual cage area), this pacifism will turn off. Duelling/Fighting in here is fine. The arena back area has silverfaces for the smithy/tailor as well as the apothecary for healing items.\n\n\n\
The Tavern has a variety of rooms upstairs you can use, and visitors are able to claim one of the doors in a similar fashion to towner houses. If someone is using one of these rooms, please do not disturb them. If you finish using a room, please leave the key outside the room so others may use it if they wish.\n\n\n\
While this area is IN character, there is a dedicated area specifically where OOC discussion IS allowed, called 'The Gutter'. To visit, take the stairs down in front of the tavern, and use the travel tile. Please remember that OOC chatter of ANY kind is ONLY allowed in The Gutter and speaking out of character in the rest of Kingsfield is a rulebreak and will be punished appropriately.\n\n\n\
Enjoy!"

/proc/apply_kingsfield_join_fade(mob/living/L)
	set waitfor = FALSE
	if(!L?.client)
		return

	var/atom/movable/screen/F = new /atom/movable/screen/fullscreen/fade()
	F.alpha = 0
	L.client.screen += F

	// Fade to black and back over a total of ~2-3 seconds.
	animate(F, alpha = 255, time = 5)
	sleep(rand(10, 20))
	if(!L?.client)
		qdel(F)
		return

	animate(F, alpha = 0, time = 5)
	sleep(5)
	if(L?.client)
		L.client.screen -= F
	qdel(F)

/proc/show_kingsfield_welcome(mob/living/L)
	set waitfor = FALSE
	if(!L)
		return

	// Delay slightly so the transfer and arrival fade can complete before showing the rules.
	sleep(3 SECONDS)
	if(!L?.client)
		return

	tgui_alert(L, KINGSFIELD_WELCOME_TEXT, "Welcome to Kingsfield", list("I understand the rules"), can_close = FALSE)

/proc/apply_kingsfield_training(mob/living/L)
	if(!L)
		return
	var/list/kingsfield_training_skills = list(
		/datum/skill/combat/knives,
		/datum/skill/combat/swords,
		/datum/skill/combat/polearms,
		/datum/skill/combat/maces,
		/datum/skill/combat/axes,
		/datum/skill/combat/whipsflails,
		/datum/skill/combat/bows,
		/datum/skill/combat/crossbows,
		/datum/skill/combat/slings,
		/datum/skill/combat/staves,
		/datum/skill/combat/firearms,
		/datum/skill/combat/shields,
		/datum/skill/misc/medicine,
		/datum/skill/craft/cooking,
	)
	for(var/skill_path in kingsfield_training_skills)
		L.adjust_skillrank_up_to(skill_path, SKILL_LEVEL_JOURNEYMAN, TRUE)

/proc/reset_for_kingsfield_arrival(mob/living/L)
	if(!L || !ishuman(L))
		return

	var/mob/living/carbon/human/H = L

	// Keep character customization baselines (race/age/statpack), wipe role-derived stats.
	H.roll_stats()

	// Wipe all learned skills so Kingsfield applies a predictable visitor baseline.
	for(var/skill_type in subtypesof(/datum/skill))
		var/current_rank = H.get_skill_level(skill_type)
		if(current_rank > 0)
			H.adjust_skillrank(skill_type, -current_rank, TRUE)

	if(H.mind)
		H.mind.RemoveAllSpells()
		H.mind.spell_points = 0
		H.mind.used_spell_points = 0
		H.mind.has_changed_spell = FALSE
		if(H.mind.has_rituos)
			H.mind.has_rituos = FALSE
		if(H.mind.rituos_spell)
			H.mind.RemoveSpell(H.mind.rituos_spell)
			H.mind.rituos_spell = null

	// Clear devotion/miracle progression so miracle abilities cannot repopulate.
	if(H.devotion)
		QDEL_NULL(H.devotion)
	H.miracle_points = 0
	H.church_favor = 0
	H.verbs -= list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)

	// Remove legal/religious world-state flags tied to their identity.
	if(H.real_name in GLOB.excommunicated_players)
		GLOB.excommunicated_players -= H.real_name
	if(H.real_name in GLOB.outlawed_players)
		GLOB.outlawed_players -= H.real_name
	if(H.name in GLOB.excommunicated_players)
		GLOB.excommunicated_players -= H.name
	if(H.name in GLOB.outlawed_players)
		GLOB.outlawed_players -= H.name

	// Remove role/class-applied traits while preserving customization and innate sources.
	if(H.status_traits)
		for(var/trait in H.status_traits.Copy())
			if(HAS_TRAIT_FROM(H, trait, JOB_TRAIT))
				REMOVE_TRAIT(H, trait, JOB_TRAIT)
			if(HAS_TRAIT_FROM(H, trait, TRAIT_GENERIC))
				REMOVE_TRAIT(H, trait, TRAIT_GENERIC)

	H.cmode_music = null

	// Remove temporary martial arts granted by jobs/class systems.
	if(H.mind?.martial_art?.base)
		H.mind.martial_art.remove(H)

/proc/apply_kingsfield_role_setup(mob/living/L, reading_level, athletics_level)
	if(!L)
		return
	ADD_TRAIT(L, TRAIT_PACIFISM, KINGSFIELD_PACIFISM_TRAIT)
	ADD_TRAIT(L, TRAIT_NOHUNGER, TRAIT_GENERIC)
	L.nutrition = NUTRITION_LEVEL_FULL
	L.hydration = HYDRATION_LEVEL_FULL
	L.adjust_skillrank_up_to(/datum/skill/misc/reading, reading_level, TRUE)
	L.adjust_skillrank_up_to(/datum/skill/misc/athletics, athletics_level, TRUE)
	L.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_NOVICE, TRUE)
	apply_kingsfield_training(L)
	apply_kingsfield_join_fade(L)
	show_kingsfield_welcome(L)

/proc/is_kingsfield_spawn_turf(turf/T)
	if(!T)
		return FALSE
	var/area/spawn_area = get_area(T)
	return is_kingsfield_area(spawn_area)

/proc/is_kingsfield_area(area/A)
	if(!A)
		return FALSE
	return istype(A, /area/rogue/outdoors/kingsfield) || istype(A, /area/rogue/indoors/kingsfield) || istype(A, /area/rogue/under/kingsfield)

/proc/enforce_kingsfield_role_area(mob/living/L, area/current_area)
	var/static/list/last_kingsfield_enforcement_log = list()
	var/static/kingsfield_enforcement_log_cooldown = 5 MINUTES

	if(!L?.mind)
		return FALSE
	if(!(L.mind.assigned_role in GLOB.kingsfield_positions))
		return FALSE
	if(is_kingsfield_area(current_area))
		return FALSE

	var/turf/return_turf = get_kingsfield_spawn_turf_for_job(L.mind.assigned_role)
	if(!return_turf)
		return_turf = get_kingsfield_spawn_turf_for_job("Kingsfield Visitor")
	if(!return_turf)
		return FALSE

	if(get_turf(L) == return_turf)
		return FALSE

	var/log_key = L.ckey ? L.ckey : "[REF(L)]"
	var/last_log_time = last_kingsfield_enforcement_log[log_key]
	if(isnull(last_log_time) || world.time >= (last_log_time + kingsfield_enforcement_log_cooldown))
		var/msg = "Kingsfield safeguard: [key_name(L)] as [L.mind.assigned_role] entered [current_area ? current_area.name : "unknown area"] at [AREACOORD(L)] and was returned to Kingsfield at [AREACOORD(return_turf)]."
		message_admins(msg)
		log_admin(msg)
		last_kingsfield_enforcement_log[log_key] = world.time

	L.forceMove(return_turf)
	to_chat(L, span_warning("You are returned to Kingsfield."))
	return TRUE

/proc/get_kingsfield_spawn_turf_for_job(jobname)
	var/list/landmarks = list()
	for(var/obj/effect/landmark/start/sloc as anything in GLOB.jobspawn_overrides[jobname])
		if(QDELETED(sloc))
			continue
		var/turf/spawn_turf = get_turf(sloc)
		if(!is_kingsfield_spawn_turf(spawn_turf))
			continue
		landmarks += spawn_turf
	if(!length(landmarks))
		return null
	return pick(landmarks)

/datum/job/roguetown/kingsfield_visitor
	title = "Kingsfield Visitor"
	faction = "Station"
	total_positions = 99
	spawn_positions = 99
	selection_color = "#8d8f78"
	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "You have arrived in Kingsfield as a humble visitor."
	outfit = /datum/outfit/job/roguetown/kingsfield_visitor
	display_order = JDO_KINGSFIELD_VISITOR
	show_in_credits = FALSE
	announce_latejoin = FALSE
	always_show_on_latechoices = TRUE
	min_pq = 0
	max_pq = null
	can_random = FALSE
	bypass_jobban = TRUE
	bypass_lastclass = TRUE
	show_position_indicators = FALSE
	category_tags = list(CTAG_KINGSFIELD)

/datum/job/roguetown/kingsfield_visitor/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	if(L?.mind)
		L.mind.remove_all_antag_datums()
		L.mind.special_role = null
	reset_for_kingsfield_arrival(L)
	. = ..()
	apply_kingsfield_role_setup(L, SKILL_LEVEL_APPRENTICE, SKILL_LEVEL_NOVICE)

/datum/job/roguetown/kingsfield_visitor/special_job_check(mob/dead/new_player/player)
	return !!get_kingsfield_spawn_turf_for_job("Kingsfield Visitor")

/datum/job/roguetown/kingsfield_visitor/special_check_latejoin(client/C)
	return !!get_kingsfield_spawn_turf_for_job("Kingsfield Visitor")

/datum/job/roguetown/kingsfield_visitor/override_latejoin_spawn(mob/living/carbon/human/H)
	var/turf/spawn_turf = get_kingsfield_spawn_turf_for_job("Kingsfield Visitor")
	if(!spawn_turf)
		to_chat(H, span_warning("I cannot find passage to Kingsfield right now."))
		return FALSE
	H.forceMove(spawn_turf)
	return TRUE

/datum/outfit/job/roguetown/kingsfield_visitor/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(should_wear_femme_clothes(H))
		shirt = pick(list(
			/obj/item/clothing/suit/roguetown/shirt/dress/silkdress,
			/obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/blue,
			/obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold,
		))
		pants = pick(list(
			/obj/item/clothing/under/roguetown/tights/black,
			/obj/item/clothing/under/roguetown/tights,
			/obj/item/clothing/under/roguetown/tights/random,
		))
	else
		shirt = pick(list(
			/obj/item/clothing/suit/roguetown/shirt/undershirt,
			/obj/item/clothing/suit/roguetown/shirt/shortshirt,
			/obj/item/clothing/suit/roguetown/shirt/tunic/purple,
			/obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold,
		))
		pants = pick(list(
			/obj/item/clothing/under/roguetown/tights,
			/obj/item/clothing/under/roguetown/trou,
			/obj/item/clothing/under/roguetown/sirwal/plainrandom,
		))
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
	)

/datum/job/roguetown/ferentian_envoy
	title = "Ferentian Envoy"
	faction = "Station"
	total_positions = 99
	spawn_positions = 99
	selection_color = "#8d8f78"
	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "You are a Ferentian envoy operating in Kingsfield under special authority."
	outfit = /datum/outfit/job/roguetown/ferentian_envoy
	display_order = JDO_FERENTIAN_ENVOY
	show_in_credits = FALSE
	announce_latejoin = FALSE
	always_show_on_latechoices = FALSE // Only show if admin
	min_pq = 0
	max_pq = null
	can_random = FALSE
	bypass_jobban = TRUE
	bypass_lastclass = TRUE
	show_position_indicators = FALSE
	category_tags = list(CTAG_KINGSFIELD)
	job_traits = list(TRAIT_NOBLE)
	social_rank = SOCIAL_RANK_NOBLE

/datum/job/roguetown/ferentian_envoy/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	if(L?.mind)
		L.mind.remove_all_antag_datums()
		L.mind.special_role = null
	reset_for_kingsfield_arrival(L)
	. = ..()
	apply_kingsfield_role_setup(L, SKILL_LEVEL_JOURNEYMAN, SKILL_LEVEL_APPRENTICE)

/datum/job/roguetown/ferentian_envoy/special_job_check(mob/dead/new_player/player)
	return !!(player?.client?.holder) && !!get_kingsfield_spawn_turf_for_job("Ferentian Envoy")

/datum/job/roguetown/ferentian_envoy/special_check_latejoin(client/C)
	return !!(C?.holder) && !!get_kingsfield_spawn_turf_for_job("Ferentian Envoy")

/datum/job/roguetown/ferentian_envoy/override_latejoin_spawn(mob/living/carbon/human/H)
	var/turf/spawn_turf = get_kingsfield_spawn_turf_for_job("Ferentian Envoy")
	if(spawn_turf)
		H.forceMove(spawn_turf)
		return TRUE
	to_chat(H, span_warning("I cannot find the Ferentian envoy post right now."))
	return FALSE

/datum/outfit/job/roguetown/ferentian_envoy/pre_equip(mob/living/carbon/human/H)
	. = ..()
	armor = null
	head = null
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
		pants = /obj/item/clothing/under/roguetown/tights/black
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
		pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/kfenvoy
	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
	)

// Spawn landmark for Ferentian Envoy arrivals. Place this in the Kingsfield map where envoys should appear.
/obj/effect/landmark/start/ferentian_envoy
	name = "Ferentian Envoy Spawn"
	icon_state = "arrow"
	jobspawn_override = list("Ferentian Envoy")
	delete_after_roundstart = FALSE

