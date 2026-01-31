extends Node

# Database of all creatures in the game
var creature_species = {}

func _ready():
	print("CreatureDB._ready() called")
	load_creatures()
	print("Loaded ", creature_species.size(), " creature species")

func load_creatures():
	# Load all 16 creatures with balanced stats (Pokemon-like)
	# Format: (name, HP, Attack, Defense, idle, attack, type)
	
	# Evolution Chain 1: Flamewing -> Aquaveil -> Terrabite (Grass)
	creature_species["Flamewing"] = CreatureData.new("Flamewing", 35, 45, 30, 
		"res://assets/sprites/sprite1_idle.png", "res://assets/sprites/sprite1_attack.png", "grass")
	
	creature_species["Aquaveil"] = CreatureData.new("Aquaveil", 45, 50, 40,
		"res://assets/sprites/sprite2_idle.png", "res://assets/sprites/sprite2_attack.png", "grass")
	
	creature_species["Terrabite"] = CreatureData.new("Terrabite", 55, 60, 50,
		"res://assets/sprites/sprite3_idle.png", "res://assets/sprites/sprite3_attack.png", "grass")
	
	# Evolution Chain 2: Nightstalker -> Prismguard (Grass)
	creature_species["Nightstalker"] = CreatureData.new("Nightstalker", 42, 50, 34,
		"res://assets/sprites/sprite15_idle.png", "res://assets/sprites/sprite15_attack.png", "grass")
	
	creature_species["Prismguard"] = CreatureData.new("Prismguard", 50, 58, 45,
		"res://assets/sprites/sprite16_idle.png", "res://assets/sprites/sprite16_attack.png", "grass")
	
	# Evolution Chain 3: Thunderfang -> Vinelash -> Glacierfist (Water)
	creature_species["Thunderfang"] = CreatureData.new("Thunderfang", 32, 52, 28,
		"res://assets/sprites/sprite12_idle.png", "res://assets/sprites/sprite12_attack.png", "water")
	
	creature_species["Vinelash"] = CreatureData.new("Vinelash", 42, 58, 38,
		"res://assets/sprites/sprite13_idle.png", "res://assets/sprites/sprite13_attack.png", "water")
	
	creature_species["Glacierfist"] = CreatureData.new("Glacierfist", 52, 64, 48,
		"res://assets/sprites/sprite14_idle.png", "res://assets/sprites/sprite14_attack.png", "water")
	
	# Evolution Chain 4: Shadowclaw -> Crystalwing -> Blazeclaw (Fire)
	creature_species["Shadowclaw"] = CreatureData.new("Shadowclaw", 40, 48, 32,
		"res://assets/sprites/sprite7_idle.png", "res://assets/sprites/sprite7_attack.png", "fire")
	
	creature_species["Crystalwing"] = CreatureData.new("Crystalwing", 48, 54, 42,
		"res://assets/sprites/sprite8_idle.png", "res://assets/sprites/sprite8_attack.png", "fire")
	
	creature_species["Blazeclaw"] = CreatureData.new("Blazeclaw", 58, 62, 50,
		"res://assets/sprites/sprite9_idle.png", "res://assets/sprites/sprite9_attack.png", "fire")
	
	# Non-evolving creatures
	creature_species["Voltspike"] = CreatureData.new("Voltspike", 38, 55, 32,
		"res://assets/sprites/sprite4_idle.png", "res://assets/sprites/sprite4_attack.png", "earth")
	
	creature_species["Leafwhisper"] = CreatureData.new("Leafwhisper", 40, 48, 40,
		"res://assets/sprites/sprite5_idle.png", "res://assets/sprites/sprite5_attack.png", "wind")
	
	creature_species["Frostbite"] = CreatureData.new("Frostbite", 44, 50, 38,
		"res://assets/sprites/sprite6_idle.png", "res://assets/sprites/sprite6_attack.png", "ice")
	
	creature_species["Tidehunter"] = CreatureData.new("Tidehunter", 48, 42, 45,
		"res://assets/sprites/sprite10_idle.png", "res://assets/sprites/sprite10_attack.png", "cute")
	
	creature_species["Stoneguard"] = CreatureData.new("Stoneguard", 52, 40, 58,
		"res://assets/sprites/sprite11_idle.png", "res://assets/sprites/sprite11_attack.png", "electric")

# Evolution chains: base -> evo1 (level 16) -> evo2 (level 32)
var evolution_chains = {
	"Flamewing": {"evolves_at": 16, "evolves_to": "Aquaveil"},
	"Aquaveil": {"evolves_at": 32, "evolves_to": "Terrabite"},
	"Nightstalker": {"evolves_at": 20, "evolves_to": "Prismguard"},
	"Thunderfang": {"evolves_at": 16, "evolves_to": "Vinelash"},
	"Vinelash": {"evolves_at": 32, "evolves_to": "Glacierfist"},
	"Shadowclaw": {"evolves_at": 16, "evolves_to": "Crystalwing"},
	"Crystalwing": {"evolves_at": 32, "evolves_to": "Blazeclaw"}
}

func get_random_creature(min_level: int = 3, max_level: int = 7) -> Creature:
	# Get base forms only (first stage creatures)
	var base_forms = ["Flamewing", "Nightstalker", "Thunderfang", "Shadowclaw", 
					  "Voltspike", "Leafwhisper", "Frostbite", "Tidehunter", "Stoneguard"]
	
	# 98% chance for base form, 2% chance for evolved form in wild
	var use_evolution = randf() < 0.02 and max_level >= 16
	
	var creature_name: String
	if use_evolution and max_level >= 32 and randf() < 0.3:
		# Very rare: third stage evolution (only if level is high enough)
		var third_stage = ["Terrabite", "Glacierfist", "Blazeclaw"]
		creature_name = third_stage[randi() % third_stage.size()]
	elif use_evolution and max_level >= 16:
		# Rare: second stage evolution
		var second_stage = ["Aquaveil", "Prismguard", "Vinelash", "Crystalwing"]
		creature_name = second_stage[randi() % second_stage.size()]
	else:
		# Common: base form
		creature_name = base_forms[randi() % base_forms.size()]
	
	var level = randi_range(min_level, max_level)
	return Creature.new(creature_species[creature_name], level)

func get_creature_by_name(name: String, level: int = 5) -> Creature:
	if creature_species.has(name):
		return Creature.new(creature_species[name], level)
	return null
