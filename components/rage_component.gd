class_name RageComponent
extends Node

signal rage_changed(current_rage: float, max_rage: float)
signal rage_activated
signal rage_deactivated

@export var max_rage: float = 100.0
@export var drain_rate: float = 15.0
@export var gain_on_damage_taken: float = 20.0
@export var gain_on_melee_hit: float = 25.0

var current_rage: float = 0.0
var is_active: bool = false

func _process(delta: float) -> void:
	if is_active:
		current_rage = move_toward(current_rage, 0.0, drain_rate * delta)
		rage_changed.emit(current_rage, max_rage)
		if current_rage <= 0.0:
			deactivate()

func add_rage(amount: float) -> void:
	if is_active:
		return
	current_rage = clamp(current_rage + amount, 0.0, max_rage)
	rage_changed.emit(current_rage, max_rage)

func can_activate() -> bool:
	return not is_active and current_rage >= max_rage

func activate() -> bool:
	if not can_activate():
		return false
	is_active = true
	rage_activated.emit()
	return true

func deactivate() -> void:
	if not is_active:
		return
	is_active = false
	current_rage = 0.0
	rage_changed.emit(current_rage, max_rage)
	rage_deactivated.emit()
