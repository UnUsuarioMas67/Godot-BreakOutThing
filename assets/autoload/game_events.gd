extends Node

signal brick_broken
signal brick_damaged
signal no_bricks_left
signal new_ball(ball: Node2D)
signal ball_lost(ball: Node2D)
signal life_lost(lives_left: int)
signal game_started
signal game_over
signal game_won
signal level_started
signal level_completed(level: int)
signal new_level(level: int)
