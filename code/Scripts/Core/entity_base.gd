extends KinematicBody2D
#Clase base para cualquier entidad
class_name EntityBase

#func _ready():
#	pass

#func _process(delta):
#	pass

var segment = SegmentShape2D.new()
var query = Physics2DShapeQueryParameters.new()
func fire_shoot_raycast(origin,target,damage=100,max_hits=4) -> void:
	target = (target - origin) * 100
	segment.set_a(origin)
	segment.set_b(target)
	var space_state = get_world_2d().direct_space_state
	query.set_shape(segment)
	var hits = space_state.intersect_shape(query, max_hits)
	if hits:
		var shield := 0
		var body = null
		var current_damage = damage
		for hit in hits:
			body = hit.collider
			if body:
				if body.has_method("get_shield"):
					shield = body.get_shield()
					if body.has_method("give_damage"):	
						body.give_damage(current_damage,hit.position)
						current_damage -= shield
						if current_damage <= 0:
							break

func raycast(origin,target,group) -> bool:
	target = (target - origin ) * 100
	var direct_space = get_world_2d().direct_space_state
	var hit = direct_space.intersect_ray(origin,target,[self])
	if hit:
		var body = hit.collider
		if body:
			var result = body.is_in_group(group)
			return result
	return false

#func _physics_process(delta):
#	pass


