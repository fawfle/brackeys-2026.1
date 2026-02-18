class_name FloatingText extends Label

func play_animation(new_text: String, duration: float = 1):
	text = new_text
	
	get_tree().create_tween().tween_property(self, "global_position", global_position + Vector2(0, -10), duration)
	
	await get_tree().create_timer(duration - 0.1).timeout
	
	var end_color = modulate
	end_color.a = 0
	get_tree().create_tween().tween_property(self, "modulate", end_color, 0.1)
	
	await get_tree().create_timer(0.1).timeout
	
	queue_free()
