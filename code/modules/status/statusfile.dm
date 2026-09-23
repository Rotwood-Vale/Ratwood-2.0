
#define STATUS_FILE_PATH "status/status.json"

/proc/status_file_loop()
	while(world)
		var/list/status_data = list()
		status_data["round"] = GLOB.rogue_round_id
		status_data["playerCount"] = GLOB.clients.len
		status_data["lobby"] = SSticker.current_state <= GAME_STATE_PREGAME

		if (SSticker.HasRoundStarted())
			status_data["roundTime"] = time2text(STATION_TIME_PASSED(), "hh:mm:ss", 0)
		else
			status_data["roundTime"] = "00:00:00"

		var/json_output = json_encode(status_data)

		if(fexists(STATUS_FILE_PATH))
			fdel(STATUS_FILE_PATH)

		text2file(json_output, STATUS_FILE_PATH)
		sleep(9000)
