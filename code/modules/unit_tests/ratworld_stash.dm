// Ratworld stash unit test
/datum/unit_test/ratworld_stash/Run()
    // Setup: allocate a human in test area
    var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human)
    H.key = "ratworld_unittest" // creates client, gives H.client.ckey

    // Pre-condition: stash exists and starts with non-negative counts
    var/datum/ratworld/stash/S = ratworld_get_stash(H.client.ckey)
    if(!S)
        return Fail("Failed to acquire stash datum")
    if(S.items && S.items.len < 0)
        return Fail("Invalid starting stash item count")

    // Allocate an item and deposit it
    var/obj/item/I = allocate(/obj/item)
    var/initial_count = S.items.len
    if(!ratworld_deposit_item(H, I))
        return Fail("Deposit proc returned FALSE")

    // Reload stash to reflect persistence
    S = ratworld_get_stash(H.client.ckey)
    if(S.items.len != initial_count + 1)
        return Fail("Item count did not increment after deposit (expected [initial_count + 1], got [S.items.len])")

    // Capture UID
    var/item_uid
    for(var/uid in S.items)
        item_uid = uid; break
    if(!item_uid)
        return Fail("No UID found in stash after deposit")

    // Withdraw
    if(!ratworld_withdraw_item(H, item_uid))
        return Fail("Withdraw proc returned FALSE")
    S = ratworld_get_stash(H.client.ckey)
    if(S.items.len != initial_count)
        return Fail("Item count did not decrement after withdraw (expected [initial_count], got [S.items.len])")

    // Success implicitly passes (no Fail calls)
    return
