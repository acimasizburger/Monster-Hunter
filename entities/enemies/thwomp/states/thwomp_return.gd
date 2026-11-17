extends EnemyState

var thwomp: ThwompEnemy:
	get:
		return entity as ThwompEnemy

func enter(_msg := {}) -> void:
	thwomp.velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	var to_start := thwomp.start_position - thwomp.global_position
	if to_start.length() <= thwomp.return_speed * delta:
		thwomp.global_position = thwomp.start_position
		thwomp.velocity = Vector2.ZERO
		transitioned.emit("Idle")
		return
		
	thwomp.velocity = to_start.normalized() * thwomp.return_speed
	thwomp.move_and_slide()
