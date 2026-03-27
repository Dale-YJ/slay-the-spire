extends Card

func apply_effects(context: Context) -> void:
	var block_effect := BlockEffect.new()
	block_effect.sound = sound
	block_effect.execute(GainBlockContext.new(context.source, context.targets, _get_numeric_entries()[0].base_value))
