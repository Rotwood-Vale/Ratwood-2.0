// AP Quest 2 port (Chunk 4) - job / treasury / logging glue for the questing system.
// New vars are declared out-of-block on existing core types (no proc redefinition); the procs
// and GLOBs are all new. Keeps the touch on _job.dm/treasury.dm/job.dm to a minimum.

// ---- /datum/job quest vars (AP _job.dm:171-180) ----
/datum/job/var/is_quest_giver = FALSE           // cosmetic ledger "handler" flag
/datum/job/var/max_active_quests = 2            // pool-contract cap for this job
/datum/job/var/townie_contract_gate_exempt = FALSE  // bypasses the early-round townie gate
/datum/job/var/quest_claim_barred = FALSE       // may never claim pool contracts (issuers)

// ---- /datum/advclass townie-gate vars (AP _advclass.dm:6-7) ----
/datum/advclass/var/townie_contract_gate_exempt = FALSE
/datum/advclass/var/townie_contract_gate_hide_in_list = FALSE

// ---- Tavern positions: the load-bearing hook that opens the innkeeper rumor tab ----
GLOBAL_LIST_INIT(tavern_positions, list("Innkeeper", "Tapster", "Cook"))

// ---- Contract-claim gates (AP _job.dm:182/188) ----
/proc/is_quest_claim_barred(mob/user)
	if(!user?.mind)
		return FALSE
	var/datum/job/J = user.job ? SSjob.GetJob(user.job) : null
	return J?.quest_claim_barred ? TRUE : FALSE

/proc/is_townie_contract_gate_exempt(mob/user)
	if(!user?.mind)
		return FALSE
	var/datum/job/J = user.job ? SSjob.GetJob(user.job) : null
	if(J?.townie_contract_gate_exempt)
		return TRUE
	// ES deviation: the picked adventurer class is retained as a name string in mob.advjob
	// (not a /datum on the mind as in AP); resolve it the way ES's own merc code does.
	if(user.advjob)
		var/datum/advclass/AC = SSrole_class_handler.get_advclass_by_name(user.advjob)
		if(!QDELETED(AC) && AC.townie_contract_gate_exempt)
			return TRUE
	return FALSE

// ---- SSjob townie-gate-exempt name cache (ledger "exempt roles" display; AP job.dm:27-44) ----
/datum/controller/subsystem/job/var/list/townie_contract_gate_exempt_names = list()

/datum/controller/subsystem/job/proc/build_townie_contract_gate_exempt_cache()
	townie_contract_gate_exempt_names = list()
	for(var/datum/job/J as anything in occupations)
		if(J.townie_contract_gate_exempt)
			townie_contract_gate_exempt_names |= J.title
	for(var/path in subtypesof(/datum/advclass))
		var/datum/advclass/AC = path
		if(!initial(AC.townie_contract_gate_exempt) || !initial(AC.name))
			continue
		if(initial(AC.townie_contract_gate_hide_in_list))
			continue
		townie_contract_gate_exempt_names |= initial(AC.name)
	sortTim(townie_contract_gate_exempt_names, /proc/cmp_text_asc)

/datum/controller/subsystem/job/proc/townie_contract_gate_exempt_display_names()
	return townie_contract_gate_exempt_names

// ---- Treasury rumor-point state (innkeeper rumor economy; AP treasury.dm:123-125,479) ----
/datum/controller/subsystem/treasury/var/rumor_points = RUMOR_POINTS_START
/datum/controller/subsystem/treasury/var/list/rumor_log = list()
/datum/controller/subsystem/treasury/var/list/rumor_issued_today = list()
/// Chunk 6: running log of blockade-defense commissions/directives issued by the Steward.
/datum/controller/subsystem/treasury/var/list/defense_log = list()

/datum/controller/subsystem/treasury/proc/tick_rumor_points()
	var/active = get_active_player_count()
	var/refill = RUMOR_POINTS_BASE_REFILL + (RUMOR_POINTS_PER_PLAYER * active)
	var/before = rumor_points
	rumor_points += refill
	var/ceiling = RUMOR_POINTS_CLAWBACK_MULTIPLIER * refill
	if(rumor_points > ceiling)
		rumor_points = ceiling
	record_round_statistic(STATS_RUMOR_POINTS_GENERATED, rumor_points - before)

// ---- Quest logging helper (AP _logging.dm:103; ES routes through log_game) ----
// NOTE: quest_recovery_shipments is now the real GLOBAL_LIST_INIT in types/kill/quest_recovery.dm
// (Chunk 5). The Chunk 4 stub that lived here has been removed.
