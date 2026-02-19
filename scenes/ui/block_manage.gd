class_name BlockManageWindow extends ColorRect

## text to display when UI is active
@onready var blocked_text: Label = $BlockedText

func _ready() -> void:
	Globals.phase_changed.connect(_on_phase_changed)
	Globals.select_room.connect(update_visibility)

func update_visibility(room: Room):
	if GameManager.inst.phase != GameManager.Phase.UPGRADING: return
	visible = room != null and room.guest != null
	blocked_text.text = "room occupied"

func _on_phase_changed(phase: GameManager.Phase):
	if phase != GameManager.Phase.UPGRADING:
		visible = true
		blocked_text.text = "management locked"
		return
	
	update_visibility(Hotel.inst.selected_room)
