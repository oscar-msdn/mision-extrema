extends Node2D

onready var Camara = ($CamaraBase/Camera2D)
onready var CamaraBase = ($CamaraBase)
onready var Minimo = ($Minimo)
onready var Maximo = ($Maximo)

# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.Subscribir(Events.SIGNAL_CAMARA_MOVED,self,"_on_Camera_Moved")
	Camara.limit_top = Minimo.position.y
	Camara.limit_left = Minimo.position.x
	Camara.limit_right = Maximo.position.x
	Camara.limit_bottom = Maximo.position.y

var old_posicionEntidad:Vector2 = Vector2.ZERO
var old_posicionCursor:Vector2 = Vector2.ZERO

func _on_Camera_Moved(posicionEntidad:Vector2,posicionCursor:Vector2):
	if old_posicionEntidad != posicionEntidad:
		old_posicionEntidad = posicionEntidad
		old_posicionCursor = posicionCursor
		CamaraBase.position = posicionEntidad
	elif old_posicionCursor != posicionCursor:
		old_posicionCursor = posicionCursor
		old_posicionEntidad = posicionEntidad
		CamaraBase.position = posicionCursor
