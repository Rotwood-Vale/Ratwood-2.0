/obj/effect/proc_holder/spell/targeted/summonitem
	name = "即时召回"
	desc = ""
	school = "transmutation"
	recharge_time = 100
	clothes_req = FALSE
	invocations = list("归来我手。")
	invocation_type = "whisper"
	range = -1
	cooldown_min = 100
	include_user = TRUE

	var/obj/marked_item

	action_icon_state = "summons"

/obj/effect/proc_holder/spell/targeted/summonitem/cast(list/targets,mob/user = usr)
	for(var/mob/living/L in targets)
		var/list/hand_items = list(L.get_active_held_item(),L.get_inactive_held_item())
		var/message

		if(!marked_item) //linking item to the spell
			message = "<span class='notice'>"
			for(var/obj/item/item in hand_items)
				if(item.item_flags & ABSTRACT)
					continue
				if(SEND_SIGNAL(item, COMSIG_ITEM_MARK_RETRIEVAL) & COMPONENT_BLOCK_MARK_RETRIEVAL)
					continue
				if(HAS_TRAIT(item, TRAIT_NODROP))
					message += "虽然这显得有些多余，"
				marked_item = 		item
				message += "你为[item]烙下了召回印记。</span>"
				name = "召回[item]"
				break

			if(!marked_item)
				if(hand_items)
					message = span_warning("我手里没有任何可供烙下召回印记的物品！")
				else
					message = span_warning("我必须把想要标记的物品握在手里，才能为它烙下召回印记！")

		else if(marked_item && (marked_item in hand_items)) //unlinking item to the spell
			message = span_notice("我解除了[marked_item]上的印记，好将它用于别处。")
			name = "即时召回"
			marked_item = 		null

		else if(marked_item && QDELETED(marked_item)) //the item was destroyed at some point
			message = span_warning("我感觉那件被标记的物品已经毁坏了！")
			name = "即时召回"
			marked_item = 		null

		else	//Getting previously marked item
			var/obj/item_to_retrieve = marked_item
			var/infinite_recursion = 0 //I don't want to know how someone could put something inside itself but these are wizards so let's be safe

			if(!item_to_retrieve.loc)
				if(isorgan(item_to_retrieve)) // Organs are usually stored in nullspace
					var/obj/item/organ/organ = item_to_retrieve
					if(organ.owner)
						// If this code ever runs I will be happy
						log_combat(L, organ.owner, "magically removed [organ.name] from", addition="INTENT: [uppertext(L.a_intent)]")
						organ.Remove(organ.owner)
			else
				while(!isturf(item_to_retrieve.loc) && infinite_recursion < 10) //if it's in something you get the whole thing.
					if(isitem(item_to_retrieve.loc))
						var/obj/item/I = item_to_retrieve.loc
						if(I.item_flags & ABSTRACT) //Being able to summon abstract things because your item happened to get placed there is a no-no
							break
					if(ismob(item_to_retrieve.loc)) //If its on someone, properly drop it
						var/mob/M = item_to_retrieve.loc
						M.dropItemToGround(item_to_retrieve)
						if(iscarbon(M)) //Edge case housekeeping
							var/mob/living/carbon/C = M
							for(var/X in C.bodyparts)
								var/obj/item/bodypart/part = X
								if(item_to_retrieve in part.embedded_objects)
									part.remove_embedded_object(item_to_retrieve)
									to_chat(C, span_warning("嵌在你[L]身上的[item_to_retrieve]神秘地消失了。真是走运！"))
									break
						item_to_retrieve = item_to_retrieve.loc
					infinite_recursion += 1
			if(!item_to_retrieve)
				return
			if(item_to_retrieve.loc)
				item_to_retrieve.loc.visible_message(span_warning("[item_to_retrieve.name]突然消失了！"))
			if(!L.put_in_hands(item_to_retrieve))
				item_to_retrieve.forceMove(L.drop_location())
				item_to_retrieve.loc.visible_message(span_warning("[item_to_retrieve.name]突然出现了！"))
				playsound(get_turf(L), 'sound/blank.ogg', 50, TRUE)
			else
				item_to_retrieve.loc.visible_message(span_warning("[item_to_retrieve.name]突然出现在[L]手中！"))
				playsound(get_turf(L), 'sound/blank.ogg', 50, TRUE)
		if(message)
			to_chat(L, message)
