/datum/mob_descriptor/age
	name = "年龄"
	slot = MOB_DESCRIPTOR_SLOT_AGE
	verbage = "%LOOK%"

/datum/mob_descriptor/age/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	return TRUE

/datum/mob_descriptor/age/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	if(H.age == AGE_OLD)
		return "年迈"
	else if (H.age == AGE_MIDDLEAGED)
		return "中年"
	else
		return "成年"

/datum/mob_descriptor/penis
	name = "阴茎"
	slot = MOB_DESCRIPTOR_SLOT_PENIS
	verbage = "有着"
	show_obscured = TRUE

/datum/mob_descriptor/penis/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	if(!penis)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/penis/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	var/adjective
	var/arousal_modifier
	switch(penis.penis_size)
		if(1)
			adjective = "小巧的"
		if(2)
			adjective = "普通的"
		if(3)
			adjective = "硕大的"
	if(H.sexcon)
		switch(H.sexcon.arousal)
			if(80 to INFINITY)
				arousal_modifier = "，正在剧烈搏动"
			if(50 to 80)
				arousal_modifier = "，胀硬而渗液"
			if(20 to 50)
				arousal_modifier = "，绷紧并微微抽搐"
			else
				arousal_modifier = "，柔软而松弛"
	else
		arousal_modifier = "，柔软而松弛"
	var/used_name
	if(penis.erect_state != ERECT_STATE_HARD && penis.sheath_type != SHEATH_TYPE_NONE)
		switch(penis.sheath_type)
			if(SHEATH_TYPE_NORMAL)
				if(penis.penis_size == 3)
					used_name = "肥厚的鞘皮"
				else if(penis.penis_size == 1)
					used_name = "瘦小的鞘皮"
				else
					used_name = "鞘皮"
			if(SHEATH_TYPE_SLIT)
				used_name = "生殖裂缝"
	else
		used_name = "[adjective] [penis.name][arousal_modifier]"
	var/branded = ""
	if(length(penis.branded_writing))
		branded = "，烙有<span style='font-size:125%;'>[span_boldwarning(penis.branded_writing)]</span>"
	return "[used_name][branded]"

/datum/mob_descriptor/testicles
	name = "睾丸"
	slot = MOB_DESCRIPTOR_SLOT_TESTICLES
	verbage = "有着"
	show_obscured = TRUE

/datum/mob_descriptor/testicles/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/testicles/testes = H.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	if(penis && penis.sheath_type == SHEATH_TYPE_SLIT) //If our penis hides in a slit, dont describe testicles
		return FALSE
	if(!testes)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/testicles/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/testicles/testes = H.getorganslot(ORGAN_SLOT_TESTICLES)
	var/adjective
	switch(testes.ball_size)
		if(1)
			adjective = "一对小巧的"
		if(2)
			adjective = "一对普通的"
		if(3)
			adjective = "一对硕大的"
	var/branded = ""
	if(length(testes.branded_writing))
		branded = "，烙有<span style='font-size:125%;'>[span_boldwarning(testes.branded_writing)]</span>"
	return "[adjective]睾丸[branded]"

/datum/mob_descriptor/vagina
	name = "阴道"
	slot = MOB_DESCRIPTOR_SLOT_VAGINA
	verbage = "有着"
	show_obscured = TRUE

/datum/mob_descriptor/vagina/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	if(!vagina)
		return FALSE
	if(H.sexcon && H.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(H.underwear)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return TRUE

/datum/mob_descriptor/vagina/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	var/vagina_type
	var/arousal_modifier
	switch(vagina.accessory_type)
		if(/datum/sprite_accessory/vagina/human)
			vagina_type = "普通阴道"
		if(/datum/sprite_accessory/vagina/hairy)
			vagina_type = "多毛阴道"
		if(/datum/sprite_accessory/vagina/trimmed)
			vagina_type = "修整过的阴道"
		if(/datum/sprite_accessory/vagina/spade)
			vagina_type = "铲形阴道"
		if(/datum/sprite_accessory/vagina/furred)
			vagina_type = "覆毛阴道"
		if(/datum/sprite_accessory/vagina/gaping)
			vagina_type = "张开的阴道"
		if(/datum/sprite_accessory/vagina/cloaca)
			vagina_type = "泄殖腔"
	switch(H.sexcon.arousal)
		if(80 to INFINITY)
			arousal_modifier = "，正因情动而汩汩泛湿"
		if(50 to 80)
			arousal_modifier = "，正因情动而变得滑润"
		if(20 to 50)
			arousal_modifier = "，正因情动而湿润"
	var/branded = ""
	if(length(vagina.branded_writing))
		branded = "，烙有<span style='font-size:125%;'>[span_boldwarning(vagina.branded_writing)]</span>"
	return "[vagina_type][arousal_modifier][branded]"

/datum/mob_descriptor/breasts
	name = "乳房"
	slot = MOB_DESCRIPTOR_SLOT_BREASTS
	verbage = "有着"
	show_obscured = TRUE

/datum/mob_descriptor/breasts/can_describe(mob/living/described)
	if(!ishuman(described))
		return FALSE
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	if(!breasts)
		return FALSE
	if(H.underwear && H.underwear.covers_breasts)
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_CHEST))
		return FALSE
	return TRUE

/datum/mob_descriptor/breasts/get_description(mob/living/described)
	var/mob/living/carbon/human/H = described
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	var/adjective
	switch(breasts.breast_size)
		if(0)
			adjective = "平坦的胸膛"
		if(1)
			adjective = "一对纤小的"
		if(2)
			adjective = "一对小巧的"
		if(3)
			adjective = "一对中等的"
		if(4)
			adjective = "一对丰满的"
		if(5)
			adjective = "一对丰硕的"
		if(6)
			adjective = "一对沉甸甸的"
		if(7)
			adjective = "一对巨大的"
		if(8)
			adjective = "一对夸张丰满的"
		if(9)
			adjective = "一对过于夸张的"
		if(10)
			adjective = "一对压弯脊背的"
		if(11)
			adjective = "一对遮住腹部的"
		if(12)
			adjective = "一对有躯干般大小的"
	var/branded = ""
	if(length(breasts.branded_writing))
		branded = "，烙有<span style='font-size:125%;'>[span_boldwarning(breasts.branded_writing)]</span>"
	if(breasts.breast_size == 0)
		return "[adjective][branded]"
	return "[adjective]乳房[branded]"
