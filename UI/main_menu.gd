class_name MainMenu
extends Control

@export_file("*.tscn") var first_level_scene: String
@export var normal_color: Color = Color(0.75, 0.75, 0.75)
@export var selected_color: Color = Color(1.0, 0.85, 0.2)
@export var cursor_offset: Vector2 = Vector2(-12, 4)

@onready var menu_container: VBoxContainer = $MenuContainer
@onready var start_button: Button = $MenuContainer/StartButton
@onready var quit_button: Button = $MenuContainer/QuitButton
@onready var cursor: Control = $Cursor

var buttons: Array[Button] = []
var current_index: int = 0

func _ready() -> void:
	for child in menu_container.get_children():
		if child is Button:
			buttons.append(child)
			var idx := buttons.size() - 1
			child.mouse_entered.connect(_on_button_hovered.bind(idx))
			child.focus_entered.connect(_on_button_hovered.bind(idx))
			
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	await get_tree().process_frame
	_select_button(0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		_select_button((current_index + 1) % buttons.size())
	elif event.is_action_pressed("ui_up"):
		_select_button((current_index - 1 + buttons.size()) % buttons.size())
	elif event.is_action_pressed("ui_accept"):
		if buttons.size() > 0:
			buttons[current_index].pressed.emit()

func _select_button(index: int) -> void:
	current_index = index
	for i in range(buttons.size()):
		var btn := buttons[i]
		if i == current_index:
			btn.add_theme_color_override("font_color", selected_color)
			btn.add_theme_color_override("font_focus_color", selected_color)
			btn.add_theme_color_override("font_hover_color", selected_color)
			btn.grab_focus()
			cursor.global_position = btn.global_position + cursor_offset
		else:
			btn.add_theme_color_override("font_color", normal_color)
			btn.add_theme_color_override("font_focus_color", normal_color)
			btn.add_theme_color_override("font_hover_color", normal_color)

func _on_button_hovered(index: int) -> void:
	_select_button(index)

func _on_start_pressed() -> void:
	if first_level_scene != "":
		get_tree().change_scene_to_file(first_level_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()
