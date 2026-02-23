extends TextureButton

func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_button_down():
	Engine.time_scale = 10
	$AudioStreamPlayer2D.play()

func _on_button_up():
	Engine.time_scale = 1
	$AudioStreamPlayer2D.stop()
