
extends KinematicBody2D

export(float) var idle_time = 1
export(float) var patrol_distance = 100
export(float) var attack_distance = 600

onready var t = get_node("Timer")
onready var sprite_node = get_node("Sprite")
onready var sight = get_node("RayCast2D")
onready var anim = get_node("anim")
onready var dmg_area = get_node("dmg_area")

var state = CONST.state_patrol
var patrolling = false
var patrol_step = -1
var current_movement = Vector2()

var facing = CONST.right setget set_facing,get_facing

var speed_y = 0

func _ready():
	t.connect("timeout", self, "advance_patrol")
	dmg_area.connect("body_enter", self, "on_body_enter")
	sight.add_exception(self)
	advance_patrol()

func _fixed_process(delta):
	
	if (state == CONST.state_patrol):
		if (patrol_step == 1 || patrol_step == 3):
			var mov = (current_movement.normalized()*CONST.walk_speed*delta)
			var fail = Vector2()
			if mov.length_squared() < current_movement.length_squared():
				fail = move(mov)
				current_movement -= mov
			else:
				fail = move(current_movement)
				current_movement = Vector2()
				advance_patrol()
		if sight.is_colliding() && "player" in sight.get_collider().get_groups():
			state = CONST.state_attack
			t.stop()
			set_fixed_process(false)
			anim.play("pre_attack")
			yield(anim,"finished")
			set_fixed_process(true)
			anim.play("attack")
			current_movement = Vector2(facing*attack_distance, 0)
	elif (state == CONST.state_attack):
		var mov = (current_movement.normalized()*CONST.run_speed*delta)
		var fail = Vector2()
		if mov.length_squared() < current_movement.length_squared():
			fail = move(mov)
			current_movement -= mov
		else:
			fail = move(current_movement)
			state = CONST.state_patrol
			anim.play("walk")
			anim.seek(0,true)
			advance_patrol()
	
	speed_y += delta*CONST.gravity

	var fail = move(Vector2(0, speed_y*delta))
	if (fail.length_squared() > 0):
		speed_y = 0

func set_facing(val):
	if facing == val:
		return
	facing = val
	sprite_node.set_scale(Vector2(facing,1)*0.5)
	sight.set_cast_to(Vector2(facing*abs(sight.get_cast_to().x), 0))
func get_facing():
	return facing
	

func advance_patrol():
	patrol_step += 1
	if patrol_step == 4:
		patrol_step = 0
	if (patrol_step == 0 || patrol_step == 2):
		t.set_wait_time(idle_time)
		t.start()
	elif patrol_step == 1:
		current_movement = Vector2(-patrol_distance, 0)
		self.facing = CONST.left
	elif patrol_step == 3:
		current_movement = Vector2(patrol_distance, 0)
		self.facing = CONST.right

func on_body_enter(body):
	if "player" in body.get_groups():
		body.take_damage()