# Battle UI Controller - manages battle UI and player input during battles
extends Control
class_name BattleUIController

var battle_system: BattleSystem
var player: Player
var game_db: GameDatabase

# UI Elements (would be created or linked in editor)
var player_creature_label: Label
var enemy_creature_label: Label
var player_hp_bar: ProgressBar
var enemy_hp_bar: ProgressBar
var move_buttons: Array[Button] = []
var item_buttons: Array[Button] = []
var battle_log_text: TextEdit

func _ready():
	add_to_group("battle_ui")

func setup(battle_system_ref: BattleSystem):
	battle_system = battle_system_ref
	player = get_tree().get_first_node_in_group("player")
	game_db = get_tree().root.get_child(0).game_db
	
	battle_system.move_executed.connect(_on_move_executed)
	battle_system.battle_ended.connect(_on_battle_ended)
	
	create_ui_elements()
	update_creature_info()

func create_ui_elements():
	# This would typically be done in the TSCN file, but creating here for completeness
	
	# Create creature info labels
	player_creature_label = Label.new()
	enemy_creature_label = Label.new()
	
	# Create HP bars
	player_hp_bar = ProgressBar.new()
	enemy_hp_bar = ProgressBar.new()
	
	# Create move buttons
	for i in range(4):
		var button = Button.new()
		button.pressed.connect(_on_move_button_pressed.bindv([i]))
		move_buttons.append(button)
	
	# Create item display
	var item_label = Label.new()
	battle_log_text = TextEdit.new()

func update_creature_info():
	if battle_system.player_creature:
		player_creature_label.text = "%s (Lv. %d)" % [
			battle_system.player_creature.name,
			battle_system.player_creature.level
		]
		player_hp_bar.value = battle_system.player_creature.get_current_hp_percent() * 100
	
	if battle_system.enemy_creature:
		enemy_creature_label.text = "%s (Lv. %d)" % [
			battle_system.enemy_creature.name,
			battle_system.enemy_creature.level
		]
		enemy_hp_bar.value = battle_system.enemy_creature.get_current_hp_percent() * 100

func update_move_buttons():
	var player_creature = battle_system.player_creature
	if not player_creature:
		return
	
	for i in range(min(4, player_creature.move_ids.size())):
		var move_id = player_creature.move_ids[i]
		var move = game_db.get_move(move_id)
		if not move.is_empty():
			var move_name = move.get("name", "Unknown")
			var move_type = CreatureType.get_type_name(move.get("type"))
			move_buttons[i].text = "%s\n(%s)" % [move_name, move_type]
		else:
			move_buttons[i].text = "Empty"

func _process(delta):
	if battle_system.is_battle_active:
		update_creature_info()

func _on_move_button_pressed(move_slot: int):
	if battle_system.is_player_turn and move_slot < battle_system.player_creature.move_ids.size():
		var move_id = battle_system.player_creature.move_ids[move_slot]
		battle_system.execute_move(move_id)

func _on_move_executed(move_name: String, damage: int, effectiveness: float):
	var effectiveness_text = ""
	if effectiveness > 1.0:
		effectiveness_text = " Super effective!"
	elif effectiveness < 1.0:
		effectiveness_text = " Not very effective..."
	
	update_creature_info()

func _on_battle_ended(player_won: bool):
	if player_won:
		battle_log_text.text += "\n[BATTLE END] You won the battle!"
	else:
		battle_log_text.text += "\n[BATTLE END] You lost the battle!"
	
	# Disable action buttons
	for button in move_buttons:
		button.disabled = true

func display_log_message(message: String):
	if battle_log_text:
		battle_log_text.text += "\n" + message
		# Auto-scroll to bottom
		battle_log_text.scroll_vertical = battle_log_text.get_line_count()
