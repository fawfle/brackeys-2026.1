## this is a class for global variables and signals
extends Node

## if in debug mode, for conditional logging
var DEBUG: bool = true

## used to signal textbox to display a mesage. Message is given as an array and clicking through will cycle until final message.
signal set_text(lines: Array[String])
