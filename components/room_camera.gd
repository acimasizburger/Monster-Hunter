class_name RoomCamera
extends Camera2D

@export var transition_duration: float = 0.45
@export var follow_speed: float = 12.0

var target: Node2D
var current_room_limits: Rect2i
var is_transitioning: bool = false

func _ready() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	position_smoothing_enabled = false

func _physics_process(delta: float) -> void:
	if not target or is_transitioning:
		return
		
	var view_size := Vector2(320, 180)
	var half_view := view_size * 0.5
	
	var target_pos := target.global_position
	var min_x := float(current_room_limits.position.x) + half_view.x
	var max_x := float(current_room_limits.end.x) - half_view.x
	var min_y := float(current_room_limits.position.y) + half_view.y
	var max_y := float(current_room_limits.end.y) - half_view.y
	
	if min_x > max_x:
		target_pos.x = float(current_room_limits.position.x + current_room_limits.end.x) * 0.5
	else:
		target_pos.x = clamp(target_pos.x, min_x, max_x)
		
	if min_y > max_y:
		target_pos.y = float(current_room_limits.position.y + current_room_limits.end.y) * 0.5
	else:
		target_pos.y = clamp(target_pos.y, min_y, max_y)
		
	global_position = global_position.lerp(target_pos, follow_speed * delta).round()

func change_room(new_limits: Rect2i, player_node: Node2D) -> void:
	target = player_node
	if current_room_limits == new_limits:
		return
		
	var is_first_room := current_room_limits.size == Vector2i.ZERO
	current_room_limits = new_limits
	
	var view_size := Vector2(320, 180)
	var half_view := view_size * 0.5
	var dest := target.global_position
	
	var min_x := float(new_limits.position.x) + half_view.x
	var max_x := float(new_limits.end.x) - half_view.x
	var min_y := float(new_limits.position.y) + half_view.y
	var max_y := float(new_limits.end.y) - half_view.y
	
	dest.x = (float(new_limits.position.x + new_limits.end.x) * 0.5) if min_x > max_x else clamp(dest.x, min_x, max_x)
	dest.y = (float(new_limits.position.y + new_limits.end.y) * 0.5) if min_y > max_y else clamp(dest.y, min_y, max_y)
	dest = dest.round()
	
	if is_first_room:
		global_position = dest
		return
		
	is_transitioning = true
	get_tree().paused = true
	
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", dest, transition_duration)
	await tween.finished
	
	global_position = dest
	get_tree().paused = false
	is_transitioning = false
