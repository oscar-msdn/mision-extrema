extends KinematicBody2D
#Clase base para cualquier entidad
class_name EntityBase

export(bool) var enable_laser : bool = false

var is_update_draw: bool = false

#
#func _ready():
#	pass
#
#func _process(delta):
#	pass
#

func draw_Laser(origin, target)->void:
	if enable_laser:
		var laserColor = Color(1.0,.329,.298,0.1)
		var laserPointColor = Color(1.0,.329,.298,0.5)
		target = (target - origin ) * 100
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(origin,target,[self])
		if result:
			target = result.position
		draw_line(transform.xform_inv(origin),transform.xform_inv(target),laserColor,1.5)
		draw_circle(transform.xform_inv(target),2,laserPointColor)

# warning-ignore:unused_argument
func _physics_process(delta):
	if enable_laser:
		if is_update_draw:
			is_update_draw = false
			update()
