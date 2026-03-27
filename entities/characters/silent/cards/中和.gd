# 记得删掉class_name
# !!一定记得把脚本附加到cardname.tres上
extends Card

func apply_effects(context: Context) -> void:
	var numeric_entries := _get_numeric_entries()
	var attack_effect := AttackEffect.new()
	attack_effect.sound = sound
	attack_effect.execute(DamageContext.new(context.source, context.targets, numeric_entries[0].base_value))
	var apply_buff_effect := ApplyBuffEffect.new()
	apply_buff_effect.execute(ApplyBuffContext.new(context.source, context.targets, numeric_entries[1].base_value, WeaknessDebuff.new()))
	
