extends PlayerState

func physics_update(delta: float) -> void:
	var direction := player.get_input_direction()
	player.update_facing_direction(direction)
	
	player.velocity.x = direction * player.move_speed
	player.apply_gravity(delta)
	player.move_and_slide()
	
	if Input.is_action_just_pressed("melee"):
		transitioned.emit("Melee")
		return
	
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= 0.5
	
	if player.is_on_floor():
		if direction == 0:
			transitioned.emit("Idle")
		else:
			transitioned.emit("Run")
