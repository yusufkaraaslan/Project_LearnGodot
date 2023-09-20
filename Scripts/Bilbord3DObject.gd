extends Node3D


@export var lookObjectGroup  = ""

var lookObject
var lastLookAtDir : Vector3

@export var isFollowing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	lookObject = get_tree().get_first_node_in_group(lookObjectGroup)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lookObject != null and isFollowing:
		var dir = lerp(lastLookAtDir, Vector3(lookObject.global_position.x, global_position.y, lookObject.global_position.z ), 1)
		look_at(Vector3(dir.x, global_position.y, dir.z))
		lastLookAtDir = dir

func SetFollow(value):
	isFollowing = value
