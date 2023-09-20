extends Node

@export var hitPoint = 9
@export var anim : AnimationPlayer
@export var restartTimer: Timer
var bars: Array = []

signal DummyDown
signal DummyUp

# Called when the node enters the scene tree for the first time.
func _ready():
	bars = [%"1", %"2", %"3", %"4", %"5", %"6", %"7", %"8", %"9"]
	anim.play("Up")

func _on_hitable_area_hit():
	if hitPoint == 0:
		return
	
	hitPoint = hitPoint -1
	
	if hitPoint <= 0:
		hitPoint = 0
		anim.play("Down")
		restartTimer.start()
		DummyDown.emit()
	
	UpdateHealthIndicator()

func _on_restart_timer_timeout():
	hitPoint = 9
	anim.play("Up")
	UpdateHealthIndicator()
	DummyUp.emit()

func UpdateHealthIndicator():
	
	for i in 9:
		bars[i].visible = i < hitPoint
