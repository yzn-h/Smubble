extends Node2D

signal weapon_fired(bullet, location, direction)

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var animation_player = $AnimationPlayer
onready var attack_cool_down = $AttackCoolDown

export (PackedScene) var Bullet

var deg_for_bullet : float
var vel : Vector2


func _physics_process(_delta):
	get_weapon_deg()


# Called when the node enters the scene tree for the first time.
func get_weapon_deg():
	var mouse_pos : Vector2 = get_global_mouse_position()
	deg_for_bullet = mouse_pos.angle_to_point(end_of_gun.global_position)
	self.look_at(mouse_pos)
	

func shoot():
	if attack_cool_down.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		emit_signal("weapon_fired", bullet_instance, end_of_gun.global_position, direction)
		attack_cool_down.start()
		animation_player.play("muzzle_flash")
		get_parent().set_knockback_velovity(direction)
