extends MarginContainer

var is_filled := true : set = _set_is_filled

@onready var empty := $Empty
@onready var filled := $Filled
@onready var heart_particle = $HeartParticle


func _ready():
	heart_particle.one_shot = true


#func _unhandled_input(event):
	#if event.is_action_pressed("start") and not is_filled:
		#is_filled = true


func _set_is_filled(value: bool):
	is_filled = value
	
	if is_filled:
		_fill()
	else:
		_empty()


func _empty():
	empty.show()
	filled.hide()
	heart_particle.emitting = true


func _fill():
	filled.show()
	filled.pivot_offset = Vector2(16, 16)
	
	var tween := create_tween()
	tween.tween_property(filled, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(empty.hide)
