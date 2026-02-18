class_name FloatingText extends Label

const FADE_OUT_TIME: float = 0.6

func play_animation(new_text: String, duration: float = 1):
	text = new_text
	
	get_tree().create_tween().tween_property(self, "global_position", global_position + Vector2(0, -20), duration)
	
	await get_tree().create_timer(duration - FADE_OUT_TIME).timeout
	
	var end_color: Color = modulate
	end_color.a = 0
	get_tree().create_tween().tween_property(self, "modulate", end_color, FADE_OUT_TIME)
	
	await get_tree().create_timer(FADE_OUT_TIME).timeout
	
	queue_free()
