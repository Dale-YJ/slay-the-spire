class_name CombatResolver
extends Control

const CARD_INSPECT_UI = preload("res://scenes/ui/card_inspect_ui.tscn")

@onready var card_resolve_stack: HBoxContainer = $CardResolveStack

# 结算栈(不允许外部访问
var _stack: Array[ResolutionEntry] = []
var is_resolving: bool = false : set = _set_resolving

var previous_result = null
var current_entry: ResolutionEntry : set = _set_current_entry

func _ready() -> void:
	for child: CardInspectUI in card_resolve_stack.get_children():
		child.queue_free()

func put_card_ui_in_stack(card: Card) -> void:
	var card_inspect_ui: CardInspectUI = CARD_INSPECT_UI.instantiate()
	card_resolve_stack.add_child(card_inspect_ui)
	card_inspect_ui.card = card

func pop_card_ui_in_stack() -> void:
	if card_resolve_stack.get_child_count() != 0:
		card_resolve_stack.get_child(-1).queue_free()

# 将卡牌加入结算栈，（卡牌调用play时加入）
func push_card(card: Card, context: Dictionary):
	var entry = ResolutionEntry.new(card, context)
	
	_stack.append(entry)
	put_card_ui_in_stack(entry.card)
	
	if not is_resolving:
		_resolve()
		
# 不断从栈顶取出effect并执行	
func _resolve():
	is_resolving = true
	while _stack.size() > 0:
		current_entry = _stack[-1]
		# 卡牌所有效果完成后移出调用栈
		if current_entry.is_finished():
			current_entry.card.on_played(current_entry.context["player"], current_entry.context["targets"])
			
			_stack.pop_back()
			pop_card_ui_in_stack()
			
			_on_card_finished(current_entry)
			await get_tree().create_timer(0.5).timeout
			continue
		await _execute_effect(current_entry.get_current_effect(), current_entry.context)
		if _should_stop():
			_clear_stack()
			break
		else:
			# 稍微等待一段时间，防止效果执行太快
			#await get_tree().create_timer(0.1).timeout
			await get_tree().process_frame
		# 移动到下一个效果
		current_entry.effect_index += 1
	is_resolving = false
	
func _clear_stack() -> void:
	_stack.clear()	
	for child in card_resolve_stack.get_children():
		child.queue_free()
	card_resolve_stack.hide()

# 判断执行是否应该终止,如杀死所有敌人时
func _should_stop() -> bool:
	var all_enemies_dead = get_tree().get_nodes_in_group("ui_enemies").all(func(e: Enemy): return e.dead)
	var player_dead = (get_tree().get_first_node_in_group("ui_player") as Player).dead
	return all_enemies_dead or player_dead

func _execute_effect(effect: Effect, context: Dictionary) -> void:
	# 如果execute是同步函数会直接忽略await
	previous_result = await effect.execute(context.get("player"), context)
	
func _on_card_finished(entry: ResolutionEntry) -> void:
	previous_result = null
	Events.card_played.emit(entry.card)

func _set_current_entry(value: ResolutionEntry) -> void:
	current_entry = value
	if is_resolving:
		card_resolve_stack.show()

func _set_resolving(value: bool) -> void:
	is_resolving = value
	if not is_resolving:
		card_resolve_stack.hide()
