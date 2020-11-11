extends Sprite

signal entity_over(body)
signal entity_exit(body)

func _ready():
	z_index = Util.ZINDEX_CURSOR
	z_as_relative = false
	_ready_()

func _ready_():	
	$Area2D.collision_layer = Util.LAYER_CURSOR
	$Area2D.collision_mask  = Util.MASK_CURSOR

func _on_Area2D_body_entered(body):
	emit_signal("entity_over",body)

func _on_Area2D_body_exited(body):
	emit_signal("entity_exit",body)

const TipoColor = {
	ROJO = Color.red,
	BLANCO = Color.white,
	VERDE = Color.green,
	AZUL = Color.blue,
	AMARILLO = Color.yellow
}

func restore_color():
	modulate = TipoColor.BLANCO

func set_change_color(color):
	modulate = color 
