extends Node3D


@export var bullet : PackedScene
@export var firePoint: Node3D

@export var fireDelay : float

var fireTimer : Timer
@export var canFire : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	fireTimer = %"Fire Timer"
	fireTimer.set_wait_time(fireDelay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if canFire:
		SpawnBullet()


func SpawnBullet():
	var newBullet = bullet.instantiate()
	newBullet.position = firePoint.global_position
	newBullet.rotation = firePoint.global_rotation
	
	get_tree().root.add_child(newBullet)

func SetCanFire(value):
	canFire = value
