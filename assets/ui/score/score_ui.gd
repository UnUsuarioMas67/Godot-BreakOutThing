extends MarginContainer

@export var score_component: ScoreComponent

@onready var score_value = %ScoreValue
@onready var hi_score_value = %HiScoreValue


func _ready():
	score_component.score_gained.connect(_on_score_gained)


func _update_score(value: int):
	score_value.text = "%08d" % value


func _on_score_gained(previous_score: int, amount: int):
	#var tween := create_tween()
	#tween.tween_method(_update_score, previous_score, score_component.current_score, 0.3)
	
	_update_score(score_component.current_score)
