extends CharacterBody2D

@export var speed: float = 100.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var x := Input.get_axis("move_left", "move_right")
	var y := Input.get_axis("move_up", "move_down")

	if x == 0.0:
		x = Input.get_axis("ui_left", "ui_right")
	if y == 0.0:
		y = Input.get_axis("ui_up", "ui_down")

	var dir := Vector2(x, y)

	if dir.length() > 1.0:
		dir = dir.normalized()

	velocity = dir * speed
	move_and_slide()

	update_animation(dir)


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
