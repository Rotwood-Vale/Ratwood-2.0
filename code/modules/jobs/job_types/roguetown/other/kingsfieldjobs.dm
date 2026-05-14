// Add Kingsfield category tag for joinlate menu section
#define CTAG_KINGSFIELD "ctag_kingsfield"

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
	. = ..()
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
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
	)

/datum/job/roguetown/ferrentian_envoy
	title = "Ferrentian Envoy"
	faction = "Station"
	total_positions = 99
	spawn_positions = 0
	selection_color = "#8d8f78"
	allowed_races = RACES_ALL_KINDS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "You are a Ferrentian envoy operating in Kingsfield under special authority."
	outfit = /datum/outfit/job/roguetown/ferrentian_envoy
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
	job_traits = list(TRAIT_NOBLE)
	social_rank = SOCIAL_RANK_NOBLE

/datum/job/roguetown/ferrentian_envoy/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	apply_kingsfield_join_fade(L)

/datum/job/roguetown/ferrentian_envoy/special_job_check(mob/dead/new_player/player)
	return !!(player?.client?.holder)

/datum/job/roguetown/ferrentian_envoy/special_check_latejoin(client/C)
	return !!(C?.holder)

/datum/job/roguetown/ferrentian_envoy/override_latejoin_spawn(mob/living/carbon/human/H)
	return TRUE  // Use custom spawn location

/datum/outfit/job/roguetown/ferrentian_envoy/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(should_wear_femme_clothes(H))
		armor = pick(list(
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
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/diplomatic = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
	)

// Spawn landmark for Ferrentian Envoy arrivals. Place this in the Kingsfield map where envoys should appear.
/obj/effect/landmark/start/ferrentian_envoy
	name = "Ferrentian Envoy Spawn"
	jobspawn_override = list("Ferrentian Envoy")
