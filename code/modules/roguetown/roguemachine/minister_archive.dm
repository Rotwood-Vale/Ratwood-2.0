// Minister Archive — placed in the Councillor's office.
// Click to pull a draft writ. Return a finalized writ to be sworn in as minister.
// Submitting a valid writ triggers a 10-second study, then grants swearing-in and archive benefits together.

/obj/structure/roguemachine/minister_archive
	name = "ministerial archive"
	desc = "A cabinet of sealed correspondence and official records, organized by faction. A councillor may draft a writ of ministry here, or submit a finalized one to be sworn in."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "closetlord"
	density = TRUE
	anchored = TRUE
	max_integrity = 300
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	/// Tracks when each councillor may pull their next writ. Keyed by mob, value is world.time they're free.
	var/list/writ_cooldowns = list()
	/// All currently active ministry datums. Keyed by ministry type path, value is datum/ministry.
	var/list/active_ministries = list()

/obj/structure/roguemachine/minister_archive/examine(mob/user)
	. = ..()
	if(!length(active_ministries))
		. += span_notice("No ministries are currently in session.")
		return
	. += span_notice("The following ministries are in session:")
	for(var/mtype in active_ministries)
		var/datum/ministry/M = active_ministries[mtype]
		var/cname = M.councillor ? M.councillor.real_name : "Unknown"
		var/pname = M.partner ? M.partner.real_name : "Unknown"
		. += span_notice("  [M.display_title] — [cname], appointed by [pname].")

/obj/structure/roguemachine/minister_archive/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!istype(user))
		return
	if(!user.mind || user.mind.assigned_role != "Councillor")
		to_chat(user, span_warning("This archive is reserved for the council chamber's use."))
		return
	if(user.ministry_active)
		to_chat(user, span_warning("You are already sworn to a ministry."))
		return

	// No active ministry — gate on cooldown and existing writ
	if(writ_cooldowns[user] && world.time < writ_cooldowns[user])
		var/remaining = round((writ_cooldowns[user] - world.time) / 600)
		to_chat(user, span_warning("The archive will not issue another writ for [remaining] minute\s."))
		return

	for(var/obj/item/ministry_writ/W in user.contents)
		to_chat(user, span_warning("You already carry a draft writ. Have it finalized by the appropriate faction head."))
		return

	writ_cooldowns[user] = world.time + 30 MINUTES
	var/obj/item/ministry_writ/writ = new(get_turf(user))
	writ.author = user
	user.put_in_hands(writ)
	to_chat(user, span_info("You pull a blank writ from the archive. Bring it to a faction head to have it finalized, then return it here."))
	playsound(src, 'sound/items/book_open.ogg', 60, FALSE)

// Called when the councillor returns a finalized writ (attackby)
/obj/structure/roguemachine/minister_archive/attackby(obj/item/I, mob/living/carbon/human/user, params)
	if(!istype(I, /obj/item/ministry_writ))
		return ..()
	var/obj/item/ministry_writ/writ = I
	if(!istype(user))
		return
	if(!user.mind || user.mind.assigned_role != "Councillor")
		to_chat(user, span_warning("This archive is not yours to submit to."))
		return
	if(user.ministry_active)
		to_chat(user, span_warning("You are already bound to a ministry."))
		return
	if(!writ.ministry_type)
		to_chat(user, span_warning("This writ has not been finalized. Bring it to the appropriate faction head first."))
		return
	if(!writ.author || writ.author != user)
		to_chat(user, span_warning("This writ was not drafted for you."))
		return
	if(!writ.signatory || writ.signatory.stat == DEAD)
		to_chat(user, span_warning("The faction head who sealed this writ is no longer available."))
		return
	if(writ.signatory.ministry_partner)
		to_chat(user, span_warning("The faction head who sealed this writ has already taken another minister."))
		return
	if(active_ministries[writ.ministry_type])
		to_chat(user, span_warning("A ministry of that charter already exists. The archive will not recognize a second appointment."))
		qdel(writ)
		return

	to_chat(user, span_notice("You open the archive and begin the rite of appointment. Hold still..."))
	var/ministry_type_to_create = writ.ministry_type
	var/mob/living/carbon/human/signatory_ref = writ.signatory

	if(!do_after(user, 10 SECONDS, target = src))
		to_chat(user, span_warning("You step away before the rite is complete."))
		return

	// Re-validate after the wait
	if(user.ministry_active)
		to_chat(user, span_warning("Something has changed — you are already bound to a ministry."))
		return
	if(active_ministries[ministry_type_to_create])
		to_chat(user, span_warning("A ministry of that charter was established while you studied. The archive cannot recognize a second."))
		qdel(writ)
		return
	if(!signatory_ref || signatory_ref.stat == DEAD || signatory_ref?.ministry_partner)
		to_chat(user, span_warning("Your patron's seal is no longer valid."))
		qdel(writ)
		return

	var/datum/ministry/M = new ministry_type_to_create()
	active_ministries[ministry_type_to_create] = M
	establish_ministry(user, signatory_ref, M, src)

	user.ministry_archive_consulted = TRUE
	for(var/trait in M.archive_traits)
		ADD_TRAIT(user, trait, "ministry_archive")
	for(var/skill_type in M.archive_skills)
		user.adjust_skillrank_up_to(skill_type, M.archive_skills[skill_type], TRUE)
	M.archive_bonus(user)

	to_chat(user, span_notice("You complete the rite. The knowledge of the [M.name] is now yours to draw upon."))
	playsound(src, 'sound/items/book_open.ogg', 60, FALSE)
	qdel(writ)
