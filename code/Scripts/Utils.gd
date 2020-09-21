extends Node

enum ALERTAS { NPC_DEAD,NA=-1 }

func Subscribir(evento:String,caller,metodo:String)->void:
	Events.connect(evento,caller,metodo)
	print(caller," -> subcripcion:",evento)

func Desubscribir(evento:String,caller,metodo:String)->void:
	Events.disconnect(evento,caller,metodo)
	print(caller," -> desubcripcion:",evento)
	
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
	
	print(caller," -> Invoke:",evento, " with ", args)

func Screenshoot()->void:
	print("Screenshot")
	get_viewport().queue_screen_capture()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var screenshot = get_viewport().get_screen_capture()
	screenshot.save_png("user://screenshot.png")
