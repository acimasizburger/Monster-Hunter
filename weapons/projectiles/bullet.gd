class_name Bullet
extends Area2D

var data: BulletData
var direction: int = 1

@onready var visual: ColorRect = $Visual
@onready var screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	screen_notifier.screen_exited.connect(queue_free)
	
	if data:
		visual.color = data.color

func setup(bullet_data: BulletData, dir: int) -> void:
	data = bullet_data
	direction = dir
	if is_node_ready() and data:
		visual.color = data.color

func _physics_process(delta: float) -> void:
	if data:
		position.x += direction * data.speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.receive_hit(data.damage, data.bullet_name, false)
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
