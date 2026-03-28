# NPC Trainer - represents trainers in the world that can be battled
extends Node3D
class_name NPCTrainer

@export var trainer_id: int = 1
@export var position_override: Vector3 = Vector3.ZERO

var trainer_data: Dictionary = {}
var game_db: GameDatabase
var battle_system: BattleSystem
var has_battled: bool = false
var interaction_area: Area3D

func _ready():
	game_db = get_tree().root.get_child(0).game_db
	battle_system = get_tree().root.get_child(0).battle_system
	
	trainer_data = game_db.get_trainer(trainer_id)
	if trainer_data.is_empty():
		queue_free()
		return
	
	global_position = position_override
	setup_interaction_area()
	add_to_group("npcs")

func setup_interaction_area():
	interaction_area = Area3D.new()
	add_child(interaction_area)
	
	var collision_shape = CollisionShape3D.new()
	var sphere_shape = SphereShape3D.new()
	sphere_shape.radius = 2.0
	collision_shape.shape = sphere_shape
	interaction_area.add_child(collision_shape)
	
	interaction_area.body_entered.connect(_on_interaction_area_entered)

func _on_interaction_area_entered(body):
	if body.is_in_group("player"):
		if not has_battled:
			initiate_battle()

func initiate_battle():
	var player = get_tree().get_first_node_in_group("player")
	var dialogue = trainer_data.get("dialogue", "Let's battle!")
	
	print("Trainer %s: %s" % [trainer_data.get("name", "Unknown"), dialogue])
	
	# Start battle with first creature of trainer
	var trainer_creature_ids = trainer_data.get("creatures", [1])
	if trainer_creature_ids.size() > 0:
		var opponent_id = trainer_creature_ids[0]
		var opponent_level = 5 + trainer_id * 2  # Levels scale with trainer
		
		battle_system.start_battle(player.team[0].id, opponent_id, opponent_level)
		has_battled = true

func get_trainer_info() -> Dictionary:
	return trainer_data

func can_rebattle() -> bool:
	return not has_battled
