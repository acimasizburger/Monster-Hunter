class_name ThwompEnemy
extends Enemy

@export_group("Thwomp Stats")
@export var fall_gravity: float = 1400.0
@export var max_fall_speed: float = 420.0
@export var return_speed: float = 65.0
@export var telegraph_time: float = 0.22
@export var ground_wait_time: float = 1.1

@onready var trigger_area: Area2D = $TriggerArea
@onready var smash_hitbox: HitboxComponent = $Visuals/SmashHitbox
@onready var contact_hitbox: HitboxComponent = $Visuals/ContactHitbox

var start_position: Vector2
var player_in_trigger: bool = false

func _ready() -> void:
	is_flying = true
	can_be_knocked_back = false
	start_position = global_position
	trigger_area.body_entered.connect(_on_trigger_body_entered)
	trigger_area.body_exited.connect(_on_trigger_body_exited)
	super._ready()
	contact_hitbox.activate()
	smash_hitbox.deactivate()

func _on_trigger_body_entered(body: Node2D) -> void:
	if body is Player and not body.is_dead:
		player_in_trigger = true

func _on_trigger_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_trigger = false
