
extends RigidBody2D

export(float) var danger_speed = 60

func _ready():
	danger_speed = pow(danger_speed, 2)
	connect("body_enter", self, "on_collision")
	get_node("VisibilityNotifier2D").connect("enter_screen", self, "set_sleeping", [false])
	call_deferred("set_fixed_process", true)

func on_collision(body):
	if "player" in body.get_groups() && get_linear_velocity().length_squared() > danger_speed:
			body.take_damage()
	