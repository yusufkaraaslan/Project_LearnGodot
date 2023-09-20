extends RigidBody3D

@export var Speed = 10
@export var Damage = 1
@export var HitGroup = ""
@export var selfDistroyTime = 7
@export var timer : Timer
@export var bulletExplodeParticle : PackedScene

var shoot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = selfDistroyTime
	timer.start()
	apply_force(transform.basis.z * Speed,-transform.basis.z)

func _on_area_3d_body_entered(body):
	DestroyBullet()

func DestroyBullet():
	var particle =  bulletExplodeParticle.instantiate()
	particle.position = global_position
	particle.rotation = global_rotation
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
	
	queue_free()

func _on_timer_timeout():
	DestroyBullet()

func _on_area_3d_area_entered(area):
	if area.is_in_group(HitGroup):
		area.TakeHit()
	DestroyBullet()
