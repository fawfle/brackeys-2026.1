extends Control

var line_queue: Array[String] = []

@onready var text_box: RichTextLabel = $TextBox
@onready var advance_text_button: TextureButton = $AdvanceText
@onready var completed_icon: TextureRect = $CompletedIcon

@onready var text_sound: AudioStreamPlayer2D = $TextSound

var text_tween: Tween

var initial_volume_linear: float = 0
var text_sound_tween: Tween

func _ready() -> void:
	Globals.set_text.connect(on_set_text)
	text_box.text = ""
	completed_icon.visible = false
	
	initial_volume_linear = text_sound.volume_linear

func load_line_from_queue():
	completed_icon.visible = false
	if line_queue.size() == 0:
		Globals.text_finished.emit()
		return
	
	text_box.visible_ratio = 0
	var line: String = line_queue.pop_front()
	text_box.text = line
	
	# if line is empty, skip
	if line == "":
		load_line_from_queue()
		return
	
	if text_tween: text_tween.kill()
	
	text_tween = get_tree().create_tween()
	text_tween.tween_property(text_box, "visible_ratio", 1, line.length() * 0.02)
	
	if text_sound_tween: text_sound_tween.kill()
	text_sound.play(randf() * text_sound.stream.get_length())
	text_sound.volume_linear = initial_volume_linear
	
	await text_tween.finished
	
	completed_icon.visible = true
	
	Globals.text_displayed.emit()
	if line_queue.size() == 0: Globals.text_final_line_displayed.emit()
	
	# extra stuff for sound
	text_sound_tween = text_sound.create_tween()
	text_sound_tween.tween_property(text_sound, "volume_linear", 0, 0.8).from(initial_volume_linear)

func on_set_text(lines: Array[String] = [""]) -> void:
	line_queue = lines
	if line_queue.size() == 0: line_queue = [""] # strat to get "consistent behavior" on empty lines
	load_line_from_queue()

func _on_advance_text_button_down() -> void:
	if text_tween != null and text_tween.is_running():
		text_tween.stop()
		text_tween.finished.emit()
		text_box.visible_ratio = 1
		return
	
	load_line_from_queue()

func _input(event: InputEvent) -> void:
	if event is not InputEventKey: return;
	event = event as InputEventKey;
	if event.is_pressed() and event.keycode == Key.KEY_SPACE:
		_on_advance_text_button_down()
