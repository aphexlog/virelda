extends Node

# Audio player pools
var ui_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

# Sound libraries
var button_sounds = {
	"click": "res://assets/audio/sfx/button_fx/high/button_fx_high_001_cc0_avr.wav",
	"hover": "res://assets/audio/sfx/button_fx/mid/button_fx_mid_001_01_cc0_avr.wav",
	"select": "res://assets/audio/sfx/button_fx/magic/button_fx_magic_001_cc0_avr.wav",
	"back": "res://assets/audio/sfx/button_fx/low/button_fx_low_001_cc0_avr.wav",
	"confirm": "res://assets/audio/sfx/button_fx/verse/button_fx_verse_001_cc0_avr.wav",
	"error": "res://assets/audio/sfx/button_fx/noise/button_fx_noise_001_cc0_avr.wav"
}

var battle_sounds = {
	"attack": "res://assets/audio/sfx/button_fx/fx/jump/button_fx_jump_001_01_cc0_avr.wav",
	"damage": "res://assets/audio/sfx/button_fx/fx/noise/button_fx_noise_008_cc0_avr.wav",
	"heal": "res://assets/audio/sfx/button_fx/fx/magic/button_fx_magic_005_cc0_avr.wav",
	"level_up": "res://assets/audio/sfx/button_fx/verse/button_fx_verse_013_cc0_avr.wav",
	"victory": "res://assets/audio/sfx/button_fx/magic/button_fx_magic_009_cc0_avr.wav",
	"run": "res://assets/audio/sfx/button_fx/fx/delay/button_fx_delay_006_002_cc0_avr.wav"
}

func _ready():
	# Create audio players
	ui_player = AudioStreamPlayer.new()
	ui_player.name = "UIPlayer"
	ui_player.bus = "Master"
	add_child(ui_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	sfx_player.bus = "Master"
	add_child(sfx_player)
	
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Master"
	add_child(music_player)
	
	print("AudioManager initialized")

func play_ui_sound(sound_name: String):
	if button_sounds.has(sound_name):
		play_sound(ui_player, button_sounds[sound_name])
	else:
		push_warning("UI sound not found: " + sound_name)

func play_battle_sound(sound_name: String):
	if battle_sounds.has(sound_name):
		play_sound(sfx_player, battle_sounds[sound_name])
	else:
		push_warning("Battle sound not found: " + sound_name)

func play_sound(player: AudioStreamPlayer, path: String):
	var stream = load(path)
	if stream:
		player.stream = stream
		player.play()
	else:
		push_error("Failed to load sound: " + path)

func stop_all():
	ui_player.stop()
	sfx_player.stop()
	music_player.stop()
