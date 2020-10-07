extends WeaponBase
#Clase que define un arma de fuego del tipo revolver de alta potencia
class_name GunWeapon

func _init_entity():
	amount_gun_charger = 0
	amount_charger_bullets = 6
	fire_rate = 30
	recharger_time = 0
	fire_spread_bullets = 1
	bullet_amount_damange = 70
	._init_entity()
