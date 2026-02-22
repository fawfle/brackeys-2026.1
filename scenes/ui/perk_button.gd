@tool
class_name PerkButton extends Control

@onready var left_upgrade: UpgradeButton = $RightPerk
@onready var right_upgrade: UpgradeButton = $LeftPerk

@onready var cost_label: Label = $LeftPerk/PerkCost

signal button_clicked(upgrade_button: UpgradeButton)

const PERK_ICONS: Dictionary[int, Texture] = {
	0: preload("res://sprites/ui/air_conditioner_icon.png"),
	1: preload("res://sprites/ui/space_heater_icon.png"),
	2: preload("res://sprites/ui/air_conditioner_icon.png"),
	3: preload("res://sprites/ui/space_heater_icon.png"),
	4: preload("res://sprites/ui/air_conditioner_icon.png"),
	5: preload("res://sprites/ui/space_heater_icon.png"),
}

@export var left_texture: Texture:
	get: return left_texture
	set(value):
		left_texture = value
		left_upgrade.texture = left_texture

@export var right_texture: Texture:
	get: return right_texture
	set(value):
		right_texture = value
		right_upgrade.texture = right_texture

@export var left_description: String:
	get: return left_description
	set(value):
		left_description = value
		if left_upgrade: left_upgrade.description = left_description
		
@export var right_description: String:
	get: return right_description
	set(value):
		right_description = value
		if right_upgrade: right_upgrade.description = right_description

@export var cost: int = 0:
	get: return cost
	set(value):
		cost = value
		left_upgrade.cost = cost
		right_upgrade.cost = cost
		if Engine.is_editor_hint(): return
		if cost_label: cost_label.text = "$" + str(value) if cost >= 0 else "MAX"


func _on_right_perk_pressed() -> void:
	button_clicked.emit(left_upgrade)

func _on_left_perk_pressed() -> void:
	button_clicked.emit(right_upgrade)

func update_textures(perk_tier: int):
	left_texture = PERK_ICONS[perk_tier * 2]
	right_texture = PERK_ICONS[perk_tier * 2 + 1]
