class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent

@export var resistances: Dictionary = {}

func receive_hit(base_damage: int, damage_type: StringName, is_melee: bool) -> void:
	if not health_component:
		return
		
	var multiplier: float = resistances.get(damage_type, 1.0)
	var final_damage: int = roundi(base_damage * multiplier)
	
	if final_damage > 0:
		health_component.take_damage(final_damage, damage_type, is_melee)
