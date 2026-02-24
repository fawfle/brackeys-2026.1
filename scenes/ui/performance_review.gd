class_name PerformanceReview extends ColorRect

@onready var stats: Label = $Stats
@onready var star_progress_bar: TextureProgressBar = $StarProgressBar

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if not visible: return
	
	star_progress_bar.create_tween().tween_property(star_progress_bar, "value", Globals.average_rating, 2.0).from(0)
	stats.text = "Total Profit: " + str(Globals.total_profit) + "\nTotal Guests: " + str(Globals.total_guests)

func _on_button_button_down() -> void:
	visible = false
