class_name WalkerEnemy
extends Enemy

@onready var floor_ray_cast: RayCast2D = $Visuals/FloorRayCast
@onready var contact_hitbox: HitboxComponent = $Visuals/ContactHitbox

func _ready() -> void:
	is_flying = false
	super._ready()
	contact_hitbox.activate()

func can_walk_forward() -> bool:
	return floor_ray_cast.is_colliding()
