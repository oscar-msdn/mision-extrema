extends EntityHealth
#Clase base de gestion del input de usuario
class_name InputController

export(bool) var enable_input = true
export(bool) var enable_strafe = true
export(bool) var is_simple_mode = true

export(float) var rotation_sensibility = 0.08
export(float) var move_sensibility = 1.0

# warning-ignore:unused_argument
func _physics_process(delta):
	manage_input()

func manage_input():
	if enable_input:
		get_input()
		
var local_direction:Vector2 = Vector2.ZERO
func get_input():
	local_direction.y =  (Input.get_action_strength("Down") - Input.get_action_strength("Up"))
	local_direction.x =  (Input.get_action_strength("Right") - Input.get_action_strength("Left"))
	
	if Input.is_action_just_released("MenuCursorDown"):
		_MenuCursorDown()
	
	if Input.is_action_just_released("MenuCursorUp"):
		_MenuCursorUp()
	
	if Input.is_action_pressed("FreeCamara"):
		_FreeCamara()
	
	if Input.is_action_just_pressed("Option"):
		_Option()
	
	if Input.is_action_just_pressed("OptionSpecial"):
		_OptionSpecial()
	
	if Input.is_action_just_pressed("Action"):
		_ActionOn()
	elif Input.is_action_just_released("Action"):
		_ActionOff()

func _move_entity(delta):
	direction = local_direction
	if !enable_strafe:
		if !is_simple_mode:
			direction.x = 0.0
			direction.y = local_direction.y
			direction = direction.rotated(rotation)
			velocity_lineal = velocity_lineal * move_sensibility
	._move_entity(delta)

func _get_look_at(delta):
	if enable_strafe:
		._get_look_at(delta)
	else:
		if is_simple_mode:
			rotation = local_direction.angle() 
		else:
			rotation_to += local_direction.x * rotation_sensibility
			_custom_look_at(delta)

func _MenuCursorDown():
	pass

func _MenuCursorUp():
	pass

func _FreeCamara():
	pass

func _Option():
	pass
	
func _OptionSpecial():
	pass

func _ActionOn():
	pass
	
func _ActionOff():
	pass
