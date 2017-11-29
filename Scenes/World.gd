extends Node2D

const FOOD_SCENE = preload("res://Mini Scenes/Food.tscn")
const NG_SCENE = preload("res://Mini Scenes/NormalGhost.tscn")

var is_playing = false
var is_dead = false

func _ready():
	set_process_input(true)

func spawn_food():
	var food = FOOD_SCENE.instance()
	rand_seed(OS.get_unix_time())
	randomize()
	var x = (randi()%25)*32
	var y = (randi()%19)*32
	food.set_pos(Vector2(x, y))
	add_child(food)
	print("Food at: " + str(x) + " , " + str(y))
	
func add_normal_ghost():
	var ghost = NG_SCENE.instance()
	rand_seed(OS.get_unix_time())
	randomize()
	var x = (randi()%25)*32
	var y = (randi()%19)*32
	ghost.set_pos(Vector2(x, y))
	add_child(ghost)
	print("Ghost at: " + str(x) + " , " + str(y))
	
func set_score(score):
	get_node("/root/World/UIElements/Score").set_text("Length: " + str(score))
	
func _input(event):
	if event.type == InputEvent.KEY and event.pressed == true:
		if event.scancode == KEY_SPACE and not is_dead:
			is_playing = true
			get_node("/root/World/UIElements/WelcomeText").hide()
			get_node("/root/World/UIElements/Splash").hide()
			get_node("/root/World/UIElements/Score").set_text("Length: 1")
		if event.scancode == KEY_SPACE and is_dead:
			get_tree().reload_current_scene()
			
func set_death():
	is_playing = false
	is_dead = true
	get_node("/root/World/UIElements/Score").hide()
	get_node("/root/World/UIElements/WelcomeText").set_bbcode("[center]You died!\nSpace to reload\n\nFinal length: " + str(get_node("Snake/Head").body_length) + "\nTimes hit: " + str(get_node("Snake/Head").times_hit) + "[/center]")
	get_node("/root/World/UIElements/WelcomeText").show()
	get_node("/root/World/UIElements/Splash").show()