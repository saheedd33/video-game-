# Getting Started with Creature Quest

This guide will help you set up and run the Creature Quest game.

## Installation

1. **Download Godot 4.0 or later** from https://godotengine.org
2. **Open Godot and import this project** by pointing to the project folder
3. **Open the project** - Godot will scan and index all files

## Running the Game

1. **Open `scenes/main.tscn`** in the editor (or it's set as the main scene)
2. **Press F5** or click the Play button to start the game
3. **Wait for initialization** - the engine will compile scripts and start

## Game Controls

### Exploration
- **W/A/S/D** - Move forward/left/backward/right
- **Mouse** - Camera looks around (relative to character)
- **Space** - Trigger wild creature encounter (30% chance)
- **P** - Pause game and open menu

### Menus
- **I** - Open inventory
- **M** - Open Pokedex/Map  
- **Esc/P** - Close menu or go back

## Game Progression

### Early Game (Levels 1-3)
1. Start with **Emberling** (Level 5)
2. Explore **Forest** area
3. Encounter wild creatures: Emberling, Grasshopper, Voltpup
4. Build your team by catching creatures
5. Battle **Trainer Zephyr** in the forest

### Mid Game (Levels 4-6)
1. Move to **Lake** area
2. Encounter water-type creatures: Aquatic, Water creatures
3. Battle **Trainer Aqua** at the lake
4. Evolve your creatures to Stage 1

### Late Game (Levels 7+)
1. Challenge the **Mountain** area
2. Face **Gym Leader Inferno** (your first major boss)
3. Earn your first badge
4. Unlock new areas for exploration

## System Overview

### Creatures

The game features 4 evolution lines with 11 total creatures:

- **Emberling → Flamewing → Infernal Phoenix** (Fire/Flying)
- **Aquatic → Waveburst → Tidal Leviathan** (Water/Dragon)  
- **Grasshopper → Verdant → Blossomoth** (Grass/Bug)
- **Voltpup → Thunderound** (Electric)

Each creature has:
- Base stats (HP, Attack, Defense, Sp.Atk, Sp.Def, Speed)
- Moveset (up to 4 moves per creature)
- Type(s) for type effectiveness
- Evolution requirements

### Battle System

Battles are **turn-based**:

1. **Player's turn** - Choose action:
   - Use a move (max 4 per creature)
   - Use an item (heal, potion)
   - Switch to another creature
   - Catch wild creature (wild battles only)

2. **Enemy's turn** - AI selects random move

3. **Type Advantage** affects damage:
   - Super effective = 2x damage
   - Normal = 1x damage
   - Not very effective = 0.5x damage
   - Immune = 0x damage

4. **Victory Conditions**:
   - Wild creature defeated → Can catch it
   - Trainer defeated → Earn money and experience
   - Your team defeated → Lose money and return to town

### Items

Starting inventory includes:
- **10x Creature Ball** - Catch wild creatures (45% base rate)
- **5x Potion** - Heal 20 HP

Additional available items:
- **Great Ball** - Better catch rate (60%)
- **Ultra Ball** - Excellent catch rate (80%)
- **Super Potion** - Heal 60 HP
- **Full Restore** - Completely heal creature

### Progression & Rewards

- Battle wild creatures: Gain experience and money
- Win trainer battles: Gain large amounts of exp and money
- Defeat gym leaders: Earn badges (unlock new areas)
- Catch creatures: Complete Pokédex entries

## Tips & Strategies

### Team Building
- Keep a **balanced team** - different types cover matchups
- Include a **tank** (high defense) for long fights
- Have **healing items** when exploring new areas
- **Rotate creatures** in battle to manage health

### Type Matchups
- Fire beats Grass, Bug, Steel
- Water beats Fire, Ground, Rock  
- Grass beats Water, Ground, Rock
- Electric beats Water, Flying
- (See data/creature_types.gd for full chart)

### Catching Creatures
- **Lower HP = higher catch rate** - weaken before catching
- **Use status moves** if available to lower resistance
- **Different balls** are more effective on different creatures
- **Keep multiple ball types** in inventory

### Leveling Up
- Creatures gain experience from battles
- Level up every 100 experience points (per level)
- Stats increase ~10% per level
- Evolution happens at specific levels (base → 16, stage1 → 36)

## Customization

### Add a New Creature

Edit **scripts/game_database.gd**, in the `load_creatures()` function:

```gdscript
12: {
    "id": 12,
    "name": "Your Creature",
    "type1": CreatureType.TYPE.FIRE,
    "type2": -1,
    "base_hp": 50,
    "base_attack": 60,
    "base_defense": 50,
    "base_sp_attack": 70,
    "base_sp_defense": 50,
    "base_speed": 65,
    "capture_rate": 45,
    "evolution_id": 13,
    "evolution_level": 16,
    "description": "Your creature's description"
}
```

### Add a New Move

In `load_moves()` function:

```gdscript
6: {
    "id": 6,
    "name": "Your Move",
    "type": CreatureType.TYPE.WATER,
    "category": "special",
    "power": 50,
    "accuracy": 100,
    "description": "What the move does"
}
```

### Add a New Trainer

In `load_trainers()` function:

```gdscript
4: {
    "id": 4,
    "name": "Trainer Name",
    "location": "Area Name",
    "creatures": [1, 2, 3],
    "dialogue": "Custom battle intro",
    "reward_money": 1000,
    "reward_exp": 200
}
```

## Troubleshooting

### Game Won't Start
- Check console for errors (View > Output)
- Verify all scripts are saved
- Ensure Godot version is 4.0+

### Creatures Not Appearing
- Check world_manager.gd spawn list
- Verify creature IDs in creature_species table
- Check encounters are enabled (30% chance with Space)

### Battle Issues
- Check battle_system.gd for move calculations
- Verify both creatures exist in database
- Check game_db initialized properly

### Save Not Working  
- Check user://creature_quest_save/ folder exists
- Verify FileAccess permissions
- Try creating saves again

## Next Steps

Once familiar with the game:

1. **Add more creatures** - The template makes it easy
2. **Create a custom area** - Extend world_manager.gd
3. **Design gym leaders** - Add unique trainer teams
4. **Build a storyline** - Use pokedex and progression tracking
5. **Add 3D assets** - Replace basic meshes with models

## Debug Commands

In the console (View > Output):

Every frame you can press:
- **Ctrl+X** - Save game
- **Ctrl+C** - Load game

## Resources

- **Godot Documentation**: https://docs.godotengine.org
- **GDScript Reference**: https://docs.godotengine.org/gdscript/
- **Godot Forum**: https://forum.godotengine.org
- **Game Design**: Study the data files in scripts/

## Credits

Created as an educational Pokémon-inspired game using Godot 4.0.

Enjoy building your creature collection! 🎮
