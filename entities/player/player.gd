class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var normal_move_speed: float = 220.0
@export var rage_move_speed: float = 310.0
@export var jump_velocity: float = -380.0
@export var gravity: float = 980.0

@export_group("Combat")
@export var normal_melee_damage: int = 20
@export var rage_melee_damage: int = 55

@onready var visuals: Node2D = $Visuals
@onready var human_sprite: AnimatedSprite2D = $Visuals/HumanSprite
@onready var monster_sprite: AnimatedSprite2D = $Visuals/MonsterSprite
@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var rage_component: RageComponent = $RageComponent
@onready var melee_hitbox: HitboxComponent = $Visuals/MeleeHitbox
@onready var melee_visual: ColorRect = $Visuals/MeleeHitbox/MeleeVisual
@onready var revolver: RevolverComponent = $RevolverComponent
@onready var muzzle_point: Marker2D = $Visuals/MuzzlePoint

var move_speed: float
var facing_direction: int = 1
var is_rage_mode: bool = false

func _ready() -> void:
	move_speed = normal_move_speed
	melee_hitbox.damage = normal_melee_damage
	
	health_component.damaged.connect(_on_damaged)
	health_component.died.connect(_on_died)
	melee_hitbox.area_entered.connect(_on_melee_hit)
	rage_component.rage_activated.connect(_on_rage_activated)
	rage_component.rage_deactivated.connect(_on_rage_deactivated)
	
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	if state_machine.current_state and state_machine.current_state.name.to_lower() == "dead":
		return
		
	if event.is_action_pressed("rage"):
		rage_component.activate()
		
	if is_rage_mode:
		return
		
	if state_machine.current_state and state_machine.current_state.name.to_lower() == "melee":
		return
		
	if event.is_action_pressed("shoot"):
		revolver.shoot(muzzle_point.global_position, facing_direction)

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

func _on_damaged(_amount: int, _damage_type: StringName, _is_melee: bool) -> void:
	rage_component.add_rage(rage_component.gain_on_damage_taken)

func _on_melee_hit(area: Area2D) -> void:
	if area is HurtboxComponent:
		rage_component.add_rage(rage_component.gain_on_melee_hit)

func _on_rage_activated() -> void:
	is_rage_mode = true
	move_speed = rage_move_speed
	melee_hitbox.damage = rage_melee_damage
	human_sprite.visible = false
	monster_sprite.visible = true

func _on_rage_deactivated() -> void:
	is_rage_mode = false
	move_speed = normal_move_speed
	melee_hitbox.damage = normal_melee_damage
	human_sprite.visible = true
	monster_sprite.visible = false

func _on_died(_killed_by_melee: bool) -> void:
	state_machine.force_transition("Dead")
