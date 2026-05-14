// Add Kingsfield category tag for joinlate menu section
#define CTAG_KINGSFIELD "ctag_kingsfield"
#define KINGSFIELD_PACIFISM_TRAIT "kingsfield_pacifism"

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

/datum/job/roguetown/kingsfield_visitor
	title = "Kingsfield Visitor"
	faction = "Station"
	total_positions = 99
	spawn_positions = 0
	selection_color = "#8d8f78"
	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "You have arrived in Kingsfield as a humble visitor."
	outfit = /datum/outfit/job/roguetown/kingsfield_visitor
	display_order = JDO_PILGRIM
	show_in_credits = FALSE
	announce_latejoin = FALSE
	always_show_on_latechoices = TRUE
	min_pq = 0
	max_pq = null
	can_random = FALSE
	bypass_jobban = TRUE
	bypass_lastclass = TRUE
	category_tags = list(CTAG_KINGSFIELD)

/datum/job/roguetown/kingsfield_visitor/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	if(L?.mind)
		L.mind.remove_all_antag_datums()
	. = ..()
	ADD_TRAIT(L, TRAIT_PACIFISM, KINGSFIELD_PACIFISM_TRAIT)
	ADD_TRAIT(L, TRAIT_NOHUNGER, TRAIT_GENERIC)
	L.nutrition = NUTRITION_LEVEL_FULL
	L.hydration = HYDRATION_LEVEL_FULL
	L.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
	L.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_NOVICE, TRUE)
	L.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_NOVICE, TRUE)
	apply_kingsfield_join_fade(L)

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
	spawn_positions = 0
	selection_color = "#8d8f78"
	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "You are a Ferentian envoy operating in Kingsfield under special authority."
	outfit = /datum/outfit/job/roguetown/ferentian_envoy
	display_order = JDO_PILGRIM
	show_in_credits = FALSE
	announce_latejoin = FALSE
	always_show_on_latechoices = FALSE // Only show if admin
	min_pq = 0
	max_pq = null
	can_random = FALSE
	bypass_jobban = TRUE
	bypass_lastclass = TRUE
	category_tags = list(CTAG_KINGSFIELD)
	job_traits = list(TRAIT_NOBLE)
	social_rank = SOCIAL_RANK_NOBLE

/datum/job/roguetown/ferentian_envoy/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	if(L?.mind)
		L.mind.remove_all_antag_datums()
	. = ..()
	ADD_TRAIT(L, TRAIT_PACIFISM, KINGSFIELD_PACIFISM_TRAIT)
	ADD_TRAIT(L, TRAIT_NOHUNGER, TRAIT_GENERIC)
	L.nutrition = NUTRITION_LEVEL_FULL
	L.hydration = HYDRATION_LEVEL_FULL
	L.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_JOURNEYMAN, TRUE)
	L.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE)
	L.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_NOVICE, TRUE)
	apply_kingsfield_join_fade(L)

/datum/job/roguetown/ferentian_envoy/special_job_check(mob/dead/new_player/player)
	return !!(player?.client?.holder)

/datum/job/roguetown/ferentian_envoy/special_check_latejoin(client/C)
	// Only show in latejoin menu for admins
	return !!(C?.holder)

/datum/job/roguetown/ferentian_envoy/override_latejoin_spawn(mob/living/carbon/human/H)
	var/list/eligible_spawns = list()
	for(var/obj/effect/landmark/start/ferentian_envoy/S in GLOB.start_landmarks_list)
		if(S.loc)
			eligible_spawns += S
	if(eligible_spawns.len)
		var/obj/effect/landmark/start/S = pick(eligible_spawns)
		if(H && S && S.loc)
			H.forceMove(S.loc)
			return TRUE
	return FALSE

/datum/outfit/job/roguetown/ferentian_envoy/pre_equip(mob/living/carbon/human/H)
	. = ..()
	armor = null
	if(should_wear_femme_clothes(H))
		shirt = pick(list(
			/obj/item/clothing/suit/roguetown/shirt/dress/silkdress,
			/obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/blue,
		))
		pants = pick(list(
			/obj/item/clothing/under/roguetown/tights,
			/obj/item/clothing/under/roguetown/tights/black,
			/obj/item/clothing/under/roguetown/tights/random,
		))
	else
		shirt = pick(list(
			/obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold,
			/obj/item/clothing/suit/roguetown/shirt/dress/thawb/random,
		))
		pants = pick(list(
			/obj/item/clothing/under/roguetown/sirwal/fancy/random,
			/obj/item/clothing/under/roguetown/tights/black,
		))
		if(prob(50))
			head = /obj/item/clothing/head/roguetown/turban/fancypurple
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/diplomatic = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
	)

// Spawn landmark for Ferentian Envoy arrivals. Place this in the Kingsfield map where envoys should appear.
/obj/effect/landmark/start/ferentian_envoy
	name = "Ferentian Envoy Spawn"
	icon_state = "arrow"
	jobspawn_override = list("Ferentian Envoy")
	delete_after_roundstart = FALSE

