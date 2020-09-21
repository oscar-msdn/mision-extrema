extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("Main")
	Utils.Subscribir(Events.SIGNAL_PLAYER_DEAD,self,"on_player_dead")
	#Events.connect(Events.SIGNAL_PLAYER_DEAD,self,"on_player_dead")
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if event.is_action_pressed("CargarEscena"):
		var error = get_tree().reload_current_scene()
		print(error)

func on_player_dead()->void:
# warning-ignore:unused_variable
	var error = get_tree().reload_current_scene()
	#get_tree().change_scene("res://Scenas/Niveles/LoadScene.tscn")
	#get_tree().call_group_flags(GROUP_CALL_REALTIME,"GRUPO","Metodo")
