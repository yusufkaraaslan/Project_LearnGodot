extends Area3D


var isOpen
var shieldBroke
var isSwordAttaking
@export var anim : AnimationPlayer

signal ShieldOpened
signal ShieldClosed

signal ShieldTakeHit
signal ShieldBroke

var reactiveTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	reactiveTimer = %"Reactive Timer"
	anim.play("IdleClose")
	isOpen = false
	shieldBroke = false
	isSwordAttaking = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ShieldControl()


func ShieldControl():
	if Input.is_action_just_pressed("Fire Shiled") and not shieldBroke and not isSwordAttaking:
		OpenShield()
	
	if Input.is_action_just_released("Fire Shiled") and isOpen:
		CloseShield()


func OpenShield():
	anim.play("Open")
	ShieldOpened.emit()
	isOpen = true;
	self.set_deferred("monitorable",true)


func CloseShield():
	anim.play("Close")
	ShieldClosed.emit()
	isOpen = false;
	self.set_deferred("monitorable",false)


func TakeDamege(damege):
	ShieldTakeHit.emit()


func BreakShield():
	anim.play("Broke")
	ShieldBroke.emit()
	isOpen = false;
	shieldBroke = true;
	self.set_deferred("monitorable",false)
	reactiveTimer.start()


func RestoreShield():
	shieldBroke = false


func _on_reactive_timer_timeout():
	RestoreShield()


func _on_sword_pref_sword_attacking():
	isSwordAttaking = true


func _on_sword_pref_sword_idling():
	isSwordAttaking = false
