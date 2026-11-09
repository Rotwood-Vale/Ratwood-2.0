/datum/job/roguetown/ashen_host
	title = "Ashen Host"
	flag = ASHENHOST
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	antag_job = TRUE
	allowed_races = RACES_ALL_KINDS
	tutorial = "You are a soldier of the Ashen Host, sworn to its Commander and the cause of the Host."
	outfit = null
	outfit_female = null
	display_order = JDO_WRETCH
	show_in_credits = FALSE
	min_pq = 5
	max_pq = null
	obsfuscated_job = TRUE
	class_categories = TRUE
	advclass_cat_rolls = list(CTAG_ASHEN = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2
	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = FALSE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_OUTLAW, TRAIT_HERESIARCH, TRAIT_SELF_SUSTENANCE, TRAIT_ASHEN_HOST, TRAIT_CABAL)
	job_subclasses = list(
		/datum/advclass/ashen_host/hollow,
		/datum/advclass/ashen_host/hollow_ballistiares,
		/datum/advclass/ashen_host/legionary,
		/datum/advclass/ashen_host/speculator,
		/datum/advclass/ashen_host/haruspex,
		/datum/advclass/ashen_host/praetorian,
		/datum/advclass/ashen_host/herald_of_progress,
		/datum/advclass/ashen_host/commander,
	)

/datum/job/roguetown/ashen_host/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(!ishuman(L) || !L.mind)
		return
	var/mob/living/carbon/human/H = L
	H.set_patron(/datum/patron/inhumen/zizo)
	H.faction += "Ashen Host"
	RegisterSignal(H, COMSIG_PARENT_EXAMINE, PROC_REF(ashen_host_examine))
	ADD_TRAIT(H, TRAIT_LICHLAIR, TRAIT_GENERIC)
	if(!H.mind.has_antag_datum(/datum/antagonist/ashen_host))
		H.mind.add_antag_datum(new /datum/antagonist/ashen_host())
	H.ambushable = FALSE

/datum/job/roguetown/ashen_host/proc/ashen_host_examine(mob/living/carbon/human/target, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!ishuman(user) || !("Ashen Host" in target.faction) || !("Ashen Host" in user.faction))
		return
	if(target.mind?.has_antag_datum(/datum/antagonist/ashen_host/leader))
		examine_list += span_notice("<i>The Legate of the Ashen Host.</i>")
		return
	if(target.advjob == "Ancient Champion")
		examine_list += span_notice("<i>A fellow Ashen Host soldier. An Ashen Praetorian, veteran of the Godslaying War!</i>")
		return
	examine_list += span_notice("<i>A fellow Ashen Host soldier. They serve as an [target.advjob].</i>")

/datum/antagonist/ashen_host
	name = "Ashen Host"
	roundend_category = "Ashen Host"
	antagpanel_category = "Ashen Host"
	job_rank = ROLE_ASHEN_HOST
	rogue_enabled = TRUE

/datum/antagonist/ashen_host/on_gain()
	. = ..()
	if(owner)
		owner.special_role = name

/datum/antagonist/ashen_host/on_removal()
	var/datum/mind/old_owner = owner
	. = ..()
	if(old_owner && old_owner.special_role == name)
		old_owner.special_role = null

/datum/antagonist/ashen_host/leader
	name = "Ashen Host Commander"
	antagpanel_category = "Ashen Host"
