//CONTAINS: Suit fibers and Detective's Scanning Computer

/atom/proc/return_fingerprints()
	var/datum/component/forensics/D = GetComponent(/datum/component/forensics)
	if(D)
		. = D.fingerprints

/atom/proc/return_hiddenprints()
	var/datum/component/forensics/D = GetComponent(/datum/component/forensics)
	if(D)
		. = D.hiddenprints

/atom/proc/return_blood_DNA()
	var/datum/component/forensics/D = GetComponent(/datum/component/forensics)
	if(D)
		. = D.blood_DNA

/atom/proc/blood_DNA_length()
	var/datum/component/forensics/D = GetComponent(/datum/component/forensics)
	if(D)
		. = length(D.blood_DNA)

/atom/proc/return_fibers()
	var/datum/component/forensics/D = GetComponent(/datum/component/forensics)
	if(D)
		. = D.fibers

/atom/proc/add_fingerprint_list(list/fingerprints)		//ASSOC LIST FINGERPRINT = FINGERPRINT
	if(QDELETED(src))
		return
	if(length(fingerprints))
		. = AddComponent(/datum/component/forensics, fingerprints)

//Set ignoregloves to add prints irrespective of the mob having gloves on.
/atom/proc/add_fingerprint(mob/M, ignoregloves = FALSE)
	if(QDELETED(src))
		return
	var/datum/component/forensics/D = AddComponent(/datum/component/forensics)
	. = D.add_fingerprint(M, ignoregloves)

/atom/proc/add_fiber_list(list/fibertext)				//ASSOC LIST FIBERTEXT = FIBERTEXT
	if(QDELETED(src))
		return
	if(length(fibertext))
		. = AddComponent(/datum/component/forensics, null, null, null, fibertext)

/atom/proc/add_fibers(mob/living/carbon/human/M)
	var/old = 0
	if(M.gloves && istype(M.gloves, /obj/item/clothing))
		var/obj/item/clothing/gloves/G = M.gloves
		old = length(G.return_blood_DNA())
		if(G.transfer_blood > 1) //bloodied gloves transfer blood to touched objects
			if(add_blood_DNA(G.return_blood_DNA()) && length(G.return_blood_DNA()) > old) //only reduces the bloodiness of our gloves if the item wasn't already bloody
				G.transfer_blood--
	else if(M.bloody_hands > 1)
		old = length(M.return_blood_DNA())
		if(add_blood_DNA(M.return_blood_DNA()) && length(M.return_blood_DNA()) > old)
			M.bloody_hands--
	var/datum/component/forensics/D = AddComponent(/datum/component/forensics)
	. = D.add_fibers(M)

/atom/proc/add_hiddenprint_list(list/hiddenprints)	//NOTE: THIS IS FOR ADMINISTRATION FINGERPRINTS, YOU MUST CUSTOM SET THIS TO INCLUDE CKEY/REAL NAMES! CHECK FORENSICS.DM
	if(length(hiddenprints))
		. = AddComponent(/datum/component/forensics, null, hiddenprints)

/atom/proc/add_hiddenprint(mob/M)
	if(QDELETED(src))
		return
	var/datum/component/forensics/D = AddComponent(/datum/component/forensics)
	. = D.add_hiddenprint(M)

/// Notes a player opening, locking, picking or breaking this for admins' View Forensics. Mobs without a player are skipped.
/// Routine is everyday use (opening, closing, keyed locking, picking up, dropping), kept in its own capped list.
/// only_if_tracked skips atoms no player has handled yet, so mass drops of untouched gear make no component.
/// Evidence also goes to the game log and the player's own log, so it outlives the atom. Routine use is too frequent to log,
/// and so are repeats: an action that folds into the last entry, such as the twentieth hit on a door, is not logged again.
/atom/proc/add_forensic_action(mob/user, action, routine = FALSE, only_if_tracked = FALSE)
	if(!user?.ckey || QDELETED(src))
		return
	var/datum/component/forensics/D = GetComponent(/datum/component/forensics)
	if(!D)
		if(only_if_tracked)
			return
		D = AddComponent(/datum/component/forensics)
	if(D.add_action(user, action, routine) && !routine)
		user.log_message("forensics on [src] ([type]): [action]", LOG_GAME)

/// Notes poison going into or out of food and drink, and drinks spiked on the rim, for admins' View Forensics.
/// transfer_log is what trans_to() moved, reagent type = amount. Only spiking prepends.
/datum/reagents/proc/record_forensic_transfer(atom/target_atom, list/transfer_log, mob/transfered_by, method, prepend)
	if(!transfered_by.ckey)
		return
	var/list/reagent_names = list()
	var/list/poison_names = list()
	for(var/reagent_type in transfer_log)
		// trans_to() logs every reagent even when nothing moved, such as into a full container
		if(!transfer_log[reagent_type])
			continue
		var/datum/reagent/reagent = GLOB.chemical_reagents_list[reagent_type]
		if(!reagent)
			continue
		reagent_names |= reagent.name
		if(reagent.is_poison())
			poison_names |= reagent.name
	var/poisons = english_list(poison_names)
	var/source = my_atom ? format_text("[my_atom]") : "something"

	if(isobj(target_atom))
		if(prepend)
			target_atom.add_forensic_action(transfered_by, "spiked the rim with [english_list(reagent_names)] from [source][length(poison_names) ? ", poisoning it with [poisons]" : ""]")
		else if(length(poison_names))
			target_atom.add_forensic_action(transfered_by, "added poison ([poisons]) from [source]")
		return

	// Consumption is noted on the food or drink, as the victim's mob has no View Forensics.
	if(method != INGEST || !length(poison_names) || !isobj(my_atom) || !ismob(target_atom))
		return
	var/mob/victim = target_atom
	if(victim == transfered_by)
		my_atom.add_forensic_action(transfered_by, "ate or drank poison ([poisons]) from it")
	else
		my_atom.add_forensic_action(transfered_by, "fed poison ([poisons]) from it to [victim.real_name] ([victim.ckey || "no player"])")

/atom/proc/add_blood_DNA(list/dna)						//ASSOC LIST DNA = BLOODTYPE
	return FALSE

/obj/add_blood_DNA(list/dna)
	. = ..()
	if(QDELETED(src))
		return
	if(length(dna))
		. = AddComponent(/datum/component/forensics, null, null, dna)

/obj/item/clothing/gloves/add_blood_DNA(list/blood_dna)
	. = ..()
	transfer_blood = rand(2, 4)

/turf/add_blood_DNA(list/blood_dna)
	var/obj/effect/decal/cleanable/blood/splatter/B = locate() in src
	if(!B)
		B = new /obj/effect/decal/cleanable/blood/splatter(src)
	B.add_blood_DNA(blood_dna) //give blood info to the blood decal.
	return TRUE //we bloodied the floor

/mob/living/carbon/human/add_blood_DNA(list/blood_dna)
	if(dna?.species?.id == "gnoll")
		if(length(blood_dna))
			AddComponent(/datum/component/forensics, null, null, blood_dna)
		bloody_hands = 0
		update_inv_gloves()
		return TRUE

	if(cloak)
		cloak.add_blood_DNA(blood_dna)
		update_inv_cloak()
	else if(wear_armor)
		wear_armor.add_blood_DNA(blood_dna)
		update_inv_armor()
	else if(wear_shirt)
		wear_shirt.add_blood_DNA(blood_dna)
		update_inv_shirt()
	else if(wear_pants)
		wear_pants.add_blood_DNA(blood_dna)
		update_inv_pants()
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		G.add_blood_DNA(blood_dna)
	else if(length(blood_dna))
		AddComponent(/datum/component/forensics, null, null, blood_dna)
		bloody_hands = rand(2, 4)
	update_inv_gloves()	//handles bloody hands overlays and updating
	return TRUE

/atom/proc/transfer_fingerprints_to(atom/A)
	A.add_fingerprint_list(return_fingerprints())
	A.add_hiddenprint_list(return_hiddenprints())
	A.fingerprintslast = fingerprintslast
