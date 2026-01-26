extends Node

const SAVE_FILE_PATH = "user://savegame.save"

var player_data = {
	"position_x": 0.0,
	"position_y": 0.0,
	"scene_path": "res://root_node.tscn"
}

var should_apply_on_ready = false

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
	
	# Save current scene
	player_data.scene_path = get_tree().current_scene.scene_file_path
	
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
