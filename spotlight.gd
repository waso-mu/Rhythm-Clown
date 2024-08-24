extends Node

var lastbeat
var bpm
var crotchet

var start_pos

@export var conductor: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = self.position
	bpm = conductor.bpm
	lastbeat = 0.0
	crotchet = 60.0 / bpm

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (conductor.songposition > lastbeat + crotchet*9):
		self.flip_h = not self.flip_h
		lastbeat += crotchet*8;
