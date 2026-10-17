/obj/item/alch/mirror_clay
	name = "mirror clay"
	desc = "A piece of warm, pulsating organic mass. Press it firmly against a living person's face to take an imprint."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "clay"
	w_class = WEIGHT_CLASS_SMALL
	var/clay_primed = FALSE
	var/mob/living/carbon/human/template_human = null

/obj/item/alch/mirror_clay/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(!istype(target))
		return ..()

	if(clay_primed)
		to_chat(user, span_warning("This clay already contains an imprint!"))
		return TRUE

	if(target.stat == DEAD)
		to_chat(user, span_warning("The clay refuses to imprint upon deceased flesh!"))
		return TRUE

	user.visible_message(
		span_danger("[user] presses \the [src] against [target]'s face!"),
		span_notice("You begin pressing the clay against [target]'s face, capturing their visage...")
	)

	if(do_after(user, 3 SECONDS, target = target))
		if(QDELETED(src) || QDELETED(target) || clay_primed)
			return TRUE

		template_human = target
		clay_primed = TRUE
		name = "imprinted clay ([target.real_name])"
		desc = "The clay has taken the exact contours and semblance of [target.real_name]'s face."

		to_chat(user, span_boldnotice("The imprint is set. Now the clay yearns for a soul."))

	return TRUE

/obj/item/alch/mirror_clay/attack_self(mob/living/carbon/human/user)
	if(!clay_primed || !template_human)
		to_chat(user, span_warning("You must first take an imprint of a living person!"))
		return

	if(QDELETED(template_human))
		user.visible_message(
			span_danger("The clay in [user]'s hands suddenly withers and crumbles to dry dust..."),
			span_warning("The connection to the original soul has been severed! The clay crumbles away.")
		)
		qdel(src)
		return

	user.visible_message(span_danger("[user] begins chanting ancient words over the clay imprint of [template_human.real_name]..."))
	INVOKE_ASYNC(src, PROC_REF(poll_for_homunculus), user)

/obj/item/alch/mirror_clay/proc/poll_for_homunculus(mob/living/carbon/human/user)
	var/poll_message = "Alchemist [user.real_name] is manifesting a homunculus clone of [template_human.real_name]. Awaken as this creation?"
	var/list/candidates = pollGhostCandidates(poll_message, "Homunculus", null, null, 15 SECONDS, "homunculus")

	if(QDELETED(src) || QDELETED(user) || !template_human)
		return

	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("No wandering spirits heeded your call. The form remains dormant."))
		return

	if(QDELETED(template_human))
		to_chat(user, span_warning("The soul thread snapped during the ritual. The clay crumbles to dust."))
		qdel(src)
		return

	var/mob/C = pick(candidates)
	if(!C)
		return

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	user.visible_message(span_userdanger("The clay suddenly erupts from [user]'s hands, rapidly knitting bone, muscle, and flesh!"))

	var/mob/living/carbon/human/clone = new template_human.type(get_turf(user))
	clone.key = C.key
	template_human.dna.transfer_identity(clone)

	if(clone.dna.species.type != template_human.dna.species.type)
		clone.set_species(template_human.dna.species.type)

	if(template_human.dna.features)
		var/list/cached_features = template_human.dna.features
		clone.dna.features = cached_features.Copy()

	clone.real_name = template_human.real_name
	clone.name = clone.real_name
	clone.nickname = template_human.nickname
	clone.pronouns = template_human.pronouns
	clone.gender = template_human.gender
	clone.age = template_human.age
	clone.skin_tone = template_human.skin_tone
	clone.hair_color = template_human.hair_color
	clone.hairstyle = template_human.hairstyle
	clone.facial_hair_color = template_human.facial_hair_color
	clone.facial_hairstyle = template_human.facial_hairstyle
	clone.eye_color = template_human.eye_color
	clone.highlight_color = template_human.highlight_color
	clone.detail_color = template_human.detail_color
	clone.voice_color = template_human.voice_color
	clone.voice_pitch = template_human.voice_pitch
	clone.voice_type = template_human.voice_type
	clone.origin = template_human.origin
	clone.job = template_human.job
	clone.advjob = template_human.advjob
	clone.migrant_type = template_human.migrant_type
	clone.social_rank = template_human.social_rank

	if(clone.mind)
		if(template_human.mind?.assigned_role)
			clone.mind.set_assigned_role(template_human.mind.assigned_role)
		else
			clone.mind.assigned_role = template_human.job
		clone.mind.cosmetic_class_title = template_human.mind?.cosmetic_class_title
		clone.mind.special_role = "Homunculus"

	if(template_human.statpack)
		clone.statpack = new template_human.statpack.type()

	clone.set_patron(template_human.patron)

	if(template_human.charflaw)
		clone.charflaw = new template_human.charflaw.type()
		clone.charflaw.on_mob_creation(clone)

	if(template_human.vices && template_human.vices.len)
		clone.vices = list()
		for(var/datum/charflaw/cf in template_human.vices)
			var/datum/charflaw/new_v = new cf.type()
			clone.vices.Add(new_v)
			new_v.on_mob_creation(clone)

	clone.headshot_link = template_human.headshot_link
	clone.nsfw_headshot_link = template_human.nsfw_headshot_link

	if(template_human.img_gallery)
		clone.img_gallery = template_human.img_gallery.Copy()
	if(template_human.nsfw_img_gallery)
		clone.nsfw_img_gallery = template_human.nsfw_img_gallery.Copy()

	clone.flavortext = template_human.flavortext
	clone.nsfwflavortext = template_human.nsfwflavortext
	clone.ooc_notes = template_human.ooc_notes
	clone.ooc_extra = template_human.ooc_extra
	clone.ooc_extra_img = template_human.ooc_extra_img
	clone.ooc_extra_img_link = template_human.ooc_extra_img_link
	clone.nsfw_ooc_extra_img = template_human.nsfw_ooc_extra_img
	clone.nsfw_ooc_extra_img_link = template_human.nsfw_ooc_extra_img_link
	clone.rumour = template_human.rumour
	clone.noble_gossip = template_human.noble_gossip
	clone.song_title = template_human.song_title
	clone.song_artist = template_human.song_artist
	clone.erpprefs = template_human.erpprefs

	if(!clone.skills)
		clone.skills = new /datum/skill_holder()
		clone.skills.set_current(clone)

	if(template_human.skills && clone.skills)
		clone.skills.known_skills = template_human.skills.known_skills.Copy()
		clone.skills.skill_experience = template_human.skills.skill_experience.Copy()

	if(template_human.mind && template_human.mind.sleep_adv && clone.mind)
		for(var/skill_path in template_human.skills.known_skills)
			if(template_human.skills.known_skills[skill_path] >= SKILL_LEVEL_APPRENTICE)
				var/datum/sleep_adv/sadv = template_human.mind.sleep_adv
				if(hascall(sadv, "get_sleep_xp"))
					var/xp_amount = call(sadv, "get_sleep_xp")(skill_path)
					if(xp_amount > 0)
						clone.mind.add_sleep_experience(skill_path, xp_amount, silent = TRUE)


	clone.STASTR = max(1, template_human.STASTR - 3)
	clone.STACON = max(1, template_human.STACON - 3)
	clone.STASPD = max(1, template_human.STASPD - 3)
	clone.STAINT = max(1, template_human.STAINT - 3)
	clone.STAPER = max(1, template_human.STAPER - 3)
	clone.STAWIL = max(1, template_human.STAWIL - 3)
	clone.STALUC = max(1, template_human.STALUC - 3)

	if(template_human.status_traits)
		for(var/trait_id in template_human.status_traits)
			if(trait_id in list(TRAIT_DNR, TRAIT_BLIND, TRAIT_MUTE, TRAIT_DEAF))
				continue
			ADD_TRAIT(clone, trait_id, "homunculus_copy")

	ADD_TRAIT(clone, TRAIT_DNR, "homunculus_copy")
	clone.copy_known_languages_from(template_human, TRUE)
	clone.body_overlay_cache_key = null
	clone.damage_overlay_cache_key = null
	clone.icon_render_key = null
	clone.regenerate_icons()
	clone.update_body()
	clone.update_hair()
	clone.update_body_parts(TRUE)

	to_chat(clone, span_userdanger("You were woven from alchemical mirror clay. You are an imperfect reflection of [template_human.real_name]. Your will is your own, but your creator is [user.real_name]."))

	qdel(src)
