extends StaticBody2D
class_name BoxWood

export(int) var shield = 100
export(int) var health = 100

export(bool)var is_alive = true

export(bool)var is_destructible = false

func _ready():
	add_to_group(Util.GROUP_WALL)
	collision_layer = Util.LAYER_WALL
	collision_mask = Util.MASK_WALL

func get_shield():
	return shield
	
func give_damage(value,position,direction)->void:
	if is_alive:
		if is_destructible:
			health =  health - value
			
		if health > 0:
			_health_changed(health,position,direction)
		else:
			is_alive = false
			_entity_died(position,direction)

# warning-ignore:unused_argument
func _health_changed(value,_position=Vector2.ZERO,_direction=Vector2.ZERO):
	var sparks = Helper.ember_splarks(_position,_direction)
	sparks.is_smoke=false
	sparks.modulate *= Color.brown

func _entity_died(_position=Vector2.ZERO,_direction=Vector2.ZERO):
	pass
