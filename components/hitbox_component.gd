class_name HitboxComponent
extends Area2D

@export var damage: int = 20
@export var damage_type: StringName = &"normal"
@export var is_melee: bool = false
@export var continuous_damage: bool = false
@export var damage_interval: float = 0.8

var hit_targets: Array[Node] = []
var tick_timer: float = 0.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	set_deferred("monitoring", false)

func _process(delta: float) -> void:
	if not continuous_damage or not monitoring:
		return
	tick_timer -= delta
	if tick_timer <= 0.0:
		tick_timer = damage_interval
		for area in get_overlapping_areas():
			if area is HurtboxComponent:
				area.receive_hit(damage, damage_type, is_melee, global_position)

func activate() -> void:
	hit_targets.clear()
	tick_timer = 0.0
	set_deferred("monitoring", true)

func deactivate() -> void:
	set_deferred("monitoring", false)

func _on_area_entered(area: Area2D) -> void:
	if continuous_damage:
		return
	if area is HurtboxComponent:
		if area.owner in hit_targets:
			return
		hit_targets.append(area.owner)
		area.receive_hit(damage, damage_type, is_melee, global_position)
