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
	enable_laser = false
	add_to_group(Util.GROUP_PLAYER)
	collision_layer = Util.LAYER_PLAYER
	collision_mask = Util.MASK_PLAYER
	z_index = Util.ZINDEX_PLAYER
	z_as_relative = false

func _ready():
	set_cursor_settings()
	set_laser_settings()
	
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
	#fire()
	print("action-->")

export(PackedScene) var muzzle
func fire():
	var from = end_of_gun.global_position
	var to = get_target_position()
	Helper.fire_bullet(from,to) 
	
	var instance = muzzle.instance()
	Helper.instance_root(from,to,instance)
	
	_fire_action = true

var _fire_action:= false
# warning-ignore:unused_argument
func _physics_process(delta):
#	if _fire_action:
#		_fire_action = false
#		var from = end_of_gun.global_position
#		var to = get_target_position()
#		fire_shoot_raycast(from,to)
	laser_update()
	
onready var _laser := $Laser
func set_laser_settings():
	_laser.set_visible(enable_laser)
	var from = end_of_gun.global_position
	#_laser.global_position = from
	_laser.set_origin(transform.xform_inv(from))
		

func laser_update():
	if enable_laser:
		var from = end_of_gun.global_position
		var to = get_target_position()
		var target = (to - from ) * 100
		var direct_space = get_world_2d().direct_space_state
		var result = direct_space.intersect_ray(from,target,[self])
		if result:
			target = result.position
		_laser.set_target(transform.xform_inv(target))

