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
	
	creature_species["Flamewing"] = CreatureData.new("Flamewing", 35, 45, 30, 
		"res://assets/sprites/sprite1_idle.png", "res://assets/sprites/sprite1_attack.png", "fire")
	
	creature_species["Aquaveil"] = CreatureData.new("Aquaveil", 40, 35, 40,
		"res://assets/sprites/sprite2_idle.png", "res://assets/sprites/sprite2_attack.png", "water")
	
	creature_species["Terrabite"] = CreatureData.new("Terrabite", 45, 40, 45,
		"res://assets/sprites/sprite3_idle.png", "res://assets/sprites/sprite3_attack.png", "earth")
	
	creature_species["Voltspike"] = CreatureData.new("Voltspike", 30, 50, 25,
		"res://assets/sprites/sprite4_idle.png", "res://assets/sprites/sprite4_attack.png", "electric")
	
	creature_species["Leafwhisper"] = CreatureData.new("Leafwhisper", 38, 38, 38,
		"res://assets/sprites/sprite5_idle.png", "res://assets/sprites/sprite5_attack.png", "grass")
	
	creature_species["Frostbite"] = CreatureData.new("Frostbite", 42, 40, 35,
		"res://assets/sprites/sprite6_idle.png", "res://assets/sprites/sprite6_attack.png", "ice")
	
	creature_species["Shadowclaw"] = CreatureData.new("Shadowclaw", 40, 48, 32,
		"res://assets/sprites/sprite7_idle.png", "res://assets/sprites/sprite7_attack.png", "dark")
	
	creature_species["Crystalwing"] = CreatureData.new("Crystalwing", 36, 42, 37,
		"res://assets/sprites/sprite8_idle.png", "res://assets/sprites/sprite8_attack.png", "crystal")
	
	creature_species["Blazeclaw"] = CreatureData.new("Blazeclaw", 48, 50, 30,
		"res://assets/sprites/sprite9_idle.png", "res://assets/sprites/sprite9_attack.png", "fire")
	
	creature_species["Tidehunter"] = CreatureData.new("Tidehunter", 50, 38, 42,
		"res://assets/sprites/sprite10_idle.png", "res://assets/sprites/sprite10_attack.png", "water")
	
	creature_species["Stoneguard"] = CreatureData.new("Stoneguard", 55, 35, 55,
		"res://assets/sprites/sprite11_idle.png", "res://assets/sprites/sprite11_attack.png", "earth")
	
	creature_species["Thunderfang"] = CreatureData.new("Thunderfang", 32, 52, 28,
		"res://assets/sprites/sprite12_idle.png", "res://assets/sprites/sprite12_attack.png", "electric")
	
	creature_species["Vinelash"] = CreatureData.new("Vinelash", 40, 40, 40,
		"res://assets/sprites/sprite13_idle.png", "res://assets/sprites/sprite13_attack.png", "grass")
	
	creature_species["Glacierfist"] = CreatureData.new("Glacierfist", 44, 42, 38,
		"res://assets/sprites/sprite14_idle.png", "res://assets/sprites/sprite14_attack.png", "ice")
	
	creature_species["Nightstalker"] = CreatureData.new("Nightstalker", 42, 50, 34,
		"res://assets/sprites/sprite15_idle.png", "res://assets/sprites/sprite15_attack.png", "dark")
	
	creature_species["Prismguard"] = CreatureData.new("Prismguard", 38, 44, 40,
		"res://assets/sprites/sprite16_idle.png", "res://assets/sprites/sprite16_attack.png", "crystal")

func get_random_creature(min_level: int = 3, max_level: int = 7) -> Creature:
	var species_list = creature_species.values()
	var random_species = species_list[randi() % species_list.size()]
	var level = randi_range(min_level, max_level)
	return Creature.new(random_species, level)

func get_creature_by_name(name: String, level: int = 5) -> Creature:
	if creature_species.has(name):
		return Creature.new(creature_species[name], level)
	return null
