extends PlayerState

func enter(_msg := {}) -> void:
	if player.knockback_timer <= 0.0:
		player.velocity.x = 0

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
	
	if not player.is_on_floor():
		transitioned.emit("Air")
		return
		
	if Input.is_action_just_pressed("melee"):
		transitioned.emit("Melee")
		return
		
	if Input.is_action_just_pressed("jump"):
		player.velocity.y = player.jump_velocity
		transitioned.emit("Air")
		return
		
	if player.get_input_direction() != 0:
		transitioned.emit("Run")
