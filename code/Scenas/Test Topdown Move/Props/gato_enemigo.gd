extends NpcEntity

func _player_died():
	print("died!")

func _player_health_change(value):
	print("health --> " , value)
