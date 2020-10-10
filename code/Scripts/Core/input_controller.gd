extends EntityHealth
#Clase base de gestion del input de usuario
class_name InputController

export(bool) var enable_input = true

# warning-ignore:unused_argument
func _physics_process(delta):
	manage_input()

func manage_input():
	if enable_input:
		get_input()

func get_input():
	direction = Vector2.ZERO
	if Input.is_action_pressed("Left"):
		direction += Vector2.LEFT
	elif Input.is_action_pressed("Right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("Up"):
		direction += Vector2.UP
	elif Input.is_action_pressed("Down"):
		direction += Vector2.DOWN
	
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
