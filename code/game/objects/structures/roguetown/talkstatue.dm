/*
Talking statues. A means of giving communication to certain spheres
(Church, Mercenaries) without overloading them into the SCOM ecosystem.

Ideally, these machines will encourage gathering in a "centralized" area.
Hopefully they are more useful than just writing a letter via HERMES.

Mercenary statue: see talkstatue_mercenary.dm (legacy merc plumbing,
chat-delivered messaging, Topic handlers for register/response links) and
talkstatue_tgui.dm (the real player-facing TGUI: ui_state/ui_interact/ui_data/ui_act).

ES port note (Step 9f): Azure-Peak's talkstatue_tgui.dm is a shared TGUI surface across
mercenary/adventurer/wretch roles. ES has no Adventurer or Wretch-for-hire framework under
any name (confirmed exhaustively in Step 9e), so only the mercenary role's TGUI surface was
ported - see talkstatue_tgui.dm's header comment for exactly what was stubbed out.
*/

/obj/structure/roguemachine/talkstatue
	name = "talking statue"
	desc = "Don't map this one! Map the others!"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mercstatue"
	density = FALSE
	anchored = TRUE
	max_integrity = 0

/obj/structure/roguemachine/talkstatue/mercenary
	name = "mercenary statue"
	desc = "A gilbronze warrior erupts from the stone bell that homes them; foreign garb, horns of stone, claws of deathly metals. The perfect central-point of a proud warrior extrinsic to this place and tyme."
	var/static/list/mercenary_status = list()
	var/static/list/pending_registrations = list()
	var/static/list/pending_message_links = list()
	var/static/list/pending_broadcast_responses = list()
	var/static/list/pending_direct_responses = list()
	var/static/list/sender_cooldowns = list()
	var/message_char_limit = 300
	var/response_timeout = 2 MINUTES
	var/single_cooldown = 10 MINUTES
	var/broadcast_cooldown_time = 20 MINUTES
	var/static/response_id_counter = 0

/obj/structure/roguemachine/talkstatue/church
	name = "church statue"
	desc = "A blessed stone statue radiating divine presence."
	icon_state = "goldvendor" //TODO: Get proper sprite

/obj/structure/roguemachine/talkstatue/church/Initialize()
	. = ..()
	if(SSroguemachine.church_statue == null)
		SSroguemachine.church_statue = src
