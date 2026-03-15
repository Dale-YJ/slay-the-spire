class_name CardUI
extends Control

@export var card: Card

@onready var state_label: Label = $Debug/StateLabel
@onready var drop_point_area: Area2D = $DropPointArea
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var visuals: Control = $Visuals

var disabled: bool = false
var playable: bool = true

var targets: Array[Node]

var original_index: int = -1
var original_position: Vector2
var original_rotation: float

var parent : Control

# 在dragging/aiming下，卡牌会脱离handmanger
@warning_ignore("unused_signal")
signal reparent_requested(card_ui: CardUI)

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_aim_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aiming_ended)
	card_state_machine.init()

func play() -> void:
	pass

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _on_card_drag_or_aiming_started(card_ui: CardUI) -> void:
		if card_ui == self:
			return
		disabled = true
func _on_card_drag_or_aiming_ended(card_ui: CardUI) -> void:
	disabled = false
	# set_playable


func _on_drop_point_area_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_area_area_exited(area: Area2D) -> void:
	targets.erase(area)
