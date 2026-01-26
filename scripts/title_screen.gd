extends Control

func _ready():
	$Content/VBoxContainer/HBoxContainer/ButtonMenu/NewGameButton.pressed.connect(_on_new_game_pressed)
	$Content/VBoxContainer/HBoxContainer/ButtonMenu/Credits.pressed.connect(_on_credits_pressed)

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://root_node.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")
