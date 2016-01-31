
extends KinematicBody2D

var facing = CONST.right setget set_facing,get_facing
var grounded = true setget ,get_grounded
var can_climb = false setget set_can_climb,get_can_climb
var climbing = false
var crouched = false

var speed_y = CONST.gravity
var speed_x = 0

var jump = 0
var max_jump = 2

var prev_anim = ""

onready var ground_ray = get_node("RayCast2D")
onready var sprite_node = get_node("Sprite")
onready var anim = get_node("anim")
var jump_timer
var last_jump_key = false
var jump_anims = ["jump","jump2"]

const air_anims = ["fall", "pre_jump", "jump", "jump2"]

func _init():
	add_to_group("player")

func _ready():
	ground_ray.add_exception(self)
	set_fixed_process(true)
	var t = Timer.new()
	t.set_name("jump_down_timer")
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	add_child(t)
	jump_timer = Timer.new()
	jump_timer.set_name("jump_timer")
	jump_timer.set_wait_time(0.1)
	jump_timer.set_one_shot(true)
	add_child(jump_timer)

func _fixed_process(delta):
	if prev_anim != anim.get_current_animation():
		normalize_rot()
	prev_anim = anim.get_current_animation()
	
	if Input.is_action_pressed("jump") && !climbing && !last_jump_key:
		last_jump_key = true
		if crouched:
			call_deferred("jump_down")
		else:
			print ("jump: " + str(jump))
			if jump == 0:
				anim.play("pre_jump")
				set_fixed_process(false)
				yield(anim, "finished")
				set_fixed_process(true)
				anim.play("jump")
				speed_y = CONST.jump_impulse[jump]
			elif jump == 1:
				anim.play("jump2")
				speed_y = CONST.jump_impulse[jump]
			jump+=1
				
	elif Input.is_action_pressed("jump") && climbing && !last_jump_key:
		climbing = false
		jump=1
		anim.play(jump_anims[0])
		speed_y = CONST.jump_impulse[0]
		jump_timer.start()
		yield(jump_timer, "timeout")
	elif !Input.is_action_pressed("jump"):
		last_jump_key = false
	if is_colliding() && get_collision_normal().y < 0 && speed_y >= 0 && jump > 0:
		jump=0
		anim.play("idle")
	
	if climbing:
		if Input.is_action_pressed("up"):
			speed_y = -CONST.climb_speed
			if anim.get_speed() != 1:
				get_tree().call_group(0, "one_way_collision", "set_one_way_collision_direction", Vector2(0,1))
			anim.set_speed(1)
		elif Input.is_action_pressed("down"):
			speed_y = CONST.climb_speed
			if anim.get_speed() != -1:
				get_tree().call_group(0, "one_way_collision", "set_one_way_collision_direction", Vector2(0,-1))
			anim.set_speed(1)
		elif is_colliding():
			climbing=false
		else:
			speed_y = 0
			anim.set_speed(0)
			anim.seek(0,true)
	if !climbing:
		anim.set_speed(1)
		if can_climb && !climbing && (Input.is_action_pressed("up") || Input.is_action_pressed("down")):
			speed_x = 0
			climbing = true
			anim.play("climb")
		elif Input.is_action_pressed("down") && self.grounded:
			speed_x = 0
			crouched = true
			if anim.get_current_animation()!="crouch":
				anim.play("crouch")
		elif Input.is_action_pressed("right"):
			speed_x = CONST.walk_speed
			if jump == 0 && anim.get_current_animation()!="walk":
				anim.play("walk")
				crouched = false
		elif Input.is_action_pressed("left"):
			speed_x -= CONST.walk_speed
			if  jump == 0 && anim.get_current_animation()!="walk":
				anim.play("walk")
				crouched = false
		elif abs(speed_x) > 0.1:
			var deaccelerate = sign(speed_x)*delta*CONST.acceleration
			if (abs(deaccelerate) > abs(speed_x)):
				speed_x = 0
			else:
				speed_x -= deaccelerate
		else:
			if  jump == 0 && anim.get_current_animation()!="idle":
				anim.play("idle")
				crouched = false
		speed_y += delta*CONST.gravity
		
	
	speed_x = clamp(speed_x, -CONST.walk_speed, CONST.walk_speed)
	if (speed_x < 0):
		self.facing = CONST.left
	elif (speed_x > 0):
		self.facing = CONST.right
	
	
	var velocity = Vector2(speed_x,0)
	var motion = velocity * delta
	motion = move( motion ) 

	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide( motion ) 
		velocity = n.slide( velocity )
		move( motion )

	velocity = Vector2(0,speed_y)
	motion = velocity * delta
	motion = move (motion)
	if (!climbing && motion.length_squared() > 0):
		speed_y=0
	

func set_facing(val):
	if facing == val:
		return
	facing = val
	sprite_node.set_scale(Vector2(facing,1)*0.4)
func get_facing():
	return facing

func set_can_climb(val):
	can_climb = val
	if (!val):
		climbing=false
func get_can_climb():
	return can_climb

func take_damage():
	set_fixed_process(false)
	var spd = anim.get_speed()
	var a = anim.get_current_animation()
	var pos = anim.get_pos()
	anim.set_speed(1)
	anim.play("hit")
	yield(anim, "finished")
	set_fixed_process(true)
	anim.set_speed(spd)
	anim.play(a)
	anim.seek(pos)
	if (GAME_MANAGER.get_item_count() == 0):
		print("game_over")
	else:
		GAME_MANAGER.return_item()

func get_grounded():
	return ground_ray.is_colliding()

func jump_down():
	get_tree().call_group(0, "one_way_collision", "set_one_way_collision_direction", Vector2(0,-1))
	var t = get_node("jump_down_timer")
	t.start()
	yield(t, "timeout")
	get_tree().call_group(0, "one_way_collision", "set_one_way_collision_direction", Vector2(0,1))

func normalize_rot():
	sprite_node.set_rot(0)