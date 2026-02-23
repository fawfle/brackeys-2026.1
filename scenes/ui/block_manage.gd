class_name BlockManageWindow extends ColorRect

## text to display when UI is active
@onready var blocked_text: Label = $BlockedText

func _ready() -> void:
	Globals.select_room.connect(update_visibility)
	Globals.current_guest_changed.connect(func(_guest: Guest): update_visibility(Hotel.inst.selected_room))
	Globals.room_updated.connect(func(_room: Room): update_visibility(Hotel.inst.selected_room))

func update_visibility(room: Room):
	visible = room != null and (room.guest != null or room.upgrading or room.guest_flag) 
	if not visible: return
	if room.guest != null or room.guest_flag: blocked_text.text = "room occupied"
	elif room.upgrading: blocked_text.text = "room upgrading"
