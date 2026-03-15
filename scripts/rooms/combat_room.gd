extends Control

@onready var hand_manager: HandManager = $CombatUI/HandManager
const CARD_UI = preload("uid://cunj3kh5og6dc")


func _on_add_card_pressed() -> void:
	var card_ui: CardUI= CARD_UI.instantiate()
	card_ui.reparent_requested.connect(hand_manager._on_card_ui_reparent_requested)
	hand_manager.add_child(card_ui)
	hand_manager.set_cards()


func _on_remove_card_pressed() -> void:
	var card_ui := hand_manager.get_child(hand_manager.get_child_count() - 1)
	card_ui.queue_free()
	await card_ui.tree_exited
	hand_manager.set_cards()
