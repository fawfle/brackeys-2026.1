## this is a class for global variables and signals
extends Node

## if in debug mode, for conditional logging
var DEBUG: bool = true

## signals phase changes
signal phase_changed(phase: GameManager.Phase)

## used to signal textbox to display a mesage. Message is given as an array and clicking through will cycle until final message.
@warning_ignore("unused_signal")
signal set_text(lines: Array[String])
## emited when text has been cycled through to end of queue
@warning_ignore("unused_signal")
signal text_finished()

## used to signal money updated
@warning_ignore("unused_signal")
signal set_money(money: int)

@warning_ignore("unused_signal")
## used by rooms to signal a click.
signal select_room(room: Room)

## used by rooms to signal a hover.
@warning_ignore("unused_signal")
signal hover_room(room: Room)

@warning_ignore(("unused_signal"))
signal begin_day(day: int)
