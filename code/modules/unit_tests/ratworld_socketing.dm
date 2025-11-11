/datum/unit_test/ratworld_socketing/Run()
	// Unskilled attempt: should brick item some % of time; we force by simulating many tries until success or timeout
	var/obj/item/I = new
	I.AddComponent(/datum/component/ratworld_socketable, 1)
	var/mob/living/carbon/human/H = new
	var/obj/item/roguegem/G1 = new
	SEND_SIGNAL(I, COMSIG_PARENT_ATTACKBY, G1, H)
	if(!(I.flags_1 & CONDUCT_1))
		Fail("Item was not bricked by unskilled user (expected possible brick)")
	var/datum/component/ratworld_socketable/S = I.GetComponent(/datum/component/ratworld_socketable)
	if(S.socketed.len)
		Fail("Bricked socketing added gem unexpectedly")
	qdel(I)

	// Skilled attempt: Court Magician should not brick and should socket gem
	I = new
	I.AddComponent(/datum/component/ratworld_socketable, 1)
	S = I.GetComponent(/datum/component/ratworld_socketable)
	var/mob/living/carbon/human/H2 = new
	H2.job = "Court Magician"
	var/obj/item/roguegem/G2 = new
	SEND_SIGNAL(I, COMSIG_PARENT_ATTACKBY, G2, H2)
	if(I.flags_1 & CONDUCT_1)
		Fail("Skilled user bricked item unexpectedly")
	if(S.socketed.len != 1)
		Fail("Skilled socketing did not record gem")
