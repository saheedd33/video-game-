# Player - manages player character, team, inventory, and progress
extends Node
class_name Player

var player_name: String = "Trainer"
var level: int = 1
var money: int = 1000
var experience: int = 0

var team: Array[Creature] = []
var max_team_size: int = 6
var inventory: Dictionary = {}  # item_id -> quantity
var caught_creatures: Array[int] = []  # IDs of all caught creatures
var pokedex: Dictionary = {}  # creature_id -> times_seen

var current_location: Vector3 = Vector3.ZERO
var badges: int = 0  # Number of gym badges earned

func _ready():
	add_to_group("player")
	initialize_inventory()
	# Start with a starter creature
	add_to_team(1)  # Emberling starter

func initialize_inventory():
	# Start with some basic items
	inventory[0] = 10  # 10 Creature Balls
	inventory[3] = 5   # 5 Potions

func add_to_team(creature_id: int, level: int = 5) -> bool:
	if team.size() >= max_team_size:
		return false
	
	var db = get_tree().root.get_child(0).game_db
	var creature = db.create_creature_instance(creature_id, level)
	if creature:
		creature.captured = true
		team.append(creature)
		if creature_id not in caught_creatures:
			caught_creatures.append(creature_id)
			pokedex[creature_id] = 0
		return true
	return false

func get_active_creature() -> Creature:
	if team.size() > 0 and not team[0].current_hp <= 0:
		return team[0]
	# Find first alive creature
	for creature in team:
		if creature.current_hp > 0:
			return creature
	return null

func switch_creature(index: int) -> bool:
	if index >= 0 and index < team.size():
		var temp = team[0]
		team[0] = team[index]
		team[index] = temp
		return true
	return false

func heal_all_creatures():
	for creature in team:
		creature.current_hp = creature.max_hp

func add_money(amount: int):
	money += amount

func remove_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		return true
	return false

func add_item(item_id: int, quantity: int = 1):
	if item_id in inventory:
		inventory[item_id] += quantity
	else:
		inventory[item_id] = quantity

func remove_item(item_id: int, quantity: int = 1) -> bool:
	if item_id in inventory and inventory[item_id] >= quantity:
		inventory[item_id] -= quantity
		if inventory[item_id] == 0:
			inventory.erase(item_id)
		return true
	return false

func has_item(item_id: int, quantity: int = 1) -> bool:
	return item_id in inventory and inventory[item_id] >= quantity

func use_potion(creature_index: int, item_id: int) -> bool:
	if not has_item(item_id):
		return false
	
	if creature_index >= 0 and creature_index < team.size():
		var db = get_tree().root.get_child(0).game_db
		var item_data = db.get_item(item_id)
		if "healing" in item_data:
			team[creature_index].heal(item_data["healing"])
			remove_item(item_id)
			return true
	return false

func earn_exp_from_battle(exp_amount: int):
	for creature in team:
		if creature.current_hp > 0:
			creature.gain_exp(exp_amount)
	experience += exp_amount

func check_for_evolution():
	for creature in team:
		if creature.evolution_id != -1 and creature.level >= creature.evolution_level:
			evolve_creature(creature)

func evolve_creature(creature: Creature):
	# Change creature to its evolution
	var db = get_tree().root.get_child(0).game_db
	var evolved_species = db.get_creature_species(creature.evolution_id)
	if evolved_species.is_empty():
		return
	
	creature.id = creature.evolution_id
	creature.name = evolved_species.get("name", "Unknown")
	creature.type1 = evolved_species.get("type1", CreatureType.TYPE.NORMAL)
	creature.type2 = evolved_species.get("type2", -1)
	creature.evolution_id = evolved_species.get("evolution_id", -1)
	creature.evolution_level = evolved_species.get("evolution_level", -1)

func record_creature_encounter(creature_id: int):
	if creature_id not in pokedex:
		pokedex[creature_id] = 1
	else:
		pokedex[creature_id] += 1

func earn_badge():
	badges += 1
