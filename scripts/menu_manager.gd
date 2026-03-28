# Game Menu Manager - handles main menu, pause menu, and game options
extends CanvasLayer
class_name GameMenuManager

var is_paused: bool = false
var main_menu_visible: bool = false

func _ready():
	add_to_group("menu_manager")
	setup_signals()

func setup_signals():
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		show_pause_menu()
	else:
		hide_pause_menu()

func show_main_menu():
	main_menu_visible = true
	get_tree().paused = true

func hide_main_menu():
	main_menu_visible = false
	get_tree().paused = false

func show_pause_menu():
	print("Game Paused")

func hide_pause_menu():
	print("Game Resumed")

func quit_to_main_menu():
	get_tree().paused = false
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()

func go_back():
	if is_paused:
		toggle_pause()
