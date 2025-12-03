# Elder Scrolls-Style Alchemy System

## Overview
This system implements Elder Scrolls-style alchemy where reagents have effects that combine when mixed to create potions.

## How It Works

### 1. Boiling Herbs in Cauldron (Part 1)
Add exactly ONE herb to a cauldron with a base reagent:

**NOVICE LEVEL (Skill 1) - Primary Extraction (90u minimum):**
- Water (90u+) + Herb → "Herb Tonic"
- Cooking Oil (90u+) + Herb → "Oil of Herb"
- Wine (90u+) + Herb → "Herb Elixir"

**AMATEUR LEVEL (Skill 2):**
- Acid (90u+) + Herb → "Vitriol of Herb"
- Herb Tonic (30u+) + Herb → "Herb Concentrate" (boil again)

**JOURNEYMAN LEVEL (Skill 3) - Tertiary Processing (30u minimum):**
- Oil of Herb (30u+) + Herb → "Herb Paste" (boil again)
- Herb Elixir (30u+) + Herb → "Herb Syrup" (boil again)

**EXPERT LEVEL (Skill 4) - Quaternary Processing (30u minimum):**
- Vitriol of Herb (30u+) + Herb → "Herb Salt" (boil again)

**Example:**
- Water (90u) + Rosa → Creates "rosa tonic" (90u) with Rosa's effects
- Rosa tonic (30u) + Rosa → Creates "rosa concentrate" (30u) with Rosa's effects

### 2. Grinding in Mortar (Part 2)
Grind ingredients in a mortar & pestle to extract reagents with effects.
*(To be implemented - will assign effects to ground reagents)*

### 3. Mixing Reagents (Part 3)
When two reagents with **common effects** are mixed in a container, they automatically combine to create a potion!

**Example:**
- Rosa tonic (effects: heal burn, restore blood, fortify constitution)
- Calendula oil (effects: heal brute, fortify endurance, restore blood)
- **Common effect:** restore blood
- **Result:** Automatically creates a health potion!

## Alchemy Effects

### Positive Effects
- `EFFECT_HEAL_BRUTE` - Heals brute damage → Health Potion
- `EFFECT_HEAL_BURN` - Heals burn damage → Health Potion
- `EFFECT_HEAL_TOX` - Heals toxin damage → Antidote
- `EFFECT_RESTORE_STAMINA` - Restores stamina → Stamina Potion
- `EFFECT_RESTORE_ENERGY` - Restores energy → Mana Potion
- `EFFECT_RESTORE_BLOOD` - Restores blood → Health Potion
- `EFFECT_FORTIFY_STRENGTH` - Strength buff → Strength Potion
- `EFFECT_FORTIFY_PERCEPTION` - Perception buff → Perception Potion
- `EFFECT_FORTIFY_INTELLIGENCE` - Intelligence buff → Intelligence Potion
- `EFFECT_FORTIFY_CONSTITUTION` - Constitution buff → Constitution Potion
- `EFFECT_FORTIFY_ENDURANCE` - Endurance buff → Endurance Potion
- `EFFECT_FORTIFY_SPEED` - Speed buff → Speed Potion
- `EFFECT_FORTIFY_LUCK` - Luck buff → Luck Potion

### Negative Effects
- `EFFECT_PARALYZE` - Paralyzes target
- `EFFECT_POISON` - Poisons target → Berry Poison
- `EFFECT_DAMAGE_STAMINA` - Damages stamina → Stamina Poison
- `EFFECT_DAMAGE_ENERGY` - Damages energy
- `EFFECT_BLINDNESS` - Blinds target
- `EFFECT_SILENCE` - Silences target
- `EFFECT_SLOW` - Slows target
- `EFFECT_WEAKNESS` - Weakens target

## Current Herb Effects

### Symphitum
- EFFECT_HEAL_BRUTE
- EFFECT_HEAL_BURN
- EFFECT_RESTORE_BLOOD

### Calendula
- EFFECT_HEAL_BRUTE
- EFFECT_FORTIFY_ENDURANCE
- EFFECT_RESTORE_BLOOD

### Mentha
- EFFECT_FORTIFY_PERCEPTION
- EFFECT_FORTIFY_INTELLIGENCE
- EFFECT_RESTORE_STAMINA

### Rosa
- EFFECT_HEAL_BURN
- EFFECT_RESTORE_BLOOD
- EFFECT_FORTIFY_CONSTITUTION

## Complete Workflow Example

1. **Gather ingredients**
   - Collect rosa herb
   - Collect symphitum herb
   - Get water and cooking oil

2. **Create first extract**
   - Add 90u water to cauldron
   - Add rosa herb
   - Light cauldron
   - Result: 90u "rosa tonic" (effects: heal burn, restore blood, fortify constitution)

3. **Create second extract**
   - Add 90u cooking oil to cauldron
   - Add symphitum herb
   - Light cauldron
   - Result: 90u "symphitum oil" (effects: heal brute, heal burn, restore blood)

4. **Mix to create potion**
   - Pour rosa tonic into vial
   - Pour symphitum oil into same vial
   - **Automatic reaction:** Common effects detected (heal burn, restore blood)
   - Result: Creates health potion!

## Technical Details

- Mixing occurs automatically when reagents are added to containers
- Maximum 30 units converted per mixing event
- 2 reagents → 1 potion (50% conversion rate)
- Effects are sorted alphabetically to ensure consistent potion types
- Primary (first) common effect determines potion type

## Adding New Herbs

To add effects to a herb, add the `alchemy_effects` list:

```dm
/obj/item/alch/my_herb
    name = "my herb"
    icon_state = "my_herb"
    alchemy_effects = list(EFFECT_HEAL_BRUTE, EFFECT_FORTIFY_STRENGTH)
    major_pot = /datum/alch_cauldron_recipe/health_potion
    med_pot = /datum/alch_cauldron_recipe/str_potion
    minor_pot = null
```

The herb will pass its effects to any extract created from it!
