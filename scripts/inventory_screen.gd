extends CanvasLayer

# Inventory screen - shows items and allows using them

@onready var item_list = $Panel/MarginContainer/VBoxContainer/ScrollContainer/ItemList
@onready var coin_label = $Panel/MarginContainer/VBoxContainer/TopBar/CoinDisplay/CoinLabel
@onready var close_button = $Panel/MarginContainer/VBoxContainer/CloseButton

func _ready():
	close_button.pressed.connect(_on_close_pressed)
	visible = false

func _input(event):
	# Press I to toggle inventory
	if event is InputEventKey and event.pressed and event.keycode == KEY_I:
		visible = !visible
		if visible:
			refresh_inventory()
		get_viewport().set_input_as_handled()

func refresh_inventory():
	item_list.clear()
	coin_label.text = str(GameData.coins)
	
	if GameData.inventory.is_empty():
		item_list.add_item("No items yet!")
		return
	
	# Show all items with quantities
	for item_name in GameData.inventory.keys():
		var quantity = GameData.inventory[item_name]
		var display_text = "%s x%d" % [item_name, quantity]
		item_list.add_item(display_text)

func _on_close_pressed():
	visible = false
