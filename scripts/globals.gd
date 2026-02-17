## this is a class for global variables and signals
extends Node

## if in debug mode, for conditional logging
var DEBUG: bool = true

## used to signal textbox to display a mesage. Message is given as an array and clicking through will cycle until final message.
@warning_ignore("unused_signal")
signal set_text(lines: Array[String])
## emited when text has been cycled through to end of queue
@warning_ignore("unused_signal")
signal text_finished()

## used by rooms to signal a click.
@warning_ignore("unused_signal")
signal select_room(room: Room)
