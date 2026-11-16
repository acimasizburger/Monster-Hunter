class_name ShellCasing
extends CharacterBody2D

@export var gravity: float = 550.0
@export var bounciness: float = 0.45
@export var friction: float = 0.75
@export var lifetime: float = 2.5

var spin_speed: float = 0.0
var is_settled: bool = false

func _ready() -> void:
	var tween := create_tween()
	tween.tween_interval(lifetime * 0.7)
	tween.tween_property(self, "modulate:a", 0.0, lifetime * 0.3)
	tween.tween_callback(queue_free)

func launch(facing_direction: int) -> void:
	var eject_dir := -facing_direction
	velocity.x = eject_dir * randf_range(28.0, 58.0)
	velocity.y = randf_range(-130.0, -85.0)
	spin_speed = eject_dir * randf_range(12.0, 22.0)

func _physics_process(delta: float) -> void:
	if is_settled:
		return
		
	velocity.y += gravity * delta
	rotation += spin_speed * delta
	
	var collision := move_and_collide(velocity * delta)
	if collision:
		var normal := collision.get_normal()
		if normal.y < -0.5 and abs(velocity.y) < 35.0:
			velocity = Vector2.ZERO
			spin_speed = 0.0
			rotation = 0.0
			is_settled = true
		else:
			velocity = velocity.bounce(normal)
			velocity.x *= friction
			velocity.y *= bounciness
			spin_speed *= 0.6
