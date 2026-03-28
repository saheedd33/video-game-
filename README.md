# Creature Quest - 3D Open-World Creature-Collecting Game

A Pokémon-inspired 3D open-world game built with Godot 4.0, featuring creature collection, turn-based battles, exploration, and progression systems.

## Features

### Core Gameplay
- **Third-person 3D exploration** with smooth camera following
- **Open world** with different biomes and areas (Forest, Lake, Mountain, etc.)
- **Wild creature encounters** with chance-based spawning
- **Turn-based battle system** with type effectiveness calculations
- **Creature capturing** mechanics with various ball types
- **Team management** - carry up to 6 creatures
- **NPC trainers** for challenging battles
- **Progression system** - level creatures, unlock new areas

### Game Systems

#### Creature System
- 11 different creature species with unique types and stats
- All 18 Pokémon-inspired types (Normal, Fire, Water, Grass, Electric, etc.)
- Type effectiveness charts for strategic depth
- Evolution system - creatures evolve at certain levels
- Moveset system - each creature learns different moves
- Stat progression - creatures gain stats on level up

#### Battle System
- Turn-based combat with alternating player/enemy moves
- Damage calculation based on attacking/defending stats
- Type effectiveness multipliers
- Accuracy and power variations for moves
- Move categories (physical vs special)
- HP tracking and victory/defeat conditions

#### Inventory & Items
- Starting items: Creature Balls, Potions
- Different ball types for catching (Creature Ball, Great Ball, Ultra Ball)
- Healing items (Potion, Super Potion, Full Restore)
- Strategic item usage during battle

#### Player Progression
- Experience and leveling
- Money earned from battles
- Badge collection from gym leader victories
- Pokédex tracking of encountered creatures
- Save/Load functionality

### Technical Features
- Godot 4.0 with GDScript
- Comprehensive game database system
- Save/Load game state
- Dynamic world management
- Extensible UI system

## Project Structure

```
video-game-/
├── project.godot           # Godot project configuration
├── scenes/                 # Scene files (TSCN format)
│   └── main.tscn          # Main game scene
├── scripts/               # GDScript files
│   ├── creature.gd        # Creature instance class
│   ├── creature_types.gd  # Type system and effectiveness
│   ├── game_database.gd   # All game data management
│   ├── player.gd          # Player state and inventory
│   ├── player_controller.gd # Third-person character control
│   ├── battle_system.gd   # Turn-based battle logic
│   ├── world_manager.gd   # World and encounter management
│   ├── save_system.gd     # Save/load functionality
│   ├── ui_manager.gd      # UI system controller
│   ├── battle_ui_controller.gd # Battle UI
│   └── main_game.gd       # Main game orchestrator
├── data/                  # Game data files
│   └── creature_types.gd  # Type effectiveness data
└── ui/                    # UI scene files (TBA)
```

## How to Use

### Setup & Running

1. **Install Godot 4.0** from [godotengine.org](https://godotengine.org)
2. **Open the project** in Godot editor
3. **Run the game** by pressing F5 or clicking the Play button

### Basic Controls

- **WASD** - Move character
- **Mouse** - Control camera (relative to character)
- **Space** - Jump/Interact
- **E** - Interact with NPCs/Areas
- **I** - Open Inventory
- **P** - Pause/Menu
- **M** - Open Map/Pokédex

### Game Flow

1. **Start Game** - Get Emberling as starter creature
2. **Explore** - Move around the world and encounter wild creatures
3. **Battle** - Fight wild creatures or NPC trainers
4. **Catch** - Use Creature Balls to catch defeated creatures
5. **Manage Team** - Keep your best creatures and manage inventory
6. **Progress** - Level up creatures, earn badges, unlock new areas

## Creatures in Game

### Starter Evolution Lines

#### Emberling Line (Fire)
- Emberling (Base) → Flamewing (Stage 1) → Infernal Phoenix (Stage 2)

#### Aquatic Line (Water)
- Aquatic (Base) → Waveburst (Stage 1) → Tidal Leviathan (Water/Dragon Stage 2)

#### Grasshopper Line (Grass/Bug)
- Grasshopper (Base) → Verdant (Stage 1) → Blossomoth (Stage 2)

#### Voltpup Line (Electric)
- Voltpup (Base) → Thunderound (Stage 1)

## Battle Mechanics

### Type Effectiveness
The game implements a full type effectiveness chart with 18 types:
- **Super effective attacks** deal 2x damage
- **Normal effectiveness** deals 1x damage
- **Not very effective attacks** deal 0.5x damage
- Some type combinations are immune (0x damage)

### Damage Calculation
```
Damage = ((Level × 2/5 + 2) × Power × AttackStat / DefenseStat / 50 + 2) × Effectiveness × Variance
```

### Catch Mechanics
- Catch rate depends on creature's capture rate stat
- Lower HP increases catch chance
- Different ball types increase catch rate multiplier
  - Regular Ball: 1.0x (45% base for average creatures)
  - Great Ball: 1.33x
  - Ultra Ball: 1.78x

## Save System

Games are saved to `user://creature_quest_save/save_N.dat` (where N is the slot number)

Contains:
- Player name, level, money, experience
- Team creatures and their stats
- Inventory items
- Caught creatures list
- Pokédex entries

## Extensibility

The system is designed to be easily extended:

### Adding New Creatures
Edit `game_database.gd` - add to the `creature_species` dictionary:
```gdscript
{
    "id": 12,
    "name": "New Creature",
    "type1": CreatureType.TYPE.FIRE,
    "base_hp": 50,
    # ... other stats
}
```

### Adding New Moves
Add to `moves` dictionary in `game_database.gd`:
```gdscript
{
    "id": 6,
    "name": "New Move",
    "type": CreatureType.TYPE.WATER,
    "power": 50,
    "accuracy": 100,
}
```

### Adding New Items
Add to `items` dictionary:
```gdscript
{
    "name": "New Item",
    "type": "potion",
    "healing": 40,
}
```

## Advanced Features (Ready to Implement)

- [ ] Dynamic day/night cycle with lighting changes
- [ ] Weather system affecting battle mechanics
- [ ] NPC trainer AI improvements
- [ ] More creature species and moves
- [ ] Multiplayer battles/trading
- [ ] Flying/Riding mechanic
- [ ] Mega evolution
- [ ] Legendary creatures
- [ ] Quest system
- [ ] Gym badges display
- [ ] Sound effects and music system
- [ ] Particle effects for moves
- [ ] 3D models and animations

## Code Architecture

### Class Hierarchy
```
Creature - Represents an individual creature instance
CreatureType - Static type system and effectiveness
GameDatabase - Manages all game data
Player - Player state, team, inventory
PlayerController - Third-person character control
BattleSystem - Turn-based battle logic
WorldManager - Open world and encounters
SaveSystem - Persistence
UIManager - UI coordination
BattleUIController - Battle interface
```

### Signals & Events
- `battle_started` - When a battle begins
- `battle_ended(player_won)` - When battle concludes
- `move_executed(move_name, damage, effectiveness)` - After a move is used
- `creature_defeated(creature)` - When a creature faints
- `turn_ended` - After a turn completes

## Future Development

### Phase 2 - Visual Polish
- Creature 3D models and textures
- Team member sprites/models
- Creature animation for moves
- Environmental 3D models
- Particle effects for abilities

### Phase 3 - Content Expansion
- 50+ more creature species
- 100+ unique moves
- Legendary creatures
- Gym leaders with themed teams
- Region boss

### Phase 4 - Advanced Gameplay
- Trading system
- Online multiplayer
- Ranking system
- Mini-games
- Secret areas and Easter eggs

## License

This is an educational project inspired by Pokémon. Created for learning Godot game development.

## Support

For issues, bugs, or feature requests, refer to the project structure and modify the relevant scripts in `/scripts/` directory.