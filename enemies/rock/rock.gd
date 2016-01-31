
extends Area2D

var speed = 0

var exceptions = []
var t

func _ready():
	connect("body_enter", self, "on_body_enter")
	set_fixed_process(true)
	get_node("VisibilityNotifier2D").connect("exit_screen", self, "queue_free")
	

func _fixed_process(delta):
	speed += CONST.gravity*delta
	set_pos(get_pos()+Vector2(0,speed*delta))

func on_body_enter(body):
	if (body in exceptions):
		return
	speed = -60
	if ("player" in body.get_groups()):
		body.take_damage()
	exceptions.append(body)
	var anim  = get_node("anim")
	anim.set_speed(-0.5 * sign(anim.get_speed()))
	if t == null:
		t = Timer.new()
		t.set_wait_time(0.5)
		t.set_one_shot(true)
	t.start()
	yield(t,"timeout")
	anim.set_speed(1)
	