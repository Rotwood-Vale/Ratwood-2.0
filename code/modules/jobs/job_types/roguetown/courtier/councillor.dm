/datum/job/roguetown/councillor
	title = "Councillor"
	flag = COUNCILLOR
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_ages = ALL_AGES_LIST
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_COUNCILLOR
	tutorial = "You may have inherited this position, bought your way into it, or were appointed to it by merit--perish the thought! Whatever the case though, you work as an assistant and agent of the crown in matters of state. Whether this be aiding the steward, the sheriff, or the crown itself, or simply enjoying the free food of the keep, your duties vary day by day. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/councillor
	advclass_cat_rolls = list(CTAG_COUNCILLOR = 2)

	give_bank_account = 40
	noble_income = 20
	min_pq = 1 //Probably a bad idea to have a complete newbie advising the monarch
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_noble.ogg'
	social_rank = SOCIAL_RANK_NOBLE
	job_traits = list(TRAIT_NOBLE, TRAIT_SEEPRICES_SHITTY)
	job_subclasses = list(
		/datum/advclass/councillor
	)

/datum/advclass/councillor
	name = "Councillor"
	tutorial = "You may have inherited this position, bought your way into it, or were appointed to it by merit--perish the thought! Whatever the case though, you work as an assistant and agent of the crown in matters of state. Whether this be aiding the steward, the sheriff, or the crown itself, or simply enjoying the free food of the keep, your duties vary day by day. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	outfit = /datum/outfit/job/roguetown/councillor/basic
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/councillor
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/councillor/basic/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/steward // If this turns out to be overbearing re:stewardry bump down to the clerk keyring instead.
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/stabard/surcoat/councillor
	backpack_contents = list()
	if(SSmapping.current_map.map_name == "Rockhill")
		armor = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/councillor
		cloak = null
	if(SSmapping.current_map.map_name == "Desert Town")
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		cloak = null
	if(SSroguemachine.ministry_bureau) // No bureau mapped in, no ministries to be had.
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/petition_ministry, H)

// ===== MINISTRIES =====

GLOBAL_LIST_INIT(ministry_charters, list(
	"Guildmaster" = /datum/ministry/guild,
	"Bishop" = /datum/ministry/church,
	"Bathmaster" = /datum/ministry/night,
	"Inquisitor" = /datum/ministry/inquisition,
	"Court Magician" = /datum/ministry/mage,
	"Head Physician" = /datum/ministry/physician,
	"Innkeeper" = /datum/ministry/innkeeper,
	"Merchant" = /datum/ministry/merchant
))

/mob/living/carbon/human
	var/datum/ministry/ministry_active
	var/datum/ministry/ministry_partner
	var/datum/ministry/ministry_pending // Finalized by clicking on the bureau.
	var/ministry_spent // We already trained the skills. Lock to reforming this one only.

/datum/ministry
	var/name = "Ministry"
	var/display_title = "Minister"
	var/income_bonus = 20
	var/list/ministry_keys = list()
	var/list/archive_traits = list()
	var/list/archive_skills = list()
	var/ring_type
	var/mob/living/carbon/human/councillor
	var/mob/living/carbon/human/partner
	var/obj/item/clothing/ring/minister/ring
	var/obj/item/paper/scroll/ministry_writ/writ
	var/active = FALSE

/datum/ministry/Destroy()
	councillor = null
	partner = null
	ring = null
	writ = null
	return ..()

/datum/ministry/proc/archive_bonus(mob/living/carbon/human/H)
	return

// Duplicating some HERMES logic here for mailing the writ.
/proc/post_to_ministry(obj/item/parcel, sender, mob/living/carbon/human/recipient, notice, turf/fallback)
	if(!parcel || QDELETED(recipient))
		return
	parcel.mailer = sender
	parcel.mailedto = recipient.real_name
	parcel.update_icon()
	var/obj/item/roguemachine/mastermail/master = SSroguemachine.hermailermaster
	if(!master)
		parcel.forceMove(fallback || get_turf(recipient))
		return
	parcel.forceMove(master.loc)
	var/datum/component/storage/STR = master.GetComponent(/datum/component/storage)
	STR?.handle_item_insertion(parcel, prevent_warning = TRUE)
	master.new_mail = TRUE
	master.update_icon()
	recipient.apply_status_effect(/datum/status_effect/ugotmail)
	recipient.playsound_local(recipient, 'sound/misc/mail.ogg', 100, FALSE, -1)
	if(notice)
		to_chat(recipient, span_notice(notice))

/proc/ministry_roster()
	var/obj/structure/roguemachine/ministry_bureau/bureau = SSroguemachine.ministry_bureau
	bureau.prune_ministries()
	var/list/lines = list()
	for(var/job_title in GLOB.ministry_charters)
		var/charter = GLOB.ministry_charters[job_title]
		var/datum/ministry/M = bureau.active_ministries[charter]
		if(M)
			lines += "[job_title] — served by [M.councillor?.real_name || "a minister"]."
			continue
		var/mob/living/carbon/human/holder
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.mind?.assigned_role == job_title && !QDELETED(H))
				holder = H
				break
		if(!holder)
			lines += "[job_title] — no one holds the post."
		else if(holder.ministry_partner)
			lines += "[job_title] — already spoken for."
		else if(holder.stat == DEAD)
			lines += "[job_title] — dead, but not yet gone."
		else
			lines += "[job_title] — open to petition."
	return lines

/datum/ministry/guild
	name = "Guild Ministry"
	display_title = "Minister of Crafts"
	ministry_keys = list(/obj/item/roguekey/crafterguild)
	archive_traits = list(TRAIT_SEEPRICES, TRAIT_SMITHING_EXPERT)
	archive_skills = list(
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE
	)
	ring_type = /obj/item/clothing/ring/minister/guild

/datum/ministry/church
	name = "Church Ministry"
	display_title = "Minister of the Faith"
	ministry_keys = list(/obj/item/roguekey/church, /obj/item/roguekey/graveyard)
	archive_traits = list(TRAIT_RITUALIST, TRAIT_VOTARY)
	archive_skills = list(/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE)
	ring_type = /obj/item/clothing/ring/minister/church

/datum/ministry/church/archive_bonus(mob/living/carbon/human/H)
	H.put_in_hands(new /obj/item/ritechalk(get_turf(H)))
	if(!H.patron || istype(H.patron, /datum/patron/godless))
		to_chat(H, span_warning("I hold no faith. Odd."))
		return
	if(H.devotion)
		H.devotion.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)
		to_chat(H, span_notice("The archive deepens my existing devotion to [H.patron.name]."))
		return
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)
	to_chat(H, span_notice("The archive stirs my faith. I feel the first whispers of [H.patron.name]'s gifts."))

/datum/ministry/night
	name = "Night Ministry"
	display_title = "Minister of Vice"
	ministry_keys = list(/obj/item/roguekey/nightmaiden)
	archive_traits = list(TRAIT_CICERONE, TRAIT_GOODLOVER)
	archive_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE
	)
	ring_type = /obj/item/clothing/ring/minister/night

/datum/ministry/inquisition
	name = "Inquisition Ministry"
	display_title = "Minister of Orthodoxy"
	ministry_keys = list(/obj/item/roguekey/inquisition)
	archive_traits = list(TRAIT_STEELHEARTED)
	archive_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT
	)
	ring_type = /obj/item/clothing/ring/minister/inquisition

/datum/ministry/inquisition/archive_bonus(mob/living/carbon/human/H)
	if(H.devotion)
		if(!istype(H.patron, /datum/patron/old_god))
			to_chat(H, span_warning("I am already bound to a credo more alive than PSYDON's. My boots are conspicuously empty."))
			return
		H.devotion.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
		to_chat(H, span_notice("The archive reaffirms my covenant. ENDVRE."))
		return
	H.set_patron(/datum/patron/old_god)
	var/datum/devotion/C = new /datum/devotion(H, GLOB.patronlist[/datum/patron/old_god])
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
	to_chat(H, span_notice("The dusty notes in the back of the archive remind me of the Old God's covenant. Surely, PSYDON yet lives!"))

/datum/ministry/mage
	name = "Arcane Ministry"
	display_title = "Minister of Magic"
	ministry_keys = list(/obj/item/roguekey/tower)
	archive_traits = list(TRAIT_ALCHEMY_EXPERT)
	archive_skills = list(
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE
	)
	ring_type = /obj/item/clothing/ring/minister/mage

/datum/ministry/mage/archive_bonus(mob/living/carbon/human/H)
	if(!H.mind)
		return
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation, H)
	H.mind.adjust_spellpoints(9)
	to_chat(H, span_notice("The archive imparts the arcyne secrets of the previous Minister. I feel a thrum of latent power."))

/datum/ministry/physician
	name = "Physician Ministry"
	display_title = "Minister of Health"
	ministry_keys = list(/obj/item/roguekey/physician, /obj/item/roguekey/courtphysician)
	archive_traits = list(TRAIT_EMPATH, TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	archive_skills = list(
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN
	)
	ring_type = /obj/item/clothing/ring/minister/physician

/datum/ministry/physician/archive_bonus(mob/living/carbon/human/H)
	H.put_in_hands(new /obj/item/storage/belt/rogue/surgery_bag/full/physician(get_turf(H)))
	to_chat(H, span_notice("The previous Minister's surgeon kit is collecting dust in the back of the archive. Following their notes, I might make use of it."))

/datum/ministry/innkeeper
	name = "Tavern Ministry"
	display_title = "Minister of Commons"
	ministry_keys = list(/obj/item/roguekey/tavern)
	archive_traits = list(TRAIT_CICERONE, TRAIT_EMPATH, TRAIT_TAVERN_FIGHTER)
	archive_skills = list(/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN)
	ring_type = /obj/item/clothing/ring/minister/innkeeper

/datum/ministry/merchant
	name = "Trade Ministry"
	display_title = "Minister of Trade"
	income_bonus = 70 // Trade Ministry is the weakest so more income helps cope
	ministry_keys = list(/obj/item/roguekey/shop)
	archive_traits = list(TRAIT_SEEPRICES, TRAIT_CICERONE)
	archive_skills = list(/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN)
	ring_type = /obj/item/clothing/ring/minister/merchant

// ===== PETITION SPELL =====

/obj/effect/proc_holder/spell/self/petition_ministry
	name = "Petition Ministry"
	desc = "Offer yourself to a faction head as their voice within the keep. Cast with none in reach to survey which posts stand open."
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	var/petition_range = 3

/obj/effect/proc_holder/spell/self/petition_ministry/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/councillor = user
	if(councillor.ministry_active)
		to_chat(councillor, span_warning("I already hold an office."))
		return
	if(councillor.ministry_pending)
		to_chat(councillor, span_notice("My charter is agreed. The bureau in the council chamber awaits my swearing-in."))
		return

	var/obj/structure/roguemachine/ministry_bureau/bureau = SSroguemachine.ministry_bureau
	bureau.prune_ministries()
	var/list/prospects = list()
	for(var/mob/living/carbon/human/head in (get_hearers_in_view(petition_range, councillor) - councillor))
		var/charter = GLOB.ministry_charters[head.mind?.assigned_role]
		if(!charter || head.stat == DEAD)
			continue
		if(councillor.ministry_spent && councillor.ministry_spent != charter)
			continue
		if(head.ministry_partner)
			continue
		if(bureau.active_ministries[charter])
			continue
		prospects[head.name] = head
	if(!length(prospects))
		if(councillor.ministry_spent)
			var/datum/ministry/spent = councillor.ministry_spent
			to_chat(councillor, span_warning("I am schooled in one trade alone. Only a new [initial(spent.display_title)]'s sponsor will have me."))
		else
			to_chat(councillor, span_warning("There is nobody here whose patronage I might seek."))
		for(var/line in ministry_roster())
			to_chat(councillor, span_notice(line))
		return

	var/picked = input(councillor, "Whose patronage do I seek?", "[name]") as null|anything in prospects
	if(!picked)
		return
	var/mob/living/carbon/human/head = prospects[picked]
	if(QDELETED(head) || !(head in get_hearers_in_view(petition_range, councillor)))
		to_chat(councillor, span_warning("They have gone."))
		return
	INVOKE_ASYNC(src, PROC_REF(propose), councillor, head)

/obj/effect/proc_holder/spell/self/petition_ministry/proc/propose(mob/living/carbon/human/councillor, mob/living/carbon/human/head)
	var/charter = GLOB.ministry_charters[head.mind?.assigned_role]
	if(!charter)
		return
	var/datum/ministry/charter_ref = charter
	councillor.say("[head.real_name], let me be your voice within the keep.")
	var/answer = alert(head, "[councillor.real_name] petitions to serve as my [initial(charter_ref.display_title)]. They will be granted a measure of my trade's knowledge, and some keys to my place of responsibility. In return I shall receive a writ to speak with them.", "Ministry", "Accept", "Refuse")
	if(answer != "Accept")
		to_chat(councillor, span_warning("[head.real_name] declines my petition."))
		to_chat(head, span_notice("I decline the petition."))
		return
	if(QDELETED(councillor) || QDELETED(head) || councillor.stat == DEAD || head.stat == DEAD)
		return
	if(!(head in get_hearers_in_view(petition_range, councillor)))
		to_chat(councillor, span_warning("I'm much too far away now!"))
		to_chat(head, span_warning("They have wandered off before the matter was settled."))
		return
	if(councillor.ministry_active || councillor.ministry_pending || head.ministry_partner)
		to_chat(head, span_warning("The arrangement has already been overtaken by events."))
		return
	if(councillor.ministry_spent && councillor.ministry_spent != charter)
		to_chat(head, span_warning("This one is schooled in another trade entirely."))
		return
	if(SSroguemachine.ministry_bureau.active_ministries[charter])
		to_chat(head, span_warning("A minister of this house has already been seated."))
		return

	var/datum/ministry/proto = new charter()
	councillor.ministry_pending = proto
	head.ministry_partner = proto
	proto.councillor = councillor
	proto.partner = head

	head.visible_message(span_notice("[head.real_name] takes [councillor.real_name] into their confidence."))
	to_chat(head, span_notice("I accept the petition. The writ will reach me by post once they are sworn in."))
	to_chat(councillor, span_notice("[head.real_name] accepts. Go to the bureau in the council chamber to be sworn in."))

// ===== WRIT OF MINISTRY =====

/obj/item/paper/scroll/ministry_writ
	name = "writ of ministry"
	desc = "A charter of appointment, sealed and witnessed."
	icon_state = "contractsigned"
	open = TRUE
	textper = 150
	var/ministry_type
	var/open_name
	var/obj/item/clothing/ring/minister/paired_ring
	var/speech_cooldown = 0
	var/speech_cooldown_time = 10 SECONDS

/obj/item/paper/scroll/ministry_writ/Destroy()
	if(paired_ring)
		paired_ring.paired_writ = null
		paired_ring = null
	return ..()

/obj/item/paper/scroll/ministry_writ/proc/finalize(mob/living/carbon/human/minister, mob/living/carbon/human/partner, datum/ministry/M)
	ministry_type = M.type
	open_name = "writ of the [M.name]"
	name = open_name
	desc = "A charter appointing [minister.real_name] to the office of [M.display_title]."
	var/datum/job/ruler = SSjob.GetJobType(/datum/job/roguetown/lord)
	var/ruler_title = ruler?.display_title || ruler?.title || "Grand Duke"
	info = "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#14103f>"
	info += "<center><b>Writ of Ministry</b></center><hr/>"
	info += "Let it be known that, [partner.real_name], [partner.mind?.assigned_role || "of the town"], \
			does receive into their confidence [minister.real_name], Councillor to the [ruler_title], \
			granting unto them the office and privileges of <b>[M.display_title]</b>.<br/><br/>"
	info += "The Minister shall speak for this house within the council chamber. Unroll this writ and speak \
			upon it to reach them, wherever they stand.<br/><br/>"
	info += "SIGNED,<br/>"
	info += "[minister.real_name], [M.display_title] of [SSmapping.map_adjustment.realm_name]"
	info += "</font>"
	update_icon_state()

/obj/item/paper/scroll/ministry_writ/examine(mob/user)
	. = ..()
	if(paired_ring && open)
		. += span_notice("Speak upon it to reach the minister.")

/obj/item/paper/scroll/ministry_writ/update_icon_state()
	if(mailer)
		return ..()
	if(!open)
		icon_state = "scroll_closed"
		name = "scroll"
		return
	icon_state = "contractsigned"
	name = open_name || initial(name)

/obj/item/paper/scroll/ministry_writ/attack_self(mob/user)
	// Let the parent clear the mail wrapper first, otherwise read() stays blocked.
	if(mailer || !open || !paired_ring || !ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user
	if(!H.ministry_partner || H.ministry_partner.partner != H)
		return ..()
	if(!can_speak_ministry(H))
		return
	H.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice("[H] murmurs over the writ."))
	var/msg = input(H, "Send word to my minister.", "Ministerial Murmurs...") as null|text
	if(!msg)
		return
	if(!can_speak_ministry(H))
		return
	if(H.ministry_partner?.partner != H || !open || mailer)
		to_chat(H, span_warning("The writ is no longer mine to speak upon."))
		return
	speech_cooldown = world.time + speech_cooldown_time
	H.whisper(msg)
	paired_ring.relay_ministry_message(msg)

/obj/item/paper/scroll/ministry_writ/proc/can_speak_ministry(mob/living/carbon/human/H)
	if(H.restrained() || H.incapacitated())
		to_chat(H, span_warning("I cannot use this while restrained or incapacitated!"))
		return FALSE
	if(world.time < speech_cooldown)
		to_chat(H, span_warning("The ink is still settling from its last use."))
		return FALSE
	if(QDELETED(paired_ring))
		to_chat(H, span_warning("The writ has no paired ring. The bond is broken."))
		return FALSE
	if(!paired_ring.find_items_mob_carrier())
		to_chat(H, span_warning("My minister is not carrying their ring. My words find no one."))
		return FALSE
	if(find_items_mob_carrier() != H)
		to_chat(H, span_warning("The writ has left my hands."))
		return FALSE
	return TRUE

/obj/item/paper/scroll/ministry_writ/proc/relay_ministry_message(msg)
	playsound(src, 'sound/misc/scom.ogg', 80, FALSE, -1)
	say("<font color='#C8A84B'>[msg]</font>")

/obj/item/paper/scroll/ministry_writ/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	if(!language)
		language = get_default_language()
	if(isitem(loc))
		var/obj/item/I = loc
		I.send_speech(message, 1, I, , spans, message_language = language)
		return
	send_speech(message, 1, src, , spans, message_language = language)

// Minister's signet, paired to the partner's writ like a two-way SCOM.
/obj/item/clothing/ring/minister
	name = "minister's signet"
	desc = "A signet ring bearing the mark of a ministerial office. Press it to your lips to speak with your patron."
	icon_state = "signet"
	sellprice = 100
	slot_flags = ITEM_SLOT_RING
	var/obj/item/paper/scroll/ministry_writ/paired_writ
	var/speech_cooldown = 0
	var/speech_cooldown_time = 10 SECONDS

/obj/item/clothing/ring/minister/Destroy()
	if(paired_writ)
		paired_writ.paired_ring = null
		paired_writ = null
	return ..()

/obj/item/clothing/ring/minister/attack_self(mob/user)
	. = ..()
	attack_right(user)

/obj/item/clothing/ring/minister/attack_right(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.ministry_active || H.ministry_active.councillor != H)
		to_chat(H, span_warning("The ring is cold and dead in my hand. It was not made for me."))
		return
	if(!can_speak_ministry(H))
		return
	H.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice("[H] presses their ring against their mouth."))
	var/msg = input(H, "Speak into the ring.", "Ministerial Murmurs...") as null|text
	if(!msg)
		return
	if(!can_speak_ministry(H))
		return
	if(H.ministry_active?.councillor != H)
		to_chat(H, span_warning("The ring has gone cold. My office is no longer mine."))
		return
	speech_cooldown = world.time + speech_cooldown_time
	H.whisper(msg)
	paired_writ.relay_ministry_message(msg)

/obj/item/clothing/ring/minister/proc/can_speak_ministry(mob/living/carbon/human/H)
	if(H.restrained() || H.incapacitated())
		to_chat(H, span_warning("I cannot use this while restrained or incapacitated!"))
		return FALSE
	if(world.time < speech_cooldown)
		to_chat(H, span_warning("The ring's metal is still heated from its last use."))
		return FALSE
	if(QDELETED(paired_writ))
		to_chat(H, span_warning("The ring has no paired writ. The bond is broken."))
		return FALSE
	if(!paired_writ.find_items_mob_carrier())
		to_chat(H, span_warning("The writ is not being carried. My words find no one."))
		return FALSE
	if(find_items_mob_carrier() != H)
		to_chat(H, span_warning("The ring has left my hands."))
		return FALSE
	return TRUE

/obj/item/clothing/ring/minister/proc/relay_ministry_message(msg)
	playsound(src, 'sound/misc/scom.ogg', 80, FALSE, -1)
	say("<font color='#C8A84B'>[msg]</font>")

/obj/item/clothing/ring/minister/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	if(!language)
		language = get_default_language()
	if(isitem(loc))
		var/obj/item/I = loc
		I.send_speech(message, 1, I, , spans, message_language = language)
		return
	send_speech(message, 1, src, , spans, message_language = language)

/obj/item/clothing/ring/minister/guild
	name = "guild minister's signet"
	desc = "A well-worn signet ring, yet smoke-stained from the fires of the Guild."

/obj/item/clothing/ring/minister/church
	name = "church minister's signet"
	desc = "A holy ring befitting a priest of the Divine Pantheon, now besmirched by court politick."
	icon_state = "signet_silver"

/obj/item/clothing/ring/minister/night
	name = "night minister's signet"
	desc = "An unassuming, sleek ring. Careful that it does not sink to the bottom of the baths."

/obj/item/clothing/ring/minister/inquisition
	name = "inquisition minister's signet"
	desc = "A signet ring bearing the Inquisition's mark. An ENDVRING fashion choice, if outdated."
	icon_state = "signet_silver"

/obj/item/clothing/ring/minister/mage
	name = "arcane minister's signet"
	desc = "A ring faintly warm to the touch, marked with an arcyne glyph."

/obj/item/clothing/ring/minister/physician
	name = "physician minister's signet"
	desc = "A ring bearing the Pestran tendrils of the court physician's office."

/obj/item/clothing/ring/minister/innkeeper
	name = "tavern minister's signet"
	desc = "A ring bearing the inn's tap-mark. Its sheen is scratched by knife and cutting board."

/obj/item/clothing/ring/minister/merchant
	name = "trade minister's signet"
	desc = "A ring bearing the mammon-hoarding marque of the Merchant's Guild."
