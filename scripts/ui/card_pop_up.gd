extends Control

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.gui_input.connect(_on_color_rect_gui_input)

func _on_color_rect_gui_input(input: InputEvent) -> void:
	if input.is_action_pressed("left_mouse"):
		hide()
