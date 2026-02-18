class_name RoomInfoMenu extends Control

@onready var guest_label: Label = $Guest

func update_viewed_room(room: Room):
	guest_label.text = room.guest.name if room.guest != null else "none"
