extends NpcController
#Clase que representa una entidad no controlada
class_name NpcEntity

func _init_entity():
	assert(.connect("entity_died",self,"_npc_died")== 0,"Error")
	assert(.connect("health_changed",self,"_npc_health_change")==0,"Error")
	._init_entity()

# warning-ignore:unused_argument
func _npc_health_change(value):
	pass

func _npc_died():
	pass
