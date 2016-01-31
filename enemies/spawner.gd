
extends Position2D

export(PackedScene) var what
export(float) var how_often = 0

onready var t = get_node("Timer")
onready var notifier = get_node("VisibilityNotifier2D")

func _ready():
	if (how_often > 0):
		t.set_wait_time(how_often)
		t.connect("timeout", self, "spawn")
		notifier.connect("enter_screen", t, "start")
		notifier.connect("exit_screen", t, "stop")

func spawn():
	var obj = what.instance()
	obj.set_pos(get_pos())
	get_tree().get_root().add_child(obj)
	