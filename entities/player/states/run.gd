extends PlayerState

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("melee"):
		transitioned.emit("Melee")
		return

	if player.can_jump():
		player.execute_jump()
		transitioned.emit("Air")
		return

	var direction := player.get_input_direction()
	player.update_facing_direction(direction)
	
	if player.knockback_timer <= 0.0:
		player.velocity.x = direction * player.move_speed
		
	player.apply_gravity(delta)
	player.move_and_slide()
	
	if not player.is_on_floor():
		transitioned.emit("Air")
		return
		
	if direction == 0 and player.knockback_timer <= 0.0:
		transitioned.emit("Idle")
