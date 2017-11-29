extends RigidBody2D

const MOVE_TIME = 0.2
var passed_time_1 = 0
var passed_time_2 = 0
var move_dir = KEY_D
const DIRS = [KEY_W, KEY_A, KEY_S, KEY_D]
var CHANGE_DIR = 3
const GRID = 32

func _ready():
	set_fixed_process(true)
	add_to_group("ghosts")
	connect("body_enter", self, "_body_enter")
	
func _fixed_process(delta):
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("walls"):
			passed_time_2 += CHANGE_DIR
	
	passed_time_2 += delta
	if passed_time_2 >= CHANGE_DIR:
		passed_time_2 -= CHANGE_DIR
		rand_seed(OS.get_unix_time())
		randomize()
		var x = (randi()%4)
		move_dir = DIRS[x]
	
	passed_time_1 += delta
	if passed_time_1 >= MOVE_TIME:
		passed_time_1 -= MOVE_TIME
		if move_dir == KEY_W:
			set_pos(get_pos() - Vector2(0, GRID))
		if move_dir == KEY_S:
			set_pos(get_pos() + Vector2(0, GRID))
		if move_dir == KEY_A:
			set_pos(get_pos() - Vector2(GRID, 0))
		if move_dir == KEY_D:
			set_pos(get_pos() + Vector2(GRID, 0))
		
func _body_enter(body):
	if body.is_in_group("body"):
		get_node("/root/World/Snake/Head").shorten_snake(body.id)
		queue_free()