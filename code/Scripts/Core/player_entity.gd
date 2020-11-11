extends PlayerController
#Clase que representa una entidad controlada por el jugador
class_name PlayerEntity

export(bool) var enable_laser : bool = false
export(bool) var laser_line2d : bool = false

var is_update_draw: bool = false
var current_body = null

func _ready():
	enable_input = true
	enable_blink_cursor = true
	enable_custom_cursor = true
	is_show_cursor = true
	enable_strafe = true
	is_simple_mode = false
	enable_laser = true
	laser_line2d = false
	add_to_group(Util.GROUP_PLAYER)
	collision_layer = Util.LAYER_PLAYER
	collision_mask = Util.MASK_PLAYER
	z_index = Util.ZINDEX_PLAYER
	z_as_relative = false
	_ready_()

func _ready_():
	set_cursor_settings()
	set_laser_settings()
	
func _MenuCursorDown():
	is_hold_cursor = true

func _MenuCursorUp():
	is_hold_cursor = false

func _cursorEntityOn(body):
	current_body = body

func _cursorEntityOff(body):
	current_body = null

func _Option():
	pass
	
func _OptionSpecial():
	pass

func _ActionOn():
	pass
	fire()

func _ActionOff():
	pass

func _health_changed(value,_position=Vector2.ZERO,_direction=Vector2.ZERO):
	pass

func _entity_died(_position=Vector2.ZERO,_direction=Vector2.ZERO):
	pass

func _change_color(color):
	if current_body != self:
		._change_color(color)

onready var end_of_gun := $EndOfGun
func _Action():
	#fire()
	pass

func fire():
	var from = end_of_gun.global_position
	var to = get_target_position()
	Helper.muzzle_flash(from,to)
	Helper.fire_bullet(from,to) 
	_fire_action = true

var _fire_action:= false
# warning-ignore:unused_argument
func _physics_process(delta):
#	if _fire_action:
#		_fire_action = false
#		var from = end_of_gun.global_position
#		var to = get_target_position()
#		fire_shoot_raycast(from,to)
	if enable_laser:
		if laser_line2d:
			laser_update()
		else:
			update()
	
onready var _laser := $Laser
func set_laser_settings():
	_laser.set_visible(enable_laser && laser_line2d)
	var from = end_of_gun.global_position
	_laser.set_origin(transform.xform_inv(from))

func laser_update():
	var from = end_of_gun.global_position
	var to = get_target_position()
	var target = (to - from ) * 100
	var direct_space = get_world_2d().direct_space_state
	var result = direct_space.intersect_ray(from,target,[self])
	if result:
		target = result.position
	_laser.set_target(transform.xform_inv(target))

func _draw():
	if enable_laser:
		if !laser_line2d:
			var from = end_of_gun.global_position
			var to = get_target_position()
			draw_Laser(from,to)

func draw_Laser(origin:Vector2 ,target:Vector2 )->void:
	var laserColor = Color(5.0,0.0,0.0,0.5) #Color(5.0,.329,.298,0.2)
	var laserPointColor = Color(7.0,0.0,0.0,0.5) #Color(10.0,.329,.298,0.3)
	target = (target - origin) * 100
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(origin,target,[self])
	if result:
		target = result.position
		draw_circle(transform.xform_inv(target),3.0,laserPointColor)
	draw_line(transform.xform_inv(origin),transform.xform_inv(target),laserColor,2.0)
	
