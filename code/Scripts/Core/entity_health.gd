extends EntityController
#Clase base de gestion de salud
class_name EntityHealth

export(int) var health = 100
export(bool)var is_alive = true
export(bool)var is_alive_stop = false

func _ready():
	if is_alive_stop:
		if !is_alive:
			Utils.set_enabler_entity(self,false)

func get_healt(value):
	if is_alive:
		health = health + value
		_health_changed(health)

func get_damage(value):
	if is_alive:
		health =  health - value
		if health > 0:
			_health_changed(health)
		else:
			is_alive = false
			_entity_died()

# warning-ignore:unused_argument
func _health_changed(value):
	pass

func _entity_died():
	pass
