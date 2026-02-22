extends Control

var line_queue: Array[String] = []

@onready var text_box: RichTextLabel = $TextBox
@onready var advance_text_button: TextureButton = $AdvanceText
@onready var completed_icon: Sprite2D = $Sprite2D

var text_tween: Tween

func _ready() -> void:
	Globals.set_text.connect(on_set_text)
	text_box.text = ""
	completed_icon.visible = false

func load_line_from_queue():
	completed_icon.visible = false
	if line_queue.size() == 0:
		Globals.text_finished.emit()
		return
	
	text_box.visible_ratio = 0
	var line: String = line_queue.pop_front()
	text_box.text = line
	
	# if line is empty, skip
	if line == "": load_line_from_queue()
	
	if text_tween != null and text_tween.is_valid(): text_tween.stop()
	
	text_tween = get_tree().create_tween()
	text_tween.tween_property(text_box, "visible_ratio", 1, line.length() * 0.02)
	
	await text_tween.finished
	
	completed_icon.visible = true
	
	Globals.text_displayed.emit()

func on_set_text(lines: Array[String] = [""]) -> void:
	line_queue = lines
	if line_queue.size() == 0: line_queue = [""] # strat to get "consistent behavior" on empty lines
	load_line_from_queue()

func _on_advance_text_button_down() -> void:
	if text_tween != null and text_tween.is_running():
		text_tween.kill()
		text_box.visible_ratio = 1
		return
	
	load_line_from_queue()
