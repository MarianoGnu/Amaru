
extends Area2D

func _ready():
	connect("body_enter", self, "on_body_enter")

func on_body_enter(body):
	if "player" in body.get_groups():
		body.exit_cave()


