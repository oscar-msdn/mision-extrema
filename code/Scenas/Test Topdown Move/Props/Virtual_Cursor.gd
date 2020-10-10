extends Sprite

signal entity_over(body)
signal entity_exit(body)

export(int) var cursor_layer_collision = 0 setget set_cursor_layer_collision, get_cursor_layer_collision
export(int) var cursor_mask_collision = 0 setget set_cursor_mask_collision, get_cursor_mask_collision

func set_cursor_layer_collision(value):
	cursor_layer_collision = value
	$Area2D.collision_layer = value

func get_cursor_layer_collision() -> int:
	return cursor_layer_collision

func set_cursor_mask_collision(value):
	cursor_mask_collision = value
	$Area2D.collision_mask  = value

func get_cursor_mask_collision() -> int:
	return cursor_mask_collision

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
