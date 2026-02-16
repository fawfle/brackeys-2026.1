extends Control

var line_queue: Array[String] = []

@onready var text_box: Label = $TextBox
@onready var advance_text_button: TextureButton = $AdvanceText

func _ready() -> void:
	Globals.set_text.connect(on_set_text)

func load_line_from_queue():
	if line_queue.size() == 0:
		text_box.text = ""
		return
	
	text_box.text = line_queue.pop_front()

func on_set_text(lines: Array[String]) -> void:
	line_queue = lines
	load_line_from_queue()

func _on_advance_text_button_down() -> void:
	load_line_from_queue()
