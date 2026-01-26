extends Control

func _ready():
	$Content/VBoxContainer/HBoxContainer/ButtonMenu/NewGameButton.pressed.connect(_on_new_game_pressed)

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://root_node.tscn")
