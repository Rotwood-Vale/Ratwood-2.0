// KCD-Style Intermediate Reagents
// These are created when boiling herbs with base reagents
// They carry the herb's alchemy effects and can be mixed to create potions

// Base template for herb extracts
/datum/reagent/herb_extract
	description = "An extract made from boiling herbs."
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_METABOLISM
	var/source_herb_name = ""
	var/source_herb_type = null

// Dynamic on_mob_life that applies effects based on alchemy_effects list
/datum/reagent/herb_extract/on_mob_life(mob/living/carbon/M)
	if(!alchemy_effects || !alchemy_effects.len)
		..()
		return
	
	// Apply each effect
	for(var/effect in alchemy_effects)
		if(volume > 0.99)
			switch(effect)
				// Healing Effects
				if(EFFECT_HEAL_BRUTE)
					M.adjustBruteLoss(-0.5*REM, 0)
					if(prob(5))
						M.visible_message(span_notice("[M]'s wounds begin to close."), span_notice(pick("My cuts start to seal.", "I feel my bruises fading.", "The pain in my body lessens.", "My wounds knit together.", "I feel my flesh mending.")))
				if(EFFECT_HEAL_BURN)
					M.adjustFireLoss(-0.5*REM, 0)
					if(prob(5))
						M.visible_message(span_notice("[M]'s burns seem to fade."), span_notice(pick("The burning sensation subsides.", "My scorched skin cools.", "I feel relief from the burns.", "The seared flesh begins to heal.", "The fire's touch fades from my skin.")))
				if(EFFECT_HEAL_TOX)
					M.adjustToxLoss(-0.5*REM, 0)
					if(prob(5))
						to_chat(M, span_notice(pick("I feel the toxins purging from my body.", "The sickness begins to fade.", "My body feels cleansed.", "The poison's grip weakens.", "I feel purity returning to my blood.")))
				if(EFFECT_RESTORE_BLOOD)
					if(M.blood_volume < BLOOD_VOLUME_NORMAL)
						if(prob(5))
							M.blood_volume = min(M.blood_volume+5, BLOOD_VOLUME_NORMAL)
							to_chat(M, span_notice(pick("I feel warmth returning to my limbs.", "My heartbeat grows stronger.", "Vitality flows through my veins.", "Color returns to my vision.", "I feel my lifeblood replenishing.")))
				if(EFFECT_RESTORE_STAMINA)
					M.stamina_add(-5)
					if(prob(5))
						to_chat(M, span_notice(pick("I feel refreshed.", "Energy surges through me.", "My weariness fades.", "Vigor returns to my muscles.", "I feel rejuvenated.")))
				if(EFFECT_RESTORE_MANA)
					M.energy_add(5)
					if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
						M.energy_add(5)
						if(prob(5))
							to_chat(M, span_notice(pick("Arcane energy fills me.", "I feel my power returning.", "The wellspring of magic replenishes.", "Mystical force flows within me.", "My essence is restored.")))
				if(EFFECT_RESTORE_DEVOTION)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.devotion)
							var/datum/devotion/D = H.devotion
							if(prob(5))
								D.update_devotion(15, 0)
								to_chat(M, span_notice(pick("I feel the gods' favor.", "Divine grace touches me.", "My faith strengthens.", "Holy warmth fills my soul.", "The Ten smile upon me.")))
				
				// Damaging Effects
				if(EFFECT_DAMAGE_BRUTE)
					if(prob(5))
						M.adjustBruteLoss(0.5*REM, 0)
						M.visible_message(span_warning("[M] winces in pain."), span_warning(pick("Sharp pain lances through my body!", "My flesh tears and aches!", "I feel my body breaking down!", "Agony courses through me!", "My bones ache terribly!")))
				if(EFFECT_DAMAGE_BURN)
					if(prob(5))
						M.adjustFireLoss(0.5*REM, 0)
						M.visible_message(span_warning("[M]'s skin reddens and blisters."), span_warning(pick("My skin burns like fire!", "Searing pain engulfs me!", "I feel like I'm burning alive!", "My flesh scorches from within!", "Unbearable heat tears through me!")))
				if(EFFECT_DAMAGE_TOX)
					if(prob(5))
						M.adjustToxLoss(0.5*REM, 0)
						to_chat(M, span_warning(pick("Poison courses through my veins!", "I feel deathly ill!", "Toxins ravage my body!", "Nausea overwhelms me!", "My blood feels like acid!")))
				if(EFFECT_DRAIN_BLOOD)
					if(prob(5))
						M.blood_volume = max(M.blood_volume-5, 0)
						M.visible_message(span_warning("Blood drips from [M]'s nose."), span_warning(pick("Blood drips from my eyes!", "I taste copper in my mouth!", "My lifeblood seeps away!", "I feel my vitality draining!", "Darkness creeps at the edges of my vision!")))
				if(EFFECT_DRAIN_STAMINA)
					if(prob(5))
						M.stamina_add(5)
						to_chat(M, span_warning(pick("Exhaustion weighs upon me.", "My limbs grow heavy.", "Weariness overtakes me.", "I can barely move.", "Fatigue drags me down.")))
				if(EFFECT_DRAIN_MANA)
					if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
						if(prob(5))
							M.energy_add(-5)
							to_chat(M, span_warning(pick("My arcane reserves dwindle!", "I feel my power fading!", "The wellspring runs dry!", "Magic slips from my grasp!", "My essence depletes!")))
				if(EFFECT_DRAIN_DEVOTION)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.devotion)
							var/datum/devotion/D = H.devotion
							if(prob(5))
								D.update_devotion(-15, 0)
								to_chat(M, span_warning(pick("I feel distant from the gods.", "Divine grace abandons me.", "My faith wavers.", "The gods turn away.", "Holy light fades from my soul.")))
				
				// Stat Buffs
				if(EFFECT_FORTIFY_STRENGTH)
					M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot)
				if(EFFECT_FORTIFY_PERCEPTION)
					M.apply_status_effect(/datum/status_effect/buff/alch/perceptionpot)
				if(EFFECT_FORTIFY_INTELLIGENCE)
					M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot)
				if(EFFECT_FORTIFY_CONSTITUTION)
					M.apply_status_effect(/datum/status_effect/buff/alch/constitutionpot)
				if(EFFECT_FORTIFY_ENDURANCE)
					M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot)
				if(EFFECT_FORTIFY_SPEED)
					M.apply_status_effect(/datum/status_effect/buff/alch/speedpot)
				if(EFFECT_FORTIFY_LUCK)
					M.apply_status_effect(/datum/status_effect/buff/alch/fortunepot)
				if(EFFECT_WEAKEN_STRENGTH)
					M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot/negative)
				if(EFFECT_WEAKEN_PERCEPTION)
					M.apply_status_effect(/datum/status_effect/buff/alch/perceptionpot/negative)
				if(EFFECT_WEAKEN_INTELLIGENCE)
					M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot/negative)
				if(EFFECT_WEAKEN_CONSTITUTION)
					M.apply_status_effect(/datum/status_effect/buff/alch/constitutionpot/negative)
				if(EFFECT_WEAKEN_ENDURANCE)
					M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot/negative)
				if(EFFECT_WEAKEN_SPEED)
					M.apply_status_effect(/datum/status_effect/buff/alch/speedpot/negative)
				if(EFFECT_WEAKEN_LUCK)
					M.apply_status_effect(/datum/status_effect/buff/alch/fortunepot/negative)
							
				// Status Effects
				if(EFFECT_BLINDNESS)
					if(prob(5))
						M.adjust_blindness(2)
						M.visible_message(span_warning("[M] squints and rubs [M.p_their()] eyes."), span_warning(pick("Darkness clouds my vision!", "I can barely see!", "My eyes burn and blur!", "Everything fades to black!", "I'm going blind!")))
				if(EFFECT_SILENCE)
					if(!HAS_TRAIT(M, TRAIT_MUTE))
						ADD_TRAIT(M, TRAIT_MUTE, "alchemy_effect")
						M.visible_message(span_warning("[M] clutches [M.p_their()] throat."), span_warning(pick("My voice is stolen!", "I cannot speak!", "Words die in my throat!", "Silence grips me!", "My tongue won't move!")))
				if(EFFECT_DEAFEN)
					if(!HAS_TRAIT(M, TRAIT_DEAF))
						ADD_TRAIT(M, TRAIT_DEAF, "alchemy_effect")
						to_chat(M, span_warning(pick("Everything goes silent!", "I cannot hear!", "My ears ring with emptiness!", "Sound fades away!", "Deafness overtakes me!")))
				if(EFFECT_NO_PAIN)
					if(!HAS_TRAIT(M, TRAIT_NOPAIN))
						ADD_TRAIT(M, TRAIT_NOPAIN, "alchemy_effect")
						to_chat(M, span_notice(pick("Pain fades away.", "I feel nothing.", "My body grows numb.", "Sensation dulls.", "I am beyond suffering.")))
				if(EFFECT_WEAKNESS)
					if(!HAS_TRAIT(M, TRAIT_CRITICAL_WEAKNESS))
						ADD_TRAIT(M, TRAIT_CRITICAL_WEAKNESS, "alchemy_effect")
						to_chat(M, span_warning(pick("My strength fails me.", "I feel utterly weak.", "All power leaves my body.", "I can barely move.", "Weakness overcomes me.")))
				if(EFFECT_INVISIBILITY)
					.= 0 // no-op
				if(EFFECT_NAUSEA)
					if(prob(5))
						M.add_nausea(3)
						M.visible_message(span_warning("[M] looks ill."), span_warning(pick("My stomach churns violently!", "I feel like I might vomit!", "Nausea grips my gut!", "Bile rises in my throat!", "My insides revolt!")))
				if(EFFECT_HALLUCINOGENIC)
					if(prob(10))
						M.emote(pick("giggle", "drools", "grins", "fidgets", "twitch_s"))
					if(prob(5))
						M.hallucination = max(M.hallucination, 10)
						to_chat(M, span_warning(pick("The walls breathe and shift!", "Colors dance before my eyes!", "Reality warps around me!", "I see things that aren't there!", "The world melts and reforms!")))
				if(EFFECT_SLEEP)
					if(prob(20))
						M.Sleeping(30)
						M.visible_message(span_warning("[M]'s eyes grow heavy."), span_warning(pick("I can barely keep my eyes open...", "Sleep calls to me...", "Drowsiness overtakes me...", "My eyelids grow so heavy...", "I feel myself drifting off...")))
				
				// Resistance Effects
				if(EFFECT_MAGIC_RESIST)
					if(!HAS_TRAIT(M, TRAIT_ANTIMAGIC))
						ADD_TRAIT(M, TRAIT_ANTIMAGIC, "alchemy_effect")
						to_chat(M, span_notice(pick("I feel protected from magic!", "Arcane forces cannot touch me!", "Magic seems to falter around me!", "I resist mystical energies!", "Spellcraft has less effect on me!")))
				if(EFFECT_CRIT_RESIST)
					if(!HAS_TRAIT(M, TRAIT_CRITICAL_RESISTANCE))
						ADD_TRAIT(M, TRAIT_CRITICAL_RESISTANCE, "alchemy_effect")
						if(prob(5))
							to_chat(M, span_notice(pick("My constitution hardens.", "I feel fortified against mortal wounds.", "My body resists grievous injury.", "Resilience flows through me.", "I become harder to kill.")))
				if(EFFECT_FEATHER_FALL)
					if(!HAS_TRAIT(M, TRAIT_NOFALLDAMAGE1))
						ADD_TRAIT(M, TRAIT_NOFALLDAMAGE1, "alchemy_effect")
						to_chat(M, span_notice(pick("I can fall from great heights unharmed!", "No fall can hurt me now!", "I am immune to fall damage!", "The ground means nothing to me!", "I can descend from heights safely!")))
				if(EFFECT_FIRE_IMMUNE)
					M.apply_status_effect(/datum/status_effect/buff/alch/fire_resist)
					if(prob(5))
						to_chat(M, span_notice(pick("Heat no longer touches me.", "Flames cannot harm me.", "I am impervious to fire.", "The inferno means nothing.", "Fire washes over me harmlessly.")))
				if(EFFECT_FROST_IMMUNE)
					if(!HAS_TRAIT(M, TRAIT_RESISTCOLD))
						ADD_TRAIT(M, TRAIT_RESISTCOLD, "alchemy_effect")
						to_chat(M, span_notice(pick("Cold cannot touch me.", "I am immune to frost.", "I resist the chill.", "Ice means nothing to me.", "The cold washes over me harmlessly.")))
				if(EFFECT_ELECTRIC_IMMUNE)
					if(!HAS_TRAIT(M, TRAIT_SHOCKIMMUNE))
						ADD_TRAIT(M, TRAIT_SHOCKIMMUNE, "alchemy_effect")
						to_chat(M, span_notice(pick("I am immune to electricity.", "Shocks cannot harm me.", "I feel insulated from lightning.", "Electricity flows harmlessly through me.", "I resist all electric damage.")))
				
				// Elemental Effects
				if(EFFECT_FIRE_STACKS)
					if(prob(10))
						M.adjust_fire_stacks(2)
						M.ignite_mob()
						M.visible_message(span_danger("[M] bursts into flames!"), span_danger(pick("I'm burning!", "Fire consumes me!", "Flames engulf my body!", "I'm on fire!", "The heat is unbearable!")))
				if(EFFECT_FROST_STACKS)
					if(prob(5))
						//apply_frost_stacks(M)
						M.visible_message(span_warning("[M] shivers violently."), span_warning(pick("Cold seeps into my bones!", "I'm freezing!", "Frost crawls across my skin!", "The chill is unbearable!", "Ice forms on my flesh!")))
				if(EFFECT_SHOCK_DAMAGE)
					if(prob(10))
						M.electrocute_act(5, src)
						M.visible_message(span_warning("[M] convulses with electricity!"), span_warning(pick("Lightning courses through me!", "Electric shock tears through my body!", "I'm being electrocuted!", "Sparks dance across my skin!", "The current is agony!")))						

				// Greater Healing Effects (stronger versions)
				if(EFFECT_GREATER_HEAL_BRUTE)
					M.adjustBruteLoss(-2*REM, 0)
					if(prob(5))
						M.visible_message(span_notice("[M]'s wounds rapidly close."), span_notice(pick("My wounds seal with incredible speed!", "I feel my body mending rapidly!", "Flesh knits together before my eyes!", "The pain vanishes as I heal!", "My injuries close completely!")))
				if(EFFECT_GREATER_HEAL_BURN)
					M.adjustFireLoss(-2*REM, 0)
					if(prob(5))
						M.visible_message(span_notice("[M]'s burns vanish."), span_notice(pick("The burns fade away completely!", "My skin regenerates before my eyes!", "Scorched flesh becomes whole again!", "The fire damage undoes itself!", "I heal from the burns entirely!")))
				if(EFFECT_GREATER_HEAL_TOX)
					M.adjustToxLoss(-2*REM, 0)
					if(prob(5))
						to_chat(M, span_notice(pick("Toxins are purged completely from my body!", "Perfect cleansing washes through me!", "All poison is expelled!", "My blood runs pure and clean!", "The sickness is utterly destroyed!")))
				if(EFFECT_GREATER_RESTORE_BLOOD)
					if(M.blood_volume < BLOOD_VOLUME_NORMAL)
						if(prob(5))
							M.blood_volume = min(M.blood_volume+15, BLOOD_VOLUME_NORMAL)
							M.visible_message(span_notice("[M] looks revitalized."), span_notice(pick("Lifeblood surges through me!", "I feel overwhelmingly alive!", "Vitality floods my being!", "My heart pounds with renewed vigor!", "Blood fills my veins with power!")))
				if(EFFECT_GREATER_RESTORE_STAMINA)
					M.stamina_add(-20)
					if(prob(5))
						to_chat(M, span_notice(pick("Incredible energy fills me!", "I could run forever!", "Boundless vigor courses through me!", "All weariness vanishes!", "I feel unstoppable!")))
				if(EFFECT_GREATER_RESTORE_MANA)
					if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
						M.energy_add(20)
						if(prob(5))
							to_chat(M, span_notice(pick("Raw arcane power floods into me!", "The wellspring overflows!", "Magic surges through my being!", "I am brimming with mystical energy!", "Power beyond measure fills me!")))
				if(EFFECT_GREATER_RESTORE_DEVOTION)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.devotion)
							var/datum/devotion/D = H.devotion
							if(prob(5))
								D.update_devotion(30, 0)
								to_chat(M, span_notice(pick("The gods embrace me fully!", "Divine radiance fills my soul!", "I am bathed in holy light!", "The Ten grant me their blessing!", "Sacred power courses through me!")))
				
				// Greater Damaging Effects
				if(EFFECT_GREATER_DAMAGE_BRUTE)
					M.adjustBruteLoss(2*REM, 0)
					if(prob(5))
						M.visible_message(span_danger("[M] cries out in extreme pain!"), span_danger(pick("Excruciating pain rips through me!", "My body tears itself apart!", "Agony like nothing before!", "I'm being ripped to shreds!", "Unbearable torment consumes me!")))
				if(EFFECT_GREATER_DAMAGE_BURN)
					M.adjustFireLoss(2*REM, 0)
					if(prob(5))
						M.visible_message(span_danger("[M]'s flesh sizzles and smokes!"), span_danger(pick("I'm burning from the inside out!", "My flesh melts from my bones!", "The heat is beyond endurance!", "Fire devours me completely!", "I'm being incinerated alive!")))
				if(EFFECT_GREATER_DAMAGE_TOX)
					M.adjustToxLoss(2*REM, 0)
					if(prob(5))
						M.visible_message(span_danger("Blood streams from [M]'s orifices!"), span_danger(pick("Deadly poison ravages my body!", "I can feel myself dying!", "Toxins destroy me from within!", "My blood turns to acid!", "Death's grip tightens!")))
				if(EFFECT_GREATER_DRAIN_BLOOD)
					M.blood_volume = max(M.blood_volume-15, 0)
					if(prob(5))
						M.visible_message(span_danger("Blood pours from [M]'s eyes and nose!"), span_danger(pick("My lifeblood hemorrhages away!", "I'm bleeding out from everywhere!", "Blood gushes from my body!", "My life drains away rapidly!", "I feel death approaching!")))
				if(EFFECT_GREATER_DRAIN_STAMINA)
					M.stamina_add(20)
					if(prob(5))
						M.visible_message(span_warning("[M] collapses from exhaustion."), span_warning(pick("All strength leaves my body!", "I can't move anymore!", "Complete exhaustion overwhelms me!", "My body refuses to respond!", "I'm utterly drained!")))
				if(EFFECT_GREATER_DRAIN_MANA)
					if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
						M.energy_add(-20)
						if(prob(5))
							to_chat(M, span_danger(pick("My power is completely drained!", "All magic leaves me!", "The wellspring goes completely dry!", "I am bereft of mystical energy!", "My essence is utterly depleted!")))
				if(EFFECT_GREATER_DRAIN_DEVOTION)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.devotion)
							var/datum/devotion/D = H.devotion
							if(prob(5))
								D.update_devotion(-30, 0)
								to_chat(M, span_danger(pick("The gods utterly forsake me!", "Divine light abandons me completely!", "I am cast from grace!", "Holy power flees from me!", "The Ten turn their backs!")))
				

				// Greater Stat Buffs
				if(EFFECT_GREATER_FORTIFY_STRENGTH)
					M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot/greater)
				if(EFFECT_GREATER_FORTIFY_PERCEPTION)
					M.apply_status_effect(/datum/status_effect/buff/alch/perceptionpot/greater)
				if(EFFECT_GREATER_FORTIFY_INTELLIGENCE)
					M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot/greater)
				if(EFFECT_GREATER_FORTIFY_CONSTITUTION)
					M.apply_status_effect(/datum/status_effect/buff/alch/constitutionpot/greater)
				if(EFFECT_GREATER_FORTIFY_ENDURANCE)
					M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot/greater)
				if(EFFECT_GREATER_FORTIFY_SPEED)
					M.apply_status_effect(/datum/status_effect/buff/alch/speedpot/greater)
				if(EFFECT_GREATER_FORTIFY_LUCK)
					M.apply_status_effect(/datum/status_effect/buff/alch/fortunepot/greater)
				if(EFFECT_GREATER_WEAKEN_STRENGTH)
					M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot/greater/negative)
				if(EFFECT_GREATER_WEAKEN_PERCEPTION)
					M.apply_status_effect(/datum/status_effect/buff/alch/perceptionpot/greater/negative)
				if(EFFECT_GREATER_WEAKEN_INTELLIGENCE)
					M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot/greater/negative)
				if(EFFECT_GREATER_WEAKEN_CONSTITUTION)
					M.apply_status_effect(/datum/status_effect/buff/alch/constitutionpot/greater/negative)
				if(EFFECT_GREATER_WEAKEN_ENDURANCE)
					M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot/greater/negative)
				if(EFFECT_GREATER_WEAKEN_SPEED)
					M.apply_status_effect(/datum/status_effect/buff/alch/speedpot/greater/negative)
				if(EFFECT_GREATER_WEAKEN_LUCK)
					M.apply_status_effect(/datum/status_effect/buff/alch/fortunepot/greater/negative)

				// Greater Status Effects (stronger/longer versions)
				if(EFFECT_GREATER_BLINDNESS)
					if(prob(5))
						M.adjust_blindness(5)
						M.visible_message(span_danger("[M] screams and covers [M.p_their()] eyes!"), span_danger(pick("Total darkness consumes me!", "I'm completely blind!", "All light is extinguished!", "My eyes see only void!", "Blindness takes me utterly!")))
				if(EFFECT_GREATER_SILENCE)
					if(!HAS_TRAIT(M, TRAIT_MUTE))
						ADD_TRAIT(M, TRAIT_MUTE, "alchemy_effect_greater")
						M.visible_message(span_danger("[M] grasps desperately at [M.p_their()] throat!"), span_danger(pick("My voice is completely stolen!", "I cannot make a sound!", "Utter silence grips my throat!", "All speech is impossible!", "I am rendered completely mute!")))
				if(EFFECT_GREATER_DEAFEN)
					if(!HAS_TRAIT(M, TRAIT_DEAF))
						ADD_TRAIT(M, TRAIT_DEAF, "alchemy_effect_greater")
						to_chat(M, span_danger(pick("Complete silence descends!", "All sound ceases to exist!", "Total deafness overtakes me!", "I hear absolutely nothing!", "The world goes utterly silent!")))
				if(EFFECT_GREATER_NO_PAIN)
					if(!HAS_TRAIT(M, TRAIT_NOPAIN))
						ADD_TRAIT(M, TRAIT_NOPAIN, "alchemy_effect_greater")
						to_chat(M, span_notice(pick("All sensation leaves my body.", "I am completely numb.", "Pain is utterly meaningless.", "I feel absolutely nothing.", "My body is beyond all suffering.")))
				if(EFFECT_GREATER_WEAKNESS)
					if(!HAS_TRAIT(M, TRAIT_CRITICAL_WEAKNESS))
						ADD_TRAIT(M, TRAIT_CRITICAL_WEAKNESS, "alchemy_effect")
						to_chat(M, span_danger(pick("My body fails me utterly.", "I am completely weak.", "All strength abandons me.", "I can do nothing at all.", "Utter weakness overcomes me.")))
				if(EFFECT_GREATER_INVISIBILITY)
					.= 0 // no-op
				if(EFFECT_GREATER_NAUSEA)
					if(prob(5))
						M.add_nausea(6)
						M.visible_message(span_danger("[M] retches violently!"), span_danger(pick("Overwhelming nausea grips me!", "I'm going to vomit!", "My stomach revolts completely!", "Bile floods my throat!", "I can't stop retching!")))
				if(EFFECT_GREATER_HALLUCINOGENIC)
					if(prob(20))
						M.emote(pick("giggle", "drools", "grins", "fidgets", "twitch_s"))
					if(prob(5))
						M.hallucination = max(M.hallucination, 20)
						to_chat(M, span_danger(pick("Reality tears itself apart!", "Nothing is real anymore!", "The world dissolves into madness!", "I see impossible things everywhere!", "Everything transforms and writhes!")))
				if(EFFECT_GREATER_SLEEP)
					if(prob(20))
						M.Sleeping(60)
						M.visible_message(span_danger("[M] falls into a deep slumber."), span_danger(pick("I cannot resist sleep...", "Unconsciousness claims me...", "I'm falling into deep sleep...", "My eyes close against my will...", "Sleep takes me completely...")))
				
				// Greater Resistance Effects
				if(EFFECT_GREATER_MAGIC_RESIST)
					if(!HAS_TRAIT(M, TRAIT_ANTIMAGIC))
						ADD_TRAIT(M, TRAIT_ANTIMAGIC, "alchemy_effect")
						to_chat(M, span_notice(pick("I am utterly protected from magic!", "Arcane forces cannot touch me at all!", "Magic fails completely around me!", "I resist all mystical energies!", "Spellcraft has no effect on me!")))	
				if(EFFECT_GREATER_CRIT_RESIST)
					if(!HAS_TRAIT(M, TRAIT_CRITICAL_RESISTANCE))
						ADD_TRAIT(M, TRAIT_CRITICAL_RESISTANCE, "alchemy_effect")
						to_chat(M, span_notice(pick("My body becomes incredibly resilient!", "I am nearly invulnerable to mortal wounds!", "My constitution is like iron!", "Grievous injuries cannot fell me!", "I become extremely hard to kill!")))
				if(EFFECT_GREATER_FEATHER_FALL)
					if(!HAS_TRAIT(M, TRAIT_NOFALLDAMAGE2))
						ADD_TRAIT(M, TRAIT_NOFALLDAMAGE2, "alchemy_effect")
						to_chat(M, span_notice(pick("I can fall from any height unharmed!", "No fall can hurt me now!", "I am immune to all fall damage!", "The ground means nothing to me!", "I can descend from any height safely!")))
				if(EFFECT_GREATER_FIRE_IMMUNE)
					M.apply_status_effect(/datum/status_effect/buff/alch/fire_resist)
					if(prob(5))
						to_chat(M, span_notice(pick("Fire is utterly meaningless to me!", "Flames wash over me like water!", "I am completely impervious to heat!", "The inferno cannot touch me!", "I walk through fire unharmed!")))
				if(EFFECT_GREATER_FROST_IMMUNE)
					if(!HAS_TRAIT(M, TRAIT_RESISTCOLD))
						ADD_TRAIT(M, TRAIT_RESISTCOLD, "alchemy_effect")
						to_chat(M, span_notice(pick("Cold cannot touch me at all!", "I am completely immune to frost!", "I utterly resist the chill!", "Ice has no effect on me!", "The cold washes over me harmlessly.")))
				if(EFFECT_GREATER_ELECTRIC_IMMUNE)
					if(!HAS_TRAIT(M, TRAIT_SHOCKIMMUNE))
						ADD_TRAIT(M, TRAIT_SHOCKIMMUNE, "alchemy_effect")
						to_chat(M, span_notice(pick("I am immune to electricity.", "Shocks cannot harm me.", "I feel insulated from lightning.", "Electricity flows harmlessly through me.", "I resist all electric damage.")))				
				
				// Greater Elemental Effects
				if(EFFECT_GREATER_FIRE_STACKS)
					if(prob(10))
						M.adjust_fire_stacks(4)
						M.ignite_mob()
						M.visible_message(span_danger("[M] bursts into flames!"), span_danger(pick("I'm burning!", "Fire consumes me!", "Flames engulf my body!", "I'm on fire!", "The heat is unbearable!")))
				if(EFFECT_GREATER_FROST_STACKS)
					if(prob(10))
						//apply_frost_stacks(M)
						M.visible_message(span_danger("[M] shivers uncontrollably."), span_danger(pick("Cold pierces my very soul!", "I'm freezing to death!", "Frost devours my flesh!", "The chill is unbearable!", "Ice overtakes me completely!")))	
				if(EFFECT_GREATER_SHOCK_DAMAGE)
					if(prob(15))
						M.electrocute_act(10, src)
						M.visible_message(span_danger("[M] convulses violently with electricity!"), span_danger(pick("Lightning tears through me!", "Electric shock ravages my body!", "I'm being electrocuted severely!", "Sparks erupt from my skin!", "The current is excruciating!")))

	..()
	. = 1

/datum/reagent/herb_extract/on_mob_end_metabolize(mob/living/M)
	if(!alchemy_effects || !alchemy_effects.len)
		. = ..()
		return
	
	// Remove traits based on which effects were present
	for(var/effect in alchemy_effects)
		switch(effect)
			// Status Effects
			if(EFFECT_SILENCE)
				REMOVE_TRAIT(M, TRAIT_MUTE, "alchemy_effect")
			if(EFFECT_DEAFEN)
				REMOVE_TRAIT(M, TRAIT_DEAF, "alchemy_effect")
			if(EFFECT_NO_PAIN)
				REMOVE_TRAIT(M, TRAIT_NOPAIN, "alchemy_effect")
			if(EFFECT_CRIT_RESIST)
				REMOVE_TRAIT(M, TRAIT_CRITICAL_RESISTANCE, "alchemy_effect")
			if(EFFECT_INVISIBILITY)
				M.alpha = 255
			
			// Greater Status Effects
			if(EFFECT_GREATER_SILENCE)
				REMOVE_TRAIT(M, TRAIT_MUTE, "alchemy_effect_greater")
			if(EFFECT_GREATER_DEAFEN)
				REMOVE_TRAIT(M, TRAIT_DEAF, "alchemy_effect_greater")
			if(EFFECT_GREATER_NO_PAIN)
				REMOVE_TRAIT(M, TRAIT_NOPAIN, "alchemy_effect_greater")
			if(EFFECT_GREATER_CRIT_RESIST)
				REMOVE_TRAIT(M, TRAIT_CRITICAL_RESISTANCE, "alchemy_effect_greater")
			if(EFFECT_GREATER_INVISIBILITY)
				M.alpha = 255
	
	. = ..()

// Water
/datum/reagent/herb_extract/tonic
	name = "herbal tonic"
	color = "#6a9295"
	taste_description = "watery herbs"
	alpha = 150

// Oil
/datum/reagent/herb_extract/oil
	name = "herbal oil"
	color = "#d4af37"
	taste_description = "oily herbs"
	alpha = 180

// Wine
/datum/reagent/herb_extract/bitters
	name = "herbal bitters"
	color = "#8a0b0b"
	taste_description = "bitter herbs and wine"
	alpha = 170

// Acid
/datum/reagent/herb_extract/vitriol
	name = "herbal vitriol"
	color = "#5eff00"
	taste_description = "caustic herbs"
	alpha = 160

// Water2
/datum/reagent/herb_extract/syrup
	name = "herbal syrup"
	color = "#4a7a7d"
	taste_description = "sweet herbal syrup"
	alpha = 200

// Oil2
/datum/reagent/herb_extract/paste
	name = "herbal paste"
	color = "#a38728"
	taste_description = "thick herbal paste"
	alpha = 220

// Wine2
/datum/reagent/herb_extract/powder
	name = "herbal powder"
	color = "#6a3a1a"
	taste_description = "powdered herbs"
	alpha = 240
	reagent_state = SOLID

// Acid2
/datum/reagent/herb_extract/salt
	name = "herbal salt"
	color = "#e0e0e0"
	taste_description = "crystalline herbal salt"
	alpha = 250
	reagent_state = SOLID

// Helper proc to create herb extract with copied effects
/proc/create_herb_extract(extract_type, obj/item/ingr, base_amount = 30)
	var/datum/reagent/herb_extract/extract = new extract_type()
	
	// Copy herb name
	if(istype(ingr, /obj/item))
		extract.source_herb_type = ingr.type
		extract.source_herb_name = ingr.name
		extract.name = "[ingr.name] [initial(extract.name)]"
	
	return extract
