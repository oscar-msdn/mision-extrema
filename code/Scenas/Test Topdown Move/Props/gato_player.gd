extends PlayerEntity

func _health_changed(value,_position=Vector2.ZERO,_direction=Vector2.ZERO):
	print("-->player_health->",value)

func _entity_died(_position=Vector2.ZERO,_direction=Vector2.ZERO):
	print("-->player_died")

