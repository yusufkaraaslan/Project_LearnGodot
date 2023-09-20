extends Node


var rotateRoot
var turrert

# Called when the node enters the scene tree for the first time.
func _ready():
	rotateRoot = $"Turret Root"
	turrert = %Turet


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func SetActivision(value):
	rotateRoot.SetFollow(value)
	turrert.SetCanFire(value) 
