# Interact.gd
extends Area2D

@onready var prompt := $Prompt
var player_inside := false

func _ready():
	prompt.visible = false
	
func _on_body_entered(body):
	print("ENTER:", body.name)
	if not body.is_in_group("player"):
		return
	player_inside = true
	prompt.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		prompt.visible = false

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		enter_house()

func enter_house():
	# TODO: replace with your scene change / teleport
	print("Entering house")
