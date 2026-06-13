/datum/objective/build_zizo_shrine
	name = "建造亵渎神龛"
	triumph_count = 0
	var/target_type = /obj/structure/fluff/psycross/zizocross
	var/target_count = 2
	var/current_count = 0

/datum/objective/build_zizo_shrine/on_creation()
	. = ..()
	if(owner?.current)
		owner.current.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/structure/zizo_shrine)
		RegisterSignal(owner.current, COMSIG_ITEM_CRAFTED, PROC_REF(on_item_crafted))
	update_explanation_text()

/datum/objective/build_zizo_shrine/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ITEM_CRAFTED)
	return ..()

/datum/objective/build_zizo_shrine/proc/on_item_crafted(datum/source, mob/user, craft_path)
	SIGNAL_HANDLER
	if(completed || !ispath(craft_path, target_type))
		return

	current_count++
	if(current_count < target_count)
		to_chat(owner.current, span_notice("你已建成 [current_count]/[target_count] 座亵渎神龛。"))
		return

	to_chat(owner.current, span_greentext("你已建成全部所需的亵渎神龛，完成了齐佐的目标！"))
	owner.current.adjust_triumphs(1)
	completed = TRUE
	adjust_storyteller_influence("Zizo", 15)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_ITEM_CRAFTED)

/datum/objective/build_zizo_shrine/update_explanation_text()
	explanation_text = "建造 [target_count] 座亵渎神龛，将齐佐的腐化传播出去！"
