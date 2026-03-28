# Save System - manages game saving and loading
extends Node
class_name SaveSystem

const SAVE_PATH = "user://creature_quest_save/"

func _ready():
	# Create save directory if it doesn't exist
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_absolute(SAVE_PATH)

func save_game(player: Player, slot: int = 0) -> bool:
	var save_file = FileAccess.open(SAVE_PATH + "save_%d.dat" % slot, FileAccess.WRITE)
	if save_file == null:
		print("Error: Could not open save file")
		return false
	
	var save_data = {
		"player_name": player.player_name,
		"level": player.level,
		"money": player.money,
		"experience": player.experience,
		"badges": player.badges,
		"position": {
			"x": player.current_location.x,
			"y": player.current_location.y,
			"z": player.current_location.z
		},
		"team": [],
		"inventory": player.inventory,
		"caught_creatures": player.caught_creatures,
		"pokedex": player.pokedex
	}
	
	# Save creature data
	for creature in player.team:
		save_data["team"].append(serialize_creature(creature))
	
	var json = JSON.stringify(save_data)
	save_file.store_string(json)
	print("Game saved to slot %d" % slot)
	return true

func load_game(slot: int = 0) -> Dictionary:
	var save_file = FileAccess.open(SAVE_PATH + "save_%d.dat" % slot, FileAccess.READ)
	if save_file == null:
		print("No save file found at slot %d" % slot)
		return {}
	
	var json_string = save_file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		print("Error parsing save file")
		return {}
	
	var save_data = json.data
	return save_data

func save_exists(slot: int = 0) -> bool:
	return FileAccess.file_exists(SAVE_PATH + "save_%d.dat" % slot)

func delete_save(slot: int = 0) -> bool:
	var file_path = SAVE_PATH + "save_%d.dat" % slot
	if FileAccess.file_exists(file_path):
		var dir = DirAccess.open(SAVE_PATH)
		if dir:
			dir.remove(file_path)
			return true
	return false

func serialize_creature(creature: Creature) -> Dictionary:
	return {
		"id": creature.id,
		"name": creature.name,
		"level": creature.level,
		"exp": creature.exp,
		"current_hp": creature.current_hp,
		"max_hp": creature.max_hp,
		"attack": creature.attack,
		"defense": creature.defense,
		"sp_attack": creature.sp_attack,
		"sp_defense": creature.sp_defense,
		"speed": creature.speed,
		"type1": creature.type1,
		"type2": creature.type2,
		"move_ids": creature.move_ids,
		"captured": creature.captured
	}

func deserialize_creature(data: Dictionary) -> Creature:
	var creature = Creature.new()
	creature.id = data.get("id", 0)
	creature.name = data.get("name", "Unknown")
	creature.level = data.get("level", 1)
	creature.exp = data.get("exp", 0)
	creature.current_hp = data.get("current_hp", 0)
	creature.max_hp = data.get("max_hp", 100)
	creature.attack = data.get("attack", 10)
	creature.defense = data.get("defense", 10)
	creature.sp_attack = data.get("sp_attack", 10)
	creature.sp_defense = data.get("sp_defense", 10)
	creature.speed = data.get("speed", 10)
	creature.type1 = data.get("type1", CreatureType.TYPE.NORMAL)
	creature.type2 = data.get("type2", -1)
	creature.move_ids = data.get("move_ids", [0, 1])
	creature.captured = data.get("captured", false)
	return creature
