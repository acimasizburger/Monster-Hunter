extends EnemyState

var thwomp: ThwompEnemy:
	get:
		return entity as ThwompEnemy

var timer: float = 0.0

func enter(_msg := {}) -> void:
	timer = thwomp.ground_wait_time
	thwomp.velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		transitioned.emit("Return")
