// Councillor ministry tracking. Ministers are sworn in here.

#define MINISTRY_REISSUE_COST 10

/obj/structure/roguemachine/ministry_bureau
	name = "ministerial bureau"
	desc = "A cabinet of sealed correspondence and official records, recording the accomplishments of the Ministers of yore. A councillor bearing an agreed charter may be sworn in here. What's more, a Ministry's signet ring could be re-issued here with ten zenarii."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "closetlord"
	density = TRUE
	layer = BELOW_OBJ_LAYER
	attacked_sound = "woodimpact"
	var/list/active_ministries = list()

/obj/structure/roguemachine/ministry_bureau/Initialize(mapload)
	. = ..()
	if(!SSroguemachine.ministry_bureau)
		SSroguemachine.ministry_bureau = src

/obj/structure/roguemachine/ministry_bureau/Destroy()
	if(SSroguemachine.ministry_bureau == src)
		SSroguemachine.ministry_bureau = null
	QDEL_LIST_ASSOC_VAL(active_ministries)
	return ..()

/obj/structure/roguemachine/ministry_bureau/examine(mob/user)
	. = ..()
	if(!length(active_ministries))
		. += span_notice("No ministries are in session.")
		return
	. += span_notice("Ministries in session:")
	for(var/charter in active_ministries)
		var/datum/ministry/M = active_ministries[charter]
		. += span_notice("[M.display_title] — [M.councillor?.real_name || "vacant"], seated by [M.partner?.real_name || "unknown"].")

// Backwards so cutting doesn't skip entries.
/obj/structure/roguemachine/ministry_bureau/proc/prune_ministries()
	for(var/i = length(active_ministries), i >= 1, i--)
		var/charter = active_ministries[i]
		var/datum/ministry/M = active_ministries[charter]
		if(!M)
			active_ministries.Cut(i, i + 1)
			continue
		var/mob/living/carbon/human/minister = M.councillor
		var/mob/living/carbon/human/partner = M.partner
		// Death doesn't prune, only far travel and gibs.
		if(minister && !QDELETED(minister) && partner && !QDELETED(partner))
			continue
		if(minister && !QDELETED(minister))
			minister.ministry_active = null
			if(SStreasury.noble_incomes[minister])
				SStreasury.noble_incomes[minister] = max(0, SStreasury.noble_incomes[minister] - M.income_bonus)
			if(minister.mind && !minister.mind.has_spell(/obj/effect/proc_holder/spell/self/petition_ministry))
				minister.mind.AddSpell(new /obj/effect/proc_holder/spell/self/petition_ministry, minister)
				to_chat(minister, span_warning("Word reaches the bureau that my sponsor is gone. My office is void, though the learning stays with me."))
		if(partner && !QDELETED(partner))
			partner.ministry_partner = null
			to_chat(partner, span_warning("The bureau strikes my minister's name from its records. The writ I was sent is no more."))
		// Leaving the writ paired would block the ring being re-cut.
		if(M.writ)
			M.writ.paired_ring = null
			M.writ = null
		if(M.ring)
			M.ring.desc = "A signet ring of a ministerial office, its mark scored through. Dead metal."
		active_ministries.Cut(i, i + 1)
		qdel(M)

/obj/structure/roguemachine/ministry_bureau/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(!istype(user) || user.mind?.assigned_role != "Councillor")
		return ..()
	if(istype(P, /obj/item/clothing/ring/minister))
		resync_ring(user, P)
		return
	if(!istype(P, /obj/item/roguecoin/gold) || !user.ministry_active)
		return ..()
	reissue_regalia(user, P)

/obj/structure/roguemachine/ministry_bureau/proc/resync_ring(mob/living/carbon/human/user, obj/item/clothing/ring/minister/ring)
	if(!QDELETED(ring.paired_writ))
		to_chat(user, span_warning("This ring still answers to its writ. There is nothing to mend."))
		return
	prune_ministries()
	var/datum/ministry/M = user.ministry_active
	if(!M || !M.active)
		to_chat(user, span_warning("I hold no office. A new charter must be agreed before this ring means anything."))
		return
	if(M.ring == ring)
		to_chat(user, span_warning("The bureau has already struck my mark anew. This one is spent."))
		return
	if(QDELETED(M.partner))
		to_chat(user, span_warning("There is no one to bear the other half."))
		return
	if(!do_after(user, 5 SECONDS, target = src))
		return
	if(user.ministry_active != M || !M.active || QDELETED(ring) || !QDELETED(ring.paired_writ))
		return
	QDEL_NULL(M.ring)
	QDEL_NULL(M.writ)
	issue_regalia(M, user, ring)
	playsound(src, 'sound/items/book_open.ogg', 60, FALSE)
	to_chat(user, span_notice("The bureau re-cuts the old mark for [M.partner.real_name] and posts them a writ to match."))

/obj/structure/roguemachine/ministry_bureau/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	if(!istype(user))
		return
	if(user.mind?.assigned_role != "Councillor")
		to_chat(user, span_warning("These records are the council chamber's own."))
		return
	if(user.ministry_active)
		to_chat(user, span_warning("I already hold an office."))
		return
	if(!user.ministry_pending)
		to_chat(user, span_warning("I have no charter to enter. A faction head must first agree to take me on."))
		for(var/line in ministry_roster())
			to_chat(user, span_notice(line))
		return

	prune_ministries()
	var/datum/ministry/M = user.ministry_pending
	var/charter = M.type
	if(active_ministries[charter])
		to_chat(user, span_warning("A minister of that house is already seated. My charter is void."))
		clear_pending(user)
		return
	if(QDELETED(M.partner) || M.partner.ministry_partner != M)
		to_chat(user, span_warning("My patron's agreement no longer stands."))
		clear_pending(user)
		return
	if(M.partner.stat == DEAD)
		to_chat(user, span_warning("My patron lies dead. The rite must wait on their recovery."))
		return

	to_chat(user, span_notice("I open the bureau and begin the rite of appointment. Hold still..."))
	playsound(src, 'sound/items/book_open.ogg', 60, FALSE)
	if(!do_after(user, 10 SECONDS, target = src))
		to_chat(user, span_warning("I step away before the rite is complete."))
		return

	if(user.ministry_active || user.ministry_pending != M)
		return
	prune_ministries()
	if(active_ministries[charter])
		to_chat(user, span_warning("Another was seated while I read. The charter is void."))
		clear_pending(user)
		return
	if(QDELETED(M.partner) || M.partner.ministry_partner != M)
		to_chat(user, span_warning("My patron's agreement no longer stands."))
		clear_pending(user)
		return
	if(M.partner.stat == DEAD)
		to_chat(user, span_warning("My patron lies dead. The rite must wait on their recovery."))
		return

	swear_in(user, M)

/obj/structure/roguemachine/ministry_bureau/proc/clear_pending(mob/living/carbon/human/user)
	var/datum/ministry/M = user.ministry_pending
	user.ministry_pending = null
	if(!M)
		return
	if(M.partner?.ministry_partner == M)
		M.partner.ministry_partner = null
	qdel(M)

/obj/structure/roguemachine/ministry_bureau/proc/swear_in(mob/living/carbon/human/user, datum/ministry/M)
	var/reforming = (user.ministry_spent == M.type)
	active_ministries[M.type] = M
	M.active = TRUE
	user.ministry_active = M
	user.ministry_pending = null
	user.ministry_spent = M.type
	SStreasury.noble_incomes[user] += M.income_bonus

	var/obj/item/clothing/ring/minister/old_ring
	if(reforming)
		for(var/obj/item/clothing/ring/minister/candidate in user.GetAllContents())
			if(candidate.type == M.ring_type && QDELETED(candidate.paired_writ))
				old_ring = candidate
				break
	issue_regalia(M, user, old_ring)

	if(!reforming)
		var/turf/T = get_turf(src)
		for(var/key_type in M.ministry_keys)
			new key_type(T)
		for(var/trait in M.archive_traits)
			ADD_TRAIT(user, trait, "ministry")
		for(var/skill_type in M.archive_skills)
			user.adjust_skillrank_up_to(skill_type, M.archive_skills[skill_type], TRUE)
		M.archive_bonus(user)

	var/obj/effect/proc_holder/spell/petition = user.mind?.get_spell(/obj/effect/proc_holder/spell/self/petition_ministry)
	if(petition)
		user.mind.RemoveSpell(petition)
	if(reforming)
		to_chat(user, span_notice("The bureau records my office restored under [M.partner.real_name]. My learning stands as it was."))
	else
		to_chat(user, span_notice("The rite is complete. I am [M.display_title], and the knowledge of the [M.name] is mine to draw upon."))
	to_chat(M.partner, span_notice("[user.real_name] has been sworn in as my [M.display_title]."))
	playsound(src, 'sound/items/book_open.ogg', 60, FALSE)

// Pass old_ring to re-cut it instead of striking a new one.
/obj/structure/roguemachine/ministry_bureau/proc/issue_regalia(datum/ministry/M, mob/living/carbon/human/receiver, obj/item/clothing/ring/minister/old_ring)
	var/obj/item/clothing/ring/minister/ring = old_ring
	if(ring)
		ring.desc = initial(ring.desc)
	else
		ring = new M.ring_type(get_turf(src))
	var/obj/item/paper/scroll/ministry_writ/writ = new(get_turf(src))
	writ.finalize(M.councillor, M.partner, M)
	ring.paired_writ = writ
	writ.paired_ring = ring
	M.ring = ring
	M.writ = writ
	if(receiver)
		receiver.put_in_hands(ring)
	post_to_ministry(writ, "[M.councillor.real_name], [M.display_title]", M.partner, "My writ of ministry has been posted. I can collect it from any HERMES.", get_turf(src))

/obj/structure/roguemachine/ministry_bureau/proc/reissue_regalia(mob/living/carbon/human/user, obj/item/roguecoin/gold/coins)
	var/datum/ministry/M = user.ministry_active
	if(!M || !M.active)
		to_chat(user, span_warning("I hold no office. The bureau has nothing to recast for me."))
		return
	if(QDELETED(M.partner))
		to_chat(user, span_warning("My partner is gone. There is no one to bear the other half."))
		return
	if(coins.quantity < MINISTRY_REISSUE_COST)
		to_chat(user, span_warning("The bureau wants [MINISTRY_REISSUE_COST] zenarii for a recasting."))
		return
	if(!do_after(user, 5 SECONDS, target = src))
		return
	if(user.ministry_active != M || !M.active || QDELETED(coins) || coins.quantity < MINISTRY_REISSUE_COST)
		return

	if(coins.quantity > MINISTRY_REISSUE_COST)
		coins.set_quantity(coins.quantity - MINISTRY_REISSUE_COST)
	else
		qdel(coins)
	SStreasury.give_money_treasury(MINISTRY_REISSUE_COST * 10, "Ministry Recasting")

	var/obj/item/clothing/ring/minister/old_ring = M.ring
	if(old_ring)
		old_ring.paired_writ = null
		old_ring.desc = "A signet ring of a ministerial office, its mark scored through. Dead metal."
		M.ring = null
	QDEL_NULL(M.writ)
	issue_regalia(M, user)
	playsound(src, 'sound/foley/coins1.ogg', 100, TRUE, -1)
	to_chat(user, span_notice("The bureau strikes a new mark and scores through the old. Whatever became of the last ring, it answers to no one now."))

#undef MINISTRY_REISSUE_COST
