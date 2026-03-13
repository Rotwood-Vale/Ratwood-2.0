////////////////////////////////////////////////////////////
//  CURSE DATUM
////////////////////////////////////////////////////////////

/datum/modular_curse
	var/name
	var/expires
	var/flavor
	var/chance
	var/cooldown
	var/last_trigger = 0
	var/trigger
	var/effect
	var/list/effect_args
	var/admin
	var/reason
	var/character_name
	var/mob/owner
	var/list/signals = list()
	var/obj/effect/proc_holder/spell/targeted/shapeshift/shapeshift = new
	var/datum/antagonist/vampire/vampholder
	
/datum/modular_curse/proc/attach_to_mob(mob/M)
	owner = M

	switch(trigger)
		if("on death")
			RegisterSignal(M, COMSIG_MOB_DEATH, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_DEATH
		if("on beheaded")
			RegisterSignal(M, COMSIG_MOB_DECAPPED, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_DECAPPED
		if("on dismembered")
			RegisterSignal(M, COMSIG_MOB_DISMEMBER, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_DISMEMBER
		if("on sleep")
			RegisterSignal(M, COMSIG_LIVING_STATUS_SLEEP, PROC_REF(on_signal_trigger))
			signals += COMSIG_LIVING_STATUS_SLEEP
		if("on attack")
			RegisterSignal(M, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_ATTACK_HAND
			RegisterSignal(M, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_ITEM_ATTACK
			RegisterSignal(M, COMSIG_MOB_ATTACK_RANGED, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_ATTACK_RANGED
		if("on receive damage")
			RegisterSignal(M, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_APPLY_DAMGE
		if("on cast spell")
			RegisterSignal(M, COMSIG_MOB_CAST_SPELL, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_CAST_SPELL
		if("on spell or miracle target")
			RegisterSignal(M, COMSIG_MOB_RECEIVE_MAGIC, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_RECEIVE_MAGIC
		if("on cut tree")
			RegisterSignal(M, COMSIG_MOB_FELL_TREE, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_FELL_TREE
		if("on orgasm")
			RegisterSignal(M, COMSIG_MOB_EJACULATED, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_EJACULATED
		if("on kiss")
			RegisterSignal(M, COMSIG_MOB_KISS, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_KISS
		if("on kissed")
			RegisterSignal(M, COMSIG_MOB_KISSED, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_KISSED
		if("on move")
			RegisterSignal(M, COMSIG_MOVABLE_MOVED, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOVABLE_MOVED
		if("on dawn")
			RegisterSignal(M, COMSIG_MOB_DAWNED, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_DAWNED
		if("on day")
			RegisterSignal(M, COMSIG_MOB_DAYED, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_DAYED
		if("on dusk")
			RegisterSignal(M, COMSIG_MOB_DUSKED, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_DUSKED
		if("on night")
			RegisterSignal(M, COMSIG_MOB_NIGHTED, PROC_REF(on_signal_trigger))
			signals += COMSIG_MOB_NIGHTED

	// spawn trigger fires instantly
	if(trigger == "on spawn")
		check_trigger("on spawn")

/datum/modular_curse/proc/trigger_effect()
	if(!owner)
		return

	var/mob/living/L = owner
	var/arg = TRUE
	switch(effect)
		if("buff or debuff")
			spawn(0)
				var/mob/living/carbon/human/H = L
				var/debuff_id = effect_args["debuff_id"]
				if(!debuff_id)
					return
				if (H.has_status_effect(text2path(debuff_id)))
					arg = FALSE
				else
					H.remove_status_effect(debuff_id)
					H.apply_status_effect(debuff_id, 10 SECONDS)
			notify_player_of_effect(arg)
		if("remove trait")
			var/trait_id = effect_args["trait"]
			if(!trait_id)
				return
			if(HAS_TRAIT(L, trait_id))
				REMOVE_TRAIT(L, trait_id, TRAIT_GENERIC)
			else
				arg = FALSE
			notify_player_of_effect(arg)
		if("add trait")
			var/trait_id = effect_args["trait"]
			if(!trait_id)
				return
			if(HAS_TRAIT(L, trait_id))
				arg = FALSE
			else
				ADD_TRAIT(L, trait_id, TRAIT_GENERIC)
			notify_player_of_effect(arg)
		if("scream")
			spawn(0)
				L.emote("scream", forced = TRUE)
				notify_player_of_effect(arg)
		if("cry")
			spawn(0)
				L.emote("cry", forced = TRUE)
				notify_player_of_effect(arg)
		if("add reagent")
			var/reagent_type = effect_args["reagent_type"]
			var/amount = effect_args["amount"]

			if(istext(reagent_type))
				reagent_type = text2path(reagent_type)

			if(!reagent_type)
				return

			var/mob/living/carbon/M = L
			var/datum/reagents/reagents = new()
			reagents.add_reagent(reagent_type, amount)
			reagents.trans_to(M, amount, transfered_by = M, method = INGEST)
			notify_player_of_effect(arg)
		if("add arousal")
			var/amount = effect_args["amount"]
			L.sexcon.arousal += amount
			notify_player_of_effect(arg)
		if("orgasm")
			L.sexcon.arousal += 999
			notify_player_of_effect(arg)
		if("shrink sex organs")
			spawn(0)
				var/obj/item/organ/penis/penis = L.getorganslot(ORGAN_SLOT_PENIS)
				var/obj/item/organ/testicles/testicles = L.getorganslot(ORGAN_SLOT_TESTICLES)
				var/obj/item/organ/breasts/breasts = L.getorganslot(ORGAN_SLOT_BREASTS)
				var/pmax = FALSE
				var/tmax = FALSE
				var/bmax = FALSE
				if(penis)
					if(penis.penis_size > MIN_PENIS_SIZE)
						penis.penis_size--
					else
						pmax = TRUE
				if(testicles)
					if(testicles.ball_size > MIN_TESTICLES_SIZE)
						testicles.ball_size--
					else
						tmax = TRUE
				if(breasts)
					if(breasts.breast_size > MIN_BREASTS_SIZE )
						breasts.breast_size--
					else
						bmax = TRUE
				if(!penis && !testicles && !breasts) //nothing to change
					arg = FALSE
				if(!pmax && !tmax && !bmax) //nothing was able to change
					arg = FALSE
				L.update_body()
				notify_player_of_effect(arg)
		if("enlarge sex organs")
			spawn(0)
				var/obj/item/organ/penis/penis = L.getorganslot(ORGAN_SLOT_PENIS)
				var/obj/item/organ/testicles/testicles = L.getorganslot(ORGAN_SLOT_TESTICLES)
				var/obj/item/organ/breasts/breasts = L.getorganslot(ORGAN_SLOT_BREASTS)
				var/pmax = FALSE
				var/tmax = FALSE
				var/bmax = FALSE
				if(penis)
					if(penis.penis_size < MAX_PENIS_SIZE)
						penis.penis_size++
					else
						pmax = TRUE
				if(testicles)
					if(testicles.ball_size < MAX_TESTICLES_SIZE)
						testicles.ball_size++
					else
						tmax = TRUE
				if(breasts)
					if(breasts.breast_size < MAX_BREASTS_SIZE )
						breasts.breast_size++
					else
						bmax = TRUE
				if(!penis && !testicles && !breasts) //nothing to change
					arg = FALSE
				if(!pmax && !tmax && !bmax) //nothing was able to change
					arg = FALSE
				L.update_body()
				notify_player_of_effect(arg)
		if("add nausea")
			var/mob/living/carbon/M = L
			var/amount = effect_args["amount"]
			M.add_nausea(amount)
			notify_player_of_effect(arg)
		if("clothesplosion")
			L.drop_all_held_items()
			for(var/obj/item/I in L.get_equipped_items())
				L.dropItemToGround(I, TRUE)
			notify_player_of_effect(arg)
		if("slip")
			spawn(0)
				L.liquid_slip(total_time = 1 SECONDS, stun_duration = 1 SECONDS, height = 12, flip_count = 0)
				notify_player_of_effect(arg)
			
		if("arcyne prison")
			spawn(0)
				var/turf/center = get_turf(L)
				for(var/turf/T in orange(1, center))
					new /obj/effect/temp_visual/trap_wall(T)
					// create the real wall after a short delay
					addtimer(CALLBACK(src, PROC_REF(create_arcyne_wall), T), 0 SECONDS)
				notify_player_of_effect(arg)
		if("make deadite")
			spawn(0)
				if(L.mind.has_antag_datum(/datum/antagonist/zombie))
					remove_zombie_antag(target = L, user = L, method = "curse", lethal = FALSE)
					arg = FALSE
				else
					L.fully_heal(TRUE)
					L.mind.add_antag_datum(/datum/antagonist/zombie)
					var/datum/antagonist/zombie/newz = L.mind.has_antag_datum(/datum/antagonist/zombie)
					if(newz)
						newz.wake_zombie(TRUE)
				notify_player_of_effect(arg)
				/*
		if("make vampire")
			spawn(0)
				var/datum/antagonist/vampire/existing = L.mind.has_antag_datum(/datum/antagonist/vampire)
				if(existing)
					if(hascall(existing, "on_removal"))
						existing.on_removal()
					L.mind.remove_antag_datum(existing)
					arg = FALSE
				else
					L.fully_heal(TRUE)
					if(vampholder)
						L.mind.add_antag_datum(vampholder)
					else
						var/datum/antagonist/vampire/newvamp = new /datum/antagonist/vampire(generation = GENERATION_THINBLOOD)
						L.mind.add_antag_datum(newvamp)
						vampholder = newvamp
						if(newvamp)
							L.adjust_bloodpool(500)
				notify_player_of_effect(arg)
		if("make werewolf")
			spawn(0)
				if(L.mind.has_antag_datum(/datum/antagonist/werewolf))
					L.mind.remove_antag_datum(/datum/antagonist/werewolf)
					arg = FALSE
				else
					L.fully_heal(TRUE)
					var/datum/antagonist/werewolf/neww = L.mind.has_antag_datum(/datum/antagonist/werewolf)
					L.mind.add_antag_datum(/datum/antagonist/werewolf)
				notify_player_of_effect(arg)
				*/
		if("shock")
			L.electrocute_act(rand(15,30), src)
			notify_player_of_effect(arg)
		if("add fire stack")
			L.adjust_fire_stacks(rand(1,6))
			L.ignite_mob()
			notify_player_of_effect(arg)
		if("cbt")
			if(!ishuman(L))
				return
			var/mob/living/carbon/human/humie = L
			var/obj/item/bodypart/affecting = humie.get_bodypart(BODY_ZONE_CHEST)
			if(!affecting)
				return
			affecting.add_wound(/datum/wound/cbt/permanent)
			notify_player_of_effect(arg)
		/*if("easy ambush")
			var/mob/living/simple_animal/M = effect_args["mob_type"]
			if(!M || !istype(M, /mob/living/simple_animal))
				return
			ambush_mob_at_target(L, M, easy = TRUE)
		if("difficult ambush")
			var/mob/living/simple_animal/M = effect_args["mob_type"]
			if(!M || !istype(M, /mob/living/simple_animal))
				return
			ambush_mob_at_target(L, M, easy = FALSE)*/
		if("explode")
			explosion(get_turf(L), 1, 2, 3, 0, TRUE, TRUE)
			notify_player_of_effect(arg)
		if("shapeshift")
			spawn(0)
				shapeshift.shapeshift_type = text2path(effect_args["mob_type"])
				var/obj/shapeshift_holder/S = locate() in L
				if(S)
					shapeshift.Restore(L)
				else if(shapeshift.shapeshift_type)
					shapeshift.Shapeshift(L)
				notify_player_of_effect(arg)
		if("gib")
			if(!L)
				return
			message_admins(span_adminnotice("[key_name_admin(owner)] gibbed due to curse."))
			SSblackbox.record_feedback("tally", "curse", 1, "Gib Curse") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living, gib), 1, 1, 1), 2)
			notify_player_of_effect(arg)
			return

		else
			// Unknown effect
			return

/datum/modular_curse/proc/notify_player_of_effect(arg)
	if(!owner)
		return
	var/no_notify_on_false_arg = TRUE

	var/flavor_text_self = ""
	var/flavor_text_other = ""
	var/trigger_text_self = ""
	var/trigger_text_other = ""
	var/effect_text_self = ""
	var/effect_text_other = ""
	var/list/choices_self = list()
	var/list/choices_other = list()

	//flavoring of notification
	switch(flavor)
		if("divine")
			choices_self = list(
				"A burning light sears through your chest",
				"A crushing judgment presses against your soul",
				"You feel holy wrath claw through your veins",
				"A lance of radiant pain pierces you",
				"You feel condemned by a merciless power"
			)
			choices_other = list(
				"A harsh blaze of light strikes [owner] from above",
				"[owner] flinches as scorch-bright radiance slams into them",
				"A crack of punishing light lashes across [owner]",
				"[owner] recoils beneath a smiting flash",
				"A blast of searing brilliance crashes down on [owner]"
			)

		if("demonic")
			choices_self = list(
				"A chill coils through your gut",
				"A shadow presses against your mind",
				"You feel stained by something foul",
				"A harsh cold grips your spirit",
				"You feel watched by darkness"
			)
			choices_other = list(
				"Shadows deepen around [owner]",
				"[owner]'s features harden sharply",
				"A dimness hangs around [owner]",
				"[owner]'s eyes catch a cruel glint",
				"The air near [owner] seems colder"
			)

		if("witchcraft")
			choices_self = list(
				"Old magic stirs beneath your skin",
				"A tingle runs through your veins",
				"You feel spells coil around you",
				"A shimmer brushes your senses",
				"You feel bound to unseen forces"
			)
			choices_other = list(
				"Faint motes flicker around [owner]",
				"[owner]'s hair stirs without wind",
				"A brief glow outlines [owner]'s shape",
				"[owner]'s gaze grows distant and strange",
				"[owner] moves as if tugged by threads"
			)

		if("fey")
			choices_self = list(
				"A mocking giggle echoes in your skull",
				"You feel unseen hands tug and tease at you",
				"A prankster's malice dances across your nerves",
				"You hear taunting whispers just behind your ear",
				"A sharp jolt of mischief jolts through your body"
			)
			choices_other = list(
				"A faint chorus of cruel laughter surrounds [owner]",
				"[owner] flinches at unseen teasing hands",
				"Whispering mockery drifts around [owner]",
				"[owner]'s posture jolts as if pranked by the unseen",
				"Soft snickering and rustling circle [owner] without source"
			)

		if("mutation")
			choices_self = list(
				"A strange tension ripples through you",
				"You feel something shift inside",
				"A wrongness tingles through your limbs",
				"Your body feels briefly unfamiliar",
				"You feel bent by twisting forces"
			)
			choices_other = list(
				"[owner]'s outline ripples slightly",
				"[owner]'s posture shudders oddly",
				"[owner]'s features shift, then settle",
				"Movement warps strangely around [owner]",
				"[owner] looks subtly out of alignment"
			)

	flavor_text_self = pick(choices_self)
	flavor_text_other = pick(choices_other)

	// ----- Trigger phrasing -----
	switch(trigger)
		if("on death")
			trigger_text_self = "as you die";trigger_text_other = "as life leaves them"
		if("on beheaded")
			trigger_text_self = "as you are beheaded";trigger_text_other = "as their head is severed"
		if("on dismembered")
			trigger_text_self = "as you lose a limb";trigger_text_other = "as a limb is torn from them"
		if("on sleep")
			trigger_text_self = "as you fall asleep";trigger_text_other = "as their body slackens"
		if("on attack")
			trigger_text_self = "as you strike";trigger_text_other = "as their blow lands"
		if("on receive damage")
			trigger_text_self = "as you are harmed";trigger_text_other = "as blood is drawn"
		if("on cast spell")
			trigger_text_self = "as you invoke power";trigger_text_other = "as words of power leave their lips"
		if("on spell or miracle target")
			trigger_text_self = "as magic touches you";trigger_text_other = "as magic strikes their form"
		if("on cut tree")
			trigger_text_self = "as you swing your axe";trigger_text_other = "as wood splinters beneath their strike"
		if("on kiss")
			trigger_text_self = "as you kiss";trigger_text_other = "as their lips meet another"
		if("on kissed")
			trigger_text_self = "as you are kissed";trigger_text_other = "as a kiss touches them"
		if("on orgasm")
			trigger_text_self = "as pleasure peaks";trigger_text_other = "as their body tenses and releases"
		if("on move")
			trigger_text_self = "as you move";trigger_text_other = "with each step they take"
		if("on dawn")
			trigger_text_self = "as dawn breaks";trigger_text_other = "as first light touches them"
		if("on day")
			trigger_text_self = "as day rises";trigger_text_other = "as daylight gathers"
		if("on dusk")
			trigger_text_self = "as dusk descends";trigger_text_other = "as shadows deepen around them"
		if("on night")
			trigger_text_self = "as night falls";trigger_text_other = "as darkness settles"

	// ----- Effect phrasing -----
	switch(effect)
		if("buff or debuff")
			effect_text_self = "your body shifts and twists inside you";effect_text_other = "their stance subtly changes"
		if("remove trait")
			effect_text_self = "something familiar fades from you";effect_text_other = "a familiar quality disappears from them"
		if("add trait")
			effect_text_self = "a new aspect awakens within you";effect_text_other = "something new takes shape in them"
		if("scream")
			effect_text_self = "you let out a scream";effect_text_other = "they begin to wail"
		if("cry")
			effect_text_self = "tears drip from your eyes";effect_text_other = "salty tears baste their cheeks"
		if("add reagent")
			effect_text_self = "your blood feels altered";effect_text_other = "a strange tint touches their veins"
		if("add arousal")
			effect_text_self = "heat eminates from your loins";effect_text_other = "their breath quickens and their cheeks flush"
		if("orgasm")
			effect_text_self = "a climax is set upon you";effect_text_other = "they look wracked with pleasure"
		if("shrink sex organs")
			effect_text_self = "your sex organs seem to retract";effect_text_other = "they look less confident"
		if("enlarge sex organs")
			effect_text_self = "your sex organs seem to swell";effect_text_other = "they look more confident"
		if("add nausea")
			effect_text_self = "your stomach twists";effect_text_other = "their face pales and their balance falters"
		if("clothesplosion")
			effect_text_self = "your equipment flies away";effect_text_other = "equipment bursts away from them"
		if("slip")
			effect_text_self = "your footing vanishes";effect_text_other = "they stumble and fall"
		if("arcyne prison")
			effect_text_self = "you are trapped in arcyne walls";effect_text_other = "they become entrapped in arcyne walls"

		if("make deadite")
			no_notify_on_false_arg = FALSE
			effect_text_self = (arg == TRUE ? "you begin to crave brains" : "you no longer crave brains") ;effect_text_other = (arg == TRUE ? "their body rapidly decomposes" : "their body rapidly restores itself") 
		/*if("make vampire")
			no_notify_on_false_arg = FALSE
			effect_text_self = (arg == TRUE ? "you begin to crave blood" : "you no longer crave blood") ;effect_text_other = (arg == TRUE ? "they become rather pale" : "life seems to rush into them") 
		if("make werewolf")
			no_notify_on_false_arg = FALSE
			effect_text_self = (arg == TRUE ? "you begin to crave flesh" : "you no longer crave flesh") ;effect_text_other = (arg == TRUE ? "their hair and nails lengthen" : "their hair and nails shorten") 
		*/
		if("shock")
			effect_text_self = "a jolt tears through you";effect_text_other = "their body convulses sharply"
		if("add fire stack")
			effect_text_self = "flames lick your skin";effect_text_other = "fire catches against them"
		if("cbt")
			effect_text_self = "your genitals wrench and twist out of place";effect_text_other = "they look to be in agonizing pain"
		if("explode")
			effect_text_self = "you detonate violently";effect_text_other = "they erupt in a sudden blast"
		if("shapeshift")
			effect_text_self = "your form twists and reshapes";effect_text_other = "their shape changes before your eyes"
		if("gib")
			effect_text_self = "you burst apart";effect_text_other = "they are torn into pieces"

	// final messages
	var/self_message   = "[flavor_text_self] [trigger_text_self]. [effect_text_self]."
	var/others_message = "[flavor_text_other] [trigger_text_other]. [effect_text_other]!"

	if(arg == FALSE && no_notify_on_false_arg == TRUE)
		return

	owner.visible_message(span_warning(others_message), span_warning(self_message))

/datum/modular_curse/proc/on_signal_trigger()
	if(!owner)
		return
	check_trigger(trigger)

/datum/modular_curse/proc/detach()
	unregister_all_signals()
	owner = null
	signals = list()
	qdel(src)

/datum/modular_curse/proc/check_trigger(trigger_name)
	if(!owner)
		return

	if(trigger != trigger_name)
		return

	if(expires <= now_days())
		var/ck = owner?.ckey
		detach()
		if(ck)
			remove_player_curse(ck, name)
		return

	// cooldown
	if(world.time < last_trigger + (cooldown * 10))
		return

	if(!prob(chance))
		return

	last_trigger = world.time
	trigger_effect()

/datum/modular_curse/proc/unregister_all_signals()
	if(!owner || !signals || !signals.len)
		return

	for(var/S in signals)
		UnregisterSignal(owner, S)

	signals.Cut()

////////////////////////////////////////////////////////////
//  TIME HELPER
////////////////////////////////////////////////////////////

/proc/now_days()
	return round((world.realtime / 10) / 86400)

////////////////////////////////////////////////////////////
//  JSON LOAD / SAVE
////////////////////////////////////////////////////////////

/proc/get_player_curses(key)
	if(!key)
		return

	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/curses.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")

	var/list/json = json_decode(file2text(json_file))
	if(!json)
		json = list()

	return json


/proc/has_player_curse(key, curse)
	if(!key || !curse)
		return FALSE

	var/list/json = get_player_curses(key)
	if(!json || !json[curse])
		return FALSE

	var/list/C = json[curse]

	if(C["expires"] <= now_days())
		remove_player_curse(key, curse)
		return FALSE

	return TRUE


/proc/apply_player_curse(
	key,
	curse,
	flavor = "divine",
	duration_days = 1,
	cooldown_seconds = 0,
	chance_percent = 100,
	trigger = null,
	effect_proc = null,
	list/effect_args = null,
	admin_name = "unknown",
	reason = "No reason supplied.",
	extra = null
)
	if(!key || !curse)
		return FALSE

	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/curses.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")

	var/list/json = json_decode(file2text(json_file))
	if(!json)
		json = list()

	if(json[curse])
		return FALSE

	json[curse] = list(
		"expires"      = now_days() + duration_days,
		"flavor"       = flavor,
		"chance"       = chance_percent,
		"cooldown"     = cooldown_seconds,
		"last_trigger" = 0,
		"trigger"      = trigger,
		"effect"       = effect_proc,
		"effect_args"  = effect_args,
		"admin"        = admin_name,
		"reason"       = reason,
		"character_name" = (extra ? extra["character_name"] : null)

	)

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

	// Live-refresh if they're online
	refresh_player_curses_for_key(key)

	return TRUE


/proc/remove_player_curse(key, curse_name)
	if(!key || !curse_name)
		return FALSE

	// --- Load JSON ---
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/curses.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")

	var/list/json = json_decode(file2text(json_file))
	if(!json || !json[curse_name])
		return FALSE

	// --- Remove from JSON ---
	json[curse_name] = null

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

	// --- Live cleanup if player online ---
	for(var/client/C in GLOB.clients)
		if(C && C.ckey == key)
			var/mob/M = C.mob
			if(!M || !M.mind || !M.mind.curses)
				break

			if(M.mind.curses[curse_name])
				var/datum/modular_curse/CR = M.mind.curses[curse_name]

				if(CR)
					CR.detach()

				M.mind.curses -= curse_name

			break

	return TRUE




////////////////////////////////////////////////////////////
//  LIVE REFRESH TO MIND / MOB
////////////////////////////////////////////////////////////

/proc/load_curses_into_mind(datum/mind/M, key)
	if(!M || !key)
		return

	var/list/json = get_player_curses(key)
	if(!json)
		json = list()

	if(!M.curses)
		M.curses = list()

	for(var/existing in M.curses)
		if(!(existing in json))
			var/datum/modular_curse/oldC = M.curses[existing]
			if(oldC)
				oldC.detach()
			M.curses -= existing

	for(var/curse_name in json)
		var/list/C = json[curse_name]
		if(!C)
			continue

		// already exists? update fields
		if(M.curses[curse_name])
			var/datum/modular_curse/existingC = M.curses[curse_name]
			existingC.expires      = C["expires"]
			existingC.flavor      = C["flavor"]
			existingC.chance       = C["chance"]
			existingC.cooldown     = C["cooldown"]
			existingC.last_trigger = C["last_trigger"]
			existingC.trigger      = C["trigger"]
			existingC.effect       = C["effect"]
			existingC.effect_args  = C["effect_args"]
			existingC.admin        = C["admin"]
			existingC.reason       = C["reason"]
			existingC.character_name = C["character_name"]
			continue

		// create NEW curse datum
		var/datum/modular_curse/newC = new
		newC.name         = curse_name
		newC.expires      = C["expires"]
		newC.flavor      = C["flavor"]
		newC.chance       = C["chance"]
		newC.cooldown     = C["cooldown"]
		newC.last_trigger = C["last_trigger"]
		newC.trigger      = C["trigger"]
		newC.effect       = C["effect"]
		newC.effect_args  = C["effect_args"]
		newC.admin        = C["admin"]
		newC.reason       = C["reason"]
		newC.character_name = C["character_name"]

		M.curses[curse_name] = newC

/proc/apply_curses_to_mob(mob/M, datum/mind/MN)
	if(!M || !MN || !MN.curses)
		return

	for(var/curse_name in MN.curses)
		var/datum/modular_curse/C = MN.curses[curse_name]
		if(C.character_name && (M.real_name != C.character_name))
			continue
		if(C.owner == M)
			continue

		C.attach_to_mob(M)


/proc/refresh_player_curses_for_key(key)
	if(!key)
		return

	for(var/client/C in GLOB.clients)
		if(!C || C.ckey != key)
			continue

		var/mob/M = C.mob
		if(!M)
			return

		if(!M.mind)
			M.mind_initialize()

		if(M.mind)
			if(M.mind.curses)
				for(var/datum/modular_curse/CRS in M.mind.curses)
					CRS.detach()
			load_curses_into_mind(M.mind, key)
			apply_curses_to_mob(M, M.mind)
		return



////////////////////////////////////////////////////////////
//  ADMIN POPUP – CURSE CREATION
////////////////////////////////////////////////////////////

/client/proc/curse_player_popup(mob/target)
	if(!target || !target.ckey)
		usr << "Invalid target."
		return

	// ---- Curse binding type ----
	var/list/binding_choices = list("ckey curse", "character curse")

	var/binding = input(
		src,
		"Apply this curse to the player's account, or only this specific character?",
		"Curse Binding Type"
	) as null|anything in binding_choices

	if(!binding)
		return

	var/key = target.ckey
	var/is_character_bound = (binding == "character curse")
	var/character_name = null
	if(is_character_bound)
		character_name = target.real_name

	// ---- Trigger Selection ----
	//commented out do not currently have signals
	var/list/trigger_list = list(
		"on spawn",
		"on death",
		"on beheaded",
		"on dismembered",
		"on sleep",
		"on attack",
		"on receive damage",
		"on cast spell",
		"on spell or miracle target",
		//"on break wall/door/window",
		"on cut tree",
		//"on craft",
		"on kiss",
		"on kissed",
		"on orgasm",
		//"on bite",
		//"on jump",
		//"on climb",
		//"on swim",
		"on move",
		"on dawn",
		"on day",
		"on dusk",
		"on night"
	)

	var/trigger = input(
		src,
		"Choose a trigger event for this curse:",
		"Trigger Selection"
	) as null|anything in trigger_list

	if(!trigger)
		return

	// ---- Chance ----
	var/chance = input(
		src,
		"Percent chance (1 to 100):",
		"Chance",
		100
	) as null|num

	if(isnull(chance))
		return
	chance = clamp(chance, 1, 100)

	// ---- Effect Selection ----
	var/list/effect_list = list(
		"buff or debuff",
		"remove trait",
		"add trait",
		"scream",
		"cry",
		"add reagent",
		"add arousal",
		"orgasm",
		"shrink sex organs",
		"enlarge sex organs",
		"add nausea",
		"clothesplosion",
		"slip",
		"arcyne prison",
		"make deadite",
		/*"make vampire",
		"make werewolf",*/
		"shock",
		"add fire stack",
		"cbt",
		//"easy ambush",
		//"difficult ambush",
		"explode",
		"shapeshift",
		"gib"
	)

	var/effect_proc = input(
		src,
		"Choose the effect this curse will apply:",
		"Effect Selection"
	) as null|anything in effect_list

	if(!effect_proc)
		return

	var/list/effect_args = null

	// ---- Trait selection ----
	if(effect_proc == "add trait" || effect_proc == "remove trait")
		var/list/trait_choices = GLOB.roguetraits.Copy()

		var/action = (effect_proc == "add trait" ? "add" : "remove")

		var/trait_id = input(
			src,
			"Select the trait to [action]:",
			"Trait Selection"
		) as null|anything in trait_choices

		if(!trait_id)
			return

		effect_args = list("trait" = trait_id)

	// ---- Buff / Debuff selection ----
	if(effect_proc == "buff or debuff")
		var/debuff_id = input(
			src,
			"Select the effect to apply:",
			"Effect Selection"
		) as null|anything in subtypesof(/datum/status_effect)

		if(!debuff_id)
			return

		effect_args = list(
			"debuff_id" = debuff_id
		)

	// ---- Reagent selection ----
	if(effect_proc == "add reagent")
		var/reagent_type = input(
			src,
			"Select the reagent to add (typepath):",
			"Reagent Selection"
		) as null|anything in subtypesof(/datum/reagent)

		if(!reagent_type)
			return

		effect_args = list(
			"reagent_type" = reagent_type
		)

	var/list/possible_shapes = list( //add more as needed
		//animals
		/mob/living/simple_animal/hostile/retaliate/rogue/cat,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf,
		/mob/living/simple_animal/hostile/retaliate/rogue/mole,
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga,
		/mob/living/simple_animal/hostile/retaliate/frog,
		/mob/living/simple_animal/hostile/retaliate/bat,
		/mob/living/simple_animal/hostile/retaliate/goose,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit,
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear,
		/mob/living/simple_animal/hostile/rogue/dragger,
		/mob/living/simple_animal/hostile/retaliate/rogue/fox,
		/mob/living/simple_animal/hostile/retaliate/rogue/headless,
		/mob/living/simple_animal/hostile/retaliate/rogue/lamia,
		/mob/living/simple_animal/hostile/retaliate/rogue/mimic,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon,
		/mob/living/simple_animal/hostile/retaliate/smallrat,
		//farm
		/mob/living/simple_animal/hostile/retaliate/rogue/chicken,
		/mob/living/simple_animal/hostile/retaliate/rogue/cow,
		/mob/living/simple_animal/hostile/retaliate/rogue/goat,
		/mob/living/simple_animal/hostile/retaliate/rogue/swine,
		//spirits
		/mob/living/simple_animal/hostile/rogue/haunt,
		//trolls
		/mob/living/simple_animal/hostile/retaliate/rogue/troll,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave,
		//elementals
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden,
		//fae
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph,
		//infernal
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher,
		//void
		/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan,
		/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk,
		/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon,
		//primordial
		/mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire,
		/mob/living/simple_animal/hostile/retaliate/rogue/primordial/water,
		/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air,
		//other
		/mob/living/simple_animal/hostile/rogue/deepone,
		/mob/living/simple_animal/hostile/rogue/sissean_jailer_mage,
		/mob/living/simple_animal/hostile/rogue/spirit_vengeance,
		/mob/living/simple_animal/hostile/rogue/skeleton,
		/mob/living/simple_animal/hostile/retaliate/rogue/drider,
		/mob/living/simple_animal/hostile/rogue/haunt
	)

	var/list/mob_list = list()
	for(var/path in possible_shapes)
		var/mob/living/simple_animal/A = path
		mob_list[initial(A.name)] = path
	
	// ---- Mob-spawning effects ----
	if(effect_proc in list("shapeshift", "easy ambush", "difficult ambush"))
		var/mob_type = input(
			src,
			"Select the mob to spawn/give:",
			"Mob Selection"
		) as null|anything in sortList(mob_list)

		if(!mob_type)
			return

		effect_args = list(
			"mob_type" = mob_list[mob_type]
		)

	//amount
	if(effect_proc in list("add reagent", "add arousal", "add nausea"))
		var/amount = input(
			src,
			"Amount:",
			"Amount",
			10
		) as null|num

		if(!amount || amount <= 0)
			return

		if(!effect_args)
			effect_args = list()

		effect_args["amount"] = amount

	// ---- Duration ----
	var/duration = input(
		src,
		"Duration (REAL WORLD DAYS):",
		"Duration",
		3
	) as null|num

	if(!duration || duration <= 0)
		return

	// ---- Cooldown ----
	var/cooldown = input(
		src,
		"Cooldown between activations (seconds):",
		"Cooldown",
		1
	) as null|num

	if(cooldown < 0)
		cooldown = 0

	// ---- Reason ----
	var/reason = input(
		src,
		"Reason for curse (admin note):",
		"Reason",
		"Change me or you are shitmin"
	) as null|text

	var/list/flavor_list = list(
		"divine",
		"demonic",
		"witchcraft",
		"fey",
		"mutation"
	)

	// ---- Flavor ----
	var/flavor = input(
		src,
		"Flavor of curse (effects player notifications):",
		"Flavor"
	) as null|anything in flavor_list

	if(!flavor)
		return

	// ---- Generate name ----
	var/cname_safe_effect = replacetext(effect_proc, " ", "_")
	var/cname_safe_trigger = replacetext(trigger, " ", "_")
	var/curse_name = "[chance]percent_[cname_safe_effect]_[cname_safe_trigger]_[rand(1000,9999)]"

	// ---- Apply ----
	var/list/extra = null
	if(is_character_bound)
		extra = list("character_name" = character_name)

	var/success = apply_player_curse(
		key,
		curse_name,
		flavor,
		duration,
		cooldown,
		chance,
		trigger,
		effect_proc,
		effect_args,
		usr.ckey,
		reason,
		extra
	)
	if(success)
		src << "<span class='notice'>Applied curse <b>[curse_name]</b> to [target].</span>"
		target << "<span class='warning'>A strange curse settles upon you…</span>"
	else
		src << "<span class='warning'>Failed to apply curse.</span>"

////////////////////////////
//// Special helpers
////////////////////////////

/datum/modular_curse/proc/create_arcyne_wall(turf/T)
	if(!T)
		return
	new /obj/structure/forcefield_weak/arcyne_prison(T)
