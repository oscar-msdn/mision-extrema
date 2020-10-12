extends PlayerController
#Clase que representa una entidad controlada por el jugador
class_name PlayerEntity

var current_body:EntityHealth = null

func _init():
	enable_input = true
	enable_blink_cursor = true
	enable_custom_cursor = true
	is_show_cursor = true
	enable_strafe = true
	is_simple_mode = false
	enable_laser = false
	add_to_group("Player")
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
	fire()
	print("action_on->")

func _ActionOff():
	print("action_off->")

func _health_changed(value):
	print("player_health->",value)

func _entity_died():
	print("player_died")

func _change_color(color):
	if current_body != self:
		._change_color(color)

onready var end_of_gun = $EndOfGun
func _Action():
	#fire()
	print("action-->")
	
func fire():
	var from = end_of_gun.global_position
	var to = get_target_position()
	Helper.fire_bullet(from,to) 

func _draw():
	var from = end_of_gun.global_position
	var to = get_target_position()
	draw_Laser(from,to)

# warning-ignore:unused_argument
func _rotation_changed(value):
	is_update_draw = true
