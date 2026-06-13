/datum/objective/steal_items
	name = "偷窃物品"
	triumph_count = 0
	var/stolen_count = 0
	var/required_count = 3

/datum/objective/steal_items/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ITEM_STOLEN, PROC_REF(on_item_stolen))
	update_explanation_text()

/datum/objective/steal_items/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ITEM_STOLEN)
	return ..()

/datum/objective/steal_items/proc/on_item_stolen(datum/source, mob/living/victim)
	SIGNAL_HANDLER
	if(completed)
		return

	stolen_count++
	if(stolen_count >= required_count)
		to_chat(owner.current, span_greentext("你已偷到足够多的物品，完成了马西奥斯的目标！"))
		owner.current.adjust_triumphs(1)
		completed = TRUE
		adjust_storyteller_influence("Matthios", 10)
		escalate_objective()
		UnregisterSignal(owner.current, COMSIG_ITEM_STOLEN)
	else
		to_chat(owner.current, span_notice("已成功偷取物品！再偷 [required_count - stolen_count] 件即可完成马西奥斯的目标。"))

/datum/objective/steal_items/update_explanation_text()
	explanation_text = "从他人手中偷取 [required_count] 件物品，以向马西奥斯证明你的狡黠！"
