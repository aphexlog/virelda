extends Control

# Starter selection screen - choose your first creature

var starters = [
	"Flamewing",    # Grass (evolves to Aquaveil -> Terrabite)
	"Shadowclaw",   # Fire (evolves to Crystalwing -> Blazeclaw)
	"Thunderfang"   # Water (evolves to Vinelash -> Glacierfist)
]

func _ready():
	# Setup sprites and buttons
	for i in range(3):
		var starter_name = starters[i]
		var creature_data = CreatureDB.creature_species[starter_name]
		
		var container = get_node("MarginContainer/VBoxContainer/HBoxContainer/Starter%d" % (i + 1))
		var sprite = container.get_node("VBoxContainer/CenterContainer/Sprite")
		var button = container.get_node("VBoxContainer/Button")
		
		# Load sprite - use AtlasTexture to show only first frame
		var atlas = AtlasTexture.new()
		atlas.atlas = load(creature_data.sprite_idle)
		atlas.region = Rect2(0, 0, 96, 96)  # First frame only
		sprite.texture = atlas
		
		# Connect button
		var callable = func(index = i): choose_starter(index)
		button.pressed.connect(callable)

func choose_starter(index: int):
	print("=== CHOOSE_STARTER CALLED ===")
	print("Index: ", index)
	
	var starter_name = starters[index]
	print("Chose starter: ", starter_name)
	
	# Create the starter creature at level 1
	var starter = CreatureDB.get_creature_by_name(starter_name, 1)
	
	if starter:
		GameData.player_party.clear()
		GameData.player_party.append(starter)
		GameData.active_creature_index = 0
		print("Added ", starter.species.species_name, " level ", starter.level, " to party!")
		
		# Check if file exists
		print("Checking if root_node.tscn exists...")
		if FileAccess.file_exists("res://root_node.tscn"):
			print("File exists!")
		else:
			print("File does NOT exist!")
		
		# Try to load the scene
		print("Attempting to load scene...")
		var game_scene = load("res://root_node.tscn")
		print("Load returned: ", game_scene)
		print("Game scene type: ", typeof(game_scene))
		
		if game_scene != null:
			print("Scene loaded successfully, changing scene...")
			var error = get_tree().change_scene_to_packed(game_scene)
			print("change_scene_to_packed returned: ", error)
			if error != OK:
				push_error("Failed to change scene! Error code: " + str(error))
		else:
			push_error("Failed to load root_node.tscn - returned null!")
	else:
		push_error("Failed to create starter creature: " + starter_name)
