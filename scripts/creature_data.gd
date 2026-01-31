extends Node

# Creature species data
class_name CreatureData

var species_name: String
var base_hp: int
var base_attack: int
var base_defense: int
var sprite_idle: String
var sprite_attack: String
var creature_type: String  # e.g., "fire", "water", "grass", "normal"

func _init(name: String, hp: int, atk: int, def: int, idle_path: String, attack_path: String, type: String = "normal"):
	species_name = name
	base_hp = hp
	base_attack = atk
	base_defense = def
	sprite_idle = idle_path
	sprite_attack = attack_path
	creature_type = type
