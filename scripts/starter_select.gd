extends Control

# Starter selection screen - choose your first creature

var starters = [
	"Flamewing",   # Fire
	"Aquaveil",    # Water
	"Leafwhisper"  # Grass
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
	var starter_name = starters[index]
	print("Chose starter: ", starter_name)
	
	# Create the starter creature at level 1
	var starter = CreatureDB.get_creature_by_name(starter_name, 1)
	if starter:
		GameData.player_party.clear()  # Clear any existing creatures
		GameData.player_party.append(starter)
		print("Added ", starter.species.species_name, " level ", starter.level, " to party!")
	
	# Start the game
	get_tree().change_scene_to_file("res://root_node.tscn")
