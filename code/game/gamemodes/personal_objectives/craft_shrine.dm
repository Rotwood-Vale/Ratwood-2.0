/datum/objective/craft_shrine
	name = "建造神龛"
	triumph_count = 0
	var/target_type = /obj/structure/fluff/psycross/crafted
	var/target_count = 2
	var/current_count = 0

/datum/objective/craft_shrine/New(text, datum/mind/owner, obj/target_path, count)
	if(target_path)
		target_type = target_path
	if(count)
		target_count = count
	. = ..()

/datum/objective/craft_shrine/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ITEM_CRAFTED, PROC_REF(on_item_crafted))
	update_explanation_text()

/datum/objective/craft_shrine/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ITEM_CRAFTED)
	return ..()

/datum/objective/craft_shrine/proc/on_item_crafted(datum/source, mob/user, craft_path)
	SIGNAL_HANDLER
	if(completed || !ispath(craft_path, target_type))
		return

	current_count++
	if(current_count < target_count)
		to_chat(owner.current, span_notice("你已建成 [current_count]/[target_count] 座神圣十字。"))
		return

	to_chat(owner.current, span_greentext("你已建成全部所需的神圣十字，完成了玛勒姆的目标！"))
	owner.current.adjust_triumphs(2)
	completed = TRUE
	adjust_storyteller_influence("Malum", 10)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_ITEM_CRAFTED)

/datum/objective/craft_shrine/update_explanation_text()
	explanation_text = "建造 [target_count] 座木制万神十字，以彰显你对玛勒姆的虔敬。"
