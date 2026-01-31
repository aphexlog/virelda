extends CharacterBody2D

@export var speed: float = 100.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var steps_taken: int = 0
var step_timer: float = 0.0
var step_interval: float = 1.5  # Check every 1.5 seconds of movement

func _ready():
	add_to_group("player")
	
	# Set spawn position for level scaling (only once)
	if not GameData.spawn_position_set:
		GameData.spawn_position = global_position
		GameData.spawn_position_set = true
		print("Spawn position set to: ", GameData.spawn_position)
	
	# Apply selected character sprite
	load_character_sprite()
	
	# Apply loaded position if loading a save
	if GameData.should_apply_on_ready:
		global_position = Vector2(GameData.player_data.position_x, GameData.player_data.position_y)
		GameData.should_apply_on_ready = false
		print("Loaded player position: ", global_position)

func load_character_sprite():
	# Load the selected character's sprite
	var texture = load(GameData.player_sprite_path)
	if not texture:
		push_error("Failed to load character sprite: " + GameData.player_sprite_path)
		return
	
	print("Loading character: ", GameData.player_name)
	
	# Update all animation frames with the new character texture
	if sprite and sprite.sprite_frames:
		for anim_name in sprite.sprite_frames.get_animation_names():
			var frame_count = sprite.sprite_frames.get_frame_count(anim_name)
			for i in range(frame_count):
				# Get the original frame to preserve the region coordinates
				var original_texture = sprite.sprite_frames.get_frame_texture(anim_name, i)
				
				# Create a new AtlasTexture with the new character sprite
				var new_atlas = AtlasTexture.new()
				new_atlas.atlas = texture
				
				# Copy the region from the original frame
				if original_texture is AtlasTexture:
					new_atlas.region = original_texture.region
				else:
					# Fallback: assume standard 32x32 frames
					new_atlas.region = Rect2(i * 32, 0, 32, 32)
				
				# Update the frame
				sprite.sprite_frames.set_frame(anim_name, i, new_atlas)
	
	print("Character sprite loaded successfully!")

func _physics_process(_delta: float) -> void:
	var x := Input.get_axis("ui_left", "ui_right")
	var y := Input.get_axis("ui_up", "ui_down")

	var dir := Vector2(x, y)

	if dir.length() > 1.0:
		dir = dir.normalized()

	velocity = dir * speed
	var is_moving = move_and_slide()
	
	# Check for random encounters while player is moving
	if velocity.length() > 0:
		step_timer += _delta
		if step_timer >= step_interval:
			step_timer = 0.0
			check_encounter()

	update_animation(dir)

func check_encounter():
	# More frequent encounters - 25% chance every 1.5 seconds of walking
	if randf() < 0.25:
		print("Battle triggered!")
		trigger_battle()

func trigger_battle():
	# Calculate wild creature level based on distance from spawn
	var wild_level = GameData.calculate_wild_creature_level(global_position)
	var wild_creature = CreatureDB.get_random_creature(wild_level, wild_level)
	var player_creature = GameData.get_active_creature()
	
	if player_creature == null:
		print("No creature in party!")
		return
	
	print("Wild level %d creature appeared at distance: %d" % [wild_level, int(global_position.distance_to(GameData.spawn_position))])
	
	# Store battle data in GameData for scene transition
	GameData.pending_battle_player_creature = player_creature
	GameData.pending_battle_enemy_creature = wild_creature
	
	# Switch to battle scene
	get_tree().change_scene_to_file("res://scenes/battle_scene.tscn")


func update_animation(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		sprite.stop()
		return

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			sprite.play("walk_right")
		else:
			sprite.play("walk_left")
	else:
		if dir.y > 0:
			sprite.play("walk_down")
		else:
			sprite.play("walk_up")
