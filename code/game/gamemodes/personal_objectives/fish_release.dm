/datum/objective/release_fish
	name = "放生稀有鱼类"
	triumph_count = 0
	var/released_count = 0
	var/required_count = 1
	var/required_rarity_rank = 1

/datum/objective/release_fish/on_creation()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOBAL_FISH_RELEASED, PROC_REF(on_fish_released))
	update_explanation_text()

/datum/objective/release_fish/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_FISH_RELEASED)
	return ..()

/datum/objective/release_fish/proc/on_fish_released(datum/source, fish_type, raritymod)
	SIGNAL_HANDLER
	if(completed || !owner?.current)
		return

	if(!(raritymod >= required_rarity_rank))
		return

	released_count++
	if(released_count >= required_count)
		complete_objective()

/datum/objective/release_fish/proc/complete_objective()
	to_chat(owner.current, span_greentext("一条稀有鱼类已重归深水，令阿比索尔感到欣喜！"))
	owner.current.adjust_triumphs(2)
	completed = TRUE
	adjust_storyteller_influence("Abyssor", 15)
	escalate_objective()
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_FISH_RELEASED)

/datum/objective/release_fish/update_explanation_text()
	explanation_text = "让任意一条稀有或更高品质的鱼类重返水中，以此敬奉阿比索尔。"
