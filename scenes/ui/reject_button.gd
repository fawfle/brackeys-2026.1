extends TextureButton

func _ready() -> void:
	Globals.current_guest_changed.connect(_on_current_guest_changed)
	Globals.managing_guest.connect(_on_manage_guest)
	
	pressed.connect(func(): disabled = true)


func _on_current_guest_changed(_guest: Guest):
	disabled  = true

func _on_manage_guest(guest: Guest):
	if guest == null:
		disabled = true
		return
	
	visible = true
	disabled = false
