extends PlayerController
#Clase que representa una entidad controlada por el jugador
class_name PlayerEntity

export(bool) var enable_laser : bool = false

var is_update_draw: bool = false
var current_body = null

func _init():
	enable_input = true
	enable_blink_cursor = true
	enable_custom_cursor = true
	is_show_cursor = true
	enable_strafe = true
	is_simple_mode = false
	enable_laser = true
	add_to_group(Util.GROUP_PLAYER)
	collision_layer = Util.LAYER_PLAYER
	collision_mask = Util.MASK_PLAYER
	z_index = Util.ZINDEX_PLAYER
	z_as_relative = false

func _ready():
	set_cursor_settings()
	
func _MenuCursorDown():
	print("Menu on->")
	is_hold_cursor = true

func _MenuCursorUp():
	print("Menu off->")
	is_hold_cursor = false

func _cursorEntityOn(body):
	current_body = body
	print("On->",body)

func _cursorEntityOff(body):
	current_body = null
	print("Exit->",body)

func _Option():
	print("opt->")
	
func _OptionSpecial():
	print("opt_special->")

func _ActionOn():
	print("action_on->")
	fire()

func _ActionOff():
	print("action_off->")

func _health_changed(value):
	print("player_health->",value)

func _entity_died():
	print("player_died")

func _change_color(color):
	if current_body != self:
		._change_color(color)

onready var end_of_gun := $EndOfGun
func _Action():
	fire()
	print("action-->")
	
func fire():
	var from = end_of_gun.global_position
	var to = get_target_position()
	Helper.fire_bullet(from,to) 
	_fire_action = true

var _fire_action:= false
# warning-ignore:unused_argument
func _physics_process_(delta):
	if _fire_action:
		_fire_action = false
		var from = end_of_gun.global_position
		var to = get_target_position()
		fire_shoot_raycast(from,to)

func _draw_():
	is_update_draw = true
	var from = end_of_gun.global_position
	var to = get_target_position()
	laser_update(from,to)

func _position_changed(value):
	._position_changed(value)
	update_canvas()
	
# warning-ignore:unused_argument
func _rotation_changed(value):
	update_canvas()

func update_canvas():
	if enable_laser:
		if is_update_draw:
			is_update_draw = false
			update()

func laser_update(origin, target):
	if enable_laser:
		target = (target - origin ) * 100
		var direct_space = get_world_2d().direct_space_state
		var result = direct_space.intersect_ray(origin,target,[self])
		if result:
			target = result.position
		var laserColor = Color(1.0,.329,.298,0.3)
		var laserPointColor = Color(1.0,.329,.298,0.5)
		draw_line(transform.xform_inv(origin),transform.xform_inv(target),laserColor,2.0)
		draw_circle(transform.xform_inv(target),3,laserPointColor)
