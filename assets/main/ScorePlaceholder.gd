extends Label

var score_component: ScoreComponent


func _ready():
	score_component = get_parent()
	score_component.score_gained.connect(_on_score_gained)


func _on_score_gained(previous_score: int, amount: int):
	text = "SCORE " + str(score_component.current_score)
