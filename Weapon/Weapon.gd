extends Node2D

onready var end_of_gun = $EndOfGun
var deg_for_bullet : float
var vel : Vector2


func _physics_process(delta):
	get_weapon_deg()


# Called when the node enters the scene tree for the first time.
func get_weapon_deg():
	var mouse_pos : Vector2 = get_global_mouse_position()
	deg_for_bullet = mouse_pos.angle_to_point(end_of_gun.global_position)
	self.look_at(mouse_pos)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
