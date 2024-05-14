extends Node

const LEVELS := [
	"res://assets/levels/level1.tscn",
	"res://assets/levels/level2.tscn", 
	"res://assets/levels/level3.tscn",
	"res://assets/levels/level4.tscn",
	"res://assets/levels/level5.tscn",
	]

var current_level: int
var balls: Array
var pausable := false


func _ready():
	GameEvents.no_bricks_left.connect(_on_no_bricks_left)
	GameEvents.game_over.connect(_on_game_over)
	GameEvents.ball_lost.connect(_on_ball_lost)
	GameEvents.new_ball.connect(_on_new_ball)


func reset():
	current_level = 1
	balls = []
	pausable = false
	
	Ball.min_speed = Ball.STARTING_SPEED
	Ball.current_speed = Ball.min_speed


func start_game():
	reset()
	ScreenTransition.transition_with_text("LEVEL " + str(current_level))
	await ScreenTransition.transition_halfway
	
	get_tree().change_scene_to_file("res://assets/main/main.tscn")
	await GameEvents.game_started
	load_next_level()


func load_next_level():
	# check if there is a node to put the level in
	var level_container := get_tree().get_first_node_in_group("level_container") as Node2D
	if !level_container or current_level > LEVELS.size():
		return
	
	var level_scene := load(LEVELS[current_level - 1]) as PackedScene
	var level_instance := level_scene.instantiate()
	
	level_instance.ready.connect(_on_level_ready, CONNECT_ONE_SHOT)
	
	# remove the previous level
	for child in level_container.get_children():
		level_container.remove_child(child)
		child.queue_free()
	
	level_container.add_child(level_instance)
	

func _on_level_ready():
	pausable = true
	await get_tree().create_timer(2.5).timeout
	GameEvents.level_started.emit()


func _on_game_over():
	pausable = false
	await get_tree().create_timer(1.5).timeout
	
	ScreenTransition.transition_with_text("GAME OVER")
	await ScreenTransition.transition_halfway
	
	reset()
	get_tree().change_scene_to_file("res://assets/ui/main_menu/main_menu.tscn")


func _on_no_bricks_left():
	pausable = false
	GameEvents.level_completed.emit(current_level)
	await get_tree().create_timer(0.5).timeout
	
	current_level += 1
	var msg := "LEVEL " + str(current_level)
	var no_levels_left = false
	
	if current_level > LEVELS.size():
		msg = "CONGRATULATIONS!1!! \nYOU WON!"
		no_levels_left = true
	
	ScreenTransition.transition_with_text(msg)
	await ScreenTransition.transition_halfway
	
	balls = []
	
	if not no_levels_left:
		load_next_level()
	else:
		GameEvents.game_won.emit()
		reset()
		get_tree().change_scene_to_file("res://assets/ui/main_menu/main_menu.tscn")


func _on_ball_lost(ball: Node2D):
	balls.erase(ball)


func _on_new_ball(ball: Node2D):
	balls.append(ball)
