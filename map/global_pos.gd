
extends Position2D

export(String) var global_var_name

func _ready():
	Globals.set(global_var_name, self)

