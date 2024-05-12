extends Node
class_name LivesComponent

const STARTING_LIVES := 5

var lives: int

@onready var ball_lost_sound = $BallLostSound


func _ready():
	GameEvents.ball_lost.connect(_on_ball_lost)
	lives = STARTING_LIVES


func _on_ball_lost(ball: Node2D):
	lives -= 1
	GameEvents.life_lost.emit(lives)
	ball_lost_sound.play()
	
	if lives == 0:
		GameEvents.game_over.emit()
