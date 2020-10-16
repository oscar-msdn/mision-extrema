extends Line2D
class_name Laser
const TipoColor = {
	ROJO = Color.red * 1.5,
	BLANCO = Color.white * 1.5,
	VERDE = Color.green * 1.5,
	AZUL = Color.blue * 1.5,
	AMARILLO = Color.yellow * 1.5
}

func _init():
	set_width(2.0)
	set_max_light(10.0)
	set_color(TipoColor.ROJO)
	add_point(position)
	add_point(position)
	
func set_origin(value:Vector2):
	set_point_position(0,value)
	
func set_target(value:Vector2):
	set_point_position(1,value)

func set_width(value):
	width = value

func set_max_light(value):
	modulate *= value

func set_color(color:Color):
	modulate = color

