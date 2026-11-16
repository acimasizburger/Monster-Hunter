class_name AmmoPickup
extends Area2D

@export var bullet_data: BulletData
@export var magnet_speed: float = 280.0
@export var drop_bounce_velocity: float = -180.0
@export var gravity_value: float = 600.0

var target_player: Player = null
var velocity: Vector2 = Vector2.ZERO
var is_grounded: bool = false

@onready var visual: ColorRect = $Visual
@onready var magnet_area: Area2D = $MagnetArea

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	magnet_area.body_entered.connect(_on_magnet_body_entered)
	velocity.y = drop_bounce_velocity
	velocity.x = randf_range(-60.0, 60.0)
	if bullet_data:
		visual.color = bullet_data.color

func setup(data: BulletData) -> void:
	bullet_data = data
	if is_node_ready() and bullet_data:
		visual.color = bullet_data.color

func _physics_process(delta: float) -> void:
	if target_player:
		var direction: Vector2 = (target_player.global_position - global_position).normalized()
		global_position += direction * magnet_speed * delta
	elif not is_grounded:
		velocity.y += gravity_value * delta
		global_position += velocity * delta
		if velocity.y > 0 and global_position.y >= get_meta("spawn_y", global_position.y):
			is_grounded = true
			velocity = Vector2.ZERO

func _on_magnet_body_entered(body: Node2D) -> void:
	if body is Player:
		target_player = body

func _on_body_entered(body: Node2D) -> void:
	if body is Player and bullet_data:
		if body.revolver.try_add_special_bullet(bullet_data):
			queue_free()
