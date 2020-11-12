extends InputController
#Clase base de gestiona el cursor y la camara
class_name PlayerController

export(int) var blink_cursor_time = 10
export(int) var clear_input_direction = 2
export(float) var cursor_distance = 200.0
export(float) var cursor_min_distance = 1.0
export(bool) var enable_blink_cursor = false
export(bool) var disable_blink_cursor = false
export(bool) var is_show_cursor = true
export(bool) var enable_custom_cursor = true
export(bool) var enable_custom_virtual_cursor = true
export(bool) var is_hold_cursor = false

var margin_screen := Vector2(100.0,100.0)
var center_screen := Vector2() # (get_viewport_rect().size - margin_screen) / 2

var virtual_cursor = null

func _ready():
	center_screen = (get_viewport_rect().size - margin_screen) / 2
	init_cursor()

func init_cursor():
	if !is_show_cursor:
		if enable_custom_virtual_cursor:
			if virtual_cursor:
				virtual_cursor.visible = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if enable_custom_cursor:
			if enable_custom_virtual_cursor:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				if !virtual_cursor:
					virtual_cursor = Props.CursorVirtualTemplate.instance()
					virtual_cursor.set_texture(Props.CursorCustom)
					get_tree().get_root().call_deferred("add_child",virtual_cursor)
					yield(get_tree(),"idle_frame")
					assert(virtual_cursor.connect("entity_over",self,"on_cursor_entity_over") == 0,"Error")
					assert(virtual_cursor.connect("entity_exit",self,"on_cursor_entity_exit") == 0,"Error")
				else:
					virtual_cursor.visible = true
					
				lookat_position = position + Vector2(1.0,0.0) * cursor_min_distance
				
			else:
				Input.set_custom_mouse_cursor(Props.CursorCustom)
		else:
			Input.set_custom_mouse_cursor(null)

# warning-ignore:unused_argument
func _physics_process(delta):
	manage_cursor_input()

# warning-ignore:unused_argument
func _process(delta):
	blink_cursor()

var count_cursor_frames:int = 0
func blink_cursor():
	if enable_blink_cursor:
		if enable_custom_cursor:
			count_cursor_frames = count_cursor_frames + 1
			if count_cursor_frames > blink_cursor_time:
				if enable_custom_virtual_cursor:
					virtual_cursor.set_texture(Props.CursorCustomBlink)
				else:
					Input.set_custom_mouse_cursor(Props.CursorCustomBlink)
				count_cursor_frames = -blink_cursor_time
			elif count_cursor_frames == 0:
				if enable_custom_virtual_cursor:
					virtual_cursor.set_texture(Props.CursorCustom)
				else:
					Input.set_custom_mouse_cursor(Props.CursorCustom)

func set_cursor_settings():
	init_cursor()

func manage_cursor_input():
	if enable_input:
		if is_show_cursor:
			manage_cursor_position()

func manage_cursor_position():
	if !is_hold_cursor:
		if enable_custom_virtual_cursor:
			lookat_position += _global_mouse_pos 
			if virtual_cursor:
				var pos:Vector2 = lookat_position
				
				var x_max = position.x + center_screen.x
				var x_min = position.x - center_screen.x
				pos.x = clamp(pos.x, x_min, x_max)

				var y_max = position.y + center_screen.y
				var y_min = position.y - center_screen.y
				pos.y = clamp(pos.y, y_min, y_max)
				
				lookat_position = pos
				
				virtual_cursor.position = lookat_position
		else:
			lookat_position = get_global_mouse_position()
			
	_global_mouse_pos = Vector2.ZERO

var count_clear_direction:int = 0
func clear_input():
	count_clear_direction =  count_clear_direction + 1
	if count_clear_direction > clear_input_direction:
		count_clear_direction = 0
		direction = Vector2.ZERO

func _position_changed(value):
	if !is_hold_cursor:
		if enable_custom_virtual_cursor:
			if virtual_cursor:
				lookat_position += value

func on_cursor_entity_over(body):
	_cursorEntityOn(body)
	if !disable_blink_cursor:
		enable_blink_cursor = true
	_change_color(virtual_cursor.TipoColor.ROJO)

func on_cursor_entity_exit(body):
	_cursorEntityOff(body)
	if !disable_blink_cursor:
		enable_blink_cursor = false
	_change_color(virtual_cursor.TipoColor.BLANCO)

func _change_color(color):
	if virtual_cursor:
		virtual_cursor.set_change_color(color)

# warning-ignore:unused_argument
func  _cursorEntityOn(body):
	pass
	
# warning-ignore:unused_argument
func _cursorEntityOff(body):
	pass

func get_target_position() -> Vector2:
	return lookat_position
