/obj/item/teleportation_scroll
	name = "传送卷轴"
	desc = ""
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
	var/uses = 4
	w_class = WEIGHT_CLASS_SMALL
	item_state = "paper"
	throw_speed = 1
	throw_range = 7
	resistance_flags = FLAMMABLE

/obj/item/teleportation_scroll/apprentice
	name = "次级传送卷轴"
	uses = 1



/obj/item/teleportation_scroll/attack_self(mob/user)
	user.set_machine(src)
	var/dat = "<B>传送卷轴：</B><BR>"
	dat += "剩余使用次数：[src.uses]<BR>"
	dat += "<HR>"
	dat += "<B>共有四次机会，请谨慎使用：</B><BR>"
	dat += "<A href='byond://?src=[REF(src)];spell_teleport=1'>传送</A><BR>"
	dat += "谨致问候，<br>巫师联合会<br><br>附言：别忘了带上你的装备，大多数法术施放时都用得上。<HR>"
	user << browse(dat, "window=scroll")
	onclose(user, "scroll")
	return

/obj/item/teleportation_scroll/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained() || src.loc != usr)
		return
	if (!ishuman(usr))
		return 1
	var/mob/living/carbon/human/H = usr
	if(H.is_holding(src))
		H.set_machine(src)
		if (href_list["spell_teleport"])
			if(uses)
				teleportscroll(H)
	if(H)
		attack_self(H)
	return

/obj/item/teleportation_scroll/proc/teleportscroll(mob/user)

	var/A

	A = input(user, "要传送到哪个区域", "传送卷轴", A) as null|anything in GLOB.teleportlocs
	if(!src || QDELETED(src) || !user || !user.is_holding(src) || user.incapacitated() || !A || !uses)
		return
	var/area/thearea = GLOB.teleportlocs[A]

	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(2, user.loc)
	smoke.attach(user)
	smoke.start()
	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		if(!is_blocked_turf(T))
			L += T

	if(!L.len)
		to_chat(user, "法术矩阵因未知原因无法定位合适的传送目的地。")
		return

	if(do_teleport(user, pick(L), forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
		smoke.start()
		uses--
	else
		to_chat(user, "目的地附近有某种东西扰乱了法术矩阵。")
