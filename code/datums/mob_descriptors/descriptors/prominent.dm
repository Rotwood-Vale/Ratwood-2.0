/datum/mob_descriptor/prominent
	abstract_type = /datum/mob_descriptor/prominent
	slot = MOB_DESCRIPTOR_SLOT_PROMINENT

/datum/mob_descriptor/prominent/none
	name = "无"

/datum/mob_descriptor/prominent/none/can_describe(mob/living/described)
	return FALSE

/datum/mob_descriptor/prominent/custom
	var/custom_index

/datum/mob_descriptor/prominent/custom/can_describe(mob/living/described)
	if(length(described.custom_descriptors) < custom_index)
		return FALSE
	return TRUE

/datum/mob_descriptor/prominent/custom/get_description(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	return entry.content_text

/datum/mob_descriptor/prominent/custom/get_pre_string(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	switch(entry.prefix_type)
		if(CUSTOM_PREFIX_HAS)
			return null
		if(CUSTOM_PREFIX_HAS_A)
			return null
		if(CUSTOM_PREFIX_HAS_AN)
			return null
		if(CUSTOM_PREFIX_IS)
			return null
		if(CUSTOM_PREFIX_LOOKS)
			return null

/datum/mob_descriptor/prominent/custom/get_verbage(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	switch(entry.prefix_type)
		if(CUSTOM_PREFIX_HAS)
			return "%HAVE%"
		if(CUSTOM_PREFIX_HAS_A)
			return "%HAVE%"
		if(CUSTOM_PREFIX_HAS_AN)
			return "%HAVE%"
		if(CUSTOM_PREFIX_IS)
			return "%ARE%"
		if(CUSTOM_PREFIX_LOOKS)
			return "%LOOK%"

/datum/mob_descriptor/prominent/custom/one
	name = "自定义 #1"
	custom_index = 1

/datum/mob_descriptor/prominent/custom/two
	name = "自定义 #2"
	custom_index = 2

/datum/mob_descriptor/prominent/hunched_over
	name = "佝偻"
	verbage = "%ARE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/crooked_nose
	name = "歪鼻"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/drooling
	name = "流着口水"
	verbage = "%ARE%"

/datum/mob_descriptor/prominent/lazy_eye
	name = "斗鸡眼"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/bloodshot_eye
	name = "布满血丝的眼睛"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/baggy_eye
	name = "浮肿的眼袋"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/deadfish_eye
	name = "死鱼眼"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/twitchy
	name = "抽搐不安"
	verbage = "%ARE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/clumsy
	name = "笨拙"
	verbage = "%ARE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/unkempt
	name = "邋遢"
	verbage = "%ARE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/tidy
	name = "整洁"
	verbage = "%ARE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/eloquent
	name = "善辩"
	verbage = "%ARE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/thick_tail
	name = "粗尾巴"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/thick_tail/can_describe(mob/living/described)
	if(!ishuman(described))
		return TRUE
	var/mob/living/carbon/human/human = described
	if(!human.getorganslot(ORGAN_SLOT_TAIL))
		return FALSE
	return TRUE

/datum/mob_descriptor/prominent/cleft_lip
	name = "唇裂"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/physically_deformed
	name = "身体畸形"
	verbage = "%ARE%"

/datum/mob_descriptor/prominent/extensive_scars
	name = "大片疤痕"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/move_strange
	name = "动作古怪"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/ghoulish_appearance
	name = "食尸鬼般的外貌"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/prominent_chest
	name = "胸部突出"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/prominent_bottom
	name = "丰满的臀部"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/prominent_potbelly
	name = "明显的大肚腩"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/prominent_thighs
	name = "丰满的大腿"
	verbage = "%HAVE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/prominent_shoulders
	name = "宽阔的肩膀"
	verbage = "%HAVE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/prominent_jawline
	name = "分明的下颌线"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/prominent_ears
	name = "招风耳"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/cold_gaze
	name = "冷淡的目光"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/piercing_gaze
	name = "锐利的目光"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/innocent_gaze
	name = "无辜的目光"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/promiscuous_mannerisms
	name = "风情举止"
	verbage = "%HAVE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/intimidating_presence
	name = "压迫感"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/meek_presence
	name = "怯懦气质"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/adorable_presence
	name = "可爱气质"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/lordly_presence
	name = "贵胄气度"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/doting_presence
	name = "关切气质"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/aristocratic_haughtiness
	name = "贵族式傲慢"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/ghastly_pale
	name = "惨白"
	verbage = "%ARE%"

/datum/mob_descriptor/prominent/elaborate_tattoos
	name = "繁复纹身"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/ritual_tattoos
	name = "仪式纹身"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/tribal_tattoos
	name = "部族纹身"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/slave_tattoos
	name = "奴隶纹身"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/enigmatic_tattoos
	name = "神秘纹身"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/mean_look
	name = "凶相"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/haughty_atmosphere
	name = "傲慢气场"
	verbage = "%HAVE%"
	prefix = ""
	show_obscured = TRUE

/datum/mob_descriptor/prominent/untrustworthy
	name = "不可信"
	verbage = "显得"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/ratty_hair
	name = "乱蓬蓬的头发"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/predatory_look
	name = "掠食者般的目光"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/chaste_mannerism
	name = "端庄举止"
	verbage = "%HAVE%"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/whimsy
	name = "异想天开的气息"
	verbage = "%HAVE%"
	prefix = ""
	suffix = "环绕在 %HIM% 身边"
	show_obscured = TRUE

/datum/mob_descriptor/prominent/dim_look
	name = "呆滞神情"
	verbage = "%HAVE%"
	prefix = ""

/datum/mob_descriptor/prominent/canine_features
	name = "犬科特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/feline_features
	name = "猫科特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/hyaenidae_features
	name = "鬣犬科特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/equine_features
	name = "马科特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/bovine_features
	name = "牛科特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/ursine_features
	name = "熊科特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/cervine_features
	name = "鹿科特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/lapine_features
	name = "兔科特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/rodent_features
	name = "啮齿类特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/primate_features
	name = "灵长类特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/marsupial_features
	name = "有袋类特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/lizard_features
	name = "蜥蜴特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/avian_features
	name = "鸟类特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/amphibian_features
	name = "两栖类特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/insectoid_features
	name = "昆虫类特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/marine_features
	name = "海生特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/vulpine_features
	name = "狐类特征"
	verbage = "%HAVE%"

/datum/mob_descriptor/prominent/prominent_ears
	name = "招风耳"
	verbage = "%HAVE%"
