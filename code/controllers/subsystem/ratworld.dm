//This file is part of Ratwood-2.0.
//Copyright (c) 2023-2024 Ratwood-2.0 Contributors
//This file is licensed under the GNU General Public License version 3.
//See LICENSE.txt in the project root for license information.
//For a copy of the GNU General Public License version 3, see <https://www.gnu.org/licenses/gpl-3.0.en.html>.

/datum/controller/subsystem/ratworld
	name         = "Ratworld"
	init_order   = INIT_ORDER_DEFAULT // Run after most other things are ready
	flags        = SS_NO_FIRE // This subsystem doesn't need to be ticked.

/datum/controller/subsystem/ratworld/Initialize()
	initialize_rw_rarity_weights()
	return ..()
