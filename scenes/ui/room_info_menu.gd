class_name RoomInfoMenu extends Control

# @onready var guest_label: Label = $Guest
# @onready var quality_label: Label = $Quality
@onready var sanitation_bar: TextureProgressBar = $SanitationBar
@onready var size_label: Label = $Size

@onready var guest_texture_rect: TextureRect = $GuestTextureRect

@onready var perk_icons: Array[TextureRect] = [$Perk1, $Perk2, $Perk3]

const SANITATION_PROGRESS: Dictionary[Room.Sanitation, float] = {
	Room.Sanitation.CLEAN: 1,
	Room.Sanitation.MESSY: 0.5,
	Room.Sanitation.DIRTY: 0.1,
}

const SANITATION_COLORS: Dictionary[Room.Sanitation, Color] = {
	Room.Sanitation.CLEAN: Color("0dff00"),
	Room.Sanitation.MESSY: Color("ffaa21ff"),
	Room.Sanitation.DIRTY: Color("ff2121ff"),
}

func update_viewed_room(room: Room):
	# guest_label.text = "Guest: " + (room.guest.name if room.guest != null else "none")
	# quality_label.text = "Quality: " + Room.quality_string(room.quality)
	sanitation_bar.value = SANITATION_PROGRESS[room.sanitation]
	sanitation_bar.tint_progress = SANITATION_COLORS[room.sanitation]
	size_label.text = "Size: " + Room.room_size_string(room.room_size)
	
	guest_texture_rect.texture = room.guest.node.texture if room.guest != null else null
	
	if room == null: return
	
	for icon in perk_icons: icon.visible = false
	
	for i in range(room.perks.size()):
		perk_icons[i].texture = Room.PERK_SPRITES[room.perks[i]]
		perk_icons[i].visible = true
