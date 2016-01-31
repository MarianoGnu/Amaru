
extends Area2D

export(int, "craneo,colibri,garra,serpiente,alas de pajaro,cola de pez,flor,piedra,rayo") var item_id = 0

func _ready():
	if !is_connected("body_enter", self, "on_body_enter"):
		connect("body_enter", self, "on_body_enter")

func on_body_enter(body):
	if ("player" in body.get_groups()):
		GAME_MANAGER.call_deferred("get_item",self)

func _enter_tree():
	add_shape(get_node("CollisionShape2D").get_shape())
