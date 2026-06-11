/datum/wound/dismemberment
	name = "流血残端"
	check_name = span_danger("<B>残端</B>")
	severity = WOUND_SEVERITY_CRITICAL
	whp = 75
	sewn_whp = 25
	bleed_rate = 25
	sewn_bleed_rate = 0.25
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 100
	sewn_woundpain = 20
	sew_threshold = 100 //absolutely awful to sew up
	mob_overlay = "dis_head"
	can_sew = TRUE
	can_cauterize = TRUE
	critical = TRUE
	sleep_healing = 0

/datum/wound/dismemberment/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/dismemberment) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/dismemberment/head
	name = "颈部残端"
	check_name = span_danger("<B>颈部残端</B>")
	mob_overlay = "dis_head"

/datum/wound/dismemberment/r_arm
	name = "右臂残端"
	check_name = span_danger("<B>右臂残端</B>")
	mob_overlay = "dis_ra"

/datum/wound/dismemberment/l_arm
	name = "左臂残端"
	check_name = span_danger("<B>左臂残端</B>")
	mob_overlay = "dis_la"

/datum/wound/dismemberment/r_leg
	name = "右腿残端"
	check_name = span_danger("<B>右腿残端</B>")
	mob_overlay = "dis_rl"

/datum/wound/dismemberment/l_leg
	name = "左腿残端"
	check_name = span_danger("<B>左腿残端</B>")
	mob_overlay = "dis_ll"

/datum/wound/dismemberment/taur
	name = "兽躯残端"
	check_name = span_danger("<B>兽躯残端</B>")
	mob_overlay = "dis_taur"
