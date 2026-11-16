class_name Enemy
extends CharacterBody2D

@export_group("Stats")
@export var move_speed: float = 50.0
@export var chase_speed: float = 80.0
@export var gravity: float = 750.0
@export var is_flying: bool = false

@export_group("Knockback")
@export var can_be_knocked_back: bool = true
@export var knockback_force: Vector2 = Vector2(120.0, -90.0)
@export var knockback_duration: float = 0.18

@onready var visuals: Node2D = $Visuals
@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var detection_area: Area2D = $DetectionArea

var facing_direction: int = 1
var target_player: Player = null
var knockback_timer: float = 0.0

func _ready() -> void:
	hurtbox_component.hit_received.connect(_on_hit_received)
	health_component.died.connect(_on_died)
	detection_area.body_entered.connect(_on_detection_body_entered)
	detection_area.body_exited.connect(_on_detection_body_exited)
	state_machine.init(self)

func _physics_process(delta: float) -> void:
	if target_player and target_player.is_dead:
		target_player = null
		
	if knockback_timer > 0.0:
		knockback_timer -= delta
		apply_gravity(delta)
		move_and_slide()

func update_facing_direction(dir_x: float) -> void:
	if knockback_timer > 0.0:
		return
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

func _on_hit_received(_damage: int, _damage_type: StringName, is_melee: bool, attacker_position: Vector2) -> void:
	if is_melee and can_be_knocked_back:
		var dir_x: float = sign(global_position.x - attacker_position.x)
		if dir_x == 0.0:
			dir_x = 1.0
		velocity = Vector2(dir_x * knockback_force.x, 0.0 if is_flying else knockback_force.y)
		knockback_timer = knockback_duration

func _on_detection_body_entered(body: Node2D) -> void:
	if body is Player and not body.is_dead:
		target_player = body

func _on_detection_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null

func _on_died(_killed_by_melee: bool) -> void:
	state_machine.force_transition("Dead")
