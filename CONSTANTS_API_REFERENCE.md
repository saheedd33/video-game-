# Game Constants & API Reference

## Quick Reference

### Creature Types (CreatureType.TYPE)

```gdscript
NORMAL = 0       │ ICE = 5      │ POISON = 7    │ FLYING = 9
FIRE = 1         │ FIGHTING = 6 │ GROUND = 8    │ PSYCHIC = 10
WATER = 2        │              │               │
GRASS = 3        │ BUG = 11     │ ROCK = 12     │ GHOST = 13
ELECTRIC = 4     │ DRAGON = 14  │ DARK = 15     │ STEEL = 16
                 │ FAIRY = 17   │               │
```

### Type Effectiveness Quick Lookup

| Type | Strong Against | Weak To | Resists |
|------|---|---|---|
| Normal | — | Rock, Ghost | Ghost |
| Fire | Grass, Bug, Steel, Ice | Water, Ground, Rock | Fire, Grass, Steel, Fairy |
| Water | Fire, Ground, Rock | Grass, Electric | Fire, Water, Ice |
| Grass | Water, Ground, Rock | Fire, Ice, Poison, Flying, Bug | Ground, Water, Grass |
| Electric | Water, Flying | Ground | Electric, Flying |
| Ice | Grass, Flying, Ground, Dragon | Fire, Fighting, Rock, Steel | Ice |
| Fighting | Normal, Ice, Rock, Dark, Steel | Flying, Psychic, Fairy | Rock, Bug, Dark |
| Poison | Grass, Fairy | Ground, Psychic | Poison, Grass, Fairy |
| Ground | Fire, Electric, Poison, Rock, Steel | Water, Grass, Ice | Poison, Rock |
| Flying | Fighting, Bug, Grass | Electric, Ice, Rock | Fighting, Bug, Grass |
| Psychic | Fighting, Poison | Bug, Ghost, Dark | Fighting, Psychic |
| Bug | Grass, Psychic, Dark | Fire, Flying, Rock | Grass, Fighting, Ground |
| Rock | Fire, Ice, Flying, Bug | Water, Grass, Fighting, Ground, Steel | Normal, Flying, Poison, Fire |
| Ghost | Ghost, Psychic | Ghost, Dark | Poison, Bug |
| Dragon | Dragon | Ice, Dragon, Fairy | Fire, Water, Grass, Electric |
| Dark | Ghost, Psychic | Fighting, Bug, Fairy | Ghost, Dark |
| Steel | Ice, Rock, Fairy | Fire, Water, Ground | Normal, Flying, Rock, Bug, Steel, Grass, Psychic, Ice, Dragon, Fairy |
| Fairy | Fighting, Dragon, Dark | Poison, Steel | Fighting, Bug, Dark |

## Creature Database Reference

### Species Constants
```gdscript
1 = Emberling (Fire)           │ 7 = Grasshopper (Grass/Bug)
2 = Flamewing (Fire)           │ 8 = Verdant (Grass/Bug)
3 = Infernal Phoenix (Fire/Fly)│ 9 = Blossomoth (Grass/Bug)
4 = Aquatic (Water)            │ 10 = Voltpup (Electric)
5 = Waveburst (Water)          │ 11 = Thunderound (Electric)
6 = Tidal Leviathan (Water/Dra)│
```

### Evolution Thresholds
```gdscript
Base → Stage 1: Level 16
Stage 1 → Stage 2: Level 36
Stage 2: No further evolution
```

### Base Stats (Example - Emberling)
```
HP: 39       SP.Attack: 60    SP.Defense: 50
Attack: 52   Defense: 43      Speed: 65
Total: 309
```

## Move Reference

### Move Database (scripts/game_database.gd)

**Move Categories:**
- `physical` - Uses Attack/Defense
- `special` - Uses Sp.Attack/Sp.Defense

**Move ID → Name:**
```gdscript
0 = Scratch (Normal, Physical, Power 40)
1 = Tackle (Normal, Physical, Power 40)
2 = Ember (Fire, Special, Power 40)
3 = Water Gun (Water, Special, Power 40)
4 = Vine Whip (Grass, Physical, Power 45)
5 = Thunder Shock (Electric, Special, Power 40)
```

## Item Reference

### Item ID → Type

**Pokéballs (for catching):**
```gdscript
0 = Creature Ball (1.0x multiplier, 45% base)
1 = Great Ball (1.33x multiplier, 60% effective)
2 = Ultra Ball (1.78x multiplier, 80% effective)
```

**Healing Items:**
```gdscript
3 = Potion (20 HP)
4 = Super Potion (60 HP)
5 = Full Restore (Max HP)
```

**Item Properties:**
```gdscript
{
    "name": String,
    "type": "pokeball" | "potion" | "other",
    "description": String,
    "catch_rate": Float (for balls),
    "healing": Int (for potions)
}
```

## Trainer Reference

### Trainer IDs & Locations

```gdscript
1 = Trainer Zephyr (Forest, Creatures: [1,7], Reward: $500)
2 = Trainer Aqua (Lake, Creatures: [4,5], Reward: $600)
3 = Gym Leader Inferno (Mountain, Creatures: [3,9,11], Reward: $2000)
```

### Reward Values
- **Money** = Opponent Level × 50 (wild) or trainer-specific
- **Experience** = Opponent Max HP × 1.5 (wild battles)

## Player Progression

### Starting State
```gdscript
Player Name: "Trainer"
Level: 1
Money: 1000
Team: [Emberling (Level 5)]
Inventory: {0: 10, 3: 5}  # 10 Creature Balls, 5 Potions
Badges: 0
Pokedex: {}  # Empty, fills with captures
```

### Experience Formula
```gdscript
Level: 1 * 100 = 100 exp needed to level 2
Level: 2 * 100 = 200 exp needed to level 3
Stat Growth: ~10% per level
```

### Stat Calculation Example
```gdscript
# Base stats are set per species
# On level up, multiply by 1.1 (10% increase)
creature.max_hp *= 1.1
creature.attack *= 1.1
creature.defense *= 1.1
creature.sp_attack *= 1.1
creature.sp_defense *= 1.1
creature.speed *= 1.1
```

## Battle Mechanics Reference

### Damage Formula
```
DAMAGE = ((2×LEVEL/5 + 2) × POWER × ATTACK/DEFENSE / 50 + 2) × EFFECTIVENESS × VARIANCE

Where:
- LEVEL = Attacker's level
- POWER = Move's base power
- ATTACK = Attacker's stat (Attack or Sp.Attack)
- DEFENSE = Defender's stat (Defense or Sp.Defense)
- EFFECTIVENESS = Type matchup (0.0x, 0.5x, 1.0x, 2.0x)
- VARIANCE = Random 0.85 to 1.0
```

### Effectiveness Table
```
Super Effective (2.0x): Bonus type coverage
Normal Effective (1.0x): Standard damage
Not Effective (0.5x):    Resisted
Immune (0.0x):          Completely blocked
```

## Catch Mechanics

### Catch Formula
```gdscript
base_rate = creature.capture_rate
item_multiplier = item.catch_rate
hp_factor = 1.0 - (current_hp / max_hp * 0.5)

final_rate = base_rate * item_multiplier * hp_factor
success = randf() < final_rate
```

### Catch Rate Examples
```
Creature Ball + Full HP: 45% * 1.0 * 0.5 = 22.5%
Great Ball + Half HP:    45% * 1.33 * 0.75 = 45%
Ultra Ball + 1 HP:       45% * 1.78 * 1.0 = 89%
```

## Environment Reference

### Areas & Wild Creatures

**Forest**
- Emberling (30% spawn rate)
- Grasshopper (40%)
- Voltpup (20%)

**Lake**
- Aquatic (30%)
- Water-types (40%)

**Mountain**
- Grasshopper (20%)
- Rock-types (40%)

**Plains**
- Voltpup (20%)
- Emberling (30%)

### Weather Effects (Planned)
- `clear` - No effect
- `cloudy` - Fire moves -10%
- `rainy` - Water moves +10%
- `snowy` - Ice moves +10%

### Time of Day (Planned)
- `6:00-18:00` - Day (normal)
- `18:00-6:00` - Night (darker, ghost-types appear)

## File Locations

### Game Data
```
/data/creature_types.gd         - Type system
/scripts/game_database.gd       - All numerical data
/scripts/creature.gd            - Creature class
```

### Save Files
```
Windows: AppData\Local\Godot\app_userdata\Creature Quest\creature_quest_save\save_0.dat
Linux: ~/.local/share/godot/app_userdata/Creature Quest/creature_quest_save/save_0.dat
macOS: ~/Library/Application Support/Godot/app_userdata/Creature Quest/creature_quest_save/save_0.dat
```

### Save Data Format
```json
{
    "player_name": "Trainer",
    "level": 1,
    "money": 1000,
    "badges": 0,
    "team": [
        {
            "id": 1,
            "level": 5,
            "current_hp": 39,
            "max_hp": 39,
            // ... all creature stats
        }
    ],
    "inventory": {
        "0": 10,
        "3": 5
    },
    "caught_creatures": [1],
    "pokedex": {
        "1": 1
    }
}
```

## Cheat Codes (Console)

Open Godot Debug console and type:

```gdscript
# Get player reference
var player = get_tree().get_first_node_in_group("player")

# Add money
player.add_money(10000)

# Add creature to team
player.add_to_team(3, 50)  # Infernal Phoenix, Level 50

# Heal all
player.heal_all_creatures()

# View inventory
print(player.inventory)

# View team
for creature in player.team:
    print("%s Level %d - HP %d/%d" % [creature.name, creature.level, creature.current_hp, creature.max_hp])
```

## Performance Metrics

### Target Performance
- FPS: 60 (vSYNC enabled)
- FPS in Battle: 60 (no special effects yet)
- RAM Usage: ~100-200MB (scalable)
- Startup Time: 2-3 seconds

### Memory Usage (Estimated)
- Game Database: ~500KB
- Active Creatures (6): ~10KB
- Save File: ~2KB
- UI Assets: TBD (requires 3D models)

This reference covers all essential constants and mechanics. For more details, see the individual script files and ARCHITECTURE.md!
