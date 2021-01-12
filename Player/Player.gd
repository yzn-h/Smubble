extends KinematicBody2D


onready var body = $body
onready var coyoty_timer = $CoyoteTimer
onready var jump_buffer = $JumpBuffer


const UP = Vector2(0, -1)

var velocity = Vector2()
export (int) var move_speed = 400
var gravity
var max_jump_velocity
var min_jump_velocity
var is_jumping

var max_jump_height = 125
var min_jump_height = 40
var jump_duration = 0.4


func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)


func _physics_process(delta):
	if velocity.y >= 0 and is_jumping:
		is_jumping = false
	var was_on_floor = is_on_floor()
	_get_input()
	apply_gravity(delta)
	velocity = move_and_slide(velocity, UP)
	coyoty_jump(was_on_floor)
	jump_buffer()

func apply_gravity(delta):
	if coyoty_timer.is_stopped():
		velocity.y += gravity * delta


func coyoty_jump(was_on_floor):
	if !is_on_floor() and was_on_floor and !is_jumping:
		coyoty_timer.start()
		velocity.y = 0


func jump_buffer():
	if is_on_floor() and !jump_buffer.is_stopped():
		jump_buffer.stop()
		jump()


func _get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	if move_direction != 0:
		body.scale.x = move_direction


func _get_h_weight():
	return 0.2 if is_on_floor() else 0.1


func _input(event):
	if event.is_action_pressed("jump"):
		if is_on_floor() or !coyoty_timer.is_stopped():
			coyoty_timer.stop()
			jump()
		else:
			jump_buffer.start()


func jump():
	velocity.y = max_jump_velocity
	is_jumping = true
