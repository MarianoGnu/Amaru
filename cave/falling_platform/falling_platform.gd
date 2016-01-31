
extends VisibilityNotifier2D

onready var platform = get_node("platform")

var test_motion_info = Physics2DTestMotionResult.new()

func _ready():
	platform.get_node("VisibilityNotifier2D").connect("exit_screen", self, "dispose")
	platform.add_to_group("one_way_collision")
	connect("enter_screen", self, "reset")
	set_fixed_process(true)
	

func _fixed_process(delta):
	if (platform.test_motion(Vector2(0,-1), 0.08, test_motion_info)):
		if "player" in test_motion_info.get_collider().get_groups():
			var player = test_motion_info.get_collider()
			if player.speed_y < -1:
				return
			set_fixed_process(false)
			var anim = platform.get_node("anim")
			anim.play("shake")
			yield(anim,"finished")
			platform.set_mode(RigidBody2D.MODE_CHARACTER)

func dispose():
	if platform.is_inside_tree():
		remove_child(platform)

func reset():
	if !platform.is_inside_tree():
		add_child(platform)
		platform.set_pos(Vector2(0,0))
		platform.set_mode(RigidBody2D.MODE_KINEMATIC)
		set_fixed_process(true)


