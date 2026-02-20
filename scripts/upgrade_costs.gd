class_name UpgradeCosts

# ALL upgrade costs are framed in terms of current state. This is to make accessing them easier.
# ex cost to upgrade from DIRTY to MESSY is SANITATION[Room.Sanitation.Dirty]

# cost of -1 represents end of upgrade path. More making code in other places simpler

## room build costs. Increase by floor
const BUILD_ROOM: Dictionary[int, int] = {
	0: 25,
	1: 40,
	2: 50,
	3: 100,
	4: 200,
	5: -1
}

## Quality upgrade costs. Takes current room prop
const QUALITY: Dictionary[Room.Quality, int] = {
	Room.Quality.DUMP: 20,
	Room.Quality.NORMAL: 100,
	Room.Quality.CLASSY: -1
}
const ROOM_SIZE: Dictionary[Room.RoomSize, int] = {
	Room.RoomSize.SMALL: 25,
	Room.RoomSize.MEDIUM: 100,
	Room.RoomSize.LARGE: -1
}

## cost to upgrade number of floors
const FLOOR: Dictionary[int, int] = {
	1: 100,
	2: 200,
	3: 300,
	4: 400,
	5: -1,
}
