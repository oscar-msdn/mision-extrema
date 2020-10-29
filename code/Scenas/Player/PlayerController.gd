extends KinematicBody2D

export (int) var SPEED = 300
export (bool) var HOLD_CROSS_HAIR_X = false
export (bool) var HOLD_CROSS_HAIR_Y = false
export (int) var CROSS_DIST_MAX = 400
export (int) var ZOOM_CROSS_DIST_MAX = 400
export (bool) var IS_DEAD = false
export (int) var LIVE = 100
export (float) var MOUSE_SEN = 1.0
export (float) var ACCEL = 15.0
export (float) var CROSS_ACCEL = 15.0

export (bool) var FLIP_FIRE_TO_LEFT_ARM = false
export (bool) var SHOW_CROSS_HAIR = true
export (bool) var IS_CURRENT_PLAYER = false

export (bool) var IS_NPC = false
export (bool) var IS_TELEKINESIS = false
export (bool) var SHOW_FIELD_VIEW = true
export (int) var FIELD_VIEW_LENGHT = 300

export (float) var FIELD_VIEW_RAY_ANG1 = 0.68
export (float) var FIELD_VIEW_FANCING_ANG2 = 0.98
export (float) var FIELD_VIEW_FIRE_PLAYER = 0.995

export (bool) var SHOW_HELP_LASER = true
export (bool) var SHOW_BULLET_LINE = true
export (int) var HIT_VALUE:int = 100

export (float) var NPC_THINK_TIME:float = 0.1

enum TipoArma { Melee, Gun, Machine, Silencer, NA }
export (TipoArma) var TIPO_ARMA = TipoArma.NA
export (bool) var IS_ARMED = false

enum TipoDisfraz {Hitman,Azul,Brown,ManOld,Robot,Soldier1,Survidor1,WomanGreen,Zoibie,NA=-1}
export (TipoDisfraz) var TIPO_DISFRAZ = TipoDisfraz.Hitman
export (TipoDisfraz) var TIPO_DISFRAZ_BASE = TipoDisfraz.Hitman
export (float) var FX_TELEKINESIS_TIME = 5.0

export (bool) var VISIVILITY_ENABLER =  true

const GRUPO_PLAYER = "Player"
const GRUPO_ENEMIGO = "Enemigo"
const GRUPO_DEAD = "DEAD"

const FIRE_RATE_SILENCER:float = 2.0
const FIRE_RATE_MACHINE:float = 7.0
const FIRE_RATE_GUN:float = 0.5

export(NodePath) var _camera_path
onready var _Camera := get_node(_camera_path)
onready var _Mira := ($Mira)
onready var _Player := ($CollisionShape2D)
onready var _Arma := ($CollisionShape2D/Arma)
onready var _LineaDisparo := ($LineaDisparo)
onready var _Sprite := ($CollisionShape2D/Personaje)
onready var _Anim := ($AnimationTree)
onready var _State_machine = _Anim.get("parameters/playback")
onready var _playBack = _Anim.get("parameters/playback")
onready var _visibilityEnabler :=  ($VisibilityEnabler2D)

var vfx_muro := preload( "res://VFX/vfx_Muro.tscn")
var vfx_blood := preload( "res://VFX/vfx_Blood.tscn")

var _velocity: Vector2 = Vector2()
var _global_mouse_pos:Vector2 = Vector2()
var _current_state:String = ""
var _current_TIPO_DISFRAZ = TipoDisfraz.NA
var _current_TIPO_DISFRAZ_name = ""
var _can_shoot:bool = true
var _is_armed_type:int = 0
var _next_Time_To_Fire:float = 0.0 
var _zoom_old_position := Vector2.ZERO
onready var _CROSS_DIST_MAX :int = CROSS_DIST_MAX

var _NPC_Target = null
var _NPC_Tick_Time:float
var _NPC_Tick_Time_Manual_Fire:float
var _old_NPC_Target_pos = null

var _setup_NPC_mira_pos = null
var _setup_NPC_player_rot = null
var _IS_NPC_DETECT_ENEMY:bool = false
var _IS_NPC_ENEMY_FACING:bool = false
var _IS_NPC_ARMED:bool = false

var _SELECTOR_Body = null

var on_NPC_ALERT_:bool = false
var tipo_NPC_ALERT:int = Utils.ALERTAS.NA
var posicion_NPC_ALERT:Vector2 = Vector2.ZERO

var INSTANCE_ID=-1

func _ready():
	INSTANCE_ID = self.get_instance_id()
	_Anim.active = true
	yield(get_tree(),"idle_frame")
	set_disfraz_base()
	AjustarEntidad()
	
	if !VISIVILITY_ENABLER:
		_visibilityEnabler.process_parent = false
		_visibilityEnabler.physics_process_parent = false
	
	if IS_NPC:
		SetupNPC()
	else:
		SetupPlayer()
	
	SubscribirEventos()

func _unhandled_input(event):
	if !IS_NPC:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_global_mouse_pos += event.relative

func _physics_process(delta):
	_current_state = _playBack.get_current_node()	
	update()
	InternalProcess(delta)
	update_State()
	_global_mouse_pos = Vector2.ZERO
	
func AjustarEntidad()->void:
	_Player.rotation_degrees = global_rotation_degrees
	var p = _Mira.global_position
	global_rotation_degrees = 0
	_Mira.global_position  = p
	
	_setup_NPC_mira_pos = _Mira.global_position
	_setup_NPC_player_rot = _Player.rotation
	
	if FLIP_FIRE_TO_LEFT_ARM:
		_Player.scale.y = -1

func PosicionOriginal()->void:
	_Mira.global_position = _setup_NPC_mira_pos
	_Player.rotation = _setup_NPC_player_rot

func InternalProcess(delta)->void:
	if !IS_DEAD:
		if IS_NPC:
			NPC_Process(delta)
		else:
			PLAYER_Process(delta)
			#Utils.Invoke(Events.SIGNAL_CAMARA_MOVED,self,[global_position,_Mira.global_position])
		get_action()
		
		NPC_ALERT_PROCESS()
		
		if IS_TELEKINESIS:
			Save_State_Telekinesis()

func PLAYER_Process(delta)->void:
	aim_player()
	move_crosshair(delta)
	move_player(delta)

func update_State()-> void:
	if IS_NPC or !SHOW_CROSS_HAIR:
		_Mira.visible = false
	else:
		_Mira.visible = true

	var isWalk:bool = false
	var _vel:float = abs(_velocity.length())
	
	if _vel > 0.1:
		isWalk = true
	
	var isReload:bool = false
	var isHold:bool  = false
	
	if IS_DEAD:
		_playBack.travel("Dead")
	else:
		_Anim["parameters/conditions/isReload"] = isReload
		
		_Anim["parameters/conditions/isGun"] = TIPO_ARMA == TipoArma.Gun
		_Anim["parameters/conditions/isMachine"] = TIPO_ARMA == TipoArma.Machine
		_Anim["parameters/conditions/isSilencer"] = TIPO_ARMA == TipoArma.Silencer
		
		_Anim["parameters/conditions/isArmed"] = IS_ARMED
		_Anim["parameters/conditions/isNotArmed"] = !IS_ARMED
	
		_Anim["parameters/conditions/isIdle"] = !isWalk
		_Anim["parameters/conditions/isWalk"] = isWalk
		
		_Anim["parameters/conditions/isHold"] = isHold
		_Anim["parameters/conditions/isNotHold"] = !isHold

func move_player(delta)-> void:
	var dir:Vector2 = Vector2.ZERO
	
	if !IS_NPC:
		dir = get_input()
	
	dir = dir.normalized()
	var vel:Vector2 = dir * SPEED
	_velocity = _velocity.linear_interpolate(vel,delta*ACCEL)
	
	if IS_NPC:
		_velocity = move_and_slide(_velocity)
	else:
		if HOLD_CROSS_HAIR_X || HOLD_CROSS_HAIR_Y:
			var old_pos:Vector2 = _Mira.get_global_transform().origin
			_velocity = move_and_slide(_velocity)
			old_pos = old_pos - _Mira.get_global_transform().origin
			if HOLD_CROSS_HAIR_X:
				_Mira.position.x += old_pos.x
			if HOLD_CROSS_HAIR_Y:
				_Mira.position.y += old_pos.y
		else:
			_velocity = move_and_slide(_velocity)

func aim_player()-> void:
	var current_pos:Vector2 = _global_mouse_pos
	var current_cross_pos:Vector2 = _Mira.position
	current_pos += current_cross_pos
	var vect_rot:Vector2 =  current_pos - _Player.position
	var ang:float = vect_rot.angle()
	_Player.set_rotation(ang)

var _camera_offset := Vector2.ZERO

func move_crosshair(delta)-> void:
	var current_cross_pos:Vector2 = _Mira.position
	var current_pos:Vector2 = _global_mouse_pos * MOUSE_SEN
	current_pos += current_cross_pos
	current_pos = current_pos
	current_cross_pos = current_cross_pos.linear_interpolate(current_pos,delta*CROSS_ACCEL)
	current_cross_pos = current_cross_pos.clamped(_CROSS_DIST_MAX)
	_Mira.position = current_cross_pos
	
	if _Camera:
		if Input.is_action_just_pressed("FreeCamara"):
			_zoom_old_position = _Mira.position
			_CROSS_DIST_MAX = ZOOM_CROSS_DIST_MAX
		elif  Input.is_action_just_released("FreeCamara"):
			_CROSS_DIST_MAX = CROSS_DIST_MAX
			_Mira.position = _zoom_old_position
			_camera_offset = Vector2.ZERO

		if  Input.is_action_pressed("FreeCamara"):
			_camera_offset = _Mira.position

		_Camera.offset = _Camera.offset.linear_interpolate(_camera_offset,0.1)

func get_input() -> Vector2:
	var dir:Vector2 = Vector2()
	if Input.is_action_pressed("Up"):
		dir.y = -1
	if Input.is_action_pressed("Down"):
		dir.y = 1 
	if Input.is_action_pressed("Right"):
		dir.x = 1
	if Input.is_action_pressed("Left"):
		dir.x = -1
	return dir

func get_action()->void:
	if IS_NPC:
		get_action_NPC()
	else:
		get_action_player()

func get_action_NPC()->void:
	pass

func get_action_player() -> void:
	if Input.is_action_just_pressed("Option"):
		SeleccionarArma()
	
	if Input.is_action_just_pressed("Interactive"):
		if _current_TIPO_DISFRAZ != TIPO_DISFRAZ:
			set_disfraz(TIPO_DISFRAZ)
		else:
			set_disfraz_base()
	
	if Input.is_action_just_pressed("Telekinesis"):
		Telekinesis()
			
	
	if Input.is_action_just_pressed("Action"):
		if !IS_ARMED:
			HOLD_CROSS_HAIR_X = !HOLD_CROSS_HAIR_X
			HOLD_CROSS_HAIR_Y = !HOLD_CROSS_HAIR_Y
	
	if Input.is_action_pressed("Action"):
		Shoot()
	else:
		ReleaseShoot()

func ReleaseShoot()->void:
	_can_shoot = true

func Shoot() -> void:
	
	if !IS_ARMED:
		pass
	elif TIPO_ARMA != TipoArma.NA:
		if TIPO_ARMA == TipoArma.Melee:
			_can_shoot = false
			pass
		else:
			
			if TIPO_ARMA != TipoArma.Gun:
				if OS.get_ticks_msec() >= _next_Time_To_Fire:
					_can_shoot = true

			var isShoot:bool = _can_shoot
			if isShoot:
				_can_shoot = false
				var origen:Vector2 = _Arma.global_position
				var target:Vector2
				
				if IS_NPC:
					if _NPC_Target:
						target = _NPC_Target.global_position
				else:
					target = _Mira.global_position
				
				target = (target - origen) * 100
				
				if SHOW_BULLET_LINE:
					_LineaDisparo.clear_points()
					_LineaDisparo.add_point(transform.xform_inv(origen))
				
				var space_state = get_world_2d().direct_space_state
				var result = space_state.intersect_ray(origen,target,[self],collision_mask)
				if result:
					if SHOW_BULLET_LINE:
						_LineaDisparo.add_point(transform.xform_inv(result.position))
					ManejarColision(result)
				else:
					if SHOW_BULLET_LINE:
						_LineaDisparo.add_point(transform.xform_inv(target))
				
				if SHOW_BULLET_LINE:
					RemoverTraza()
				
				_Arma.Shoot()
				
				if TIPO_ARMA == TipoArma.Silencer:
					_next_Time_To_Fire = OS.get_ticks_msec() + 1000/FIRE_RATE_SILENCER
				elif TIPO_ARMA == TipoArma.Machine:
					_next_Time_To_Fire = OS.get_ticks_msec() + 1000/FIRE_RATE_MACHINE

func RemoverTraza()->void:
	yield(get_tree().create_timer(0.03), "timeout")
	_LineaDisparo.clear_points()

func SeleccionarArma()-> void:
	if TIPO_ARMA != TipoArma.NA:
		IS_ARMED = !IS_ARMED
	else:
		IS_ARMED = false
	
	if !IS_ARMED:
		HOLD_CROSS_HAIR_X = false
		HOLD_CROSS_HAIR_Y = false

func set_disfraz_base()->void:
	set_disfraz(TIPO_DISFRAZ_BASE)

func set_disfraz(value)->void:
	if _current_TIPO_DISFRAZ != value:
		if is_in_group(_current_TIPO_DISFRAZ_name):
			remove_from_group(_current_TIPO_DISFRAZ_name)
		_current_TIPO_DISFRAZ = value
		var nombre = TipoDisfraz.keys()[value]
		_current_TIPO_DISFRAZ_name = nombre
		add_to_group(_current_TIPO_DISFRAZ_name)
		var anim = "../AnimationPlayer"+nombre
		_Anim.active = false
		_Anim.set_animation_player(anim)
		_Anim.active = true
		_playBack = _Anim.get("parameters/playback")

func Hit(valor,posicion,normal)->void:	
	if LIVE > 0:
		LIVE = max(LIVE - valor,0)
		show_VFX_blood(posicion,normal)
		if LIVE == 0:
			IS_DEAD = true
			Disable()
			if IS_CURRENT_PLAYER:
				yield(get_tree().create_timer(2.0),"timeout")
				Utils.Invoke(Events.SIGNAL_PLAYER_DEAD,self)
			else:
				Utils.Invoke(Events.SIGNAL_NPC_ALERT,self,[Utils.ALERTAS.NPC_DEAD,position])
				SelfRemove(true,2.0)

func ManejarColision(result:Dictionary)->void:
	if result:
		#var x = get_tree().has_group(GROUPO_ENEMIGO)
		#print(x)
		var a = result.position
		var n:Vector2 = result.normal 
		var b = result.collider
		#var c = b.is_in_group(GROUPO_ENEMIGO)
		#if c:
		if b:
			if b.has_method("Hit"):
				b.Hit(HIT_VALUE,a,n)
			else:
				show_VFX_muro(a,n)

		#get_tree().call_group("my_group","my_function",args...)
		#var my_group_members = get_tree().get_nodes_in_group("my_group")
		#for member in get_tree().get_nodes_in_group("my_group"):
		#member.my_function(args...)
		pass

func show_VFX_muro(posicion:Vector2,normal:Vector2):
	var vfx:Particles2D = vfx_muro.instance()
	show_VFX(vfx,posicion,normal)

func show_VFX_blood(posicion:Vector2,normal:Vector2):
	var vfx:Particles2D = vfx_blood.instance()
	show_VFX(vfx,posicion,normal)

func show_VFX(vfx:Particles2D,posicion:Vector2,normal:Vector2):
	vfx.position = posicion
	vfx.process_material.direction = Vector3(normal.x,normal.y,0)
	get_parent().add_child(vfx)
	vfx.emitting = true

func Disable()->void:
	SHOW_FIELD_VIEW = false
	SHOW_HELP_LASER = false
	add_to_group(GRUPO_DEAD)
	if is_in_group(GRUPO_ENEMIGO):
		remove_from_group(GRUPO_ENEMIGO)
	if is_in_group(GRUPO_PLAYER):
		remove_from_group(GRUPO_PLAYER)
	collision_layer = 512

func SelfRemove(isDelay:bool=false,delay:float=1.0)->void:
	if isDelay:
		yield(get_tree().create_timer(delay),"timeout")
	get_parent().remove_child(self)
	queue_free()

func SetupNPC()->void:
	add_to_group(GRUPO_ENEMIGO)
	collision_mask = 7
	collision_layer = 2
	$NPC/ViewField.global_position = global_position
	$NPC/ViewField/CollisionShape2D.shape.radius = FIELD_VIEW_LENGHT
	$NPC/ViewField.collision_layer = 0
	$NPC/ViewField.collision_mask = 1
	var selector = $Mira.get_node("Selector") 
	if selector:
		$Mira.remove_child(selector)

func SetupPlayer()->void:
	remove_child($NPC)
	add_to_group(GRUPO_PLAYER)
	collision_mask = 7
	collision_layer = 1
	$Mira/Selector.collision_layer = 0
	$Mira/Selector.collision_mask = 2

func _draw():
	if SHOW_FIELD_VIEW:
		#Draw_Field_View()
		pass
	if SHOW_HELP_LASER:
		if IS_ARMED:
			#Draw_Laser()
			pass

func Draw_Field_View()->void:
	var color = Color(0.0,1.0,0.0,0.5)
	var ang = _Player.rotation_degrees + 90	
	var from = ang - 45
	var to = ang + 45
	draw_circle_arc_poly(transform.xform_inv(global_position),FIELD_VIEW_LENGHT, from, to,color)

func draw_circle_arc_poly( center, radius, angle_from, angle_to, color )->void:
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
		points_arc.push_back(center + Vector2( cos( deg2rad(angle_point) ), sin( deg2rad(angle_point) ) ) * radius)
	draw_polygon(points_arc, colors)

func Draw_Laser()->void:
	var laserColor = Color(1.0,.329,.298,0.1)
	var laserPointColor = Color(1.0,.329,.298,0.5)

	var origen:Vector2 = _Arma.global_position
	var target:Vector2 = _Mira.global_position
	target = (target - origen) * 100
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(origen,target,[self])
	if result:
		target = result.position
	draw_line(transform.xform_inv(origen),transform.xform_inv(target),laserColor,1.5)
	draw_circle(transform.xform_inv(target),2,laserPointColor)

func _on_ViewField_body_entered(body):
	if !_NPC_Target:
		if body:
			if body.is_in_group(GRUPO_PLAYER):
				_NPC_Target = body

func _on_ViewField_body_exited(body):
	if body == _NPC_Target:
		_NPC_Target = null

func NPC_Process(delta)->void:
	var isProcess:bool = false
	var time = OS.get_ticks_msec()
	if time >= _NPC_Tick_Time:
		isProcess = true
	
	if isProcess:
		
		if _NPC_Target:
			if !_IS_NPC_ARMED and _NPC_Target.is_in_group(_current_TIPO_DISFRAZ_name):
				if _IS_NPC_DETECT_ENEMY:
					_IS_NPC_DETECT_ENEMY = false
					PosicionOriginal()
			else:
				_IS_NPC_DETECT_ENEMY = true
	
	if isProcess:
		NPC_Static()
	
	if _IS_NPC_ENEMY_FACING:
		NPC_Aim(delta,isProcess)
	
	if isProcess:
		NPC_Shoot()
	
	if isProcess:
		time = OS.get_ticks_msec()
		_NPC_Tick_Time = time + 1000 * NPC_THINK_TIME

func NPC_Static()->void:
	if _NPC_Target and _IS_NPC_DETECT_ENEMY:
		#Facing Direction
		var origen:Vector2 = position
		var target:Vector2 = _NPC_Target.position
		var dir_view  = target - origen
		var x = _Player.transform.x
		var fA:Vector2 = x
		var dir_view_norm = dir_view.normalized()
		var view = dir_view_norm.dot(fA)
		#var ang = rad2deg(acos(view))
		var isView = view > FIELD_VIEW_RAY_ANG1 #+-(50°)
		var isView2 = view > FIELD_VIEW_FANCING_ANG2 # <10°
		var dir_lenght = dir_view.length()
		var isLenght = dir_lenght < FIELD_VIEW_LENGHT
		
		var isFieldView1:bool = isView and isLenght
		var isFieldView2:bool = isView2 and isLenght
		
		if isFieldView1:
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(origen,target,[self],collision_mask)
			if result:
				target = result.position
				var b = result.collider
				var isPlayer = b.is_in_group(GRUPO_PLAYER)
				if isPlayer:
					_IS_NPC_DETECT_ENEMY = true
					_IS_NPC_ENEMY_FACING = true
					if view > FIELD_VIEW_FIRE_PLAYER: # entre 5° y 0°
						IS_ARMED = true
						_IS_NPC_ARMED = true
				elif isFieldView2:
					IS_ARMED = true
					_IS_NPC_ARMED = true
					_IS_NPC_DETECT_ENEMY = true
					_IS_NPC_ENEMY_FACING = true
			else:
				_IS_NPC_DETECT_ENEMY = false
		elif isFieldView2:
			_IS_NPC_DETECT_ENEMY = true
			_IS_NPC_ENEMY_FACING = true
		else:
			if _IS_NPC_DETECT_ENEMY:
				_IS_NPC_DETECT_ENEMY = false
				_IS_NPC_ENEMY_FACING = false
				_IS_NPC_ARMED = false
				PosicionOriginal()

func NPC_Aim(delta,isProcess:bool)->void:
		if _NPC_Target:
			if isProcess:
				_old_NPC_Target_pos = _NPC_Target.global_position
			elif !_old_NPC_Target_pos:
				_old_NPC_Target_pos = _NPC_Target.global_position
		
		var to_pos = _old_NPC_Target_pos
		var from_pos = _Mira.global_position
		var pos  = from_pos.linear_interpolate(to_pos,delta*CROSS_ACCEL)
		_Mira.global_position = pos
		
		var dir = pos - global_position
		var rot = (dir).angle()
		_Player.rotation = rot

func NPC_Shoot()->void:
	if _NPC_Target and _IS_NPC_DETECT_ENEMY:
		if IS_ARMED and _IS_NPC_ARMED:
			var is_can_shoot = _can_shoot
			Shoot()
			if is_can_shoot:
				_NPC_Tick_Time_Manual_Fire = OS.get_ticks_msec() + 1000/FIRE_RATE_GUN
			else:
				if TIPO_ARMA == TipoArma.Gun:
					if OS.get_ticks_msec() >= _NPC_Tick_Time_Manual_Fire:
						ReleaseShoot()

func Telekinesis()->void:
	if _SELECTOR_Body:
		if !_SELECTOR_Body.IS_TELEKINESIS:
			if _SELECTOR_Body.has_method("Show_Telekinesis"):
				_SELECTOR_Body.Take_Telekinesis()
		else:
			if _SELECTOR_Body.has_method("Release_Telekinesis"):
				_SELECTOR_Body.Release_Telekinesis()

func Take_Telekinesis()->void:
	if IS_NPC:
		if !IS_TELEKINESIS:
			IS_TELEKINESIS = true
			IS_NPC = false
			Show_Telekinesis()
			$FX_Timer.stop()
			$FX_Timer.wait_time = FX_TELEKINESIS_TIME
			$FX_Timer.start()

func Show_Telekinesis(isShow=true):
	if isShow:
		_Sprite.self_modulate = Color("cf129aec")
	else:
		_Sprite.self_modulate = Color.white

func Release_Telekinesis()->void:
	if !IS_CURRENT_PLAYER:
		if IS_TELEKINESIS:
			IS_TELEKINESIS = false
			IS_NPC = true
			Show_Telekinesis(false)

func Save_State_Telekinesis()->void:
	_setup_NPC_mira_pos = _Mira.global_position
	_setup_NPC_player_rot = _Player.rotation

func _on_Selector_SelectItem(body):
	_SELECTOR_Body = body

func _on_FX_Timer_timeout():
	Release_Telekinesis()

func NPC_ALERT_PROCESS()->void:
	if on_NPC_ALERT_:
		on_NPC_ALERT_ = false
		print(INSTANCE_ID," -> off_alerta")

func _on_NPC_ALERT_PROCESS(alerta:int,posicion:Vector2)->void:
	on_NPC_ALERT_ = true
	match(alerta):
		Utils.ALERTAS.NPC_DEAD:
			tipo_NPC_ALERT = alerta
			posicion_NPC_ALERT = posicion
			_IS_NPC_ARMED = true
			print(INSTANCE_ID," -> on_alerta:",alerta,posicion)

func SubscribirEventos()->void:
	if IS_NPC:
		Utils.Subscribir(Events.SIGNAL_NPC_ALERT,self,"_on_NPC_ALERT_PROCESS")

func _on_ViewField_mouse_entered():
	pass # Replace with function body.

func _on_ViewField_mouse_exited():
	pass # Replace with function body.
