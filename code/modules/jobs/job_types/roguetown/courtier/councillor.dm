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
	if(SSmapping.config.map_name == "Rockhill")
		armor = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/councillor
		cloak = null
		mask = null

// ===== MINISTER SYSTEM =====
// Councillors draft a writ at the ministerial archive. They bring it to a
// faction leader, who finalizes it. The councillor then returns the finalized
// writ to the archive to be sworn in, gaining an income boost, signet ring,
// keys, and archive benefits (skills and traits that match their position). 
// The patron receives a seal to contact their minister, 2-way private comms.

/datum/ministry
	var/name = "Ministry"
	var/display_title = "Minister"
	var/income_bonus = 20
	var/list/ministry_keys = list()
	var/list/archive_traits = list()
	var/list/archive_skills = list()
	var/ring_type = null
	var/seal_type = null
	var/mob/living/carbon/human/councillor = null
	var/mob/living/carbon/human/partner = null
	var/active = FALSE

/datum/ministry/proc/archive_bonus(mob/living/carbon/human/H)
	return

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
	if(istype(H.patron, /datum/patron/godless))
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
			to_chat(H, span_warning("You are already bound to a credo more alive than PSYDON's. The Old God will not share."))
			return
		H.devotion.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
		to_chat(H, span_notice("The archive reaffirms your covenant. ENDVRE."))
		return
	var/datum/devotion/C = new /datum/devotion(H, GLOB.patronlist[/datum/patron/old_god])
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
	to_chat(H, span_notice("The dusty notes in the back of the archive remind you of the Old God's covenant. ENDVRE."))

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
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	H.mind.adjust_spellpoints(9)
	to_chat(H, span_notice("The archive imparts the arcyne secrets of the previous Minister. You feel a thrum of latent power."))

/datum/ministry/physician
	name = "Physician Ministry"
	display_title = "Minister of Health"
	ministry_keys = list(/obj/item/roguekey/physician, /obj/item/roguekey/courtphysician)
	archive_traits = list(TRAIT_EMPATH, TRAIT_MEDICINE_EXPERT)
	archive_skills = list(/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT)
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
	ministry_keys = list(/obj/item/roguekey/shop)
	archive_traits = list(TRAIT_SEEPRICES, TRAIT_CICERONE)
	archive_skills = list(/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN)
	ring_type = /obj/item/clothing/ring/minister/merchant
	seal_type = /obj/item/seal_of_ministry/merchant

/proc/get_ministry_for_job(job_title)
	switch(job_title)
		if("Guildmaster")
			return /datum/ministry/guild
		if("Bishop")
			return /datum/ministry/church
		if("Bathmaster")
			return /datum/ministry/night
		if("Inquisitor")
			return /datum/ministry/inquisition
		if("Court Magician")
			return /datum/ministry/mage
		if("Head Physician")
			return /datum/ministry/physician
		if("Innkeeper")
			return /datum/ministry/innkeeper
		if("Merchant")
			return /datum/ministry/merchant
	return null

/proc/establish_ministry(mob/living/carbon/human/councillor, mob/living/carbon/human/partner, datum/ministry/M, atom/archive)
	M.councillor = councillor
	M.partner = partner
	M.active = TRUE
	councillor.ministry_active = M
	partner.ministry_partner = M

	SStreasury.noble_incomes[councillor] += M.income_bonus

	var/obj/item/clothing/ring/minister/ring = new M.ring_type(get_turf(councillor))
	var/obj/item/seal_of_ministry/seal = new M.seal_type(get_turf(partner))
	ring.paired_seal = seal
	seal.paired_ring = ring

	councillor.put_in_hands(ring)
	councillor.put_in_hands(seal)

	var/turf/key_turf = archive ? get_turf(archive) : get_turf(councillor)
	for(var/key_type in M.ministry_keys)
		new key_type(key_turf)

/mob/living/carbon/human
	var/datum/ministry/ministry_active = null
	var/datum/ministry/ministry_partner = null
	var/ministry_archive_consulted = FALSE


// ===== MINISTRY WRIT =====
// Writs prompt the faction heads whether they want to opt in to having a minister.

/obj/item/ministry_writ
	name = "draft writ of ministry"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "contractunsigned"
	w_class = WEIGHT_CLASS_SMALL
	var/ministry_type = null
	var/mob/living/carbon/human/author = null
	var/mob/living/carbon/human/signatory = null

/obj/item/ministry_writ/Initialize(mapload)
	. = ..()
	update_writ()

/obj/item/ministry_writ/proc/update_writ()
	if(ministry_type)
		var/datum/ministry/proto = new ministry_type()
		name = "[proto.name] writ"
		icon_state = "contractsigned"
		desc = "A finalized writ of the [proto.name], bearing the seal of the appropriate faction head. Return it to the ministerial archive to be sworn in."
		qdel(proto)
	else
		name = "draft writ of ministry"
		icon_state = "contractunsigned"
		desc = "A draft writ of ministry, as yet unsigned. Present it to a faction head — Guildmaster, Bishop, Bathmaster, Inquisitor, Court Magician, Head Physician, Innkeeper, or Merchant — and ask them to finalize it."

/obj/item/ministry_writ/examine(mob/user)
	. = ..()
	. += span_notice("Councillor: [author ? author.real_name : "Unknown"]")
	. += span_notice("Sponsored By: [signatory ? signatory.real_name : "—"]")

/obj/item/ministry_writ/attack_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(ministry_type)
		to_chat(H, span_warning("This writ has already been finalized."))
		return
	if(!H.mind || !H.mind.assigned_role)
		return
	var/new_type = get_ministry_for_job(H.mind.assigned_role)
	if(!new_type)
		to_chat(H, span_warning("Your office holds no ministerial charter to grant."))
		return
	if(H.ministry_partner)
		to_chat(H, span_warning("You have already appointed a minister."))
		return
	if(alert(H, "Finalize this writ and appoint a minister to your domain? They will gain keys and knowledge of your trade.", "Ministry Writ", "Finalize", "Cancel") != "Finalize")
		return
	ministry_type = new_type
	signatory = H
	update_writ()
	H.visible_message(
		span_notice("[H.real_name] signs [H.p_their()] name to the paper, finalizing the [name]."),
		span_notice("You finalize the [name]. Return it to the councillor, that they might archive it to complete the appointment.")
	)

// ===== MINISTER SIGNET RING =====
// Right-click to speak privately to the paired seal.

/obj/item/clothing/ring/minister
	name = "minister's signet"
	desc = "A signet ring bearing the seal of a ministerial office. Press it to your lips to speak with your appointed patron."
	icon = 'icons/roguetown/clothing/rings.dmi'
	icon_state = "signet"
	sellprice = 100
	slot_flags = ITEM_SLOT_RING
	var/obj/item/seal_of_ministry/paired_seal = null
	var/ministry_cooldown = 0
	var/ministry_cooldown_time = 600 // 1 minute

/obj/item/clothing/ring/minister/attack_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(world.time < ministry_cooldown)
		to_chat(H, span_warning("The ring's gem is still warm from its last use."))
		return
	if(!paired_seal || QDELETED(paired_seal))
		to_chat(H, span_warning("The ring has no paired seal — the ministry bond is broken."))
		return
	if(!ismob(paired_seal.loc))
		to_chat(H, span_warning("The seal is not being carried. Your words find no one."))
		return
	var/msg = input(H, "Speak into the ring.", "Ministry Channel") as null|text
	if(!msg)
		return
	ministry_cooldown = world.time + ministry_cooldown_time
	H.visible_message(span_notice("[H.real_name] presses their ring to their lips and murmurs quietly."))
	paired_seal.receive_ministry_message(msg, H.real_name, "Minister")

/obj/item/clothing/ring/minister/proc/receive_ministry_message(msg, speaker_name, speaker_role)
	playsound(src, 'sound/misc/scom.ogg', 80, FALSE, -1)
	send_speech("<font color='#C8A84B'><b>[speaker_name] ([speaker_role]):</b> [msg]</font>", 1, src)

/obj/item/clothing/ring/minister/guild
	name = "guild minister's signet"
	desc = "A well-worn signet ring, yet smoke-stained from the fires of the Guild."
	icon_state = "signet"

/obj/item/clothing/ring/minister/church
	name = "church minister's signet"
	desc = "A holy ring befitting a priest of the Divine Pantheon, now besmirched by court politick."
	icon_state = "signet_silver"

/obj/item/clothing/ring/minister/night
	name = "night minister's signet"
	desc = "An unassuming, sleek ring. Careful that it does not sink to the bottom of the baths."
	icon_state = "signet"

/obj/item/clothing/ring/minister/inquisition
	name = "inquisition minister's signet"
	desc = "A signet ring bearing the Inquisition's mark. An ENDVRING fashion choice, if outdated."
	icon_state = "signet_silver"

/obj/item/clothing/ring/minister/mage
	name = "arcane minister's signet"
	desc = "A ring faintly warm to the touch, marked with an arcyne glyph."
	icon_state = "signet"

/obj/item/clothing/ring/minister/physician
	name = "physician minister's signet"
	desc = "A ring bearing the Pestran tendrils of the court physician's office."
	icon_state = "signet"

/obj/item/clothing/ring/minister/innkeeper
	name = "tavern minister's signet"
	desc = "A ring bearing the inn's tap-mark. Its sheen is scratched by knife and cutting board."
	icon_state = "signet"

/obj/item/clothing/ring/minister/merchant
	name = "trade minister's signet"
	desc = "A ring bearing the mammon-hoarding marque of the Merchant's Guild."
	icon_state = "signet"

// ===== SEAL OF MINISTRY =====
// Held or carried by the faction head partner.
// Right-click to speak privately to the paired ring.

/obj/item/seal_of_ministry
	name = "seal of ministry"
	desc = "A sealed dispatch bearing a ministerial mark. The wax is soft and dark."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scroll_closed"
	w_class = WEIGHT_CLASS_TINY
	var/obj/item/clothing/ring/minister/paired_ring = null
	var/ministry_cooldown = 0
	var/ministry_cooldown_time = 600 // 1 minute

/obj/item/seal_of_ministry/attack_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(world.time < ministry_cooldown)
		to_chat(H, span_warning("The seal is still reforming from its last break. Try again in a minute."))
		return
	if(!paired_ring || QDELETED(paired_ring))
		to_chat(H, span_warning("The seal has no paired ring — the ministry bond is broken."))
		return
	if(!ismob(paired_ring.loc))
		to_chat(H, span_warning("Your minister is not carrying the ring. Your words find no one."))
		return
	var/msg = input(H, "Send word to your minister.", "Ministry Channel") as null|text
	if(!msg)
		return
	ministry_cooldown = world.time + ministry_cooldown_time
	H.visible_message(span_notice("[H.real_name] breaks the seal on the token and murmurs quietly into it."))
	paired_ring.receive_ministry_message(msg, H.real_name, "Patron")

/obj/item/seal_of_ministry/proc/receive_ministry_message(msg, speaker_name, speaker_role)
	playsound(src, 'sound/misc/scom.ogg', 80, FALSE, -1)
	send_speech("<font color='#C8A84B'><b>[speaker_name] ([speaker_role]):</b> [msg]</font>", 1, src)



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
	desc = "A tightly rolled writ sealed with the Archbishop's silver stamp. The edges are sharp and precise."

/obj/item/seal_of_ministry/mage
	name = "arcane seal of ministry"
	desc = "A scroll whose wax seal faintly glows with a glyph that shifts when you aren't looking directly at it."

/obj/item/seal_of_ministry/physician
	name = "physician seal of ministry"
	desc = "A clinical roll of parchment sealed with the caduceus in dark red wax. Smells faintly of camphor."

/obj/item/seal_of_ministry/innkeeper
	name = "tavern seal of ministry"
	desc = "A short scroll sealed with the inn's tap-mark pressed into amber wax. It smells vaguely of ale."

/obj/item/seal_of_ministry/merchant
	name = "trade seal of ministry"
	desc = "A folded dispatch sealed with the merchant's mark in green wax, the edges worn from handling."
