extends Node

# Type effectiveness system (like Pokemon)
# Multipliers: 2.0 = super effective, 0.5 = not very effective, 0.0 = no effect

var type_chart = {
	"grass": {
		"strong_against": ["water", "earth", "electric"],
		"weak_against": ["fire", "ice", "wind"],
		"resists": ["water", "earth", "electric"],
		"weak_to": ["fire", "ice", "wind"]
	},
	"fire": {
		"strong_against": ["grass", "ice", "wind"],
		"weak_against": ["water", "earth"],
		"resists": ["grass", "ice", "fire", "wind"],
		"weak_to": ["water", "earth"]
	},
	"water": {
		"strong_against": ["fire", "earth"],
		"weak_against": ["grass", "electric"],
		"resists": ["fire", "water", "ice"],
		"weak_to": ["grass", "electric"]
	},
	"electric": {
		"strong_against": ["water", "wind"],
		"weak_against": ["earth"],
		"resists": ["electric", "wind"],
		"weak_to": ["earth"]
	},
	"earth": {
		"strong_against": ["fire", "electric"],
		"weak_against": ["water", "grass", "ice"],
		"resists": ["electric"],
		"weak_to": ["water", "grass", "ice"]
	},
	"ice": {
		"strong_against": ["grass", "earth", "wind"],
		"weak_against": ["fire"],
		"resists": ["ice"],
		"weak_to": ["fire"]
	},
	"wind": {
		"strong_against": ["earth"],
		"weak_against": ["electric", "ice"],
		"resists": ["grass", "wind"],
		"weak_to": ["electric", "ice"]
	},
	"cute": {
		"strong_against": [],
		"weak_against": [],
		"resists": ["cute"],
		"weak_to": []
	}
}

func get_effectiveness(attacker_type: String, defender_type: String) -> float:
	# Default multiplier
	var multiplier = 1.0
	
	if not type_chart.has(attacker_type):
		return multiplier
	
	var attacker_data = type_chart[attacker_type]
	
	# Check if super effective
	if defender_type in attacker_data["strong_against"]:
		multiplier = 2.0
	# Check if not very effective
	elif defender_type in attacker_data["weak_against"]:
		multiplier = 0.5
	
	return multiplier

func get_effectiveness_text(multiplier: float) -> String:
	if multiplier > 1.5:
		return "It's super effective!"
	elif multiplier < 0.75:
		return "It's not very effective..."
	else:
		return ""
