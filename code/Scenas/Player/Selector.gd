extends Area2D

signal SelectItem(body)

func _on_Selector_body_entered(body):
	$Label.visible = true
	emit_signal("SelectItem", body)

# warning-ignore:unused_argument
func _on_Selector_body_exited(body):
	$Label.visible = false
	emit_signal("SelectItem", null)
