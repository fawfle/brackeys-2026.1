class_name BlockManageWindow extends ColorRect

## text to display when UI is active
@onready var blocked_text: Label = $BlockedText

func _ready() -> void:
	Globals.select_room.connect(update_visibility)
	Globals.current_guest_changed.connect(func(_guest: Guest): update_visibility(Hotel.inst.selected_room))

func update_visibility(room: Room):
	visible = room != null and room.guest != null
	blocked_text.text = "room occupied"
