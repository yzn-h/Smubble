extends KinematicBody2D

onready var body = $body

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
	_get_input()
	apply_gravity(delta)
	velocity = move_and_slide(velocity, UP)

func apply_gravity(delta):
	velocity.y += gravity * delta

func _get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	if move_direction != 0:
		body.scale.x = move_direction


func _get_h_weight():
	return 0.2 if is_on_floor() else 0.1


func _input(event):
	if event.is_action_pressed("jump"):
		if is_on_floor():
			jump()


func jump():
	velocity.y = max_jump_velocity
	is_jumping = true
