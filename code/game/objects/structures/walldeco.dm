
/obj/structure/fluff/walldeco
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/decoration.dmi'
	anchored = TRUE
	density = FALSE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER+0.1

/obj/structure/fluff/walldeco/OnCrafted(dirin, user)
	pixel_x = 0
	pixel_y = 0
	switch(dirin)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32
	. = ..()

/obj/structure/fluff/walldeco/proc/get_attached_wall()
	return

/obj/structure/fluff/walldeco/wantedposter
	name = "bandit notice"
	desc = "A place for posters displaying the faces of roving bandits. Let's see if there are any this week..."
	icon_state = "wanted1"
	layer = BELOW_MOB_LAYER
	pixel_y = 32

/obj/structure/fluff/walldeco/wantedposter/r
	pixel_y = 0
	pixel_x = 32
/obj/structure/fluff/walldeco/wantedposter/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/fluff/walldeco/wantedposter/Initialize(mapload)
	. = ..()
	icon_state = "wanted[rand(1,3)]"
	dir = pick(GLOB.cardinals)

/obj/structure/fluff/walldeco/wantedposter/examine(mob/user)
	. = ..()
	if(user.Adjacent(src))
		if(SSrole_class_handler.bandits_in_round)
			. += span_bold("I see that bandits are active in the region.")
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
		else
			. += span_bold("There doesn't seem to be any reports of bandit activity.")

/obj/structure/fluff/walldeco/innsign
	name = "tavern sign"
	desc = "Weathered wood marks a place of respite in a cold and unfeeling world, where one can numb themselves with stale company and yet more stale drink."
	icon_state = "bar"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/steward
	name = "steward sign"
	desc = "Polished wood and leaf gold marks the office of the steward, manager of the city lord's estate and treasury."
	icon_state = "steward"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/bsmith
	name = "smithy sign"
	desc = "A small swinging anvil sign marks the smithy, where bloodied coin changes hands for hasty repairs and second hand weaponry."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bsmith"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/goblet
	name = "dining hall sign"
	desc = "A small swinging sign engraved with a goblet marks a common dining hall, it may lack the majesty of a city tavern, but it serves as a place to eat and rest in relative safety."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "goblet"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/flower
	name = "bathhouse sign"
	desc = "In a world of disease and violence a bathhouse is a rare spot of respite, where one can wash away exhausion and sin alike in warm, perfumed waters."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "flower"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersign
	name = "barber surgeon sign"
	desc = "The iconic swirl of the barber surgeon, where one can exchange coin for continued life."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersign"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersignreverse
	name = "barber surgeon sign"
	desc = "The iconic swirl of the barber surgeon, where one can exchange coin for continued life."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersignflip"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/mercenaryflag
	name = "mercenary guild banner"
	desc = "A rugged white banner stitched with a blood-red sparrow, the mark of the Mercenary Guild. A loose confederation of smaller mercenary companies and independent contractors, they can be trusted as far as you can spend your gold."
	icon_state = "sparrow"

/obj/structure/fluff/walldeco/xavo
	name = "white oak banner"
	desc = "Alone against a black sky and crimson field sits a white oak, regal and proud. The craftsmanship is exquisite and the banner is made of fine linen, but the heraldry is unfamiliar to you. Perhaps a forgotten dynasty or mercenary company?"
	icon_state = "xavo"

/obj/structure/fluff/walldeco/serpflag
	name = "house lindwurm banner"
	desc = "On a black field a fearsome serpent coils, the heraldry of the barony of House Lindwurm, 'Our Work is Eternal' went their house motto. Crushed by the taxes of the city lord's ancestors, the barony of Lord Lindwurm was forced to abandon its lands and flee to the capital city of Kingsfield. Now their estate is occupied by the wretches of the realm, squatting in the ruins of their glory."
	icon_state = "serpent"

/obj/structure/fluff/walldeco/artificerflag
	name = "artificer guild flag"
	desc = "Golden tools gleam against the blue of the oceans these craftsmen cross in their trade and works. The proud flag of the artificer guild, a collection of artisans and craftsmen who work together for shared profit and protection. In some cities their legal rights rival that of the petty nobility."
	icon_state = "artificer"

/obj/structure/fluff/walldeco/maidendrape
	name = "black drape"
	desc = "A dark drape of fabric, a featureless decoration for those too cowardly to mark their heraldry."
	icon_state = "black_drape"
	dir = SOUTH
	pixel_y = 32

/obj/structure/fluff/walldeco/wallshield
	name = "old wall shield"
	desc = "An old shield mounted on the wall, its heraldry damaged and faded by time. No longer able to serve its purpose in combat, its function is now decorative."
	icon_state = "wallshield"

/obj/structure/fluff/walldeco/sign/merchantsign
	name = "merchant guild sign"
	desc = "A sign advertising the services of the Merchant Guild, a widespread alliance of merchants across the world. Here you can hope to earn enough from your spoils to at least break even, if not afford a meal."
	icon_state = "shopsign_merchant_right"
	plane = -1
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/merchantsign/left
	name = "merchant guild sign"
	desc = "A sign advertising the services of the Merchant Guild, a widespread alliance of merchants across the world. Here you can hope to earn enough from your spoils to at least break even, if not afford a meal."
	icon_state = "shopsign_merchant_left"

/obj/structure/fluff/walldeco/psybanner
	name = "sun cult banner"
	desc = "Fine silk dyed in deep purple with golden thread in its trim, this banner is the mark of the Sun Cult. Wherever the rays of Astrata touch the world, there may be found her followers, who claim authority over all sects and temples."
	icon_state = "Psybanner-PURPLE"

/obj/structure/fluff/walldeco/psybanner/red
	name = "otavan orthodoxy banner"
	desc = "Rich red silk trimmed with silver thread marks the banner of the Otavan Orthodoxy, the church of the Creator-God PSYDON which dominates the nation of Otava and sends its Inquisition abroad to root out heresy in its neighbors."
	icon_state = "Psybanner-RED"

/obj/structure/fluff/walldeco/stone
	name = ""
	desc = ""
	icon_state = "walldec1"
	mouse_opacity = 0

/obj/structure/fluff/walldeco/stone/bronze
	color = "#ff9c1a"

/obj/structure/fluff/walldeco/church/line
	name = ""
	desc = ""
	icon_state = "churchslate"
	mouse_opacity = 0
	layer = ABOVE_NORMAL_TURF_LAYER+0.1
	plane = -8

/obj/structure/fluff/walldeco/stone/Initialize(mapload)
	icon_state = "walldec[rand(1,6)]"
	..()

/obj/structure/fluff/walldeco/maidensigil
	name = "stone sigil"
	desc = ""
	icon_state = "maidensigil"
	mouse_opacity = 0
	dir = SOUTH
	pixel_y = 32

/obj/structure/fluff/walldeco/maidensigil/r
	dir = WEST
	pixel_x = 16

/obj/structure/fluff/walldeco/bigpainting
	name = "midnight in the darkwood"
	desc = "Made by the traveling scholar Johann Grünwald in his travels across the continent, this painting depicts a moonlit night in the wilderness of Grenzelhoft. While there are many replicas of this painting, a few highly prized originals still exist."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "sherwoods"
	pixel_y = 32
	pixel_x = -16

/obj/structure/fluff/walldeco/bigpainting/lake
	name = "crimson lake lighthouse"
	desc = "Made by the traveling scholar Johann Grünwald in his travels across the lands, this painting depicts a peaceful moonlit lake in the Otavan countryside. A popular piece among the wealthy, even a good replica can fetch a fine price."
	icon_state = "lake"

/obj/structure/fluff/walldeco/mona
	name = "old painting"
	desc = "A painting of a woman, its frame is weathered and its paint peels from the canvas. Time has not treated this piece well, but it has a certain charm to it."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "mona"
	pixel_y = 32

/obj/structure/fluff/walldeco/chains
	name = "hanging chains"
	alpha = 180
	layer = 4.26
	icon_state = "chains1"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	can_buckle = 1
	buckle_lying = 0
	breakoutextra = 5 MINUTES
	buckleverb = "tie"
	smeltresult = /obj/item/rope/chain

/obj/structure/fluff/walldeco/chains/Initialize(mapload)
	icon_state = "chains[rand(1,8)]"
	..()

/obj/structure/fluff/walldeco/customflag
	name = "Banner of Rotwood Vale"
	desc = "Prominently fluttering in the breeze you see the sturdy banner of the realm, the heraldry of the city lord's family. Many would be honored to wear these colors in loyal service to the crown."
	icon_state = "wallflag"

/obj/structure/fluff/walldeco/customflag/Initialize(mapload)
	. = ..()
	if(SSmapping.current_map.map_name == "Rockhill")
		name = "Rockhill flag"
	else if(SSmapping.current_map.map_name == "Desert Town")
		name = "Al-Ashur flag"
		desc = "A banner flutters in the breeze in the proud heraldic colors of the Sultanate."
	else if(SSmapping.current_map.map_name == "Build Your Own Settlement")
		name = "New-Kingsfield flag"
		desc = "A banner flutters in the breeze in the proud heraldic colors of the Colony."
	else
		name = "Rotwood Vale flag"
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/structure/fluff/walldeco/customflag/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/fluff/walldeco/customflag/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "wallflag_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "wallflag_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)

/obj/structure/fluff/walldeco/moon
	name = "noccite banner"
	desc = "On a plate of silvered metal is draped a banner of deep purple, with the leering face of a crescent moon in its center; the heraldry of Noc has an expression of deep concentration, meant to inspire insight in his acolytes."
	icon_state = "moon"

/obj/structure/fluff/walldeco/rpainting
	name = "morbid painting"
	desc = "A painting of a candelabra and human skull on a covered table, it is a modestly grim yet tasteful piece of art."
	icon_state = "painting_1"

/obj/structure/fluff/walldeco/rpainting/forest
	name = "forest painting"
	desc = "A painting of a forest and distant castle shrouded in fog, it gives a feeling of mystery as the mind fills in the details."
	icon_state = "painting_2"

/obj/structure/fluff/walldeco/rpainting/crown
	name = "crown painting"
	desc = "A painting of a noble crown atop a book with an apple to its side, it is a simple yet elegant piece on the elements of any good ruler's life."
	icon_state = "painting_3"

/obj/structure/fluff/walldeco/med
	name = "frostbite diagram"
	desc = "Frostbite can cause severe burns and tissue damage if untreated, and while warming up can lessen the damage, existing frostbite must be treated. Slice open the patient and apply clamps to prevent bleedout, retract the incision, cut away the dead tissue with a scalpel, then clean the cut before removing your tools and closing up the wound."
	icon_state = "medposter"

/obj/structure/fluff/walldeco/med2
	name = "eye diagram"
	desc = "Eye surgery is a delicate procedure, requiring focus and skill. Ensure the patient is numbed from pain, then carefully cut at the eye, clamping and retracting for better access. Manipulate the eye with care to remove it, insert the replacement, slice to ensure a flow of healthy blood to the new eyes, then clean and close the site."
	icon_state = "medposter2"

/obj/structure/fluff/walldeco/med3
	name = "limb attachment diagram"
	desc = "When a limb is severed, it must be sutured immediately before bleedout occurs. Once the limb is applied to the stump, the arteries will be re-opened, and you must suture the limb. Use bone forceps to set the limb in place, then forceps to ensure the muscles won't separate once the patient begins to move. Suture to finish."
	icon_state = "medposter3"

/obj/structure/fluff/walldeco/med4
	name = "toxin diagram"
	desc = "Toxins can quickly travel through the blood and overwhelm the patient, so the use of leeches has become essential in modern medicine. Regular leeches will drain blood until they are fully engorged, harming the patient if ripped off early. Some students of medical science are gifted with the cheele, a helpful specialized leech which can switch between draining or infusing blood when its stomach is gently pressed on."
	icon_state = "medposter4"

/obj/structure/fluff/walldeco/med5
	name = "lux diagram"
	desc = "As the pump that moves blood through the body, lux naturally accumulates over the heart in layers. With careful practice, it can be scraped off the surface and collected for further use. This will leave the patient weakened, and they should rest properly after volunteering for lux donation."
	icon_state = "medposter5"

/obj/structure/fluff/walldeco/med6
	name = "revival diagram"
	desc = "When the new medical student is confused on how to revive a patient, there may be several causes for a failure to revitalize. Attempt to diagnose your patient if possible, as the issue may be ensanguination, significant bodily trauma, or even sustained oxygen deprivation damage. Rebalance their humors, tend bruises and burns, conduct CPR, and if all else fails ask your mentor for advice."
	icon_state = "medposter6"

/obj/structure/fluff/walldeco/alarm
	name = "le réveil murmure"
	icon_state = "alarm"
	desc = "This est un wall-mounted système d'alarme, designed dans les ."
	pixel_y = 32
	var/next_yap = 0
	var/onoff = 1 //Init on

/obj/structure/fluff/walldeco/alarm/attack_hand(mob/living/user)

	user.changeNext_move(CLICK_CD_MELEE)

	if(!(HAS_TRAIT(user, TRAIT_NOBLE)))
		playsound(src, 'sound/misc/machineno.ogg', 100, TRUE, -1)
		say("REMOVE THINE HAND FROM THE ALARM, CREATURE!")
		return

	playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
	if(onoff == 0)
		onoff = 1
		icon_state = "alarm"
		say("Bonjour, le sentinelle est active.")
		next_yap = 0 //They won't believe us unless we yap again
		return
	if(onoff == 1)
		onoff = 0
		icon_state = "face"
		say("A moment's rest, merci! Bonne nuit.")
		return
	else //failsafe
		onoff = 1
		icon_state = "alarm"

/obj/structure/fluff/walldeco/alarm/Crossed(mob/living/user)

	if(onoff == 0)
		return

	if(next_yap > world.time) //Yap cooldown
		return

	if(ishuman(user)) //are we a person?
		var/mob/living/carbon/human/HU = user

		if(HU.anti_magic_check()) //are we shielded?
			return

		if(!(HU in SStreasury.bank_accounts)) //first off- do we not have an account? we'll ALWAYS scream if that's the case
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("UNKNOWN PERSON IN SECURE AREA- ARRETZ-VOUZ!!")
			loud_message("The [src] shrieks, sounding an alarm", hearing_distance = 12)
			next_yap = world.time + 6 SECONDS
			return

		if(HAS_TRAIT(user, TRAIT_NOBLE))
			say("Salut, [user.real_name] de Sommet. Thirty-breths silence period active por votre grace.")
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			next_yap = world.time + 30 SECONDS
			return

		if((HU in SStreasury.bank_accounts)) //do we not have an account?
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			say("Yeoman [user.real_name] logged entering zone securisee.")
			return

		else //?????
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("UNAUTHORIZED PERSON IN SECURE AREA- ARRETZ-VOUZ!!")
			loud_message("The [src] shrieks, sounding an alarm", hearing_distance = 12)
			next_yap = world.time + 6 SECONDS

	else
		playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
		say("UNKNOWN CREATURE IN SECURE AREA- ARRETZ-VOUS!!")
		loud_message("The [src] shrieks, sounding an alarm", hearing_distance = 12)
		next_yap = world.time + 6 SECONDS

/obj/structure/fluff/walldeco/vinez // overlay vines for more flexibile mapping
	name = "vines"
	desc = "Nature begins to retake this place, slowly but surely."
	icon_state = "vinez"

/obj/structure/fluff/walldeco/vinez/l
	pixel_x = -32

/obj/structure/fluff/walldeco/vinez/r
	pixel_x = 32

/obj/structure/fluff/walldeco/vinez/offset
	name = "vines"
	desc = "Nature begins to retake this place, slowly but surely."
	icon_state = "vinez"
	pixel_y = 32

/obj/structure/fluff/walldeco/vinez/blue
	name = "vines"
	desc = "Nature begins to retake this place, slowly but surely."
	icon_state = "vinez_blue"

/obj/structure/fluff/walldeco/vinez/red
	name = "vines"
	desc = "Nature begins to retake this place, slowly but surely."
	icon_state = "vinez_red"

/obj/structure/fluff/walldeco/bath // suggestive stonework
	name = "suggestive stonework"
	desc = "Tasteful and inviting artwork depicting the female form, its as close as you'll get without any coin."
	icon_state = "bath1"
	pixel_x = -32
	alpha = 210

/obj/structure/fluff/walldeco/bath/two
	name = "inviting stonework"
	desc = "Suggestive and tempting artwork depicting the female form, the figure seems to beckon you closer, but the stone is cold and hard to your touch."
	icon_state = "bath2"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/three
	name = "tempting stonework"
	desc = "Inviting and detailed artwork depicting the male form, its physique is herculean and twisted in some great effort, promising much yet without real motion."
	icon_state = "bath3"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/four
	name = "detailed stonework"
	desc = "Impressive and sensual artwork depicting the female form, the figure invites yet rewards nothing to your touch, tempting one towards spending their coin elsewhere."
	icon_state = "bath4"
	pixel_y = 32
	pixel_x = 0

/obj/structure/fluff/walldeco/bath/five
	name = "raunchy stonework"
	desc = "Detailed and suggestive artwork depicting the female form, the figure is posed in an excited fashion, frozen in a moment of ecstasy."
	icon_state = "bath5"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/six
	name = "generous stonework"
	desc = "Tempting and luridly gifted artwork depicting the female form, the figure waits for the action of the audience, ever unable to reciprocate."
	icon_state = "bath6"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/seven
	name = "coy stonework"
	desc = "A playful and inviting artwork depicting the female form, the figure tempts those watching with a finger, to an act of passion that will never begin."
	icon_state = "bath7"
	pixel_x = 32

/obj/structure/fluff/walldeco/bath/gents
	name = "gents bath sign"
	desc = "Gentlemen only, please."
	icon_state = "gents"
	pixel_x = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/bath/ladies
	name = "ladies bath sign"
	desc = "Ladies only, please."
	icon_state = "ladies"
	pixel_x = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/bath/wallrope
	name = "rope"
	desc = "A good rope can solve most problems."
	icon_state = "wallrope"
	layer = WALL_OBJ_LAYER+0.1
	pixel_x = 0
	pixel_y = 0
	color = "#d66262"

/obj/structure/fluff/walldeco/sign/saiga
	name = "The Drunken Saiga"
	desc = "A stumbling beast is depicted on this sign, promising heavy inebriation at least, if not quality food or service."
	icon_state = "shopsign_inn_saiga_right"
	plane = -1
	pixel_x = 3
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/saiga/left
	icon_state = "shopsign_inn_saiga_left"

/obj/structure/fluff/walldeco/sign/trophy
	name = "saiga trophy"
	desc = "A mounted trophy of curved saiga horns, a hunter's pride."
	icon_state = "saiga_trophy"
	pixel_y = 32

/obj/effect/decal/shadow_floor
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "shadow_floor"
	mouse_opacity = 0

/obj/effect/decal/shadow_floor/corner
	icon_state = "shad_floorcorn"


/obj/structure/fluff/walldeco/fakewall
	name = "Wall...?"
	desc = "It certainly looks like a wall..."
	icon = 'icons/turf/walls/stone_wall.dmi'//change this
	icon_state = "stone"//change this
	density = FALSE
	opacity = TRUE
	max_integrity = 100

/obj/structure/fluff/walldeco/bogbanner
	name = "banner of victory"
	desc = "A red banner hanging off a wall, symbolizing martial triumph over all enemies."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bogbanner-whole"
	layer = WALL_OBJ_LAYER+0.1

/obj/structure/fluff/walldeco/bogbanner/brown
	name = "banner of the forgotten"
	desc = "A discolored and tattered banner hanging off a wall, its heraldry is long forgotten."
	icon_state = "bogbanner-brown"

/obj/structure/fluff/walldeco/bogbanner/zizo
	name = "profane banner"
	desc = "A bloodstained banner with a profane zcross depicted on it, the proud symbol of the Zizite Cabal."
	icon_state = "bogbanner-zizo"

/obj/structure/fluff/walldeco/bogbanner/bogguard
	name = "bog guard banner"
	desc = "A torn banner with a snake depicted on it, the proud standard of a local swamp militia. Its last members dead or deserted, it is now a relic of a dead hope."
	icon_state = "bogbanner-snake"

/obj/structure/fluff/walldeco/bogbanner/bogguard/animated
	name = "bog guard banner"
	desc = "A torn banner with a snake depicted on it, the proud standard of a local swamp militia. Its last members dead or deserted, it is now a relic of a dead hope."
	icon_state = "bogbanner-snake-anim"
