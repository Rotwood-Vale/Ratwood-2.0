// =====================================================
// BLOOD RED
// A deep crimson draught that strips the body's strength
// and drops the drinker cold for a minute.
// =====================================================

/datum/reagent/blood_red
	name = "Blood Red"
	description = "Whatever's in this, it isn't wine."
	color = "#8B0000"
	metabolization_rate = 0.5
	reagent_state = LIQUID

/datum/reagent/blood_red/on_mob_add(mob/living/L)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	H.apply_status_effect(/datum/status_effect/debuff/blood_red_drain)
	H.SetSleeping(1 MINUTES)

/datum/reagent/blood_red/on_mob_life(mob/living/carbon/M)
	M.blood_volume = min(M.blood_volume + 25, BLOOD_VOLUME_NORMAL)
	..()
	. = 1

/datum/status_effect/debuff/blood_red_drain
	id = "blood_red_drain"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_red_drain
	effectedstats = list(
		STATKEY_STR = -3,
		STATKEY_PER = -3,
		STATKEY_INT = -3,
		STATKEY_CON = -3,
		STATKEY_WIL = -3,
		STATKEY_SPD = -3,
		STATKEY_LCK = -3,
	)
	duration = 5 MINUTES

/atom/movable/screen/alert/status_effect/debuff/blood_red_drain
	name = "Drained"
	desc = "Something in that drink has taken the fight out of me."
	icon_state = "debuff"

/obj/item/reagent_containers/glass/bottle/rogue/blood_red
	name = "Blood Red"
	desc = "A dark bottle of something crimson. The smell is medicinal, but not pleasantly so."
	volume = 130
	list_reagents = list(
		/datum/reagent/blood_red = 50,
		/datum/reagent/medicine/healthpot = 30,
		/datum/reagent/medicine/stronghealth = 30,
		/datum/reagent/water/blessed = 20,
	)

// =====================================================
// VOSS SERUM
// Thin and pale. Goes down easy and makes you regret it.
// =====================================================

/datum/reagent/voss_serum
	name = "Voss Serum"
	description = "A cloudy, pale fluid. Warm to the touch."
	color = "#d4c8a8"
	metabolization_rate = 0.5
	reagent_state = LIQUID

/datum/reagent/voss_serum/on_mob_add(mob/living/L)
	if(!ishuman(L))
		return
	L.reagents.add_reagent(/datum/reagent/infection, rand(4, 8))

/obj/item/reagent_containers/glass/bottle/rogue/voss_serum
	name = "Voss Serum"
	desc = "A small bottle of pale liquid. Unmarked. It smells faintly biological."
	list_reagents = list(/datum/reagent/voss_serum = 50)
