extends CanvasLayer

@export var x_speed := 40.0
@export var y_speed := 40.0

@onready var sprite_left = $WallLeft/Sprite2D
@onready var sprite_right = $WallRight/Sprite2D


func _process(delta):
	sprite_left.region_rect.position += Vector2(x_speed, y_speed) * delta
	sprite_right.region_rect.position += Vector2(x_speed, y_speed) * delta
