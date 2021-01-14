extends KinematicBody2D
class_name Player


signal player_fired_bullet(bullet, position, direction)


onready var body = $body

onready var coyoty_timer = $CoyoteTimer
onready var jump_buffer_timer = $JumpBuffer
onready var variable_jump_buffer = $VariableJumpBuffer

onready var weapon = $Weapon

onready var health_stat = $Health


export (int) var move_speed = 400


var knockback = 625
var knockback_velovity : Vector2

const UP = Vector2(0, -1)

var velocity = Vector2()
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
	weapon.connect("weapon_fired", self, "shoot")


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
	if !is_on_floor() and was_on_floor and velocity.y >= 0:
		coyoty_timer.start()
		velocity.y = 0


func jump_buffer():
	if is_on_floor() and !jump_buffer_timer.is_stopped():
		jump_buffer_timer.stop()
		jump()
		variable_jump_buffer.start()
	if !variable_jump_buffer.is_stopped() and !Input.is_action_pressed("jump"):
		variable_jump()


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
			jump_buffer_timer.start()
	if event.is_action_released("jump"):
		variable_jump()
	if event.is_action_pressed("shoot"):
		weapon.shoot()

 
func shoot(bullet_instance, location: Vector2, direction: Vector2):
	emit_signal("player_fired_bullet", bullet_instance, location, direction)


func set_knockback_velovity(knockback_direction):
	knockback_direction.x *= 2.75
	knockback_velovity = knockback_direction * -knockback
	velocity = knockback_velovity

func handle_hit():
	health_stat.health -= 1
	print("player hit!", health_stat.health)


func jump():
	velocity.y = max_jump_velocity
	is_jumping = true


func variable_jump():
	if !velocity.y >= min_jump_velocity and is_jumping:
		velocity.y = min_jump_velocity
