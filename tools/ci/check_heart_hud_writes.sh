#!/bin/bash
set -euo pipefail

RED="\033[0;31m"
NC="\033[0m"

lint="tools/ci/heart_hud_writes.awk"
fixture=$(mktemp)
trap 'rm -f "$fixture"' EXIT

cat > "$fixture" <<'EOF'
/mob/living
	VAR_PROTECTED/blood_volume = BLOOD_VOLUME_NORMAL
	var/toxloss = 0

/datum/wound/example
	woundpain = 10

/mob/living/proc/set_blood_volume(amount)
	blood_volume = amount

/mob/living/proc/setToxLoss(amount)
	toxloss = amount

/obj/item/bodypart/proc/receive_damage(brute = 0, burn = 0)
	brute_dam += brute
	burn_dam = max_damage

/datum/wound/dynamic/bite/upgrade(dam, armor)
	woundpain += dam

/mob/living/carbon/human/proc/adjust_pain_mod(multiplier)
	physiology.pain_mod *= multiplier

/mob/living/proc/allowed_reads(mob/living/other)
	if(blood_volume <= BLOOD_VOLUME_BAD && blood_volume != 0 && other.toxloss >= 1 || oxyloss == 5)
		to_chat(src, "blood_volume = [blood_volume], toxloss = [toxloss]")
	set_blood_volume(blood_volume - 1)
	other.adjustToxLoss(-5)
	// toxloss = 0
	/* oxyloss = 0 */
	/*
	blood_volume = 0
	*/
	var/toxloss = getToxLoss()
	toxloss = max(toxloss, 0)

/mob/living/proc/argument_shadow(brute_dam)
	brute_dam = 5

/mob/living/proc/local_does_not_hide_members(mob/living/other)
	var/oxyloss = 0
	oxyloss += 1
	other.oxyloss = oxyloss //BAD

/mob/living/carbon/human/restore_blood()
	blood_volume = BLOOD_VOLUME_NORMAL //BAD

/mob/living/proc/handle_passive_blood()
	blood_volume += passive_regen_rate //BAD
	src.blood_volume++ //BAD
	--blood_volume //BAD

/datum/status_effect/blooddrunk/on_apply()
	owner.toxloss *= 10 //BAD
	owner.oxyloss *= 10 //BAD
	BP.brute_dam *= 10 //BAD
	BP.burn_dam *= 10 //BAD

/obj/effect/proc_holder/spell/invoked/persistence/cast(list/targets)
	bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25) //BAD
	phy.pain_mod *= 1.5 //BAD
	addtimer(VARSET_CALLBACK(phy, pain_mod, phy.pain_mod /= 1.5), 19 SECONDS) //BAD

/obj/item/bodypart/proc/change_bodypart_status(new_limb_status, heal_limb)
	burn_dam = 0 //BAD

/datum/wound/proc/on_life()
	woundpain -= 1 //BAD

/datum/admins/Topic(href, href_list)
	target.vars["toxloss"] = 0 //BAD

/mob/living/carbon
	proc/old_style_nested()
		blood_volume = 0 //BAD

#define DRAIN_BLOOD(mob) mob.blood_volume -= 1 //BAD
#define POISON(mob) \
	mob.toxloss += 2 //BAD
EOF

expected=$(grep -n '//BAD' "$fixture" | cut -d: -f1 | tr '\n' ' ')
actual=$(awk -f "$lint" "$fixture" | cut -d: -f2 | tr '\n' ' ')
if [ "$expected" != "$actual" ]; then
	echo -e "${RED}ERROR: $lint self-test failed.${NC}"
	echo "expected lines: $expected"
	echo "reported lines: $actual"
	exit 1
fi

hits=$(find code modular* -type f -name '*.dm' -print0 | xargs -0 awk -f "$lint")
if [ -n "$hits" ]; then
	echo "$hits"
	echo
	echo -e "${RED}ERROR: a heart HUD input is written directly. Use the setter named on each line above.${NC}"
	echo -e "${RED}A direct write never refreshes the heart HUD, so the player sees stale blood, poison, suffocation or pain. See the header of code/_onclick/hud/hud.dm.${NC}"
	exit 1
fi
