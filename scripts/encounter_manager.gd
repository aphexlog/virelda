extends Node

# Manages random encounters while walking

signal encounter_triggered(wild_creature: Creature)

var encounter_chance: float = 0.05  # 5% per step
var steps_since_encounter: int = 0
var min_steps_between_encounters: int = 5

func check_for_encounter() -> bool:
	steps_since_encounter += 1
	
	if steps_since_encounter < min_steps_between_encounters:
		return false
	
	if randf() < encounter_chance:
		trigger_encounter()
		return true
	
	return false

func trigger_encounter():
	steps_since_encounter = 0
	var wild_creature = CreatureDB.get_random_creature(3, 8)
	encounter_triggered.emit(wild_creature)
	print("Wild ", wild_creature.species.species_name, " appeared!")
