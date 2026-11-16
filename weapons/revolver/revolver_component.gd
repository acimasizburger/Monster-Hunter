class_name RevolverComponent
extends Node

signal magazine_updated(magazine: Array[BulletData], max_capacity: int)
signal reload_started(duration: float)
signal reload_finished

@export var bullet_scene: PackedScene
@export var shell_scene: PackedScene
@export var default_bullet: BulletData
@export var max_capacity: int = 6
@export var reload_duration: float = 1.2
@export var fire_cooldown: float = 0.25

var magazine: Array[BulletData] = []
var is_reloading: bool = false
var cooldown_timer: float = 0.0

func _ready() -> void:
	_fill_default_ammo()

func _process(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta

func _fill_default_ammo() -> void:
	magazine.clear()
	for i in range(max_capacity):
		magazine.append(default_bullet)
	magazine_updated.emit(magazine, max_capacity)

func can_shoot() -> bool:
	return not is_reloading and cooldown_timer <= 0 and magazine.size() > 0

func shoot(spawn_position: Vector2, direction: int) -> bool:
	if not can_shoot():
		return false
		
	var current_bullet: BulletData = magazine.pop_front()
	
	var bullet_instance: Bullet = bullet_scene.instantiate()
	bullet_instance.global_position = spawn_position
	bullet_instance.setup(current_bullet, direction)
	get_tree().current_scene.add_child(bullet_instance)
	
	_eject_shell(spawn_position, direction)
	
	cooldown_timer = fire_cooldown
	magazine_updated.emit(magazine, max_capacity)
	
	if magazine.is_empty():
		start_reload()
		
	return true

func _eject_shell(spawn_position: Vector2, direction: int) -> void:
	if not shell_scene:
		return
	var shell: ShellCasing = shell_scene.instantiate()
	shell.global_position = spawn_position
	get_tree().current_scene.add_child(shell)
	shell.launch(direction)

func start_reload() -> void:
	if is_reloading:
		return
	is_reloading = true
	reload_started.emit(reload_duration)
	
	await get_tree().create_timer(reload_duration).timeout
	
	_fill_default_ammo()
	is_reloading = false
	reload_finished.emit()

func try_add_special_bullet(special_bullet: BulletData) -> bool:
	if is_reloading:
		return false
		
	if magazine.size() < max_capacity:
		magazine.push_front(special_bullet)
		magazine_updated.emit(magazine, max_capacity)
		return true
		
	for i in range(magazine.size()):
		if magazine[i] == default_bullet:
			magazine[i] = special_bullet
			magazine_updated.emit(magazine, max_capacity)
			return true
			
	return false
