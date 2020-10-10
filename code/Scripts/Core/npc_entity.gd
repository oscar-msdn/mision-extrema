extends NpcController
#Clase que representa una entidad no controlada
class_name NpcEntity

func _ready():
	add_to_group("NPC")
	collision_mask = 7
	collision_layer = 2

func _health_changed(value):
	print("-->NPC_health->",value)

func _entity_died():
	print("-->NPC_died")

