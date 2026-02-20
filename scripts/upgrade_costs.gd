class_name UpgradeCosts

# ALL upgrade costs are framed in terms of current state. This is to make accessing them easier.
# ex cost to upgrade from DIRTY to MESSY is SANITATION[Room.Sanitation.Dirty]

const BUILD_ROOM: int = 25

## Quality upgrade costs. Takes current room prop
const QUALITY: Dictionary[Room.Quality, int] = {
	Room.Quality.DUMP: 20,
	Room.Quality.NORMAL: 100,
}
const ROOM_SIZE: Dictionary[Room.RoomSize, int] = {
	Room.RoomSize.SMALL: 25,
	Room.RoomSize.MEDIUM: 100,
}

## cost to upgrade number of floors
const FLOOR: Dictionary[int, int] = {
	1: 100,
	2: 200,
	3: 300,
	4: 400,
}
