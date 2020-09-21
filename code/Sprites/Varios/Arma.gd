extends Position2D

onready var _Muzzle = ($AnimationPlayer)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Shoot()->void:
	_Muzzle.play("Muzzle")
