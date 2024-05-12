extends Node
class_name ScoreComponent

signal score_gained(previous_score: int, amount: int)

const POINTS_PER_BRICK_BROKEN := 100
const POINTS_PER_BRICK_DAMAGED := 25

var current_score: int = 0


func _ready():
	GameEvents.brick_broken.connect(_on_brick_broken)
	GameEvents.brick_damaged.connect(_on_brick_damaged)


func _on_brick_broken():
	var previous_score = current_score
	
	current_score += POINTS_PER_BRICK_BROKEN
	score_gained.emit(previous_score, POINTS_PER_BRICK_BROKEN)


func _on_brick_damaged():
	var previous_score = current_score
	
	current_score += POINTS_PER_BRICK_DAMAGED
	score_gained.emit(previous_score, POINTS_PER_BRICK_DAMAGED)
