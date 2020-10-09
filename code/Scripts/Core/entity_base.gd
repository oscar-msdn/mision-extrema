extends Node
#Clase base para cualquier entidad
class_name EntityBase

func _ready():
	_init_entity()

func _process(delta):
	_loop_process_render(delta)

func _physics_process(delta):
	_loop_process(delta)

#Metodos a Heredar
#Incializacion de entidades. _ready
func _init_entity():
	pass

#Loop general. _physics_process
# warning-ignore:unused_argument
func _loop_process(delta):
	pass

#Loop de render. _process
# warning-ignore:unused_argument
func _loop_process_render(delta):
	pass
