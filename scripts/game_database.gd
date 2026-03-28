# Game Database - manages all game data (creatures, moves, items)
extends Node
class_name GameDatabase

# Creature species data
var creature_species = {}
var moves = {}
var items = {}
var trainers = {}

func _ready():
	load_all_data()

func load_all_data():
	load_creatures()
	load_moves()
	load_items()
	load_trainers()

func load_creatures():
	# Create creature species data
	creature_species = {
		1: {
			"id": 1,
			"name": "Emberling",
			"type1": CreatureType.TYPE.FIRE,
			"type2": -1,
			"base_hp": 39,
			"base_attack": 52,
			"base_defense": 43,
			"base_sp_attack": 60,
			"base_sp_defense": 50,
			"base_speed": 65,
			"capture_rate": 45,
			"evolution_id": 2,
			"evolution_level": 16,
			"description": "A small fire-type creature with a flame on its head.",
		},
		2: {
			"id": 2,
			"name": "Flamewing",
			"type1": CreatureType.TYPE.FIRE,
			"type2": -1,
			"base_hp": 58,
			"base_attack": 62,
			"base_defense": 63,
			"base_sp_attack": 80,
			"base_sp_defense": 65,
			"base_speed": 80,
			"capture_rate": 45,
			"evolution_id": 3,
			"evolution_level": 36,
			"description": "An evolved fire-type with increased power.",
		},
		3: {
			"id": 3,
			"name": "Infernal Phoenix",
			"type1": CreatureType.TYPE.FIRE,
			"type2": CreatureType.TYPE.FLYING,
			"base_hp": 78,
			"base_attack": 84,
			"base_defense": 78,
			"base_sp_attack": 109,
			"base_sp_defense": 85,
			"base_speed": 100,
			"capture_rate": 45,
			"evolution_id": -1,
			"evolution_level": -1,
			"description": "A powerful fire-flying type that can soar through the skies.",
		},
		4: {
			"id": 4,
			"name": "Aquatic",
			"type1": CreatureType.TYPE.WATER,
			"type2": -1,
			"base_hp": 44,
			"base_attack": 48,
			"base_defense": 65,
			"base_sp_attack": 50,
			"base_sp_defense": 64,
			"base_speed": 43,
			"capture_rate": 45,
			"evolution_id": 5,
			"evolution_level": 16,
			"description": "A small water-type creature.",
		},
		5: {
			"id": 5,
			"name": "Waveburst",
			"type1": CreatureType.TYPE.WATER,
			"type2": -1,
			"base_hp": 59,
			"base_attack": 63,
			"base_defense": 80,
			"base_sp_attack": 65,
			"base_sp_defense": 80,
			"base_speed": 58,
			"capture_rate": 45,
			"evolution_id": 6,
			"evolution_level": 36,
			"description": "An evolved water-type creature.",
		},
		6: {
			"id": 6,
			"name": "Tidal Leviathan",
			"type1": CreatureType.TYPE.WATER,
			"type2": CreatureType.TYPE.DRAGON,
			"base_hp": 79,
			"base_attack": 83,
			"base_defense": 100,
			"base_sp_attack": 85,
			"base_sp_defense": 105,
			"base_speed": 78,
			"capture_rate": 45,
			"evolution_id": -1,
			"evolution_level": -1,
			"description": "A powerful water-dragon hybrid creature.",
		},
		7: {
			"id": 7,
			"name": "Grasshopper",
			"type1": CreatureType.TYPE.GRASS,
			"type2": -1,
			"base_hp": 45,
			"base_attack": 49,
			"base_defense": 49,
			"base_sp_attack": 65,
			"base_sp_defense": 65,
			"base_speed": 45,
			"capture_rate": 45,
			"evolution_id": 8,
			"evolution_level": 16,
			"description": "A grass-type insect-like creature.",
		},
		8: {
			"id": 8,
			"name": "Verdant",
			"type1": CreatureType.TYPE.GRASS,
			"type2": CreatureType.TYPE.BUG,
			"base_hp": 60,
			"base_attack": 65,
			"base_defense": 65,
			"base_sp_attack": 90,
			"base_sp_defense": 75,
			"base_speed": 65,
			"capture_rate": 45,
			"evolution_id": 9,
			"evolution_level": 36,
			"description": "A grass-bug hybrid with flowering petals.",
		},
		9: {
			"id": 9,
			"name": "Blossomoth",
			"type1": CreatureType.TYPE.GRASS,
			"type2": CreatureType.TYPE.BUG,
			"base_hp": 80,
			"base_attack": 85,
			"base_defense": 85,
			"base_sp_attack": 110,
			"base_sp_defense": 100,
			"base_speed": 75,
			"capture_rate": 45,
			"evolution_id": -1,
			"evolution_level": -1,
			"description": "A beautiful grass-bug butterfly creature.",
		},
		10: {
			"id": 10,
			"name": "Voltpup",
			"type1": CreatureType.TYPE.ELECTRIC,
			"type2": -1,
			"base_hp": 35,
			"base_attack": 55,
			"base_defense": 40,
			"base_sp_attack": 50,
			"base_sp_defense": 50,
			"base_speed": 90,
			"capture_rate": 45,
			"evolution_id": 11,
			"evolution_level": 16,
			"description": "A small electric puppy with crackling energy.",
		},
		11: {
			"id": 11,
			"name": "Thunderound",
			"type1": CreatureType.TYPE.ELECTRIC,
			"type2": -1,
			"base_hp": 65,
			"base_attack": 80,
			"base_defense": 60,
			"base_sp_attack": 80,
			"base_sp_defense": 60,
			"base_speed": 120,
			"capture_rate": 45,
			"evolution_id": -1,
			"evolution_level": -1,
			"description": "A powerful electric hound creature.",
		},
	}

func load_moves():
	# Create move data
	moves = {
		0: {
			"id": 0,
			"name": "Scratch",
			"type": CreatureType.TYPE.NORMAL,
			"category": "physical",
			"power": 40,
			"accuracy": 100,
			"description": "A basic scratch attack."
		},
		1: {
			"id": 1,
			"name": "Tackle",
			"type": CreatureType.TYPE.NORMAL,
			"category": "physical",
			"power": 40,
			"accuracy": 100,
			"description": "A basic charging attack."
		},
		2: {
			"id": 2,
			"name": "Ember",
			"type": CreatureType.TYPE.FIRE,
			"category": "special",
			"power": 40,
			"accuracy": 100,
			"description": "A fire attack."
		},
		3: {
			"id": 3,
			"name": "Water Gun",
			"type": CreatureType.TYPE.WATER,
			"category": "special",
			"power": 40,
			"accuracy": 100,
			"description": "A water attack."
		},
		4: {
			"id": 4,
			"name": "Vine Whip",
			"type": CreatureType.TYPE.GRASS,
			"category": "physical",
			"power": 45,
			"accuracy": 100,
			"description": "A grass attack."
		},
		5: {
			"id": 5,
			"name": "Thunder Shock",
			"type": CreatureType.TYPE.ELECTRIC,
			"category": "special",
			"power": 40,
			"accuracy": 100,
			"description": "An electric attack."
		},
	}

func load_items():
	# Create item data
	items = {
		0: {
			"id": 0,
			"name": "Creature Ball",
			"type": "pokeball",
			"description": "A standard ball for catching creatures (45% catch rate)",
			"catch_rate": 1.0
		},
		1: {
			"id": 1,
			"name": "Great Ball",
			"type": "pokeball",
			"description": "A better ball for catching creatures (60% catch rate)",
			"catch_rate": 1.33
		},
		2: {
			"id": 2,
			"name": "Ultra Ball",
			"type": "pokeball",
			"description": "An excellent ball for catching creatures (80% catch rate)",
			"catch_rate": 1.78
		},
		3: {
			"id": 3,
			"name": "Potion",
			"type": "potion",
			"description": "Restores 20 HP to a creature",
			"healing": 20
		},
		4: {
			"id": 4,
			"name": "Super Potion",
			"type": "potion",
			"description": "Restores 60 HP to a creature",
			"healing": 60
		},
		5: {
			"id": 5,
			"name": "Full Restore",
			"type": "potion",
			"description": "Fully restores HP to a creature",
			"healing": 999
		},
	}

func load_trainers():
	# Create NPC trainer data
	trainers = {
		1: {
			"id": 1,
			"name": "Trainer Zephyr",
			"location": "Forest",
			"creatures": [1, 7],  # Creature IDs
			"dialogue": "I've trained hard to become strong!",
			"reward_money": 500,
			"reward_exp": 100
		},
		2: {
			"id": 2,
			"name": "Trainer Aqua",
			"location": "Lake",
			"creatures": [4, 5],
			"dialogue": "My creatures are as powerful as the waves!",
			"reward_money": 600,
			"reward_exp": 120
		},
		3: {
			"id": 3,
			"name": "Gym Leader Inferno",
			"location": "Mountain",
			"creatures": [3, 9, 11],
			"dialogue": "You must be very strong to defeat me!",
			"reward_money": 2000,
			"reward_exp": 500
		},
	}

func get_creature_species(creature_id: int) -> Dictionary:
	return creature_species.get(creature_id, {})

func get_move(move_id: int) -> Dictionary:
	return moves.get(move_id, {})

func get_item(item_id: int) -> Dictionary:
	return items.get(item_id, {})

func get_trainer(trainer_id: int) -> Dictionary:
	return trainers.get(trainer_id, {})

func create_creature_instance(species_id: int, level: int = 1) -> Creature:
	var species = get_creature_species(species_id)
	if species.is_empty():
		return null
	
	var creature = Creature.new()
	creature.id = species_id
	creature.name = species.get("name", "Unknown")
	creature.level = level
	creature.type1 = species.get("type1", CreatureType.TYPE.NORMAL)
	creature.type2 = species.get("type2", -1)
	creature.max_hp = species.get("base_hp", 50)
	creature.attack = species.get("base_attack", 10)
	creature.defense = species.get("base_defense", 10)
	creature.sp_attack = species.get("base_sp_attack", 10)
	creature.sp_defense = species.get("base_sp_defense", 10)
	creature.speed = species.get("base_speed", 10)
	creature.current_hp = creature.max_hp
	creature.capture_rate = species.get("capture_rate", 45)
	creature.evolution_id = species.get("evolution_id", -1)
	creature.evolution_level = species.get("evolution_level", -1)
	
	return creature
