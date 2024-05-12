extends MarginContainer

@export var lives_component: LivesComponent

const HEART_SCENE: PackedScene = preload("res://assets/ui/lives/heart.tscn")

@onready var heart_container = %HeartContainer


func _ready():
	_initialize_hearts()
	GameEvents.life_lost.connect(_on_life_lost)


func _initialize_hearts():
	var hearts_count := heart_container.get_child_count()
	
	if hearts_count < lives_component.STARTING_LIVES:
		# add remaining hearts
		var hearts_to_add := lives_component.STARTING_LIVES - hearts_count
		for heart in hearts_to_add:
			var heart_instance = HEART_SCENE.instantiate()
			heart_container.add_child(heart_instance)
	elif hearts_count > lives_component.STARTING_LIVES:
		# remove excess hearts
		var hearts_to_remove := hearts_count - lives_component.STARTING_LIVES
		var hearts := heart_container.get_children()
		for heart in hearts_to_remove:
			hearts[heart].queue_free()


func _life_lost_animation():
	var tween = create_tween().set_parallel()
	var reverse_children := heart_container.get_children().duplicate()
	reverse_children.reverse()
	
	for heart in reverse_children:
		var previous_position = heart.position
		
		tween.tween_property(heart, "position", heart.position + Vector2(0, -10), 0.1)
		tween.chain().tween_property(heart, "position", previous_position, 0.2)


func _on_life_lost(lives_left: int):
	var pointer := heart_container.get_child_count() - 1
	var hearts := heart_container.get_children()
	
	while pointer >= 0:
		var h = hearts[pointer]
		if h.is_filled:
			h.is_filled = false
			break
		
		pointer -= 1
