# UI Manager - manages all UI elements and gameplay screens
extends Node
class_name UIManager

# References to UI panels
var battle_ui_controller: BattleUIController
var main_menu_ui: MainMenuUI
var pause_menu_ui: PauseMenuUI
var inventory_ui: InventoryUI

func _ready():
	add_to_group("ui_manager")

func setup_battle_ui(battle_system: BattleSystem):
	battle_ui_controller = BattleUIController.new()
	add_child(battle_ui_controller)
	battle_ui_controller.setup(battle_system)

func show_main_menu():
	if main_menu_ui:
		main_menu_ui.show()

func show_pause_menu():
	if pause_menu_ui:
		pause_menu_ui.show()

func show_inventory():
	if inventory_ui:
		inventory_ui.show()

func show_pokedex():
	# Show creature database UI
	pass

func update_player_info(player: Player):
	# Update UI with player info
	pass
