
extends Area2D


func _ready():
	connect("body_enter", self, "on_body_enter")

func on_body_enter(body):
	if body extends RigidBody2D:
		for stone in get_children():
			if stone extends RigidBody2D:
				stone.set_mode(RigidBody2D.MODE_RIGID)


