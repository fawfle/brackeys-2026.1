class_name RoomUpgradeMenu extends Control

@onready var manage_menu: Control = $Manage
@onready var build_menu: Control = $Build

@onready var quality_button: UpgradeButton = $Manage/QualityButton
@onready var size_button: UpgradeButton = $Manage/SizeButton
@onready var perk_button: PerkButton = $Manage/PerkButton

@onready var build_button: UpgradeButton = $Build/BuildButton


func _ready() -> void:
	Globals.select_room.connect(update_menu)
	Globals.room_updated.connect(func(r: Room): if Hotel.inst.selected_room == r: update_menu(r))
	
	perk_button.button_clicked.connect(_on_perk_button_pressed)
	
	build_menu.visible = false
	manage_menu.visible = false

func update_menu(room: Room) -> void:
	if room == null:
		visible = false
		return
	
	visible = true
	
	build_menu.visible = not room.built
	manage_menu.visible = room.built
	
	update_button_costs(room)

func update_button_costs(room: Room):
	if room == null: return
	quality_button.cost = UpgradeCosts.QUALITY.get(room.quality)
	size_button.cost = UpgradeCosts.ROOM_SIZE.get(room.room_size)
	build_button.cost = UpgradeCosts.BUILD_ROOM.get(room.hotel_floor)
	perk_button.cost = UpgradeCosts.ROOM_PERKS.get(room.perk_tier)
	perk_button.update_textures(room.perk_tier)
	

func _on_quality_pressed() -> void:
	if Hotel.inst.selected_room == null or Hotel.inst.selected_room.quality == Room.Quality.CLASSY or Hotel.inst.selected_room.occupied: return
	if GameManager.inst.purchase_upgrade(UpgradeCosts.QUALITY[Hotel.inst.selected_room.quality]):
		Hotel.inst.selected_room.upgrade_quality()
		update_button_costs(Hotel.inst.selected_room)


func _on_size_pressed() -> void:
	if Hotel.inst.selected_room == null or Hotel.inst.selected_room.room_size == Room.RoomSize.LARGE or Hotel.inst.selected_room.occupied: return
	if GameManager.inst.purchase_upgrade(UpgradeCosts.ROOM_SIZE[Hotel.inst.selected_room.room_size]):
		Hotel.inst.selected_room.upgrade_room_size()
		update_button_costs(Hotel.inst.selected_room)

func _on_build_pressed() -> void:
	if Hotel.inst.selected_room == null or Hotel.inst.selected_room.built or Hotel.inst.selected_room.occupied: return
	if GameManager.inst.purchase_upgrade(UpgradeCosts.BUILD_ROOM[Hotel.inst.selected_room.hotel_floor]):
		Hotel.inst.selected_room.build()
		update_button_costs(Hotel.inst.selected_room)

func _on_perk_button_pressed(_button: UpgradeButton, perk_index):
	if Hotel.inst.selected_room == null or Hotel.inst.selected_room.perk_tier >= 3 or Hotel.inst.selected_room.occupied: return
	if GameManager.inst.purchase_upgrade(UpgradeCosts.ROOM_PERKS[Hotel.inst.selected_room.perk_tier]):
		Hotel.inst.selected_room.add_perk(Room.PERK_TIER[Hotel.inst.selected_room.perk_tier][perk_index])
		update_button_costs(Hotel.inst.selected_room)
		
		var description: String = ""
		if Hotel.inst.selected_room.perk_tier <= 2: description = Room.PERK_DESCRIPTIONS.get(Room.PERK_TIER[Hotel.inst.selected_room.perk_tier][perk_index])
		Globals.update_upgrade_text.emit(description)
