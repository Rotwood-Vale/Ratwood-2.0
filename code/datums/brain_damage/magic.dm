//Magical traumas, caused by spells and curses.
//Blurs the line between the victim's imagination and reality
//Unlike regular traumas this can affect the victim's body and surroundings

/datum/brain_trauma/magic
	resilience = TRAUMA_RESILIENCE_LOBOTOMY

/datum/brain_trauma/magic/lumiphobia
	name = "惧光症"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我开始渴求黑暗。")
	lose_text = span_notice("光亮不再困扰我了。")
	var/next_damage_warning = 0

/datum/brain_trauma/magic/lumiphobia/on_life()
	..()
	var/turf/T = owner.loc
	if(istype(T))
		var/light_amount = T.get_lumcount()
		if(light_amount > SHADOW_SPECIES_LIGHT_THRESHOLD) //if there's enough light, start dying
			if(world.time > next_damage_warning)
				to_chat(owner, span_warning("<b>光亮正在灼烧我！</b>"))
				next_damage_warning = world.time + 100 //Avoid spamming
			owner.take_overall_damage(0,3)

/datum/brain_trauma/magic/poltergeist
	name = "喧灵"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我感到一股充满恶意的存在正逼近我。")
	lose_text = span_notice("我感到那股充满恶意的存在消散了。")

/datum/brain_trauma/magic/poltergeist/on_life()
	..()
	if(prob(4))
		var/most_violent = -1 //So it can pick up items with 0 throwforce if there's nothing else
		var/obj/item/throwing
		for(var/obj/item/I in view(5, get_turf(owner)))
			if(I.anchored)
				continue
			if(I.throwforce > most_violent)
				most_violent = I.throwforce
				throwing = I
		if(throwing)
			throwing.throw_at(owner, 8, 2)

/datum/brain_trauma/magic/antimagic
	name = "拒魔妄想"
	desc = ""
	scan_desc = ""
	gain_text = span_notice("我意识到魔法不可能是真实存在的。")
	lose_text = span_notice("我意识到魔法也许真的存在。")

/datum/brain_trauma/magic/antimagic/on_gain()
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/magic/antimagic/on_lose()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, TRAUMA_TRAIT)
	..()
