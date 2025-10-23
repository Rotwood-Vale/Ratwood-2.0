// Minimal purchase logging to support the uplink component

GLOBAL_LIST_EMPTY(uplink_purchase_logs_by_key)

/datum/uplink_purchase_log
	var/key
	var/total_spent = 0
	var/datum/component/uplink/uplink
	var/list/entries = list()

/datum/uplink_purchase_log/New(owner_key, datum/component/uplink/U)
	key = owner_key
	uplink = U

/datum/uplink_purchase_log/proc/LogPurchase(atom/A, datum/uplink_item/I, cost)
	if(!I || isnull(cost))
		return
	total_spent += cost
	entries += list(list("name" = initial(I.name), "cost" = cost, "atom" = WEAKREF(A)))

/datum/uplink_purchase_log/proc/MergeWithAndDel(datum/uplink_purchase_log/other)
	if(!istype(other))
		return
	total_spent += other.total_spent
	for(var/E in other.entries)
		entries += E
	qdel(other)
