GLOBAL_VAR_INIT(hsboxspawn, TRUE)

/mob/proc/CanBuild()
	sandbox = new/datum/hSB
	sandbox.owner = src.ckey
	if(src.client.holder)
		sandbox.admin = 1
	verbs += new/mob/proc/sandbox_panel
/mob/proc/sandbox_panel()
	set name = "沙盒面板"
	if(sandbox)
		sandbox.update()

/datum/hSB
	var/owner = null
	var/admin = 0

	var/static/clothinfo = null
	var/static/reaginfo = null
	var/static/objinfo = null
	var/canisterinfo = null
	var/hsbinfo = null
	//items that shouldn't spawn on the floor because they would bug or act weird
	var/static/list/spawn_forbidden = list(
		/obj/item/tk_grab,
		/obj/projectile)

/datum/hSB/proc/update()
	var/static/list/hrefs = list(
			"太空装备",

			"标准工具")



	if(!hsbinfo)
		hsbinfo = "<center><b>沙盒面板</b></center><hr>"
		if(admin)
			hsbinfo += "<b>管理选项</b><br>"
			hsbinfo += "- <a href='?src=[REF(src)];hsb=hsbtobj'>切换物体生成</a><br>"
			hsbinfo += "- <a href='?src=[REF(src)];hsb=hsbtac'>切换物品生成面板自动关闭</a><br>"
		else
			hsbinfo += "<i>部分物品生成可能已被管理员禁用。</i><br>"
			hsbinfo += "<i>只有管理员才能生成危险的气罐。</i><br>"
		for(var/T in hrefs)
			var/href = hrefs[T]
			if(href)
				hsbinfo += "- <a href='?[REF(src)];hsb=[hrefs[T]]'>[T]</a><br>"
			else
				hsbinfo += "<br><b>[T]</b><br>"
		hsbinfo += "<hr>"
		hsbinfo += "- <a href='?[REF(src)];hsb=hsbcloth'>生成服装...</a><br>"
		hsbinfo += "- <a href='?[REF(src)];hsb=hsbreag'>生成试剂容器...</a><br>"
		hsbinfo += "- <a href='?[REF(src)];hsb=hsbobj'>生成其他物品...</a><br><br>"

	usr << browse(hsbinfo, "window=hsbpanel")

/datum/hSB/Topic(href, href_list)
	if(!usr || !src || !(src.owner == usr.ckey))
		if(usr)
			usr << browse(null,"window=sandbox")
		return

	if(href_list["hsb"])
		switch(href_list["hsb"])
			//
			// Admin: toggle spawning
			//
			if("hsbtobj")
				if(!admin) return
				if(GLOB.hsboxspawn)
					to_chat(world, "<span class='boldannounce'>沙盒：</span> <b>\black[usr.key] 已禁用物体生成！</b>")
					GLOB.hsboxspawn = FALSE
					return
				else
					to_chat(world, "<span class='boldnotice'>沙盒：</span> <b>\black[usr.key] 已启用物体生成！</b>")
					GLOB.hsboxspawn = TRUE
					return
			//
			// Admin: Toggle auto-close
			//
			if("hsbtac")
				if(!admin) return
				var/sbac = CONFIG_GET(flag/sandbox_autoclose)
				if(sbac)
					to_chat(world, "<span class='boldnotice'>沙盒：</span> <b>\black [usr.key] 已移除物体生成限制。</b>")
				else
					to_chat(world, "<span class='danger'>沙盒：</span> <b>\black [usr.key] 已为物体生成添加限制。窗口现在会在使用后自动关闭。</b>")
				CONFIG_SET(flag/sandbox_autoclose, !sbac)
				return
			//
			// Object spawn window
			//

			// Clothing
			if("hsbcloth")
				if(!GLOB.hsboxspawn) return

				if(!clothinfo)
					clothinfo = "<b>服装</b> <a href='?[REF(src)];hsb=hsbreag'>(试剂容器)</a> <a href='?[REF(src)];hsb=hsbobj'>(其他物品)</a><hr><br>"
					var/list/all_items = subtypesof(/obj/item/clothing)
					for(var/typekey in spawn_forbidden)
						all_items -= typesof(typekey)
					for(var/O in reverseRange(all_items))
						clothinfo += "<a href='?src=[REF(src)];hsb=hsb_safespawn&path=[O]'>[O]</a><br>"

				usr << browse(clothinfo,"window=sandbox")

			// Reagent containers
			if("hsbreag")
				if(!GLOB.hsboxspawn) return

				if(!reaginfo)
					reaginfo = "<b>试剂容器</b> <a href='?[REF(src)];hsb=hsbcloth'>(服装)</a> <a href='?[REF(src)];hsb=hsbobj'>(其他物品)</a><hr><br>"
					var/list/all_items = subtypesof(/obj/item/reagent_containers)
					for(var/typekey in spawn_forbidden)
						all_items -= typesof(typekey)
					for(var/O in reverseRange(all_items))
						reaginfo += "<a href='?src=[REF(src)];hsb=hsb_safespawn&path=[O]'>[O]</a><br>"

				usr << browse(reaginfo,"window=sandbox")

			// Other items
			if("hsbobj")
				if(!GLOB.hsboxspawn) return

				if(!objinfo)
					objinfo = "<b>其他物品</b> <a href='?[REF(src)];hsb=hsbcloth'>(服装)</a> <a href='?[REF(src)];hsb=hsbreag'>(试剂容器)</a><hr><br>"
					var/list/all_items = subtypesof(/obj/item/) - typesof(/obj/item/clothing) - typesof(/obj/item/reagent_containers)
					for(var/typekey in spawn_forbidden)
						all_items -= typesof(typekey)

					for(var/O in reverseRange(all_items))
						objinfo += "<a href='?src=[REF(src)];hsb=hsb_safespawn&path=[O]'>[O]</a><br>"

				usr << browse(objinfo,"window=sandbox")

			//
			// Safespawn checks to see if spawning is disabled.
			//
			if("hsb_safespawn")
				if(!GLOB.hsboxspawn)
					usr << browse(null,"window=sandbox")
					return

				var/typepath = text2path(href_list["path"])
				if(!typepath)
					to_chat(usr, "无效路径：\"[href_list["path"]]\"")
					return
				new typepath(usr.loc)

				if(CONFIG_GET(flag/sandbox_autoclose))
					usr << browse(null,"window=sandbox")
			//
			// For everything else in the href list
			//
			if("hsbspawn")
				var/typepath = text2path(href_list["path"])
				if(!typepath)
					to_chat(usr, "无效路径：\"[href_list["path"]]\"")
					return
				new typepath(usr.loc)

				if(CONFIG_GET(flag/sandbox_autoclose))
					usr << browse(null,"window=sandbox")
