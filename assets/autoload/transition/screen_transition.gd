extends CanvasLayer

signal transition_halfway

@onready var rect = $ColorRect
@onready var center_container = $CenterContainer
@onready var label = $CenterContainer/Label


func transition():
	var tween := create_tween()
	
	tween.tween_callback(rect.show)
	tween.tween_property(rect.material, "shader_parameter/percent", 1, 0.4)
	tween.tween_callback(emit_transition_halfway)
	tween.tween_interval(1)
	tween.tween_property(rect.material, "shader_parameter/percent", 0, 0.4)
	tween.tween_callback(rect.hide)


func transition_with_text(text: String):
	label.text = text
	var tween := create_tween()
	
	# transition fade-in
	tween.tween_callback(rect.show)
	tween.tween_property(rect.material, "shader_parameter/percent", 1, 0.4)
	
	# signal
	tween.tween_callback(emit_transition_halfway)
	
	# show text
	tween.tween_callback(center_container.show)
	tween.tween_property(center_container, "modulate", Color.WHITE, 0.1).from(Color.TRANSPARENT)
	tween.tween_interval(1.0)
	tween.tween_property(center_container, "modulate", Color.TRANSPARENT, 0.1)
	tween.tween_callback(center_container.hide)
	
	# transition fade-out
	tween.tween_property(rect.material, "shader_parameter/percent", 0, 0.4)
	tween.tween_callback(rect.hide)


func emit_transition_halfway():
	transition_halfway.emit()
