class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var normal_move_speed: float = 100.0
@export var rage_move_speed: float = 140.0
@export var jump_velocity: float = -240.0
@export var gravity: float = 750.0

@export_group("Combat")
@export var normal_melee_damage: int = 20
@export var rage_melee_damage: int = 55
@export var knockback_force: Vector2 = Vector2(130.0, -110.0)
@export var knockback_duration: float = 0.2

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
var is_dead: bool = false
var knockback_timer: float = 0.0

func _ready() -> void:
	move_speed = normal_move_speed
	melee_hitbox.damage = normal_melee_damage
	
	hurtbox_component.hit_received.connect(_on_hit_received)
	health_component.died.connect(_on_died)
	melee_hitbox.area_entered.connect(_on_melee_hit)
	rage_component.rage_activated.connect(_on_rage_activated)
	rage_component.rage_deactivated.connect(_on_rage_deactivated)
	
	state_machine.init(self)

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		knockback_timer -= delta

func _unhandled_input(event: InputEvent) -> void:
	if is_dead:
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
	if knockback_timer > 0.0 or is_dead:
		return 0.0
	return Input.get_axis("left", "right")

func update_facing_direction(direction: float) -> void:
	if knockback_timer > 0.0:
		return
	if direction > 0 and facing_direction != 1:
		facing_direction = 1
		visuals.scale.x = 1
	elif direction < 0 and facing_direction != -1:
		facing_direction = -1
		visuals.scale.x = -1

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func apply_knockback(attacker_position: Vector2) -> void:
	var dir_x: float = sign(global_position.x - attacker_position.x)
	if dir_x == 0.0:
		dir_x = -facing_direction
	velocity = Vector2(dir_x * knockback_force.x, knockback_force.y)
	knockback_timer = knockback_duration

func _on_hit_received(_amount: int, _damage_type: StringName, _is_melee: bool, attacker_position: Vector2) -> void:
	rage_component.add_rage(rage_component.gain_on_damage_taken)
	if not is_dead:
		apply_knockback(attacker_position)

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
	is_dead = true
	state_machine.force_transition("Dead")
