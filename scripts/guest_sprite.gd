class_name GuestSprite extends Sprite2D

@onready var angry_sprite: Sprite2D = $AngrySprite

func _ready() -> void:
	angry_sprite.visible = false

func play_angry_animation():
	var duration: float = 0.6
	
	angry_sprite.visible = true
	
	if not is_inside_tree(): return
	await get_tree().create_timer(duration).timeout
	
	angry_sprite.visible = false
