
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("AnimationPlayer").connect("finished", self, "load_level")

func load_level():
	get_tree().change_scene("res://map/world.scn")


