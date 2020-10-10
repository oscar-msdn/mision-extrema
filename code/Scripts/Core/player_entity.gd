extends PlayerController
#Clase que representa una entidad controlada por el jugador
class_name PlayerEntity

func _ready():
	enable_input = true
	enable_blink_cursor = true
	enable_custom_cursor = true
	is_show_cursor = true
	enable_strafe = true
	is_simple_mode = false
	set_cursor_settings()
	add_to_group("Player")
	collision_layer = 1
	collision_mask = 6
	set_cursor_layer_collision(0)
	set_cursor_mask_collision(7)
	

var current_body:EntityHealth = null

func _MenuCursorDown():
	print("Menu on->")
	is_hold_cursor = true

func _MenuCursorUp():
	print("Menu off->")
	is_hold_cursor = false

func _cursorEntityOn(body:EntityHealth):
	current_body = body
	print("On->",body)

func _cursorEntityOff(body:EntityHealth):
	current_body = null
	print("Exit->",body)

func _Option():
	print("opt->")
	
func _OptionSpecial():
	print("opt_special->")

func _ActionOn():
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
