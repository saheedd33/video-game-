# Main Game Controller - orchestrates all game systems
extends Node3D

@onready var player_controller: PlayerController = $Player
@onready var battle_ui: CanvasLayer = $BattleUI

var game_db: GameDatabase
var player: Player
var world_manager: WorldManager
var battle_system: BattleSystem
var save_system: SaveSystem
var ui_manager: UIManager
var pokedex: Pokedex
var move_database: MoveDatabase
var menu_manager: GameMenuManager

var encounter_timer: float = 0.0

func _ready():
	# Initialize all game systems in proper order
	game_db = GameDatabase.new()
	add_child(game_db)
	
	player = Player.new()
	add_child(player)
	
	world_manager = WorldManager.new()
	add_child(world_manager)
	
	battle_system = BattleSystem.new()
	add_child(battle_system)
	battle_system.battle_ended.connect(_on_battle_ended)
	
	save_system = SaveSystem.new()
	add_child(save_system)
	
	ui_manager = UIManager.new()
	add_child(ui_manager)
	
	pokedex = Pokedex.new()
	add_child(pokedex)
	
	move_database = MoveDatabase.new()
	add_child(move_database)
	
	menu_manager = GameMenuManager.new()
	add_child(menu_manager)
	
	# Set initial area
	world_manager.set_current_area("Forest")
	
	# Display welcome message
	print("\n" + "=".repeat(50))
	print("Welcome to Creature Quest!")
	print("=".repeat(50))
	print("Player Name: %s" % player.player_name)
	print("Starting Creature: %s (Lv. %d)" % [player.team[0].name, player.team[0].level])
	print("Starting Money: $%d" % player.money)
	print("Pokedex Completion: %d%%" % pokedex.get_pokedex_percentage())
	print("\nControls:")
	print("  WASD - Move")
	print("  Space - Activate/Interact (encountering)")
	print("  P - Pause")
	print("  I - Inventory")
	print("  M - Pokedex/Map")
	print("=".repeat(50) + "\n")
	
	setup_test_npcs()

func setup_test_npcs():
	# Create some test NPCs in the world
	for trainer_id in [1, 2]:
		var npc = NPCTrainer.new()
		add_child(npc)
		npc.trainer_id = trainer_id
		npc.position_override = Vector3(5 + trainer_id * 10, 0, 5 + trainer_id * 10)

func _process(delta):
	# Check for wild creature encounters
	encounter_timer += delta
	
	if Input.is_action_just_pressed("ui_accept"):
		# Space bar to roll for wild encounter
		encounter_timer = 0.0
		if randf() < 0.3:  # 30% chance
			var wild_creature = world_manager.encounter_wild_creature()
			if not wild_creature.is_empty():
				start_wild_battle(wild_creature["id"], wild_creature["level"])
		else:
			print("No creatures nearby...")
	
	# Save/Load commands
	if Input.is_action_just_pressed("ui_cut"):  # Ctrl+X
		save_game()
	elif Input.is_action_just_pressed("ui_copy"):  # Ctrl+C
		load_game()

func start_wild_battle(creature_id: int, level: int):
	print("\nA wild creature appeared!")
	var db = game_db.get_creature_species(creature_id)
	print("%s (Lv. %d) appeared!" % [db.get("name", "Unknown"), level])
	
	player_controller.set_battle_mode(true)
	battle_ui.visible = true
	
	battle_system.start_battle(player.team[0].id, creature_id, level)

func _on_battle_ended(player_won: bool):
	player_controller.set_battle_mode(false)
	battle_ui.visible = false
	
	if player_won:
		print("\nBattle won! Returning to exploration...")
		# Auto-save after battle
		await get_tree().create_timer(1.0).timeout
		save_game()
	else:
		print("\nBattle lost! You were defeated...")
		player.heal_all_creatures()

func save_game():
	if save_system.save_game(player):
		print("\n[SAVE] Game saved successfully!")
	else:
		print("\n[ERROR] Failed to save game!")

func load_game():
	var save_data = save_system.load_game()
	if not save_data.is_empty():
		load_player_data(save_data)
		print("\n[LOAD] Game loaded successfully!")
	else:
		print("\n[ERROR] No save file found!")

func load_player_data(save_data: Dictionary):
	player.player_name = save_data.get("player_name", "Trainer")
	player.level = save_data.get("level", 1)
	player.money = save_data.get("money", 1000)
	player.experience = save_data.get("experience", 0)
	player.badges = save_data.get("badges", 0)
	player.inventory = save_data.get("inventory", {})
	player.caught_creatures = save_data.get("caught_creatures", [])
	player.pokedex = save_data.get("pokedex", {})
	
	# Load creatures
	player.team.clear()
	for creature_data in save_data.get("team", []):
		player.team.append(save_system.deserialize_creature(creature_data))
