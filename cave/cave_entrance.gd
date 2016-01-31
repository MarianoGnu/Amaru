
extends Area2D

func _ready():
	Globals.set("cave_entrance_pos", self)
	connect("body_enter", self, "on_body_enter")
	connect("body_exit", self, "on_body_exit")

func on_body_enter(body):
	if "player" in body.get_groups():
		body.allow_enter_cave=true

func on_body_exit(body):
	if "player" in body.get_groups():
		body.allow_enter_cave=false