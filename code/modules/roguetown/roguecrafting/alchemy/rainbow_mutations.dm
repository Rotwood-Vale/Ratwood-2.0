GLOBAL_LIST_EMPTY(recall_anchors)
GLOBAL_LIST_EMPTY(recall_cooldowns)

/datum/reagent/medicine/mythic
	name = "Mythic Concoction"
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_METABOLISM * 0.1
	var/potency_tier = 1


/datum/reagent/medicine/mythic/New()
	..()
	if(!islist(data))
		data = list()
	data["potency_tier"] = potency_tier

/datum/reagent/medicine/mythic/on_new(list/new_data)
	..()
	if(islist(new_data) && new_data["potency_tier"])
		potency_tier = new_data["potency_tier"]
	if(!islist(data))
		data = list()
	data["potency_tier"] = potency_tier

/datum/reagent/medicine/mythic/on_merge(list/new_data, amount)
	..()
	if(islist(new_data) && new_data["potency_tier"])
		potency_tier = max(potency_tier, new_data["potency_tier"])
	if(!islist(data))
		data = list()
	data["potency_tier"] = potency_tier

/datum/reagent/medicine/mythic/health
	name = "Elixir of Life III"
	description = "A mythical panacea shimmering with prismatic light. Legend says it can knit flesh, blood, and severed limbs."
	color = "#ff007f"
	taste_description = "pure revitalizing warmth"
	var/next_limb_regen = 0

/datum/reagent/medicine/mythic/health/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	M.adjustBruteLoss(-12 * REM, 0)
	M.adjustFireLoss(-12 * REM, 0)
	M.adjustOxyLoss(-8, 0)
	M.adjustToxLoss(-6, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -10 * REM)
	M.adjustCloneLoss(-10 * REM, 0)

	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(9)

	if(potency_tier >= 2)
		if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
			M.set_blood_volume(min(M.get_blood_volume() + 40, BLOOD_VOLUME_NORMAL))

		M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot)
		M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot)

	if(potency_tier >= 3 && ishuman(M))
		var/mob/living/carbon/human/H = M
		if(world.time >= next_limb_regen)
			var/list/missing_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			for(var/zone in missing_zones)
				if(!H.get_bodypart(zone))
					if(H.regenerate_limb(zone))
						H.visible_message(span_userdanger("The flesh on [H]'s stump erupts with iridescent light, regrowing the limb!"))
						playsound(H.loc, 'sound/magic/heal.ogg', 70, TRUE)
						next_limb_regen = world.time + 8 SECONDS
						break
	..()

/datum/reagent/medicine/mythic/mana
	name = "Archon's Surge III"
	description = "Pure condensed aether. Restores immense magical reservoirs and sharpens spellcasting focus."
	color = "#00d4ff"
	taste_description = "crackling lightning"

/datum/reagent/medicine/mythic/mana/on_mob_metabolize(mob/living/L)
	. = ..()

	if(potency_tier >= 3 && ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/eyes/E = H.getorganslot(ORGAN_SLOT_EYES)

		ADD_TRAIT(H, TRAIT_DARKVISION, type)
		H.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if(E)
			E.see_in_dark = 8
			E.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		H.update_sight()
		H.sync_lighting_plane_alpha()

		if(H.mind)
			for(var/obj/effect/proc_holder/spell/S in (H.mind.spell_list | H.mob_spell_list))
				S.finish_recharge()
			to_chat(H, span_notice("Arcane energy surges through your mind, refreshing all spells!"))

/datum/reagent/medicine/mythic/mana/on_mob_end_metabolize(mob/living/L)
	if(potency_tier >= 3 && ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/eyes/E = H.getorganslot(ORGAN_SLOT_EYES)
		REMOVE_TRAIT(H, TRAIT_DARKVISION, type)
		H.lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
		if(E)
			E.see_in_dark = initial(E.see_in_dark)
			E.lighting_alpha = initial(E.lighting_alpha)
		H.update_sight()
		H.sync_lighting_plane_alpha()
	..()

/datum/reagent/medicine/mythic/mana/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
		M.energy_add(250)

	if(potency_tier >= 2)
		M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot)
		M.stamina_add(-30)

	..()


/datum/reagent/medicine/mythic/stamina
	name = "Endless Wind III"
	description = "Turns the blood into pure kinetic wind, rendering the drinker inexhaustible."
	color = "#00ff66"
	taste_description = "sparkling static shock"

/datum/reagent/medicine/mythic/stamina/on_mob_metabolize(mob/living/L)
	. = ..()
	if(potency_tier >= 3)
		ADD_TRAIT(L, TRAIT_STUNIMMUNE, type)
		L.SetAllImmobility(0, TRUE)
		to_chat(L, span_notice("A violent wind courses through your veins, making you completely unstoppable!"))

/datum/reagent/medicine/mythic/stamina/on_mob_end_metabolize(mob/living/L)
	if(potency_tier >= 3)
		REMOVE_TRAIT(L, TRAIT_STUNIMMUNE, type)
		to_chat(L, span_warning("The unstoppable winds settle down."))
	..()

/datum/reagent/medicine/mythic/stamina/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	M.stamina_add(-100)

	if(potency_tier >= 2)
		M.apply_status_effect(/datum/status_effect/buff/alch/speedpot)

	if(potency_tier >= 3)
		M.SetAllImmobility(0, FALSE)
		M.stam_paralyzed = FALSE

	..()


/datum/reagent/medicine/mythic/antidote
	name = "Pestra's Cleansing III"
	description = "The pinnacle of physician mastery. Purges all biological and spiritual contagions."
	color = "#005522"
	taste_description = "pure mountain spring water"

/datum/reagent/medicine/mythic/antidote/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	M.adjustToxLoss(-25, 0)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R.harmful && R != src)
			holder.remove_reagent(R.type, 8)

	if(potency_tier >= 2)
		holder.remove_reagent(/datum/reagent/infection, 15)
		holder.remove_reagent(/datum/reagent/infection/minor, 15)
		holder.remove_reagent(/datum/reagent/infection/major, 15)
		M.set_disgust(0)
		M.dizziness = 0
		M.jitteriness = 0

	if(potency_tier >= 3)
		if(M.has_status_effect(/datum/status_effect/debuff/ritualdefiled))
			M.remove_status_effect(/datum/status_effect/debuff/ritualdefiled)

		if(M.mind && M.mind.curses && M.mind.curses.len)
			for(var/c_name in M.mind.curses)
				var/datum/modular_curse/C = M.mind.curses[c_name]
				if(istype(C))
					qdel(C)
			M.mind.curses.Cut()
			to_chat(M, span_notice("A brilliant radiance purges all curses from your spirit!"))

	..()

/datum/reagent/medicine/mythic/strength
	name = "Titan's Might III"
	color = "#e65100"
	taste_description = "raw iron and molten marrow"

/datum/reagent/medicine/mythic/strength/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/alch/mythic_str)

	if(potency_tier >= 3)
		ADD_TRAIT(L, TRAIT_STRENGTH_UNCAPPED, type)
		L.apply_status_effect(/datum/status_effect/buff/potence, 2)
		to_chat(L, span_notice("Your muscles swell with unrestrained titan strength!"))

/datum/reagent/medicine/mythic/strength/on_mob_end_metabolize(mob/living/L)
	L.remove_status_effect(/datum/status_effect/buff/alch/mythic_str)

	if(potency_tier >= 3)
		REMOVE_TRAIT(L, TRAIT_STRENGTH_UNCAPPED, type)
		L.remove_status_effect(/datum/status_effect/buff/potence)
		to_chat(L, span_warning("The titanic power in your sinews subsides."))
	..()

/datum/reagent/medicine/mythic/strength/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	if(potency_tier >= 2)
		M.stamina_add(-25)
	..()

/datum/reagent/medicine/mythic/constitution
	name = "Adamantine Flesh III"
	color = "#212121"
	taste_description = "stone dust and heavy minerals"

/datum/reagent/medicine/mythic/constitution/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/alch/mythic_con)

	if(potency_tier >= 3)
		ADD_TRAIT(L, TRAIT_CRITICAL_RESISTANCE, type)
		ADD_TRAIT(L, TRAIT_NOPAIN, type)
		to_chat(L, span_notice("Your skin hardens into adamantine stone!"))

/datum/reagent/medicine/mythic/constitution/on_mob_end_metabolize(mob/living/L)
	L.remove_status_effect(/datum/status_effect/buff/alch/mythic_con)

	if(potency_tier >= 3)
		REMOVE_TRAIT(L, TRAIT_CRITICAL_RESISTANCE, type)
		REMOVE_TRAIT(L, TRAIT_NOPAIN, type)
		to_chat(L, span_warning("The mineral density of your skin returns to normal."))
	..()

/datum/reagent/medicine/mythic/constitution/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	if(potency_tier >= 2)
		M.heal_wounds(5)

	if(potency_tier >= 3)
		M.adjustBruteLoss(-2, 0)
	..()


/datum/reagent/medicine/mythic/speed
	name = "Phantom Celerity III"
	color = "#ffd600"
	taste_description = "sparkling static"

/datum/reagent/medicine/mythic/speed/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/alch/mythic_spd)

	if(potency_tier >= 2)
		ADD_TRAIT(L, TRAIT_DODGEEXPERT, type)

	if(potency_tier >= 3)
		ADD_TRAIT(L, TRAIT_IGNORESLOWDOWN, type)
		ADD_TRAIT(L, TRAIT_LONGSTRIDER, type)
		ADD_TRAIT(L, TRAIT_NOSLIPALL, type)
		ADD_TRAIT(L, TRAIT_LIGHT_STEP, type)
		to_chat(L, span_notice("Your feet feel weightless, detached from the burden of the earth!"))

/datum/reagent/medicine/mythic/speed/on_mob_end_metabolize(mob/living/L)
	L.remove_status_effect(/datum/status_effect/buff/alch/mythic_spd)

	if(potency_tier >= 2)
		REMOVE_TRAIT(L, TRAIT_DODGEEXPERT, type)
	if(potency_tier >= 3)
		REMOVE_TRAIT(L, TRAIT_IGNORESLOWDOWN, type)
		REMOVE_TRAIT(L, TRAIT_LONGSTRIDER, type)
		REMOVE_TRAIT(L, TRAIT_NOSLIPALL, type)
		REMOVE_TRAIT(L, TRAIT_LIGHT_STEP, type)
		to_chat(L, span_warning("Your supernatural lightness fades away."))
	..()

/datum/reagent/medicine/mythic/speed/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	if(potency_tier >= 2)
		M.stamina_add(-25)
	..()


/datum/reagent/medicine/mythic/perception
	name = "All-Seeing Eye III"
	color = "#ffff8d"
	taste_description = "glowing embers"
	var/old_see_in_dark = null
	var/old_lighting_alpha = null

/datum/reagent/medicine/mythic/perception/on_mob_metabolize(mob/living/L)
	. = ..()

	L.apply_status_effect(/datum/status_effect/buff/alch/mythic_per)

	if(potency_tier >= 2 && ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/eyes/E = H.getorganslot(ORGAN_SLOT_EYES)

		ADD_TRAIT(H, TRAIT_DARKVISION, type)
		ADD_TRAIT(H, TRAIT_NIGHT_VISION, type)

		old_lighting_alpha = H.lighting_alpha
		H.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE

		if(E)
			old_see_in_dark = E.see_in_dark
			E.see_in_dark = 8
			E.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE

		H.update_sight()
		H.sync_lighting_plane_alpha()
		to_chat(H, span_notice("The shadows part as your vision adapts to the darkness!"))

	if(potency_tier >= 3)
		ADD_TRAIT(L, TRAIT_XRAY_VISION, type)
		L.update_sight()
		to_chat(L, span_userdanger("The veil of reality dissolves! You see through stone and flesh!"))

/datum/reagent/medicine/mythic/perception/on_mob_end_metabolize(mob/living/L)
	L.remove_status_effect(/datum/status_effect/buff/alch/mythic_per)

	if(potency_tier >= 2 && ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/eyes/E = H.getorganslot(ORGAN_SLOT_EYES)

		REMOVE_TRAIT(H, TRAIT_DARKVISION, type)
		REMOVE_TRAIT(H, TRAIT_NIGHT_VISION, type)

		if(!isnull(old_lighting_alpha))
			H.lighting_alpha = old_lighting_alpha
		else
			H.lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE

		if(E)
			if(!isnull(old_see_in_dark))
				E.see_in_dark = old_see_in_dark
			else
				E.see_in_dark = initial(E.see_in_dark)
			E.lighting_alpha = initial(E.lighting_alpha)

		H.update_sight()
		H.sync_lighting_plane_alpha()
		to_chat(H, span_warning("Your supernatural sight fades away."))

	if(potency_tier >= 3)
		REMOVE_TRAIT(L, TRAIT_XRAY_VISION, type)
		L.update_sight()
	..()

/datum/reagent/medicine/mythic/perception/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	M.cure_nearsighted(type)
	M.adjustOrganLoss(ORGAN_SLOT_EYES, -2 * REM)
	..()

/datum/reagent/medicine/mythic/intelligence
	name = "Arcane Omniscience III"
	color = "#00e676"
	taste_description = "sweet glowing nectar"

/datum/reagent/medicine/mythic/intelligence/on_mob_metabolize(mob/living/L)
	. = ..()

	L.apply_status_effect(/datum/status_effect/buff/alch/mythic_int)

	if(potency_tier >= 2 && L.mind)
		L.mind.add_sleep_experience(/datum/skill/magic/arcane, 100, FALSE)
		L.mind.add_sleep_experience(/datum/skill/craft/alchemy, 100, FALSE)
		to_chat(L, span_notice("Esoteric revelations flood your mind with newfound understanding!"))

	if(potency_tier >= 3)
		L.apply_status_effect(/datum/status_effect/buff/alch/mythic_max_int)
		to_chat(L, span_userdanger("Your mind transcends mortal limits! Pure intellect illuminates your soul!"))

/datum/reagent/medicine/mythic/intelligence/on_mob_end_metabolize(mob/living/L)
	L.remove_status_effect(/datum/status_effect/buff/alch/mythic_int)

	if(potency_tier >= 3)
		L.remove_status_effect(/datum/status_effect/buff/alch/mythic_max_int)
		to_chat(L, span_warning("The cosmic knowledge slips from your grasp."))
	..()

/datum/reagent/medicine/mythic/intelligence/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	if(potency_tier >= 2)
		if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
			M.energy_add(40)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -4 * REM)
	..()

/datum/reagent/medicine/mythic/fortune
	name = "Fortune's Chosen III"
	color = "#ffea00"
	taste_description = "sparkling champagne"

/datum/reagent/medicine/mythic/fortune/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/alch/mythic_lck)

	if(potency_tier >= 2)
		ADD_TRAIT(L, TRAIT_CRITICAL_RESISTANCE, type)
		to_chat(L, span_notice("You feel an unseen force shielding you from fatal mishaps!"))

	if(potency_tier >= 3)
		L.apply_status_effect(/datum/status_effect/buff/alch/mythic_max_lck)
		to_chat(L, span_userdanger("You are anointed by Destiny! Fate bends completely to your will!"))

/datum/reagent/medicine/mythic/fortune/on_mob_end_metabolize(mob/living/L)
	L.remove_status_effect(/datum/status_effect/buff/alch/mythic_lck)

	if(potency_tier >= 2)
		REMOVE_TRAIT(L, TRAIT_CRITICAL_RESISTANCE, type)

	if(potency_tier >= 3)
		L.remove_status_effect(/datum/status_effect/buff/alch/mythic_max_lck)
		to_chat(L, span_warning("The threads of fortune loosen."))
	..()

/datum/reagent/medicine/mythic/fortune/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	if(potency_tier >= 2)
		M.stamina_add(-25)

	..()

/datum/reagent/medicine/mythic/fire_resist
	name = "Infernal Sovereign III"
	color = "#ff3d00"
	taste_description = "burning brimstone and honey"
	var/next_ash_burst = 0

/datum/reagent/medicine/mythic/fire_resist/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/alch/fire_resist/mythic)
	to_chat(L, span_notice("The warmth of primordial fire wraps around you, shielding your flesh!"))

/datum/reagent/medicine/mythic/fire_resist/on_mob_end_metabolize(mob/living/L)
	L.remove_status_effect(/datum/status_effect/buff/alch/fire_resist/mythic)
	to_chat(L, span_warning("The protective flames fade from your skin."))
	..()

/datum/reagent/medicine/mythic/fire_resist/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()
	
	M.adjustFireLoss(-10, 0)
	M.adjust_fire_stacks(-10)

	if(potency_tier >= 2)
		var/turf/open/T = get_turf(M)
		if(istype(T) && !locate(/obj/effect/hotspot) in T)
			new /obj/effect/hotspot(T)

	if(potency_tier >= 3 && world.time >= next_ash_burst)
		next_ash_burst = world.time + 5 SECONDS
		var/turf/center = get_turf(M)

		new /obj/effect/temp_visual/small_smoke(center)

		for(var/mob/living/L in range(2, center))
			if(L == M || L.stat == DEAD)
				continue

			L.blur_eyes(5)
			L.adjustOxyLoss(12)
			L.stamina_add(15)
			to_chat(L, span_userdanger("Choking black ash billows from [M], searing your throat and blinding your eyes!"))
	..()


/datum/reagent/medicine/mythic/strong_poison
	name = "Venom of the Void III"
	color = "#050005"
	taste_description = "pure agony and rot"
	harmful = TRUE
	metabolization_rate = 0.2 * REAGENTS_METABOLISM

/datum/reagent/medicine/mythic/strong_poison/on_mob_metabolize(mob/living/L)
	. = ..()
	if(potency_tier >= 3)
		to_chat(L, span_userdanger("A PITCH-BLACK ICHOR FREEZES YOUR SOUL! YOUR HEART TURNS TO DUST!"))
		L.playsound_local('sound/magic/heartbeat.ogg', 100)
		L.death(FALSE)

/datum/reagent/medicine/mythic/strong_poison/on_mob_life(mob/living/carbon/M)
	if(volume <= 0.05)
		return ..()

	M.adjustToxLoss(5)

	if(potency_tier >= 2)
		M.Paralyze(3 SECONDS)
		M.blur_eyes(5)
		if(prob(30))
			to_chat(M, span_userdanger("My limbs refuse to respond! The poison paralyzes my spine!"))
	..()

/datum/reagent/magic/recall
	name = "Chronowarp Tincture"
	description = "A shimmering, iridescent liquid that hums with unstable spatial arcana. The first sip anchors your physical presence in space; the second snaps you back to that anchor."
	color = "#7b1fa2"
	taste_description = "ozone and metallic deja-vu"
	metabolization_rate = REAGENTS_METABOLISM * 0.5

/datum/reagent/magic/recall/on_mob_add(mob/living/L)
	. = ..()
	handle_sip(L)

/datum/reagent/magic/recall/on_merge(data, amount)
	. = ..()
	if(holder && isliving(holder.my_atom))
		handle_sip(holder.my_atom)

/datum/reagent/magic/recall/proc/handle_sip(mob/living/L)
	if(!istype(L))
		return

	var/mob_key = "\ref[L]"

	var/last_sip = GLOB.recall_cooldowns[mob_key]
	if(last_sip && (world.time < last_sip + 1 SECONDS))
		return
	GLOB.recall_cooldowns[mob_key] = world.time

	if(!GLOB.recall_anchors[mob_key])
		var/turf/anchor = get_turf(L)
		GLOB.recall_anchors[mob_key] = anchor

		playsound(anchor, 'sound/magic/blink.ogg', 70, TRUE)
		new /obj/effect/temp_visual/small_smoke(anchor)
		to_chat(L, span_boldnotice("A spatial rift imprints beneath your feet! Your presence is anchored to this location."))
		return

	var/turf/destination = GLOB.recall_anchors[mob_key]
	GLOB.recall_anchors -= mob_key

	if(istype(destination))
		to_chat(L, span_userdanger("Space bends violently around you, pulling you back to your anchor!"))
		playsound(get_turf(L), 'sound/magic/teleport_diss.ogg', 80, TRUE)
		new /obj/effect/temp_visual/small_smoke(get_turf(L))

		do_teleport(L, destination, 0, asoundin = 'sound/magic/teleport_diss.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
		new /obj/effect/temp_visual/small_smoke(destination)
	else
		to_chat(L, span_warning("Your spatial anchor has collapsed!"))

/datum/reagent/magic/transmutation
	name = "Beastblood Transmutagen"
	description = "A chaotic, primordial brew smelling of wild musk and raw untamed fury. Realigns mortal bone and humours into the form of a beast for 5 minutes."
	color = "#5d4037"
	taste_description = "raw game and wild pine"
	metabolization_rate = REAGENTS_METABOLISM * 0.1

/datum/reagent/magic/transmutation/on_mob_metabolize(mob/living/L)
	. = ..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	if(istype(H, /mob/living/carbon/human/species/wildshape))
		to_chat(H, span_warning("Your beastly flesh rejects further metamorphosis!"))
		return

	var/list/shapes = list(
		"bear",
		"volf",
		"fox",
		"cat",
		"cabbit",
		"saiga",
		"spider"
	)

	var/picked_name = pick(shapes)
	var/target_shape = GLOB.wildshapes[picked_name]

	if(!target_shape)
		var/list/fallback_shapes = list(
			/mob/living/carbon/human/species/wildshape/bear,
			/mob/living/carbon/human/species/wildshape/volf,
			/mob/living/carbon/human/species/wildshape/fox,
			/mob/living/carbon/human/species/wildshape/cat,
			/mob/living/carbon/human/species/wildshape/cabbit,
			/mob/living/carbon/human/species/wildshape/saiga,
			/mob/living/carbon/human/species/wildshape/spider
		)
		target_shape = pick(fallback_shapes)

	to_chat(H, span_userdanger("Your skeleton twists and warps violently! You are becoming a beast!"))
	playsound(H.loc, 'sound/magic/charged.ogg', 80, TRUE)
	H.Stun(20)
	H.Knockdown(20)

	var/datum/mind/player_mind = H.mind
	INVOKE_ASYNC(H, TYPE_PROC_REF(/mob/living/carbon/human, wildshape_transformation), target_shape)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(revert_transmutation_by_mind), player_mind), 5 MINUTES)

/proc/revert_transmutation_by_mind(datum/mind/M)
	if(!M || QDELETED(M))
		return
	var/mob/living/carbon/human/current_mob = M.current
	if(!current_mob || QDELETED(current_mob))
		return
	if(current_mob.stat == DEAD)
		return
	if(istype(current_mob, /mob/living/carbon/human/species/wildshape))
		to_chat(current_mob, span_notice("The wild animal humours leave your blood. You return to your mortal shell!"))
		current_mob.wildshape_untransform()

/datum/reagent/magic/mimicry
	name = "Mirage Draught"
	description = "A pearlescent, liquid mirror. Once consumed, inspecting another person binds their visage into your mind. Within 30 seconds your flesh remolds into their exact replica for 10 minutes."
	color = "#e0f7fa"
	taste_description = "tasteless cold liquid mercury"
	metabolization_rate = REAGENTS_METABOLISM * 0.1

/datum/reagent/magic/mimicry/on_mob_metabolize(mob/living/L)
	. = ..()
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	H.apply_status_effect(/datum/status_effect/buff/mimicry_primed)
	to_chat(H, span_notice("A cold numbness spreads across your face. Inspect someone to capture their identity!"))

/datum/status_effect/buff/mimicry_primed
	id = "mimicry_primed"
	duration = 5 MINUTES

/datum/status_effect/buff/mimicry_primed/proc/trigger_mimicry(mob/living/carbon/human/target_human)
	if(!ishuman(target_human) || target_human == owner || target_human.stat == DEAD)
		return FALSE

	to_chat(owner, span_boldnotice("You engrave the visage of [target_human.real_name] deep into your memory! In 30 seconds your body will shift!"))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(execute_mimicry_shift), WEAKREF(owner), WEAKREF(target_human)), 30 SECONDS)
	qdel(src)
	return TRUE

/mob/living/carbon/human/on_examine_face(mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user))
		var/datum/status_effect/buff/mimicry_primed/M = user.has_status_effect(/datum/status_effect/buff/mimicry_primed)
		if(M)
			M.trigger_mimicry(src)

/proc/execute_mimicry_shift(datum/weakref/user_ref, datum/weakref/target_ref)
	var/mob/living/carbon/human/user = user_ref?.resolve()
	var/mob/living/carbon/human/target = target_ref?.resolve()

	if(!user || QDELETED(user) || !target || QDELETED(target))
		return

	var/list/backup = list(
		"real_name"          = user.real_name,
		"name"               = user.name,
		"age"                = user.age,
		"gender"             = user.gender,
		"pronouns"           = user.pronouns,
		"skin_tone"          = user.skin_tone,
		"hair_color"         = user.hair_color,
		"hairstyle"          = user.hairstyle,
		"facial_hair_color"  = user.facial_hair_color,
		"facial_hairstyle"   = user.facial_hairstyle,
		"eye_color"          = user.eye_color,
		"highlight_color"    = user.highlight_color,
		"detail_color"       = user.detail_color,
		"voice_color"        = user.voice_color,
		"voice_pitch"        = user.voice_pitch,
		"voice_type"         = user.voice_type,
		"origin"             = user.origin,
		"dna_features"       = user.dna.features.Copy(),
		"species_type"       = user.dna.species.type,
		"job"                = user.job,
		"advjob"             = user.advjob,
		"migrant_type"       = user.migrant_type,
		"social_rank"        = user.social_rank,
		"assigned_role"      = user.mind ? user.mind.assigned_role : user.job,
		"cosmetic_title"     = user.mind ? user.mind.cosmetic_class_title : null
	)

	target.dna.transfer_identity(user)
	user.real_name = target.real_name
	user.name = target.real_name
	user.nickname = target.nickname
	user.pronouns = target.pronouns
	user.gender = target.gender
	user.age = target.age
	user.skin_tone = target.skin_tone
	user.hair_color = target.hair_color
	user.hairstyle = target.hairstyle
	user.facial_hair_color = target.facial_hair_color
	user.facial_hairstyle = target.facial_hairstyle
	user.eye_color = target.eye_color
	user.highlight_color = target.highlight_color
	user.detail_color = target.detail_color
	user.voice_color = target.voice_color
	user.voice_pitch = target.voice_pitch
	user.voice_type = target.voice_type
	user.origin = target.origin
	user.job = target.job
	user.advjob = target.advjob
	user.migrant_type = target.migrant_type
	user.social_rank = target.social_rank

	if(user.mind && target.mind)
		user.mind.assigned_role = target.mind.assigned_role
		user.mind.cosmetic_class_title = target.mind.cosmetic_class_title

	if(user.dna.species.type != target.dna.species.type)
		user.set_species(target.dna.species.type)

	user.body_overlay_cache_key = null
	user.damage_overlay_cache_key = null
	user.icon_render_key = null

	user.regenerate_icons()
	user.update_body()
	user.update_hair()
	user.update_body_parts(TRUE)

	user.visible_message(
		span_warning("[user]'s flesh suddenly ripples like water, molding into the exact double of [target.real_name]!"),
		span_userdanger("Your face, body, and vocal cords remold! You have assumed the identity of [target.real_name] for 10 minutes!")
	)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(revert_mimicry_shift), WEAKREF(user), backup), 10 MINUTES)


/proc/revert_mimicry_shift(datum/weakref/user_ref, list/backup)
	var/mob/living/carbon/human/user = user_ref?.resolve()
	if(!user || QDELETED(user) || !islist(backup))
		return

	if(user.dna.species.type != backup["species_type"])
		user.set_species(backup["species_type"])

	user.real_name = backup["real_name"]
	user.name = backup["name"]
	user.age = backup["age"]
	user.gender = backup["gender"]
	user.pronouns = backup["pronouns"]
	user.skin_tone = backup["skin_tone"]
	user.hair_color = backup["hair_color"]
	user.hairstyle = backup["hairstyle"]
	user.facial_hair_color = backup["facial_hair_color"]
	user.facial_hairstyle = backup["facial_hairstyle"]
	user.eye_color = backup["eye_color"]
	user.highlight_color = backup["highlight_color"]
	user.detail_color = backup["detail_color"]
	user.voice_color = backup["voice_color"]
	user.voice_pitch = backup["voice_pitch"]
	user.voice_type = backup["voice_type"]
	user.origin = backup["origin"]
	user.job = backup["job"]
	user.advjob = backup["advjob"]
	user.migrant_type = backup["migrant_type"]
	user.social_rank = backup["social_rank"]

	if(user.mind)
		user.mind.assigned_role = backup["assigned_role"]
		user.mind.cosmetic_class_title = backup["cosmetic_title"]

	if(backup["dna_features"])
		var/list/cached_features = backup["dna_features"]
		user.dna.features = cached_features.Copy()

	user.body_overlay_cache_key = null
	user.damage_overlay_cache_key = null
	user.icon_render_key = null

	user.regenerate_icons()
	user.update_body()
	user.update_hair()
	user.update_body_parts(TRUE)

	user.visible_message(
		span_warning("The mirage breaks! [user]'s features dissolve back into their true self!"),
		span_notice("The mimicry draught expires. Your true identity returns.")
	)
	playsound(user.loc, 'sound/items/firesnuff.ogg', 60, TRUE)

/datum/status_effect/buff/alch/mythic_str
	id = "mythic_str"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/strengthpot
	effectedstats = list(STATKEY_STR = 5)


/datum/status_effect/buff/alch/mythic_con
	id = "mythic_con"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/constitutionpot
	effectedstats = list(STATKEY_CON = 5)


/datum/status_effect/buff/alch/mythic_spd
	id = "mythic_spd"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/speedpot
	effectedstats = list(STATKEY_SPD = 5)


/datum/status_effect/buff/alch/mythic_per
	id = "mythic_per"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/perceptionpot
	effectedstats = list(STATKEY_PER = 5)


/datum/status_effect/buff/alch/mythic_int
	id = "mythic_int"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/intelligencepot
	effectedstats = list(STATKEY_INT = 5)


/datum/status_effect/buff/alch/mythic_lck
	id = "mythic_lck"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/fortunepot
	effectedstats = list(STATKEY_LCK = 5)


/datum/status_effect/buff/alch/mythic_max_int
	id = "mythic_max_int"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/intelligencepot
	effectedstats = list(STATKEY_INT = 10)


/datum/status_effect/buff/alch/mythic_max_lck
	id = "mythic_max_lck"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/fortunepot
	effectedstats = list(STATKEY_LCK = 10)

/datum/status_effect/buff/alch/fire_resist/mythic
	id = "mythic_fire_resist"

/client/verb/debug_spawn_mythic_potion()
	set name = "Spawn Mythic Potion"
	set category = "Debug"
	set desc = "Spawns a vial containing a mythic potion of chosen potency tier."

	if(!holder || !check_rights(R_ADMIN|R_DEBUG))
		to_chat(usr, span_warning("You do not have permission to use this."))
		return

	var/list/potion_choices = list(
		"Elixir of Life III (Health)"          = /datum/reagent/medicine/mythic/health,
		"Archon's Surge III (Mana)"            = /datum/reagent/medicine/mythic/mana,
		"Endless Wind III (Stamina)"           = /datum/reagent/medicine/mythic/stamina,
		"Pestra's Cleansing III (Antidote)"    = /datum/reagent/medicine/mythic/antidote,
		"Titan's Might III (Strength)"         = /datum/reagent/medicine/mythic/strength,
		"Phantom Celerity III (Speed)"         = /datum/reagent/medicine/mythic/speed,
		"Adamantine Flesh III (Constitution)"  = /datum/reagent/medicine/mythic/constitution,
		"All-Seeing Eye III (Perception)"      = /datum/reagent/medicine/mythic/perception,
		"Arcane Omniscience III (Intelligence)"= /datum/reagent/medicine/mythic/intelligence,
		"Fortune's Chosen III (Fortune)"       = /datum/reagent/medicine/mythic/fortune,
		"Infernal Sovereign III (Fire Resist)" = /datum/reagent/medicine/mythic/fire_resist,
		"Venom of the Void III (Poison)"       = /datum/reagent/medicine/mythic/strong_poison,
		"Chronowarp Tincture (Recall)"         = /datum/reagent/magic/recall,
		"Beastblood Transmutagen (Wildshape)"  = /datum/reagent/magic/transmutation,
		"Mirage Draught (Mimicry)"             = /datum/reagent/magic/mimicry
	)

	var/chosen_name = input(usr, "Select a potion to spawn:", "Mythic Alchemy Spawner") as null|anything in potion_choices
	if(!chosen_name)
		return

	var/reagent_type = potion_choices[chosen_name]

	var/chosen_tier = input(usr, "Select Potency Tier (1 - 3):", "Potion Tier", 3) as null|num
	if(!chosen_tier)
		return
	chosen_tier = CLAMP(round(chosen_tier), 1, 3)
	var/amount = input(usr, "Enter volume (drams):", "Potion Volume", 30) as null|num

	if(!amount || amount <= 0)
		return

	var/obj/item/reagent_containers/glass/bottle/bottle = new /obj/item/reagent_containers/glass/bottle(get_turf(usr))
	bottle.name = "vial of [chosen_name] (Tier [chosen_tier])"
	bottle.desc = "An alchemical vial shimmering with condensed arcana."

	var/list/reagent_data = list("potency_tier" = chosen_tier)
	bottle.reagents.add_reagent(reagent_type, amount, reagent_data)

	var/datum/reagent/medicine/mythic/M = bottle.reagents.get_reagent(reagent_type)
	if(istype(M))
		M.potency_tier = chosen_tier
		if(!islist(M.data))
			M.data = list()
		M.data["potency_tier"] = chosen_tier

	if(!usr.put_in_hands(bottle))
		bottle.forceMove(get_turf(usr))
		to_chat(usr, span_notice("Spawned [bottle.name] at your feet."))
	else
		to_chat(usr, span_notice("Spawned [bottle.name] in your hands."))

	log_admin("[key_name(usr)] spawned [chosen_name] (Tier [chosen_tier], [amount]u).")
