/obj/item/rune
	var/list/remarks = list() //things to read about while learning.
	var/pages_to_mastery = 5 //Essentially controls how long a mob must keep the rune in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form rune
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/roguetown/items/books.dmi'

/obj/item/rune/proc/turn_page(mob/user)
	//playsound(user, pick('sound/blank.ogg'), 30, TRUE)
	if(do_after(user,50, user))
		return TRUE
	return FALSE

/obj/item/rune/proc/already_known(mob/user)
	return FALSE

/obj/item/rune/proc/on_start(mob/user)
	to_chat(user, "<span class='notice'>I start reading [name]...</span>")

/obj/item/rune/proc/on_stopped(mob/user)
	to_chat(user, "<span class='notice'>I stop reading...</span>")

/obj/item/rune/proc/on_finished(mob/user)
	to_chat(user, "<span class='notice'>I finish reading [name]!</span>")

/obj/item/rune/proc/onlearned(mob/user)
	qdel(src)

/obj/item/rune/attack_self(mob/user)
	if(reading)
		//to_chat(user, "<span class='warning'>You're already reading this!</span>")
		return FALSE
	if(already_known(user))
		to_chat(user, "<span class='notice'>I already know this spell.</span>")
		return FALSE
	if(!user.get_skill_level(/datum/skill/magic/arcane))
		to_chat(user, "<span class='warning'>I don't have the knowledge to learn this spell.</span>")
		return FALSE
	on_start(user)
	reading = TRUE
	if(remarks.len)
		to_chat(user, "<span class='notice'>[pick(remarks)]</span>")
	for(var/i=1, i<=pages_to_mastery, i++)
		if(!turn_page(user))
			on_stopped()
			reading = FALSE
			return
	if(do_after(user,50, user))
		on_finished(user)
		reading = FALSE
	return TRUE

//Spells
/obj/item/rune/spell
	name = "符文"
	pages_to_mastery = 3
	var/spell
	var/spellname = "no spell"
	icon_state = "spellbookpower1_0" //temporary sprite

/obj/item/rune/spell/on_start(mob/user)
	user.visible_message("<span class='warning'>[user] begins siphoning the rune.</span>")

/obj/item/rune/spell/on_finished(mob/user)
	for(var/obj/effect/proc_holder/spell/knownspell in user.mind.spell_list)
		if(knownspell.type == spell)
			spell = null
	if(spell)
		to_chat(user, "<span class='notice'>The power of [spellname] is emblazened in your mind!</span>")
		var/obj/effect/proc_holder/spell/S = new spell
		user.mind.AddSpell(S)
		if(user.get_skill_level(/datum/skill/magic/arcane) <= 5)
			user.adjust_experience(/datum/skill/magic/arcane, 100, FALSE)
	else if(user.get_skill_level(/datum/skill/magic/arcane) <= 5)
		to_chat(user, "<span class='notice'>Arcane power is emblazened in your mind!</span>")
		user.adjust_experience(/datum/skill/magic/arcane, 150, FALSE)
	user.visible_message("<span class='warning'>[src] glows dark, and then crumbles!</span>")
	qdel(src)

/obj/item/rune/spell/fire_rune
	spell = /obj/effect/proc_holder/spell/invoked/projectile/fireball
	spellname = "fireball"
	// icon_state = "fire_rune"
	name = "火焰符文"
	desc = "散发着温热的力量。"
	remarks = list("要理解这些古老之物……", "光把它们点着可不行……", "还得把侧风算进去……真的？", "我好像刚把手烧到了……")

/obj/item/rune/spell/water_rune
	spell = /obj/effect/proc_holder/spell/targeted/ethereal_jaunt
	spellname = "ethereal jaunt"
	// icon_state = "water_rune"
	name = "水之符文"
	desc = "有些潮湿。"
	remarks = list("To understand these archaic things...", "法力流淌于一切活物之中……", "这个法术会让我疲惫……", "法术应如流水般流转……")

/obj/item/rune/spell/air_rune
	spell = /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt
	spellname = "lightning"
	// icon_state = "air_rune"
	name = "风之符文"
	desc = "摸起来很凉。"
	remarks = list("To understand these archaic things...", "若施放得当，这也许能……", "我好像刚把手电麻了……")

/obj/item/rune/spell/earth_rune
	spell = /obj/effect/proc_holder/spell/invoked/projectile/fetch
	spellname = "fetch"
	// icon_state = "earth_rune"
	name = "土之符文"
	desc = "比看起来更沉。"
	remarks = list("To understand these archaic things...", "我只能拉，不能推……", "我的脑子像泥浆一样沉重……")

/obj/item/rune/spell/blank_rune
	spell = null
	spellname = "arcane magic"
	// icon_state = "blank_rune"
	name = "符文精华"
	desc = "我们这个世界中魔法的源头。"
	remarks = list("我头好痛……", "我永远也搞不懂这个！", "我不想把视线移开……")
