extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.hurtbox_component.set_deferred("monitorable", false)
	player.hurtbox_component.set_deferred("monitoring", false)
	player.melee_hitbox.deactivate()
	player.melee_visual.visible = false
	if player.rage_component.is_active:
		player.rage_component.deactivate()

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
