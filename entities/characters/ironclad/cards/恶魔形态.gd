extends Card

func apply_effects(context: Context) -> void:
	var numeric_entries: Array[NumericEntry] = _get_numeric_entries()
	var apply_buff_effect := ApplyBuffEffect.new()
	apply_buff_effect.execute(ApplyBuffContext.new(context.source, \
	[context.source], numeric_entries[0].base_value, StrengthBuff.new()))
	apply_buff_effect.sound = sound
	apply_buff_effect.execute(ApplyBuffContext.new(context.source,\
	[context.source], numeric_entries[1].base_value, DemonFormBuff.new()))
