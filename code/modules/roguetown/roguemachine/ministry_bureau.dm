// This machine enables and keeps track of the Councillor "minister" datums, allowing
// Councillor jobs to secure approval of certain power roles for skills + access.

#define MINISTRY_REISSUE_COST 10

/obj/structure/roguemachine/ministry_bureau
	name = "ministerial bureau"
	desc = "A cabinet of sealed correspondence and official records, sorted by house. A councillor bearing an agreed charter may be sworn in here."
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

// Tears down ministries whose councillor or partner is gone.
// Walks backwards so cutting entries doesn't skip the next one.
/obj/structure/roguemachine/ministry_bureau/proc/prune_ministries()
	for(var/i = length(active_ministries), i >= 1, i--)
		var/charter = active_ministries[i]
		var/datum/ministry/M = active_ministries[charter]
		if(!M)
			active_ministries.Cut(i, i + 1)
			continue
		var/mob/living/carbon/human/minister = M.councillor
		var/mob/living/carbon/human/partner = M.partner
		if(minister && !QDELETED(minister) && minister.stat != DEAD && partner && !QDELETED(partner) && partner.stat != DEAD)
			continue
		if(minister && !QDELETED(minister))
			minister.ministry_active = null
			if(SStreasury.noble_incomes[minister])
				SStreasury.noble_incomes[minister] = max(0, SStreasury.noble_incomes[minister] - M.income_bonus)
		if(partner && !QDELETED(partner))
			partner.ministry_partner = null
		active_ministries.Cut(i, i + 1)
		qdel(M)

/obj/structure/roguemachine/ministry_bureau/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(!istype(user) || !istype(P, /obj/item/roguecoin/gold))
		return ..()
	if(user.mind?.assigned_role != "Councillor" || !user.ministry_active)
		return ..()
	reissue_regalia(user, P)

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
	if(QDELETED(M.partner) || M.partner.stat == DEAD || M.partner.ministry_partner != M)
		to_chat(user, span_warning("My patron's agreement no longer stands."))
		clear_pending(user)
		return

	to_chat(user, span_notice("I open the bureau and begin the rite of appointment. Hold still..."))
	playsound(src, 'sound/items/book_open.ogg', 60, FALSE)
	if(!do_after(user, 10 SECONDS, target = src))
		to_chat(user, span_warning("I step away before the rite is complete."))
		return

	// Re-check everything; ten seconds is a long time in this town.
	if(user.ministry_active || user.ministry_pending != M)
		return
	prune_ministries()
	if(active_ministries[charter])
		to_chat(user, span_warning("Another was seated while I read. The charter is void."))
		clear_pending(user)
		return
	if(QDELETED(M.partner) || M.partner.stat == DEAD || M.partner.ministry_partner != M)
		to_chat(user, span_warning("My patron's agreement no longer stands."))
		clear_pending(user)
		return

	swear_in(user, M)

// Drops a dead-on-arrival charter and releases the partner's reservation.
/obj/structure/roguemachine/ministry_bureau/proc/clear_pending(mob/living/carbon/human/user)
	var/datum/ministry/M = user.ministry_pending
	user.ministry_pending = null
	if(!M)
		return
	if(M.partner?.ministry_partner == M)
		M.partner.ministry_partner = null
	qdel(M)

/obj/structure/roguemachine/ministry_bureau/proc/swear_in(mob/living/carbon/human/user, datum/ministry/M)
	active_ministries[M.type] = M
	M.active = TRUE
	user.ministry_active = M
	user.ministry_pending = null
	SStreasury.noble_incomes[user] += M.income_bonus

	issue_regalia(M, user)

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
	to_chat(user, span_notice("The rite is complete. I am [M.display_title], and the knowledge of the [M.name] is mine to draw upon."))
	to_chat(M.partner, span_notice("[user.real_name] has been sworn in as your [M.display_title]."))
	playsound(src, 'sound/items/book_open.ogg', 60, FALSE)

// Mints the paired ring and seal. The ring goes to the minister, the seal to the mail.
/obj/structure/roguemachine/ministry_bureau/proc/issue_regalia(datum/ministry/M, mob/living/carbon/human/receiver)
	var/obj/item/clothing/ring/minister/ring = new M.ring_type(get_turf(src))
	var/obj/item/seal_of_ministry/seal = new M.seal_type(get_turf(src))
	ring.paired_seal = seal
	seal.paired_ring = ring
	M.ring = ring
	M.seal = seal
	if(receiver)
		receiver.put_in_hands(ring)
	post_seal(seal, M.councillor, M)

// Ten zenarii mints a fresh pair. The old ring survives as inert loot, the old seal doesn't.
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

	// The old ring stays in the world as dead metal - whoever holds it keeps a
	// trinket, not a channel. The old seal is worthless, so it goes.
	var/obj/item/clothing/ring/minister/old_ring = M.ring
	if(old_ring)
		old_ring.paired_seal = null
		old_ring.desc = "A signet ring of a ministerial office, its mark scored through. Dead metal."
		M.ring = null
	QDEL_NULL(M.seal)
	issue_regalia(M, user)
	playsound(src, 'sound/foley/coins1.ogg', 100, TRUE, -1)
	to_chat(user, span_notice("The bureau strikes a new mark and scores through the old. Whatever became of the last ring, it answers to no one now."))

// Instead of making the councillor walk back, we can send the partner's seal through the mail.
/obj/structure/roguemachine/ministry_bureau/proc/post_seal(obj/item/seal_of_ministry/seal, mob/living/carbon/human/minister, datum/ministry/M)
	var/mob/living/carbon/human/partner = M.partner
	seal.mailer = "[minister.real_name], [M.display_title]"
	seal.mailedto = partner.real_name
	var/obj/item/roguemachine/mastermail/master = SSroguemachine.hermailermaster
	if(!master)
		seal.forceMove(get_turf(src))
		return
	seal.forceMove(master.loc)
	var/datum/component/storage/STR = master.GetComponent(/datum/component/storage)
	STR?.handle_item_insertion(seal, prevent_warning = TRUE)
	master.new_mail = TRUE
	master.update_icon()
	partner.apply_status_effect(/datum/status_effect/ugotmail)
	partner.playsound_local(partner, 'sound/misc/mail.ogg', 100, FALSE, -1)
	to_chat(partner, span_notice("Your seal of ministry has been posted. Collect it from any HERMES."))

#undef MINISTRY_REISSUE_COST
