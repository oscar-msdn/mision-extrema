extends Node2D

var _Parent

func _ready():
	_Parent = get_parent()

func _physics_process(delta):
	update()

func _draw():
	if _Parent.SHOW_FIELD_VIEW:
		Draw_Field_View()
	if _Parent.SHOW_HELP_LASER:
		if _Parent.IS_ARMED:
			Draw_Laser()

func Draw_Field_View()->void:
	var color = Color(0.0,1.0,0.0,0.2)
	var ang = _Parent._Player.rotation_degrees + 90
	var from = ang - 45
	var to = ang + 45
	draw_circle_arc_poly(_Parent.transform.xform_inv(_Parent.position),_Parent.FIELD_VIEW_LENGHT, from, to,color)

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

	var origen:Vector2 = _Parent._Arma.global_position
	var target:Vector2 = _Parent._Mira.global_position
	target = (target - origen) * 100
	var space_state = get_world_2d().direct_space_state
	if space_state:
		var result = space_state.intersect_ray(origen,target,[_Parent])
		if result:
			target = result.position
	draw_line(_Parent.transform.xform_inv(origen),_Parent.transform.xform_inv(target),laserColor,1.5)
	draw_circle(_Parent.transform.xform_inv(target),2,laserPointColor)
