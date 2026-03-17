# meta-name: 卡牌逻辑
# meta-description: 卡牌逻辑脚本的模板

class_name MyCard
extends Card

func apply_effects(targets) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 6
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
