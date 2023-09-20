extends Node3D

@export var lerpSpeed : float = 1
@export var sensitivity : float = 5
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = lerp(global_position,player.global_position, lerpSpeed*delta)
	#$SpringArm3D/Camera3D.look_at(player.get_node("Look At").global_position)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var tempRot = rotation.x - event.relative.y / 1000 * sensitivity
		rotation.y -= event.relative.x / 1000 * 5
		
		rotation.x = clamp(tempRot, -0.5, 0.3)
