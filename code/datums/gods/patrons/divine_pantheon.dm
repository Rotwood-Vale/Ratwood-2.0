/datum/patron/divine
	name = null
	associated_faith = /datum/faith/divine

//What're you? A lunatic. That's all you've ever been.
//No miracles. No care. Suffer, as the Ten do.
/datum/patron/divine/undivided
	name = "Undivided"
	domain = "Absolutely nothing."
	desc = "A misguided attempt, of aeons past, to worship all Ten of the Pantheon. The council did not care for this. To split one's faith is to split their mind. \
	As such, those who'd adhered to this doctrine have long since gone mad. Or, perhaps, have faith in a world that has since left them behind."
	worshippers = "Lunatics."
	confess_lines = list(
		"THE TEN SHALL SAVE ME, I KNOW IT!",
		"I DREAM OF A BETTER WORLD!",
		"FORGIVE ME!",
	)
	storyteller = null
	disabled_patron = TRUE//Another selection, m'lord.

//Under no circumstance do we care.
/datum/patron/divine/undivided/hear_prayer(mob/living/follower)
	to_chat(follower, span_danger("The Ten have no pity for once such as you."))
	return FALSE//Borderline apostasy.

//End of absurdity. Start of normalcy.
/datum/patron/divine/astrata
	name = "Astrata"
	domain = "The Day, The Sun, Order"
	desc = "The Absolute Order is the glorious sunlight that permeates our lands and drives back evil. By Her Light is the world given Order, and by her Blessing is Nobility deigned to rule. Ravox stands at Her side to ensure Her Order does not become Tyranny."
	worshippers = "Nobility, The Righteous, The Zealous"
	mob_traits = list(TRAIT_APRICITY)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/ignition				= CLERIC_T0,
					/obj/effect/proc_holder/spell/self/astrata_gaze				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/astratan_path			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/heal					= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/revive				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/immolation			= CLERIC_T4,
	)
	confess_lines = list(
		"ASTRATA IS MY LIGHT!",
		"ASTRATA BRINGS LAW!",
		"I SERVE THE GLORY OF THE SUN!",
	)
	storyteller = /datum/storyteller/astrata

/datum/patron/divine/noc
	name = "Noc"
	domain = "The Night, The Moon, Knowledge, Magic, Secrets"
	desc = "The Father of Secrets is the glorious moonlight that grants us power through knowledge. We are granted visions of His vault of secrets, and given the ability to wield the Arcyne through His benevolence."
	worshippers = "Wizards, Scholars, Night Owls"
	mob_traits = list(TRAIT_NIGHT_OWL, TRAIT_NOCSIGHT)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/noc_sight				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/darkvision/miracle	= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/invisibility/miracle	= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blindness				= CLERIC_T2,
					/obj/effect/proc_holder/spell/self/noc_spell_bundle			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/noc			= CLERIC_T4,
	)
	confess_lines = list(
		"NOC IS NIGHT!",
		"NOC SEES ALL!",
		"I SEEK THE MYSTERIES OF THE MOON!",
	)
	storyteller = /datum/storyteller/noc

/datum/patron/divine/dendor
	name = "Dendor"
	domain = "Plants, Animals, Nature, Agriculture"
	desc = "The Treefather was the First Druid, driven mad by the abuse of His realm. Even still, He stands vigil over the woods and the plains, blessing our harvests and our livelihoods. His beasts show us no quarter, but we can learn to avoid their jaws."
	worshippers = "Druids, Beasts, Madmen, Farmers, Elves, Wildkin"
	mob_traits = list(TRAIT_KNEESTINGER_IMMUNITY, TRAIT_LEECHIMMUNE)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/spiderspeak 			= CLERIC_T0,
					/obj/effect/proc_holder/spell/targeted/blesscrop			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/targeted/wildshape			= CLERIC_T2,
					/obj/effect/proc_holder/spell/targeted/beasttame			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/targeted/conjure_glowshroom	= CLERIC_T3,
					/obj/effect/proc_holder/spell/self/howl/call_of_the_moon	= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/dendor		= CLERIC_T4,
	)
	confess_lines = list(
		"DENDOR PROVIDES!",
		"THE TREEFATHER BRINGS BOUNTY!",
		"I ANSWER THE CALL OF THE WILD!",
	)
	storyteller = /datum/storyteller/dendor

/datum/patron/divine/abyssor
	name = "Abyssor"
	domain = "The Seas, Dreams, Purity, Cleansing"
	desc = "The Pure Tide disappeared into a slumber, without considering that His dreams would inspire followers of His Divine Absence. The twisted minds and bodies of the Dreamers have corrupted His realm, though through His waters may we be cleansed. If He awakens, the world will be cleansed in full."
	worshippers = "Fishermen, Axians, Lamia, Dreamers, Madmen"
	mob_traits = list(TRAIT_ABYSSOR_SWIM, TRAIT_SEA_DRINKER)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/aquatic_compulsion	= CLERIC_T0,
					/obj/effect/proc_holder/spell/self/abyssor_wind				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/abyssor_bends			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/abyssor_undertow		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/abyssheal				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/call_mossback			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/call_dreamfiend		= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/abyssal_infusion		= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/abyssor		= CLERIC_T4,
	)
	confess_lines = list(
		"ABYSSOR COMMANDS THE WAVES!",
		"THE OCEAN'S FURY IS ABYSSOR'S WILL!",
		"I AM DRAWN BY THE PULL OF THE TIDE!",
	)

	storyteller = /datum/storyteller/abyssor

/datum/patron/divine/ravox
	name = "Ravox"
	domain = "Justice, Battle, Glory, Righteous Fury"
	desc = "The Glorious Justice plays as foil to Astrata's Order, preventing the world from being ruled by the Sun's Tyranny. He is an impartial God who exists solely to enforce Divine Justice. His followers are often misguided in their pursuit of such."
	worshippers = "Warriors, Mercenaries, Knights, Seekers of Justice"
	mob_traits = list(TRAIT_SHARPER_BLADES, TRAIT_JUSTICARSIGHT)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/tug_of_war			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/divine_strike			= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/call_to_arms				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/challenge				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/persistence			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/ravox		= CLERIC_T4,
	)
	confess_lines = list(
		"RAVOX IS JUSTICE!",
		"THROUGH STRIFE, GRACE!",
		"THROUGH PERSISTENCE, GLORY!",
	)
	storyteller = /datum/storyteller/ravox

/datum/patron/divine/necra
	name = "Necra"
	domain = "Death, The Afterlife, Rebirth"
	desc = "The Undermaiden is the custodian of the Afterlife, where all souls must eventually go. She tasks the lost with the Trials of the Forgotten, where they must ruminate on their lyfe to be reborn. Her followers find resurrection to be abhorrent, choosing to isolate themselves to their graveyards."
	worshippers = "Gravediggers, Morticians, Disgraced Physicians, Loners"
	mob_traits = list(TRAIT_SOUL_EXAMINE, TRAIT_NOSTINK)	//No stink is generic but they deal with dead bodies so.. makes sense, I suppose?
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/necras_sight			= CLERIC_T0,
					/obj/effect/proc_holder/spell/targeted/burialrite			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/avert					= CLERIC_T1,
					// /obj/effect/proc_holder/spell/invoked/deaths_door			= CLERIC_T1, // Investigate the 'crashes' and emotes becoming impossible to see. Re-enable if certain it works without issue.
					/obj/effect/proc_holder/spell/targeted/abrogation			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance = CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/speakwithdead		= CLERIC_T3,
	)
	confess_lines = list(
		"ALL SOULS FIND THEIR WAY TO NECRA!",
		"THE UNDERMAIDEN IS OUR FINAL REPOSE!",
		"I FEAR NOT DEATH, MY LADY AWAITS ME!",
	)
	storyteller = /datum/storyteller/necra

/datum/patron/divine/xylix
	name = "Xylix"
	domain = "Trickery, Freedom, Inspiration, Fate, Fluvians"
	desc = "The Trickster is an unknown amongst the Pantheon. They created the Fluvian race with the gift of Fate, and serve the sole purpose of pulling pranks on Gods and Mortals alike. Their followers see freedom as an absolute, and despise slavery."
	worshippers = "Gamblers, Bards, Artists, The Silver-Tongued, Fluvians"
	mob_traits = list(TRAIT_XYLIX)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/xylixslip				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/xylixlian_luck        = CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/wheel					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/mockery				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/mastersillusion		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/xylix		= CLERIC_T4,
	)
	confess_lines = list(
		"ASTRATA IS MY LIGHT!",
		"NOC IS NIGHT!",
		"DENDOR PROVIDES!",
		"ABYSSOR COMMANDS THE WAVES!",
		"RAVOX IS JUSTICE!",
		"ALL SOULS FIND THEIR WAY TO NECRA!",
		"HAHAHAHA! AHAHAHA! HAHAHAHA!",
		"PESTRA SOOTHES ALL ILLS!",
		"MALUM IS MY MUSE!",
		"EORA BRINGS US TOGETHER!",
		"LONG LIVE ZIZO!",
		"GRAGGAR IS THE BEAST I WORSHIP!",
		"MATTHIOS IS MY LORD!",
		"BAOTHA IS MY JOY!",
		"REBUKE THE HERETICAL- PSYDON ENDURES!",
	)
	storyteller = /datum/storyteller/xylix

/datum/patron/divine/pestra
	name = "Pestra"
	domain = "Medicine, Pestilence, Decay"
	desc = "The Panacea is the only of the Ten to be born to a wildkin, She taught us the arts of medicine and surgery. Her followers are obsessed with rot and decay to a concerning degree to the other Tennites."
	worshippers = "The Sick, Chirurgeons, Apothecaries"
	mob_traits = list(TRAIT_EMPATH, TRAIT_ROT_EATER)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/diagnose				= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/pestra_leech			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/infestation			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/attach_bodypart		= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/cure_rot				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/pestra		= CLERIC_T4,
	)
	confess_lines = list(
		"PESTRA SOOTHES ALL ILLS!",
		"DECAY IS A CONTINUATION OF LIFE!",
		"MY AFFLICTION IS MY TESTAMENT!",
	)
	storyteller = /datum/storyteller/pestra

/datum/patron/divine/malum
	name = "Malum"
	domain = "Craft, Fire, Destruction, Ingenuity"
	desc = "The Opinionless God teaches that tools for killing or saving are tools, either way. The well-oiled guillotine and the well-sharpened axe are merely tools, and there is no good and evil to their craft."
	worshippers = "Smiths, Miners, Engineers, Dwarves"
	mob_traits = list(TRAIT_FORGEBLESSED, TRAIT_BETTER_SLEEP)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/malum_flame_rogue 	= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/conjure_tool			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/vigorousexchange		= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/heatmetal				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/hammerfall			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/craftercovenant		= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/malum		= CLERIC_T4,
	)
	confess_lines = list(
		"MALUM IS MY MUSE!",
		"TRUE VALUE IS IN THE TOIL!",
		"I AM AN INSTRUMENT OF CREATION!",
	)

	storyteller = /datum/storyteller/malum


/datum/patron/divine/eora
	name = "Eora"
	domain = "Love, Family, Beauty"
	desc = "The Lady of the Hearth blesses our Love, unconditional of for whom it is for. Marriage is Astrata's Tyranny encroaching on Eora's domain. Her followers are oft promiscuous, bards especially so."
	worshippers = "Lovers, Doting Parents, Bards, Hopeless Romantics"
	mob_traits = list(TRAIT_EMPATH, TRAIT_EXTEROCEPTION)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/eora_blessing			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/bless_food            = CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/bud					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/heartweave			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/eoracurse				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/wound_heal			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/pomegranate			= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/eora		= CLERIC_T4,
	)
	confess_lines = list(
		"EORA BRINGS US TOGETHER!",
		"HER BEAUTY IS EVEN IN THIS TORMENT!",
		"I LOVE YOU, EVEN AS YOU TRESPASS AGAINST ME!",
	)
	traits_tier = list(TRAIT_EORAN_CALM = CLERIC_T0, TRAIT_EORAN_SERENE = CLERIC_T2)
	storyteller = /datum/storyteller/eora

/////////////////////////////////
// Does God Hear Your Prayer ? //
/////////////////////////////////
// Astrata - In daylight, church, cross, or ritual chalk.
/datum/patron/divine/astrata/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer during daytime if outside.
	if(istype(get_area(follower), /area/rogue/outdoors) && (GLOB.tod == "day" || GLOB.tod == "dawn"))
		return TRUE
	to_chat(follower, span_danger("For Astrata to hear my prayer I must either be in her blessed daylight, within the church, or near a psycross.."))
	return FALSE


// Noc - In moonlight, church, cross, or ritual chalk
/datum/patron/divine/noc/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer during nightime if outside.
	if(istype(get_area(follower), /area/rogue/outdoors) && (GLOB.tod == "night" || GLOB.tod == "dusk"))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/noc in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Noc to hear my prayer I must either be in his blessed moonlight, within the church, or near a psycross."))
	return FALSE


// Dendor - In grove, bog, cross, or ritual chalk
// Yes, he is NOT calling the master cus he's unique. Whole bog is his prayer zone. Druids exist for a reason instead of in the church.
/datum/patron/divine/dendor/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the druid tower + houses in the forest
	if(istype(get_area(follower), /area/rogue/indoors/shelter/woods))
		return TRUE
	// Allows prayer in outdoors wilderness, such as bog
	if(istype(get_area(follower), /area/rogue/outdoors/rtfield))
		return TRUE
	for(var/obj/structure/flora/roguetree/wise in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("I must either be in Dendor's wilds, the Grove, near a wise tree, or near a Panetheon Cross for the 'Tree Father' to hear my prays..."))
	return FALSE


// Abyssor - Near water, cross, or within the church.
/datum/patron/divine/abyssor/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer near any body of water turf.
	for(var/turf/open/water in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Abyssor to hear my prayer I must either pray within the church, near a psycross, or at any body of water so that the tides of prayer may flow.."))
	return FALSE


// Ravox - Near a knight statue, cross, or within the church
/datum/patron/divine/ravox/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer near any knight statue and its subtypes.
	for(var/obj/structure/fluff/statue/knight/K in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Ravox to hear my prayer I must either pray within the church, near a psycross, or near a knighly statue in memorium of the fallen.."))
	return FALSE


// Necra - Near a grave, cross, or within the church
/datum/patron/divine/necra/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer near a grave.
	for(var/obj/structure/closet/dirthole/grave/G in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Necra to hear my prayer I must either pray within the church, near a psycross, or near a grave where we all go to be given our final embrace.."))
	return FALSE


// Xylix - Near a gambling machine, cross, or within the church
/datum/patron/divine/xylix/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer near gambling machines.
	for(var/obj/structure/roguemachine/lottery_roguetown/L in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Xylix to hear my prayer I must either pray within the church, near a psycross, or near a machine of fortune blessed by the grand jester.."))
	return FALSE


// Pestra - Near a well, cross, within the physicians, or within the church
/datum/patron/divine/pesta/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer in the appothocary's building.
	if(istype(get_area(follower), /area/rogue/indoors/town/physician))
		return TRUE
	// Allows prayer near wells. Weird one, but makes sense for health and disease. Miasma, water, etc.
	for(var/obj/structure/well/W in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Pestra to hear my prayer I must either pray within the church, phyisican's building, near a psycross, or near a well to observe the full circle of life.."))
	return FALSE


// Malum - Near a smelter, hearth, cross, within the smithy, or within the church
/datum/patron/divine/malum/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer in the smith's building.
	if(istype(get_area(follower), /area/rogue/indoors/town/dwarfin))
		return TRUE
	// Allows prayer near hearths.
	for(var/obj/machinery/light/rogue/hearth/H in view(4, get_turf(follower)))
		return TRUE
	// Allows prayer near smelters.
	for(var/obj/machinery/light/rogue/smelter/H in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Malum to hear my prayer I must either pray within the church, the smithy's workshop, near a psycross, near a smelter, or hearth to bask in Malum's glory.."))
	return FALSE

// Eora - Near a gambling machine, cross, or within the church
/datum/patron/divine/eora/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows Eorans to pray using flowers
	var/obj/item/held_item = follower.get_active_held_item()
	if(istype(held_item, /obj/item/reagent_containers/food/snacks/grown/rogue/poppy))
		qdel(held_item)
		return TRUE
	// Allows player to pray while wearing eoran bud.
	if(HAS_TRAIT(follower, TRAIT_PACIFISM))
		return TRUE
	to_chat(follower, span_danger("For Eora to hear my prayer I must either pray within the church, near a psycross, offering her poppy flowers, or wearing one of her blessed flowers atop my head.."))
	return FALSE
