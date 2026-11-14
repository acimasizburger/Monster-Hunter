extends PlayerState

@export var attack_duration: float = 0.22

var timer: float = 0.0

func enter(_msg := {}) -> void:
	timer = attack_duration
	player.melee_hitbox.activate()
	player.melee_visual.visible = true

func exit() -> void:
	player.melee_hitbox.deactivate()
	player.melee_visual.visible = false

func physics_update(delta: float) -> void:
	var direction := player.get_input_direction()
	player.velocity.x = direction * player.move_speed
	
	player.apply_gravity(delta)
	player.move_and_slide()
	
	timer -= delta
	if timer <= 0:
		if not player.is_on_floor():
			transitioned.emit("Air")
		elif direction != 0:
			transitioned.emit("Run")
		else:
			transitioned.emit("Idle")
