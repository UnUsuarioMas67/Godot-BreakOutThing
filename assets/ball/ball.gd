extends CharacterBody2D
class_name Ball

const STARTING_SPEED := 180.0
const MAX_SPEED := 300.0
const SPEED_INCREASE_PER_BRICK_HIT := 2.0
const SPEED_DECREASE_PER_LIFE_LOST := 30.0
const MIN_PADDLE_BOUNCE_ANGLE := 30.0
const MIN_SPEED_INCREASE_PER_LEVEL := 20.0

static var min_speed: float = STARTING_SPEED
static var current_speed: float = min_speed

var direction := Vector2.UP
var can_move := true

@onready var paddle_bounce_sound = $PaddleBounce
@onready var brick_bounce_sound = $BrickBounce
@onready var wall_bounce_sound = $WallBounce


func _ready():
	GameEvents.brick_broken.connect(_on_brick_broken_or_damaged)
	GameEvents.brick_damaged.connect(_on_brick_broken_or_damaged)
	GameEvents.life_lost.connect(_on_life_lost)
	GameEvents.level_completed.connect(_on_level_completed)
	
	GameEvents.new_ball.emit(self)


func _physics_process(delta):
	if !can_move:
		return
	
	velocity = current_speed * direction
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		_handle_collision(get_slide_collision(0))


func destroy():
	queue_free()
	GameEvents.ball_lost.emit(self)


func _handle_collision(collision: KinematicCollision2D):
	var collider = collision.get_collider() as Node2D
	
	if collider.is_in_group("brick_map"):
		collider.hit_brick_by_rid(collision.get_collider_rid())
		direction = direction.bounce(collision.get_normal())
		brick_bounce_sound.play()
		return
	
	if collider.is_in_group("paddle"):
		_bounce_from_paddle(collider)
		paddle_bounce_sound.play()
	else:
		direction = direction.bounce(collision.get_normal())
		wall_bounce_sound.play()


func _bounce_from_paddle(paddle: Node2D):
	var bounce_angle := rad_to_deg(paddle.global_position.angle_to_point(global_position))
	bounce_angle = clampf(bounce_angle, (180 - MIN_PADDLE_BOUNCE_ANGLE) * -1, -MIN_PADDLE_BOUNCE_ANGLE)
	
	direction = Vector2.from_angle(deg_to_rad(bounce_angle))


func _on_level_completed(level: int):
	can_move = false
	min_speed += MIN_SPEED_INCREASE_PER_LEVEL * level
	current_speed = min_speed


func _on_brick_broken_or_damaged():
	current_speed = min(current_speed + SPEED_INCREASE_PER_BRICK_HIT, MAX_SPEED)


func _on_life_lost(lives_left: int):
	current_speed = max(current_speed - SPEED_DECREASE_PER_LIFE_LOST, min_speed)
