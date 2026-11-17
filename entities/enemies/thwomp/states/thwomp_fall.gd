extends EnemyState

var thwomp: ThwompEnemy:
	get:
		return entity as ThwompEnemy

func enter(_msg := {}) -> void:
	thwomp.velocity = Vector2.ZERO
	thwomp.smash_hitbox.activate()

func exit() -> void:
	thwomp.smash_hitbox.deactivate()

func physics_update(delta: float) -> void:
	thwomp.velocity.y = min(thwomp.velocity.y + thwomp.fall_gravity * delta, thwomp.max_fall_speed)
	thwomp.move_and_slide()
	
	if thwomp.is_on_floor():
		transitioned.emit("Landed")
