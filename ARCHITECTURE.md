# Creature Quest - Technical Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Main Game (main_game.gd)             │
│         Orchestrates all systems and coordinates        │
└────────────┬────────────────────────────────────────────┘
             │
    ┌────────┼────────┬──────────────┬──────────┬────────┐
    │        │        │              │          │        │
    v        v        v              v          v        v
┌────────┐┌──────┐┌───────────┐┌─────────┐┌──────┐┌────────┐
│GameDB  ││Player││Battle     ││World    ││Save  ││Pokedex │
│        ││      ││System     ││Manager  ││System││        │
└────────┘└──────┘└───────────┘└─────────┘└──────┘└────────┘
    │        │        │              │
    │        │        │              │
    v        v        v              v
┌────────┐┌──────┐┌───────────┐┌─────────┐
│Creature││Team  ││Moves      ││Creatures│
│Database││      ││Available  ││         │
└────────┘└──────┘└───────────┘└─────────┘
```

## Core Classes

### Creature (scripts/creature.gd)
Represents a single creature instance with stats and state.

**Key Properties:**
- `id: int` - Species ID
- `name: String` - Creature name
- `level: int` - Combat level (1-100+)
- `exp: int` - Experience points
- `current_hp: int` - Current health
- `max_hp: int` - Maximum health
- `attack: int` - Physical attack stat
- `defense: int` - Physical defense stat
- `sp_attack: int` - Special attack stat
- `sp_defense: int` - Special defense stat
- `speed: int` - Speed stat
- `type1, type2: int` - Type associations
- `move_ids: Array[int]` - Learned moves
- `captured: bool` - Whether creature is owned

**Key Methods:**
- `gain_exp(amount)` - Add experience
- `level_up()` - Increase level/stats
- `take_damage(damage)` - Reduce health
- `heal(amount)` - Restore health
- `get_current_hp_percent()` - Health percentage

### CreatureType (data/creature_types.gd)
Static type system with effectiveness calculations.

**Constants:**
- 18 creature types (Normal, Fire, Water, etc.)
- Type names and colors mapped
- Type effectiveness chart

**Static Methods:**
- `get_type_effectiveness(attacker, defender) -> float` - Multiplier
- `get_type_name(type)` - String name
- `get_type_color(type)` - Color for UI

### GameDatabase (scripts/game_database.gd)
Central repository for all game data.

**Data Containers:**
- `creature_species: Dictionary` - All creature definitions
- `moves: Dictionary` - Move data
- `items: Dictionary` - Item definitions
- `trainers: Dictionary` - NPC trainer data

**Key Methods:**
- `get_creature_species(id)` - Fetch creature spec
- `get_move(id)` - Fetch move definition
- `get_item(id)` - Fetch item definition
- `get_trainer(id)` - Fetch trainer data
- `create_creature_instance(species_id, level)` - Instantiate creature

### Player (scripts/player.gd)
Manages player state, team, and inventory.

**Properties:**
- `team: Array[Creature]` - Active team (max 6)
- `inventory: Dictionary` - Item counts
- `money: int` - Currency
- `badges: int` - Gym badges earned
- `pokedex: Dictionary` - Seen creatures count
- `caught_creatures: Array[int]` - Owned species IDs

**Team Methods:**
- `add_to_team(creature_id, level)` - Catch/add creature
- `get_active_creature()` - Currently usable creature
- `switch_creature(index)` - Swap team member

**Inventory Methods:**
- `add_item(item_id, quantity)`
- `remove_item(item_id, quantity)` -> bool
- `has_item(item_id, quantity)` -> bool
- `use_potion(creature_index, item_id)` -> bool

**Economy Methods:**
- `add_money(amount)`
- `remove_money(amount)` -> bool

**Progression Methods:**
- `earn_exp_from_battle(amount)`
- `check_for_evolution()` - Evolution trigger
- `evolve_creature(creature)`
- `earn_badge()`

### BattleSystem (scripts/battle_system.gd)
Turn-based combat engine.

**Signals:**
- `battle_started` - Begin combat
- `battle_ended(player_won)` - Combat concludes
- `move_executed(name, damage, effectiveness)` - Move used
- `creature_defeated(creature)` - Creature faints
- `turn_ended` - Turn completed

**Combatants:**
- `player_creature: Creature` - Active player creature
- `enemy_creature: Creature` - Opposition creature
- `is_player_turn: bool` - Turn flag
- `is_battle_active: bool` - Battle state

**Battle Flow:**
```gdscript
start_battle(player_id, enemy_id, level)
  → execute_move(move_id)
    → calculate_damage(attacker, move, defender)
    → check defeat conditions
    → end_turn()
    → [enemy turn if active]
  → end_battle()
```

**Key Methods:**
- `start_battle(player_id, enemy_id, level)`
- `execute_move(move_id)` - Use move
- `calculate_damage(attacker, move, defender)` -> int
- `player_switch_creature(index)` -> bool
- `player_use_item(item_id, creature_index)` -> bool
- `attempt_catch(item_id)` -> bool
- `end_turn()` - Turn completion
- `end_battle()` - Combat over

### WorldManager (scripts/world_manager.gd)
Open world management and encounters.

**World State:**
- `current_area: String` - Active region
- `current_weather: String` - Current conditions
- `time_of_day: float` - Hours (0-24)
- `wild_creatures: Array` - Spawn definitions
- `active_npcs: Array` - Trainer data

**Configuration:**
- Per-area wild creature lists
- Spawn rates by creature
- NPC placement

**Key Methods:**
- `encounter_wild_creature()` -> Dictionary
- `set_current_area(area_name)`
- `get_weather_for_area(area)` -> String
- `get_available_wild_creatures()` -> Array

### BattleUIController (scripts/battle_ui_controller.gd)
Battle interface and player input.

**UI Elements:**
- Creature info labels
- HP progress bars
- Move buttons
- Battle log
- Item selection

**Key Methods:**
- `setup(battle_system)`
- `update_creature_info()` - Refresh display
- `update_move_buttons()` - Refresh move list
- `execute_move_button(slot)` - Move selection
- `display_log_message(message)` - Log output

### SaveSystem (scripts/save_system.gd)
Game persistence and state serialization.

**Storage:**
- Location: `user://creature_quest_save/save_N.dat`
- Format: JSON
- Auto-creates directory

**Key Methods:**
- `save_game(player, slot) -> bool`
- `load_game(slot) -> Dictionary`
- `save_exists(slot) -> bool`
- `delete_save(slot) -> bool`
- `serialize_creature(creature)` -> Dictionary
- `deserialize_creature(data)` -> Creature

**Save Contents:**
- Player stats (name, level, money)
- Team composition and stats
- Inventory items
- Caught creatures list
- Pokédex progress

### PlayerController (scripts/player_controller.gd)
Third-person character movement.

**Camera:**
- Follows behind character
- Configurable distance/height
- Smooth interpolation

**Movement:**
- WASD input
- Camera-relative movement
- Gravity and collisions
- Speed scaling

**Key Methods:**
- `set_battle_mode(in_battle)` - Freeze movement
- `check_interactions()` - Environment interaction
- `get_camera()` -> Camera3D

## Data Flow Examples

### Creature Evolution

```gdscript
# Player levels up creature
creature.gain_exp(100)  # In Creature
creature.level_up()
# Stats increase 10% per level

# After reaching threshold
player.check_for_evolution()  # In Player
player.evolve_creature(creature)
# Updates: id, name, type, stats, evolution_id, evolution_level
```

### Battle Damage Calculation

```gdscript
# Attacker uses move
damage = battle_system.calculate_damage(attacker, move, defender)

# Formula inside:
base_damage = ((Level*2/5 + 2) * Power * Atk/Def / 50 + 2)
effectiveness = type_effectiveness[move.type][defender.type]
final_damage = base_damage * effectiveness * variance(0.85-1.0)
```

### Catching Mechanics

```gdscript
# Use ball in battle
success = battle_system.attempt_catch(item_id)

# Calculation:
catch_rate = creature.capture_rate
modifier *= item.catch_rate_multiplier
hp_factor = 1.0 - (current_hp / max_hp * 0.5)  # Lower = better
final_rate = catch_rate * modifier * hp_factor
success = randf() < final_rate
```

## Extension Points

### Adding Mechanics

1. **Extend Creature** - Add move learning, held items
2. **Extend BattleSystem** - Add status effects, weather
3. **Extend GameDatabase** - Add more content
4. **Extend Player** - Add quest tracking

### Adding Features

```gdscript
# New system template
extends Node
class_name NewSystem

var player: Player
var game_db: GameDatabase

func _ready():
	add_to_group("game_systems")
	player = get_tree().get_first_node_in_group("player")
	game_db = get_tree().root.get_child(0).game_db

func do_something():
	# Implementation
	pass
```

## Performance Considerations

- **Creature Database**: Loaded once at startup
- **Battles**: Generated on-demand, minimal memory
- **Saves**: JSON serialization for readability
- **World**: Areas load/unload dynamically (future)

## Debugging

Enable console output with:
```gdscript
print("Message")  # Standard GDScript
```

Check signals with:
```gdscript
# In signals connection
signal_name.connect(handler_function)
```

Monitor performance:
```gdscript
# In _process
print("FPS: %d" % Engine.get_frames_per_second())
```

## Best Practices

1. **Keep data in GameDatabase** - Single source of truth
2. **Use groups** - `add_to_group()` for organization
3. **Connect signals** - Decouple systems
4. **Script organization** - One class per file
5. **Resource management** - Clean up with `queue_free()`

## Future Architecture

Plans for scaling:

- **Scene Manager** - Handle transitions
- **Event Bus** - Global signal aggregation
- **Async Loading** - Load areas in background
- **Network Layer** - Multiplayer infrastructure
- **Mod System** - Custom creatures/content

This architecture provides flexibility for both learning and expansion!
