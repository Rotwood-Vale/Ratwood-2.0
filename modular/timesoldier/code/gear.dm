// meds meds i love drugs im a c*rckhead!!!

/obj/item/timesoldier/medical
	name = "medical supplies"
	desc = "this should not exist!!!"
	w_class = WEIGHT_CLASS_SMALL
	var/uses = 8
	var/brute_heal = 0
	var/burn_heal = 0
	var/treatment_time = 3 SECONDS
	grid_width = 32
	grid_height = 32 // smol

/obj/item/timesoldier/medical/proc/can_treat(obj/item/bodypart/affecting)
	if(!affecting)
		return FALSE
	
	if(brute_heal > 0 && affecting.brute_dam > 0)
		return TRUE
	
	if(burn_heal > 0 && affecting.burn_dam > 0)
		return TRUE
	
	return FALSE

/obj/item/timesoldier/medical/attack(mob/living/M, mob/living/user, def_zone)
	if(user.used_intent.type == INTENT_HARM || user.cmode)
		return ..()
	
	if(!ishuman(M))
		to_chat(user, span_warning("I can't use [src] on that.."))
		return
	
	var/mob/living/carbon/human/H = M
	var/zone = check_zone(def_zone)
	var/obj/item/bodypart/affecting = H.get_bodypart (zone) // just copying from surgery.

	if(!affecting)
		to_chat(user, span_warning("There's nothing to treat there."))
		return
	
	if(affecting.status == BODYPART_ROBOTIC)
		to_chat(user, span_warning("[src] won't do anything for a mechanical limb..")) // i almost forgot about prosthethics ngl
		return 

	if(!can_treat(affecting))
		to_chat(user, span_warning("[H == user ? "My" : "[H]'s"] [affecting.name] doesn't need this treatment.."))
		return

	user.visible_message(
		span_notice("[user] begins treating [H]'s [affecting.name] with [src]."),
		span_notice("I begin treating [H == user ? "my" : "[H]'s"] [affecting.name] with [src].")
	)

	if(!do_after(user, treatment_time, target = H))
		return
	// we check the limb again after the do_after. it could be removed, healed or otherwise changed while or after we treat it.
	affecting = H.get_bodypart(zone)

	if(!affecting)
		return
	
	if(affecting.status == BODYPART_ROBOTIC)
		return

	if(!can_treat(affecting))
		to_chat(user, span_warning("[H == user ? "My" : "[H]'s"] [affecting.name] no longer needs this treatment.."))
		return

	affecting.heal_damage(brute_heal, burn_heal)
	H.update_damage_overlays()

	uses--

	user.visible_message(
		span_notice("[user] finishes treating [H]'s [affecting.name] with [src]."),
		span_notice("I finish treating [H == user ? "my" : "[H]'s"] [affecting.name] with [src].")
	)

	if(uses > 0)
		to_chat(user, span_info("[src] has [uses] applications remaining."))
	else
		to_chat(user, span_warning("I use the last of [src]."))
		qdel(src)

// items!!

/obj/item/timesoldier/medical/bruise
	name = "field trauma kit"
	desc = "A compact collection of sterile dressings, compression bandages and other such supplies. Far beyond anything a local chirurgeon could readily produce, but this would definitely come from Kingsfield's Military"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	icon_state = "traumakit" // temporary sprite until i make something myself.
	uses = 8
	brute_heal = 35
	burn_heal = 0
	treatment_time = 3 SECONDS

/obj/item/timesoldier/medical/burn
	name = "field dressing kit"
	desc = "A compact collection of ointments and soothing medical mixtures intended for treating severe burns."
	icon = 'modular/timesoldier/sprites/gear.dmi'
	icon_state = "burnkit" // ditto as above
	uses = 8
	brute_heal = 0
	burn_heal = 35
	treatment_time = 3 SECONDS

/obj/item/storage/backpack/rogue/satchel/short/timesoldier_ifak
	name = "individiual aid satchel"
	desc = "<span class='yellow'><i>Whenever crates of this stuff came around, we knew we'd have to start digging into our own wounds that following dae. Doubles as a small satchel, too.</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	icon_state = "ifak" // ditto as above
	populate_contents = list(
		/obj/item/timesoldier/medical/bruise,
		/obj/item/timesoldier/medical/bruise,
		/obj/item/timesoldier/medical/burn
	)
