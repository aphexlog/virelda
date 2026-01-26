extends Control

# Character data: [sprite_path, name, bio]
var characters = [
	["res://assets/characters/overworld/ow1.png", "Aiden", "A brave adventurer\nseeking glory"],
	["res://assets/characters/overworld/ow2.png", "Elara", "A skilled mage with\nancient knowledge"],
	["res://assets/characters/overworld/ow3.png", "Finn", "A wandering merchant\nwith many tales"],
	["res://assets/characters/overworld/ow4.png", "Kira", "A swift rogue who\nloves treasure"],
	["res://assets/characters/overworld/ow5.png", "Roland", "A noble knight\nof the realm"],
	["res://assets/characters/overworld/ow6.png", "Lyra", "A gentle healer\nwith a pure heart"],
	["res://assets/characters/overworld/ow7.png", "Magnus", "A mighty warrior\nfrom the north"],
	["res://assets/characters/overworld/ow8.png", "Ivy", "A nature spirit\nconnected to forest"]
]

var selected_index = 0
var character_buttons = []

@onready var character_list = $MarginContainer/VBoxContainer/HBoxContainer/CharacterList/VBoxContainer
@onready var preview_sprite = $MarginContainer/VBoxContainer/HBoxContainer/CharacterPreview/MarginContainer/VBoxContainer/CenterContainer/PreviewSprite
@onready var character_name_label = $MarginContainer/VBoxContainer/HBoxContainer/CharacterPreview/MarginContainer/VBoxContainer/CharacterName
@onready var character_bio_label = $MarginContainer/VBoxContainer/HBoxContainer/CharacterPreview/MarginContainer/VBoxContainer/CharacterBio

func _ready():
	create_character_buttons()
	update_preview()
	
	$MarginContainer/VBoxContainer/ButtonContainer/BackButton.pressed.connect(_on_back_pressed)
	$MarginContainer/VBoxContainer/ButtonContainer/ConfirmButton.pressed.connect(_on_confirm_pressed)

func create_character_buttons():
	for i in range(characters.size()):
		var button = Button.new()
		button.text = characters[i][1]
		button.custom_minimum_size = Vector2(180, 50)
		button.add_theme_font_override("font", preload("res://fonts/Sniglet Regular.ttf"))
		button.add_theme_font_size_override("font_size", 18)
		
		# Add theme
		var theme = preload("res://themes/default_theme.tres")
		button.theme = theme
		
		var callable = func(index = i): select_character(index)
		button.pressed.connect(callable)
		
		character_list.add_child(button)
		character_buttons.append(button)
	
	# Highlight first button
	if character_buttons.size() > 0:
		highlight_button(0)

func select_character(index: int):
	selected_index = index
	update_preview()
	
	# Update button highlights
	for i in range(character_buttons.size()):
		highlight_button(i) if i == index else unhighlight_button(i)

func highlight_button(index: int):
	if index < character_buttons.size():
		character_buttons[index].add_theme_color_override("font_color", Color(1, 1, 0.6))

func unhighlight_button(index: int):
	if index < character_buttons.size():
		character_buttons[index].remove_theme_color_override("font_color")

func update_preview():
	var char_data = characters[selected_index]
	
	# Load and display character sprite
	var texture = load(char_data[0])
	var atlas = AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = Rect2(0, 0, 32, 32)
	preview_sprite.texture = atlas
	
	character_name_label.text = char_data[1]
	character_bio_label.text = char_data[2]

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _on_confirm_pressed():
	# Save selected character data
	GameData.selected_character_index = selected_index
	GameData.player_name = characters[selected_index][1]
	GameData.player_sprite_path = characters[selected_index][0]
	
	# Start the game
	get_tree().change_scene_to_file("res://root_node.tscn")
