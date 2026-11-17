extends EnemyState

var thwomp: ThwompEnemy:
	get:
		return entity as ThwompEnemy

var is_telegraphing: bool = false
var timer: float = 0.0

func enter(_msg := {}) -> void:
	is_telegraphing = false
	timer = 0.0
	thwomp.velocity = Vector2.ZERO
	thwomp.visuals.position = Vector2.ZERO
	thwomp.smash_hitbox.deactivate()

func physics_update(delta: float) -> void:
	if not is_telegraphing:
		if thwomp.player_in_trigger:
			is_telegraphing = true
			timer = thwomp.telegraph_time
		return

	timer -= delta
	thwomp.visuals.position.x = randf_range(-1.5, 1.5)
	if timer <= 0.0:
		thwomp.visuals.position = Vector2.ZERO
		transitioned.emit("Fall")
