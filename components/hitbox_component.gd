class_name HitboxComponent
extends Area2D

@export var damage: int = 20
@export var damage_type: StringName = &"normal"
@export var is_melee: bool = false

var hit_targets: Array[Node] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	set_deferred("monitoring", false)

func activate() -> void:
	hit_targets.clear()
	set_deferred("monitoring", true)

func deactivate() -> void:
	set_deferred("monitoring", false)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		if area.owner in hit_targets:
			return
		hit_targets.append(area.owner)
		area.receive_hit(damage, damage_type, is_melee)
