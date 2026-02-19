class_name RoomInfoMenu extends Control

@onready var guest_label: Label = $Guest
@onready var quality_label: Label = $Quality
@onready var sanitation_label: Label = $Sanitation
@onready var size_label: Label = $Size

func update_viewed_room(room: Room):
	guest_label.text = "Guest: " + (room.guest.name if room.guest != null else "none")
	quality_label.text = "Quality: " + Room.quality_string(room.quality)
	sanitation_label.text = "Sanitation: " + Room.sanitation_string(room.sanitation)
	size_label.text = "Size: " + Room.room_size_string(room.room_size)
