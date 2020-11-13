extends NpcController
#Clase que representa una entidad no controlada
class_name NpcEntity

func _ready():
	add_to_group(Util.GROUP_NPC)
	collision_layer = Util.LAYER_ENEMY
	collision_mask = Util.MASK_ENEMY
	z_index = Util.ZINDEX_ENEMY
	z_as_relative = false

func hit_blood(position=Vector2.ZERO,direction=Vector2.ZERO):
	# warning-ignore:return_value_discarded
	#Helper.blood_splarks(_position,_direction)
	#Helper.blood_splater(position,direction)
	var sparks = Helper.ember_splarks(global_position,direction)
	sparks.modulate *= Color.red 
	sparks.is_smoke = false
	sparks.scale *= 4.0
	sparks.speed_scale = 1.0
	Helper.blood_splater(global_position,direction)
	var smoke = Helper.smoke(position)
	smoke.modulate *= Color.chocolate 
	smoke.modulate.r *= 2.0
	smoke.modulate.a = 0.5
	smoke.scale *= 0.3
	smoke.FACTOR = 2.0 

func _health_changed(value,_position=Vector2.ZERO,_direction=Vector2.ZERO):
	hit_blood(_position,_direction)
	velocity_lineal = velocity_lineal + _direction  * 1000000.0
	
func _entity_died(_position=Vector2.ZERO,_direction=Vector2.ZERO):
	hit_blood(_position,_direction)
	queue_free()

func exit_damage(position,direction) -> void:
	pass
	
