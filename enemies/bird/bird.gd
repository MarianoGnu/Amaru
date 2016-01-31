
extends Node2D

export(int,"lineal,dive,circle,cross") var patrol = 0

const patrols = ["patrol_a","patrol_b","patrol_c","patrol_d"]

func _ready():
	var area = get_node("bird_area")
	area.connect("body_enter", self, "on_body_enter")
	get_node("bird_area/patrol").set_speed(rand_range(0.8,1.2))
	get_node("bird_area/patrol").play(patrols[patrol])
	

func on_body_enter(body):
	if "player" in body.get_groups():
		body.take_damage()

