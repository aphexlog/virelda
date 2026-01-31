extends Control

# Battle scene controller

var player_creature: Creature
var enemy_creature: Creature
var battle_active: bool = false
var player_turn: bool = true

@onready var player_sprite = $BattleArea/PlayerPosition/PlayerSprite
@onready var enemy_sprite = $BattleArea/EnemyPosition/EnemySprite
@onready var attack_vfx = $BattleArea/VFXLayer/AttackVFX
@onready var background = $Background

@onready var player_name_label = $UI/PlayerInfo/MarginContainer/VBoxContainer/PlayerName
@onready var player_level_label = $UI/PlayerInfo/MarginContainer/VBoxContainer/PlayerLevel
@onready var player_hp_bar = $UI/PlayerInfo/MarginContainer/VBoxContainer/HPBar
@onready var player_hp_label = $UI/PlayerInfo/MarginContainer/VBoxContainer/HPLabel

@onready var enemy_name_label = $UI/EnemyInfo/MarginContainer/VBoxContainer/EnemyName
@onready var enemy_level_label = $UI/EnemyInfo/MarginContainer/VBoxContainer/EnemyLevel
@onready var enemy_hp_bar = $UI/EnemyInfo/MarginContainer/VBoxContainer/HPBar
@onready var enemy_hp_label = $UI/EnemyInfo/MarginContainer/VBoxContainer/HPLabel

@onready var message_label = $UI/MessageBox/MarginContainer/MessageLabel
@onready var attack_button = $UI/BattleMenu/MarginContainer/VBoxContainer/AttackButton
@onready var run_button = $UI/BattleMenu/MarginContainer/VBoxContainer/RunButton

var vfx_textures = []

func _ready():
	load_vfx()
	attack_button.pressed.connect(_on_attack_pressed)
	run_button.pressed.connect(_on_run_pressed)
	
	# Load random background
	var bg_num = randi_range(1, 3)
	background.texture = load("res://assets/backgrounds/background%d.png" % bg_num)
	
	# Start battle with pending creatures from GameData
	if GameData.pending_battle_player_creature and GameData.pending_battle_enemy_creature:
		start_battle(GameData.pending_battle_player_creature, GameData.pending_battle_enemy_creature)
		# Clear pending data
		GameData.pending_battle_player_creature = null
		GameData.pending_battle_enemy_creature = null
	else:
		print("ERROR: No pending battle data!")

func load_vfx():
	for i in range(1, 8):
		vfx_textures.append(load("res://assets/vfx/attack%d.png" % i))

func start_battle(player_creature_data: Creature, enemy_creature_data: Creature):
	player_creature = player_creature_data
	enemy_creature = enemy_creature_data
	battle_active = true
	player_turn = true
	
	setup_ui()
	show_message("A wild %s appeared!" % enemy_creature.species.species_name)

func setup_ui():
	# Player creature
	var player_atlas = AtlasTexture.new()
	player_atlas.atlas = load(player_creature.species.sprite_idle)
	player_atlas.region = Rect2(0, 0, 96, 96)  # First frame only
	player_sprite.texture = player_atlas
	player_name_label.text = player_creature.species.species_name
	player_level_label.text = "Lv. %d" % player_creature.level
	update_player_hp()
	
	# Enemy creature
	var enemy_atlas = AtlasTexture.new()
	enemy_atlas.atlas = load(enemy_creature.species.sprite_idle)
	enemy_atlas.region = Rect2(0, 0, 96, 96)  # First frame only
	enemy_sprite.texture = enemy_atlas
	enemy_name_label.text = enemy_creature.species.species_name
	enemy_level_label.text = "Lv. %d" % enemy_creature.level
	update_enemy_hp()

func update_player_hp():
	player_hp_bar.value = float(player_creature.current_hp) / player_creature.max_hp
	player_hp_label.text = "HP: %d/%d" % [player_creature.current_hp, player_creature.max_hp]

func update_enemy_hp():
	enemy_hp_bar.value = float(enemy_creature.current_hp) / enemy_creature.max_hp
	enemy_hp_label.text = "HP: %d/%d" % [enemy_creature.current_hp, enemy_creature.max_hp]

func show_message(text: String):
	message_label.text = text

func disable_menu():
	attack_button.disabled = true
	run_button.disabled = true

func enable_menu():
	attack_button.disabled = false
	run_button.disabled = false

func _on_attack_pressed():
	if not battle_active or not player_turn:
		return
	
	disable_menu()
	await player_attack()
	
	if not enemy_creature.is_fainted():
		await get_tree().create_timer(0.5).timeout
		await enemy_attack()
	
	if battle_active:
		enable_menu()

func player_attack():
	player_turn = false
	show_message("%s attacks!" % player_creature.species.species_name)
	
	# Show attack animation
	var attack_atlas = AtlasTexture.new()
	attack_atlas.atlas = load(player_creature.species.sprite_attack)
	attack_atlas.region = Rect2(0, 0, 96, 96)
	player_sprite.texture = attack_atlas
	await get_tree().create_timer(0.3).timeout
	
	# Show VFX on enemy
	await play_vfx(enemy_sprite.global_position + Vector2(0, 0))
	
	# Calculate damage
	var damage = calculate_damage(player_creature, enemy_creature)
	enemy_creature.take_damage(damage)
	update_enemy_hp()
	
	show_message("%s dealt %d damage!" % [player_creature.species.species_name, damage])
	
	# Reset sprite
	var idle_atlas = AtlasTexture.new()
	idle_atlas.atlas = load(player_creature.species.sprite_idle)
	idle_atlas.region = Rect2(0, 0, 96, 96)
	player_sprite.texture = idle_atlas
	await get_tree().create_timer(0.5).timeout
	
	# Check if enemy fainted
	if enemy_creature.is_fainted():
		await battle_won()
	else:
		player_turn = true

func enemy_attack():
	show_message("%s attacks!" % enemy_creature.species.species_name)
	
	# Show attack animation
	var attack_atlas = AtlasTexture.new()
	attack_atlas.atlas = load(enemy_creature.species.sprite_attack)
	attack_atlas.region = Rect2(0, 0, 96, 96)
	enemy_sprite.texture = attack_atlas
	await get_tree().create_timer(0.3).timeout
	
	# Show VFX on player
	await play_vfx(player_sprite.global_position + Vector2(0, 0))
	
	# Calculate damage
	var damage = calculate_damage(enemy_creature, player_creature)
	player_creature.take_damage(damage)
	update_player_hp()
	
	show_message("%s dealt %d damage!" % [enemy_creature.species.species_name, damage])
	
	# Reset sprite
	var idle_atlas = AtlasTexture.new()
	idle_atlas.atlas = load(enemy_creature.species.sprite_idle)
	idle_atlas.region = Rect2(0, 0, 96, 96)
	enemy_sprite.texture = idle_atlas
	await get_tree().create_timer(0.5).timeout
	
	# Check if player fainted
	if player_creature.is_fainted():
		await battle_lost()

func calculate_damage(attacker: Creature, defender: Creature) -> int:
	# Pokemon-like damage formula: more realistic damage calculation
	# Damage = ((2 * Level / 5 + 2) * Attack / Defense) * random(0.85-1.0)
	var level_modifier = (2.0 * attacker.level / 5.0 + 2.0)
	var attack_defense_ratio = float(attacker.attack) / max(1.0, float(defender.defense))
	var base_damage = level_modifier * attack_defense_ratio * 10.0  # Scale up for visibility
	var damage = base_damage * randf_range(0.85, 1.0)
	return max(1, int(damage))

func play_vfx(position: Vector2):
	var vfx_texture = vfx_textures[randi() % vfx_textures.size()]
	attack_vfx.texture = vfx_texture
	attack_vfx.global_position = position - Vector2(64, 64)
	attack_vfx.visible = true
	attack_vfx.modulate.a = 1.0
	
	# Fade out effect
	var tween = create_tween()
	tween.tween_property(attack_vfx, "modulate:a", 0.0, 0.5)
	await tween.finished
	attack_vfx.visible = false

func battle_won():
	battle_active = false
	disable_menu()
	show_message("You won! %s fainted!" % enemy_creature.species.species_name)
	await get_tree().create_timer(1.5).timeout
	
	# Give experience based on enemy level
	var exp_gained = enemy_creature.level * 15
	player_creature.gain_experience(exp_gained)
	show_message("%s gained %d EXP!" % [player_creature.species.species_name, exp_gained])
	await get_tree().create_timer(2.0).timeout
	
	end_battle()

func battle_lost():
	battle_active = false
	disable_menu()
	show_message("You lost! %s fainted!" % player_creature.species.species_name)
	await get_tree().create_timer(2.0).timeout
	end_battle()

func _on_run_pressed():
	if not battle_active:
		return
	
	disable_menu()
	
	# 50% chance to run
	if randf() < 0.5:
		show_message("Got away safely!")
		await get_tree().create_timer(1.5).timeout
		end_battle()
	else:
		show_message("Can't escape!")
		await get_tree().create_timer(1.0).timeout
		await enemy_attack()
		if battle_active:
			enable_menu()

func end_battle():
	# Heal player's creature after battle (full HP restore)
	if player_creature:
		player_creature.current_hp = player_creature.max_hp
		print("%s fully healed!" % player_creature.species.species_name)
	
	# Return to overworld
	get_tree().change_scene_to_file("res://root_node.tscn")
