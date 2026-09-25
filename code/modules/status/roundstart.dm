
#define ROUND_START_FILE_PATH "status/roundstart.json"

/proc/round_start_status_file()
	var/list/status_data = list()
	status_data["round"] = GLOB.rogue_round_id

	var/json_output = json_encode(status_data)

	if(fexists(ROUND_START_FILE_PATH))
		fdel(ROUND_START_FILE_PATH)

	text2file(json_output, ROUND_START_FILE_PATH)

