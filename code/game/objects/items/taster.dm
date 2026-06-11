/obj/item/taster
	name = "试味器"
	desc = ""
	icon = 'icons/obj/surgery.dmi'
	icon_state = "tonguenormal"

	w_class = WEIGHT_CLASS_TINY

	speech_span = null

	var/taste_sensitivity = 15

/obj/item/taster/afterattack(atom/O, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(O.reagents)
		var/message = O.reagents.generate_taste_message(taste_sensitivity)
		to_chat(user, span_notice("[src]从[O]里尝出了<span class='italics'>[message]</span>。"))
