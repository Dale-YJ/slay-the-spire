class_name HellRaiserBuff
extends Buff

var block: int

func _init() -> void:
	# 一定要在init中设置buff名
	# 在buff进树之前会判断buff_name
	var buff_info: Dictionary = BuffLibrary.buff_data["地狱狂徒"]
	buff_name = buff_info["name"]
	description = buff_info["description"]
	icon = buff_info["icon"]
	stackable = false
	type = Type.BUFF
	
func _ready() -> void:
	if agent and agent.has_signal("after_draw_card"):
		agent.connect("after_draw_card", _on_after_draw_card)


func _on_after_draw_card(context: DrawCardContext) -> void:
	var card = context.card
	if card and card.id.contains("打击"):
		var enemies: Array[Node] = agent.get_tree().get_nodes_in_group("ui_enemies")
		if card.get_target() == card.Target.SINGLE_ENEMY:
			enemies = [enemies[randi() % len(enemies)]]
		card.first_play_free = true
		card.play(agent, enemies)
		context.card = null
