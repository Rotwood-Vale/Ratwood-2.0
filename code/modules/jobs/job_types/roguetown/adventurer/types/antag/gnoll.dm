/datum/job/roguetown/gnoll
	title = "Gnoll"
	flag = GNOLL
	antag_job = TRUE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "你已向 格拉加 证明了自己的价值，而他也赐下了至高的祝福。如今你要去追猎配得上你的对手，寻找那些强到足以让你流血的人。"
	outfit = null
	outfit_female = null
	display_order = JDO_GNOLL
	show_in_credits = TRUE
	min_pq = 30 //Same as wretches for now
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_GNOLL = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/utility/noble) //Are you for real?
	job_subclasses = list(
		/datum/advclass/gnoll/berserker,
		/datum/advclass/gnoll/knight,
		/datum/advclass/gnoll/templar,
		/datum/advclass/gnoll/shaman,
	)

/datum/job/roguetown/gnoll/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Ensure gnolls are represented in the antagonist list.
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/gnoll))
			var/datum/antagonist/new_antag = new /datum/antagonist/gnoll()
			H.mind.add_antag_datum(new_antag)
			H.verbs |= /mob/living/carbon/human/proc/gnoll_inspect_skin


/mob/living/carbon/human/proc/apply_gnoll_preferences(initial_setup = TRUE)
	if(!client?.prefs?.gnoll_prefs)
		return FALSE

	// Species swaps do not always clear extra body zones from prior forms.
	// Purge lamia/taur leftovers so gnolls only use gnoll body setup.
	ensure_not_taur()

	reset_gnoll_sprite_scale()

	// Gnoll role always belongs to Graggar, regardless of the source slot's faith.
	set_patron(/datum/patron/inhumen/graggar)

	if(initial_setup)
		// Gnolls should be a blank slate at spawn; strip inherited vice/virtue state from base character prefs.
		if(length(vices))
			for(var/datum/charflaw/vice as anything in vices)
				vice.on_removal(src)
		if(charflaw && !(charflaw in vices))
			charflaw.on_removal(src)
		vices = list()
		charflaw = null
		headshot_link = null

	// Gnolls should not inherit player-authored social metadata from their base slot.
	rumour = null
	noble_gossip = null

	if(status_traits)
		for(var/trait in status_traits.Copy())
			if(HAS_TRAIT_FROM(src, trait, TRAIT_VIRTUE))
				REMOVE_TRAIT(src, trait, TRAIT_VIRTUE)

	// Explicitly purge known lamia/mount carryover paths that can survive species swaps.
	REMOVE_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE, BODY_ZONE_TAUR)
	REMOVE_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE, TRAIT_VIRTUE)
	REMOVE_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE, TRAIT_GENERIC)
	REMOVE_TRAIT(src, TRAIT_LAMIAN_TAIL, INNATE_TRAIT)
	REMOVE_TRAIT(src, TRAIT_LAMIAN_TAIL, TRAIT_VIRTUE)
	REMOVE_TRAIT(src, TRAIT_LAMIAN_TAIL, TRAIT_GENERIC)

	var/datum/gnoll_prefs/prefs = client.prefs.gnoll_prefs

	// Gnolls are assigned their own subclass statlines later in equip flow; wipe inherited statpack roll during initial setup only.
	if(initial_setup)
		roll_stats()
	refresh_live_vocal_preferences()

	fully_replace_character_name(real_name, prefs.ensure_gnoll_name())

	if(prefs.gnoll_pronouns)
		pronouns = prefs.gnoll_pronouns

	icon_state = prefs.pelt_type || "firepelt"
	dna?.species?.custom_base_icon = prefs.pelt_type || "firepelt"

	var/wants_penis = !!prefs.genitals["penis"]
	var/wants_vagina = !!prefs.genitals["vagina"]
	var/wants_breasts = !!prefs.genitals["breasts"]

	var/obj/item/organ/penis/penis = getorganslot(ORGAN_SLOT_PENIS)
	if(wants_penis)
		if(!penis)
			penis = new /obj/item/organ/penis/knotted/big()
			penis.Insert(src, TRUE, FALSE)
		var/obj/item/organ/testicles/testicles = getorganslot(ORGAN_SLOT_TESTICLES)
		if(!testicles)
			testicles = new()
			testicles.ball_size = MAX_TESTICLES_SIZE
			testicles.Insert(src, TRUE, FALSE)
	else if(penis)
		penis.Remove(src)
		qdel(penis)
		var/obj/item/organ/testicles/testicles = getorganslot(ORGAN_SLOT_TESTICLES)
		if(testicles)
			testicles.Remove(src)
			qdel(testicles)

	var/obj/item/organ/vagina/vagina = getorganslot(ORGAN_SLOT_VAGINA)
	if(wants_vagina)
		if(!vagina)
			vagina = new /obj/item/organ/vagina()
			vagina.accessory_type = /datum/sprite_accessory/vagina/furred
			vagina.Insert(src, TRUE, FALSE)
	else if(vagina)
		vagina.Remove(src)
		qdel(vagina)

	var/obj/item/organ/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
	if(wants_breasts)
		if(!breasts)
			breasts = new()
			breasts.Insert(src, TRUE, FALSE)
	else if(breasts)
		breasts.Remove(src)
		qdel(breasts)

	update_body()
	ambushable = FALSE
	clear_mob_descriptors()
	add_mob_descriptor(/datum/mob_descriptor/stature/gnoll)
	add_mob_descriptor(prefs.descriptor_height || /datum/mob_descriptor/height/moderate)
	add_mob_descriptor(prefs.descriptor_body || /datum/mob_descriptor/body/muscular)
	add_mob_descriptor(prefs.descriptor_fur || /datum/mob_descriptor/fur/coarse)
	add_mob_descriptor(prefs.descriptor_voice || /datum/mob_descriptor/voice/growly)
	add_mob_descriptor(prefs.descriptor_muzzle || /datum/mob_descriptor/face/gnoll/long_muzzle)
	add_mob_descriptor(prefs.descriptor_expression || /datum/mob_descriptor/face_exp/gnoll/alert)
	return TRUE

/mob/living/carbon/human/proc/reset_gnoll_sprite_scale()
	if(!dna?.features)
		return FALSE
	dna.features["body_size"] = BODY_SIZE_NORMAL
	dna.update_body_size()
	return TRUE

/datum/outfit/job/roguetown/gnoll/proc/don_pelt(mob/living/carbon/human/H)
	if(H.mind)
		H.apply_gnoll_preferences()
		H.set_blindness(0)
		H.regenerate_icons()
		H.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/howl/gnoll)
		H.AddComponent(/datum/component/gnoll_combat_tracker)

		var/obj/effect/proc_holder/spell/invoked/gnoll_sniff/F = new()
		var/obj/effect/proc_holder/spell/invoked/invisibility/gnoll/I = new()

		var/obj/effect/proc_holder/spell/invoked/abduct/S = new /obj/effect/proc_holder/spell/invoked/abduct()
		S.destination_turf = get_turf(H) // Set the anchor to where they spawn/don the outfit
		H.AddSpell(S)
		H.AddSpell(F)
		H.AddSpell(I)

		to_chat(H, span_boldwarning("即便身为豺狼人，你依旧要遵守角色扮演要求。豺狼人是狡诈的猎手，不是无脑的野兽。\
									暗星对你的期许极高，屠戮弱者并无多少荣耀可言。"))
		to_chat(H, span_biginfo("你对最低垂的果实毫无兴趣，轻而易举的猎获只会让你的主人感到乏味。急着扑向这类猎物，是<i>有失身份</i>的。 \n") \
			+ span_notice("更好的做法，是去寻找猎物中最有价值的那些，并确保这场追猎对所有参与者而言都足够惊险。"))
		to_chat(H, span_biginfo("*-------*"))

		var/mode = SSgnoll_scaling.get_gnoll_scaling()
		if(mode == GNOLL_SCALING_NONE)
			to_chat(H, span_smallnotice("依我看，这周不会有任何豺狼人援军到来。") + span_info("我必须依靠狡诈，而不是数量。"))
		else if(mode != GNOLL_SCALING_DOUBLE)
			to_chat(H, span_smallnotice("这周我应当会与我的族群会合。") + span_info("我该等他们到了再集结行动。"))
		else
			to_chat(H, span_smallnotice("这周我的族群规模不大。") + span_info("我该先与其他豺狼人会合，在能一同狩猎前避免鲁莽交战。"))
		to_chat(H, span_info("耐心与周密谋划，才是我这门技艺真正的美德。若我无法将目标孤立出来，换一只猎物去尾随才更明智。 \n\
									追踪棘手目标时，我应当在野外扎营，并设法结成同盟。"))
		to_chat(H, span_warning("那群匪徒渣滓不配得到我的援助。"))
		to_chat(H, span_biginfo("*------*"))

/mob/living/carbon/human/proc/gnoll_inspect_skin()
	set name = "检查毛皮"
	set category = "豺狼人"
	set desc = "查看我的豺狼人皮甲"
	if(!istype(skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor))
		to_chat(src, span_warning("我身上没有可供检查的豺狼人皮甲！"))
		return
	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/GA = skin_armor
	GA.Topic(null, list("inspect" = "1"), src)
