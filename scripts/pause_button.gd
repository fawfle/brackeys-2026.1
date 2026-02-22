extends TextureButton

@export var pause_menu: Control

func _ready() -> void:
	pressed.connect(_on_press)

func _on_press() -> void:
	get_tree().paused = not get_tree().paused
	pause_menu.visible = get_tree().paused
