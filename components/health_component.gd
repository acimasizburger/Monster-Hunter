class_name HealthComponent
extends Node

signal health_changed(current_health: int, max_health: int)
signal damaged(amount: int, damage_type: StringName, is_melee: bool)
signal died(killed_by_melee: bool)

@export var max_health: int = 100
var current_health: int

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int, damage_type: StringName = &"normal", is_melee: bool = false) -> void:
	if current_health <= 0:
		return
		
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	damaged.emit(amount, damage_type, is_melee)
	
	if current_health == 0:
		died.emit(is_melee)
