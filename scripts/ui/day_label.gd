extends Label

func _ready() -> void:
	Globals.begin_day.connect(on_begin_day)

func on_begin_day(day: int) -> void:
	text = "Day " + str(day)
