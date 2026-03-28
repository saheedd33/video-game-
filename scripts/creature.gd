# Creature - represents an individual creature instance with stats and moves
extends Resource
class_name Creature

var id: int = 0  # Creature species ID
var name: String = "Creature"
var level: int = 1
var exp: int = 0
var current_hp: int = 0
var max_hp: int = 100
var attack: int = 10
var defense: int = 10
var sp_attack: int = 10
var sp_defense: int = 10
var speed: int = 10
var type1: int = CreatureType.TYPE.NORMAL
var type2: int = -1  # -1 = no type2
var move_ids: Array[int] = [0, 1]  # Move IDs from move database
var ability: String = "Ability"
var captured: bool = false
var capture_rate: int = 45  # Used for catching mechanics
var evolution_id: int = -1  # Next evolution species ID (-1 = none)
var evolution_level: int = 16

func _to_string() -> String:
	return "%s (Lv. %d)" % [name, level]

func get_current_hp_percent() -> float:
	if max_hp <= 0:
		return 0.0
	return float(current_hp) / float(max_hp)

func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)

func take_damage(damage: int) -> void:
	current_hp = max(0, current_hp - damage)

func gain_exp(amount: int) -> void:
	exp += amount
	# Level up at 100 exp per level
	while exp >= level * 100:
		exp -= level * 100
		level_up()

func level_up() -> void:
	level += 1
	# Increase all stats by 10%
	max_hp = int(max_hp * 1.1)
	attack = int(attack * 1.1)
	defense = int(defense * 1.1)
	sp_attack = int(sp_attack * 1.1)
	sp_defense = int(sp_defense * 1.1)
	speed = int(speed * 1.1)
	current_hp = max_hp

func get_stat(stat_name: String) -> int:
	match stat_name:
		"hp": return max_hp
		"attack": return attack
		"defense": return defense
		"sp_attack": return sp_attack
		"sp_defense": return sp_defense
		"speed": return speed
	return 0
