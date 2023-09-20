extends Node3D


var turret

# Called when the node enters the scene tree for the first time.
func _ready():
	turret = %"Follow Turret"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enter_area_3d_area_entered(area):
	if area.is_in_group("Player"):
		turret.SetFollow(true)


func _on_exit_area_3d_area_entered(area):
	if area.is_in_group("Player"):
		turret.SetFollow(false)


func _on_enter_area_3d_body_entered(body):
	print_debug(body)
	if body.is_in_group("Player"):
		print_debug("in in")
		turret.SetActivision(true)


func _on_exit_area_3d_body_entered(body):
	print_debug("out")
	if body.is_in_group("Player"):
		turret.SetActivision(false)
