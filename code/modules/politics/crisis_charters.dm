// Crisis charters: foreign-imposed decrees used on Peasant Rebel rounds.
//
// A crisis charter is a /datum/decree that starts INACTIVE and is imposed at round start
// (impose()). While its goal is incomplete it is goal-locked: the Lord can only revoke it by
// confirming an explicit act of defiance, which fires apply_defiance_penalty(). Once the goal
// is complete the charter unlocks and can be revoked for free (or auto-releases, if
// auto_release is set). A rebel ruler can always revoke for free - that is the win path.
//
// CONFIRM markers below are things I could not see in the uploaded files.
// The floor applies to POLL TAX (mammon/day, POLL_TAX_CAT_*). The Lord's max is POLL_TAX_MAX_RATE
// (40), so the floor of 50 sits above anything they can set. Yeomen are in POLL_TAX_CAT_BURGHER,
// peasants in POLL_TAX_CAT_PEASANT. The floor is applied AFTER caps and exemptions, so it
// overrides the Golden Bull's burgher poll cap for yeoman jobs only.

#ifndef DECREE_CATEGORY_CRISIS
#define DECREE_CATEGORY_CRISIS "crisis"
#endif

#define DECREE_CRISIS_GRENZELHOFT "crisis_grenzelhoft"

#define CRISIS_POLL_PERIOD (30 SECONDS)
#define CRISIS_PROGRESS_DEADLINE (60 MINUTES) // if no progress has been made by now, the obligation fails

// Grenzelhoft debt tuning
#define CRISIS_DEBT_RATE_FLOOR 50 // mammon/day; POLL_TAX_MAX_RATE is 40
#define CRISIS_DEBT_TARGET 5000 // Crown's Purse must hold this (it starts around 1,500)

// ---------------------------------------------------------------------------------------------
// Goal datum
// ---------------------------------------------------------------------------------------------

/datum/crisis_goal
	var/name = "Obligation"
	var/desc = "An obligation."
	var/is_complete = FALSE
	var/datum/decree/crisis/charter
	var/poll_timer
	var/deadline_timer
	/// FALSE = no progress deadline (e.g. a second-chance obligation that must not fail again).
	var/use_deadline = TRUE
	/// Fraction of the goal (0 to 1) that must be exceeded by the deadline. 0 = any progress at all.
	var/deadline_min_fraction = 0

/datum/crisis_goal/New(datum/decree/crisis/new_charter)
	. = ..()
	charter = new_charter

/datum/crisis_goal/Destroy(force, ...)
	stop()
	charter = null
	return ..()

/// Called once when the charter is imposed. Set targets here, then start polling.
/datum/crisis_goal/proc/begin()
	if(use_deadline)
		deadline_timer = addtimer(CALLBACK(src, PROC_REF(check_deadline)), CRISIS_PROGRESS_DEADLINE, TIMER_STOPPABLE)
	poll()

/datum/crisis_goal/proc/stop()
	if(poll_timer)
		deltimer(poll_timer)
		poll_timer = null
	if(deadline_timer)
		deltimer(deadline_timer)
		deadline_timer = null

/// Progress as a fraction of the goal, 0 to 1. Override per goal.
/datum/crisis_goal/proc/get_progress_fraction()
	return 0

/// Runs once at the deadline: no progress means the obligation fails.
/datum/crisis_goal/proc/check_deadline()
	deadline_timer = null
	if(is_complete || QDELETED(charter) || !charter.active)
		return
	if(get_progress_fraction() > deadline_min_fraction)
		return
	charter.fail_obligation()

/datum/crisis_goal/proc/poll()
	poll_timer = null
	if(is_complete)
		return
	if(check_completion())
		mark_complete()
		return
	poll_timer = addtimer(CALLBACK(src, PROC_REF(poll)), CRISIS_POLL_PERIOD, TIMER_STOPPABLE)

/datum/crisis_goal/proc/mark_complete()
	if(is_complete)
		return
	is_complete = TRUE
	stop()
	charter?.on_goal_complete()

/// Override per goal. Return TRUE when the obligation is met.
/datum/crisis_goal/proc/check_completion()
	return FALSE

/// Short status string shown on the charter, e.g. "1200/3000 mammon".
/datum/crisis_goal/proc/get_progress_text()
	return is_complete ? "fulfilled" : "unfulfilled"

// --- Treasury target (Grenzelhoft debt) ---

/datum/crisis_goal/treasury_target
	name = "Settle the Debt"
	var/target = 0
	var/start_balance = 0

/datum/crisis_goal/treasury_target/begin()
	target = CRISIS_DEBT_TARGET
	start_balance = SStreasury.discretionary_fund.balance
	desc = "The Crown's Purse must hold [target] mammon to settle the debt."
	. = ..()

// Threshold on the Crown's Purse balance, so a Lord who stops spending also counts as progress.
// For a cumulative "seized" count, track it from the tax collection proc instead.
/datum/crisis_goal/treasury_target/check_completion()
	return SStreasury.discretionary_fund.balance >= target

/// Normal income raises the balance too, so "any progress" is easy to meet here. Set
/// deadline_min_fraction (e.g. 0.25) if you want the debt to demand a real share by the deadline.
/datum/crisis_goal/treasury_target/get_progress_fraction()
	var/span = target - start_balance
	if(span <= 0)
		return 1
	return CLAMP((SStreasury.discretionary_fund.balance - start_balance) / span, 0, 1)

/datum/crisis_goal/treasury_target/get_progress_text()
	return "[min(SStreasury.discretionary_fund.balance, target)]/[target] mammon"

// ---------------------------------------------------------------------------------------------
// Crisis charter base
// ---------------------------------------------------------------------------------------------

/datum/decree/crisis
	category = DECREE_CATEGORY_CRISIS
	active = FALSE
	// id is intentionally unset: init_decrees skips id-less (abstract) types.
	var/goal_type
	var/datum/crisis_goal/goal
	var/imposed_text
	var/goal_complete_text
	/// A decree this crisis suspends while it is imposed (e.g. DECREE_GOLDEN_BULL). It cannot be
	/// restored until the obligation is met or the charter lifts.
	var/held_decree_id
	var/datum/decree/held_decree
	/// FALSE = never offered in the round-start choice (follow-up charters imposed by another crisis).
	var/offerable = TRUE
	/// Name shown to the Lord in the round-start crisis choice.
	var/crisis_title
	/// Private briefing shown to the Lord with the choice.
	var/duke_briefing
	var/defiance_warning = "Defying this charter before its obligation is met will bring ruin upon the realm."
	/// TRUE = goal completion auto-suspends the charter. FALSE = it just unlocks and the Lord chooses.
	var/auto_release = FALSE
	/// Set by confirm_defiance for a penalty-free revoke (rebel ruler). Consumed by on_revoke.
	var/free_revocation = FALSE
	/// TRUE while a defiance prompt is open, so repeated UI clicks can't stack prompts.
	var/defiance_prompting = FALSE
	/// Minimum tax rate imposed on floored payers (same units as the cap defines).
	var/rate_floor = 0
	/// Poll tax categories the floor can apply to (POLL_TAX_CAT_*). Empty = all categories.
	var/list/floor_categories = list()
	/// Categories where the Lord's tax UI is clamped at category level (payer-less query).
	/// Leave out shared categories: POLL_TAX_CAT_BURGHER also holds real burghers, so only
	/// the collection side (per payer, by job) can floor yeomen without hitting them.
	var/list/ui_floor_categories = list()

/datum/decree/crisis/roll_initial_year()
	return CALENDAR_EPOCH_YEAR

/// Whether this crisis can be offered to the Lord this round (enough players, a Lord, etc).
/datum/decree/crisis/proc/is_available()
	return TRUE

/// Suspends held_decree_id (silently, with no revoke broadcast) and blocks its restoration.
/datum/decree/crisis/proc/hold_decree()
	if(!held_decree_id)
		return
	var/datum/decree/D = SStreasury.get_decree(held_decree_id)
	if(!D)
		return
	held_decree = D
	if(D.active)
		var/saved_revoke_text = D.revoke_text
		D.revoke_text = null
		D.set_state(FALSE)
		D.revoke_text = saved_revoke_text
	D.held_by = src

/// Lets the held decree be restored again by the Lord. Safe to call more than once.
/datum/decree/crisis/proc/release_held_decree()
	if(held_decree)
		held_decree.held_by = null
	held_decree = null

/// Called at the end of impose(), after the goal exists.
/datum/decree/crisis/proc/on_imposed()
	return

/// Called when the obligation ends: goal complete or charter revoked. Must be idempotent.
/datum/decree/crisis/proc/on_obligation_ended()
	return

/// Jobs the floor applies to. Override per charter.
/datum/decree/crisis/proc/get_floored_jobs()
	return list()

/// Imposes the charter (round start). Silent to the decree cooldown/limits on purpose.
/datum/decree/crisis/proc/impose()
	if(active)
		return FALSE
	active = TRUE
	has_ever_been_active = TRUE
	year = CALENDAR_EPOCH_YEAR
	SStreasury.active_crisis = src
	if(goal_type)
		goal = new goal_type(src)
		goal.begin()
	hold_decree()
	on_imposed()
	if(imposed_text)
		priority_announce(fill_decree_tokens(imposed_text), "BY FOREIGN DECREE", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")
	return TRUE

/datum/decree/crisis/is_goal_locked()
	return active && goal && !goal.is_complete

/// Hidden from the Charters UI until it has been imposed.
/datum/decree/crisis/is_listed()
	return has_ever_been_active

/// An imposed charter can't be re-imposed by the Lord once revoked.
/datum/decree/crisis/can_change_state()
	if(!active)
		return FALSE
	return ..()

/datum/decree/crisis/confirm_defiance(mob/user)
	free_revocation = FALSE
	if(!is_goal_locked())
		return TRUE
	// Rebel ruler: free revoke. This is the win path.
	if(user?.mind && (user.mind.has_antag_datum(/datum/antagonist/prebel) || user.mind.has_antag_datum(/datum/antagonist/prebel/head)))
		free_revocation = TRUE
		return TRUE
	if(defiance_prompting)
		return FALSE
	defiance_prompting = TRUE
	var/choice = alert(user, defiance_warning, "Defy [name]?", "Defy", "Stand down")
	defiance_prompting = FALSE
	// If the goal completed while the prompt was open, on_revoke sees it and skips the penalty.
	return choice == "Defy"

/datum/decree/crisis/on_revoke()
	var/penalize = goal && !goal.is_complete && !free_revocation
	goal?.stop()
	free_revocation = FALSE
	if(penalize)
		apply_defiance_penalty()
	release_held_decree()
	on_obligation_ended()

/datum/decree/crisis/proc/on_goal_complete()
	release_held_decree()
	on_obligation_ended()
	if(goal_complete_text)
		priority_announce(fill_decree_tokens(goal_complete_text), "BY FOREIGN DECREE", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")
	if(auto_release && active)
		set_state(FALSE)

/// The deadline passed with no progress: the foreign power loses patience. Applies the same
/// penalty as defiance, then lifts the charter (without the player-facing revoke broadcast).
/datum/decree/crisis/proc/fail_obligation()
	if(!active || !goal || goal.is_complete)
		return
	priority_announce("The deadline has passed with no progress upon [name]. The patience of its patrons is at an end.", "BY FOREIGN DECREE", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")
	goal.stop()
	apply_defiance_penalty()
	free_revocation = TRUE // the penalty is already paid: on_revoke must not apply it again
	var/saved_revoke_text = revoke_text
	revoke_text = null
	set_state(FALSE)
	revoke_text = saved_revoke_text

/// Override per charter: what happens when the Lord defies it early.
/datum/decree/crisis/proc/apply_defiance_penalty()
	return

/// Shown on the charter card in the Charters UI.
/datum/decree/crisis/get_goal_text()
	if(!goal)
		return null
	return "[goal.desc] ([goal.get_progress_text()])"

/datum/decree/crisis/apply_poll_tax_floor(mob/living/payer, poll_category, current_rate)
	if(!active || !rate_floor)
		return current_rate
	if(length(floor_categories) && !(poll_category in floor_categories))
		return current_rate
	if(payer)
		if(!(payer.job in get_floored_jobs()))
			return current_rate
	else if(!(poll_category in ui_floor_categories))
		// payer is null: category-level query (the Lord's poll-rate screen).
		return current_rate
	return max(current_rate, rate_floor)

// ---------------------------------------------------------------------------------------------
// Grenzelhoft debt
// ---------------------------------------------------------------------------------------------

/datum/decree/crisis/grenzelhoft_debt
	id = DECREE_CRISIS_GRENZELHOFT
	name = "The Grenzelhoft Debt Covenant"
	crisis_title = "Indebted to Grenzelhoft"
	duke_briefing = "The Crown owes the Grenzelhoft bankers. Peasant and yeoman poll taxes are locked at a punishing rate until the Crown's Purse holds enough mammon to settle the debt. Defy the covenant early and the creditors will bankrupt the duchy."
	mechanical_text = "Peasant and yeoman taxes cannot fall below the covenant rate until the debt is settled. Defying the covenant early throws the Crown into sequestration."
	flavor_text = "Let it be known that the Crown stands in arrears to the bankers of the Grenzelhoft Imperiate. By this covenant the %RULER% binds the Vale's common folk to a heavy levy until the sum is made whole. Should the Crown break faith before the debt is settled, the creditors shall take their due from the Crown's own coffers."
	imposed_text = "Agents of the Grenzelhoft Imperiate have called the Crown's debts. A heavy levy is placed upon the common folk until the sum is settled."
	goal_complete_text = "The Crown's debt to the Grenzelhoft Imperiate has been settled. The covenant's levy may now be lifted."
	revoke_text = "The %RULER% has set aside the Grenzelhoft Debt Covenant. The levy upon the common folk is lifted."
	defiance_warning = "If you defy the covenant before the debt is settled, the Grenzelhoft creditors will call the Crown's debts and the treasury will be placed in sequestration."
	goal_type = /datum/crisis_goal/treasury_target
	rate_floor = CRISIS_DEBT_RATE_FLOOR
	floor_categories = list(POLL_TAX_CAT_PEASANT, POLL_TAX_CAT_BURGHER)
	ui_floor_categories = list(POLL_TAX_CAT_PEASANT)

/datum/decree/crisis/grenzelhoft_debt/get_floored_jobs()
	return GLOB.peasant_positions + GLOB.yeoman_positions

/datum/decree/crisis/grenzelhoft_debt/apply_defiance_penalty()
	// The creditors take everything in the Crown's Purse first, so the duchy enters bankruptcy
	// the way it normally would: with the treasury run dry. enter_bankruptcy() is the same proc
	// distribute_daily_payments() calls on a failed payroll, so the state change, debt and
	// concession picks are whatever it already does.
	var/seized = round(SStreasury.discretionary_fund.balance)
	if(seized > 0)
		SStreasury.burn(SStreasury.discretionary_fund, seized, "Seized by Grenzelhoft creditors - breach of covenant")
	if(SStreasury.treasury_state == TREASURY_BANKRUPTCY)
		return
	var/amount_text = seized > 0 ? " ([seized] mammon)" : ""
	priority_announce("The Grenzelhoft creditors, finding the covenant broken, have seized the Crown's treasury[amount_text] and called its debts in full. The treasury is placed in sequestration.", "BY FOREIGN DECREE", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")
	SStreasury.enter_bankruptcy()

// ---------------------------------------------------------------------------------------------
// Treasury glue
// ---------------------------------------------------------------------------------------------

/// Lets every active decree raise a poll rate to its floor. payer may be null (category-level).
/datum/controller/subsystem/treasury/proc/apply_decree_poll_tax_floors(mob/living/payer, poll_category, rate)
	for(var/decree_id in decrees)
		var/datum/decree/D = decrees[decree_id]
		if(!D?.active)
			continue
		rate = D.apply_poll_tax_floor(payer, poll_category, rate)
	return rate

/// TRUE if a decree binds this category's poll rate at category level (Lord can't edit it).
/datum/controller/subsystem/treasury/proc/is_poll_rate_bound(poll_category)
	return apply_decree_poll_tax_floors(null, poll_category, 0) > 0

/// Imposes a crisis charter by id. Call at round start from the peasant rebel setup.
/datum/controller/subsystem/treasury/proc/impose_crisis(crisis_id)
	var/datum/decree/crisis/C = get_decree(crisis_id)
	if(!istype(C))
		return FALSE
	return C.impose()
