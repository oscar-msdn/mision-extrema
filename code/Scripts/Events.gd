extends Node

signal NPC_ALERT(alerta,posicion)
signal PLAYER_DEAD()
signal CAMARA_MOVED(posicionEntidad,posicionCursor)

const SIGNAL_NPC_ALERT = "NPC_ALERT"
const SIGNAL_PLAYER_DEAD = "PLAYER_DEAD"
const SIGNAL_CAMARA_MOVED = "CAMARA_MOVED"
