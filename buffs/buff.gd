class_name Buff
extends Node

# SPECIAL一般是无法解除的buff
enum Type {BUFF, DEBUFF, SPECIAL}
var type

@export var stacks: int = 1
var description: String
var buff_name: String

func add_stack(amount: int):
	stacks += amount
	
func remove_stack(amount: int):
	stacks -= amount
	if stacks <= 0:
		queue_free()
