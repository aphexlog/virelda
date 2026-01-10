extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(_delta: float) -> void:
	var x := Input.get_axis("move_left", "move_right")
	var y := Input.get_axis("move_up", "move_down")

	# Optional fallback to arrow-key defaults if you haven't made custom actions yet
	if x == 0.0:
		x = Input.get_axis("ui_left", "ui_right")
	if y == 0.0:
		y = Input.get_axis("ui_up", "ui_down")

	var dir := Vector2(x, y)

	# Normalize so diagonal isn't faster
	if dir.length() > 1.0:
		dir = dir.normalized()

	velocity = dir * speed
	move_and_slide()
