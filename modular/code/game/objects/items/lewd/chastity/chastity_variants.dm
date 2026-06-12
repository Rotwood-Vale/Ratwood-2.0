// Concrete chastity item variants and subtype defaults.

/obj/item/chastity/chastity_cage
	name = "贞操笼"
	desc = "一只结实的金属笼，用来防止肉棒勃起。"
	icon_state = "cage_standard"
	item_state = "cage_standard"
	mob_overlay_icon = "cage_standard"
	sprite_acc = /datum/sprite_accessory/chastity/cage
	chastity_type = 1
	chastity_organtype = 1
	suffix = null

/obj/item/chastity/chastity_cage/anal
	name = "带肛门护盾的贞操笼"
	desc = "一只牢固的贞操笼，后方还带有护盾，同样可阻止肛门接触。"
	chastity_type = 2
	icon_state = "cage_standard_shield"
	item_state = "cage_standard_shield"
	suffix = null

/obj/item/chastity/chastity_cage/spiked
	name = "尖刺贞操笼"
	desc = "一只内侧布满尖刺、带有惩戒意味的贞操笼。"
	chastity_type = 3
	icon_state = "cage_standard_spiked"
	item_state = "cage_standard_spiked"
	sprite_acc = /datum/sprite_accessory/chastity/spiked
	suffix = null

/obj/item/chastity/chastity_cage/spiked_anal
	name = "带肛门护盾的尖刺贞操笼"
	desc = "一只残酷的尖刺贞操笼，后方还配有封闭护盾。"
	chastity_type = 4
	icon_state = "cage_standard_spikeshield"
	item_state = "cage_standard_spikeshield"
	sprite_acc = /datum/sprite_accessory/chastity/spiked_anal
	suffix = null

/obj/item/chastity/chastity_cage/flat
	name = "扁平贞操笼"
	desc = "一种扁平轮廓的贞操笼，能更紧地贴合身体。"
	chastity_flat = TRUE
	icon_state = "cage_flat"
	item_state = "cage_flat"
	sprite_acc = /datum/sprite_accessory/chastity/flat
	suffix = null

/obj/item/chastity/chastity_cage/flat/anal
	name = "带肛门护盾的扁平贞操笼"
	desc = "一只扁平轮廓的贞操笼，并配有后方封闭护盾。"
	chastity_type = 2
	icon_state = "cage_flat_shield"
	item_state = "cage_flat_shield"
	suffix = null

/obj/item/chastity/chastity_cage/flat/spiked
	name = "尖刺扁平贞操笼"
	desc = "一只扁平轮廓的贞操笼，内侧带有惩戒用尖刺。"
	chastity_type = 3
	icon_state = "cage_flat_spiked"
	item_state = "cage_flat_spiked"
	suffix = null

/obj/item/chastity/chastity_cage/flat/spiked_anal
	name = "带肛门护盾的尖刺扁平贞操笼"
	desc = "一只扁平的尖刺贞操笼，并带有后方封闭护盾。"
	chastity_type = 4
	icon_state = "cage_flat_spikeshield"
	item_state = "cage_flat_spikeshield"
	suffix = null

/obj/item/chastity/chastity_belt
	name = "内置贞操带"
	desc = "一条带内置结构的上锁贞操带，用于持续性的拒绝与封闭。"
	icon_state = "cage_insert"
	item_state = "cage_insert"
	mob_overlay_icon = "cage_insert"
	sprite_acc = /datum/sprite_accessory/chastity/full
	chastity_type = 5
	chastity_organtype = 2
	suffix = null

/obj/item/chastity/chastity_belt/anal
	name = "带肛门护盾的内置贞操带"
	desc = "一条带内置结构的贞操带，并额外配有后方护盾。"
	chastity_type = 6
	icon_state = "cage_insert_shield"
	item_state = "cage_insert_shield"
	sprite_acc = /datum/sprite_accessory/chastity/anal
	suffix = null

/obj/item/chastity/chastity_belt/spiked
	name = "尖刺内置贞操带"
	desc = "一条装有残酷内向尖刺的内置贞操带。"
	chastity_type = 7
	icon_state = "cage_insert_spiked"
	item_state = "cage_insert_spiked"
	sprite_acc = /datum/sprite_accessory/chastity/spiked_belt
	suffix = null

/obj/item/chastity/chastity_belt/spiked_anal
	name = "带肛门护盾的尖刺内置贞操带"
	desc = "一条带尖刺内置结构的贞操带，并配有后方封闭护盾。"
	chastity_type = 8
	icon_state = "cage_insert_spikeshield"
	item_state = "cage_insert_spikeshield"
	sprite_acc = /datum/sprite_accessory/chastity/spiked_belt_anal
	suffix = null

/obj/item/chastity/intersex
	name = "双性贞操装置"
	desc = "一种宽大的框架，将贞操笼与护盾结合为一体并统一上锁。"
	icon_state = "cage_belt"
	item_state = "cage_belt"
	mob_overlay_icon = "cage_belt"
	sprite_acc = /datum/sprite_accessory/chastity/intersex
	chastity_type = 0
	chastity_organtype = 3
	suffix = null

/obj/item/chastity/intersex/spiked
	name = "尖刺双性贞操装置"
	desc = "一件装有内向惩戒尖刺的双性贞操装置。"
	chastity_type = 9
	icon_state = "cage_belt"
	item_state = "cage_belt"
	sprite_acc = /datum/sprite_accessory/chastity/spiked
	suffix = null

/obj/item/chastity/cursed
	name = "诅咒贞操装置"
	desc = "一件刻满符文、仿佛在蠕动的贞操框架。它弯曲起伏得像是活物。"
	icon_state = "cage_cursed"
	item_state = "cage_cursed"
	mob_overlay_icon = "cage_cursed"
	sprite_acc = /datum/sprite_accessory/chastity/cursed_belt
	chastity_cursed = TRUE
	lockable = FALSE
	locked = TRUE
	cursed_front_mode = 0
	cursed_anal_open = FALSE
	cursed_spikes_on = FALSE
	suffix = null
