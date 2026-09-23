
#define ROUND_END_FILE_PATH "status/roundend.json"

/proc/round_end_status_file()
	var/list/status_data = list()
	status_data["round"] = GLOB.rogue_round_id
	status_data["roundTime"] = time2text(STATION_TIME_PASSED(), "hh:mm:ss", 0)

	var/json_output = json_encode(status_data)

	if(fexists(ROUND_END_FILE_PATH))
		fdel(ROUND_END_FILE_PATH)

	text2file(json_output, ROUND_END_FILE_PATH)

