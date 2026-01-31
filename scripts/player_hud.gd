extends CanvasLayer

# Player HUD - shows coins and other info during gameplay

@onready var coin_label = $TopBar/HBoxContainer/CoinDisplay/CoinLabel

func _ready():
	update_coins()

func _process(_delta):
	# Update coins display every frame (lightweight)
	update_coins()

func update_coins():
	coin_label.text = str(GameData.coins)
