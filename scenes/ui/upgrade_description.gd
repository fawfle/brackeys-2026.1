extends Control

@onready var label: Label = $Label

func _ready() -> void:
	Globals.update_upgrade_text.connect(set_text)
	
	visible = false

func set_text(text: String) -> void:
	if text == "":
		visible = false
		return
	
	visible = true
	label.text = text
