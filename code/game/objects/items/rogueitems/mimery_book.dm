/obj/item/book/mimery
	name = "高深拟态戏法指南"
	desc = ""
	icon_state ="bookmime"

/obj/item/book/mimery/attack_self(mob/user,)
	user.set_machine(src)
	var/dat = "<B>高深拟态戏法指南</B><BR>"
	dat += "教授三种经典默剧套路之一，让熟练的默剧演员能够将无形之物具现为实体。<BR>"
	dat += "一旦你掌握了自己的套路，这本书便再无更多可教。<BR>"
	dat += "<HR>"
	dat += "<A href='byond://?src=[REF(src)];invisible_wall=1'>隐形墙</A><BR>"
	dat += "<A href='byond://?src=[REF(src)];invisible_chair=1'>隐形椅</A><BR>"
	dat += "<A href='byond://?src=[REF(src)];invisible_box=1'>隐形箱</A><BR>"
	user << browse(dat, "window=book")

/obj/item/book/mimery/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained() || src.loc != usr)
		return
	if (!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.is_holding(src) && H.mind)
		H.set_machine(src)
		if (href_list["invisible_wall"])
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall(null))
		if (href_list["invisible_chair"])
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair(null))
	to_chat(usr, "<span class='notice'>这本书凭空消失了。</span>")
	qdel(src)
