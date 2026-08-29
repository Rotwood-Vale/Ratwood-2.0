///The OOC card and identity of a player character, carried on the mind so it follows the player
///through any body. Captured whenever the mind leaves a human body, the presentation restamped on
///entering one, and the identity snapshot remakes the flesh when a foreign brain gets force-revived.
///Fields are grouped IC (the character as the world sees them) versus OOC (player boundaries).
///Any future mechanic that copies IC presentation between characters (disguises, changelings)
///must never touch the OOC block.
/datum/player_card
	//IC, the character's presentation
	var/flavortext
	var/nsfwflavortext
	var/headshot_link
	var/rumour
	var/noble_gossip
	var/list/img_gallery
	var/list/nsfw_img_gallery
	var/ooc_extra //the character's theme song url, legacy naming
	var/ooc_extra_img
	var/ooc_extra_img_link
	var/nsfw_ooc_extra_img
	var/nsfw_ooc_extra_img_link
	var/song_title
	var/song_artist
	var/pronouns
	var/voice_type
	var/vocal_bark
	var/vocal_bark_id
	var/vocal_speed
	var/vocal_pitch
	var/vocal_pitch_range
	///Snapshot of the character's dna, including organ_dna, for remaking a claimed body
	var/datum/dna/stored_dna
	//appearance that lives outside dna, needed so the remade body is not left with the old owner's coloring.
	//Hair is deliberately absent, it lives on the head bodypart and the head is already the right person's
	var/skin_tone

	//OOC, player boundaries
	var/ooc_notes
	var/erpprefs

/datum/player_card/Destroy()
	QDEL_NULL(stored_dna)
	return ..()

/datum/player_card/proc/capture_from(mob/living/carbon/human/H)
	flavortext = H.flavortext
	nsfwflavortext = H.nsfwflavortext
	headshot_link = H.headshot_link
	rumour = H.rumour
	noble_gossip = H.noble_gossip
	img_gallery = H.img_gallery?.Copy()
	nsfw_img_gallery = H.nsfw_img_gallery?.Copy()
	ooc_extra = H.ooc_extra
	ooc_extra_img = H.ooc_extra_img
	ooc_extra_img_link = H.ooc_extra_img_link
	nsfw_ooc_extra_img = H.nsfw_ooc_extra_img
	nsfw_ooc_extra_img_link = H.nsfw_ooc_extra_img_link
	song_title = H.song_title
	song_artist = H.song_artist
	pronouns = H.pronouns
	voice_type = H.voice_type
	vocal_bark = H.vocal_bark
	vocal_bark_id = H.vocal_bark_id
	vocal_speed = H.vocal_speed
	vocal_pitch = H.vocal_pitch
	vocal_pitch_range = H.vocal_pitch_range
	ooc_notes = H.ooc_notes
	erpprefs = H.erpprefs
	if(!H.dna)
		return
	// A stranger's body must never overwrite the identity snapshot, or the forced-revival
	// conversion would remake bodies into the wrong person. Same-name bodies only
	if(stored_dna && stored_dna.real_name != H.dna.real_name)
		return
	if(!stored_dna)
		stored_dna = new
	H.dna.copy_dna(stored_dna)
	stored_dna.organ_dna = H.dna.organ_dna.Copy() //copy_dna leaves this out
	skin_tone = H.skin_tone

///Restamps the card onto a body the mind now inhabits
/datum/player_card/proc/apply_card_to(mob/living/carbon/human/H)
	H.flavortext = flavortext
	H.nsfwflavortext = nsfwflavortext
	H.headshot_link = headshot_link
	H.rumour = rumour
	H.noble_gossip = noble_gossip
	H.img_gallery = img_gallery?.Copy()
	H.nsfw_img_gallery = nsfw_img_gallery?.Copy()
	H.ooc_extra = ooc_extra
	H.ooc_extra_img = ooc_extra_img
	H.ooc_extra_img_link = ooc_extra_img_link
	H.nsfw_ooc_extra_img = nsfw_ooc_extra_img
	H.nsfw_ooc_extra_img_link = nsfw_ooc_extra_img_link
	H.song_title = song_title
	H.song_artist = song_artist
	H.pronouns = pronouns
	H.voice_type = voice_type
	H.vocal_bark = vocal_bark
	H.vocal_bark_id = vocal_bark_id
	H.vocal_speed = vocal_speed
	H.vocal_pitch = vocal_pitch
	H.vocal_pitch_range = vocal_pitch_range
	H.ooc_notes = ooc_notes
	H.erpprefs = erpprefs

///Remakes a claimed body into this character: species, features, markings, organs, name.
///The head is left completely alone, it already belongs to this character and carries their own hair
/datum/player_card/proc/apply_identity_to(mob/living/carbon/human/H)
	if(!stored_dna || !H.dna)
		return
	// The species swap inside transfer_identity strips every bodypart feature and only restores the
	// character's own customization from prefs, which we do not have. The head is already this
	// character's, snout and all, so hold its features across the swap. Cut() does not qdel them
	var/obj/item/bodypart/head/old_head = H.get_bodypart(BODY_ZONE_HEAD)
	var/list/kept_head_features = old_head?.bodypart_features?.Copy()
	stored_dna.transfer_identity(H)
	H.real_name = stored_dna.real_name
	H.name = H.real_name
	H.skin_tone = skin_tone
	if(kept_head_features)
		var/obj/item/bodypart/head/new_head = H.get_bodypart(BODY_ZONE_HEAD) //refetched, a body plan change can swap the limb
		if(new_head)
			new_head.bodypart_features = kept_head_features
	H.updateappearance(icon_update = 0)
	// Both cache keys carry the species, so a same species binding leaves them unchanged and the
	// rebuilds would be skipped. Clearing them forces the refresh the conversion actually needs
	H.body_overlay_cache_key = null
	H.damage_overlay_cache_key = null
	H.icon_render_key = null
	H.update_body()
	H.update_hair()
	H.update_body_parts()
	H.update_damage_overlays()

///Admin content purge, mirrors the VV slot purge categories
/datum/player_card/proc/vv_purge(choice)
	if(choice == "Flavor" || choice == "All")
		flavortext = null
		nsfwflavortext = null
		ooc_extra_img = null
		ooc_extra_img_link = null
		nsfw_ooc_extra_img = null
		nsfw_ooc_extra_img_link = null
	if(choice == "Notes" || choice == "All")
		ooc_notes = null
		erpprefs = null
	if(choice == "Extra" || choice == "All")
		ooc_extra = null
		song_title = null
		song_artist = null
		img_gallery = list()
		nsfw_img_gallery = list()
