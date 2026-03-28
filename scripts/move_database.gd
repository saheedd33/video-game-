# Move Database and Info - manages move information and learning
extends Node
class_name MoveDatabase

var game_db: GameDatabase

func _ready():
	game_db = get_tree().root.get_child(0).game_db

func get_move(move_id: int) -> Dictionary:
	return game_db.get_move(move_id)

func get_all_moves() -> Array:
	var all_moves = []
	for move_id in game_db.moves:
		all_moves.append(game_db.moves[move_id])
	return all_moves

func get_moves_of_type(type: int) -> Array:
	var moves_of_type = []
	for move_id in game_db.moves:
		var move = game_db.moves[move_id]
		if move.get("type") == type:
			moves_of_type.append(move)
	return moves_of_type

func format_move_info(move_id: int) -> String:
	var move = get_move(move_id)
	if move.is_empty():
		return "Unknown Move"
	
	var output = ""
	output += "=== %s ===\n" % move.get("name", "Unknown")
	output += "Type: %s\n" % CreatureType.get_type_name(move.get("type", CreatureType.TYPE.NORMAL))
	output += "Category: %s\n" % move.get("category", "Unknown")
	output += "Power: %d\n" % move.get("power", 0)
	output += "Accuracy: %d%%\n" % move.get("accuracy", 100)
	output += "Description: %s\n" % move.get("description", "No description")
	
	return output
