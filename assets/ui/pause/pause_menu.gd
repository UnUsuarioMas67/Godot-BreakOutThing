extends CanvasLayer

@onready var resume_button = %ResumeButton
@onready var exit_button = %ExitButton


func _ready():
	get_tree().paused = true
	
	resume_button.pressed.connect(_on_resume_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = false
		queue_free()
		get_tree().root.set_input_as_handled()


func _on_resume_button_pressed():
	get_tree().paused = false
	queue_free()


func _on_exit_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://assets/ui/main_menu/main_menu.tscn")
