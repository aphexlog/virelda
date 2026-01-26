extends Control

func _ready():
	$MarginContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
