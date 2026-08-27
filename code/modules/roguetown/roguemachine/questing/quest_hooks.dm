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

// ---- Bathhouse positions (AP jobs.dm): facilitator checks for the blackmarket navigator ----
GLOBAL_LIST_INIT(bathhouse_positions, list(
	"Bathmaster",
	"Bathhouse Attendant",
))

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
	// Ratwood deviation: the picked adventurer class is retained as a name string in mob.advjob
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
