extends EntityHealth
#Clase base de gestion del input de usuario
class_name PlayerController

export(int) var blink_cursor_time = 10
export(int) var clear_input_direction = 0

var cursor_custom := load("res://Sprites/Varios/Cursores/Outline/crosshair007.png")
var cursor_custom_blink := load("res://Sprites/Varios/Cursores/Outline/crosshair009.png")

export(bool)var enable_blink_cursor =true
export(bool)var is_show_cursor = true
export(bool)var enable_custom_cursor = true
export(bool)var enable_input = true

func _init_entity():
	._init_entity()
	if !is_show_cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		if enable_custom_cursor:
			Input.set_custom_mouse_cursor(cursor_custom)

var count_cursor_frames:int = 0
func blink_cursor():
	if enable_blink_cursor:
		if enable_custom_cursor:
			count_cursor_frames = count_cursor_frames + 1
			if count_cursor_frames > blink_cursor_time:
				Input.set_custom_mouse_cursor(cursor_custom_blink)
				count_cursor_frames = -blink_cursor_time
			elif count_cursor_frames == 0:
				Input.set_custom_mouse_cursor(cursor_custom)

func init_cursor():
	if !is_show_cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		if enable_custom_cursor:
			Input.set_custom_mouse_cursor(cursor_custom)
		else:
			Input.set_custom_mouse_cursor(null)

func _loop_process(delta):
	._loop_process(delta)
	manage_input(delta)

func _loop_process_render(delta):
	._loop_process_render(delta)
	blink_cursor()

func manage_input(delta):
	if enable_input:
		clear_input()
		get_input(delta)
		lookat_position = get_global_mouse_position()

# warning-ignore:unused_argument
func get_input(delta):
	if Input.is_action_pressed("Left"):
		direction += Vector2.LEFT
	elif Input.is_action_pressed("Right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("Up"):
		direction += Vector2.UP
	elif Input.is_action_pressed("Down"):
		direction += Vector2.DOWN

var count_clear_direction:int = 0
func clear_input():
	count_clear_direction =  count_clear_direction + 1
	if count_clear_direction > clear_input_direction:
		count_clear_direction = 0
		direction = Vector2.ZERO



