# 记得删掉class_name
extends Card

func apply_effects(context: Context) -> void:
	var numeric_entries := _get_numeric_entries()
	var damage_effect := AttackEffect.new()
	damage_effect.sound = sound
	damage_effect.execute(DamageContext.new(context.source, context.targets, numeric_entries[0].base_value))
	var buff_effect := ApplyBuffEffect.new()
	buff_effect.execute(ApplyBuffContext.new(context.source, \
	context.targets, numeric_entries[1].base_value, VulnerableDebuff.new()))
