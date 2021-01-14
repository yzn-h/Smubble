extends KinematicBody2D


onready var health_stat = $Health


export (int) var move_speed = 400


const UP = Vector2(0, -1)

var velocity = Vector2()
var gravity
var max_jump_velocity
var min_jump_velocity


var health: int = 10

var max_jump_height = 125
var min_jump_height = 40
var jump_duration = 0.4


func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)


func handle_hit():
	health_stat.health -= 1
	print("Enemy hit!", health_stat.health)
	if health_stat.health <= 0:
		die()


func die():
	queue_free()


func _physics_process(delta):
	apply_gravity(delta)
	velocity = move_and_slide(velocity, UP)


func apply_gravity(delta):
	velocity.y += gravity * delta
