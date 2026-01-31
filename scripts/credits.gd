extends Control

func _ready():
	$MarginContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()

func _on_back_pressed():
	AudioManager.play_ui_sound("back")
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
