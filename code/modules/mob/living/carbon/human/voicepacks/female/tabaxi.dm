/datum/voicepack/female/tabaxi/get_sound(soundin, modifiers)
	var/used
	switch(modifiers)
		if("old")
			used = getfold(soundin)
		if("young")
			used = getfyoung(soundin)
		if("silenced")
			used = getfsilenced(soundin)
	if(!used)
		switch(soundin)
			if("meow")
				// Removed second missing file (tabaxi_meow2.ogg) to avoid resource error
				used = list('sound/vo/female/tabaxi/tabaxi_meow1.ogg')
			if("purr")
				used = list('sound/vo/female/tabaxi/tabaxi_purr.ogg')
			if("trill")
				used = list('sound/vo/female/tabaxi/tabaxi_mrrp1.ogg', 'sound/vo/female/tabaxi/tabaxi_mrrp2.ogg')
			if("hiss")
				used = list('sound/vo/female/tabaxi/tabaxi_hiss1.ogg', 'sound/vo/female/tabaxi/tabaxi_hiss2.ogg')
			else
				return ..()
	return used 
