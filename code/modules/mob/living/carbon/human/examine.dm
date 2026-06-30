/mob/living/carbon/human/proc/on_examine_face(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.mind)
		user.mind.i_know_person(src)
	if(user.has_flaw(/datum/charflaw/paranoid))	//We hate different species, that are stronger than us, and aren't racist themselves
		if(dna.species.name != user.dna.species.name && (STASTR - user.STASTR) > 1 && !has_flaw(/datum/charflaw/paranoid))
			user.add_stress(/datum/stressevent/parastr)
	if(HAS_TRAIT(user, TRAIT_JESTERPHOBIA) && job == "Jester")
		user.add_stress(/datum/stressevent/jesterphobia)
	if(HAS_TRAIT(src, TRAIT_BEAUTIFUL) && user != src)//it doesn't really make sense that you can examine your own face
		user.add_stress(/datum/stressevent/beautiful)
		to_chat(user, span_info("[p_they(TRUE)] [p_are()] 惊人地美丽。"))
		// Apply Xylix buff when examining someone with the beautiful trait
		if(HAS_TRAIT(user, TRAIT_XYLIX) && !user.has_status_effect(/datum/status_effect/buff/xylix_joy))
			user.apply_status_effect(/datum/status_effect/buff/xylix_joy)
			to_chat(user, span_info("他们的美丽让我脸上泛起微笑，让我的脚步带来好运！"))
	if(HAS_TRAIT(src, TRAIT_UNSEEMLY) && user != src)
		if(!HAS_TRAIT(user, TRAIT_UNSEEMLY))
			user.add_stress(/datum/stressevent/unseemly)
	if(HAS_TRAIT(src, TRAIT_LEPROSY) && user != src)
		user.add_stress(/datum/stressevent/leprosy)
	// Apply Xylix buff when examining someone with the beautiful trait
	if(HAS_TRAIT(user, TRAIT_XYLIX) && !user.has_status_effect(/datum/status_effect/buff/xylix_joy) && user.has_stress_event(/datum/stressevent/beautiful))
		user.apply_status_effect(/datum/status_effect/buff/xylix_joy)
		to_chat(user, span_info("他们的美丽让我脸上泛起微笑，让我的脚步带来好运！"))

/mob/living/carbon/human/proc/human_modular_examine_lines(mob/user, observer_privilege, m1, m2, m3)
	var/list/lines = list()
	var/list/ext_lines = human_modular_examine_extension(user, observer_privilege, m1, m2, m3)
	if(length(ext_lines))
		lines += ext_lines
	return lines

/mob/living/carbon/human/proc/get_examine_item_name_with_hover(mob/user, obj/item/I)
	if(!I)
		return ""
	var/display_name = I.get_examine_string(user)
	if(!I.show_examine_hover_tooltip())
		return display_name
	var/self_examine = (src == user)
	var/tooltip_html = I.get_hover_examine_html(user, self_examine)
	if(!tooltip_html)
		return display_name
	var/label = display_name
	if(!I.always_show_examine_link)
		label = "<u><font color='#add8e6'>[display_name]</font></u>"
	return "<span data-component=\"TooltipHTML\" data-position=\"bottom-start\" data-html=\"[html_encode(tooltip_html)]\">[label]</span>"

/mob/living/carbon/human/examine(mob/user)
	var/observer_privilege = isobserver(user)
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
	var/t_him = p_them()
	var/t_has = p_have()
	var/t_is = p_are()
	var/obscure_name = FALSE
	var/race_name = "<a href='?src=[REF(src)];species_lore=1'><u>[dna.species.name]</u></A>"
	var/datum/antagonist/maniac/maniac = user.mind?.has_antag_datum(/datum/antagonist/maniac)
	var/datum/antagonist/skeleton/skeleton = user.mind?.has_antag_datum(/datum/antagonist/skeleton)
	if(maniac && (user != src))
		race_name = "恶心的猪猡"
	if(skeleton && (user != src))
		race_name = "[pick("蹒跚的", "紧绷的", "腐朽的")]"

	var/m1 = "[t_He] [t_is]"
	var/m2 = "[t_his]"
	var/m3 = "[t_He] [t_has]"
	if(user == src)
		m1 = "我"
		m2 = "我的"
		m3 = "我有"

	if(isliving(user))
		var/mob/living/L = user
		if(HAS_TRAIT(L, TRAIT_PROSOPAGNOSIA))
			obscure_name = TRUE

	var/static/list/unknown_names = list(
		"未知",
		"未知男子",
		"未知女子",
	)
	if(get_face_name() != real_name)
		obscure_name = TRUE

	if(observer_privilege)
		obscure_name = FALSE

	if ((dna?.species?.id != "gnoll") && (valid_headshot_link(src, headshot_link, TRUE)) && (user.client?.prefs.chatheadshot) && (!obscure_name || client?.prefs.masked_examine))
		. = list("[chat_headshot(headshot_link)]\nø ------------ ø")
	else
		. = list("ø ------------ ø")

	if(name in unknown_names)
		. += span_info("这是 <EM>[name]</EM>.")
	else if(obscure_name)
		. += span_info("这是一位未知的 <EM>[name]</EM>.")
		if(HAS_TRAIT(user, TRAIT_HERETIC_SEER))
			var/heretic_text = get_heretic_text(user)
			if(heretic_text)
				. += span_notice(heretic_text)
	else
		on_examine_face(user)
		var/used_name = name
		// Scarred trait only hides the name, nothing else
		if(HAS_TRAIT(src, TRAIT_SCARRED) && !observer_privilege)
			// Use descriptor system like masked characters
			var/list/d_list = get_mob_descriptors()
			var/trait_desc = "[capitalize(build_coalesce_description_nofluff(d_list, src, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))]"
			var/stature_desc = "[capitalize(build_coalesce_description_nofluff(d_list, src, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))]"
			var/descriptor_name = "[trait_desc] [stature_desc]"
			if(descriptor_name != " " && descriptor_name != "")
				used_name = descriptor_name
			else
				// Fallback to gender-based unknown name
				used_name = "未知[(gender == FEMALE) ? "女子" : "男子"]"
		var/used_title = get_role_title()
		// Check for cosmetic class titles (for advclass cosmetic variants)
		if(mind && mind.cosmetic_class_title)
			var/cosmetic_title = mind.cosmetic_class_title
				// Use query string approach (like species_lore) to reveal the true job
			used_title = "<a href='?src=[REF(src)];reveal_cosmetic=1'><u>[\cosmetic_title]</u></A>"
		if(SSticker.regentmob == src)
			used_title = "[used_title]" + " 摄政"
		var/display_as_wanderer = FALSE
		var/display_as_lowlife = FALSE
		if(observer_privilege)
			used_name = real_name
		if(migrant_type)
			used_title = MIGRANT_ROLE(migrant_type)
			. += span_info("这是 <EM>[used_name]</EM>, 一名流浪的 [race_name] [used_title].")
		else if(job)
			var/datum/job/J = SSjob.GetJob(job)
			if(!J || J.wanderer_examine)
				display_as_wanderer = TRUE
			else if(J.lowlife_examine)
				display_as_lowlife = TRUE
		var/rank_color = "#725D4C"
		if(HAS_TRAIT(src, TRAIT_NOBLE) && social_rank < 4)
			social_rank = SOCIAL_RANK_MINOR_NOBLE
		switch(social_rank)
			if(SOCIAL_RANK_PEASANT)
				rank_color = "#91733B"
			if(SOCIAL_RANK_YEOMAN)
				rank_color = "#B1892A"
			if(SOCIAL_RANK_MINOR_NOBLE)
				rank_color = "#D09F19"
			if(SOCIAL_RANK_NOBLE)
				rank_color = "#ECB20A"
			if(SOCIAL_RANK_ROYAL)
				rank_color = "#FFBF00"
		var/social_strata = "<a href='?src=[REF(src)];social_strata=1'><font color='#[rank_color]'>⚜</font></A>"
		if(family_datum)
			social_strata = "<a href='?src=[REF(src)];social_strata=1'><font color='#[rank_color]'>⛯</font></A>"
		var/display1
		var/display2 = "[(!HAS_TRAIT(usr, TRAIT_OUTLANDER) && src.social_rank) ? "[social_strata]" : " "]"
		if(display_as_wanderer)
			display1 = span_info("这是 <EM>[used_name]</EM>, 一名流浪的 [race_name].")
		else if(display_as_lowlife)
			display1 = span_info("这是 <EM>[used_name]</EM>, 一名下等人的 [race_name].")
		else if(used_title)
			display1 = span_info("这是 <EM>[used_name]</EM>, 一名 [race_name] [used_title].")
		else
			display1 = span_info("这是 <EM>[used_name]</EM>, 一名 [race_name].")
		. += "[display1] [display2]"

		if(HAS_TRAIT(src, TRAIT_WITCH))
			if(HAS_TRAIT(user, TRAIT_NOBLE) || HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_WITCH))
				. += span_warning("一个女巫！他们的存在带来一股令人不安的气息。")
			else if(HAS_TRAIT(user, TRAIT_COMMIE) || HAS_TRAIT(user, TRAIT_CABAL) || HAS_TRAIT(user, TRAIT_HORDE) || HAS_TRAIT(user, TRAIT_DEPRAVED))
				. += span_notice("一个古老之道的践行者。")
			else
				. += span_notice("他们身上有一种……与众不同的气息。")

		if(GLOB.lord_titles[name])
			. += span_notice("[m3] been granted the title of \"[GLOB.lord_titles[name]]\".")

		if(HAS_TRAIT(src, TRAIT_NOBLE) || HAS_TRAIT(src, TRAIT_DEFILED_NOBLE))
			if(HAS_TRAIT(user, TRAIT_NOBLE) || HAS_TRAIT(user, TRAIT_DEFILED_NOBLE))
				. += span_notice("一位贵族同袍。")
			else
				. += span_notice("一位贵族！")
		// Leashed pet status effect message
		if(has_status_effect(/datum/status_effect/leash_pet))
			. += span_warning("一根皮带钩在他们的项圈上。他们像宠物一样被牵着。")

		// Knotted effect message
		if(has_status_effect(/datum/status_effect/knot_tied))
			. += span_warning("一个绳结锁在[p_them()]体内。[m1]像宠物一样被牵着走。")

		// Facial/Creampie/Body shot effect message
		var/datum/status_effect/facial/facial = has_status_effect(/datum/status_effect/facial)
		var/datum/status_effect/facial/external/external = has_status_effect(/datum/status_effect/facial/external)
		var/datum/status_effect/facial/internal/creampie = null
		var/datum/status_effect/creampie_leak/drip = null
		if(observer_privilege || get_location_accessible(src, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
			creampie = has_status_effect(/datum/status_effect/facial/internal)
			drip = has_status_effect(/datum/status_effect/creampie_leak/long)
			if(!drip)
				drip = has_status_effect(/datum/status_effect/creampie_leak)
		var/any_cum_effect = facial || external || creampie
		if(any_cum_effect || drip)
			var/show_detail = (user == src) || observer_privilege
			if(!show_detail && isliving(user))
				var/mob/living/L = user
				show_detail = (L.STAPER >= 8 && L.STAINT >= 5)
			if(!show_detail)
				if(any_cum_effect)
					. += span_warning("[m1]身上沾满了某种光泽的液体！")
			else
				if(external)
					. += span_aiprivradio("[capitalize(m2)]的身体是[!external.has_dried_up ? "沾满了精液" : "沾满了干涸的精液"]！")
				if(facial)
					. += span_aiprivradio("[capitalize(m2)]的脸上是[!facial.has_dried_up ? "涂满了精液" : "糊满了干涸的精液"]！")
				if(creampie && !drip)
					. += span_aiprivradio("[capitalize(m2)]的胯下是[!creampie.has_dried_up ? "一片精液狼藉" : "沾满了干涸的精斑"]！")
				if(drip)
					var/is_long = istype(drip, /datum/status_effect/creampie_leak/long)
					switch(drip.orifice)
						if(SEX_PART_CUNT)
							. += span_aiprivradio("[m1] [is_long ? "正从[m2]的下体涌出精液" : "正从[m2]的下体滴落精液"]！")
						if(SEX_PART_ANUS)
							. += span_aiprivradio("[m1] [is_long ? "正从[m2]的后庭大量泄漏" : "正从[m2]的后庭漏出精液"]！")
						if(SEX_PART_SLIT_SHEATH)
							. += span_aiprivradio("[m1] [is_long ? "正从[m2]的裂缝大量泄漏" : "正从[m2]的裂缝滴落精液"]！")
						if(SEX_PART_CUNT|SEX_PART_ANUS)
							. += span_aiprivradio("[m1] [is_long ? "正从[m2]的两个穴口大量泄漏" : "正从[m2]的两个穴口滴落精液"]！")
						else
							. += span_aiprivradio("[m1] [is_long ? "正泄漏着大量浊物" : "正从[m2]的下身滴落精液"]！")
		var/list/modular_lines = human_modular_examine_lines(user, observer_privilege, m1, m2, m3)
		if(length(modular_lines))
			. += modular_lines

		if((HAS_TRAIT(src, TRAIT_OUTLANDER) && !HAS_TRAIT(user, TRAIT_OUTLANDER)) || (HAS_TRAIT(user, TRAIT_RACISMISBAD) && !(src.dna.species.name == "Elf" || src.dna.species.name == "Dark Elf" || src.dna.species.name == "Half Elf")))
			. += span_phobia("一个外国人……")

		if(HAS_TRAIT(src, TRAIT_LOOSE_STRAPS))
			. += span_phobia("[capitalize(m2)]的盔甲摇摇欲坠……")

		if(HAS_TRAIT(src, TRAIT_DISGRACED_NOBLE))
			if(HAS_TRAIT(user, TRAIT_NOBLE))
				. += span_phobia("一个被玷污的贵族成员……")
			else
				. += span_notice("一个被玷污的贵族。")

		//For tennite schism god-event
		if(length(GLOB.tennite_schisms))
			var/datum/tennite_schism/S = GLOB.tennite_schisms[1]
			var/user_side = (WEAKREF(user) in S.supporters_astrata) ? "astrata" : (WEAKREF(user) in S.supporters_challenger) ? "challenger" : null
			var/mob_side = (WEAKREF(src) in S.supporters_astrata) ? "astrata" : (WEAKREF(src) in S.supporters_challenger) ? "challenger" : null

			if(user_side && mob_side)
				var/datum/patron/their_god = (mob_side == "astrata") ? S.astrata_god.resolve() : S.challenger_god.resolve()
				if(their_god)
					. += (user_side == mob_side) ? span_notice("[their_god.name]的支持者同伴！") : span_userdanger("卑鄙的[their_god.name]支持者！")


		if(origin && origin != "Unknown")
			. += span_info("[capitalize(m2)]血统是[origin]。")

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.marriedto == name)
				. += span_love("这是我的配偶。")

		var/gang_message = get_gang_text(user)
		if (gang_message)
			. += gang_message

		if(name in GLOB.excommunicated_players)
			. += span_userdanger("异端！耻辱！")

		if(HAS_TRAIT(src, TRAIT_EXCOMMUNICATED))
			. += span_userdanger("绝罚者！耻辱！")//Temporary, probably going to get rid of the trait since it doesn't fit for us.
/*
		if(name in GLOB.excommunicated_players)
			var/mob/living/carbon/human/H = src
			switch (H.patron)
				if (istype(H.patron, /datum/patron/divine))
					. += span_userdanger("EXCOMMUNICATED! SHAME!")
				if (istype(H.patron, /datum/patron/inhumen))
					. += span_userdanger("HERETIC! SHAME!")
				if (istype(H.patron, /datum/patron/old_god))
					. += span_userdanger("HEATHEN! SHAME!")
*/
		if(name in GLOB.outlawed_players)
			. += span_userdanger("法外之徒!")

		if(HAS_TRAIT(user, TRAIT_JUSTICARSIGHT) && !HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			for(var/datum/bounty/b in GLOB.head_bounties) //I hate this.
				if(b.target == real_name)
					. += span_syndradio("[m3]的头上有一份来自[b.employer]的[b.amount]玛门的悬赏，罪名是[b.reason]。")
					break

		if(name in GLOB.court_agents)
			var/datum/job/J = SSjob.GetJob(user.mind?.assigned_role)
			if(J?.department_flag & GARRISON || J?.department_flag & NOBLEMEN)
				. += span_greentext("<b>[m1]是宫中的密探！</b>")

		if(user != src && !HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS) && ishuman(user))
			if(has_flaw(/datum/charflaw/addiction/lovefiend) && user.has_flaw(/datum/charflaw/addiction/lovefiend))
				. += span_aiprivradio("[m1]和我一样为情所困。")

			if(has_flaw(/datum/charflaw/marked_by_baotha) && HAS_TRAIT(user, TRAIT_DEPRAVED))
				. += span_aiprivradio("[m1]被我的庇护者的放荡气息所标记。")

			if(has_flaw(/datum/charflaw/addiction/junkie) && user.has_flaw(/datum/charflaw/addiction/junkie))
				. += span_deadsay("[m1]的鼻子上和我一样带着同样的粉尘痕迹。")

			if(has_flaw(/datum/charflaw/addiction/smoker) && user.has_flaw(/datum/charflaw/addiction/smoker))
				. += span_suppradio("[m1]被那股熟悉而微弱的烟味所笼罩。我再熟悉不过了。")

			if(has_flaw(/datum/charflaw/addiction/alcoholic) && user.has_flaw(/datum/charflaw/addiction/alcoholic))
				. += span_syndradio("[m1]挣扎着掩饰宿醉，还有那股酒臭味。我们是一类人。")

			if(has_flaw(/datum/charflaw/paranoid) && user.has_flaw(/datum/charflaw/paranoid))
				var/mob/living/carbon/human/H = user
				if(dna.species.name == H.dna.species.name)
					. += span_nicegreen("[m1]深知周围这些陌生人的危险。[m1]和我一样恐惧。")
				else
					. += span_nicegreen("[m1]是好人中的一员。[m1]和我一样恐惧。")
			if(has_flaw(/datum/charflaw/addiction/masochist) && user.has_flaw(/datum/charflaw/addiction/sadist))
				. += span_secradio("[m1]身上带着为取乐而留下的伤疤。是我欲望的绝佳目标。")
			if(has_flaw(/datum/charflaw/addiction/sadist) && user.has_flaw(/datum/charflaw/addiction/masochist))
				. += span_secradio("[m1]的眼神里充满施虐的欲望。真让人兴奋。")
			if(HAS_TRAIT(user, TRAIT_EMPATH) && HAS_TRAIT(src, TRAIT_PERMAMUTE))
				. += span_notice("[m1]没有声音。[m1]是个哑巴！")

		var/villain_text = get_villain_text(user)
		if(villain_text)
			. += villain_text
		var/heretic_text = get_heretic_text(user)
		if(heretic_text)
			. += span_notice(heretic_text)
		var/inquisition_text = get_inquisition_text(user)
		if(inquisition_text)
			. +=span_notice(inquisition_text)

		if (HAS_TRAIT(src, TRAIT_LEPROSY))
			. += span_necrosis("一个麻风病人……")

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(family_datum == H.family_datum && family_datum)
				var/family_text = ReturnRelation(user)
				if(family_text)
					. += family_text

		if (HAS_TRAIT(src, TRAIT_BEAUTIFUL))
			switch (pronouns)
				if (HE_HIM, SHE_HER_M)
					. += span_beautiful_masc("[m1]英俊潇洒！")
				if (SHE_HER, HE_HIM_F)
					. += span_beautiful_fem("[m1]美丽动人！")
				if (THEY_THEM, THEY_THEM_F, IT_ITS)
					. += span_beautiful_nb("[m1]很好看！")

		if (HAS_TRAIT(src, TRAIT_UNSEEMLY))
			switch (pronouns)
				if (HE_HIM, SHE_HER_M)
					. += span_redtext("[m1]令人作呕！")
				if (SHE_HER, HE_HIM_F)
					. += span_redtext("[m1]令人厌恶！")
				if (THEY_THEM, THEY_THEM_F, IT_ITS)
					. += span_redtext("[m1]令人反感！")

		if (HAS_TRAIT(src, TRAIT_COMICSANS))
			. += span_sans("[m3]一张莫名烦人的脸和一副烦人的嗓音。")

		if (HAS_TRAIT(src, TRAIT_SCARRED))
			. += span_redtext("[capitalize(m2)]的脸上布满了可怕的伤疤。")

		if (HAS_TRAIT(src, TRAIT_DISFIGURED))
			switch (pronouns)
				if (HE_HIM, SHE_HER_M)
					. += span_beautiful_masc("[capitalize(m2)]的脸被丑陋地毁容了，使[m2]无法被认出。")
				if (SHE_HER, HE_HIM_F)
					. += span_beautiful_fem("[capitalize(m2)]的脸被丑陋地毁容了，使[m2]无法被认出。")
				if (THEY_THEM, THEY_THEM_F, IT_ITS)
					. += span_beautiful_nb("[capitalize(m2)]的脸被丑陋地毁容了，使[m2]无法被认出。")

		// Shouldn't be able to tell they are unrevivable through a mask as a Necran
		if(HAS_TRAIT(src, TRAIT_DNR) && src != user)
			if(HAS_TRAIT(user, TRAIT_DEATHSIGHT))
				. += span_danger("他们散发着苍白的灵光。他们的灵魂[src.stat == DEAD ? "不曾" : "并不"]纯净。他们已经完了。")
			else if(user.stat == DEAD)
				. += span_danger("这是他们此生唯一的机会。")

	if(has_flaw(/datum/charflaw/hunted) && ishuman(user) && istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.dna?.species?.type == /datum/species/gnoll)
			. += span_cultsmall("Graggar has marked them!")

	// Real medical role can tell at a glance it is a waste of time, but only if the Necra message don't come first.

	if(user.get_skill_level(/datum/skill/misc/medicine) >= SKILL_LEVEL_EXPERT && src.stat == DEAD)
		if(HAS_TRAIT(src, TRAIT_DNR) && src != user && !HAS_TRAIT(user, TRAIT_DEATHSIGHT)) // A lot of conditional to avoid a redundant message, but we also want unknown DNRs to be covered.
			. += span_danger("他们的身体已无丝毫生机。任何药物也无法使其复生。")

	if (HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS) && (!HAS_TRAIT(src, TRAIT_VAMP_DREAMS)))
		if(isliving(user))
			var/mob/living/L = user
			if(L.STAINT > 9 && L.STAPER > 9)
				. += span_redtext("<i>[m1]脆弱至极！</i>")

	if(user != src && HAS_TRAIT(user, TRAIT_MATTHIOS_EYES) && (!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS)))
		var/atom/item = get_most_expensive()
		if(item)
			. += span_notice("你觉得[m2]最值钱的财产是\a [item]。")

	if(user != src && get_dist(user, src) <= 3)
		var/datum/charflaw/malodorous/malodorous_flaw = src.get_flaw(/datum/charflaw/malodorous)
		if((malodorous_flaw && malodorous_flaw.is_reeking()) || has_status_effect(/datum/status_effect/debuff/stinky_contact))
			var/can_see_stink = !isliving(user) // adminghost always sees it
			if(isliving(user))
				var/mob/living/living_user = user
				can_see_stink = living_user.can_smell() && !HAS_TRAIT(living_user, TRAIT_NOSTINK)
			if(can_see_stink)
				. += span_greentext("他们浑身恶臭。")

	var/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if(HAS_TRAIT(user, TRAIT_ROYALSERVANT))
		var/datum/job/our_job = SSjob.name_occupations[job]
		if(length(culinary_preferences) && is_type_in_list(our_job, list(/datum/job/roguetown/lord, /datum/job/roguetown/lady, /datum/job/roguetown/exlady, /datum/job/roguetown/prince, /datum/job/roguetown/hand, /datum/job/roguetown/steward, /datum/job/roguetown/councillor, /datum/job/roguetown/physician, /datum/job/roguetown/knight, /datum/advclass/knight/irregularknight, /datum/job/roguetown/magician, /datum/job/roguetown/dungeoneer)))
			var/obj/item/reagent_containers/food/snacks/fav_food = src.culinary_preferences[CULINARY_FAVOURITE_FOOD]
			var/datum/reagent/consumable/fav_drink = src.culinary_preferences[CULINARY_FAVOURITE_DRINK]
			if(fav_food)
				if(fav_drink)
					. += span_notice("他们喜欢[fav_food.name]和[fav_drink.name]。")
				else
					. += span_notice("他们喜欢[fav_food.name]。")
			else if(fav_drink)
				. += span_notice("他们喜欢[fav_drink.name]。")
			var/obj/item/reagent_containers/food/snacks/hated_food = src.culinary_preferences[CULINARY_HATED_FOOD]
			var/datum/reagent/consumable/hated_drink = src.culinary_preferences[CULINARY_HATED_DRINK]
			if(hated_food)
				if(hated_drink)
					. += span_notice("他们讨厌[hated_food.name]和[hated_drink.name]。")
				else
					. += span_notice("他们讨厌[hated_food.name]。")
			else if(hated_drink)
				. += span_notice("他们讨厌[hated_drink.name]。")

	var/is_stupid = FALSE
	var/is_smart = FALSE
	var/is_normal = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(HAS_TRAIT(H, TRAIT_INTELLECTUAL) || H.get_skill_level(H, /datum/skill/craft/blacksmithing) >= SKILL_EXP_EXPERT)
			is_smart = TRUE	//Most of this is determining integrity of objects + seeing multiple layers.
		if(((H?.STAINT - 10) + round((H?.STAPER - 10) / 2) + H.get_skill_level(/datum/skill/misc/reading)) < 0 && !is_smart)
			is_stupid = TRUE
		if(((H?.STAINT - 10) + (H?.STAPER - 10) + H.get_skill_level(/datum/skill/misc/reading)) >= 5)
			is_normal = TRUE

	if(user != src)
		var/datum/mind/Umind = user.mind
		if(Umind && mind)
			for(var/datum/antagonist/aD in mind.antag_datums)
				for(var/datum/antagonist/bD in Umind.antag_datums)
					var/shit = bD.examine_friendorfoe(aD,user,src)
					if(shit)
						. += shit
		if(user.mind?.has_antag_datum(/datum/antagonist/vampire) && can_be_blood_drunk())
			. += span_userdanger("<a href='?src=[REF(src)];task=bloodpoolinfo;'>Vitae: [(mind && !clan) ? (bloodpool * CLIENT_VITAE_MULTIPLIER) : bloodpool]; Blood: [blood_volume]</a>")

	if(wear_shirt && !(SLOT_SHIRT in obscured))
		var/str = "[m3] [get_examine_item_name_with_hover(user, wear_shirt)]. "
		str += "[wear_shirt.integrity_check(is_smart)]"
		if(is_stupid)
			str = "[m3]某种衬衫！"
		. += str

	//uniform
	if(wear_pants && !(SLOT_PANTS in obscured))
		//accessory
		var/accessory_msg
		if(istype(wear_pants, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = wear_pants
			if(U.attached_accessory)
				accessory_msg += "和[icon2html(U.attached_accessory, user)] \a [U.attached_accessory]"
		var/str = "[m3][get_examine_item_name_with_hover(user, wear_pants)][accessory_msg]。"
		str += wear_pants.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3]一条什么裤子！"
		. += str


	//head
	if(head && !(SLOT_HEAD in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, head)]在[m2]头上。 "
		var/head_condition = head.integrity_check(is_smart)
		str += head_condition
		if(is_stupid)
			if(istype(head,/obj/item/clothing/head/roguetown/helmet))
				str = "[m3]某种头盔！"
			else
				str = "[m3]某种帽子！"
			if(head_condition)
				str += " [head_condition]"
		. += str

	//suit/armor
	if(wear_armor && !(SLOT_ARMOR in obscured))
		var/str = "[m3] [get_examine_item_name_with_hover(user, wear_armor)]. "
		var/armor_condition = wear_armor.integrity_check()
		if(is_smart || is_normal)
			str += armor_condition
		else if (is_stupid)
			if(istype(wear_armor, /obj/item/clothing/suit/roguetown/armor))
				var/obj/item/clothing/suit/roguetown/armor/examined_armor = wear_armor
				switch(examined_armor.armor_class)
					if(ARMOR_CLASS_LIGHT)
						str = "[m3]一些薄皮甲！"
					if(ARMOR_CLASS_MEDIUM)
						if(!HAS_TRAIT(user, TRAIT_MEDIUMARMOR))
							str = "[m3]一些金属和皮革！"
					if(ARMOR_CLASS_HEAVY)
						if(!HAS_TRAIT(user, TRAIT_HEAVYARMOR))
							str = "[m3]一些很重的金属玩意儿！"
			if(armor_condition)
				str += " [armor_condition]"
		if(armor_condition && !findtext(str, "[armor_condition]"))
			str += " [armor_condition]"
		. += str
		//suit/armor storage
		if(s_store && !(SLOT_S_STORE in obscured))
			if(is_normal || is_smart)
				. += "[m1]带着[get_examine_item_name_with_hover(user, s_store)]在[m2][wear_armor.name]上。"
	//back
//	if(back)
//		. += "[m3] [back.get_examine_string(user)] on [m2] back."

	//cloak
	if(cloak && !(SLOT_CLOAK in obscured))
		var/str
		if(istype(cloak, /obj/item/clothing))
			var/obj/item/clothing/CL = cloak
			str = "[m3][get_examine_item_name_with_hover(user, CL)]在[m2]肩膀上。 "
		else
			str = "[m3][get_examine_item_name_with_hover(user, cloak)]在[m2]肩膀上。 "
		str += cloak.integrity_check(is_smart)
		if (is_stupid)					//So they can tell the named RG tabards. If they can read them, anyway.
			if(!istype(cloak, /obj/item/clothing/cloak/stabard) && user.get_skill_level(/datum/skill/misc/reading) == 0)
				str = "[m3]肩膀上挂着某种布类的东西！"
		. += str

	//right back
	if(backr && !(SLOT_BACK_R in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, backr)]在[m2]背上。"
		str += backr.integrity_check(is_smart)
		. += str

	//left back
	if(backl && !(SLOT_BACK_L in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, backl)]在[m2]背上。"
		str += backl.integrity_check(is_smart)
		. += str

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			var/str = "[m1]用[m2][get_held_index_name(get_held_index_of_item(I))]拿着[get_examine_item_name_with_hover(user, I)]。"
			str += I.integrity_check(is_smart)
			. += str

	var/datum/component/forensics/FR = GetComponent(/datum/component/forensics)
	//gloves
	if(gloves && !(SLOT_GLOVES in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, gloves)]在[m2]手上。 "
		str += gloves.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3]某种手套！"
		. += str
	else if(FR && length(FR.blood_DNA))
		var/hand_number = get_num_arms(FALSE)
		if(hand_number)
			if(is_stupid)
				. += "[m3]手好奇怪！看起来不对劲！"
			else
				. += "[m3][hand_number > 1 ? "" : " a"]<span class='bloody'>血迹斑斑的</span>手[hand_number > 1 ? "s" : ""]！"

	//belt
	if(belt && !(SLOT_BELT in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, belt)]系在[m2]腰上。 "
		str += belt.integrity_check(is_smart)
		. += str
		if(istype(belt, /obj/item/storage/belt/rogue)) // check if belt has dildo attached
			var/obj/item/storage/belt/rogue/belt_with_dildo = belt
			if(belt_with_dildo.attached_toy)
				. += "[m3] [get_examine_item_name_with_hover(user, belt_with_dildo.attached_toy)]挂在[m2]腰带上。 "

	var/modular_chastity_toy_line = human_modular_chastity_toy_examine_line(user, m2, m3)
	if(modular_chastity_toy_line)
		. += modular_chastity_toy_line


	//right belt
	if(beltr && !(SLOT_BELT_R in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, beltr)]在[m2]腰带上。 "
		str += beltr.integrity_check(is_smart)
		. += str

	//left belt
	if(beltl && !(SLOT_BELT_L in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, beltl)]在[m2]腰带上。 "
		str += beltl.integrity_check(is_smart)
		. += str

	//shoes
	if(shoes && !(SLOT_SHOES in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, shoes)]在[m2]脚上。 "
		str += shoes.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3]脚上有些鞋子！"
		. += str

	//mask
	if(wear_mask && !(SLOT_WEAR_MASK in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, wear_mask)]在[m2]脸上。 "
		str += wear_mask.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3]脸上有什么东西！"
		. += str

	//mouth
	if(mouth && !(SLOT_MOUTH in obscured))
		var/str
		if(istype(mouth, /obj/item/clothing))
			var/obj/item/clothing/CM = mouth
			str = "[m3][get_examine_item_name_with_hover(user, CM)]在[m2]嘴里。 "
		else
			"[m3][get_examine_item_name_with_hover(user, mouth)]在[m2]嘴里。 "
		str += mouth.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3]嘴里有什么东西！"
		. += str

	//neck
	if(wear_neck && !(SLOT_NECK in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, wear_neck)]围在[m2]脖子上。 "
		str += wear_neck.integrity_check(is_smart)
		if (is_stupid)
			str = "[m3]脖子上有些东西！"
		. += str

	//eyes
	if(!(SLOT_GLASSES in obscured))
		if(glasses)
			. += "[m3][get_examine_item_name_with_hover(user, glasses)]盖在[m2]眼上。"
		else if(eye_color == BLOODCULT_EYE)
			. += span_warning("<B>[m2]的眼睛散发着不自然的红光！</B>")

	//ears
	if(ears && !(SLOT_HEAD in obscured))
		. += "[m3] [get_examine_item_name_with_hover(user, ears)]在[m2]耳上。"

	//ring
	if(wear_ring && !(SLOT_RING in obscured) && !HAS_TRAIT(wear_ring, TRAIT_EXAMINE_SKIP))
		var/str = "[m3][get_examine_item_name_with_hover(user, wear_ring)]在[m2]手指上。 "
		if(is_smart && istype(wear_ring, /obj/item/clothing/ring/active))
			var/obj/item/clothing/ring/active/AR = wear_ring
			if(AR.cooldowny)
				if(world.time < AR.cooldowny + AR.cdtime)
					str += span_warning("它暂时还无法再次激活。")
				else
					str += span_warning("它已准备就绪。")
		if(is_stupid)
			str = "[m3]某种戒指！"
		. += str

	//wrists
	if(wear_wrists && !(SLOT_WRISTS in obscured))
		var/str = "[m3][get_examine_item_name_with_hover(user, wear_wrists)]在[m2]手腕。"
		str += wear_wrists.integrity_check(is_smart)
		if (is_stupid)
			str = "[m3]手腕上有些东西！"
		. += str

	//handcuffed?
	if(handcuffed)
		if(user == src)
			. += "<span class='warning'>[m1]被\a [handcuffed]绑住了！</span>"
		else
			. += "<A href='?src=[REF(src)];item=[SLOT_HANDCUFFED]'><span class='warning'>[m1]被\a [handcuffed]绑住了！</span></A>"

	if(legcuffed)
		. += "<A href='?src=[REF(src)];item=[SLOT_LEGCUFFED]'><span class='warning'>[m3]\a [legcuffed]捆在[m2]的腿上！</span></A>"

	var/datum/status_effect/bugged/effect = has_status_effect(/datum/status_effect/bugged)
	if(effect && HAS_TRAIT(user, TRAIT_INQUISITION))
		. += "<A href='?src=[REF(src)];item=[effect.device]'><span class='warning'>[m3]\a [effect.device]被植入了。</span></A>"

	//Gets encapsulated with a warning span
	var/list/msg = list()

	var/appears_dead = FALSE
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE

	if (get_bodypart(BODY_ZONE_HEAD)?.grievously_wounded)
		msg += span_bloody("<b>[p_their(TRUE)]的脖子是一片血与骨的惨状，摇摇欲坠地挂着！</b>")

	var/temp = getBruteLoss()
	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		if(temp)
			if (temp < 25)
				msg += "[m3]一些瘀伤。\n"
			else if (temp < 50)
				msg += "[m3]很多瘀伤！\n"
			else
				msg += "<B>[m1]青一块紫一块！！</B>\n"

		temp = getFireLoss()
		if(temp)
			if (temp < 25)
				msg += "[m3]一些烧伤。\n"
			else if (temp < 50)
				msg += "[m3]很多烧伤！\n"
			else
				msg += "<B>[m1]快成烤龙肉了！！</B>\n"

	//body temp
	switch(bodytemperature)
		if(0 to BODYTEMP_COLD_LEVEL_ONE_MAX)
			msg += span_biginfo("<font color='#023E8A'> [m1]失控地颤抖着</font>")
		if(BODYTEMP_COLD_LEVEL_ONE_MAX to BODYTEMP_NORMAL_MIN)
			msg += span_biginfo("<font color='#99e6ff'> [m1]在颤抖</font>")
		if(BODYTEMP_NORMAL_MAX to BODYTEMP_HEAT_LEVEL_ONE_MAX)
			msg += span_biginfo("<font color='#ffff00'> [m1]在出汗</font>")
		if(BODYTEMP_HEAT_LEVEL_ONE_MAX to 600)
			msg += span_biginfo("<font color='#DC143C?'> [m1]汗流不止</font>")

	// Blood volume
	switch(blood_volume)
		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			msg += span_artery("<B>[m1]极其苍白而病态。</B>")
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			msg += span_artery("<B>[m1]非常苍白。</B>")
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			msg += span_artery("[m1]面色苍白。")
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			msg += span_artery("[m1]有点苍白。")

	// Bleeding
	var/bleed_rate = get_bleed_rate()
	if(bleed_rate)
		if(!is_stupid)
			var/bleed_wording = "在出血"
			switch(bleed_rate)
				if(0 to 1)
					bleed_wording = "轻微出血"
				if(1 to 5)
					bleed_wording = "在出血"
				if(5 to 10)
					bleed_wording = "出血很多"
				if(10 to INFINITY)
					bleed_wording = "大量出血"
			var/list/bleeding_limbs = list()
			var/static/list/bleed_zones = list(
				BODY_ZONE_HEAD,
				BODY_ZONE_CHEST,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_LEG,
				BODY_ZONE_L_LEG,
			)
			for(var/bleed_zone in bleed_zones)
				var/obj/item/bodypart/bleeder = get_bodypart(bleed_zone)
				if(!bleeder?.get_bleed_rate() || (!observer_privilege && !get_location_accessible(src, bleeder.body_zone)))
					continue
				bleeding_limbs += parse_zone(bleeder.body_zone)
			if(length(bleeding_limbs))
				if(bleed_rate >= 5)
					msg += span_bloody("<B>[capitalize(m2)]的[english_list(bleeding_limbs)]部位[bleeding_limbs.len > 1 ? "正在" : "正在"][bleed_wording]！</B>")
				else
					msg += span_bloody("[capitalize(m2)]的[english_list(bleeding_limbs)]部位[bleeding_limbs.len > 1 ? "正在" : "正在"][bleed_wording]！")
			else
				if(bleed_rate >= 5)
					msg += span_bloody("<B>[m1][bleed_wording]！</B>")
				else
					msg += span_bloody("[m1][bleed_wording]！")
		else
			if(isliving(user))
				var/mob/living/M = user
				if(M.patron.type == /datum/patron/inhumen/graggar)
					msg += span_bloody("[m1]正倾泻着生命的血液，暴露出软弱！")
				else
					msg += span_bloody("[m1]正往外流着红色的东西！")

	// Missing limbs
	var/missing_head = FALSE
	var/list/missing_limbs = list()
	for(var/missing_zone in get_missing_limbs())
		if(missing_zone == BODY_ZONE_HEAD)
			missing_head = TRUE
			if (isdullahan(src))
				var/datum/species/dullahan/user_species = dna.species
				if(user_species.headless && user != src && !isdullahan(user))
					user.add_stress(/datum/stressevent/headless)
		missing_limbs += parse_zone(missing_zone)

	if(length(missing_limbs))
		var/missing_limb_message = "<B>[capitalize(m2)]的[english_list(missing_limbs)][missing_limbs.len > 1 ? "都" : ""]没了。</B>"
		if(missing_head)
			missing_limb_message = span_dead("[missing_limb_message]")
		else
			missing_limb_message = span_danger("[missing_limb_message]")
		msg += missing_limb_message

	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks))
		msg += "[t_He][t_is]被某些易燃物覆盖了。\n"
	if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[t_He]看起来有点湿透了。\n"
	//Grabbing
	if(pulledby && pulledby.grab_state)
		msg += "[m1]正被[pulledby]抓着。"

	//Nutrition and Thirst
	if(nutrition < (NUTRITION_LEVEL_STARVING - 50))
		msg += "[m1]看起来骨瘦如柴。"
//	else if(nutrition >= NUTRITION_LEVEL_FAT)
//		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
//			msg += "[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy."
//		else
//			msg += "[t_He] [t_is] quite chubby."

	if(HAS_TRAIT(user, TRAIT_EXTEROCEPTION))
		switch(nutrition)
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				msg += "[m1]看起来有点饿了。"
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				msg += "[m1]看起来很饿。"
			if(NUTRITION_LEVEL_STARVING-50 to NUTRITION_LEVEL_STARVING)
				msg += "[m1]看起来饿极了。"
		switch(hydration)
			if(HYDRATION_LEVEL_THIRSTY to HYDRATION_LEVEL_SMALLTHIRST)
				msg += "[m1]看起来[m2]口干舌燥。"
			if(HYDRATION_LEVEL_DEHYDRATED to HYDRATION_LEVEL_THIRSTY)
				msg += "[m1]看起来口渴想喝水。"
			if(0 to HYDRATION_LEVEL_DEHYDRATED)
				msg += "[m1]看起来干渴至极。"

	//Fire/water stacks
	if(has_status_effect(/datum/status_effect/fire_handler))
		msg += "[m1]被某些易燃物覆盖了。"
	if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[m1]湿透了。"

	//Status effects
	var/list/status_examines = status_effect_examines()
	if(length(status_examines))
		msg += status_examines

	//Disgusting behemoth of stun absorption
	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				msg += "[m1][stun_absorption[i]["examine_message"]]"

	if(!appears_dead)
		if(!skipface)
			//Disgust
			switch(disgust)
				if(DISGUST_LEVEL_SLIGHTLYGROSS to DISGUST_LEVEL_GROSS)
					msg += "[m1]有点反感。"
				if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
					msg += "[m1]感到反感。"
				if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
					msg += "[m1]非常反感。"
				if(DISGUST_LEVEL_DISGUSTED to INFINITY)
					msg += "<B>[m1]极度厌恶。</B>"

			//Drunkenness
			switch(drunkenness)
				if(11 to 21)
					msg += "[m1]微微泛红。"
				if(21.01 to 41) //.01s are used in case drunkenness ends up to be a small decimal
					msg += "[m1]脸色发红。"
				if(41.01 to 51)
					msg += "[m1]脸色通红，[m2]的呼吸中带着酒味。"
				if(51.01 to 61)
					msg += "[m1]满脸通红，呼吸中散发着浓烈的酒味。"
				if(61.01 to 91)
					msg += "[m1]看起来一副醉醺醺的样子。"
				if(91.01 to INFINITY)
					msg += "[m1]是个烂醉如泥、口水横流的醉鬼。"

			//Stress
			var/stress = get_stress_amount()
			if(HAS_TRAIT(user, TRAIT_EMPATH))
				switch(stress)
					if(20 to INFINITY)
						msg += "[m1]极度紧张。"
					if(10 to 19)
						msg += "[m1]非常紧张。"
					if(1 to 9)
						msg += "[m1]有点紧张。"
					if(-9 to 0)
						msg += "[m1]不紧张。"
					if(-19 to -10)
						msg += "[m1]内心颇为平静。"
					if(-20 to INFINITY)
						msg += "[m1]内心安宁。"
			else if(stress > 10)
				msg += "[m3]满脸压力。"

		//Jitters
		switch(jitteriness)
			if(300 to INFINITY)
				msg += "<B>[m1]剧烈抽搐！</B>"
			if(200 to 300)
				msg += "[m1]严重颤抖。"
			if(100 to 200)
				msg += "[m1]微微抽动。"

		if(InCritical())
			msg += span_warning("[m1]勉强还有意识。")
		else
			if(stat >= UNCONSCIOUS)
				msg += "[m1][IsSleeping() ? "在睡觉" : "失去了意识"]。"
			else if(eyesclosed)
				msg += "[capitalize(m2)]的眼睛闭着。"
			else if(has_status_effect(/datum/status_effect/debuff/sleepytime))
				msg += "[m1]看起来有点疲惫。"
	else
		msg += "[m1]失去了意识。"
//		else
//			if(HAS_TRAIT(src, TRAIT_DUMB))
//				msg += "[m3] a stupid expression on [m2] face."
//			if(InCritical())
//				msg += "[m1] barely conscious."
//		if(getorgan(/obj/item/organ/brain))
//			if(!key)
//				msg += span_deadsay("[m1] totally catatonic. The stresses of life in deep-space must have been too much for [t_him]. Any recovery is unlikely.")
//			else if(!client)
//				msg += "[m3] a blank, absent-minded stare and appears completely unresponsive to anything. [t_He] may snap out of it soon."

	if(length(msg))
		. += span_warning("[msg.Join("\n")]")

	// Show especially large embedded objects at a glance
	for(var/obj/item/bodypart/part as anything in bodyparts)
		if(LAZYLEN(part.embedded_objects))
			for(var/obj/item/stuck_thing as anything in part.embedded_objects)
				if(stuck_thing.w_class >= WEIGHT_CLASS_SMALL)
					. += span_bloody("<b>[m3]\a [stuck_thing]卡在[m2]的[part.name]里！</b>")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/stress = H.get_stress_amount()//stress check for racism
		if(H.dna.species.name != dna.species.name && dna.species.stress_examine)
			var/should_apply_species_reaction = dna.species.examine_stress_always
			if(!should_apply_species_reaction)
				should_apply_species_reaction = H.has_flaw(/datum/charflaw/paranoid) || stress >= 4
			if(should_apply_species_reaction)
				var/is_graggar_follower = (H.patron?.type == dna.species.examine_relief_patron)
				if(is_graggar_follower)
					if(dna.species.examine_relief_event)
						user.add_stress(dna.species.examine_relief_event)
				else
					. += dna.species.stress_desc
					if(dna.species.examine_stress_ignores_tolerant || !HAS_TRAIT(user, TRAIT_TOLERANT))//They're given the stress event if they qualify for racism and aren't tolerant.
						var/stress_type = dna.species.examine_stress_event
						if(HAS_TRAIT(user, TRAIT_XENOPHOBIC))//Xenophobic are hit worse. By a bit.
							stress_type = dna.species.examine_stress_event_xenophobic
						user.add_stress(stress_type)

	if((user != src) && isliving(user))
		var/mob/living/L = user
		var/final_str = STASTR
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_str = L.STASTR - rand(1,2)
		var/strength_diff = final_str - L.STASTR
		switch(strength_diff)
			if(5 to INFINITY)
				. += span_warning("<B>[t_He]看起来比我强壮得多。</B>")
			if(1 to 5)
				. += span_warning("[t_He]看起来比我强壮。")
			if(0)
				. += "[t_He]看起来和我差不多强壮。"
			if(-5 to -1)
				. += span_warning("[t_He]看起来比我弱。")
			if(-INFINITY to -5)
				. += span_warning("<B>[t_He]看起来比我弱得多。</B>")

	if((HAS_TRAIT(user,TRAIT_INTELLECTUAL)))
		var/mob/living/L = user
		var/final_int = STAINT
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_int = L.STAINT
		var/int_diff = final_int - L.STAINT
		switch(int_diff)
			if(5 to INFINITY)
				. += span_revenwarning("[t_He]看起来比我聪明得多。")
			if(2 to 5)
				. += span_revenminor("[t_He]看起来比我聪明。")
			if(-1 to 1)
				. += "[t_He]看起来和我差不多聪明。"
			if(-5 to -2)
				. += span_revennotice("[t_He]看起来比我笨。")
			if(-INFINITY to -5)
				. += span_revennotice("[t_He]脑袋笨得像块石头。")

	if(maniac)
		var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
		if(heart?.inscryption && (heart.inscryption_key in maniac.key_nums))
			. += span_danger("[t_He]知道[heart.inscryption_key]，我对此确信无疑！")

	if(Adjacent(user))
		if(observer_privilege)
			var/static/list/check_zones = list(
				BODY_ZONE_HEAD,
				BODY_ZONE_CHEST,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_LEG,
				BODY_ZONE_L_LEG,
			)
			for(var/zone in check_zones)
				var/obj/item/bodypart/bodypart = get_bodypart(zone)
				if(!bodypart)
					continue
				. += "<a href='?src=[REF(src)];inspect_limb=[zone]'>检查 [parse_zone(zone)]</a>"
			. += "<a href='?src=[REF(src)];check_hb=1'>检查心跳</a>"
		else
			var/checked_zone = check_zone(user.zone_selected)
			. += "<a href='?src=[REF(src)];inspect_limb=[checked_zone]'>检查 [parse_zone(checked_zone)]</a>"
			if(!(mobility_flags & MOBILITY_STAND) && user != src && (user.zone_selected == BODY_ZONE_CHEST))
				. += "<a href='?src=[REF(src)];check_hb=1'>倾听心跳</a>"

	if(!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS) && user != src)
		if(isliving(user))
			var/mob/living/L = user
			if(L.STAINT > 9 && L.STAPER > 9)
				if(HAS_TRAIT(src, TRAIT_COMBAT_AWARE))
					. += span_warning("<i>他们看起来身经百战。</i>")
				if(HAS_TRAIT(user, TRAIT_COMBAT_AWARE))
					var/userheld = user.get_active_held_item()
					var/srcheld = get_active_held_item()
					var/datum/skill/user_skill = /datum/skill/combat/unarmed	//default
					var/datum/skill/src_skill = /datum/skill/combat/unarmed
					if(userheld)
						var/obj/item/I = userheld
						if(I.associated_skill)
							user_skill = I.associated_skill
					if(srcheld)
						var/obj/item/I = srcheld
						if(I.associated_skill)
							src_skill = I.associated_skill
					var/skilldiff = user.get_skill_level(user_skill) - get_skill_level(src_skill)
					. += "<font size = 3><i>[skilldiff_report(skilldiff)]在我擅长的武艺上，相对而言他们就是了。</i></font>"

	if((dna?.species?.id != "gnoll") && (!obscure_name || client?.prefs.masked_examine) && (flavortext || headshot_link || ooc_notes))
		. += "<a href='?src=[REF(src)];task=view_headshot;'>Examine closer</a>"

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(get_dist(src, H) <= ((2 + clamp(floor(((H.STAPER - 10))),-1, 4)) + HAS_TRAIT(user, TRAIT_INTELLECTUAL)))
			. += "<a href='?src=[REF(src)];task=assess;'>评估</a>"

	/// Rumours & Gossip
	if(length(rumour) || length(noble_gossip))
		if(!obscure_name || (obscure_name && client?.prefs.masked_examine) || observer_privilege)
			. += "<a href='?src=[REF(src)];task=view_rumours_gossip;'>回忆传闻与八卦</a>"

	if(lip_style)
		switch(lip_color)
			if("red")
				. += "<span class='info' style='color: #a81324'>[m1]涂着红色口红。</span>"
			if("purple")
				. += "<span class='info' style='color: #800080'>[m1]涂着紫色口红。</span>"
			if("lime")
				. += "<span class='info' style='color: #00FF00'>[m1]涂着亮绿色口红。</span>"
			if("black")
				. += "<span class='info' style='color: #313131ff'>[m1]涂着黑色口红。</span>"


	var/list/lines
	if((get_face_name() != real_name) && !observer_privilege)
		lines = build_cool_description_unknown(get_mob_descriptors_unknown(obscure_name, user), src)
	else
		lines = build_cool_description(get_mob_descriptors(obscure_name, user), src)

	for(var/line in lines)
		. += span_info(line)

	// for underwears that don't cover from the rear, genital descriptions are still shown
	if(get_location_accessible(src, BODY_ZONE_PRECISE_GROIN) && src.underwear)
		//separate these conditions to not throw an error when no underwear is worn at all
		if(user.InCone(src, turn(src.dir, 180)) && !src.underwear.covers_rear)
			var/list/descriptors = list()
			//only populate the descriptors for genitals you have
			if(src.getorganslot(ORGAN_SLOT_PENIS))
				descriptors += /datum/mob_descriptor/penis
			if(src.getorganslot(ORGAN_SLOT_VAGINA))
				descriptors += /datum/mob_descriptor/vagina
			if(src.getorganslot(ORGAN_SLOT_TESTICLES))
				descriptors += /datum/mob_descriptor/testicles
			. += span_info("[t_his]的内衣从后面遮不住[t_him]。")
			//male genitalia line
			var/malegen = build_coalesce_description(descriptors, src, list(MOB_DESCRIPTOR_SLOT_PENIS, MOB_DESCRIPTOR_SLOT_TESTICLES), "%THEY% %DESC1%, and %DESC2%.")
			if(malegen)
				. += span_info(malegen)
			//female genitalia line
			var/femgen = build_coalesce_description(descriptors, src, list(MOB_DESCRIPTOR_SLOT_VAGINA), "%THEY% %DESC1%.")
			if(femgen)
				. += span_info(femgen)

	if(branded) // we are branded, now check what bodypart brands we've got. genital brands handled separately.
		for(var/obj/item/bodypart/branded_bodypart as anything in bodyparts)
			if(length(branded_bodypart.branded_writing) && get_location_accessible(src, branded_bodypart.body_zone))
				. += span_info("[capitalize(m2)]的[LOWER_TEXT(branded_bodypart.name)]被烙上了 ") + "[span_boldwarning(branded_bodypart.branded_writing)]."
			if(istype(branded_bodypart, /obj/item/bodypart/chest))
				var/obj/item/bodypart/chest/chest = branded_bodypart
				if(length(chest.branded_writing_on_buttocks) && get_location_accessible(src, BODY_ZONE_PRECISE_GROIN))
					. += span_info("[capitalize(m2)]的臀部被烙上了 ") + "[span_boldwarning(chest.branded_writing_on_buttocks)]."
				if(length(chest.branded_writing_on_stomach) && get_location_accessible(src, BODY_ZONE_PRECISE_STOMACH))
					. += span_info("[capitalize(m2)]的腹部被烙上了 ") + "[span_boldwarning(chest.branded_writing_on_stomach)]."
			else if(istype(branded_bodypart, /obj/item/bodypart/head))
				var/obj/item/bodypart/head/neck = branded_bodypart
				if(length(neck.branded_writing_on_neck) && get_location_accessible(src, BODY_ZONE_PRECISE_NECK))
					. += span_info("[capitalize(m2)]的脖子被烙上了 ") + "[span_boldwarning(neck.branded_writing_on_neck)]."

	// Characters with the marked for death flaw will freak out if they can't see someone's face.
	if(!appears_dead)
		if(skipface && user.has_flaw(/datum/charflaw/assassintarget) && user != src)
			user.add_stress(/datum/stressevent/hunted)

	if(dna?.species?.type == /datum/species/gnoll)
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.dna?.species?.type == /datum/species/gnoll)
				if(user.advjob)
					. += span_notice("<i>他们是族群的[advjob]。</i>")

	var/trait_exam = common_trait_examine()
	if(!isnull(trait_exam))
		. += trait_exam

	if(temporary_flavortext) //should be kept at the bottom always if possible, since someone could change the spans to trick people if it's on other places
		var/max_temp_ft_length = 100 //Proably a good idea to fine-tune this later
		if(length_char(temporary_flavortext) > max_temp_ft_length)
			. += " <span class='info' style='color: #eaeaea'> ø ------------ ø\n [copytext_char(temporary_flavortext, 1, max_temp_ft_length + 1)]</span>" + "<a href='?src=[REF(src)];task=show_temp_ft;'>...</a>"
		else
			. += " <span class='info' style='color: #eaeaea'> ø ------------ ø\n [temporary_flavortext]</span>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/mob/living/proc/status_effect_examines(pronoun_replacement) //You can include this in any mob's examine() to show the examine texts of status effects!
	var/list/dat = list()
	if(!pronoun_replacement)
		pronoun_replacement = p_they(TRUE)
	for(var/V in status_effects)
		var/datum/status_effect/E = V
		if(E.examine_text)
			var/new_text = replacetext(E.examine_text, "SUBJECTPRONOUN", pronoun_replacement)
			new_text = replacetext(new_text, "[pronoun_replacement] is", "[pronoun_replacement] [p_are()]") //To make sure something become "They are" or "She is", not "They are" and "She are"
			dat += "[new_text]\n" //dat.Join("\n") doesn't work here, for some reason
	if(dat.len)
		return dat.Join()

/// Returns patron-related examine text for the mob, if any. Can return null.
/mob/living/proc/get_heretic_text(mob/examiner)
	var/heretic_text = null
	var/seer

	if(HAS_TRAIT(src,TRAIT_DECEIVING_MEEKNESS))
		return null

	if(HAS_TRAIT(examiner, TRAIT_HERETIC_SEER))
		seer = TRUE

	if(HAS_TRAIT(src, TRAIT_COMMIE))
		if(seer)
			heretic_text += "马西奥斯信徒。"
			if(HAS_TRAIT(examiner, TRAIT_COMMIE))
				heretic_text += " 共享。共担。为众人，为我们。"
		else if(HAS_TRAIT(examiner, TRAIT_COMMIE))
			heretic_text += "同志！"
	else if((HAS_TRAIT(src, TRAIT_CABAL)))
		if(seer)
			heretic_text += "齐佐密社的成员。"
			if(HAS_TRAIT(examiner, TRAIT_CABAL))
				heretic_text += " 愿他们的野心不要妨碍到我。"
	else if((HAS_TRAIT(src, TRAIT_HORDE)))
		if(seer)
			heretic_text += "经格拉加尔的仪式千锤百炼。"
			if(HAS_TRAIT(examiner, TRAIT_HORDE))
				heretic_text += " 我自己的仪式也是一段光荣的记忆。"
	else if((HAS_TRAIT(src, TRAIT_DEPRAVED)))
		if(seer)
			heretic_text += "巴奥莎的眷顾者。"
			if(HAS_TRAIT(examiner, TRAIT_DEPRAVED))
				heretic_text += " 她引领我们走向至高之境。"

	return heretic_text

/// Same as get_heretic_text, but returns a simple symbol depending on the type of heretic!
/mob/living/proc/get_heretic_symbol(mob/examiner)
	var/heretic_text
	if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
		return
	if(HAS_TRAIT(src, TRAIT_COMMIE) && HAS_TRAIT(examiner, TRAIT_COMMIE))
		heretic_text += "♠"
	else if(HAS_TRAIT(src, TRAIT_CABAL) && HAS_TRAIT(examiner, TRAIT_CABAL))
		heretic_text += "♦"
	else if(HAS_TRAIT(src, TRAIT_HORDE) && HAS_TRAIT(examiner, TRAIT_HORDE))
		heretic_text += "♠"
	else if(HAS_TRAIT(src, TRAIT_DEPRAVED) && HAS_TRAIT(examiner, TRAIT_DEPRAVED))
		heretic_text += "♥"

	return heretic_text


// Used for Inquisition tags
/mob/living/proc/get_inquisition_text(mob/examiner)
	var/inquisition_text
	if(HAS_TRAIT(src, TRAIT_INQUISITION) && HAS_TRAIT(examiner, TRAIT_INQUISITION))
		inquisition_text = "一位共同遵循神圣奥塔瓦宗教审判所使命的同伴。"
	if(HAS_TRAIT(src, TRAIT_PURITAN) && HAS_TRAIT(examiner, TRAIT_INQUISITION))
		inquisition_text = "我的上级，由神圣奥塔瓦宗教审判所派遣来领导我们教派。"
	if(HAS_TRAIT(src, TRAIT_INQUISITION) && HAS_TRAIT(examiner, TRAIT_PURITAN))
		inquisition_text = "我在权威下的下属，这是神圣奥塔瓦宗教审判所的旨意。"
	if(HAS_TRAIT(src, TRAIT_PURITAN) && HAS_TRAIT(examiner, TRAIT_PURITAN))
		inquisition_text = "我自己。我领导着神圣奥塔瓦宗教审判所的这一教派。"

	return inquisition_text

/// Returns antagonist-related examine text for the mob, if any. Can return null.
/mob/living/proc/get_villain_text(mob/examiner)
	var/villain_text
	if(mind)
		if(mind.special_role == "强盗")
			if(HAS_TRAIT(examiner, TRAIT_COMMIE))
				villain_text = span_notice("自由人!")
			if(HAS_TRAIT(src,TRAIT_KNOWNCRIMINAL))
				villain_text = span_userdanger("法外之徒!")
		if(mind.special_role == "尸鬼") //对齐 code/modules/antagonists/roguetown/villain/zombie/zombie.dm /datum/antagonist/zombie
			villain_text = span_userdanger("尸鬼!")
		if(mind.special_role == "Vampire Lord")
			var/datum/antagonist/vampire/VD = mind.has_antag_datum(/datum/antagonist/vampire)
			if(!SEND_SIGNAL(VD.owner, COMSIG_DISGUISE_STATUS))
				villain_text += span_userdanger("怪物!")
		if(mind.assigned_role == "Lunatic")
			villain_text += span_userdanger("疯子!")

	return villain_text

/proc/get_blade_dulling_text(obj/item/rogueweapon/I, verbose = FALSE)
	switch(I.blade_dulling)
		if(DULLING_SHAFT_WOOD)
			return "[verbose ? "木制的" : "(木柄)"]"
		if(DULLING_SHAFT_REINFORCED)
			return "[verbose ? "加固的" : "(加固柄)"]"
		if(DULLING_SHAFT_METAL)
			return "[verbose ? "金属的" : "(金属柄)"]"
		if(DULLING_SHAFT_GRAND)
			return "[verbose ? "宏大的" : "(宏大柄)"]"
		if(DULLING_SHAFT_CONJURED)
			return "[verbose ? "召唤的" : "(召唤柄)"]"
		else
			return null

/// Simple gang sytem

/mob/living/proc/get_gang_text(mob/examiner)
	var/gang_text = null

	if (HAS_TRAIT(src, TRAIT_GANG_A))
		if (HAS_TRAIT(examiner, TRAIT_GANG_A))
			gang_text = span_notice ("我的隆兹鼠帮帮派成员！")
		else if (HAS_TRAIT(examiner, TRAIT_GANG_B))
			gang_text = span_userdanger ("隆兹鼠帮渣滓！敌人！") ///I don't know why it doesn't indicate the correct gang here


	if (HAS_TRAIT(src, TRAIT_GANG_B))
		if (HAS_TRAIT(examiner, TRAIT_GANG_B))
			gang_text = span_notice ("我的布洛兹狼帮帮派成员！")
		else if (HAS_TRAIT(examiner, TRAIT_GANG_A))
			gang_text = span_userdanger ("布洛兹狼帮渣滓！敌人！")

	return gang_text

