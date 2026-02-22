@tool
class_name PerkButton extends Control

@onready var left_upgrade: UpgradeButton = $RightPerk
@onready var right_upgrade: UpgradeButton = $LeftPerk

@onready var cost_label: Label = $LeftPerk/PerkCost

signal button_clicked(upgrade_button: UpgradeButton, perk_index: int)

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
	button_clicked.emit(left_upgrade, 0)

func _on_left_perk_pressed() -> void:
	button_clicked.emit(right_upgrade, 1)

func update_textures(perk_tier: int):
	left_texture = Room.PERK_SPRITES[Room.PERK_TIER[perk_tier][0]]
	right_texture = Room.PERK_SPRITES[Room.PERK_TIER[perk_tier][1]]
