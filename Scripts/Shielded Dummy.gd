extends Node3D


@export var reopenTimer : Timer

@export var rotateRoot : Node3D
@export var shield : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	shield.OpenShield()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_shield_shield_broke():
	reopenTimer.start()
	rotateRoot.SetFollow(false)


func _on_timer_timeout():
	shield.OpenShield()
	rotateRoot.SetFollow(true)
