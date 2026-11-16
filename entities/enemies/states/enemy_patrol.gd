extends EnemyState

@export var patrol_turn_time: float = 2.0

var turn_timer: float = 0.0

func enter(_msg := {}) -> void:
	turn_timer = patrol_turn_time

func physics_update(delta: float) -> void:
	if enemy.target_player:
		if enemy.state_machine.has_state("Shoot"):
			transitioned.emit("Shoot")
			return
		elif enemy.state_machine.has_state("Chase"):
			transitioned.emit("Chase")
			return

	if enemy.is_flying:
		turn_timer -= delta
		if turn_timer <= 0:
			turn_timer = patrol_turn_time
			enemy.update_facing_direction(-enemy.facing_direction)
		enemy.velocity.y = 0
	else:
		enemy.apply_gravity(delta)
		if enemy.is_on_wall() or not enemy.can_walk_forward():
			enemy.update_facing_direction(-enemy.facing_direction)

	enemy.velocity.x = enemy.facing_direction * enemy.move_speed
	enemy.move_and_slide()
