/datum/objective/wise_trees
	name = "创造贤树"
	triumph_count = 0
	var/trees_transformed = 0
	var/trees_required = 3

/datum/objective/wise_trees/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_TREE_TRANSFORMED, PROC_REF(on_tree_transformed))
	update_explanation_text()

/datum/objective/wise_trees/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_TREE_TRANSFORMED)
	return ..()

/datum/objective/wise_trees/proc/on_tree_transformed(datum/source)
	SIGNAL_HANDLER
	if(completed)
		return

	trees_transformed++
	to_chat(owner.current, span_green("树木已转化！还需要 [trees_required - trees_transformed] 棵树。"))

	if(trees_transformed >= trees_required)
		complete_objective()

/datum/objective/wise_trees/proc/complete_objective()
	to_chat(owner.current, span_greentext("你已创造出足够多的贤树，令登多尔感到满意！"))
	owner.current.adjust_triumphs(1)
	completed = TRUE
	adjust_storyteller_influence("Dendor", 15)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_TREE_TRANSFORMED)

/datum/objective/wise_trees/update_explanation_text()
	explanation_text = "借助登多尔的赐福，将 [trees_required] 棵普通树木转化为守护贤树。"
