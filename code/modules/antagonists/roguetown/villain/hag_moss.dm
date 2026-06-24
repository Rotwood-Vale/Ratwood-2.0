/obj/item/alch/hag_moss
	name = "Generic moss"
	desc = "A bloom of moss."
	icon_state = "moss_blank"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'

/obj/item/alch/hag_moss/sorrow
	name = "Mother's sorrow"
	desc = "A blossom of green moss. Said to induce melancholy when consumed by mothers-to-be, have-been, and would've-been."
	icon_state = "moss"

/obj/item/alch/hag_moss/fury
	name = "Mother's fury"
	desc = "A blossom of red moss. It cuts the throat when consumed, it burns and irritates the skin when touched. No one would dare cut down a mossmother, lest the very air be choked by her fury."
	color = "#610202"

/obj/item/alch/hag_moss/mercy
	name = "Mother's mercy"
	desc = "A blossom of pale, glowing moss. Holding it parts the trees, it is as if home, hearth, and a warm meal surround you at once."
	color = "#E0FFD1"

/obj/item/alch/hag_moss/grief
	name = "Mother's grief"
	desc = "A blossom of dark, velvet moss. Looking at it makes the silence louder, until it is deafening."
	color = "#2C2C2C"

/obj/item/alch/hag_moss/envy
	name = "Mother's envy"
	desc = "A blossom of bile-colored moss. It hisses when it touches metal and dissolves organic matter into a nutrient-rich slurry for the Mossmother's roots."
	color = "#A4C639"

/obj/item/alch/hag_moss/lullaby
	name = "Mother's lullaby"
	desc = "A blossom of deep indigo moss."
	color = "#203653"

/obj/item/alch/hag_moss/lullaby/examine(mob/user)
	. = ..()
	. += "<br><span class='italic'>You recall a childhood rhyme regarding this bloom...</span>"
	. += "<br>[span_notice("Smell too deep, fall asleep,")]"
	. += "[span_warning("Into the soil, quiet and steep.")]"
	. += "<br>[span_danger("Hear her hum a hollow strain,")]"
	. += "[span_boldnotice("To wash away your fear and pain.")]"

/obj/item/alch/hag_moss/pride
	name = "Mother's pride"
	desc = "A golden blossom of moss. It feels like a treasure in your hand, something to cherish until the end of your days."
	color = "#ffc400"

/obj/item/alch/hag_moss/enchanted
	name = "Enchanted Moss"
	desc = "A bloom of moss with magical properties. Its petals shimmer with an otherworldly light."
	icon_state = "moss_blank"
	var/boon_path // The path of the boon this moss grants essence for

/obj/item/alch/hag_moss/enchanted/Initialize(mapload)
	. = ..()
	// Letting color properly init first.
	spawn(1)
		apply_glow()

/obj/item/alch/hag_moss/enchanted/proc/apply_glow()
	src.add_filter("moss_glow", 1, list("type" = "outline", "color" = color, "size" = 1))

// Test mosses, don't make these craftable.
/obj/item/alch/hag_moss/enchanted/rotting
	name = "Rotting Moss"
	boon_path = /datum/hag_boon/curse/rotting_touch
	color = "#4b5320"

/obj/item/alch/hag_moss/enchanted/soaked
	name = "Soaked Moss"
	boon_path = /datum/hag_boon/buff/curse/waterlogged
	color = "#00e2d7"

// Proper mosses
/obj/item/alch/hag_moss/enchanted/deathless
	name = "Stormy Moss"
	boon_path = /datum/hag_boon/buff/storm_rebirth
	desc = "No matter how you slice it, this moss always seems to regrow into its original shape whilst the cuttings rapidly wilt."
	color = "#fffb00"

/obj/item/alch/hag_moss/enchanted/corrosive
	name = "Corrosive Moss"
	boon_path = /datum/hag_boon/trait/wyrd_labourer
	desc = "This moss looks strong, tough, as if the very leaves themselves have muscles."
	color = "#683700"

/obj/item/alch/hag_moss/enchanted/sprouting
	name = "Sprouting Moss"
	boon_path = /datum/hag_boon/trait/bogwalker
	desc = "Tiny offshoots bud from this moss, swaying towards anything within reach."
	color = "#3cd300"

/obj/item/alch/hag_moss/enchanted/crawling
	name = "Crawling Moss"
	boon_path = /datum/hag_boon/spell/spider_speak
	desc = "This moss frequently sprouts a little spider made out of moss, it crawls around on the moss."
	color = "#0e0b09"

/obj/item/alch/hag_moss/enchanted/caring
	name = "Caring Moss"
	boon_path = /datum/hag_boon/spell/twist_food
	desc = "This moss smells absolutely delicious."
	color = "#ff0cff"

/obj/item/alch/hag_moss/enchanted/rooted
	name = "Rooted Moss"
	boon_path = /datum/hag_boon/buff/natural_communion
	desc = "The moss seems to be growing a patch of grass underneath it, looking at it makes you feel more energetic."
	color = "#019715"

/obj/item/alch/hag_moss/enchanted/creeping
	name = "Creeping Moss"
	boon_path = /datum/hag_boon/buff/creeping_moss
	desc = "This moss is trying to cling to you, but for some reason... it feels nice. You like this."
	color = "#74b945"

/obj/item/alch/hag_moss/enchanted/gilded
	name = "Gilded Moss"
	boon_path = /datum/hag_boon/spell/find_riches
	desc = "You really want this moss. It is yours, your prized possession!."
	color = "#eca202"

/obj/item/alch/hag_moss/enchanted/drowned
	name = "Drowned Moss"
	boon_path = /datum/hag_boon/spell/banish
	desc = "This moss makes you feel like you aren't standing before it anymore. You sense water.. The depths, true terror lingers at the edges of your mind."
	color = "#037981"

/obj/item/alch/hag_moss/enchanted/dreamy
	name = "Dreamy Moss"
	boon_path = /datum/hag_boon/buff/curse/slumber
	color = "#b105a8"

// Trait mosses
/obj/item/alch/hag_moss/enchanted/random
	name = "Unstable Moss"
	/// The master list of all valid trait boons, built once on startup.
	var/static/list/trait_pool

/obj/item/alch/hag_moss/enchanted/random/Initialize(mapload)
	. = ..()
	if(!trait_pool)
		trait_pool = list()
		for(var/path in typesof(/datum/hag_boon/trait))
			var/datum/hag_boon/trait/dummy = path
			if(initial(dummy.hag_curse) || path == /datum/hag_boon/trait) 
				continue
			trait_pool += path

	var/list/valid_options = list()
	for(var/path in trait_pool)
		var/p_val = initial(path:points)
		if(is_in_range(p_val))
			valid_options += path

	if(length(valid_options))
		boon_path = pick(valid_options)
		name = "[initial(boon_path:name)] Moss"
	else
		stack_trace("Hag Moss at [get_turf(src)] failed to find a trait in its point range!")
		qdel(src)

/obj/item/alch/hag_moss/enchanted/random/proc/is_in_range(val)
	return FALSE

// --- The Three Tiers ---

/obj/item/alch/hag_moss/enchanted/random/low
	name = "Faded Moss"
	desc = "It makes you feel like a different person, ever so slightly."
	color = "#a9a9a9"

/obj/item/alch/hag_moss/enchanted/random/low/is_in_range(val)
		return val <= 50

/obj/item/alch/hag_moss/enchanted/random/mid
	name = "Lustrous Moss"
	desc = "It really makes you feel like your skin isn't your own."
	color = "#3db1ff"

/obj/item/alch/hag_moss/enchanted/random/mid/is_in_range(val)
		return val >= 51 && val <= 75

/obj/item/alch/hag_moss/enchanted/random/high
	name = "Prismatic Moss"
	desc = "The leaves show a different person, you wish you were them, you -could- be them."
	color = "#ff3de1"

/obj/item/alch/hag_moss/enchanted/random/high/is_in_range(val)
		return val >= 76

/obj/item/reagent_containers/lux/moss
	name = "lux moss"
	desc = "The stuff of life and souls, a purified imitation made by the forest."
	icon_state = "moss_blank"
