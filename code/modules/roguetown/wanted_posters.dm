/**
 * Wanted posters, shared by the bandit notices in town and the round end Outlaws tab.
 *
 * In-round (bandit notices) only publicly named people are shown: declared outlaws
 * (GLOB.outlawed_players) and bounty targets whose name is on the Excidium (/datum/bounty/target).
 * Hidden-identity bounties set target_hidden instead; those are only shown once the round is over.
 * Portraits come from SScrediticons.
 */
/datum/wanted_poster
	var/name
	/// Sum of all named bounties on this person, in mammons.
	var/amount = 0
	/// Reasons from each bounty. Already html-encoded by the add_bounty procs.
	var/list/crimes = list()

/datum/wanted_poster/New(name)
	src.name = name

/// Builds the current wanted list. One poster per person, with all their bounties merged.
/// include_hidden adds hidden-identity bounties; only use it once identities no longer matter (round end).
/proc/collect_wanted_posters(include_bounties = TRUE, include_hidden = FALSE)
	var/list/posters = list()
	for(var/outlaw_name in GLOB.outlawed_players)
		if(!posters[outlaw_name])
			posters[outlaw_name] = new /datum/wanted_poster(outlaw_name)
	if(include_bounties)
		for(var/datum/bounty/bounty as anything in GLOB.head_bounties)
			var/target_name = bounty.target
			if(!target_name && include_hidden)
				target_name = bounty.target_hidden
			if(!target_name)
				continue
			var/datum/wanted_poster/poster = posters[target_name]
			if(!poster)
				poster = new /datum/wanted_poster(target_name)
				posters[target_name] = poster
			if(isnum(bounty.amount))
				poster.amount += bounty.amount
			if(bounty.reason)
				poster.crimes |= bounty.reason
	. = list()
	for(var/poster_name in posters)
		. += posters[poster_name]

/// HTML for a set of wanted posters, or empty_text if there are none.
/proc/render_wanted_posters(list/posters, empty_text)
	if(!length(posters))
		return "<div style='text-align: center; color: #999; font-style: italic;'>[empty_text]</div>"

	var/list/html = list({"
	<style>
		.wanted-container {
			display: flex;
			flex-wrap: wrap;
			justify-content: center;
			gap: 20px;
			padding: 15px;
			max-width: calc(200px * 3 + 20px * 2);
			margin: 0 auto;
		}
		.wanted-poster {
			width: 175px;
			min-height: 228px;
			border: 3px double #5c2c0f;
			background-color: #f5e7d0;
			padding: 8px;
			box-shadow: 3px 3px 5px rgba(0,0,0,0.3);
			font-family: 'Times New Roman', serif;
			display: flex;
			flex-direction: column;
		}
		.wanted-header {
			color: #c70404;
			font-size: 28px;
			font-weight: bold;
			text-align: center;
			margin-bottom: 5px;
			text-transform: uppercase;
		}
		.wanted-divider {
			border-bottom: 2px solid #8B0000;
			margin: 5px 0;
		}
		.wanted-footer {
			color: #8B0000;
			font-size: 16px;
			font-weight: bold;
			text-align: center;
			margin-bottom: 8px;
			text-transform: uppercase;
		}
		.wanted-icon-container {
			width: 120px;
			height: 85px;
			margin: 0 auto;
			border: 2px solid #5c2c0f;
			background-color: #ccac74;
			padding: 3px;
		}
		.wanted-icon {
			width: 100%;
			height: 90%;
			object-fit: cover;
			image-rendering: pixelated;
		}
		.wanted-name-container {
			flex-grow: 1;
			display: flex;
			flex-direction: column;
			justify-content: center;
			min-height: 65px;
			margin-top: 5px;
		}
		.wanted-name {
			color: #000000;
			font-size: 18px;
			font-weight: bold;
			text-align: center;
			padding: 0 5px;
			text-transform: uppercase;
			word-break: break-word;
			overflow: hidden;
			display: -webkit-box;
			-webkit-line-clamp: 3;
			-webkit-box-orient: vertical;
		}
		.wanted-bounty {
			color: #5c2c0f;
			font-size: 15px;
			font-weight: bold;
			text-align: center;
		}
		.wanted-crime {
			color: #333;
			font-size: 13px;
			font-style: italic;
			text-align: center;
			word-break: break-word;
		}
	</style>
	<div class='wanted-container'>
	"})

	for(var/datum/wanted_poster/poster as anything in posters)
		var/portrait_b64 = SScrediticons.get_poster_base64(SScrediticons.get_portrait_by_name(poster.name))
		var/icon_html = portrait_b64 \
			? "<img class='wanted-icon' src='data:image/png;base64,[portrait_b64]'>" \
			: "<div class='wanted-icon' style='background:#8B4513;'></div>"
		var/bounty_html = ""
		if(poster.amount > 0)
			bounty_html += "<div class='wanted-bounty'>[poster.amount] MAMMONS</div>"
		for(var/crime in poster.crimes)
			bounty_html += "<div class='wanted-crime'>[crime]</div>"
		html += {"
		<div class='wanted-poster'>
			<div class='wanted-header'>WANTED</div>
			<div class='wanted-divider'></div>
			<div class='wanted-footer'>DEAD OR ALIVE</div>
			<div class='wanted-icon-container'>
				[icon_html]
			</div>
			<div class='wanted-name-container'>
				<div class='wanted-name'>[html_encode(poster.name)]</div>
			</div>
			[bounty_html]
		</div>
		"}

	html += "</div>"
	return html.Join()
