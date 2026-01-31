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

func _ready():
	# Give player a starter creature
	if player_party.is_empty():
		var starter = CreatureDB.get_creature_by_name("Flamewing", 5)
		if starter:
			player_party.append(starter)

func get_active_creature() -> Creature:
	if player_party.is_empty():
		return null
	return player_party[active_creature_index]

func add_creature_to_party(creature: Creature):
	if player_party.size() < 6:
		player_party.append(creature)

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
