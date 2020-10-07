extends EntityHealth
#Clase base de gestion de un NPC
class_name NpcController

func _init_entity():
	._init_entity()
	lookat_position = position

func _loop_process(delta):
	._loop_process(delta)

func _loop_process_render(delta):
	._loop_process_render(delta)
