extends Area2D
class_name Bullet

onready var kill_timer = $KillTimer

export (int) var speed = 500


var direction := Vector2.ZERO


func _ready():
	kill_timer.start()


func _physics_process(delta):
	
	if direction != Vector2.ZERO:
		var velocity = direction * delta * speed
		
		global_position += velocity


func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_KillTimer_timeout():
	queue_free()


func _on_Bullet_body_entered(body):
	queue_free()
