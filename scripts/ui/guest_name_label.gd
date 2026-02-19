class_name GuestNameLabel extends Label

func _ready() -> void:
	Globals.current_guest_changed.connect(_on_current_guest_changed)

func _on_current_guest_changed(guest: Guest) -> void:
	if guest == null:
		text = ""
		return
	
	text = guest.name
