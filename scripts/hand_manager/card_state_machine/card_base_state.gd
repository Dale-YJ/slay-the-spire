extends CardState

var original_visual_position: Vector2

## TODO: tween动画有点混乱

func enter_state() -> void:
	card_ui.state_label.text = "BASE"
	card_ui.reparent_requested.emit(card_ui)
	var tween:= create_tween()
	tween.tween_property(card_ui.visuals, "scale", Vector2.ONE, 0.2)
	# 在clicked z_index会设为1以在其他卡上方展示
	card_ui.z_index = 0
	original_visual_position = card_ui.visuals.position

func on_gui_input(event: InputEvent) -> void:
	if card_ui.disabled or not card_ui.playable:
		return
	if event.is_action_pressed("left_mouse"):
		card_state_machine_change_state_requested.emit(self, STATE.CLICKED)
		

func exit_state() -> void:
	var tween := create_tween()
	tween.tween_property(card_ui.visuals, "position:y", original_visual_position.y, 1.0).set_trans(Tween.TRANS_SINE)
	Events.card_previewed.emit(card_ui, false)
	
func on_mouse_entered() -> void:
	if card_ui.disabled:
		return
	Events.card_previewed.emit(card_ui, true)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	# 只移动显示部分，防止鼠标移到卡牌下方时直接触发mouse_exit
	# visuals的初始position为(150, 211)
	tween.tween_property(card_ui.visuals, "position:y", original_visual_position.y - 150, 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(card_ui.visuals, "scale", Vector2(1.3, 1.3), 0.2)
	tween.tween_property(card_ui, "rotation_degrees", 0, 0.2).set_trans(Tween.TRANS_SINE)

func on_mouse_exited() -> void:
	if card_ui.disabled:
		return
	Events.card_previewed.emit(card_ui, false)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(card_ui.visuals, "position:y", original_visual_position.y, 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(card_ui.visuals, "scale", Vector2.ONE, 0.2)
	tween.tween_property(card_ui, "rotation_degrees", card_ui.original_rotation, 0.2).set_trans(Tween.TRANS_SINE)
