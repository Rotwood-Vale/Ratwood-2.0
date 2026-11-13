/datum/unit_test/silk_bed/Run()
	var/turf/center = get_step(get_step(run_loc_floor_bottom_left, NORTH), EAST)
	var/obj/structure/bed/rogue/silk/bed = allocate(/obj/structure/bed/rogue/silk, center)
	TEST_ASSERT_EQUAL(bed.sleepy, 2, "First weave must offer bedroll comfort.")
	TEST_ASSERT_NULL(bed.web_foreground, "First weave must only cover the ground.")
	TEST_ASSERT(bed.layer < OBJ_LAYER, "Ground silk must sit below dropped objects.")
	TEST_ASSERT_NULL(bed.GetComponent(/datum/component/hiding_spot), "The bed must not hide occupants inside itself.")
	var/mob/living/carbon/human/consistent/sleeper = allocate(/mob/living/carbon/human/consistent, center)
	TEST_ASSERT(bed.buckle_mob(sleeper, force = TRUE), "Floor silk must accept a sleeper.")
	TEST_ASSERT(bed.upgrade(), "The second weave must upgrade the existing bed.")
	TEST_ASSERT_EQUAL(bed.sleepy, 3, "Upgraded silk must offer ordinary-bed comfort without neighboring webs.")
	TEST_ASSERT_EQUAL(sleeper.buckled, bed, "Upgrading must preserve the existing sleeper.")
	TEST_ASSERT(bed.web_foreground.layer > LARGE_MOB_LAYER, "The completed veil must cover large passers as well as its sleeper.")
	TEST_ASSERT_EQUAL(bed.plane, GAME_PLANE_LOWER, "Floor silk must remain on the lower structure plane.")
	TEST_ASSERT_EQUAL(bed.web_foreground.plane, GAME_PLANE_UPPER, "The veil must explicitly escape the lower structure plane.")
	TEST_ASSERT(bed.web_foreground.plane > sleeper.plane, "The veil must render on a plane above its occupant.")
	var/overlay_count = length(bed.overlays)
	TEST_ASSERT(!bed.upgrade(), "A completed bed must reject further upgrades.")
	bed.refresh_silk_appearance()
	TEST_ASSERT_EQUAL(length(bed.overlays), overlay_count, "Repeated refreshes must not accumulate veils.")
	var/obj/effect/proc_holder/spell/self/spin_silk_bed/spell = allocate(/obj/effect/proc_holder/spell/self/spin_silk_bed)
	TEST_ASSERT(!spell.can_place(center), "Completed silk must reject another bed cast.")
	TEST_ASSERT(bed.CanPass(sleeper, center), "Its sleeper must bypass web obstruction.")
	qdel(bed)
	TEST_ASSERT_NULL(sleeper.buckled, "Deleting the bed must release its sleeper.")

/datum/unit_test/silk_bed_visuals/Run()
	var/turf/center = get_step(get_step(run_loc_floor_bottom_left, NORTH), EAST)
	var/obj/structure/bed/rogue/silk/first = allocate(/obj/structure/bed/rogue/silk, center)
	var/obj/structure/bed/rogue/silk/neighbor = allocate(/obj/structure/bed/rogue/silk, get_step(center, EAST))
	TEST_ASSERT(first.upgrade(), "First tile must upgrade independently.")
	TEST_ASSERT_EQUAL(neighbor.sleepy, 2, "Upgrading one tile must not upgrade its neighbor.")
	TEST_ASSERT_NULL(neighbor.web_foreground, "An unfinished neighbor must remain ground silk.")
	neighbor.upgrade()
	TEST_ASSERT_EQUAL(first.icon_state, neighbor.icon_state, "Neighbors must use the same tileable art.")
	TEST_ASSERT(icon_exists(first.icon, "basic") && icon_exists(first.icon, "complete_front"), "Both weaving stages need artwork.")
	qdel(first)
	TEST_ASSERT_EQUAL(neighbor.sleepy, 3, "Removing a neighbor must not downgrade completed silk.")
	neighbor.forceMove(get_step(center, NORTH))
	TEST_ASSERT_EQUAL(neighbor.sleepy, 3, "Moving a completed tile must preserve its upgrade.")

/datum/unit_test/arachnid_weaving/Run()
	var/turf/center = get_step(get_step(run_loc_floor_bottom_left, NORTH), EAST)
	var/mob/living/carbon/human/consistent/weaver = allocate(/mob/living/carbon/human/consistent, center)
	weaver.set_species(/datum/species/arachnid)
	var/list/expected_types = list(/obj/effect/proc_holder/spell/self/spin_web, /obj/effect/proc_holder/spell/self/spin_silk_bed, /obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon)
	var/list/weaving_actions = list()
	for(var/obj/effect/proc_holder/spell/option as anything in weaver.mob_spell_list)
		if(!istype(option, /obj/effect/proc_holder/spell/self/spin_web) && !istype(option, /obj/effect/proc_holder/spell/self/spin_silk_bed) && !istype(option, /obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon))
			continue
		TEST_ASSERT(option.type in expected_types, "Only the retained web, bed and cocoon abilities should be granted.")
		TEST_ASSERT_EQUAL(option.action.owner, weaver, "Each ability must retain its owner.")
		TEST_ASSERT(option.action in weaver.actions, "Every retained ability must have a visible button.")
		TEST_ASSERT(icon_exists(option.action_icon, option.overlay_state), "Retained ability button art is missing.")
		weaving_actions += option.action
	TEST_ASSERT_EQUAL(length(weaving_actions), 3, "Arachnids must have three retained weaving abilities.")
	var/obj/effect/proc_holder/spell/self/spin_web/web_spell = locate() in weaver.mob_spell_list
	var/obj/effect/proc_holder/spell/self/spin_silk_bed/bed_spell = locate() in weaver.mob_spell_list
	var/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/cocoon_spell = locate() in weaver.mob_spell_list
	web_spell.charge_counter = 0
	TEST_ASSERT(!web_spell.action.IsAvailable(), "A cooling-down web button must be unavailable.")
	TEST_ASSERT_EQUAL(web_spell.charge_counter, 0, "Checking readiness must not refund a cooldown.")
	TEST_ASSERT_EQUAL(bed_spell.charge_counter, bed_spell.recharge_time, "Web cooldown must not consume bed cooldown.")
	TEST_ASSERT_EQUAL(cocoon_spell.charge_counter, 3, "Web cooldown must not consume cocoon charges.")
	var/datum/species/arachnid/species = weaver.dna.species
	species.remove_web_spells(weaver)
	for(var/obj/effect/proc_holder/spell/spell in list(web_spell, bed_spell, cocoon_spell))
		TEST_ASSERT(!(spell in weaver.mob_spell_list), "Removing weaving must remove every retained spell.")
	for(var/datum/action/action as anything in weaving_actions)
		TEST_ASSERT(!(action in weaver.actions), "Removing weaving must remove every retained ability button.")

/datum/unit_test/arachnid_weaving_cast/Run()
	var/turf/center = get_step(get_step(run_loc_floor_bottom_left, NORTH), EAST)
	var/mob/living/carbon/human/consistent/weaver = allocate(/mob/living/carbon/human/consistent, center)
	weaver.set_species(/datum/species/arachnid)
	var/obj/effect/proc_holder/spell/self/spin_web/spell = locate() in weaver.mob_spell_list
	var/start_stamina = weaver.stamina
	weaver.doing = TRUE
	TEST_ASSERT(!spell.cast(weaver), "A busy weaver must not start another weaving action.")
	weaver.doing = FALSE
	TEST_ASSERT_EQUAL(weaver.stamina, start_stamina, "Interrupted weaving must not spend stamina.")
	TEST_ASSERT(!(locate(/obj/structure/spider/stickyweb) in center), "Interrupted weaving must not place webbing.")
	ADD_TRAIT(weaver, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	TEST_ASSERT(spell.cast(weaver), "A valid continuous weave must complete.")
	var/obj/structure/spider/stickyweb/thick/web = locate() in center
	TEST_ASSERT(web, "Completed continuous weaving must create dense webbing.")
	allocated += web
	TEST_ASSERT(!spell.can_place(center), "Existing dense webbing must reject overlapping placement.")
	var/obj/effect/proc_holder/spell/self/spin_silk_bed/bed_spell = locate() in weaver.mob_spell_list
	TEST_ASSERT(!bed_spell.can_place(center), "Existing webbing must prevent placing a silk bed over it.")
	qdel(web)
	weaver.stamina = weaver.max_stamina
	REMOVE_TRAIT(weaver, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	TEST_ASSERT(!spell.cast(weaver), "Exhausted weavers must not begin weaving.")
	TEST_ASSERT(!(locate(/obj/structure/spider/stickyweb) in center), "Exhaustion must not produce webbing.")

/datum/unit_test/arachnid_weaving_upgrades/Run()
	var/turf/center = get_step(get_step(run_loc_floor_bottom_left, NORTH), EAST)
	var/mob/living/carbon/human/consistent/weaver = allocate(/mob/living/carbon/human/consistent, center)
	weaver.set_species(/datum/species/arachnid)
	ADD_TRAIT(weaver, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	var/obj/effect/proc_holder/spell/self/spin_web/web_spell = locate() in weaver.mob_spell_list
	TEST_ASSERT_EQUAL(web_spell.type, /obj/effect/proc_holder/spell/self/spin_web, "The ordinary web choice must be available.")
	TEST_ASSERT(web_spell.cast(weaver), "A continuous ordinary weave must succeed.")
	var/obj/structure/spider/stickyweb/thick/dense = locate() in center
	TEST_ASSERT(dense && dense.opacity, "An uninterrupted cast must finish as dense webbing.")
	allocated += dense
	TEST_ASSERT(!(locate(/obj/structure/spider/stickyweb/thin) in center), "Reinforcement must replace its thin web.")
	TEST_ASSERT(!web_spell.can_place(center), "Dense webbing must reject further weaving.")
	qdel(dense)
	var/obj/effect/proc_holder/spell/self/spin_silk_bed/bed_spell = locate() in weaver.mob_spell_list
	TEST_ASSERT(bed_spell.cast(weaver), "First bed weave must succeed.")
	var/obj/structure/bed/rogue/silk/bed = locate() in center
	TEST_ASSERT(bed && !bed.upgraded, "First weave must create unfinished floor silk.")
	allocated += bed
	TEST_ASSERT(bed_spell.can_place(center), "Unfinished bedding must accept a second cast.")
	TEST_ASSERT(bed_spell.cast(weaver), "Second bed weave must add the overhead veil.")
	TEST_ASSERT_EQUAL(locate(/obj/structure/bed/rogue/silk) in center, bed, "Upgrade must preserve the original bed object.")
	TEST_ASSERT(bed.upgraded && bed.sleepy == 3, "Second weave must grant ordinary-bed comfort.")
	TEST_ASSERT(!bed_spell.can_place(center), "Finished bedding must reject a third weave.")

/datum/unit_test/arachnid_web_chain
	var/passes_started = 0
	var/cancel_mode
	var/cooldown_held = FALSE
	var/obj/effect/proc_holder/spell/self/spin_web/web_spell

/datum/unit_test/arachnid_web_chain/proc/on_pass_started(mob/source)
	SIGNAL_HANDLER
	passes_started++
	if(passes_started == 2)
		cooldown_held = web_spell.charge_counter == 0
		addtimer(CALLBACK(src, PROC_REF(interrupt_chain), source, get_turf(source)), 1)

/datum/unit_test/arachnid_web_chain/proc/interrupt_chain(mob/source, turf/start)
	switch(cancel_mode)
		if("move")
			source.forceMove(get_step(start, EAST))
		if("cancel")
			source.doing = FALSE
		if("delete")
			var/obj/structure/spider/stickyweb/web = locate() in start
			qdel(web)

/datum/unit_test/arachnid_web_chain/Run()
	var/turf/center = get_step(get_step(run_loc_floor_bottom_left, NORTH), EAST)
	var/mob/living/carbon/human/consistent/weaver = allocate(/mob/living/carbon/human/consistent, center)
	weaver.set_species(/datum/species/arachnid)
	ADD_TRAIT(weaver, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	web_spell = locate() in weaver.mob_spell_list
	RegisterSignal(weaver, COMSIG_DO_AFTER_BEGAN, PROC_REF(on_pass_started))
	cancel_mode = "move"
	TEST_ASSERT(web_spell.cast(weaver), "Moving during the second pass must retain a successful first pass.")
	var/obj/structure/spider/stickyweb/thin/thin = locate() in center
	TEST_ASSERT(thin, "Movement must leave the first thin web intact.")
	allocated += thin
	TEST_ASSERT(cooldown_held, "Cooldown must not progress during the initial weaving pass.")
	TEST_ASSERT_EQUAL(web_spell.charge_counter, 0, "Cooldown must begin from zero after the chain ends.")
	TEST_ASSERT(!weaver.doing, "Interrupting reinforcement must release the timed-action state.")
	web_spell.start_recharge()
	TEST_ASSERT_EQUAL(web_spell.charge_counter, 0, "Starting recharge must retain the full cooldown after partial completion.")
	weaver.forceMove(center)
	passes_started = 0
	cancel_mode = null
	TEST_ASSERT(web_spell.cast(weaver), "An existing thin web must still accept reinforcement later.")
	TEST_ASSERT_EQUAL(passes_started, 1, "Resuming thin webbing must take only the remaining dense pass.")
	var/obj/structure/spider/stickyweb/thick/dense = locate() in center
	TEST_ASSERT(dense, "Resuming must create dense webbing.")
	allocated += dense
	qdel(dense)
	for(var/mode in list("cancel", "delete"))
		passes_started = 0
		cancel_mode = mode
		TEST_ASSERT(web_spell.cast(weaver), "An interrupted reinforcement must preserve first-pass success.")
		TEST_ASSERT(!weaver.doing, "Cancellation must release timed-action state.")
		TEST_ASSERT_EQUAL(web_spell.charge_counter, 0, "Interrupted reinforcement must leave a full cooldown to run.")
		thin = locate() in center
		if(mode == "cancel")
			TEST_ASSERT(thin, "Canceling must leave thin webbing intact.")
			allocated += thin
			qdel(thin)
		else
			TEST_ASSERT(!(locate(/obj/structure/spider/stickyweb) in center), "A deleted foundation must not be recreated by reinforcement.")
	UnregisterSignal(weaver, COMSIG_DO_AFTER_BEGAN)

/datum/unit_test/arachnid_cocoon_containment/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, center)
	var/obj/structure/spider/rescue_cocoon/cocoon = allocate(/obj/structure/spider/rescue_cocoon, center)
	patient.set_blood_volume(300)
	TEST_ASSERT(cocoon.enclose(patient), "An intact cocoon must accept one living patient.")
	TEST_ASSERT_EQUAL(patient.loc, cocoon, "The patient must actually be contained.")
	TEST_ASSERT(!cocoon.Exit(patient), "Ordinary movement must not bypass the escape action.")
	TEST_ASSERT(HAS_TRAIT(patient, TRAIT_SILK_COMPRESSION), "Containment must apply temporary compression.")
	patient.bleed(10)
	TEST_ASSERT_EQUAL(patient.get_blood_volume(), 300, "Compression must prevent blood loss.")
	var/mob/living/carbon/human/consistent/second = allocate(/mob/living/carbon/human/consistent, center)
	TEST_ASSERT(!cocoon.enclose(second), "An occupied cocoon must reject a second person.")
	patient.forceMove(get_step(center, EAST))
	TEST_ASSERT(!HAS_TRAIT(patient, TRAIT_SILK_COMPRESSION), "Teleporting out must immediately remove compression.")
	TEST_ASSERT_NULL(cocoon.occupant, "External movement must clear the patient reference.")
	TEST_ASSERT(cocoon.opened, "An externally vacated cocoon must become a spent shell.")
	patient.bleed(10)
	TEST_ASSERT(patient.get_blood_volume() < 300, "Normal bleeding must resume after release.")
	TEST_ASSERT(!cocoon.enclose(patient), "A spent shell must never be reusable.")

/datum/unit_test/arachnid_cocoon_treatment/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, center)
	var/obj/item/bodypart/chest = patient.get_bodypart(BODY_ZONE_CHEST)
	var/datum/wound/slash/wound = new
	wound.apply_to_bodypart(chest)
	var/wound_bleeding = wound.bleed_rate
	patient.adjustBruteLoss(20)
	patient.adjustFireLoss(20)
	patient.adjustOxyLoss(20)
	patient.set_blood_volume(300)
	patient.bleedsuppress = TRUE
	patient.physiology.bleed_mod = 0.5
	var/obj/structure/spider/rescue_cocoon/cocoon = allocate(/obj/structure/spider/rescue_cocoon, center)
	TEST_ASSERT(cocoon.enclose(patient), "Wounded patient must be rescuable.")
	STOP_PROCESSING(SSobj, cocoon)
	var/brute = patient.getBruteLoss()
	var/burn = patient.getFireLoss()
	var/oxygen = patient.getOxyLoss()
	cocoon.next_treatment = world.time
	cocoon.process()
	TEST_ASSERT(patient.getBruteLoss() < brute && patient.getFireLoss() < burn, "Treatment must slowly heal brute and burns.")
	TEST_ASSERT(patient.getOxyLoss() < oxygen, "Treatment must support oxygen recovery.")
	TEST_ASSERT_EQUAL(patient.get_blood_volume(), 302, "Blood recovery must use the deliberately slow rate.")
	TEST_ASSERT_EQUAL(wound.bleed_rate, wound_bleeding, "Compression must not cure or rewrite bleeding wounds.")
	cocoon.open_cocoon("snipped")
	TEST_ASSERT(patient.bleedsuppress, "Release must preserve another treatment's suppression flag.")
	TEST_ASSERT_EQUAL(patient.physiology.bleed_mod, 0.5, "Release must preserve independent bleeding modifiers.")
	TEST_ASSERT(wound in patient.get_wounds(), "Opening the cocoon must leave untreated wounds in place.")

/datum/unit_test/arachnid_cocoon_cleanup/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, center)
	var/obj/structure/spider/rescue_cocoon/cocoon = allocate(/obj/structure/spider/rescue_cocoon, center)
	cocoon.enclose(patient)
	patient.death()
	TEST_ASSERT_EQUAL(patient.loc, cocoon, "Death must leave the corpse inside.")
	TEST_ASSERT(!HAS_TRAIT(patient, TRAIT_SILK_COMPRESSION), "Death must stop restorative compression.")
	var/blood = patient.get_blood_volume()
	cocoon.next_treatment = world.time
	cocoon.process()
	TEST_ASSERT_EQUAL(patient.get_blood_volume(), blood, "A corpse must receive no healing.")
	cocoon.open_cocoon("snipped")
	TEST_ASSERT_EQUAL(patient.loc, center, "Cutting must release a corpse.")
	var/mob/living/carbon/human/consistent/other = allocate(/mob/living/carbon/human/consistent, center)
	var/obj/structure/spider/rescue_cocoon/removed = allocate(/obj/structure/spider/rescue_cocoon, center)
	removed.enclose(other)
	qdel(removed)
	TEST_ASSERT_EQUAL(other.loc, center, "Deleting a cocoon must release its occupant.")
	TEST_ASSERT(!HAS_TRAIT(other, TRAIT_SILK_COMPRESSION), "Deletion must remove only its temporary effect.")
	var/obj/structure/spider/rescue_cocoon/empty = allocate(/obj/structure/spider/rescue_cocoon, center)
	empty.enclose(other)
	qdel(other)
	TEST_ASSERT_NULL(empty.occupant, "Deleting the patient must not leave a stale reference.")

/datum/unit_test/arachnid_cocoon_opening/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, center)
	var/obj/structure/spider/rescue_cocoon/cocoon = allocate(/obj/structure/spider/rescue_cocoon, center)
	cocoon.enclose(patient)
	cocoon.take_damage(1000, BRUTE, "blunt", FALSE)
	TEST_ASSERT(!QDELETED(cocoon), "Breaking an intact cocoon must leave a spent shell.")
	TEST_ASSERT_EQUAL(cocoon.icon_state, "smashed", "Damage must use the smashed shell art.")
	TEST_ASSERT_EQUAL(patient.loc, center, "Breaking must release the patient.")
	TEST_ASSERT(!HAS_TRAIT(patient, TRAIT_SILK_COMPRESSION), "Breaking must stop compression.")
	cocoon.take_damage(1000, BRUTE, "blunt", FALSE)
	TEST_ASSERT(QDELETED(cocoon), "A later damaging hit must remove the spent shell.")
	for(var/obj/item/natural/silk/silk in center)
		allocated += silk
	patient.set_species(/datum/species/arachnid)
	var/obj/structure/spider/rescue_cocoon/self_wrap = allocate(/obj/structure/spider/rescue_cocoon, center)
	self_wrap.enclose(patient)
	self_wrap.container_resist(patient)
	TEST_ASSERT_EQUAL(patient.loc, center, "An able Arachnid must escape immediately.")
	TEST_ASSERT_EQUAL(self_wrap.icon_state, "snipped", "An Arachnid's exit must leave a parted shell.")
	patient.STASTR = 10
	TEST_ASSERT_EQUAL(self_wrap.escape_time(patient), 30 SECONDS, "Baseline escape must be half rope time.")
	patient.STASTR = 12
	TEST_ASSERT_EQUAL(self_wrap.escape_time(patient), 24 SECONDS, "Escape must retain Strength scaling.")
	patient.STASTR = 15
	TEST_ASSERT_EQUAL(self_wrap.escape_time(patient), 15 SECONDS, "High Strength must retain half rope timing.")

/datum/unit_test/arachnid_cocoon_cast
	var/mob/living/patient
	var/cancel_cast = FALSE

/datum/unit_test/arachnid_cocoon_cast/proc/on_weave(mob/source)
	SIGNAL_HANDLER
	if(cancel_cast)
		addtimer(CALLBACK(src, PROC_REF(move_patient)), 1)

/datum/unit_test/arachnid_cocoon_cast/proc/move_patient()
	patient.forceMove(get_step(patient, EAST))

/datum/unit_test/arachnid_cocoon_cast/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/weaver = allocate(/mob/living/carbon/human/consistent, center)
	weaver.set_species(/datum/species/arachnid)
	var/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/spell = locate() in weaver.mob_spell_list
	TEST_ASSERT(spell && (spell.action in weaver.actions), "Arachnids need their own cocoon button.")
	TEST_ASSERT_EQUAL(spell.charge_counter, 3, "The ability must start with three charges.")
	TEST_ASSERT(icon_exists(spell.action_icon, spell.overlay_state), "The cocoon button needs valid artwork.")
	patient = allocate(/mob/living/carbon/human/consistent, get_step(center, EAST))
	RegisterSignal(weaver, COMSIG_DO_AFTER_BEGAN, PROC_REF(on_weave))
	cancel_cast = TRUE
	TEST_ASSERT(!spell.cast(list(patient), weaver), "A moving target must interrupt wrapping.")
	TEST_ASSERT_EQUAL(spell.charge_counter, 3, "Interrupted casts must not consume a charge.")
	TEST_ASSERT(!weaver.doing, "Interrupted casts must release the timed-action lock.")
	patient.forceMove(get_step(center, EAST))
	cancel_cast = FALSE
	TEST_ASSERT(spell.cast(list(patient), weaver), "A stationary adjacent target must be cocooned.")
	var/obj/structure/spider/rescue_cocoon/cocoon = patient.loc
	TEST_ASSERT(istype(cocoon), "Successful cast must contain the target.")
	allocated += cocoon
	TEST_ASSERT_EQUAL(spell.charge_counter, 2, "Successful wrapping must consume exactly one charge.")
	TEST_ASSERT_EQUAL(length(spell.charge_returns), 1, "Successful wrapping must schedule its own return.")
	cocoon.open_cocoon("snipped")
	TEST_ASSERT(spell.cast(list(weaver), weaver), "Self cocooning must use the same validated cast.")
	allocated += weaver.loc
	var/obj/structure/spider/rescue_cocoon/self_wrap = weaver.loc
	self_wrap.container_resist(weaver)
	TEST_ASSERT_EQUAL(weaver.loc, center, "Self-wrapped Arachnid must be able to exit.")
	weaver.set_species(/datum/species/human/northern)
	TEST_ASSERT(!(locate(/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon) in weaver.mob_spell_list), "Species loss must remove the racial ability.")

/datum/unit_test/arachnid_cocoon_charges/Run()
	var/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/spell = allocate(/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon)
	spell.charge_counter = 0
	var/mob/living/carbon/human/consistent/user = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	TEST_ASSERT(!spell.charge_check(user), "An empty ability must reject casting with safe feedback.")
	spell.charge_counter = 3
	spell.weaving = TRUE
	TEST_ASSERT(!spell.charge_check(user), "A busy ability must reject reentrant casts with safe feedback.")
	spell.weaving = FALSE
	spell.charge_counter = 0
	spell.charge_returns = list(world.time - 1, world.time + 1 MINUTES, world.time + 2 MINUTES)
	spell.process()
	TEST_ASSERT_EQUAL(spell.charge_counter, 1, "Only the due charge must recover.")
	TEST_ASSERT_EQUAL(length(spell.charge_returns), 2, "Later charges must retain their original deadlines.")
	spell.charge_returns[1] = world.time
	spell.process()
	TEST_ASSERT_EQUAL(spell.charge_counter, 2, "A second charge must return independently.")
	TEST_ASSERT_EQUAL(spell.charge_returns[1], world.time + 2 MINUTES, "Returning a charge must not restart the last deadline.")
	spell.charge_returns[1] = world.time
	spell.process()
	TEST_ASSERT_EQUAL(spell.charge_counter, 3, "All recovered charges must restore full capacity.")
	TEST_ASSERT_EQUAL(length(spell.charge_returns), 0, "No recharge deadlines should remain at full capacity.")

/datum/unit_test/arachnid_cocoon_snipping/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, center)
	var/mob/living/carbon/human/consistent/rescuer = allocate(/mob/living/carbon/human/consistent, center)
	var/obj/item/tool = allocate(/obj/item, center)
	rescuer.used_intent = allocate(/datum/intent/snip)
	var/obj/structure/spider/rescue_cocoon/cocoon = allocate(/obj/structure/spider/rescue_cocoon, center)
	cocoon.enclose(patient)
	TEST_ASSERT(cocoon.attacked_by(tool, rescuer), "Snipping an occupied cocoon must complete.")
	TEST_ASSERT(!QDELETED(cocoon) && cocoon.opened, "The first snip must leave an opened shell.")
	TEST_ASSERT_EQUAL(cocoon.icon_state, "snipped", "Cutting must use its own artwork.")
	TEST_ASSERT_EQUAL(patient.loc, center, "Cutting must release the occupant.")
	TEST_ASSERT(!HAS_TRAIT(patient, TRAIT_SILK_COMPRESSION), "Cutting must remove compression.")
	TEST_ASSERT(cocoon.attacked_by(tool, rescuer), "A second snip must harvest the spent shell.")
	TEST_ASSERT(QDELETED(cocoon), "Harvesting must remove the spent shell.")
	var/yield = 0
	for(var/obj/item/natural/silk/silk in center)
		yield++
		allocated += silk
	TEST_ASSERT(yield >= 1 && yield <= 2, "Harvesting must match ordinary web snipping yield.")
	TEST_ASSERT(!rescuer.doing, "Snipping must release its timed-action lock.")

/datum/unit_test/arachnid_cocoon_cast_lifecycle
	var/recovery_delay = 20 SECONDS
	var/datum/mind/test_mind

/datum/unit_test/arachnid_cocoon_cast_lifecycle/Destroy()
	// Delete the test mind while its character still exists.
	QDEL_NULL(test_mind)
	return ..()

/datum/unit_test/arachnid_cocoon_cast_lifecycle/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/weaver = allocate(/mob/living/carbon/human/consistent, center)
	weaver.set_species(/datum/species/arachnid)
	weaver.mind_initialize()
	test_mind = weaver.mind
	// Isolate spell scheduling from survival needs during the unattended timer wait.
	weaver.notransform = TRUE
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, get_step(center, EAST))
	var/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/spell = locate() in weaver.mob_spell_list
	spell.charge_delay = recovery_delay
	TEST_ASSERT(spell.cast_check(FALSE, weaver), "Framework must permit a fresh cast.")
	weaver.doing = TRUE
	TEST_ASSERT(!spell.perform(list(patient), user = weaver), "A busy caster must fail wrapping through the full framework.")
	weaver.doing = FALSE
	spell.revert_cast(weaver)
	TEST_ASSERT_EQUAL(spell.charge_counter, 3, "A failed framework cast must neither spend nor refund an unreserved charge.")
	TEST_ASSERT_EQUAL(length(spell.charge_returns), 0, "Failed casts must not schedule a recharge.")
	TEST_ASSERT(!spell.weaving && spell.action.IsAvailable(), "Failed casting must leave the ability usable.")
	world.log << "LIVE INITIAL: count=[spell.charge_counter], type=[spell.charge_type], available=[spell.action.IsAvailable()]"
	for(var/use in 1 to 3)
		TEST_ASSERT(spell.cast_check(FALSE, weaver), "Framework cast_check must accept remaining charges.")
		TEST_ASSERT(spell.perform(list(patient), user = weaver), "Full framework casting must succeed.")
		var/obj/structure/spider/rescue_cocoon/cocoon = patient.loc
		TEST_ASSERT(istype(cocoon), "Full casting must create a cocoon.")
		allocated += cocoon
		cocoon.open_cocoon("snipped")
		world.log << "LIVE USE [use]: count=[spell.charge_counter], deadlines=[json_encode(spell.charge_returns)], time=[world.time], queued=[spell in SSfastprocess.processing], available=[spell.action.IsAvailable()], name=[spell.action.name]"
		TEST_ASSERT_EQUAL(spell.charge_counter, 3 - use, "Each full cast must spend exactly one charge.")
		TEST_ASSERT_EQUAL(spell.action.IsAvailable(), use < 3, "Button must remain usable until all three uses are spent.")
	world.log << "LIVE WAIT: observing [DisplayTimeText(spell.charge_delay)] deadline recovery, without manually calling process()."
	var/timeout = world.time + spell.charge_delay + 10 SECONDS
	var/next_report = world.time
	while(world.time < timeout && spell.charge_counter < 3)
		if(world.time >= next_report)
			world.log << "LIVE WATCH: count=[spell.charge_counter], time=[world.time], queued=[spell in SSfastprocess.processing], deadlines=[json_encode(spell.charge_returns)]"
			next_report = world.time + 30 SECONDS
		sleep(1 SECONDS)
	world.log << "LIVE FINAL: count=[spell.charge_counter], stat=[weaver.stat], health=[weaver.health], listed=[spell in weaver.mob_spell_list], weaving=[spell.weaving], available=[spell.action.IsAvailable()]"
	TEST_ASSERT_EQUAL(spell.charge_counter, 3, "All charges must return through real subsystem processing after their independent five-minute deadlines.")
	TEST_ASSERT(spell.action.IsAvailable(), "Button must become usable after live recovery.")
	TEST_ASSERT_EQUAL(length(spell.charge_returns), 0, "Full live recovery must clear all pending deadlines.")

/datum/unit_test/arachnid_cocoon_other_arachnid
	var/datum/mind/test_mind

/datum/unit_test/arachnid_cocoon_other_arachnid/Destroy()
	QDEL_NULL(test_mind)
	return ..()

/datum/unit_test/arachnid_cocoon_other_arachnid/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/weaver = allocate(/mob/living/carbon/human/consistent, center)
	weaver.set_species(/datum/species/arachnid)
	weaver.mind_initialize()
	test_mind = weaver.mind
	weaver.notransform = TRUE
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, get_step(center, EAST))
	patient.set_species(/datum/species/arachnid)
	patient.notransform = TRUE
	var/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/spell = locate() in weaver.mob_spell_list
	TEST_ASSERT(spell.cast_check(FALSE, weaver), "The separate Arachnid caster must be eligible.")
	TEST_ASSERT(spell.perform(list(patient), user = weaver), "One Arachnid must be able to cocoon another.")
	var/obj/structure/spider/rescue_cocoon/cocoon = patient.loc
	TEST_ASSERT(istype(cocoon), "The recipient must be in the player rescue cocoon.")
	allocated += cocoon
	TEST_ASSERT(isarachnid(patient), "Wrapping must preserve the other Arachnid's species.")
	var/start = world.time
	patient.resist()
	TEST_ASSERT_EQUAL(world.time, start, "The actual Resist command must not start a timed struggle for another Arachnid.")
	TEST_ASSERT_EQUAL(patient.loc, get_step(center, EAST), "The recipient must be released on its own original tile.")
	TEST_ASSERT(cocoon.opened, "The instant exit must leave an opened shell.")
	TEST_ASSERT(!patient.doing, "Instant escape must not leave a timed-action lock.")
	TEST_ASSERT(!HAS_TRAIT(patient, TRAIT_SILK_COMPRESSION), "Instant escape must remove treatment from the recipient.")

/datum/unit_test/arachnid_cocoon_fire_entry/Run()
	var/turf/center = run_loc_floor_bottom_left
	for(var/fire_type in list(/datum/status_effect/fire_handler/fire_stacks, /datum/status_effect/fire_handler/fire_stacks/divine, /datum/status_effect/fire_handler/fire_stacks/sunder, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, center)
		patient.adjust_fire_stacks(5, fire_type)
		patient.ignite_mob(TRUE)
		TEST_ASSERT(patient.on_fire, "The test patient must actually be burning before wrapping.")
		var/obj/structure/spider/rescue_cocoon/cocoon = allocate(/obj/structure/spider/rescue_cocoon, center)
		TEST_ASSERT(cocoon.enclose(patient), "A burning patient must be rescuable.")
		TEST_ASSERT(!patient.on_fire, "Completed silk must immediately extinguish the occupant.")
		TEST_ASSERT(!patient.has_status_effect(fire_type), "Extinguishing must remove the real fire effect, not just its cached flag.")
		TEST_ASSERT(!(cocoon.resistance_flags & FIRE_PROOF), "Smothering the occupant must not make silk fireproof.")
		cocoon.open_cocoon("snipped")
		patient.adjust_fire_stacks(5)
		patient.ignite_mob(TRUE)
		TEST_ASSERT(patient.on_fire, "A released patient must not retain fire immunity.")
		patient.extinguish_mob()
	var/mob/living/carbon/human/consistent/weaver = allocate(/mob/living/carbon/human/consistent, center)
	weaver.set_species(/datum/species/arachnid)
	var/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/spell = locate() in weaver.mob_spell_list
	spell.weave_time = 0
	weaver.adjust_fire_stacks(5)
	weaver.ignite_mob(TRUE)
	TEST_ASSERT(spell.cast(list(weaver), weaver), "An Arachnid must be able to complete a self-wrap while burning.")
	var/obj/structure/spider/rescue_cocoon/self_wrap = weaver.loc
	allocated += self_wrap
	TEST_ASSERT(istype(self_wrap) && !weaver.on_fire, "Completed self-wrapping must smother the caster's flames.")

/datum/unit_test/arachnid_cocoon_fire_reignition/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, center)
	var/obj/structure/spider/rescue_cocoon/cocoon = allocate(/obj/structure/spider/rescue_cocoon, center)
	cocoon.enclose(patient)
	patient.adjust_fire_stacks(5)
	patient.ignite_mob(TRUE)
	stoplag(1)
	TEST_ASSERT(!patient.on_fire, "Ignition while enclosed must be smothered after the ignition callback finishes.")
	cocoon.open_cocoon("snipped")
	patient.adjust_fire_stacks(5)
	patient.ignite_mob(TRUE)
	stoplag(1)
	TEST_ASSERT(patient.on_fire, "Opening must unregister automatic smothering.")
	patient.extinguish_mob()
	var/obj/structure/spider/rescue_cocoon/moved = allocate(/obj/structure/spider/rescue_cocoon, center)
	moved.enclose(patient)
	patient.forceMove(get_step(center, EAST))
	patient.adjust_fire_stacks(5)
	patient.ignite_mob(TRUE)
	stoplag(1)
	TEST_ASSERT(patient.on_fire, "Forced exit must unregister automatic smothering.")
	patient.extinguish_mob()
	var/obj/structure/spider/rescue_cocoon/deleted = allocate(/obj/structure/spider/rescue_cocoon, get_turf(patient))
	deleted.enclose(patient)
	patient.adjust_fire_stacks(5)
	patient.ignite_mob(TRUE)
	qdel(deleted)
	stoplag(1)
	TEST_ASSERT(patient.on_fire, "A queued callback must not extinguish someone after their cocoon is deleted.")
	patient.extinguish_mob()

/datum/unit_test/arachnid_cocoon_fire_exception/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, center)
	ADD_TRAIT(patient, TRAIT_NO_EXTINGUISH, TRAIT_SOURCE_UNIT_TESTS)
	patient.adjust_fire_stacks(5)
	patient.ignite_mob(TRUE)
	var/obj/structure/spider/rescue_cocoon/cocoon = allocate(/obj/structure/spider/rescue_cocoon, center)
	TEST_ASSERT(!cocoon.enclose(patient), "Unextinguishable fire must not be silently overridden.")
	TEST_ASSERT_EQUAL(patient.loc, center, "A patient whose flames cannot be smothered must not remain trapped.")
	TEST_ASSERT(patient.on_fire, "The existing everlasting-fire rule must be preserved.")
	TEST_ASSERT(!HAS_TRAIT(patient, TRAIT_SILK_COMPRESSION), "Failed containment must leave no treatment effect.")
	REMOVE_TRAIT(patient, TRAIT_NO_EXTINGUISH, TRAIT_SOURCE_UNIT_TESTS)
	patient.extinguish_mob()
	var/obj/structure/spider/rescue_cocoon/reignited = allocate(/obj/structure/spider/rescue_cocoon, center)
	reignited.enclose(patient)
	ADD_TRAIT(patient, TRAIT_NO_EXTINGUISH, TRAIT_SOURCE_UNIT_TESTS)
	patient.adjust_fire_stacks(5)
	patient.ignite_mob(TRUE)
	stoplag(1)
	TEST_ASSERT_EQUAL(patient.loc, center, "Unsmotherable ignition inside must release the patient.")
	TEST_ASSERT(reignited.opened, "Unsmotherable ignition must open the silk.")
	TEST_ASSERT(!HAS_TRAIT(patient, TRAIT_SILK_COMPRESSION), "Emergency opening must clean up treatment.")
	REMOVE_TRAIT(patient, TRAIT_NO_EXTINGUISH, TRAIT_SOURCE_UNIT_TESTS)
	patient.extinguish_mob()

/datum/unit_test/arachnid_cocoon_spider_speak/Run()
	var/turf/center = run_loc_floor_bottom_left
	var/mob/living/carbon/human/consistent/patient = allocate(/mob/living/carbon/human/consistent, center)
	patient.notransform = TRUE
	TEST_ASSERT(!is_species(patient, /datum/species/arachnid), "Spider Speak must work for a non-Arachnid.")
	patient.apply_status_effect(/datum/status_effect/buff/spider_speak)
	var/obj/structure/spider/rescue_cocoon/cocoon = allocate(/obj/structure/spider/rescue_cocoon, center)
	TEST_ASSERT(cocoon.enclose(patient), "The blessed patient must be enclosed.")
	var/start = world.time
	patient.resist()
	TEST_ASSERT_EQUAL(world.time, start, "Active Spider Speak must permit instant escape through Resist.")
	TEST_ASSERT_EQUAL(patient.loc, center, "Spider Speak must release the patient onto the cocoon tile.")
	TEST_ASSERT(cocoon.opened && !patient.doing, "Instant exit must open the shell without a timed-action lock.")
	TEST_ASSERT(!HAS_TRAIT(patient, TRAIT_SILK_COMPRESSION), "Instant exit must remove cocoon treatment.")
	var/obj/structure/spider/rescue_cocoon/second = allocate(/obj/structure/spider/rescue_cocoon, center)
	TEST_ASSERT(second.enclose(patient), "The patient must be able to enter a second cocoon.")
	patient.stat = UNCONSCIOUS
	second.container_resist(patient)
	TEST_ASSERT_EQUAL(patient.loc, second, "Spider Speak must not let an unconscious patient escape.")
	patient.stat = CONSCIOUS
	patient.remove_status_effect(/datum/status_effect/buff/spider_speak)
	patient.STASTR = 19
	start = world.time
	second.container_resist(patient)
	TEST_ASSERT(world.time >= start + 2 SECONDS, "Removing Spider Speak must restore the ordinary Strength-scaled struggle.")
	TEST_ASSERT_EQUAL(patient.loc, center, "The ordinary struggle must still release the patient.")
	TEST_ASSERT(!patient.doing && !second.struggling, "Completed ordinary escape must clear its action locks.")
