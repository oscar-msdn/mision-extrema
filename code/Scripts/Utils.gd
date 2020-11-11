extends Node

enum ALERTAS { NPC_DEAD,NA=-1 }

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	add_to_group("Main")
#	Utils.Subscribir(Events.SIGNAL_PLAYER_DEAD,self,"on_player_dead")
#	#Events.connect(Events.SIGNAL_PLAYER_DEAD,self,"on_player_dead")

func Subscribir(evento:String,caller,metodo:String)->void:
# warning-ignore:return_value_discarded
	Events.connect(evento,caller,metodo)

func Desubscribir(evento:String,caller,metodo:String)->void:
	Events.disconnect(evento,caller,metodo)
	
func Invoke(evento:String,caller,args:Array=[])->void:
	match(args.size()):
		0:
			Events.emit_signal(evento)
		1:
			Events.emit_signal(evento,args[0])
		2:
			Events.emit_signal(evento,args[0],args[1])
		3:
			Events.emit_signal(evento,args[0],args[1],args[2])
		4:
			Events.emit_signal(evento,args[0],args[1],args[2],args[3])
		5:
			Events.emit_signal(evento,args[0],args[1],args[2],args[3],args[4])
	




