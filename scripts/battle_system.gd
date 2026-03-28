# Battle System - manages turn-based battles between creatures
extends Node
class_name BattleSystem

signal battle_started
signal turn_ended
signal battle_ended(player_won)
signal creature_defeated(creature)
signal move_executed(move_name, damage, type_effectiveness)

var player_creature: Creature
var enemy_creature: Creature
var is_player_turn: bool = true
var battle_log: Array[String] = []
var is_battle_active: bool = false

var game_db: GameDatabase

func _ready():
	game_db = get_tree().root.get_child(0).game_db

func start_battle(player_creature_id: int, enemy_creature_id: int, enemy_level: int = 1) -> void:
	var player = get_tree().get_first_node_in_group("player")
	player_creature = player.team[0]
	
	enemy_creature = game_db.create_creature_instance(enemy_creature_id, enemy_level)
	if enemy_creature:
		enemy_creature.current_hp = enemy_creature.max_hp
	
	player_creature.current_hp = player_creature.max_hp
	is_battle_active = true
	is_player_turn = true
	battle_log.clear()
	
	add_log("%s sent out %s!" % [player.player_name, player_creature.name])
	add_log("Enemy sent out %s!" % [enemy_creature.name])
	
	battle_started.emit()

func execute_move(move_id: int) -> void:
	if not is_battle_active:
		return
	
	var move_data = game_db.get_move(move_id)
	if move_data.is_empty():
		return
	
	var attacker = player_creature if is_player_turn else enemy_creature
	var defender = enemy_creature if is_player_turn else player_creature
	
	# Calculate damage
	var damage = calculate_damage(attacker, move_data, defender)
	
	# Apply damage
	defender.take_damage(damage)
	
	# Log the move
	var move_name = move_data.get("name", "Unknown")
	var attacker_name = attacker.name
	var defender_name = defender.name
	
	add_log("%s used %s!" % [attacker_name, move_name])
	add_log("%s took %d damage!" % [defender_name, damage])
	
	# Check type effectiveness
	var effectiveness = CreatureType.get_type_effectiveness(move_data.get("type"), defender.type1)
	if effectiveness > 1.0:
		add_log("It's super effective!")
	elif effectiveness < 1.0:
		add_log("It's not very effective...")
	
	move_executed.emit(move_name, damage, effectiveness)
	
	# Check if battle is over
	if defender.current_hp <= 0:
		end_turn()
		return
	
	end_turn()

func calculate_damage(attacker: Creature, move: Dictionary, defender: Creature) -> int:
	var move_type = move.get("type", CreatureType.TYPE.NORMAL)
	var move_power = move.get("power", 0)
	var move_category = move.get("category", "physical")
	
	# Get attacking and defending stats
	var atk_stat = attacker.attack
	var def_stat = defender.defense
	
	if move_category == "special":
		atk_stat = attacker.sp_attack
		def_stat = defender.sp_defense
	
	# Basic damage formula
	var damage = int(((2.0 * float(attacker.level) / 5.0 + 2.0) * float(move_power) * float(atk_stat) / float(def_stat)) / 50.0 + 2.0)
	
	# Apply type effectiveness
	var effectiveness = CreatureType.get_type_effectiveness(move_type, defender.type1)
	if defender.type2 != -1:
		effectiveness *= CreatureType.get_type_effectiveness(move_type, defender.type2)
	
	damage = int(float(damage) * effectiveness)
	
	# Add some variance (85-100%)
	var variance = randf_range(0.85, 1.0)
	damage = int(float(damage) * variance)
	
	return max(1, damage)

func player_switch_creature(new_creature_index: int) -> bool:
	var player = get_tree().get_first_node_in_group("player")
	if is_player_turn and player.switch_creature(new_creature_index):
		player_creature = player.team[0]
		add_log("%s sent out %s!" % [player.player_name, player_creature.name])
		end_turn()
		return true
	return false

func player_use_item(item_id: int, creature_index: int) -> bool:
	var player = get_tree().get_first_node_in_group("player")
	if is_player_turn and player.use_potion(creature_index, item_id):
		var item = game_db.get_item(item_id)
		var creature = player.team[creature_index]
		add_log("Used %s to heal %s!" % [item.get("name", "Item"), creature.name])
		end_turn()
		return true
	return false

func attempt_catch(item_id: int) -> bool:
	var player = get_tree().get_first_node_in_group("player")
	if not player.remove_item(item_id):
		return false
	
	var item_data = game_db.get_item(item_id)
	var catch_rate = item_data.get("catch_rate", 1.0)
	
	# Catch formula: uses creature's capture rate and current HP
	var catch_chance = (enemy_creature.capture_rate * catch_rate) / 255.0
	var hp_ratio = float(enemy_creature.current_hp) / float(enemy_creature.max_hp)
	catch_chance *= (1.0 - hp_ratio * 0.5)  # Lower HP = higher catch rate
	
	var item_name = item_data.get("name", "Ball")
	add_log("Threw %s!" % [item_name])
	
	if randf() < catch_chance:
		add_log("%s was caught!" % [enemy_creature.name])
		if player.team.size() < player.max_team_size:
			player.add_to_team(enemy_creature.id, enemy_creature.level)
		is_battle_active = false
		battle_ended.emit(true)
		return true
	else:
		add_log("%s broke free!" % [enemy_creature.name])
		end_turn()
		return false

func end_turn() -> void:
	if not is_battle_active:
		end_battle()
		return
	
	is_player_turn = !is_player_turn
	
	if not is_player_turn:
		# Enemy turn - execute random move
		await get_tree().create_timer(1.5).timeout
		var random_move = enemy_creature.move_ids[randi() % enemy_creature.move_ids.size()]
		execute_move(random_move)
		
		# Check if player creature is defeated
		if player_creature.current_hp <= 0:
			add_log("%s was defeated!" % [player_creature.name])
			is_battle_active = false
			battle_ended.emit(false)
			creature_defeated.emit(player_creature)
	else:
		turn_ended.emit()

func end_battle() -> void:
	is_battle_active = false
	var player = get_tree().get_first_node_in_group("player")
	
	if player_creature.current_hp > 0:
		# Player won
		var exp_earned = int(enemy_creature.max_hp * 1.5)
		player.earn_exp_from_battle(exp_earned)
		var money_earned = enemy_creature.level * 50
		player.add_money(money_earned)
		add_log("Victory! Earned %d exp and $%d!" % [exp_earned, money_earned])
		battle_ended.emit(true)
	else:
		# Player lost
		add_log("Defeat...")
		player.money = int(player.money * 0.5)
		add_log("Lost half your money!")
		battle_ended.emit(false)

func add_log(message: String) -> void:
	battle_log.append(message)
	print("[Battle] " + message)

func get_battle_log() -> Array[String]:
	return battle_log
