extends EntityController
#Clase base de gestion de salud
class_name EntityHealth

signal health_changed(value)
signal entity_died()

export(int) var health = 100
export(bool)var is_alive = true

func get_healt(value):
	if is_alive:
		health = health + value
		emit_signal("health_changed",health)

func get_damage(value):
	if is_alive:
		health =  health - value
		if health > 0:
			emit_signal("health_changed",health)
		else:
			is_alive = false
			emit_signal("entity_died")
