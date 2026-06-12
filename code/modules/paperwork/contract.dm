/* For employment contracts and infernal contracts */

/obj/item/paper/contract
	throw_range = 3
	throw_speed = 3
	var/signed = FALSE
	var/datum/mind/target
	item_flags = NOBLUDGEON

/obj/item/paper/contract/proc/update_text()
	return

/obj/item/paper/contract/update_icon()
	return


/obj/item/paper/contract/employment
	icon_state = "paper_words"

/obj/item/paper/contract/employment/New(atom/loc, mob/living/nOwner)
	. = ..()
	if(!nOwner || !nOwner.mind)
		qdel(src)
		return -1
	target = nOwner.mind
	update_text()


/obj/item/paper/contract/employment/update_text()
	name = "[target]的雇佣契约"
	info = "<center>雇佣条件</center><BR><BR><BR><BR>本协议自下方最后一个签名落款之日起生效，由[target]（下称“奴隶”）与纳米（下称“全知全能且乐于助人的人类监护者”）共同订立。<BR>兹证明如下：<BR>鉴于，“奴隶”为天生的人类或类人生物，具备可协助这位全知全能且乐于助人的人类监护者的技能，并自愿在这位全知全能且乐于助人的人类监护者麾下求职。<BR>鉴于，这位全知全能且乐于助人的人类监护者同意偶尔向“奴隶”支付报酬，以换取其永久服役。<BR>因此，鉴于本协议所载双方约定及其他正当且有价值的对价，双方特此共同同意如下：<BR>作为微薄报酬的交换，“奴隶”同意在其今生余生及未来所有生命中，持续为这位全知全能且乐于助人的人类监护者工作。<BR>此外，“奴隶”同意将其灵魂所有权转让给这位全知全能且乐于助人的人类监护者的忠诚部门。<BR>若灵魂无法完成转让，则改为设立留置权。<BR>签署人：<BR><i>[target]</i>"


/obj/item/paper/contract/employment/attack(mob/living/M, mob/living/carbon/human/user)
	var/deconvert = FALSE
	if(M.mind == target && !M.owns_soul())
		if(user.mind && (user.mind.assigned_role == "Lawyer"))
			deconvert = TRUE
		else if (user.mind && (user.mind.assigned_role =="Head of Personnel") || (user.mind.assigned_role == "CentCom Commander"))
			deconvert = prob (25) // the HoP doesn't have AS much legal training
		else
			deconvert = prob (5)
	if(deconvert)
		M.visible_message("<span class='notice'>[user]提醒了[M]，[M]的灵魂早已被纳米买下！</span>")
		to_chat(M, "<span class='boldnotice'>我感觉自己的灵魂回到了它真正的主人手中，纳米。</span>")
		M.return_soul()
	else
		M.visible_message("<span class='danger'>[user]用[src]猛砸了[M]的脑袋！</span>", \
			"<span class='danger'>[user]用[src]猛砸了[M]的脑袋！</span>")
	return ..()
