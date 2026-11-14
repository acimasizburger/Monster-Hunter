class_name State
extends Node

signal transitioned(state_name: StringName)

var entity: CharacterBody2D

func enter(_msg := {}) -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
