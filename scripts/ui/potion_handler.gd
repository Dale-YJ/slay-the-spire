class_name PotionHandler
extends MarginContainer

@export var max_potion_slot := 3
@onready var potion_place_holder: HBoxContainer = $MarginContainer/PotionPlaceHolder
const POTION_UI = preload("res://scenes/ui/top_bar/potion_ui.tscn")

var potions: Array[Potion] = []
var potion_count = 0

func _ready() -> void:
	Events.combat_start.connect(_on_combat_started)
	Events.combat_won.connect(_on_combat_ended)
	potions = [preload("uid://cmilch2jb6xgn"), preload("uid://btvj32p8ixefr"), preload("uid://6tqk3prnw8wl")]
	update_potion_slot()

func update_potion_slot() -> void:
	for child in potion_place_holder.get_children():
		child.queue_free()
	for i in range(max_potion_slot):
		var potion_ui = POTION_UI.instantiate() as PotionUI
		potion_ui.potion_used.connect(_on_potion_used)
		potion_place_holder.add_child(potion_ui)
	await get_tree().process_frame
	set_potions()
		
func set_potions() -> void:
	for i in range(max_potion_slot):
		potion_place_holder.get_child(i).set_potion(null)
	for i in range(len(potions)):
		potion_place_holder.get_child(i).set_potion(potions[i])

func add_potion(potion: Potion) -> bool:
	if potion_count >= max_potion_slot:
		return false
	else:
		for i in range(max_potion_slot):
			if potions[i] == null:
				potions[i] = potion
				potion_place_holder.get_child(i).set_potion(potion)
				return true
	printerr("potion_handler:add_potion")
	return false

func get_potions():
	return potions

func _on_potion_used(potion_ui: PotionUI) -> void:
	for child: PotionUI in potion_place_holder.get_children():
		if potion_ui == child:
			child.set_potion(null)
			potions[child.get_index()] = null
			return
	printerr("potion_handler:_on_potion_used")	
		
func _on_combat_started() -> void:
	for child: PotionUI in potion_place_holder.get_children():
		child.in_combat = true

func _on_combat_ended() -> void:
	for child: PotionUI in potion_place_holder.get_children():
		child.in_combat = false
