// Examine highlight framework adapted from Azure Peak. Item paths below use BD equivalents.
/obj/item
	/// Optional highlight metadata for items whose appearance changes without changing type.
	var/examine_highlight_severity = null
	var/examine_highlight_desc = null

/** Does this item have an important, immediately notable quality (such as being heretical)?
*	If it is, this should return a list containing:
* - First: A highlight status (see `code\__DEFINES\highlight_examine_defines.dm`).
* - Second: A short description explaining in-character why this item has that status.
*
* When set, highlights the item's mob examine name/tooltip with obvious heretical flavor when worn/held.
*
* Types that cannot override this proc (i.e. one reskinned by a morphing elixir, which keeps its own
* type) can instead set `examine_highlight_severity` and `examine_highlight_desc`.
*
* If this returns null, the item will not be shown as heretical.*/
/obj/item/proc/get_examine_highlight_status()
	if(examine_highlight_severity && examine_highlight_desc)
		return list(examine_highlight_severity, examine_highlight_desc)
	return null

/** Returns an HTML-formatted string explaining how/why this item has the highlight status it does.
* - `examine_highlight_status`: This item's examine highlight status (see `proc/get_examine_highlight_status()`).
* - `itis`: Determines if the string will start with "It is".
* - `allcaps`: Determines if the returned string will be in allcaps.
*/
/obj/item/proc/get_examine_highlight_description(list/examine_highlight_status, itis = FALSE, allcaps = TRUE)
	if(examine_highlight_status)
		var/severity = examine_highlight_status[1]
		var/heresy_desc = examine_highlight_status[2]
		if(!severity || !heresy_desc)
			return null
		var/highlight_itis = "[itis ? "It is " : ""]<b>[get_examine_highlight_adjective(severity)]</b>"
		return get_examine_highlight_labeled_string(severity, "[allcaps ? uppertext(highlight_itis) : highlight_itis]: [allcaps ? uppertext(heresy_desc) : heresy_desc]")
	return null

/// Returns `label_string` HTML formatted depending on the provided highlight status (see `code\__DEFINES\highlight_examine_defines.dm`).
/obj/item/proc/get_examine_highlight_labeled_string(examine_highlight_type, label_string)
	if(!examine_highlight_type || !label_string)
		return null
	var/highlight_color = get_examine_highlight_color(examine_highlight_type)
	var/highlight_symbol = get_examine_highlight_symbol(examine_highlight_type)
	return "<font color = '[highlight_color]'>[highlight_symbol] [label_string] [highlight_symbol]</font>"

/// Returns a full HTML-formatted tooltip string whose contents depend on the given highlight status type (See `proc/get_examine_highlight_status()` and `code\__DEFINES\highlight_examine_defines.dm`).
/obj/item/proc/get_examine_highlight_tooltip_string(list/examine_highlight_status)
	if(!examine_highlight_status)
		return null
	var/highlight_reason = get_examine_highlight_description(examine_highlight_status)
	var/highlight_explanation = get_examine_highlight_explanation(examine_highlight_status[1])

	return "[highlight_reason]<br>[highlight_explanation]"

/// See `proc/get_examine_highlight_status()` and `code\__DEFINES\highlight_examine_defines.dm`.
/obj/item/proc/get_examine_highlight_adjective(highlight_type)
	switch(highlight_type)
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING)
			return "HERETICAL"
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS)
			return "SUSPICIOUS"
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD)
			return "Odd"
		if(EXAMINEHIGHLIGHT_VIBE_FRIEND)
			return "Sworn Ally"
		if(EXAMINEHIGHLIGHT_VIBE_FOE)
			return "Sworn Enemy"
		if(EXAMINEHIGHLIGHT_VIBE_CROWN)
			return "Divine"
		if(EXAMINEHIGHLIGHT_VIBE_GOLGATHA)
			return "Blessed"
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD)
			return "ALARMINGLY ODD"
	return null

/// See `proc/get_examine_highlight_status()` and `code\__DEFINES\highlight_examine_defines.dm`.
/obj/item/proc/get_examine_highlight_explanation(highlight_type)
	switch(highlight_type)
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING)
			return EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_ALARMING
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS)
			return EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_SUSPICIOUS
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD)
			return EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_ODD
		if(EXAMINEHIGHLIGHT_VIBE_FRIEND)
			return EXAMINEHIGHLIGHT_TOOLTIP_VIBE_FRIEND
		if(EXAMINEHIGHLIGHT_VIBE_FOE)
			return EXAMINEHIGHLIGHT_TOOLTIP_VIBE_FOE
		if(EXAMINEHIGHLIGHT_VIBE_CROWN)
			return EXAMINEHIGHLIGHT_TOOLTIP_VIBE_CROWN
		if(EXAMINEHIGHLIGHT_VIBE_GOLGATHA)
			return EXAMINEHIGHLIGHT_TOOLTIP_VIBE_GOLGATHA
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD)
			return EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_VERYODD
	return null

/// See `proc/get_examine_highlight_status()` and `code\__DEFINES\highlight_examine_defines.dm`.
/obj/item/proc/get_examine_highlight_color(highlight_type)
	switch(highlight_type)
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING)
			return COLOR_HERESYSEVERITY_ALARMING
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS)
			return COLOR_HERESYSEVERITY_SUSPICIOUS
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD)
			return COLOR_HERESYSEVERITY_ODD
		if(EXAMINEHIGHLIGHT_VIBE_FRIEND)
			return COLOR_VIBE_FRIEND
		if(EXAMINEHIGHLIGHT_VIBE_FOE)
			return COLOR_VIBE_FOE
		if(EXAMINEHIGHLIGHT_VIBE_CROWN)
			return COLOR_VIBE_CROWN
		if(EXAMINEHIGHLIGHT_VIBE_GOLGATHA)
			return COLOR_VIBE_GOLGATHA
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD)
			return COLOR_HERESYSEVERITY_VERYODD
	return null

/// See `proc/get_examine_highlight_status()` and `code\__DEFINES\highlight_examine_defines.dm`.
/obj/item/proc/get_examine_highlight_symbol(highlight_type)
	switch(highlight_type)
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING)
			return EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ALARMING
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS)
			return EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_SUSPICIOUS
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD)
			return EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ODD
		if(EXAMINEHIGHLIGHT_VIBE_FRIEND)
			return SYMBOL_VIBE_FRIEND
		if(EXAMINEHIGHLIGHT_VIBE_FOE)
			return SYMBOL_VIBE_FOE
		if(EXAMINEHIGHLIGHT_VIBE_CROWN)
			return SYMBOL_VIBE_CROWN
		if(EXAMINEHIGHLIGHT_VIBE_GOLGATHA)
			return SYMBOL_VIBE_GOLGATHA
		if(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD)
			return EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_VERYODD
	return null

// Cosmetic attachments build their names outside the normal equipment hover panel.
/obj/item/proc/get_highlighted_attachment_name(mob/user)
	var/attachment_name = get_examine_name(user)
	var/list/highlight_status = get_examine_highlight_status()
	if(!highlight_status)
		return attachment_name
	var/label = get_examine_highlight_labeled_string(highlight_status[1], attachment_name)
	return SPAN_TOOLTIP_DANGEROUS_HTML(get_examine_highlight_tooltip_string(highlight_status), label)

// Classifications for items already present in Bad Drakian.

/obj/item/rogue/instrument/ztratocaster/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, "A profane instrument of Zizo's champions.")

/obj/item/abyssal_marker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, "It shatters the barrier between reality and NIGHTMARE")

/obj/item/abyssal_marker/tidal/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, "It shatters the barrier between reality and NIGHTMARE")

/obj/item/black_rose/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_BLACK_ROT)

/obj/item/clothing/cloak/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_GRAGGAR_MISC)

/obj/item/clothing/gloves/roguetown/chain/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/gloves/roguetown/chain/vampire/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/gloves/roguetown/plate/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/gloves/roguetown/plate/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_GRAGGAR_ARMOR)

/obj/item/clothing/gloves/roguetown/plate/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ARMOR)

/obj/item/clothing/gloves/roguetown/plate/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/head/roguetown/crown/serpcrown/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_VIBE_CROWN, VIBEDESC_CROWN)

/obj/item/clothing/head/roguetown/helmet/bascinet/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/head/roguetown/helmet/heavy/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_GRAGGAR_ARMOR)

/obj/item/clothing/head/roguetown/helmet/heavy/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ARMOR)

/obj/item/clothing/head/roguetown/helmet/heavy/vampire/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/head/roguetown/helmet/heavy/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/head/roguetown/vampire/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE_CROWN)

/obj/item/clothing/neck/roguetown/bevor/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/neck/roguetown/dragon_scale/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ICON)

/obj/item/clothing/neck/roguetown/psicross/abyssor/gronn/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_GRONN)

/obj/item/clothing/neck/roguetown/psicross/dendor/gronn/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_GRONN)

/obj/item/clothing/neck/roguetown/psicross/inhumen/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_ZIZO_ICON)

/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_ZIZO_ICON)

/obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_BAOTHA_ICON)

/obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/gronn/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_GRONN)

/obj/item/clothing/neck/roguetown/psicross/inhumen/bronze/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_ZIZO_ICON)

/obj/item/clothing/neck/roguetown/psicross/inhumen/g/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_ZIZO_ICON)

/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_GRAGGAR_ICON)

/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_GRONN)

/obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_GRONN)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_MATTHIOS_ICON)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_GRONN)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn/generic/get_examine_highlight_status()
	return null

/obj/item/clothing/neck/roguetown/psicross/weeping/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_WEEPING_CROSS)

/obj/item/clothing/ring/griefflower/get_examine_highlight_status()
	return null

/obj/item/clothing/shoes/roguetown/anklets/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/shoes/roguetown/boots/armor/avantyne/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/shoes/roguetown/boots/armor/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/shoes/roguetown/boots/armor/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_GRAGGAR_ARMOR)

/obj/item/clothing/shoes/roguetown/boots/armor/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ARMOR)

/obj/item/clothing/shoes/roguetown/boots/armor/vampire/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/shoes/roguetown/boots/armor/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/suit/roguetown/armor/chainmail/iron/vampire/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/suit/roguetown/armor/leather/studded/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_ZIZO_ARTIFICE_RECLAIMED)

/obj/item/clothing/suit/roguetown/armor/plate/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_GRAGGAR_ARMOR)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/suit/roguetown/armor/plate/full/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/suit/roguetown/armor/plate/full/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ARMOR)

/obj/item/clothing/suit/roguetown/armor/plate/full/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/suit/roguetown/armor/plate/vampire/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/suit/roguetown/shirt/robe/necromancer/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, "The robes of Zizo's foul deadite-raisers")

/obj/item/clothing/under/roguetown/platelegs/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/under/roguetown/platelegs/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/under/roguetown/platelegs/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_GRAGGAR_ARMOR)

/obj/item/clothing/under/roguetown/platelegs/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ARMOR)

/obj/item/clothing/under/roguetown/platelegs/vampire/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE)

/obj/item/clothing/under/roguetown/platelegs/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/wrists/roguetown/bracers/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/wrists/roguetown/bracers/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/flashlight/flare/torch/lantern/psycenser/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_VIBE_GOLGATHA, VIBEDESC_GOLGATHA)

/obj/item/flashlight/flare/torch/lantern/pumpkin/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, "GREAT GOOGLY MOOGLY, THAT PUMPKIN IS PRAISING SHE OF Z!")

/obj/item/rogueweapon/flail/peasantwarflail/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_WEAPON)

/obj/item/rogueweapon/greataxe/dreamscape/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_DREAM_ITEM)

/obj/item/rogueweapon/greataxe/dreamscape/active/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_WEAPON)

/obj/item/rogueweapon/greataxe/steel/doublehead/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_GRAGGAR_WEAPON)

/obj/item/rogueweapon/greatsword/bsword/dreamscape/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_DREAM_ITEM)

/obj/item/rogueweapon/greatsword/bsword/dreamscape/active/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_WEAPON)

/obj/item/rogueweapon/greatsword/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_AVANTYNE)

/obj/item/rogueweapon/halberd/glaive/dreamscape/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_DREAM_ITEM)

/obj/item/rogueweapon/halberd/glaive/dreamscape/active/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_WEAPON)

/obj/item/rogueweapon/huntingknife/combat/messer/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_GRAGGAR_WEAPON)

/obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_WEAPON)

/obj/item/rogueweapon/huntingknife/idagger/steel/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_WEAPON)

/obj/item/rogueweapon/huntingknife/idagger/steel/rondel/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_WEAPON)

/obj/item/rogueweapon/shield/tower/metal/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_WEAPON)

/obj/item/rogueweapon/spear/billhook/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_AVANTYNE)

/obj/item/rogueweapon/spear/dreamscape_trident/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_DREAM_ITEM)

/obj/item/rogueweapon/spear/dreamscape_trident/active/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_WEAPON)

/obj/item/rogueweapon/sword/arming/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_AVANTYNE)

/obj/item/rogueweapon/sword/long/judgement/vlord/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VAMPIRE_SWORD)

/obj/item/rogueweapon/sword/long/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_AVANTYNE)

/obj/item/rogueweapon/sword/rapier/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_AVANTYNE)

/obj/item/rogueweapon/whip/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_WEAPON)

/obj/item/storage/belt/rogue/leather/plaquegold/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

// The whisperer looks like an ordinary signet ring only while worn as a ring.
/obj/item/speakerinq/get_examine_highlight_status()
	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		if(wearer.wear_ring == src)
			return null
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_INQUIS_WHISPERER)

// Only the openly screaming performance reveals the churner's nature, not harmonizing.
/obj/item/psydonmusicbox/get_examine_highlight_status()
	if(!cranking || !isliving(loc))
		return null
	var/mob/living/wearer = loc
	if(wearer.has_status_effect(/datum/status_effect/buff/cranking_soulchurner))
		return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_INQUIS_CHURNER)
	return null

// Ordinary scabbards conceal their contents. Greatweapon straps visibly display them.
/obj/item/rogueweapon/scabbard/gwstrap/get_examine_highlight_status()
	var/list/highlight_status = sheathed?.get_examine_highlight_status()
	if(!highlight_status)
		return null
	return list(highlight_status[1], "It holds \a [sheathed.name]: [highlight_status[2]]")
