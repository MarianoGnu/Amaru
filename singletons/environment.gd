
extends Node

export(Environment) var env

func _ready():
	get_tree().get_root().get_world().set_environment(env)


