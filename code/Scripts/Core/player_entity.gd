extends PlayerController
#Clase que representa una entidad controlada por el jugador
class_name PlayerEntity

func _init_entity():
#	enable_input = true
#	enable_blink_cursor = true
#	enable_custom_cursor = true
#	is_show_cursor = true
	add_to_group("Player")
	collision_mask = 7
	collision_layer = 1
	assert(.connect("entity_died",self,"_player_died") == 0,"Error")
	assert(.connect("health_changed",self,"_player_health_change") == 0,"Error")
	._init_entity()

# warning-ignore:unused_argument
func _player_health_change(value):
	pass

func _player_died():
	pass
