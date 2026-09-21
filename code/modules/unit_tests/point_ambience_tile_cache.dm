/datum/unit_test/point_ambience_tile_cache
	var/datum/point_ambience_category/fire_category
	var/datum/point_ambience_category/torch_category
	var/fire_range
	var/fire_silenced
	var/torch_silenced
	var/saved_use_tile_cache
	var/saved_verify_tile_cache
	var/saved_cross_floor
	var/list/test_sources = list()

/datum/unit_test/point_ambience_tile_cache/Run()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	fire_category = ambience.categories_by_path[/datum/point_ambience_category/fire]
	torch_category = ambience.categories_by_path[/datum/point_ambience_category/torch]
	fire_range = fire_category.range
	fire_silenced = fire_category.silenced
	torch_silenced = torch_category.silenced
	saved_use_tile_cache = ambience.use_tile_cache
	saved_verify_tile_cache = ambience.verify_tile_cache
	saved_cross_floor = ambience.cross_floor
	ambience.cross_floor = FALSE
	fire_category.silenced = FALSE
	torch_category.silenced = FALSE
	ambience.set_tile_cache(TRUE)

	var/turf/center = locate(run_loc_floor_bottom_left.x + 2, run_loc_floor_bottom_left.y + 2, run_loc_floor_bottom_left.z)
	var/turf/nearby = locate(center.x + 2, center.y, center.z)
	var/turf/far = locate(center.x + fire_range * 2 + 4, center.y, center.z)
	TEST_ASSERT_NOTNULL(far, "The test needs room for two separate source ranges")
	TEST_ASSERT_EQUAL(ambience.get_tile_ranking(center), TRUE, "An empty tile must cache an empty answer")
	var/hits_before = ambience.tile_cache_hits
	TEST_ASSERT_EQUAL(ambience.get_tile_ranking(center), TRUE, "The empty answer must survive a second reader")
	TEST_ASSERT_EQUAL(ambience.tile_cache_hits, hits_before + 1, "An empty answer must count as a hit")
	TEST_ASSERT_EQUAL(ambience.get_tile_ranking(far), TRUE, "The distant tile starts empty")

	var/obj/first = allocate(/obj, center)
	var/obj/second = allocate(/obj, nearby)
	test_sources += first
	test_sources += second
	var/before_registration = ambience.static_version
	ambience.register_source(first, fire_category.type)
	TEST_ASSERT(!ambience.can_reuse_tile_listener(center, before_registration), "A new source must refresh listeners inside its reach")
	TEST_ASSERT(ambience.can_reuse_tile_listener(far, before_registration), "A distant new source must preserve a standing answer, including silence")
	TEST_ASSERT_NULL(ambience.tile_cache[center], "Registration must invalidate a cached empty answer")
	TEST_ASSERT_EQUAL(ambience.tile_cache[far], TRUE, "A local source must not flush a distant tile")
	ambience.register_source(second, fire_category.type)
	TEST_ASSERT(ambience.can_reuse_tile_listener(far, before_registration), "Several known distant changes must preserve a standing answer")
	var/before_override = ambience.static_version
	ambience.register_source(first, fire_category.type, volume_scale = 0.5)
	TEST_ASSERT_EQUAL(fire_category.source_volumes[first], 0.5, "A source volume override must be retained")
	TEST_ASSERT(!ambience.can_reuse_tile_listener(center, before_override), "A source volume override must refresh nearby listeners without movement")
	TEST_ASSERT(ambience.can_reuse_tile_listener(far, before_override), "A source volume override must not refresh distant listeners")
	ambience.register_source(first, fire_category.type)
	TEST_ASSERT_EQUAL(fire_category.source_volumes[first], 0.5, "An omitted volume scale must preserve an existing override")
	var/before_override_reset = ambience.static_version
	ambience.register_source(first, fire_category.type, volume_scale = 1)
	TEST_ASSERT_NULL(fire_category.source_volumes[first], "An explicit scale of one must restore the category volume")
	TEST_ASSERT(!ambience.can_reuse_tile_listener(center, before_override_reset), "Resetting a source volume must refresh nearby listeners")
	TEST_ASSERT(ambience.can_reuse_tile_listener(far, before_override_reset), "Resetting a source volume must preserve distant listeners")
	var/list/ranking = ambience.get_tile_ranking(center)
	var/at = ranking.Find(fire_category)
	TEST_ASSERT(at, "The fire category must be ranked")
	TEST_ASSERT_EQUAL(ranking[at + 1], first, "A source on the listening turf must win")
	TEST_ASSERT_EQUAL(ranking[at + 2], 0, "Distance zero must not be treated as absent")
	TEST_ASSERT_EQUAL(ranking[at + 3], second, "The next source must remain available for occlusion")
	TEST_ASSERT_EQUAL(ranking[at + 4], 4, "The runner-up uses squared distance")
	TEST_ASSERT_EQUAL(length(ambience.scratch_tile_best), 0, "Build scratch must not retain source references")
	TEST_ASSERT_EQUAL(length(ambience.scratch_uncached), 0, "Gather scratch must not retain sources between cache misses")

	var/list/other_ranking = ambience.get_tile_ranking(nearby)
	TEST_ASSERT_NOTEQUAL(ranking, other_ranking, "Different tiles must not share mutable build scratch")
	TEST_ASSERT_EQUAL(ranking[at + 1], first, "Another tile's build must not change this winner")
	TEST_ASSERT_EQUAL(ranking[at + 3], second, "Another tile's build must not change this runner-up")
	TEST_ASSERT_EQUAL(ambience.get_tile_ranking(center), ranking, "A hit must reuse the stored entry")

	var/before_removal = ambience.static_version
	ambience.unregister_source(first, fire_category.type)
	TEST_ASSERT(!ambience.can_reuse_tile_listener(center, before_removal), "Source removal must refresh its old reach")
	TEST_ASSERT(ambience.can_reuse_tile_listener(far, before_removal), "Source removal must preserve a distant standing answer")
	TEST_ASSERT_NULL(ambience.tile_cache[center], "Removal must release the cached ranking immediately")
	ranking = ambience.get_tile_ranking(center)
	at = ranking.Find(fire_category)
	TEST_ASSERT_EQUAL(ranking[at + 1], second, "Removing the winner must promote the remaining source")
	TEST_ASSERT_NULL(ranking[at + 3], "The removed source must not remain as runner-up")

	second.forceMove(locate(center.x + 3, center.y, center.z))
	ambience.register_source(second, fire_category.type)
	TEST_ASSERT_NULL(ambience.tile_cache[center], "A short move must invalidate the old answer")
	ranking = ambience.get_tile_ranking(center)
	at = ranking.Find(fire_category)
	TEST_ASSERT_EQUAL(ranking[at + 2], 9, "The moved source must be reranked at its new distance")
	var/before_long_move = ambience.static_version
	second.forceMove(far)
	ambience.register_source(second, fire_category.type)
	TEST_ASSERT(!ambience.can_reuse_tile_listener(center, before_long_move), "A source move must refresh its old reach even after it moves away")
	TEST_ASSERT(!ambience.can_reuse_tile_listener(far, before_long_move), "A source move must refresh its new reach")
	TEST_ASSERT_NULL(ambience.tile_cache[center], "A move must clear its old reach")
	TEST_ASSERT_NULL(ambience.tile_cache[far], "A move must clear its new reach")
	TEST_ASSERT_EQUAL(ambience.get_tile_ranking(center), TRUE, "A moved-away source must leave silence")
	ranking = ambience.get_tile_ranking(far)
	at = ranking.Find(fire_category)
	TEST_ASSERT_EQUAL(ranking[at + 1], second, "The source must be found at its new position")

	var/before_category_change = ambience.static_version
	ambience.register_source(second, torch_category.type)
	TEST_ASSERT(!ambience.can_reuse_tile_listener(far, before_category_change), "Changing source category must refresh nearby listeners")
	TEST_ASSERT_NULL(ambience.tile_cache[far], "A category change must clear its former ranking")
	ranking = ambience.get_tile_ranking(far)
	TEST_ASSERT_EQUAL(ranking.Find(fire_category), 0, "The former category must not survive a category change")
	at = ranking.Find(torch_category)
	TEST_ASSERT(at, "The new category must be ranked")
	TEST_ASSERT_EQUAL(ranking[at + 1], second, "The source must answer under its new category")
	ambience.unregister_source(second, torch_category.type)
	TEST_ASSERT_NULL(ambience.tile_cache[far], "Unregistration must release the new category's ranking")

	first.forceMove(nearby)
	ambience.register_source(first, fire_category.type)
	ambience.get_tile_ranking(center)
	TEST_ASSERT(!fire_category.vv_edit_var("range", 0), "A zero range would divide by zero during volume falloff")
	var/before_range_edit = ambience.static_version
	TEST_ASSERT(fire_category.vv_edit_var("range", 1), "A valid range edit must be accepted")
	TEST_ASSERT(!ambience.can_reuse_tile_listener(far, before_range_edit), "Global range tuning must not be mistaken for a local source change")
	TEST_ASSERT_EQUAL(length(ambience.tile_cache), 0, "A range decrease must clear all cached source references")
	TEST_ASSERT_EQUAL(ambience.get_tile_ranking(center), TRUE, "The reduced range must exclude the source")
	TEST_ASSERT(fire_category.vv_edit_var("range", fire_range + 1), "A range increase must be accepted")
	TEST_ASSERT_EQUAL(fire_category.range_sq, (fire_range + 1) ** 2, "Range edits must update squared distance gates")
	TEST_ASSERT(ambience.max_range >= fire_category.range, "The bucket search must cover the increased range")
	ranking = ambience.get_tile_ranking(center)
	at = ranking.Find(fire_category)
	TEST_ASSERT(at, "The larger range must admit the source again")
	TEST_ASSERT_EQUAL(ranking[at + 1], first, "Range expansion must rebuild the answer")

	var/mismatches_before = ambience.tile_cache_mismatches
	ambience.tile_cache[center] = TRUE
	ambience.verify_tile_cache = TRUE
	ranking = ambience.get_tile_ranking(center)
	TEST_ASSERT_EQUAL(ambience.tile_cache_mismatches, mismatches_before + 1, "Verification must detect a stale empty entry")
	at = ranking.Find(fire_category)
	TEST_ASSERT(at, "Verification must repair the stale answer before use")
	TEST_ASSERT_EQUAL(ranking[at + 1], first, "Verification must return the fresh winner")
	ambience.get_tile_ranking(center)
	TEST_ASSERT_EQUAL(ambience.tile_cache_mismatches, mismatches_before + 1, "An unchanged answer must verify cleanly")
	var/before_unknown_change = ambience.static_version
	ambience.static_version++
	ambience.register_source(first, fire_category.type, volume_scale = 0.6)
	TEST_ASSERT(!ambience.can_reuse_tile_listener(far, before_unknown_change), "A global version gap must force refresh even when followed by a known distant change")
	var/before_known_change = ambience.static_version
	ambience.register_source(first, fire_category.type, volume_scale = 0.7)
	TEST_ASSERT(ambience.can_reuse_tile_listener(far, before_known_change), "A listener refreshed after a global gap may reuse a later known distant change")
	ambience.cross_floor = TRUE
	TEST_ASSERT(!ambience.can_reuse_tile_listener(far, before_known_change), "Cross-floor selection must retain global refresh")
	ambience.cross_floor = FALSE
	var/before_history_expiry = ambience.static_version
	for(var/change in 1 to 64)
		ambience.register_source(first, fire_category.type, volume_scale = 0.7 + change * 0.01)
	TEST_ASSERT(!ambience.can_reuse_tile_listener(far, before_history_expiry), "A listener older than the bounded history must refresh conservatively")
	ambience.set_tile_cache(FALSE)
	TEST_ASSERT(!ambience.can_reuse_tile_listener(far, ambience.static_version), "The uncached control must not use localized reuse")
	TEST_ASSERT_EQUAL(length(ambience.tile_cache), 0, "Disabling the cache must release its entries")

/datum/unit_test/point_ambience_tile_cache/Destroy()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	for(var/atom/source as anything in test_sources)
		ambience.unregister_source(source)
	test_sources.Cut()
	if(fire_category)
		fire_category.range = fire_range
		fire_category.silenced = fire_silenced
		torch_category.silenced = torch_silenced
		ambience.refresh_category_ranges()
		ambience.cross_floor = saved_cross_floor
		ambience.set_tile_cache(saved_use_tile_cache, saved_verify_tile_cache)
	return ..()
