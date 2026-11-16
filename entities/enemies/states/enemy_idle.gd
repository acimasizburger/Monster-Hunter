extends EnemyState

func enter(_msg := {}) -> void:
	enemy.velocity.x = 0

func physics_update(delta: float) -> void:
	if enemy.target_player:
		if enemy.state_machine.has_state("Shoot"):
			transitioned.emit("Shoot")
			return
		elif enemy.state_machine.has_state("Chase"):
			transitioned.emit("Chase")
			return

	enemy.apply_gravity(delta)
	enemy.move_and_slide()
