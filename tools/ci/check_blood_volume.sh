#!/bin/bash
set -euo pipefail

RED="\033[0;31m"
NC="\033[0m"

lint="tools/ci/blood_volume_writes.awk"
fixture=$(mktemp)
trap 'rm -f "$fixture"' EXIT

cat > "$fixture" <<'EOF'
/mob/living/carbon/human/species/example
	blood_volume = BLOOD_VOLUME_NORMAL

/mob/living
	VAR_PROTECTED/blood_volume = BLOOD_VOLUME_NORMAL

/mob/living/proc/set_blood_volume(amount)
	amount = clamp(amount, 0, BLOOD_VOLUME_MAXIMUM)
	blood_volume = amount

/mob/living/proc/allowed_reads(mob/living/other)
	if(blood_volume <= BLOOD_VOLUME_BAD && blood_volume != 0 && blood_volume >= 1 || blood_volume == 5)
		to_chat(src, "blood_volume = [blood_volume]")
	var/old_volume = blood_volume
	set_blood_volume(blood_volume - old_volume)
	other.adjust_blood_volume(-5)
	// blood_volume = 0
	/* blood_volume = 0 */
	/*
	blood_volume = 0
	*/
	if(!blood_volume || blood_volume & 1)
		return

/mob/living/carbon/human/restore_blood()
	blood_volume = BLOOD_VOLUME_NORMAL //BAD
	bleed_rate = 0

/mob/living/proc/handle_passive_blood()
	blood_volume += passive_regen_rate //BAD

/mob/living/carbon/adjustToxLoss(amount)
	if(amount > 0)
		blood_volume -= 5*amount //BAD
	blood_volume = max(blood_volume, 0) // clamp //BAD

/mob/living/carbon/human/proc/try_blood_milking(mob/living/carbon/human/milked)
	milked.blood_volume = max(0, milked.blood_volume - 20) //BAD
	src.blood_volume++ //BAD
	--blood_volume //BAD
	blood_volume *= 0.5 //BAD
	vars["blood_volume"] = 0 //BAD

/mob/living/carbon
	proc/old_style_nested()
		blood_volume = 0 //BAD

#define DRAIN_BLOOD(mob) mob.blood_volume -= 1 //BAD
#define DRAIN_MORE(mob) \
	mob.blood_volume -= 2 //BAD
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
	echo -e "${RED}ERROR: blood_volume is written directly. Use set_blood_volume() or adjust_blood_volume() instead.${NC}"
	echo -e "${RED}A direct write skips COMSIG_LIVING_BLOOD_VOLUME_CHANGED and never refreshes the heart HUD, so the player sees stale blood loss.${NC}"
	exit 1
fi
