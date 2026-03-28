# World Manager - manages the open world, wild creatures, NPCs, and areas
extends Node3D
class_name WorldManager

var wild_creatures: Array[Dictionary] = []  # Available wild creatures in current area
var active_npcs: Array[Dictionary] = []
var current_weather: String = "clear"
var time_of_day: float = 12.0  # 0-24 hours
var current_area: String = "Forest"

func _ready():
	setup_world()
	setup_wild_creatures()
	setup_npcs()

func setup_world():
	# Initialize world areas and their properties
	pass

func setup_wild_creatures():
	# Define wild creatures available in each area
	wild_creatures = [
		{
			"creature_id": 1,
			"level": 3,
			"spawn_rate": 0.3,
			"areas": ["Forest", "Grassland"]
		},
		{
			"creature_id": 4,
			"level": 3,
			"spawn_rate": 0.3,
			"areas": ["Lake", "River"]
		},
		{
			"creature_id": 7,
			"level": 3,
			"spawn_rate": 0.4,
			"areas": ["Forest", "Grassland"]
		},
		{
			"creature_id": 10,
			"level": 3,
			"spawn_rate": 0.2,
			"areas": ["Plains", "Electric Temple"]
		},
	]

func setup_npcs():
	# Define NPC trainers and their locations
	var db = get_tree().root.get_child(0).game_db
	for trainer_id in db.trainers:
		var trainer_data = db.get_trainer(trainer_id)
		active_npcs.append(trainer_data)

func get_available_wild_creatures() -> Array[int]:
	var available = []
	for wild_creature in wild_creatures:
		if current_area in wild_creature.get("areas", []):
			available.append(wild_creature.get("creature_id"))
	return available

func encounter_wild_creature() -> Dictionary:
	var available = get_available_wild_creatures()
	if available.is_empty():
		return {}
	
	var creature_id = available[randi() % available.size()]
	var creature_data = {}
	
	for wild in wild_creatures:
		if wild.get("creature_id") == creature_id:
			creature_data = wild
			break
	
	return {
		"id": creature_id,
		"level": creature_data.get("level", 1)
	}

func set_current_area(area_name: String):
	current_weather = get_weather_for_area(area_name)
	current_area = area_name
	print("Entered area: %s (Weather: %s)" % [area_name, current_weather])

func get_weather_for_area(area_name: String) -> String:
	# Simple weather system based on area
	var weather_options = ["clear", "cloudy", "rainy", "snowy"]
	match area_name:
		"Forest":
			return ["clear", "cloudy", "rainy"][randi() % 3]
		"Mountain":
			return ["snowy", "cloudy"][randi() % 2]
		"Lake":
			return ["rainy", "clear"][randi() % 2]
		"Desert":
			return "clear"
		_:
			return weather_options[randi() % weather_options.size()]

func update_time(delta: float):
	time_of_day += delta / 240.0  # One minute = 1 second
	if time_of_day >= 24.0:
		time_of_day -= 24.0
	
	# Trigger day/night transitions
	if time_of_day > 18.0 or time_of_day < 6.0:
		set_night_mode()
	else:
		set_day_mode()

func set_day_mode():
	# Adjust lighting/visibility for daytime
	pass

func set_night_mode():
	# Adjust lighting/visibility for nighttime
	pass

func _process(delta):
	update_time(delta)
