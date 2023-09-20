extends Node3D

@export var bullet : PackedScene
@export var firePoint: Node3D

var canFire

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Fire Bullet") and canFire and not Input.is_action_pressed("Fire Shiled"):
		SpawnBullet()

func SpawnBullet():
	var newBullet = bullet.instantiate()
	newBullet.position = firePoint.global_position
	newBullet.rotation = firePoint.global_rotation
	
	get_tree().root.add_child(newBullet)

func _on_player_character_alive():
	canFire = true

func _on_player_character_dashing():
	canFire = true

func _on_player_character_state_change():
	canFire = false
