extends EnemyState

@export var attack_range: float = 36.0

func physics_update(delta: float) -> void:
	if not enemy.target_player:
		if enemy.state_machine.has_state("Patrol"):
			transitioned.emit("Patrol")
		elif enemy.state_machine.has_state("Idle"):
			transitioned.emit("Idle")
		return

	var to_player: Vector2 = enemy.target_player.global_position - enemy.global_position
	enemy.update_facing_direction(to_player.x)

	if enemy.state_machine.has_state("Attack") and to_player.length() <= attack_range:
		transitioned.emit("Attack")
		return

	if enemy.is_flying:
		enemy.velocity = to_player.normalized() * enemy.chase_speed
	else:
		enemy.apply_gravity(delta)
		if enemy.can_walk_forward():
			enemy.velocity.x = sign(to_player.x) * enemy.chase_speed
		else:
			enemy.velocity.x = 0

	enemy.move_and_slide()
