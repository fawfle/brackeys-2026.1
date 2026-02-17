extends Control

var line_queue: Array[String] = []

@onready var text_box: Label = $TextBox
@onready var advance_text_button: TextureButton = $AdvanceText

var text_tween: Tween

func _ready() -> void:
	Globals.set_text.connect(on_set_text)
	text_box.text = ""

func load_line_from_queue():
	if line_queue.size() == 0:
		Globals.text_finished.emit()
		return
	
	text_box.visible_ratio = 0
	var line: String = line_queue.pop_front()
	text_box.text = line
	
	text_tween = get_tree().create_tween()
	text_tween.tween_property(text_box, "visible_ratio", 1, line.length() * 0.02)

func on_set_text(lines: Array[String] = [""]) -> void:
	line_queue = lines
	load_line_from_queue()

func _on_advance_text_button_down() -> void:
	if text_tween != null and text_tween.is_running():
		text_tween.kill()
		text_box.visible_ratio = 1
		return
	
	load_line_from_queue()
