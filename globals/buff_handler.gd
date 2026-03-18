extends Node

func add_buff(buff_context: ApplyBuffContext) -> void:
	var buff_node: Node
	buff_context.buff_node.stacks = buff_context.amount
	for target: Node2D in buff_context.targets:
		buff_node = buff_context.buff_node.duplicate()
		var exist_buff: Buff = null
		for child: Buff in target.get_children():
			# godot的typeof无法分辨自定义类
			if child.buff_name == buff_node.buff_name:
				exist_buff = child
				break
		if exist_buff:
			exist_buff.add_stack(buff_node.amount)
		else:
			target.add_child(buff_node)		


		
			
