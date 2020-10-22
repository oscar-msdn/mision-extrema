extends EntityController
#Clase base de gestion de salud
class_name EntityHealth

export(int) var shield = 100
export(int) var health = 100
export(bool)var is_alive = true
export(bool)var is_alive_stop = false

func _ready():
	if is_alive_stop:
		if !is_alive:
			Helper.set_enabler_entity(self,false)

func get_healt(value):
	if is_alive:
		health = health + value
		_health_changed(health)

func get_shield():
	return shield

# warning-ignore:unused_argument
func give_damage(value,position,direction)->void:
	if is_alive:
		health =  health - value
		if health > 0:
			_health_changed(health,position,direction)
		else:
			is_alive = false
			_entity_died(position,direction)

func _health_changed(value,_position=Vector2.ZERO,_direction=Vector2.ZERO):
	pass


func _entity_died(_position=Vector2.ZERO,_direction=Vector2.ZERO):
	pass
