extends Node

# Database of all creatures in the game
var creature_species = {}

func _ready():
	print("CreatureDB._ready() called")
	load_creatures()
	print("Loaded ", creature_species.size(), " creature species")

func load_creatures():
	# Load all 16 creatures with stats
	creature_species["Flamewing"] = CreatureData.new("Flamewing", 45, 55, 40, 
		"res://assets/sprites/sprite1_idle.png", "res://assets/sprites/sprite1_attack.png", "fire")
	
	creature_species["Aquaveil"] = CreatureData.new("Aquaveil", 50, 45, 50,
		"res://assets/sprites/sprite2_idle.png", "res://assets/sprites/sprite2_attack.png", "water")
	
	creature_species["Terrabite"] = CreatureData.new("Terrabite", 55, 50, 55,
		"res://assets/sprites/sprite3_idle.png", "res://assets/sprites/sprite3_attack.png", "earth")
	
	creature_species["Voltspike"] = CreatureData.new("Voltspike", 40, 60, 35,
		"res://assets/sprites/sprite4_idle.png", "res://assets/sprites/sprite4_attack.png", "electric")
	
	creature_species["Leafwhisper"] = CreatureData.new("Leafwhisper", 48, 48, 48,
		"res://assets/sprites/sprite5_idle.png", "res://assets/sprites/sprite5_attack.png", "grass")
	
	creature_species["Frostbite"] = CreatureData.new("Frostbite", 52, 50, 45,
		"res://assets/sprites/sprite6_idle.png", "res://assets/sprites/sprite6_attack.png", "ice")
	
	creature_species["Shadowclaw"] = CreatureData.new("Shadowclaw", 50, 58, 42,
		"res://assets/sprites/sprite7_idle.png", "res://assets/sprites/sprite7_attack.png", "dark")
	
	creature_species["Crystalwing"] = CreatureData.new("Crystalwing", 46, 52, 47,
		"res://assets/sprites/sprite8_idle.png", "res://assets/sprites/sprite8_attack.png", "crystal")
	
	creature_species["Blazeclaw"] = CreatureData.new("Blazeclaw", 58, 60, 40,
		"res://assets/sprites/sprite9_idle.png", "res://assets/sprites/sprite9_attack.png", "fire")
	
	creature_species["Tidehunter"] = CreatureData.new("Tidehunter", 60, 48, 52,
		"res://assets/sprites/sprite10_idle.png", "res://assets/sprites/sprite10_attack.png", "water")
	
	creature_species["Stoneguard"] = CreatureData.new("Stoneguard", 65, 45, 65,
		"res://assets/sprites/sprite11_idle.png", "res://assets/sprites/sprite11_attack.png", "earth")
	
	creature_species["Thunderfang"] = CreatureData.new("Thunderfang", 42, 62, 38,
		"res://assets/sprites/sprite12_idle.png", "res://assets/sprites/sprite12_attack.png", "electric")
	
	creature_species["Vinelash"] = CreatureData.new("Vinelash", 50, 50, 50,
		"res://assets/sprites/sprite13_idle.png", "res://assets/sprites/sprite13_attack.png", "grass")
	
	creature_species["Glacierfist"] = CreatureData.new("Glacierfist", 54, 52, 48,
		"res://assets/sprites/sprite14_idle.png", "res://assets/sprites/sprite14_attack.png", "ice")
	
	creature_species["Nightstalker"] = CreatureData.new("Nightstalker", 52, 60, 44,
		"res://assets/sprites/sprite15_idle.png", "res://assets/sprites/sprite15_attack.png", "dark")
	
	creature_species["Prismguard"] = CreatureData.new("Prismguard", 48, 54, 50,
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
