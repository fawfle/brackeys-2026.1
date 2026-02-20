@tool
class_name UpgradeButton extends TextureButton


@onready var label: Label = $Label
@onready var cost_label: Label = $Cost

@export var label_text: String = "Name":
	get: return label_text
	set(value):
		label_text = value
		$Label.text = value
	
@export var cost: int = 0:
	get: return cost
	set(value):
		cost = value
		if Engine.is_editor_hint(): return
		cost_label.text = "$" + str(value)
		update_button(GameManager.inst.money)

const disabled_color: Color = Color("#ffffff22")

## description to display when hovering
@export var description: String = ""

func _ready() -> void:
	if Engine.is_editor_hint(): return
	Globals.set_money.connect(update_button)
	
	label.text = label_text

func update_button(money: int) -> void:
	if money < cost:
		modulate = disabled_color
		return
	
	modulate = Color("#ffffff")



func _on_mouse_entered() -> void:
	Globals.update_upgrade_text.emit(description)

func _on_mouse_exited() -> void:
	Globals.update_upgrade_text.emit("")
