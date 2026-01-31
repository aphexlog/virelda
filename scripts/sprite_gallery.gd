extends Control

# Sprite gallery to help plan creature evolutions

func _ready():
	var grid = $MarginContainer/VBoxContainer/ScrollContainer/GridContainer
	var continue_button = $MarginContainer/VBoxContainer/ContinueButton
	
	continue_button.pressed.connect(_on_continue_pressed)
	
	# Create cards for all 16 creatures
	var creature_names = [
		"Flamewing", "Aquaveil", "Terrabite", "Voltspike",
		"Leafwhisper", "Frostbite", "Shadowclaw", "Crystalwing",
		"Blazeclaw", "Tidehunter", "Stoneguard", "Thunderfang",
		"Vinelash", "Glacierfist", "Nightstalker", "Prismguard"
	]
	
	for i in range(16):
		var creature_name = creature_names[i]
		var sprite_num = i + 1
		
		# Create card container
		var card = PanelContainer.new()
		card.custom_minimum_size = Vector2(140, 180)
		
		var vbox = VBoxContainer.new()
		card.add_child(vbox)
		
		# Add sprite number
		var num_label = Label.new()
		num_label.text = "Sprite %d" % sprite_num
		num_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		num_label.add_theme_font_size_override("font_size", 12)
		vbox.add_child(num_label)
		
		# Add sprite image
		var center = CenterContainer.new()
		center.custom_minimum_size = Vector2(0, 100)
		vbox.add_child(center)
		
		var sprite_rect = TextureRect.new()
		sprite_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite_rect.custom_minimum_size = Vector2(96, 96)
		sprite_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		
		# Load sprite with AtlasTexture to show first frame
		var atlas = AtlasTexture.new()
		atlas.atlas = load("res://assets/sprites/sprite%d_idle.png" % sprite_num)
		atlas.region = Rect2(0, 0, 96, 96)
		sprite_rect.texture = atlas
		
		center.add_child(sprite_rect)
		
		# Add creature name
		var name_label = Label.new()
		name_label.text = creature_name
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_override("font", preload("res://fonts/Sniglet Regular.ttf"))
		name_label.add_theme_font_size_override("font_size", 14)
		vbox.add_child(name_label)
		
		# Add type
		if CreatureDB.creature_species.has(creature_name):
			var type_label = Label.new()
			type_label.text = CreatureDB.creature_species[creature_name].creature_type.capitalize()
			type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			type_label.add_theme_font_size_override("font_size", 11)
			type_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
			vbox.add_child(type_label)
		
		grid.add_child(card)

func _on_continue_pressed():
	# Skip to title screen
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
