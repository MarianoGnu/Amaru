
extends Node

const none = 0

#region player
const walk_speed = 120
const run_speed = 200
const acceleration = 300
const gravity = 300
const jump_impulse = [-200,-300]
const climb_speed = 80

#enums (do not touch)
#-directions
const right=1
const left=-1
#-enemies
const state_patrol = 0
const state_attack = 1
#-items
const craneo = 0
const colibri = 1
const garra = 2
const serpiente = 3
const alas_pajaro = 4
const cola_pez = 5
const flor = 6
const stone = 7
const thunder = 8
const items_name = ["craneo,colibri,garra,serpiente,alas de pajaro,cola de pez,flor,piedra,rayo"]