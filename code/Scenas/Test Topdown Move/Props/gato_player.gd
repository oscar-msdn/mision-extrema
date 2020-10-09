extends PlayerEntity

func _init_entity():
	._init_entity()

func _loop_process_render(delta):
	._loop_process_render(delta)

func _player_died():
	print("died!")

func _player_health_change(value):
	print("health --> " , value)

