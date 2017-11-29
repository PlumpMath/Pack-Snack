extends Node2D

const FOOD_SCENE = preload("res://Mini Scenes/Food.tscn")
const NG_SCENE = preload("res://Mini Scenes/NormalGhost.tscn")

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