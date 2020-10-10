extends InputController
#Clase base de gestiona el cursor y la camara
class_name PlayerController

export(int) var blink_cursor_time = 10
export(int) var clear_input_direction = 2
export(float) var cursor_distance = 200.0
export(bool) var enable_blink_cursor = false
export(bool) var disable_blink_cursor = false
export(bool) var is_show_cursor = true
export(bool) var enable_custom_cursor = true
export(bool) var enable_custom_virtual_cursor = true
export(bool) var is_hold_cursor = false

var cursor_layer_collision:int = 0 setget set_cursor_layer_collision, get_cursor_layer_collision
var cursor_mask_collision:int = 0 setget set_cursor_mask_collision, get_cursor_mask_collision

var cursor_custom := load("res://Sprites/Varios/Cursores/Outline/crosshair007.png")
var cursor_custom_blink := load("res://Sprites/Varios/Cursores/Outline/crosshair009.png")
var cursor_virtual_tpl := load("res://Scenas/Test Topdown Move/Props/Virtual_Cursor.tscn")

var margin_screen := Vector2(100.0,100.0)
var center_screen # := (get_viewport_rect().size - margin_screen) / 2

var virtual_cursor = null
var _global_mouse_pos:Vector2 = Vector2()

func _ready():
	center_screen = (get_viewport_rect().size - margin_screen) / 2
	init_cursor()

func set_cursor_layer_collision(value):
	cursor_layer_collision = value
	if virtual_cursor:
		virtual_cursor.set_cursor_mask_collision(value)

func get_cursor_layer_collision() -> int:
	return cursor_layer_collision

func set_cursor_mask_collision(value):
	cursor_mask_collision = value
	if virtual_cursor:
		virtual_cursor.set_cursor_mask_collision(value)

func get_cursor_mask_collision() -> int:
	return cursor_mask_collision

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
					virtual_cursor = cursor_virtual_tpl.instance()
					virtual_cursor.set_texture(cursor_custom)
					get_tree().get_root().call_deferred("add_child",virtual_cursor)

					yield(get_tree(),"idle_frame")

					virtual_cursor.set_cursor_mask_collision(cursor_layer_collision)
					virtual_cursor.set_cursor_mask_collision(cursor_mask_collision)
					
					assert(virtual_cursor.connect("entity_over",self,"on_cursor_entity_over") == 0,"Error")
					assert(virtual_cursor.connect("entity_exit",self,"on_cursor_entity_exit") == 0,"Error")
				else:
					virtual_cursor.visible = true
			else:
				Input.set_custom_mouse_cursor(cursor_custom)
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
					virtual_cursor.set_texture(cursor_custom_blink)
				else:
					Input.set_custom_mouse_cursor(cursor_custom_blink)
				count_cursor_frames = -blink_cursor_time
			elif count_cursor_frames == 0:
				if enable_custom_virtual_cursor:
					virtual_cursor.set_texture(cursor_custom)
				else:
					Input.set_custom_mouse_cursor(cursor_custom)

func set_cursor_settings():
	init_cursor()

func manage_cursor_input():
	if enable_input:
		if is_show_cursor:
			manage_cursor_position()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_global_mouse_pos += event.relative

func manage_cursor_position():
	if !is_hold_cursor:
		if enable_custom_virtual_cursor:
			lookat_position += _global_mouse_pos 
			if virtual_cursor:
				virtual_cursor.position = lookat_position
				var pos = virtual_cursor.position
				pos.x = clamp(pos.x, position.x - center_screen.x,position.x + center_screen.x)
				pos.y = clamp(pos.y, position.y - center_screen.y,position.y + center_screen.y)
				virtual_cursor.position = pos
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
