/datum/objective/create_abyssoids
	name = "创造阿比索体"
	triumph_count = 0
	var/abyssoids_created = 0
	var/abyssoids_required = 5

/datum/objective/create_abyssoids/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ABYSSOID_CREATED, PROC_REF(on_abyssoid_created))
	update_explanation_text()

/datum/objective/create_abyssoids/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ABYSSOID_CREATED)
	return ..()

/datum/objective/create_abyssoids/proc/on_abyssoid_created(datum/source)
	SIGNAL_HANDLER
	if(completed)
		return

	abyssoids_created++

	if(abyssoids_created >= abyssoids_required)
		complete_objective()
	else
		to_chat(owner.current, span_notice("已创造阿比索体！还需要 [abyssoids_required - abyssoids_created] 个阿比索体。"))

/datum/objective/create_abyssoids/proc/complete_objective()
	to_chat(owner.current, span_greentext("你已创造出足够的阿比索体，令阿比索尔感到满意！"))
	owner.current.adjust_triumphs(1)
	completed = TRUE
	adjust_storyteller_influence("Abyssor", 15)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_ABYSSOID_CREATED)

/datum/objective/create_abyssoids/update_explanation_text()
	explanation_text = "将常见水蛭转化为 [abyssoids_required] 个阿比索体，再把它们散布到那些忘恩负义的人群中！"
