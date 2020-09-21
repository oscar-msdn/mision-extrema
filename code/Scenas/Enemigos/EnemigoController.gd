extends KinematicBody2D

export (int) var SPEED = 350
export (bool) var HOLD_CROSS_HAIR = false
export (bool) var IS_DEAD = false

export (int) var LIVE = 100

const ACCEL = 15.0
const CROSS_DIST_MAX = 300.0
const CROSS_ACCEL = 15.0

onready var _Player = ($CollisionShape2D)
onready var _Anim = ($AnimationTree)
onready var _State_machine = _Anim.get("parameters/playback")
onready var _playBack = _Anim.get("parameters/playback")
onready var _Sprite = ($CollisionShape2D/Personaje)

var _velocity = Vector2()
var _can_shoot = true
var _current_state = ""
var _is_armed_type = 0

func _ready():	
	pass

func _physics_process(delta):
	_current_state = _playBack.get_current_node()
	if(!IS_DEAD):
		aim_player()
		move_player(delta)
		get_action()
		update_State()

func update_State():
	var isWalk = false
	var _vel = abs(_velocity.length())
	
	if _vel > 0.1:
		isWalk = true
	
	var isArmed = _is_armed_type > 0
	var isGun = _is_armed_type == 1
	var isMachine = _is_armed_type == 2
	
	var isReload = false
	var isHold  = false
	
	var isDead = _is_armed_type == 3
	if isDead:
		IS_DEAD = true
		_playBack.travel("Dead")
	
	_Anim["parameters/conditions/isReload"] = isReload
	
	_Anim["parameters/conditions/isGun"] = isGun
	_Anim["parameters/conditions/isMachine"] = isMachine
	
	_Anim["parameters/conditions/isArmed"] = isArmed
	_Anim["parameters/conditions/isNotArmed"] = !isArmed

	_Anim["parameters/conditions/isIdle"] = !isWalk
	_Anim["parameters/conditions/isWalk"] = isWalk
	
	_Anim["parameters/conditions/isHold"] = isHold
	_Anim["parameters/conditions/isNotHold"] = !isHold

func move_player(delta):
	var dir = get_input()
	dir = dir.normalized()
	var vel = dir * SPEED
	_velocity = _velocity.linear_interpolate(vel,delta*ACCEL)
	_velocity = move_and_slide(_velocity)

func aim_player():
	pass
	#var current_pos = _global_mouse_pos
	#var current_cross_pos = _Crosshair.position
	#current_pos += current_cross_pos
	#var vect_rot =  current_pos - _Player.position
	#var ang = vect_rot.angle() 
	#_Player.set_rotation(ang)
	#_Player.set_rotation(ang)

func get_input():
	var dir = Vector2()
	return dir

func get_action():
	if Input.is_action_just_pressed("Option"):
		if _is_armed_type > 0:
			_is_armed_type = 0
		else:
			_is_armed_type = 1
			
	if Input.is_action_just_pressed("Action"):
		shoot()

func shoot():
	if(_can_shoot):
		_can_shoot = false
