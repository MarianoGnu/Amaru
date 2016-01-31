
extends Node2D

#onready var climp_area = get_node("climb_area")

func _ready():
	var climb_area = get_node("climb_area")
	if (climb_area != null):
		climb_area.connect("body_enter", self, "on_body_enter")
		climb_area.connect("body_exit", self, "on_body_exit")
	var walkable = get_node("walkable")
	if (walkable != null):
		walkable.add_to_group("one_way_collision")

func on_body_enter(body):
	if ("player" in body.get_groups()):
		body.can_climb = true


func on_body_exit(body):
	if ("player" in body.get_groups()):
		body.can_climb = false

