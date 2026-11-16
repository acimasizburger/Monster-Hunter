class_name LootDropComponent
extends Node

@export var health_component: HealthComponent
@export var pickup_scene: PackedScene
@export var drop_bullet_data: BulletData
@export_range(0.0, 1.0) var normal_drop_chance: float = 0.15
@export_range(0.0, 1.0) var melee_drop_chance: float = 0.75

func _ready() -> void:
	if health_component:
		health_component.died.connect(_on_died)

func _on_died(killed_by_melee: bool) -> void:
	if not pickup_scene or not drop_bullet_data:
		return
		
	var chance: float = melee_drop_chance if killed_by_melee else normal_drop_chance
	if randf() <= chance:
		_spawn_pickup()

func _spawn_pickup() -> void:
	var parent_node := get_parent() as Node2D
	if not parent_node:
		return
		
	var pickup: AmmoPickup = pickup_scene.instantiate()
	pickup.global_position = parent_node.global_position
	pickup.set_meta("spawn_y", parent_node.global_position.y)
	pickup.setup(drop_bullet_data)
	get_tree().current_scene.call_deferred("add_child", pickup)
