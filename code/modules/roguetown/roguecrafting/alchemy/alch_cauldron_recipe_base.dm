/datum/alch_cauldron_recipe
	abstract_type = /datum/alch_cauldron_recipe // This is an abstract type, it should not be instantiated directly.
	var/name = "" //The name of the recipe, kinda there just in case.
	var/category = "Potions"
	var/skill_required = SKILL_LEVEL_APPRENTICE
	var/list/output_reagents = list() 
	var/list/output_items = list()
	var/required_base = /datum/reagent/water
	var/required_base_amount = 60
	var/list/required_runes = list()
	var/requires_rainbow = FALSE

/datum/alch_cauldron_recipe/proc/generate_html(mob/user)
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

	html += "<b>Required Skill:</b> [SSskills.level_names_plain[skill_required]]<br>"

	var/datum/reagent/base_instance = required_base
	var/base_name = initial(base_instance.name)
	html += "<b>Required Base:</b> Boil at least [required_base_amount] oz of [base_name] in a Cauldron or Laboratory.<br><br>"

	html += "<div><strong>Required Runes:</strong><br>"
	if(required_runes[ALCH_RUNE_RED])
		html += "- <span style='color: #ff4d4d; font-weight: bold;'>[required_runes[ALCH_RUNE_RED]] Red Rune</span><br>"
	if(required_runes[ALCH_RUNE_GREEN])
		html += "- <span style='color: #5cd65c; font-weight: bold;'>[required_runes[ALCH_RUNE_GREEN]] Green Rune</span><br>"
	if(required_runes[ALCH_RUNE_BLUE])
		html += "- <span style='color: #4da6ff; font-weight: bold;'>[required_runes[ALCH_RUNE_BLUE]] Blue Rune</span><br>"
	if(requires_rainbow)
		html += "- <span style='color: #ff00ff; font-weight: bold; text-shadow: 0 0 3px #ff00ff;'>+ 1 Rainbow Rune (Any Rank)</span><br>"
	html += "</div><br>"

	if(output_reagents.len)
		html += "<div><strong>Creates:</strong><br>"
		for(var/path as anything in output_reagents)
			var/count = output_reagents[path]
			if(ispath(path, /datum/reagent))
				var/datum/reagent/R = path
				html += "[FLOOR(count, 1)] [UNIT_FORM_STRING(FLOOR(count, 1))] of [initial(R.name)]<br>"
		html += "</div>"

	if(output_items.len)
		html += "<div><strong>Guaranteed Items:</strong><br>"
		for(var/path as anything in output_items)
			var/count = output_items[path]
			if(ispath(path, /obj))
				var/atom/atom = path
				html += "- [count] [initial(atom.name)]<br>"
		html += "</div>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/alch_cauldron_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user), "window=new_recipe;size=500x810")
