extends CanvasLayer

func _ready():
	hide()
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/SaveButton.pressed.connect(_on_save_pressed)
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_resume_pressed()
		else:
			show()
			get_tree().paused = true

func _on_resume_pressed():
	hide()
	get_tree().paused = false

func _on_save_pressed():
	# TODO: Implement save system
	print("Game saved!")
	# For now, just show a brief confirmation
	pass

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _on_quit_pressed():
	get_tree().quit()
