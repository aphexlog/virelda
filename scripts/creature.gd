extends Node

# Creature instance - represents an actual creature in battle or party
class_name Creature

var species: CreatureData
var level: int = 5
var current_hp: int
var max_hp: int
var attack: int
var defense: int
var experience: int = 0
var exp_to_next_level: int = 100

func _init(creature_species: CreatureData, creature_level: int = 5):
	species = creature_species
	level = creature_level
	calculate_stats()
	current_hp = max_hp
	exp_to_next_level = calculate_exp_for_level(level + 1)

func calculate_stats():
	# Pokemon-like stat calculation - much lower HP, higher attack/defense impact
	max_hp = species.base_hp + (level * 2)  # Lower HP growth
	attack = species.base_attack + (level * 3)  # Higher attack growth
	defense = species.base_defense + (level * 3)  # Higher defense growth

func calculate_exp_for_level(target_level: int) -> int:
	# Experience needed grows with level (simple formula)
	return int(pow(target_level, 2.5) * 10)

func gain_experience(exp: int):
	experience += exp
	print("%s gained %d EXP!" % [species.species_name, exp])
	
	# Check for level up
	while experience >= exp_to_next_level and level < 100:
		level_up()

func level_up():
	level += 1
	AudioManager.play_battle_sound("level_up")
	print("%s leveled up to %d!" % [species.species_name, level])
	
	var old_max_hp = max_hp
	calculate_stats()
	exp_to_next_level = calculate_exp_for_level(level + 1)
	
	# Heal the difference when leveling up
	current_hp += (max_hp - old_max_hp)
	current_hp = min(current_hp, max_hp)
	
	# Check for evolution
	check_evolution()

func check_evolution():
	# Check if this creature can evolve
	if CreatureDB.evolution_chains.has(species.species_name):
		var evo_data = CreatureDB.evolution_chains[species.species_name]
		if level >= evo_data["evolves_at"]:
			evolve_to(evo_data["evolves_to"])

func evolve_to(new_species_name: String):
	print("%s is evolving..." % species.species_name)
	
	# Get new species data
	var new_species = CreatureDB.creature_species[new_species_name]
	if new_species:
		# Store old HP percentage
		var hp_percent = float(current_hp) / float(max_hp)
		
		# Evolve!
		species = new_species
		calculate_stats()
		
		# Restore HP based on percentage
		current_hp = int(max_hp * hp_percent)
		current_hp = max(1, current_hp)
		
		print("Congratulations! Your creature evolved into %s!" % species.species_name)

func take_damage(damage: int):
	var actual_damage = max(1, damage - (defense / 4))
	current_hp = max(0, current_hp - actual_damage)
	return actual_damage

func is_fainted() -> bool:
	return current_hp <= 0

func heal(amount: int):
	current_hp = min(max_hp, current_hp + amount)
