extends Node

# Item system - potions, coins, and collectibles

# Item data class
class ItemData:
	var item_name: String
	var description: String
	var icon_path: String
	var item_type: String  # "potion", "coin", "treasure"
	var effect_value: int
	
	func _init(p_name: String, p_desc: String, p_icon: String, p_type: String, p_value: int):
		item_name = p_name
		description = p_desc
		icon_path = p_icon
		item_type = p_type
		effect_value = p_value

# Global item database
var items = {}

func _ready():
	load_items()

func load_items():
	# Healing potions
	items["Small Potion"] = ItemData.new(
		"Small Potion",
		"Restores 20 HP",
		"res://assets/ui/options4.png",
		"potion",
		20
	)
	
	items["Medium Potion"] = ItemData.new(
		"Medium Potion",
		"Restores 50 HP",
		"res://assets/ui/options4.png",
		"potion",
		50
	)
	
	items["Large Potion"] = ItemData.new(
		"Large Potion",
		"Restores 100 HP",
		"res://assets/ui/options4.png",
		"potion",
		100
	)
	
	items["Full Restore"] = ItemData.new(
		"Full Restore",
		"Restores all HP",
		"res://assets/ui/options4.png",
		"potion",
		9999
	)
	
	# Currency
	items["Coin"] = ItemData.new(
		"Coin",
		"Currency for buying items",
		"res://assets/ui/options8.png",
		"coin",
		1
	)

func get_item(item_name: String) -> ItemData:
	if items.has(item_name):
		return items[item_name]
	return null
