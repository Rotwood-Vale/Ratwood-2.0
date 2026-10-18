// Cursed blood categories, matching the findings on a haemological report
#define BLOOD_VAMPIRE "Porphylick Haemophilia (Vampire)"
#define BLOOD_WEREWOLF "Liquid Madness Corrosion (Werewolf)"
#define BLOOD_GNOLL "Anthropophagic Corruption (Gnoll)"
#define BLOOD_HEMOPHAGE "Hemophage"
#define BLOOD_BLACKBLOOD "Stabilized Blackblood Tincture (Blackblood)"
#define BLOOD_PALLID "Consecrated Pallid Remnant (Pallid)"
#define BLOOD_ROTCURED "Resolved Necrotic Affliction (Rotcured)"

/client/proc/inquisitorial_matters()
	set name = "Inquisitorial Matters"
	set category = "-Admin-"
	set desc = "Show the current Inquisition, and every player with cursed blood grouped as a haemological report would find them."
	if(!check_rights(R_ADMIN))
		return
	holder.show_inquisitorial_matters()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Inquisitorial Matters")

/datum/admins/proc/show_inquisitorial_matters()
	if(!check_rights(R_ADMIN))
		return
	var/list/inquisitors = list()
	var/list/afflicted = list(
		BLOOD_VAMPIRE = list(),
		BLOOD_WEREWOLF = list(),
		BLOOD_GNOLL = list(),
		BLOOD_HEMOPHAGE = list(),
		BLOOD_BLACKBLOOD = list(),
		BLOOD_PALLID = list(),
		BLOOD_ROTCURED = list(),
	)
	for(var/datum/mind/M as anything in SSticker.minds)
		if(!M.key || !ishuman(M.current))
			continue
		var/mob/living/carbon/human/H = M.current
		if(HAS_TRAIT(H, TRAIT_INQUISITION) || HAS_TRAIT(H, TRAIT_PURITAN))
			inquisitors += M
		for(var/category in get_blood_afflictions(H))
			afflicted[category] += M

	var/dat = "<a href='?_src_=holder;[HrefToken()];inquisitorial_matters=1'>\[Refresh\]</a> <a href='?_src_=holder;[HrefToken()];view_inquisition_reports=1'>\[View Blood Reports\]</a><HR>"

	dat += "<B>The Inquisition</B>"
	dat += "<table cellspacing=5><tr><th>Ckey</th><th>Character</th><th>Role</th><th></th></tr>"
	for(var/datum/mind/M as anything in inquisitors)
		dat += "<tr><td>[inquisitorial_ckey(M)]</td><td>[inquisitorial_name(M)]</td><td>[inquisitorial_role(M)]</td><td>[ADMIN_PP(M.current)] [ADMIN_FLW(M.current)]</td></tr>"
	if(!length(inquisitors))
		dat += "<tr><td colspan=4>Nobody.</td></tr>"
	dat += "</table><HR>"

	dat += "<B>Cursed Blood</B><BR><BR>"
	for(var/category in afflicted)
		var/list/members = afflicted[category]
		dat += "<B>[category]</B>"
		dat += "<table cellspacing=5><tr><th>Ckey</th><th>Character</th><th>Role</th><th>Species</th><th>Blood Sold</th><th></th></tr>"
		for(var/datum/mind/M as anything in members)
			var/mob/living/carbon/human/H = M.current
			// TRAIT_CBLOOD is given once the Inquisition has paid out marques for this mind's cursed blood, and blocks any further payouts
			var/blood_sold = HAS_TRAIT(M, TRAIT_CBLOOD) ? "<font color='red'>Yes</font>" : "No"
			dat += "<tr><td>[inquisitorial_ckey(M)]</td><td>[inquisitorial_name(M)]</td><td>[inquisitorial_role(M)]</td><td>[H.dna?.species?.name || "N/A"]</td><td>[blood_sold]</td><td>[ADMIN_PP(H)] [ADMIN_FLW(H)]</td></tr>"
		if(!length(members))
			dat += "<tr><td colspan=6>Nobody.</td></tr>"
		dat += "</table><BR>"

	usr << browse(dat, "window=inquisitorial_matters;size=850x700")

/// The cursed blood categories a haemological report would find in this person. Mirrors the findings in /obj/item/paper/inquisition_report/proc/fill_report(),
/// plus Hemophages, whose blood the INDEXER still counts as cursed.
/datum/admins/proc/get_blood_afflictions(mob/living/carbon/human/H)
	. = list()
	for(var/datum/antagonist/D in H.mind?.antag_datums)
		if(istype(D, /datum/antagonist/vampire))
			. |= BLOOD_VAMPIRE
		else if(istype(D, /datum/antagonist/werewolf))
			. |= BLOOD_WEREWOLF
		else if(istype(D, /datum/antagonist/gnoll))
			. |= BLOOD_GNOLL
	if(HAS_TRAIT(H, TRAIT_HEMOPHAGE))
		. += BLOOD_HEMOPHAGE
	if(HAS_TRAIT(H, TRAIT_BLACKBLOOD))
		. += BLOOD_BLACKBLOOD
	if(HAS_TRAIT(H, TRAIT_PALLID))
		. += BLOOD_PALLID
	if(HAS_TRAIT(H, TRAIT_ROTMAN))
		. += BLOOD_ROTCURED

/datum/admins/proc/inquisitorial_ckey(datum/mind/M)
	return M.key ? ckey(M.key) : "no key"

/datum/admins/proc/inquisitorial_name(datum/mind/M)
	return "[M.name][M.current?.stat == DEAD ? " <font color='red'>(DEAD)</font>" : ""]"

/datum/admins/proc/inquisitorial_role(datum/mind/M)
	var/role = M.assigned_role || "None"
	if(M.current?.advjob)
		role += " ([M.current.advjob])"
	return role

/// Lists every haemological report mailed to the Inquisition this round, with a link to read each one.
/datum/admins/proc/show_inquisition_reports()
	if(!check_rights(R_ADMIN))
		return
	var/dat = "<B>Showing haemological reports mailed this round.</B><HR>"
	dat += "<table cellspacing=5><tr><th>Report</th><th>Time</th><th>Submitted By</th><th>Subject</th><th></th></tr>"
	for(var/id in GLOB.inquisition_reports)
		var/list/report = GLOB.inquisition_reports[id]
		dat += "<tr><td>#[id]</td><td>[report["time"]]</td><td>[report["submitter"]]</td><td>[report["subject"]]</td><td><a href='?_src_=holder;[HrefToken()];view_inquisition_report=[id]'>\[View\]</a></td></tr>"
	if(!length(GLOB.inquisition_reports))
		dat += "<tr><td colspan=5>No blood reports have been mailed this round.</td></tr>"
	dat += "</table>"
	usr << browse(dat, "window=inquisition_reports;size=700x500")

#undef BLOOD_VAMPIRE
#undef BLOOD_WEREWOLF
#undef BLOOD_GNOLL
#undef BLOOD_HEMOPHAGE
#undef BLOOD_BLACKBLOOD
#undef BLOOD_PALLID
#undef BLOOD_ROTCURED
