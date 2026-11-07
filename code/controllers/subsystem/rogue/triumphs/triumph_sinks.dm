/*
	TRIUMPH SINKS
	Tallies triumphs spent per source for the wipe season, so admins can see where triumphs go.
	Spending only touches the in-memory list. The file is read at init and written at round end with the leaderboard.
	Sources are defined in code/__DEFINES/roguetown.dm (TRIUMPH_SINK_SOURCES).
*/

/datum/controller/subsystem/triumphs/proc/get_triumph_sinks_file()
	return file("data/triumph_sinks/triumph_sinks_season_[GLOB.triumph_wipe_season].json")

/datum/controller/subsystem/triumphs/proc/load_triumph_sinks()
	var/json_file = get_triumph_sinks_file()
	if(!fexists(json_file))
		return
	var/list/loaded = json_decode(file2text(json_file))
	if(islist(loaded))
		triumph_sinks = loaded

/datum/controller/subsystem/triumphs/proc/save_triumph_sinks()
	var/json_file = get_triumph_sinks_file()
	if(fexists(json_file))
		fdel(json_file)
	WRITE_FILE(json_file, json_encode(triumph_sinks))

/// Records amount triumphs spent on source. Pass a TRIUMPH_SINK_* define.
/datum/controller/subsystem/triumphs/proc/record_triumph_sink(source, amount)
	if(!source || amount <= 0)
		return
	triumph_sinks[source] += amount

/client/proc/triumphs_panel()
	set category = "-Admin-"
	set name = "Triumphs"
	if(!holder)
		return
	var/dat = "<a href='byond://?_src_=holder;[HrefToken()];triumph_sinks=1'>Show triumph sinks</a>"
	var/datum/browser/popup = new(src, "triumphs_panel", "Triumphs", 300, 200)
	popup.set_content(dat)
	popup.open()

/client/proc/show_triumph_sinks()
	if(!holder)
		return
	var/list/totals = list()
	for(var/source in TRIUMPH_SINK_SOURCES)
		totals[source] = SStriumphs.triumph_sinks[source] || 0
	sortTim(totals, GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)

	var/list/dat = list("<b>Triumph sinks: season [GLOB.triumph_wipe_season]</b>")
	dat += " <a href='byond://?_src_=holder;[HrefToken()];triumph_sinks=1'>Refresh</a><hr>"
	dat += "<table style='width: 100%;'><tr><th style='text-align: left;'>Source</th><th style='text-align: right;'>Triumphs used</th></tr>"
	for(var/source in totals)
		dat += "<tr><td>[source]</td><td style='text-align: right;'>[totals[source]]</td></tr>"
	dat += "</table>"
	var/datum/browser/popup = new(src, "triumph_sinks", "Triumph Sinks", 400, 400)
	popup.set_content(dat.Join())
	popup.open()
