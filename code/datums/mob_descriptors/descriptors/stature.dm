/datum/mob_descriptor/stature
	abstract_type = /datum/mob_descriptor/stature
	slot = MOB_DESCRIPTOR_SLOT_STATURE
	show_obscured = TRUE

/datum/mob_descriptor/stature/man
	name = "男人/女人"

/datum/mob_descriptor/stature/man/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "女人"
		if(SHE_HER_M)
			return "女人"
		if(HE_HIM)
			return "男人"
		if(HE_HIM_F)
			return "男人"
		if(THEY_THEM)
			return "人"
		if(THEY_THEM_F)
			return "人"
		else
			return "怪家伙"

/datum/mob_descriptor/stature/gentleman
	name = "绅士/淑女"

/datum/mob_descriptor/stature/gentleman/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "淑女"
		if(SHE_HER_M)
			return "淑女"
		if(HE_HIM)
			return "绅士"
		if(HE_HIM_F)
			return "绅士"
		if(THEY_THEM)
			return "雅士"
		if(THEY_THEM_F)
			return "雅士"
		else
			return "体面怪家伙"

/datum/mob_descriptor/stature/patriarch
	name = "家长/家母"

/datum/mob_descriptor/stature/patriarch/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "家母"
		if(HE_HIM)
			return "家长"
		if(THEY_THEM)
			return "尊长"
		if(THEY_THEM_F)
			return "尊长"
		else
			return "尊长"

/datum/mob_descriptor/stature/hag
	name = "老妪/老朽"

/datum/mob_descriptor/stature/hag/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "老妪"
		if(HE_HIM)
			return "老朽"
		if(THEY_THEM)
			return "长者"
		if(THEY_THEM_F)
			return "长者"
		else
			return "长者"

/datum/mob_descriptor/stature/villain
	name = "恶徒/恶女"

/datum/mob_descriptor/stature/villain/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "恶女"
		if(HE_HIM)
			return "恶徒"
		if(THEY_THEM)
			return "对头"
		if(THEY_THEM_F)
			return "对头"
		else
			return "对头"

/datum/mob_descriptor/stature/thug
	name = "恶棍"

/datum/mob_descriptor/stature/knave
	name = "无赖"

/datum/mob_descriptor/stature/wench
	name = "泼妇"

/datum/mob_descriptor/stature/snob
	name = "势利眼"

/datum/mob_descriptor/stature/slob
	name = "邋遢鬼"

/datum/mob_descriptor/stature/brute
	name = "粗人"

/datum/mob_descriptor/stature/highbrow
	name = "高雅之人"

/datum/mob_descriptor/stature/scholar
	name = "学者"

/datum/mob_descriptor/stature/rogue
	name = "浪子"

/datum/mob_descriptor/stature/hermit
	name = "隐士"

/datum/mob_descriptor/stature/pushover
	name = "软柿子"

/datum/mob_descriptor/stature/beguiler
	name = "蛊惑者"

/datum/mob_descriptor/stature/daredevil
	name = "亡命徒"

/datum/mob_descriptor/stature/valiant
	name = "英勇之人"

/datum/mob_descriptor/stature/adventurer
	name = "冒险者"

/datum/mob_descriptor/stature/fiend
	name = "恶徒"

/datum/mob_descriptor/stature/stoic
	name = "坚忍者"

/datum/mob_descriptor/stature/stooge
	name = "跟班"

/datum/mob_descriptor/stature/fool
	name = "蠢材"

/datum/mob_descriptor/stature/bookworm
	name = "书呆子"

/datum/mob_descriptor/stature/lowlife
	name = "下三滥"

/datum/mob_descriptor/stature/dignitary
	name = "显贵"

/datum/mob_descriptor/stature/degenerate
	name = "堕落者"

/datum/mob_descriptor/stature/zealot
	name = "狂热者"

/datum/mob_descriptor/stature/churl
	name = "粗鄙之人"

/datum/mob_descriptor/stature/archon
	name = "执政官"

/datum/mob_descriptor/stature/vizier
	name = "维齐尔"

/datum/mob_descriptor/stature/blaggard
	name = "恶棍"

/datum/mob_descriptor/stature/creep
	name = "怪胎"

/datum/mob_descriptor/stature/freek
	name = "怪人"

/datum/mob_descriptor/stature/weerdoe
	name = "怪咖"

/datum/mob_descriptor/stature/plump
	name = "丰满身形"

/datum/mob_descriptor/stature/savant
	name = "奇才"

/datum/mob_descriptor/stature/pilgrim
	name = "朝圣者"

/datum/mob_descriptor/stature/penitent
	name = "忏悔者"

/datum/mob_descriptor/stature/gallant
	name = "豪侠"

/datum/mob_descriptor/stature/firebrand
	name = "煽动者"

/datum/mob_descriptor/stature/mourner
	name = "哀悼者"

/datum/mob_descriptor/stature/caretaker
	name = "照料者"

/datum/mob_descriptor/stature/meddler
	name = "搅局者"

/datum/mob_descriptor/stature/dreamer
	name = "梦想家"

/datum/mob_descriptor/stature/ascetic
	name = "苦修者"

/datum/mob_descriptor/stature/sort
	name = "货色"

/datum/mob_descriptor/stature/sprite
	name = "小精灵"

/datum/mob_descriptor/stature/debutante
	name = "初入社交界的少女"

/datum/mob_descriptor/stature/coquette
	name = "卖弄风情者"

/datum/mob_descriptor/stature/songbird
	name = "百灵"

/datum/mob_descriptor/stature/lad
	name = "小伙/姑娘"

/datum/mob_descriptor/stature/lad/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "姑娘"
		if(SHE_HER_M)
			return "姑娘"
		if(HE_HIM)
			return "小伙"
		if(HE_HIM_F)
			return "小伙"
		if(THEY_THEM)
			return "小子"
		if(THEY_THEM_F)
			return "小子"
		else
			return "小子"

/datum/mob_descriptor/stature/beau
	name = "俊男/佳人"

/datum/mob_descriptor/stature/beau/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "佳人"
		if(SHE_HER_M)
			return "佳人"
		if(HE_HIM)
			return "俊男"
		if(HE_HIM_F)
			return "俊男"
		if(THEY_THEM)
			return "美人"
		if(THEY_THEM_F)
			return "美人"
		else
			return "美人"

/datum/mob_descriptor/stature/dandy
	name = "花花公子/少女"

/datum/mob_descriptor/stature/dandy/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "少女"
		if(SHE_HER_M)
			return "少女"
		if(HE_HIM)
			return "花花公子"
		if(HE_HIM_F)
			return "花花公子"
		if(THEY_THEM)
			return "浪荡子"
		if(THEY_THEM_F)
			return "浪荡子"
		else
			return "浪荡子"

/datum/mob_descriptor/stature/hero
	name = "英雄/女英雄"

/datum/mob_descriptor/stature/hero/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "女英雄"
		if(SHE_HER_M)
			return "女英雄"
		if(HE_HIM)
			return "英雄"
		if(HE_HIM_F)
			return "英雄"
		if(THEY_THEM)
			return "英雄"
		if(THEY_THEM_F)
			return "英雄"
		else
			return "英雄"

/datum/mob_descriptor/stature/host
	name = "主人/女主人"

/datum/mob_descriptor/stature/host/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "女主人"
		if(SHE_HER_M)
			return "女主人"
		if(HE_HIM)
			return "主人"
		if(HE_HIM_F)
			return "主人"
		if(THEY_THEM)
			return "主人"
		if(THEY_THEM_F)
			return "主人"
		else
			return "主人"

/datum/mob_descriptor/stature/widower
	name = "鳏夫/寡妇"

// Gnoll stature — always returns "gnoll" regardless of pronouns
/datum/mob_descriptor/stature/gnoll
	name = "Gnoll"

/datum/mob_descriptor/stature/gnoll/get_description(mob/living/described)
	return "gnoll"

/datum/mob_descriptor/stature/widower/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "寡妇"
		if(SHE_HER_M)
			return "寡妇"
		if(HE_HIM)
			return "鳏夫"
		if(HE_HIM_F)
			return "鳏夫"
		if(THEY_THEM)
			return "遗偶"
		if(THEY_THEM_F)
			return "遗偶"
		else
			return "遗偶"

/datum/mob_descriptor/stature/hunter
	name = "猎人/女猎手"

/datum/mob_descriptor/stature/hunter/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "女猎手"
		if(SHE_HER_M)
			return "女猎手"
		if(HE_HIM)
			return "猎人"
		if(HE_HIM_F)
			return "猎人"
		if(THEY_THEM)
			return "猎人"
		if(THEY_THEM_F)
			return "猎人"
		else
			return "猎人"

/datum/mob_descriptor/stature/bear
	name = "熊般的人"

/datum/mob_descriptor/stature/ruffian
	name = "恶汉/壮妞"

/datum/mob_descriptor/stature/ruffian/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "壮妞"
		if(SHE_HER_M)
			return "壮妞"
		if(HE_HIM)
			return "恶汉"
		if(HE_HIM_F)
			return "恶汉"
		if(THEY_THEM)
			return "恶徒"
		if(THEY_THEM_F)
			return "恶徒"
		else
			return "恶徒"

/datum/mob_descriptor/stature/wanderer
	name = "流浪者"

/datum/mob_descriptor/stature/hustler
	name = "钻营者"

/datum/mob_descriptor/stature/samaritan
	name = "善人"

/datum/mob_descriptor/stature/pupil
	name = "学生"

/datum/mob_descriptor/stature/soldier
	name = "士兵"

/datum/mob_descriptor/stature/recluse
	name = "隐居者"

/datum/mob_descriptor/stature/socialite
	name = "社交名流"
