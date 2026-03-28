# Inventory UI - manages inventory display and item usage
extends Control
class_name InventoryUI

var player: Player
var game_db: GameDatabase
var is_visible: bool = false

# UI references
var item_list: ItemList
var item_info_label: Label

func _ready():
	add_to_group("inventory_ui")
	player = get_tree().get_first_node_in_group("player")
	game_db = get_tree().root.get_child(0).game_db

func show_inventory():
	is_visible = true
	visible = true
	refresh_item_list()

func hide_inventory():
	is_visible = false
	visible = false

func refresh_item_list():
	if item_list:
		item_list.clear()
		
		for item_id in player.inventory:
			var item = game_db.get_item(item_id)
			var quantity = player.inventory[item_id]
			var item_name = item.get("name", "Unknown Item")
			
			item_list.add_item("%s x%d" % [item_name, quantity])

func get_item_count(item_id: int) -> int:
	return player.inventory.get(item_id, 0)

func get_total_items() -> int:
	var total = 0
	for quantity in player.inventory.values():
		total += quantity
	return total

func use_item(item_id: int, target_creature_index: int = 0) -> bool:
	var item_data = game_db.get_item(item_id)
	
	if item_data.is_empty():
		return false
	
	var item_type = item_data.get("type", "")
	
	match item_type:
		"potion":
			return player.use_potion(target_creature_index, item_id)
		"pokeball":
			# Pokeballs are used in battle
			return false
		_:
			return false

func get_inventory_summary() -> String:
	var summary = "=== INVENTORY ===\n"
	summary += "Total Items: %d\n\n" % get_total_items()
	
	if player.inventory.is_empty():
		summary += "No items"
	else:
		for item_id in player.inventory:
			var item = game_db.get_item(item_id)
			var quantity = player.inventory[item_id]
			var name = item.get("name", "Unknown")
			summary += "%s: %d\n" % [name, quantity]
	
	return summary
