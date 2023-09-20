extends CharacterBody3D


const SPEED = 10.0
const DASHSPEED = 80.0

var canDash
var dashDirection
@export var dashTimer :Timer
@export var dashCooldownTimer :Timer

var lookAtObj
var lastLookAtDir : Vector3

var anim : AnimationTree

@export var stunTimer : Timer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var playerState: Constants.CharacterState
signal CharacterStateChange
signal CharacterAlive
signal CharacterStuned
signal CharacterDashing
signal CharacterDead

func _ready():
	lookAtObj = get_tree().get_first_node_in_group("CameraController").get_node("Player Look At")
	anim = %AnimationTree
	ChangeCharacterState(Constants.CharacterState.Alive)
	canDash = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("Left", "Right", "Forward","Backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if playerState == Constants.CharacterState.Alive and Input.is_action_just_pressed("Dash") and canDash:
		dashDirection = direction
		ChangeCharacterState(Constants.CharacterState.Dashing)
		dashTimer.start()
		dashCooldownTimer.start()
	
	if playerState == Constants.CharacterState.Dashing:
		Dash()
	
	if playerState == Constants.CharacterState.Alive:
		UpdateCharacterDirection(direction)
		UpdateMovement(direction)
	
	UpdateAnimationTree(input_dir)
	
	move_and_slide()

func UpdateCharacterDirection(direction):
	if direction or IsPlayerAttaking() :
		var dir = lerp(lastLookAtDir, Vector3(lookAtObj.global_position.x, global_position.y, lookAtObj.global_position.z ), .08)
		look_at(Vector3(dir.x, global_position.y, dir.z))
		lastLookAtDir = dir

func IsPlayerAttaking():
	return Input.is_action_pressed("Fire Bullet") or Input.is_action_pressed("Fire Shiled")

func UpdateMovement(direction):
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func Dash():
	velocity.x = dashDirection.x * DASHSPEED
	velocity.z = dashDirection.z * DASHSPEED

func _on_dash_timer_timeout():
	if playerState == Constants.CharacterState.Dashing:
		ChangeCharacterState(Constants.CharacterState.Alive)

func _on_dash_cooldown_timer_timeout():
	canDash = true

func UpdateAnimationTree(input_dir):
	# Movement
	anim.set("parameters/Movement/conditions/Backwards walk", input_dir.x == 0 and input_dir.y > 0)
	anim.set("parameters/Movement/conditions/Forward Run", input_dir.x == 0 and input_dir.y < 0 and not Input.is_action_pressed("Fire Shiled"))
	anim.set("parameters/Movement/conditions/Forward Walk", input_dir.x == 0 and input_dir.y < 0 and Input.is_action_pressed("Fire Shiled"))
	anim.set("parameters/Movement/conditions/Idle", input_dir.x == 0 and input_dir.y == 0)
	anim.set("parameters/Movement/conditions/Left Forward Run", input_dir.x < 0 and input_dir.y < 0)
	anim.set("parameters/Movement/conditions/Left Walk", input_dir.x < 0 and input_dir.y == 0)
	anim.set("parameters/Movement/conditions/Right Forward Run", input_dir.x > 0 and input_dir.y < 0)
	anim.set("parameters/Movement/conditions/Right Walk", input_dir.x > 0 and input_dir.y == 0)

func ChangeCharacterState(newState):
	playerState = newState
	CharacterStateChange.emit()
	
	match playerState:
		Constants.CharacterState.Alive:
			CharacterAlive.emit()
		Constants.CharacterState.Stuned:
			CharacterStuned.emit()
		Constants.CharacterState.Dashing:
			canDash = false
			CharacterDashing.emit()
		Constants.CharacterState.Dead:
			CharacterDead.emit()

func _on_shield_shield_broke():
	ChangeCharacterState(Constants.CharacterState.Stuned)
	stunTimer.start()

func _on_stun_timer_timeout():
	if playerState == Constants.CharacterState.Stuned:
		ChangeCharacterState(Constants.CharacterState.Alive)
