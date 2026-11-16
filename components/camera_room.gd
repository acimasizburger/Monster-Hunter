class_name CameraRoom
extends Area2D

@export var room_camera: RoomCamera

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and room_camera:
		var limits := _calculate_room_limits()
		room_camera.change_room(limits, body)

func _calculate_room_limits() -> Rect2i:
	var shape := collision_shape.shape as RectangleShape2D
	if not shape:
		return Rect2i(0, 0, 320, 180)
		
	var center := collision_shape.global_position
	var extents := shape.size * 0.5
	var top_left := Vector2i((center - extents).round())
	var size := Vector2i(shape.size.round())
	return Rect2i(top_left, size)
