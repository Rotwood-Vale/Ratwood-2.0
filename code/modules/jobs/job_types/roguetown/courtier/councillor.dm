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
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/petition_ministry, H)

// ===== MINISTRIES =====
// A councillor petitions a faction head to serve as their voice in the keep.
// The head keeps a writ and a seal; the councillor takes their charter to the
// bureau to be sworn in, gaining that faction's keys, skills and secrets.

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
	var/datum/ministry/ministry_pending // held until finalized by clicking on the bureau

/datum/ministry
	var/name = "Ministry"
	var/display_title = "Minister"
	var/income_bonus = 20
	var/list/ministry_keys = list()
	var/list/archive_traits = list()
	var/list/archive_skills = list()
	var/ring_type
	var/seal_type
	var/mob/living/carbon/human/councillor
	var/mob/living/carbon/human/partner
	var/obj/item/clothing/ring/minister/ring
	var/obj/item/seal_of_ministry/seal
	var/active = FALSE

/datum/ministry/Destroy()
	councillor = null
	partner = null
	ring = null
	seal = null
	return ..()

// Extra perks beyond keys, traits and skills. Runs after those are applied.
/datum/ministry/proc/archive_bonus(mob/living/carbon/human/H)
	return

// Reports every charter and its standing, so a councillor knows who is worth
// walking to before they go looking.
/proc/ministry_roster()
	var/obj/structure/roguemachine/ministry_bureau/bureau = SSroguemachine.ministry_bureau
	bureau?.prune_ministries()
	var/list/lines = list()
	for(var/job_title in GLOB.ministry_charters)
		var/charter = GLOB.ministry_charters[job_title]
		var/datum/ministry/M = bureau?.active_ministries?[charter]
		if(M)
			lines += "[job_title] — served by [M.councillor?.real_name || "a minister"]."
			continue
		var/mob/living/carbon/human/holder
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.mind?.assigned_role == job_title && H.stat != DEAD)
				holder = H
				break
		if(!holder)
			lines += "[job_title] — no one holds the post."
		else if(holder.ministry_partner)
			lines += "[job_title] — already spoken for."
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
	seal_type = /obj/item/seal_of_ministry/guild

/datum/ministry/church
	name = "Church Ministry"
	display_title = "Minister of the Faith"
	ministry_keys = list(/obj/item/roguekey/church, /obj/item/roguekey/graveyard)
	archive_traits = list(TRAIT_RITUALIST, TRAIT_VOTARY)
	archive_skills = list(/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE)
	ring_type = /obj/item/clothing/ring/minister/church
	seal_type = /obj/item/seal_of_ministry/church

/datum/ministry/church/archive_bonus(mob/living/carbon/human/H)
	H.put_in_hands(new /obj/item/ritechalk(get_turf(H)))
	if(!H.patron || istype(H.patron, /datum/patron/godless))
		to_chat(H, span_warning("You hold no faith. Odd."))
		return
	if(H.devotion)
		H.devotion.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)
		to_chat(H, span_notice("The archive deepens your existing devotion to [H.patron.name]."))
		return
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)
	to_chat(H, span_notice("The archive stirs your faith. You feel the first whispers of [H.patron.name]'s gifts."))

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
	seal_type = /obj/item/seal_of_ministry/night

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
	seal_type = /obj/item/seal_of_ministry/inquisition

/datum/ministry/inquisition/archive_bonus(mob/living/carbon/human/H)
	if(H.devotion)
		if(!istype(H.patron, /datum/patron/old_god))
			to_chat(H, span_warning("You are already bound to a credo more alive than PSYDON's. Your boots are conspicuously empty."))
			return
		H.devotion.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
		to_chat(H, span_notice("The archive reaffirms your covenant. ENDVRE."))
		return
	H.set_patron(/datum/patron/old_god)
	var/datum/devotion/C = new /datum/devotion(H, GLOB.patronlist[/datum/patron/old_god])
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
	to_chat(H, span_notice("The dusty notes in the back of the archive remind you of the Old God's covenant. Surely, PSYDON yet lives!"))

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
	seal_type = /obj/item/seal_of_ministry/mage

/datum/ministry/mage/archive_bonus(mob/living/carbon/human/H)
	if(!H.mind)
		return
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation, H)
	H.mind.adjust_spellpoints(9)
	to_chat(H, span_notice("The archive imparts the arcyne secrets of the previous Minister. You feel a thrum of latent power."))

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
	seal_type = /obj/item/seal_of_ministry/physician

/datum/ministry/physician/archive_bonus(mob/living/carbon/human/H)
	H.put_in_hands(new /obj/item/storage/belt/rogue/surgery_bag/full/physician(get_turf(H)))
	to_chat(H, span_notice("The previous Minister's surgeon kit is collecting dust in the back of the archive. Following their notes, you might make use of it."))

/datum/ministry/innkeeper
	name = "Tavern Ministry"
	display_title = "Minister of Commons"
	ministry_keys = list(/obj/item/roguekey/tavern)
	archive_traits = list(TRAIT_CICERONE, TRAIT_EMPATH, TRAIT_TAVERN_FIGHTER)
	archive_skills = list(/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN)
	ring_type = /obj/item/clothing/ring/minister/innkeeper
	seal_type = /obj/item/seal_of_ministry/innkeeper

/datum/ministry/merchant
	name = "Trade Ministry"
	display_title = "Minister of Trade"
	income_bonus = 70 // Trade Ministry is the weakest so more income helps cope
	ministry_keys = list(/obj/item/roguekey/shop)
	archive_traits = list(TRAIT_SEEPRICES, TRAIT_CICERONE)
	archive_skills = list(/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN)
	ring_type = /obj/item/clothing/ring/minister/merchant
	seal_type = /obj/item/seal_of_ministry/merchant

// ===== PETITION SPELL =====
// Sits on the councillor's HUD until they've struck a deal and been sworn in.

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

	SSroguemachine.ministry_bureau?.prune_ministries()
	var/list/prospects = list()
	for(var/mob/living/carbon/human/head in (get_hearers_in_view(petition_range, councillor) - councillor))
		var/charter = GLOB.ministry_charters[head.mind?.assigned_role]
		if(!charter || head.stat == DEAD)
			continue
		if(head.ministry_partner)
			continue
		if(SSroguemachine.ministry_bureau?.active_ministries?[charter])
			continue
		prospects[head.name] = head
	if(!length(prospects))
		to_chat(councillor, span_warning("There is nobody here whose patronage I might seek."))
		for(var/line in ministry_roster())
			to_chat(councillor, span_notice(line))
		return

	var/picked = input(councillor, "Whose patronage do you seek?", "[name]") as null|anything in prospects
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
	var/answer = alert(head, "[councillor.real_name] petitions to serve as your [initial(charter_ref.display_title)]. They will be granted a measure of your trade's knowledge, and you a seal to speak with them.", "Ministry", "Accept", "Refuse")
	if(answer != "Accept")
		to_chat(councillor, span_warning("[head.real_name] declines my petition."))
		to_chat(head, span_notice("You decline the petition."))
		return
	// Everything could have changed while the prompt sat open.
	if(QDELETED(councillor) || QDELETED(head) || councillor.stat == DEAD || head.stat == DEAD)
		return
	if(!(head in get_hearers_in_view(petition_range, councillor)))
		to_chat(councillor, span_warning("I'm much too far away now!"))
		to_chat(head, span_warning("They have wandered off before the matter was settled."))
		return
	if(councillor.ministry_active || councillor.ministry_pending || head.ministry_partner)
		to_chat(head, span_warning("The arrangement has already been overtaken by events."))
		return
	if(SSroguemachine.ministry_bureau?.active_ministries?[charter])
		to_chat(head, span_warning("A minister of this house has already been seated."))
		return

	var/datum/ministry/proto = new charter()
	councillor.ministry_pending = proto
	head.ministry_partner = proto
	proto.councillor = councillor
	proto.partner = head

	var/obj/item/paper/scroll/ministry_writ/writ = new(get_turf(head))
	writ.finalize(councillor, head, proto)
	head.put_in_hands(writ)
	head.visible_message(span_notice("[head.real_name] takes [councillor.real_name] into their confidence."))
	to_chat(head, span_notice("You accept the petition. Keep this writ as your record of it."))
	to_chat(councillor, span_notice("[head.real_name] accepts. Go to the bureau in the council chamber to be sworn in."))

// ===== WRIT OF MINISTRY =====
// The partner's copy. Arrives finalized, stays with them. Nothing to sign.

/obj/item/paper/scroll/ministry_writ
	name = "writ of ministry"
	desc = "A charter of appointment, sealed and witnessed."
	icon_state = "contractsigned"
	open = TRUE
	textper = 150
	var/ministry_type

/obj/item/paper/scroll/ministry_writ/proc/finalize(mob/living/carbon/human/minister, mob/living/carbon/human/partner, datum/ministry/M)
	ministry_type = M.type
	name = "writ of the [M.name]"
	desc = "A charter appointing [minister.real_name] to the office of [M.display_title]."
	var/datum/job/ruler = SSjob.GetJobType(/datum/job/roguetown/lord)
	var/ruler_title = ruler?.display_title || ruler?.title || "Grand Duke"
	info = "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#14103f>"
	info += "<center><b>Writ of Ministry</b></center><hr/>"
	info += "Let it be known that, [partner.real_name], [partner.mind?.assigned_role || "of the town"], \
			does receive into their confidence [minister.real_name], Councillor to the [ruler_title], \
			granting unto them the office and privileges of <b>[M.display_title]</b>.<br/><br/>"
	info += "The Minister shall speak for this house within the council chamber. The seal accompanying this writ \
			shall carry their voice, and bear yours in return.<br/><br/>"
	info += "SIGNED,<br/>"
	info += "[minister.real_name], [M.display_title] of [SSmapping.map_adjustment.realm_name]"
	info += "</font>"
	update_icon_state()

/obj/item/paper/scroll/ministry_writ/update_icon_state()
	if(!open)
		icon_state = "scroll_closed"
		name = "scroll"
		return
	icon_state = "contractsigned"

// ===== MINISTER'S SIGNET =====
// Paired with a seal held by the partner. Speak into one, the other hears.

/obj/item/clothing/ring/minister
	name = "minister's signet"
	desc = "A signet ring bearing the mark of a ministerial office. Press it to your lips to speak with your patron."
	icon_state = "signet"
	sellprice = 100
	slot_flags = ITEM_SLOT_RING
	var/obj/item/seal_of_ministry/paired_seal
	var/speech_cooldown = 0
	var/speech_cooldown_time = 1 MINUTES

/obj/item/clothing/ring/minister/Destroy()
	if(paired_seal)
		paired_seal.paired_ring = null
		paired_seal = null
	return ..()

// Works worn or in hand.
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
	if(H.restrained() || H.incapacitated())
		to_chat(H, span_warning("I cannot use this while restrained or incapacitated!"))
		return
	if(world.time < speech_cooldown)
		to_chat(H, span_warning("The ring's metal is still heated from its last use."))
		return
	if(QDELETED(paired_seal))
		to_chat(H, span_warning("The ring has no paired seal. The bond is broken."))
		return
	if(!ismob(get_atom_on_turf(paired_seal, /mob)))
		to_chat(H, span_warning("The seal is not being carried. My words find no one."))
		return
	H.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice("[H] presses their ring against their mouth."))
	var/msg = input(H, "Speak into the ring.", "Ministry Channel") as null|text
	if(!msg || QDELETED(paired_seal))
		return
	speech_cooldown = world.time + speech_cooldown_time
	H.whisper(msg)
	paired_seal.relay_ministry_message(msg, H.real_name, "Minister")

/obj/item/clothing/ring/minister/proc/relay_ministry_message(msg, speaker_name, speaker_role)
	playsound(src, 'sound/misc/scom.ogg', 80, FALSE, -1)
	say("<font color='#C8A84B'><b>[speaker_name] ([speaker_role]):</b> [msg]</font>")

/obj/item/clothing/ring/minister/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	if(!language)
		language = get_default_language()
	// Speak from whatever is sitting on the turf, so a bagged ring still carries.
	var/atom/movable/source = get_atom_on_turf(src, /mob)
	if(!source)
		source = src
	source.send_speech(message, 1, source, , spans, message_language = language)

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

// ===== SEAL OF MINISTRY =====
// The partner's half of the pair.

/obj/item/seal_of_ministry
	name = "seal of ministry"
	desc = "A sealed dispatch bearing a ministerial mark. The wax is soft and dark."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scroll_closed"
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.6
	var/obj/item/clothing/ring/minister/paired_ring
	var/speech_cooldown = 0
	var/speech_cooldown_time = 1 MINUTES

/obj/item/seal_of_ministry/Destroy()
	if(paired_ring)
		paired_ring.paired_seal = null
		paired_ring = null
	return ..()

/obj/item/seal_of_ministry/attack_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.ministry_partner || H.ministry_partner.partner != H)
		to_chat(H, span_warning("The wax is inert. This seal answers to another hand."))
		return
	if(H.restrained() || H.incapacitated())
		to_chat(H, span_warning("I cannot use this while restrained or incapacitated!"))
		return
	if(world.time < speech_cooldown)
		to_chat(H, span_warning("The seal is still reforming from its last break."))
		return
	if(QDELETED(paired_ring))
		to_chat(H, span_warning("The seal has no paired ring. The bond is broken."))
		return
	if(!ismob(get_atom_on_turf(paired_ring, /mob)))
		to_chat(H, span_warning("My minister is not carrying their ring. My words find no one."))
		return
	H.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice("[H] murmurs into the wax of the seal."))
	var/msg = input(H, "Send word to your minister.", "Ministry Channel") as null|text
	if(!msg || QDELETED(paired_ring))
		return
	speech_cooldown = world.time + speech_cooldown_time
	H.whisper(msg)
	paired_ring.relay_ministry_message(msg, H.real_name, "Patron")

/obj/item/seal_of_ministry/proc/relay_ministry_message(msg, speaker_name, speaker_role)
	playsound(src, 'sound/misc/scom.ogg', 80, FALSE, -1)
	say("<font color='#C8A84B'><b>[speaker_name] ([speaker_role]):</b> [msg]</font>")

/obj/item/seal_of_ministry/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	if(!language)
		language = get_default_language()
	// Speak from whatever is sitting on the turf, so a bagged seal still carries.
	var/atom/movable/source = get_atom_on_turf(src, /mob)
	if(!source)
		source = src
	source.send_speech(message, 1, source, , spans, message_language = language)

/obj/item/seal_of_ministry/guild
	name = "guild seal of ministry"
	desc = "A rolled dispatch sealed with the crossed-hammer mark of the Guildmaster. The wax feels warm when held."

/obj/item/seal_of_ministry/church
	name = "church seal of ministry"
	desc = "A scroll bound shut with the Pantheon cross in pale wax. It carries the faint smell of flower petals."

/obj/item/seal_of_ministry/night
	name = "night seal of ministry"
	desc = "A plain roll of parchment, sealed with unmarked black wax. Nothing about it invites curiosity."

/obj/item/seal_of_ministry/inquisition
	name = "inquisition seal of ministry"
	desc = "A tightly rolled writ sealed with a silver stamp. The edges are sharp and precise."

/obj/item/seal_of_ministry/mage
	name = "arcane seal of ministry"
	desc = "A scroll whose wax seal faintly glows with a glyph that shifts when you aren't looking directly at it."

/obj/item/seal_of_ministry/physician
	name = "physician seal of ministry"
	desc = "A clinical roll of parchment sealed in dark red wax. Smells faintly of camphor."

/obj/item/seal_of_ministry/innkeeper
	name = "tavern seal of ministry"
	desc = "A short scroll sealed with the inn's tap-mark pressed into amber wax. It smells vaguely of ale."

/obj/item/seal_of_ministry/merchant
	name = "trade seal of ministry"
	desc = "A folded dispatch sealed with the merchant's mark in green wax, the edges worn from handling."
