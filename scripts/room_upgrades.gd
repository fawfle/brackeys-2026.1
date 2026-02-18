extends Node

@onready var room = get_parent()

# Depending on the button pressed, it calls one of these functions.
func upgrade_sanitation(): 
	print(room.sanitation)
	if room.sanitation == Room.Sanitation.CLEAN:
		print("Cannot Upgrade Further")
		print(room.sanitation)
		return
	else:
		room.sanitation -= 1
		print("Upgrade Successful")
		print(room.sanitation)
		
func upgrade_quality(): 
	print(room.quality)
	if room.quality == Room.Quality.CLASSY:
		print("Cannot Upgrade Further")
		print(room.quality)
		return
	else:
		room.quality -= 1
		print("Upgrade Successful")
		print(room.quality)
		
func upgrade_roomSize(): 
	print(room.room_size)
	if room.room_size == Room.RoomSize.LARGE:
		print("Cannot Upgrade Further")
		print(room.room_size)
		return
	else:
		room.room_size -= 1
		print("Upgrade Successful")
		print(room.room_size)

# when the button is pressed, it calls one of the functions above
func _on_button_pressed() -> void:
	upgrade_sanitation()


func _on_button_2_pressed() -> void:
	upgrade_quality()


func _on_button_3_pressed() -> void:
	upgrade_roomSize()


func _on_button_4_pressed() -> void:
	$".".visible = false
