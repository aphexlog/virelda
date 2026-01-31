extends Node

const SAVE_FILE_PATH = "user://savegame.save"

var player_data = {
	"position_x": 0.0,
	"position_y": 0.0,
	"scene_path": "res://root_node.tscn",
	"character_index": 0,
	"character_name": "Aiden",
	"character_sprite": "res://assets/characters/overworld/ow1.png"
}

var should_apply_on_ready = false

# Current character selection
var selected_character_index = 0
var player_name = "Aiden"
var player_sprite_path = "res://assets/characters/overworld/ow1.png"

# Player's creature party (max 6 like Pokemon)
var player_party: Array[Creature] = []
var active_creature_index: int = 0

# Inventory system
var inventory = {}  # {"item_name": quantity}
var coins: int = 100  # Starting money

# Starting position for level scaling
var spawn_position: Vector2 = Vector2.ZERO
var spawn_position_set: bool = false

# Current position before battle (for returning on loss)
var position_before_battle: Vector2 = Vector2.ZERO

# Battle data - temporary storage for scene transitions
var pending_battle_player_creature: Creature = null
var pending_battle_enemy_creature: Creature = null
var battle_result: String = ""  # "won", "lost", or "ran"

func _ready():
	# Don't auto-add starter - player will choose one
	print("GameData._ready() called")
	print("Player party size: ", player_party.size())
	
	# Start with some basic items for fun!
	add_item("Small Potion", 3)
	add_item("Medium Potion", 1)

func get_active_creature() -> Creature:
	if player_party.is_empty():
		print("ERROR: Player party is empty!")
		return null
	print("Getting active creature: ", player_party[active_creature_index].species.species_name)
	return player_party[active_creature_index]

func add_creature_to_party(creature: Creature):
	if player_party.size() < 6:
		player_party.append(creature)

# Inventory management
func add_item(item_name: String, quantity: int = 1):
	if inventory.has(item_name):
		inventory[item_name] += quantity
	else:
		inventory[item_name] = quantity
	print("Added %d x %s" % [quantity, item_name])

func remove_item(item_name: String, quantity: int = 1) -> bool:
	if not inventory.has(item_name):
		return false
	
	if inventory[item_name] >= quantity:
		inventory[item_name] -= quantity
		if inventory[item_name] <= 0:
			inventory.erase(item_name)
		return true
	return false

func has_item(item_name: String) -> bool:
	return inventory.has(item_name) and inventory[item_name] > 0

func get_item_count(item_name: String) -> int:
	if inventory.has(item_name):
		return inventory[item_name]
	return 0

func add_coins(amount: int):
	coins += amount
	print("Gained %d coins! Total: %d" % [amount, coins])

func calculate_wild_creature_level(player_position: Vector2) -> int:
	# Calculate distance from spawn point
	if not spawn_position_set:
		return 1  # Default to level 1 if spawn not set
	
	var distance = player_position.distance_to(spawn_position)
	
	# Every 200 pixels of distance = 1 level
	# Minimum level 1, maximum level 20
	var level = int(distance / 200.0) + 1
	level = clamp(level, 1, 20)
	
	return level

func save_game():
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file == null:
		push_error("Failed to open save file for writing")
		return false
	
	# Get player position if it exists
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player_data.position_x = player.global_position.x
		player_data.position_y = player.global_position.y
	
	# Save current scene and character info
	player_data.scene_path = get_tree().current_scene.scene_file_path
	player_data.character_index = selected_character_index
	player_data.character_name = player_name
	player_data.character_sprite = player_sprite_path
	
	# Convert to JSON and save
	var json_string = JSON.stringify(player_data)
	save_file.store_line(json_string)
	save_file.close()
	
	print("Game saved successfully!")
	return true

func load_game():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		push_warning("No save file found")
		return false
	
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if save_file == null:
		push_error("Failed to open save file for reading")
		return false
	
	# Read and parse JSON
	var json_string = save_file.get_line()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		push_error("Failed to parse save file")
		return false
	
	player_data = json.data
	
	# Restore character selection
	selected_character_index = player_data.get("character_index", 0)
	player_name = player_data.get("character_name", "Aiden")
	player_sprite_path = player_data.get("character_sprite", "res://assets/characters/overworld/ow1.png")
	
	print("Game loaded successfully!")
	return true

func has_save_file():
	return FileAccess.file_exists(SAVE_FILE_PATH)

func apply_loaded_data():
	# Find and position the player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.global_position = Vector2(player_data.position_x, player_data.position_y)
		print("Player positioned at: ", player.global_position)
