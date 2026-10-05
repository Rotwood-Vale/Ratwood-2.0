// Scenario harddel tests. create_and_destroy only spawns one of every type in isolation, so it cannot
// catch leaks that need two objects to interact first. These drive the gameplay entry points instead.

/// Fails the test if anything besides the caller's own var and the garbage queue still refers to thing.
#define TEST_ASSERT_COLLECTABLE(thing, what) \
	if(refcount(thing) > baseline_refs()) { \
		TEST_FAIL("[what] will hard delete: [refcount(thing) - baseline_refs()] reference(s) survived its destruction"); \
	}

/// Refcount a just-qdel'd datum has when nothing else holds it: the caller's var plus its garbage queue entry.
/datum/unit_test/proc/baseline_refs()
	var/static/cached
	if(isnull(cached))
		var/datum/control = new
		qdel(control)
		cached = refcount(control)
	return cached

/// A mind must not keep itself alive through its own soulOwner/current/language_holder references.
/datum/unit_test/harddel_mind/Run()
	var/mob/living/carbon/human/consistent/subject = new(run_loc_floor_bottom_left)
	subject.mind_initialize()
	var/datum/mind/mind = subject.mind
	TEST_ASSERT_NOTNULL(mind, "mind_initialize() did not give the mob a mind")
	mind.get_language_holder()

	qdel(mind)

	TEST_ASSERT_NULL(subject.mind, "the mob still points at its destroyed mind")
	TEST_ASSERT_COLLECTABLE(mind, "/datum/mind")
	qdel(subject)

/// A spell must drop its reference to a conjured item once that item is destroyed.
/datum/unit_test/harddel_conjured_item/Run()
	var/obj/effect/proc_holder/spell/spell = new
	var/obj/item/conjured = new(run_loc_floor_bottom_left)

	spell.set_conjured_item(conjured)
	qdel(conjured)

	TEST_ASSERT_NULL(spell.conjured_item, "the spell still points at its destroyed conjured item")
	TEST_ASSERT_COLLECTABLE(conjured, "a conjured item")
	qdel(spell)

/// A mob held in another mob's enemies list must not be pinned by it.
/datum/unit_test/harddel_enemy_list/Run()
	var/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/aggressor = new(run_loc_floor_bottom_left)
	var/mob/living/carbon/human/consistent/victim = new(run_loc_floor_bottom_left)

	aggressor.Retaliate()
	TEST_ASSERT(victim in aggressor.enemies, "Retaliate() did not add the bystander to the enemies list")

	qdel(victim)

	TEST_ASSERT_COLLECTABLE(victim, "a mob on an enemies list")
	qdel(aggressor)

#undef TEST_ASSERT_COLLECTABLE
