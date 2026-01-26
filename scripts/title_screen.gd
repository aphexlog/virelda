extends Control

func _ready():
	$Content/VBoxContainer/HBoxContainer/ButtonMenu/NewGameButton.pressed.connect(_on_new_game_pressed)
	$Content/VBoxContainer/HBoxContainer/ButtonMenu/LoadGameButton.pressed.connect(_on_load_game_pressed)
	$Content/VBoxContainer/HBoxContainer/ButtonMenu/Credits.pressed.connect(_on_credits_pressed)
	
	# Disable load button if no save exists
	if not GameData.has_save_file():
		$Content/VBoxContainer/HBoxContainer/ButtonMenu/LoadGameButton.disabled = true

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://root_node.tscn")

func _on_load_game_pressed():
	if GameData.load_game():
		# Flag that we need to apply loaded data
		GameData.should_apply_on_ready = true
		get_tree().change_scene_to_file(GameData.player_data.scene_path)
	else:
		print("Failed to load game")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")
