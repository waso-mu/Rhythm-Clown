extends Node

@export var magnitude: float

var lastbeat
var bpm
var crotchet

var start_pos

@export var conductor: Node

func bop_up():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position", Vector2.UP*magnitude+start_pos, crotchet*0.75)

func bop_down():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2.DOWN*magnitude+start_pos, crotchet*0.25)
	tween.connect("finished", bop_up)


# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = self.position
	bpm = conductor.bpm
	lastbeat = 0.0
	crotchet = 60.0 / bpm

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (conductor.songposition > lastbeat + crotchet):
		bop_down();
		lastbeat += crotchet;
