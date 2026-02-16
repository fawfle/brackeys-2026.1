extends Label

var line_queue: Array[String] = []

func _ready() -> void:
	Globals.set_text.connect(on_set_text)

func load_line_from_queue():
	if line_queue.size() == 0: return
	
	text = line_queue.pop_front()

func on_set_text(lines: Array[String]) -> void:
	line_queue = lines
	load_line_from_queue()
