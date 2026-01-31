extends CanvasLayer

# Debug cheat menu for testing

@onready var level_input = $Panel/MarginContainer/VBoxContainer/LevelInput
@onready var set_level_button = $Panel/MarginContainer/VBoxContainer/SetLevelButton

func _input(event):
	# Press F12 to toggle cheat menu
	if event is InputEventKey and event.pressed and event.keycode == KEY_F12:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			visible = !visible
			if visible:
				level_input.grab_focus()
			get_viewport().set_input_as_handled()

func _ready():
	visible = false
	set_level_button.pressed.connect(_on_set_level_pressed)
	level_input.text_submitted.connect(_on_level_submitted)

func _on_set_level_pressed():
	apply_level_change()

func _on_level_submitted(_text: String):
	apply_level_change()

func apply_level_change():
	var new_level = int(level_input.text)
	
	if new_level < 1 or new_level > 100:
		print("Invalid level. Must be between 1 and 100")
		return
	
	if GameData.player_party.size() == 0:
		print("No creature in party!")
		return
	
	var creature = GameData.player_party[GameData.active_creature_index]
	var old_level = creature.level
	
	# Set new level
	creature.level = new_level
	creature.calculate_stats()
	creature.current_hp = creature.max_hp
	creature.experience = creature.calculate_exp_for_level(new_level)
	creature.exp_to_next_level = creature.calculate_exp_for_level(new_level + 1)
	
	print("Changed %s from level %d to level %d!" % [creature.species.species_name, old_level, new_level])
	
	# Check for evolution
	creature.check_evolution()
	
	visible = false
