/datum/voicepack/male/harpy/get_sound(soundin, modifiers)
	var/used
	switch(modifiers)
		if("old")
			used = getmold(soundin)
		if("young")
			used = getmyoung(soundin)
		if("silenced")
			used = getmsilenced(soundin)
	if(!used)
		switch(soundin)
			if("scream")
				used = 'sound/vo/mobs/bird/raptorscream.ogg'
			if("painscream")
				used = 'sound/vo/mobs/bird/raptorscream.ogg'
			if("trill")
				used = list('sound/vo/mobs/bird/thrill1.ogg', 'sound/vo/mobs/bird/thrill2.ogg')
			if("raptor")
				used = list('sound/vo/mobs/bird/raptor_1.ogg', 'sound/vo/mobs/bird/raptor_2.ogg', 'sound/vo/mobs/bird/raptor_3.ogg', 'sound/vo/mobs/bird/raptor_4.ogg', 'sound/vo/mobs/bird/raptor_5.ogg')
			if("caw")
				used = list('sound/vo/mobs/bird/crowcall.ogg', 'sound/vo/mobs/bird/caw.ogg')
			if("loudcaw")
				used = 'sound/vo/mobs/bird/boobycall.ogg'
			if("growl")
				used = 'sound/vo/mobs/bird/raptorgrowl1.ogg'
			if("squeak")
				used = 'sound/vo/mobs/bird/teshsqueak.ogg'
			if("warble")
				used = list('sound/vo/mobs/bird/warbles.ogg', 'sound/vo/mobs/bird/wurble.ogg')
			if("chirp")
				used = 'sound/vo/mobs/bird/teshchirp.ogg'
			if("dove")
				used = 'sound/vo/mobs/bird/dovecall.ogg'
			if("purr")
				used = 'sound/vo/mobs/bird/raptor_purr.ogg'
	if(!used) //we haven't found a racial specific sound so use generic
		used = ..(soundin, modifiers)
	return used
