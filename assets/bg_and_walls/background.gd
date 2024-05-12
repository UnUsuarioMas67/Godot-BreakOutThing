extends CanvasLayer

@export var x_speed := 40.0
@export var y_speed := 40.0

@onready var sprite = $Sprite2D


func _process(delta):
	sprite.region_rect.position += Vector2(x_speed, y_speed) * delta
