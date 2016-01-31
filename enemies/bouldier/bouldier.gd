
extends RigidBody2D

export(float) var danger_speed = 60

func _ready():
	danger_speed = pow(danger_speed, 2)
	connect("body_enter", self, "on_collision")
	get_node("VisibilityNotifier2D").connect("enter_screen", self, "roll")
	call_deferred("set_fixed_process", true)

func on_collision(body):
	if "player" in body.get_groups() && get_linear_velocity().length_squared() > danger_speed:
			body.take_damage()

func roll():
	print("rolling")
	set_mode(RigidBody2D.MODE_RIGID)