class_name FlyerEnemy
extends Enemy

@onready var contact_hitbox: HitboxComponent = $Visuals/ContactHitbox

func _ready() -> void:
	is_flying = true
	super._ready()
	contact_hitbox.activate()

func can_walk_forward() -> bool:
	return true
