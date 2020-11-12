extends Node

func _ready():
	add_to_group("helper")
	
func add_child_to_root(object,position:=null):
	if position:
		object.global_position = position
	get_tree().get_root().call_deferred("add_child",object)

func instance_root(origin,target,object):
	var direction = origin.direction_to(target)
	object.global_position = origin + direction * 40.0
	object.rotation = direction.angle()
	get_tree().get_root().call_deferred("add_child",object)

func blood_splarks(position,direction)->Object:
	var bloods = Props.BloodSparks.instance()
	bloods.global_position = position
	bloods.rotation = direction.angle()
	get_tree().get_root().call_deferred("add_child",bloods)
	bloods.emitting = true
	return bloods

func blood_splater(position,direction)->Object:
	var blood = Props.BloodSplater.instance()
	blood.global_position = position
	blood.rotation = direction.angle()
	get_tree().get_root().call_deferred("add_child",blood)
	blood.emitting = true
	return blood

func smoke(position,isadd:=true)->Object:
	var smoke = Props.Smoke.instance()
	smoke.global_position = position
	if isadd:
		get_tree().get_root().call_deferred("add_child",smoke)
	return smoke
	
func smoke2(position,isadd:=true)->Object:
	var smoke = Props.Smoke2.instance()
	smoke.global_position = position
	if isadd:
		get_tree().get_root().call_deferred("add_child",smoke)
	return smoke

func ember_splarks(position,direction)->Object:
	var splarks = Props.EmberSparks.instance()
	splarks.global_position = position
	splarks.rotation = direction.angle()
	get_tree().get_root().call_deferred("add_child",splarks)
	splarks.emitting = true
	return splarks

func muzzle_flash(origin,target)->Object:
	var muzzle = Props.MuzzleFlash.instance()
	var direction = origin.direction_to(target)
	muzzle.global_position = origin + direction * 40.0
	muzzle.rotation = direction.angle()
	get_tree().get_root().call_deferred("add_child",muzzle)
	return muzzle

func fire_bullet(position,target)->Object:
	var bullet = Props.BulletTemplate.instance()
	bullet.set_values(position,target)
	get_tree().get_root().call_deferred("add_child",bullet)
	return bullet

func set_enabler_entity(object:Node,stop=false):
	object.set_process_internal(stop)
	object.set_process(stop)
	object.set_physics_process(stop) 
	object.set_physics_process_internal(stop)

func Screenshoot()->void:
	get_viewport().queue_screen_capture()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var screenshot = get_viewport().get_screen_capture()
	screenshot.save_png("user://screenshot.png")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event.is_action_pressed("test_load"):
# warning-ignore:unused_variable
		for i in range(10):
			get_tree().get_root().add_child(Props.GatoEnemyTemplate.instance())
	
	if event.is_action_pressed("stop_process"):
		set_process_internal(false)
		set_process(false)
		
	if event.is_action_pressed("stop_process_fixed"):
		set_physics_process(false) 
		set_physics_process_internal(false)
