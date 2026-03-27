# 记得删掉class_name
# !!一定记得把脚本附加到cardname.tres上
extends Card

func apply_effects(context: Context) -> void:
	var attack_effect := AttackEffect.new()
	attack_effect.sound = sound
	attack_effect.execute(DamageContext.new(context.source, context.targets, 3))
	var apply_buff_effect := ApplyBuffEffect.new()
	apply_buff_effect.execute(ApplyBuffContext.new(context.source, context.targets, 1, WeaknessDebuff.new()))
	
