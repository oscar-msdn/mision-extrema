extends Node

func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("Main")
	Utils.Subscribir(Events.SIGNAL_PLAYER_DEAD,self,"on_player_dead")
	#Events.connect(Events.SIGNAL_PLAYER_DEAD,self,"on_player_dead")
	

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event.is_action_pressed("test_load"):
# warning-ignore:unused_variable
		for i in range(10):
			get_tree().get_root().add_child(Util.gato_enemy_template.instance())
	
	if event.is_action_pressed("stop_process"):
		set_process_internal(false)
		set_process(false)
		
	if event.is_action_pressed("stop_process_fixed"):
		set_physics_process(false) 
		set_physics_process_internal(false)
		
#	if event.is_action_pressed("CargarEscena"):
#		var error = get_tree().reload_current_scene()
#		print(error)

#func on_player_dead()->void:
## warning-ignore:unused_variable
#	var error = get_tree().reload_current_scene()
#	#get_tree().change_scene("res://Scenas/Niveles/LoadScene.tscn")
#	#get_tree().call_group_flags(GROUP_CALL_REALTIME,"GRUPO","Metodo")
