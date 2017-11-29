extends RigidBody2D

const BODY_SCENE = preload("res://Mini Scenes/Body.tscn")

const MOVE_TIME = .2
const GRID = 32
var body_part_array = []
var dt = 0
var move_dir = KEY_W
var dead = false
var body_length = 1
var incID = 1
var times_hit = 0

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	var body_part = BODY_SCENE.instance()
	body_part.set_pos(get_pos() + Vector2(0, GRID))
	get_parent().add_child(body_part)
	body_part_array.push_back(body_part)

func _fixed_process(delta):
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.is_in_group("body"):
			dead = true
		if body.is_in_group("walls") or body.is_in_group("ghosts"):
			dead = true
		if body.is_in_group("food"):
			body_length += 1
			body.queue_free()
			get_node("/root/World").spawn_food()
	
	dt += delta
	if dt > MOVE_TIME and not dead:
		dt -= MOVE_TIME
		var body_part = BODY_SCENE.instance()
		body_part.set_pos(get_pos())
		body_part.add_to_group("body")
		body_part.id = incID
		incID += 1
		get_parent().add_child(body_part)
		body_part_array.push_back(body_part)
		while body_part_array.size() > body_length:
			body_part_array[0].queue_free()
			body_part_array.pop_front()
		
		if move_dir == KEY_W:
			set_pos(get_pos() - Vector2(0, GRID))
		if move_dir == KEY_S:
			set_pos(get_pos() + Vector2(0, GRID))
		if move_dir == KEY_A:
			set_pos(get_pos() - Vector2(GRID, 0))
		if move_dir == KEY_D:
			set_pos(get_pos() + Vector2(GRID, 0))

func _input(event):
	if event.type == InputEvent.KEY and event.pressed == true:
		if event.scancode == KEY_W and move_dir != KEY_S:
			move_dir = event.scancode
		if event.scancode == KEY_S and move_dir != KEY_W:
			move_dir = event.scancode
		if event.scancode == KEY_A and move_dir != KEY_D:
			move_dir = event.scancode
		if event.scancode == KEY_D and move_dir != KEY_A:
			move_dir = event.scancode
			
func shorten_snake(part_id):
	var culled = 0
	times_hit += 1
	for body_part in body_part_array:
		if body_part.id <= part_id:
			culled += 1
	body_length -= culled
	for i in range(times_hit + 1):
		get_node("/root/World").add_normal_ghost()