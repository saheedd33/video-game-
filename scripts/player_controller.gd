# Player Controller - handles third-person character movement and interaction
extends CharacterBody3D
class_name PlayerController

@export var move_speed: float = 10.0
@export var rotation_speed: float = 0.05
@export var camera_distance: float = 3.0
@export var camera_height: float = 1.5
@export var gravity: float = 9.8

var camera: Camera3D
var interaction_radius: float = 2.0
var is_in_battle: bool = false

func _ready():
	# Create camera
	camera = Camera3D.new()
	add_child(camera)
	camera.position = Vector3(0, camera_height, camera_distance)
	camera.look_at(global_position + Vector3(0, camera_height - 0.5, 0), Vector3.UP)

func _physics_process(delta):
	if is_in_battle:
		return
	
	# Get input
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var camera_transform = camera.global_transform
	var forward = -camera_transform.basis.z.normalized()
	var right = camera_transform.basis.x.normalized()
	
	# Calculate movement direction relative to camera
	var move_dir = (forward * input_dir.y + right * input_dir.x).normalized()
	
	if move_dir != Vector3.ZERO:
		# Rotate character towards movement direction
		var target_angle = atan2(move_dir.x, move_dir.z)
		rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed)
		
		velocity = move_dir * move_speed
	else:
		velocity = Vector3.ZERO
	
	# Apply gravity
	velocity.y -= gravity * delta
	
	# Move the character
	move_and_slide()
	
	# Update camera position
	var camera_target = global_position + Vector3(0, camera_height, 0)
	camera.global_position = camera.global_position.lerp(
		camera_target + (camera.global_transform.basis.z * camera_distance),
		0.1
	)
	camera.look_at(camera_target, Vector3.UP)
	
	# Check for interactions
	check_interactions()

func check_interactions():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.current_location = global_position

func set_battle_mode(in_battle: bool):
	is_in_battle = in_battle
	if in_battle:
		velocity = Vector3.ZERO

func get_camera() -> Camera3D:
	return camera
