/datum/alch_grind_recipe
	var/name = "通用研磨配方"
	var/category = "研磨"
	var/picky = TRUE // if TRUE: the item path MUST MATCH, and cannot be a subtype.
	var/obj/item/valid_input = null //the typepath that, when ground, makes an output
	var/list/valid_outputs = list() //List of [Itempath = amnt?1] to be created always
	var/list/bonus_chance_outputs = list() //List of [Itempath = chance/100] to create sometimes.
	abstract_type = /datum/alch_grind_recipe

/datum/alch_grind_recipe/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	user << browse_rsc('html/book.png')
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<body>
		  <div>
		    <h1>[name]</h1>
		"}
	
	html += "将[initial(valid_input.name)]放入炼金研钵中。<br>"
	html += "用杵研磨，可制成：<br>"

	if(valid_outputs.len)
		html += "<div><strong>固定产出</strong><br>"
		for(var/path as anything in valid_outputs)
			var/count = valid_outputs[path]
			if(ispath(path, /obj))
				var/atom/atom = path
				html += "- [count] [initial(atom.name)]<br>"
		html += "</div>"

	if(bonus_chance_outputs.len)
		html += "<div><strong>额外产出</strong><br>"
		for(var/path as anything in bonus_chance_outputs)
			var/chance = bonus_chance_outputs[path]
			if(ispath(path, /obj))
				var/atom/atom = path
				html += "- [initial(atom.name)]（概率：[chance]%）<br>"
		html += "</div>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/alch_grind_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=new_recipe;size=500x810")

/datum/alch_grind_recipe/proc/get_bonus_output_chance(output_path, mob/living/carbon/human/user, base_chance)
	return base_chance
