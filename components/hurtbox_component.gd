class_name HurtboxComponent
extends Area2D

signal hit_received(damage: int, damage_type: StringName, is_melee: bool, attacker_position: Vector2)

@export var health_component: HealthComponent
@export var resistances: Dictionary = {}

func receive_hit(base_damage: int, damage_type: StringName, is_melee: bool, attacker_position: Vector2 = Vector2.ZERO) -> void:
	if not health_component:
		return
		
	var multiplier: float = resistances.get(damage_type, 1.0)
	var final_damage: int = roundi(base_damage * multiplier)
	
	if final_damage > 0:
		health_component.take_damage(final_damage, damage_type, is_melee)
		hit_received.emit(final_damage, damage_type, is_melee, attacker_position)
