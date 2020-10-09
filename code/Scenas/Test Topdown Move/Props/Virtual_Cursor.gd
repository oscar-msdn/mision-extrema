extends Sprite

signal entity_over(body)
signal entity_exit(body)


func _on_Area2D_body_entered(body):
	emit_signal("entity_over",body)


func _on_Area2D_body_exited(body):
	emit_signal("entity_exit",body)
