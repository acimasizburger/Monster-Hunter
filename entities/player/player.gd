class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var move_speed: float = 220.0
@export var jump_velocity: float = -380.0
@export var gravity: float = 980.0

@export_group("Combat")
@export var is_rage_mode: bool = false

@onready var melee_hitbox: HitboxComponent = $Visuals/MeleeHitbox
@onready var melee_visual: ColorRect = $Visuals/MeleeHitbox/MeleeVisual
@onready var visuals: Node2D = $Visuals
@onready var state_machine: StateMachine = $StateMachine

var facing_direction: int = 1

func _ready() -> void:
	print("1. Player hazır")
	state_machine.init(self)
	print("2. Mevcut durum: ", state_machine.current_state)

func get_input_direction() -> float:
	return Input.get_axis("left", "right")

func update_facing_direction(direction: float) -> void:
	if direction > 0 and facing_direction != 1:
		facing_direction = 1
		visuals.scale.x = 1
	elif direction < 0 and facing_direction != -1:
		facing_direction = -1
		visuals.scale.x = -1

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
