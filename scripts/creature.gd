extends Node

# Creature instance - represents an actual creature in battle or party
class_name Creature

var species: CreatureData
var level: int = 5
var current_hp: int
var max_hp: int
var attack: int
var defense: int

func _init(creature_species: CreatureData, creature_level: int = 5):
	species = creature_species
	level = creature_level
	calculate_stats()
	current_hp = max_hp

func calculate_stats():
	# Simple stat calculation based on level
	max_hp = species.base_hp + (level * 5)
	attack = species.base_attack + (level * 2)
	defense = species.base_defense + (level * 2)

func take_damage(damage: int):
	var actual_damage = max(1, damage - (defense / 4))
	current_hp = max(0, current_hp - actual_damage)
	return actual_damage

func is_fainted() -> bool:
	return current_hp <= 0

func heal(amount: int):
	current_hp = min(max_hp, current_hp + amount)
