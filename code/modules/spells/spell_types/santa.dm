//Santa spells!
/obj/effect/proc_holder/spell/aoe_turf/conjure/presents
	name = "召来礼物！"
	desc = ""
	school = "santa"
	recharge_time = 600
	clothes_req = FALSE
	antimagic_allowed = TRUE
	invocations = list("礼物现身！")
	invocation_type = "shout"
	range = 3
	cooldown_min = 50

	summon_type = list("/obj/item/a_gift")
	summon_lifespan = 0
	summon_amt = 5
