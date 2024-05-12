extends CharacterBody2D

const MOVE_SPEED := 300.0
const BALL_SCENE: PackedScene = preload("res://assets/ball/ball.tscn")

static var can_move := false

var ball: Node2D

@onready var ball_spawn_point = $BallSpawnPoint


func _ready():
	GameEvents.life_lost.connect(_on_life_lost)
	GameEvents.level_started.connect(_on_level_started)
	GameEvents.level_completed.connect(_on_level_completed)


func _physics_process(delta):
	if not can_move:
		return
	
	var move_dir := Input.get_axis("move_left", "move_right")
	velocity.x = move_dir * MOVE_SPEED
	move_and_slide()


func _unhandled_input(event):
	if not can_move:
		return

	if event.is_action_pressed("start") and ball != null:
		_release_ball()


func _spawn_ball():
	var ball_instance = BALL_SCENE.instantiate()
	ball_instance.can_move = false
	add_child(ball_instance)
	ball_instance.position = ball_spawn_point.position
	ball = ball_instance


func _release_ball():
	var ball_previous_pos = ball.global_position
	var shoot_angle = -30.0 if velocity.x < 0 else 30.0
	
	remove_child(ball)
	get_parent().add_child(ball)
	
	ball.global_position = ball_previous_pos
	ball.can_move = true
	ball.direction = Vector2.UP.rotated(deg_to_rad(shoot_angle))
	ball.paddle_bounce_sound.play()
	ball = null


func _on_life_lost(lives_left: int):
	if lives_left == 0:
		return
	
	await get_tree().create_timer(0.5).timeout
	_spawn_ball()


func _on_level_started():
	_spawn_ball()
	can_move = true


func _on_level_completed(level: int):
	can_move = false
