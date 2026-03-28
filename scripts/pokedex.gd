# Pokedex - manages creature database and viewing
extends Node
class_name Pokedex

var player: Player
var game_db: GameDatabase

func _ready():
	add_to_group("pokedex")
	player = get_tree().get_first_node_in_group("player")
	game_db = get_tree().root.get_child(0).game_db

func get_creature_info(creature_id: int) -> Dictionary:
	var species = game_db.get_creature_species(creature_id)
	var encounter_count = player.pokedex.get(creature_id, 0)
	
	return {
		"id": creature_id,
		"name": species.get("name", "Unknown"),
		"type1": species.get("type1", CreatureType.TYPE.NORMAL),
		"type2": species.get("type2", -1),
		"description": species.get("description", "No description available."),
		"times_encountered": encounter_count,
		"times_caught": 1 if creature_id in player.caught_creatures else 0,
		"stats": {
			"hp": species.get("base_hp", 50),
			"attack": species.get("base_attack", 50),
			"defense": species.get("base_defense", 50),
			"sp_attack": species.get("base_sp_attack", 50),
			"sp_defense": species.get("base_sp_defense", 50),
			"speed": species.get("base_speed", 50)
		}
	}

func get_caught_creatures() -> Array[int]:
	return player.caught_creatures

func get_pokedex_completion() -> float:
	if player.caught_creatures.is_empty():
		return 0.0
	return float(player.caught_creatures.size()) / float(game_db.creature_species.size())

func get_pokedex_percentage() -> int:
	return int(get_pokedex_completion() * 100)

func format_creature_info(creature_id: int) -> String:
	var info = get_creature_info(creature_id)
	var type_name = CreatureType.get_type_name(info["type1"])
	var type2_name = "None"
	if info["type2"] != -1:
		type2_name = CreatureType.get_type_name(info["type2"])
	
	var output = ""
	output += "=== %s ===\n" % info["name"]
	output += "ID: %d\n" % creature_id
	output += "Type: %s / %s\n" % [type_name, type2_name]
	output += "Description: %s\n" % info["description"]
	output += "\nBase Stats:\n"
	output += "HP: %d\n" % info["stats"]["hp"]
	output += "Attack: %d\n" % info["stats"]["attack"]
	output += "Defense: %d\n" % info["stats"]["defense"]
	output += "Sp. Atk: %d\n" % info["stats"]["sp_attack"]
	output += "Sp. Def: %d\n" % info["stats"]["sp_defense"]
	output += "Speed: %d\n" % info["stats"]["speed"]
	
	return output
