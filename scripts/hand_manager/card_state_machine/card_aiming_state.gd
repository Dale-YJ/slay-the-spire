extends CardState

# 屏幕高1080
const MOUSE_Y_SNAPBACK_THRESHHOLD := 800

func enter_state() -> void:
	card_ui.state_label.text = "AMIMING"
	card_ui.drop_point_area.monitoring = false
	card_ui.targets.clear()
	Events.card_aim_started.emit(card_ui)

func exit_state() -> void:
	Events.card_aim_ended.emit(card_ui)

func on_input(_event: InputEvent) -> void:
	var mouse_motion := _event is InputEventMouseMotion
	var mouse_at_bottom := card_ui.get_global_mouse_position().y > MOUSE_Y_SNAPBACK_THRESHHOLD
	
	if (mouse_motion and mouse_at_bottom) or _event.is_action_pressed("right_mouse"):
		card_state_machine_change_state_requested.emit(self, STATE.BASE)
	elif _event.is_action_released("left_mouse") or _event.is_action_pressed("left_mouse"):
		get_viewport().set_input_as_handled()
		card_state_machine_change_state_requested.emit(self, STATE.RELEASED)
		
