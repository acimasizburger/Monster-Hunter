class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func init(parent_entity: CharacterBody2D) -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.entity = parent_entity
			child.transitioned.connect(_on_child_transition)
	
	if initial_state:
		current_state = initial_state
		current_state.enter()

func has_state(state_name: StringName) -> bool:
	return states.has(state_name.to_lower())

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func _on_child_transition(new_state_name: StringName) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state or new_state == current_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state

func force_transition(new_state_name: StringName, msg := {}) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state or new_state == current_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter(msg)
	current_state = new_state
