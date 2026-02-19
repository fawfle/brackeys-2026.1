extends Button

func _ready() -> void:
	Globals.select_room.connect(update_disabled)
	Globals.phase_changed.connect(_on_phase_changed)
	
	pressed.connect(func(): disabled = true)

## hook for room selection for assigning guest
func update_disabled(room: Room):
	if GameManager.inst.phase == GameManager.Phase.ASSIGNING:
		disabled = room == null or room.guest != null

func _on_phase_changed(phase: GameManager.Phase):
	if phase != GameManager.Phase.ASSIGNING:
		visible = false
		disabled  = true
	else:
		visible = true
		update_disabled(Hotel.inst.selected_room)
