// Miscellaneous/novelty statpacks

/datum/statpack/wildcard/wretched
	name = "Wretched"
	desc = "The cruelty of Enigma leaves many in its wake - you among them. But with her terrible eye turned elsewhere, perhaps it is time for your fortune to be made..."
	stat_array = list(STAT_STRENGTH = -2, STAT_PERCEPTION = -2, STAT_INTELLIGENCE = -2, STAT_CONSTITUTION = -2, STAT_WILLPOWER = -2, STAT_SPEED = -2, STAT_FORTUNE = 3)

/datum/statpack/wildcard/fated
	name = "Fated"
	desc = "The first or the last - let destiny's fickle loom decree what your fate shall be."
	stat_array = list(STAT_STRENGTH = list(-2, 2), STAT_PERCEPTION = list(-2, 2), STAT_INTELLIGENCE = list(-2, 2), STAT_CONSTITUTION = list(-2, 2), STAT_WILLPOWER = list(-2, 2), STAT_SPEED = list(-2, 2), STAT_FORTUNE = list(-2, 2))

/datum/statpack/wildcard/frail
	name = "Frail"
	desc = "The growing dark limns your vision more with every passing day: your flesh and mind are failing you, and destiny has turned her gaze from you. How will your tale endure such hardship?"
	stat_array = list(STAT_STRENGTH = -4, STAT_PERCEPTION = -4, STAT_INTELLIGENCE = -4, STAT_CONSTITUTION = -4, STAT_WILLPOWER = -4, STAT_SPEED = -4, STAT_FORTUNE = -4)

/datum/statpack/wildcard/austere
	name = "Austere"
	desc = "You've kept your humors balanced, your body honed and mind sharp enough. Fate has left you mostly unchanged, in every way."

/datum/statpack/wildcard/virtuous
	name = "Virtuous"
	desc = "The breadth of my being is one of many, distinguished talents. \n (Allows access to 'virtues', special traits/quirks that replace the bonus normally given by a statpack.)"



//------------------------------------------------------------------
/datum/statpack/wildcard/crimson_blooded
	name = "Sanguine Noctis"
	min_pq = 30
	desc = "<span style='color: #8B0000;'><b>⚠ Requires 30 PQ ⚠</b></span><br>\
	<span style='color: #DAA520;'>When <span style='color: #FFD700;'><b>Psydon</b></span> fell to Zizo's spear, His divine lifeblood—the <span style='color: #C0C0C0;'><b>Argentum</b></span>—spilled across the world. \
	A portion, corrupted by Zizo's necrotic touch and the All-Father's despair, became the <span style='color: #DC143C;'><b>Sanguine Noctis</b></span>. \
	The Naledi war-scholars sought to harness this power in the <span style='color: #4B0082;'><b>Umbra Chasm</b></span>, but birthed the first Vampyrs instead—creatures of paradox, \
	forever cursed to walk between life and death. <b>Click 'Read Lore Primer' to learn more.</b></span><br><br>\
	<span style='color: #00FF00;'><b>✦ DARK GIFTS ✦</b></span><br>\
	<span style='color: #90EE90;'>• <b>Vampiric Bite:</b> Drain the living Argentum from mortal blood to fuel your cursed existence</span><br>\
	<span style='color: #98FB98;'>• <b>Eyes of Night:</b> Pierce the deepest darkness with darkvision</span><br>\
	<span style='color: #32CD32;'>• <b>Dual Covenant:</b> Master one vampiric coven AND one god-aligned coven (11 research points total)</span><br>\
	<span style='color: #00FA9A;'>• <b>Sire's Curse:</b> Create new vampyrs by draining mortals to near-death (requires consent)</span><br>\
	<span style='color: #20B2AA;'>• <b>Torpor Regeneration:</b> Rest in coffins to enter deathless slumber and heal wounds</span><br><br>\
	<span style='color: #FF0000;'><b>☠ TERRIBLE PRICE ☠</b></span><br>\
	<span style='color: #FF6347;'>• <b>Astrata's Scorn:</b> Sunlight burns you horribly—remain in shadow or perish</span><br>\
	<span style='color: #FF4500;'>• <b>Silver Bane:</b> Sacred silver triggers blood frenzy and causes severe pain</span><br>\
	<span style='color: #DC143C;'>• <b>Blood Hunger:</b> Must consume living blood to survive.</span><br>\
	<span style='color: #B22222;'>• <b>Mortal Emotions:</b> Unlike true vampyrs, you still feel pain and emotion fully, and die to mortal wounds as any living being.</span><br>\
	<span style='color: #8B0000;'>• <b>Necra's Ire:</b> Trapped outside rebirth, hunted by Morticians and vampyr purists alike</span><br><br>\
	<span style='color: #9370DB;'><i>Traits: Vampire Bite • No Sleep • Darkvision • Limb Attachment • Silver Weakness • Vampiric Dreams • Wild Eater • Deadite Infection Immunity </i></span>"



// Apply immediately and schedule vampire setup until mind exists
/datum/statpack/wildcard/crimson_blooded/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient)
		return FALSE
	// Check PQ requirement first
	if(!isnull(min_pq) && recipient.client)
		var/player_pq = get_playerquality(recipient.client.ckey)
		if(player_pq < min_pq)
			to_chat(recipient, span_warning("You do not meet the Player Quality requirement ([min_pq] PQ) for this statpack."))
			return FALSE
	// Defer antag creation until mind exists, in case roll_stats runs before mind attach
	ensure_crimson_vampire(recipient)
	recipient.update_health_hud()
	record_featured_object_stat(FEATURED_STATS_STATPACKS, name)
	return TRUE

/datum/statpack/wildcard/crimson_blooded/proc/ensure_crimson_vampire(mob/living/carbon/human/H, tries = 40)
	if(!H || QDELETED(H))
		return FALSE
	if(H.mind)
		// If already has a vampire antag, do nothing (includes Vampire Lord)
		if(locate(/datum/antagonist/vampire) in H.mind.antag_datums)
			// Ensure the player's HUD exists (create if client attached), then set bloodpool color
			if(H.client && !H.hud_used)
				H.create_mob_hud()
			if(H.hud_used && H.hud_used.bloodpool)
				H.hud_used.bloodpool.set_fill_color("#510000")
			return TRUE
		// Don't override if they're assigned to be a vampire antagonist (Vampire Lord/Servant)
		if(H.mind.special_role == ROLE_NBEAST || H.mind.special_role == ROLE_VAMPIRE)
			return TRUE
		// Don't override if they're assigned to be a vampire antagonist (Vampire Lord/Servant)
		if(H.mind.special_role == ROLE_NBEAST || H.mind.special_role == ROLE_VAMPIRE)
			return TRUE
		var/datum/antagonist/vampire/crimson/new_antag = new /datum/antagonist/vampire/crimson()
		H.mind.add_antag_datum(new_antag)
		// Ensure bloodpool HUD is initialized after antag is added
		if(H.hud_used && !H.hud_used.bloodpool)
			addtimer(CALLBACK(src, PROC_REF(init_bloodpool_hud), H), 1 SECONDS)
		return TRUE
	if(tries <= 0)
		to_chat(H, span_warning("Could not finalize Crimson-Blooded setup. Please notify admins."))
		return FALSE
	addtimer(CALLBACK(src, PROC_REF(ensure_crimson_vampire), H, tries - 1), 2 SECONDS)
	return TRUE


/datum/statpack/wildcard/crimson_blooded/proc/init_bloodpool_hud(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return
	// If the client is attached but HUD wasn't created, create it now
	if(H.client && !H.hud_used)
		H.create_mob_hud()
	// If HUD exists and has a bloodpool, set its color
	if(H.hud_used && H.hud_used.bloodpool)
		H.hud_used.bloodpool.set_fill_color("#510000")
