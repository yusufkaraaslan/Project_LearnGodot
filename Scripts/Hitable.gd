extends Area3D

@export var canTakeDamege : bool

signal Hit
signal HitPointChange

func TakeHit():
	if canTakeDamege:
		HitPointChange.emit()
		Hit.emit()

func _on_player_character_alive():
	canTakeDamege = true

func _on_player_character_dashing():
	canTakeDamege = false

func _on_player_character_dead():
	canTakeDamege = false

func _on_player_character_stuned():
	canTakeDamege = true
