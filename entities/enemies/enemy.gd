class_name Enemy
extends CharacterBody2D

@export_group("Stats")
@export var move_speed: float = 90.0
@export var chase_speed: float = 140.0
@export var gravity: float = 980.0
@export var is_flying: bool = false

@onready var visuals: Node2D = $Visuals
@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var detection_area: Area2D = $DetectionArea

var facing_direction: int = 1
var target_player: Player = null

func _ready() -> void:
	health_component.died.connect(_on_died)
	detection_area.body_entered.connect(_on_detection_body_entered)
	detection_area.body_exited.connect(_on_detection_body_exited)
	state_machine.init(self)

func update_facing_direction(dir_x: float) -> void:
	if dir_x > 0 and facing_direction != 1:
		facing_direction = 1
		visuals.scale.x = 1
	elif dir_x < 0 and facing_direction != -1:
		facing_direction = -1
		visuals.scale.x = -1

func apply_gravity(delta: float) -> void:
	if not is_flying and not is_on_floor():
		velocity.y += gravity * delta

func can_walk_forward() -> bool:
	return true

func _on_detection_body_entered(body: Node2D) -> void:
	if body is Player:
		target_player = body

func _on_detection_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null

func _on_died(_killed_by_melee: bool) -> void:
	state_machine.force_transition("Dead")
