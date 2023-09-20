extends Node


@export var anim :AnimationTree
@export var hitArea : Area3D
@export var delayTimer: Timer

var canAttack
var attackReady
var canBreakeShield
var isAnimRestart
var isShiedOpen
@export var HitGroup = ""

signal SwordAttacking
signal SwordIdling

# Called when the node enters the scene tree for the first time.
func _ready():
	attackReady = true
	canBreakeShield = false
	hitArea.monitorable = false
	isShiedOpen = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not isAnimRestart:
		anim.set("parameters/StateMachine/conditions/Attack",false)
		isAnimRestart = true
	
	if Input.is_action_just_pressed("Melee Attack") and canAttack and attackReady and not isShiedOpen:
		Attack()

func Attack():
	anim.set("parameters/StateMachine/conditions/Attack",true)
	attackReady = false
	canBreakeShield = true
	isAnimRestart = false
	SwordAttacking.emit()
	delayTimer.start()

func AttackOpen():
	canAttack = true

func  AttackClose():
	canAttack = false

func StartDamage():
	canBreakeShield = true

func StopDamage():
	canBreakeShield = false
	SwordIdling.emit()

func AttackReady():
	attackReady = true

func _on_area_3d_area_entered(area):
	if canAttack and canBreakeShield and area.is_in_group(HitGroup):
		area.BreakShield()

func _on_attack_delay_timer_timeout():
	if canAttack :
		AttackReady()


func _on_player_character_alive():
	AttackOpen()


func _on_player_character_dead():
	AttackClose()


func _on_player_character_stuned():
	AttackClose()


func _on_shield_shield_opened():
	isShiedOpen = true


func _on_shield_shield_closed():
	isShiedOpen = false
