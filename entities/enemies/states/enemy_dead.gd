extends EnemyState

func enter(_msg := {}) -> void:
	enemy.velocity = Vector2.ZERO
	enemy.hurtbox_component.set_deferred("monitorable", false)
	enemy.hurtbox_component.set_deferred("monitoring", false)
	enemy.queue_free()
