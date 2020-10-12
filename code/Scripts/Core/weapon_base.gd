extends EntityBase
#Clase base de gestion de armas de fuego
class_name WeaponBase

signal weapon_fired(amuount, damage)
# warning-ignore:unused_signal
signal weapon_reloaded()
# warning-ignore:unused_signal
signal weapon_empty()

export(int) var amount_gun_charger = 1
export(int) var amount_charger_bullets = 10
#RPM
export(float) var fire_rate = 60
#Segundos
export(float) var recharger_time = 1.0
#Cantidad de munisiones en cada disparo
export(float) var fire_spread_bullets = 1
#Daño de dado por cada proyectil
export(float) var bullet_amount_damange = 10

var remain_bullets : int = 0
var remain_chargers : int = 0

var is_empty:bool = false

var co_reload_wait = null
var counter_recharger_time:float = 0.0

func _ready():
	remain_bullets = amount_charger_bullets
	remain_chargers = amount_gun_charger

func _process(delta):
	if co_reload_wait and co_reload_wait.is_valid():
		counter_recharger_time = counter_recharger_time + delta
		if counter_recharger_time > recharger_time:
			counter_recharger_time = 0
			co_reload_wait.resume()

func fire():
	if !co_reload_wait or !co_reload_wait.is_valid():
		if remain_bullets > 0:
			emit_signal("weapon_fired",fire_spread_bullets,bullet_amount_damange)
			remain_bullets = remain_bullets - 1
		else:
			co_reload_wait = co_reload()

func co_reload():
	if remain_chargers > 0:
		yield()
		remain_chargers = remain_chargers - 1
		remain_bullets = amount_charger_bullets
		emit_signal("weapon_reloaded")
	else:
		is_empty = true
		emit_signal("weapon_empty")
	co_reload_wait = null

