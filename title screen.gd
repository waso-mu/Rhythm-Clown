extends Control

func loadMain():
	# This is like autoloading the scene, only
	# it happens after already loading the main scene.
	var simultaneous_scene = preload("res://the main event.tscn").instantiate()
	get_tree().root.add_child(simultaneous_scene)
	get_tree().root.get_node("TitleScreen").hide()

func showTut():
	$Help.show()

func hideTut():
	$Help.hide()

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainEvent.pressed.connect(self.loadMain)
	$Tutorial.pressed.connect(self.showTut)
	$Help/Close.pressed.connect(self.hideTut)
