extends NpcController
#Clase que representa una entidad no controlada
class_name NpcEntity

func _init():
	add_to_group(Util.GROUP_NPC)
	collision_layer = Util.LAYER_ENEMY
	collision_mask = Util.MASK_ENEMY
	z_index = Util.ZINDEX_ENEMY
	z_as_relative = false

func _health_changed(value,_position=Vector2.ZERO,_direction=Vector2.ZERO):
	print("-->NPC_health->",value)

func _entity_died(_position=Vector2.ZERO,_direction=Vector2.ZERO):
	print("-->NPC_died")
# warning-ignore:return_value_discarded
	Helper.blood_splater(_position,_direction)
	var smoke = Helper.smoke(_position)
	smoke.modulate *= Color.chocolate 
	smoke.modulate.r *= 2.0
	smoke.scale *= 0.3
	smoke.FACTOR = 2.0 
	queue_free()
