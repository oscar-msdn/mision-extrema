extends PlayerEntity

func _health_changed(value):
	print("-->player_health->",value)

func _entity_died():
	print("-->player_died")

