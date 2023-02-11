extends Node

onready var lmg :PackedScene = preload("res://Scenes/Player/Weapons/lmg.tscn")
onready var lmg_pickup :PackedScene = preload("res://Scenes/Player/Weapons/pickups/lmg_pickup.tscn")
onready var lmg2 :PackedScene = preload("res://Assets/Models/weapons/lmg2/lmg2.tscn")
onready var lmg2_pickup :PackedScene = preload("res://Assets/Models/weapons/lmg2/lmg2_pickup.tscn")
onready var airplanegun : PackedScene = preload("res://Scenes/Player/Weapons/AirPlane.tscn")
onready var airplanegun_pickup : PackedScene = preload("res://Scenes/Player/Weapons/pickups/airplaneGun_pickup.tscn")



onready var smg1 : PackedScene = preload("res://Assets/Models/weapons/smg1/smg1.tscn")
onready var smg1_pickup : PackedScene = preload("res://Assets/Models/weapons/smg1/smg1_pickup.tscn")
onready var shotty1 : PackedScene = preload("res://Assets/Models/weapons/shotty1/shotty1.tscn")
onready var shotty1_pickup : PackedScene = preload("res://Assets/Models/weapons/shotty1/shotty1_pickup.tscn")

onready var sniper1 : PackedScene = preload("res://Assets/Models/weapons/sniper1/sniper1.tscn")
onready var sniper1_pickup : PackedScene = preload("res://Assets/Models/weapons/sniper1/sniper1_pickup.tscn")
onready var weapons = {"primary": null, "secondary": null}
onready var weaponslist = {"lmg": {"scene": lmg, "pickupscene": lmg_pickup},"lmg2": {"scene": lmg2, "pickupscene": lmg2_pickup}, "airplanegun": {"scene": airplanegun, "pickupscene": airplanegun_pickup}, "smg1": {"scene": smg1, "pickupscene": smg1_pickup}, "sniper1": {"scene": sniper1, "pickupscene": sniper1_pickup}
,"shotty1": {"scene": shotty1, "pickupscene": shotty1_pickup}}

onready var primary_changed = false
onready var secondary_changed = false






func get_spray(weapon):

	match str(weapon):
		"lmg": 
			return [[0,0],[0.8,0.9],[1,1.2],[1.6,1.8],[2,3],[2,3],[2,3],[2,3],[2,3],[rand_range(-1.4,10),rand_range(-1.4,10)]]
		"lmg2":
			return [[0,0],[0.8,0.9],[1,1.2],[1.6,1.8],[2,3],[2,3],[2,3],[2,3],[2,3],[rand_range(-1.4,10.6),rand_range(-1.4,10.6)]]
		"smg1":
			return [[0,0],[rand_range(-0.7,1.3),rand_range(-0.7,5)],[rand_range(-0.7,4.3),rand_range(-0.7,5)],[0.8,0.9],[1,1.5],[1,1.5],[1,1.5],[1,1.5],[1,1.5],[rand_range(-0.7,1.3),rand_range(-0.7,1.3)]]
		"shotty":
			return [[0,0],[0.4,0.45],[0.5,0.6],[0.8,0.9],[1,1.5],[1,1.5],[1,1.5],[1,1.5],[1,1.5],[rand_range(-0.7,1.3),rand_range(-0.7,1.3)]]
		"sniper1":
			return [[0,0],[rand_range(20,30),rand_range(20,30)]]



func add_primary(weapon):
	if str(weapon) in weaponslist:
		weapons["primary"] = str(weapon)
		
		
	
func add_secondary(weapon):
	if str(weapon) in weaponslist:
		weapons["secondary"] = str(weapon)
	
	

func get_primary():
	if weapons["primary"] != null:
		return weaponslist[str(weapons["primary"])]["scene"].instance()
	return null
	

func get_secondary():
	if weapons["secondary"] != null:
		return weaponslist[str(weapons["secondary"])]["scene"].instance()
	return null
	
	
	
func get_primary_pickup():
	if weapons["primary"] != null:
		return weaponslist[str(weapons["primary"])]["pickupscene"].instance()
	return null
	
func get_secondary_pickup():
	if weapons["primary"] != null:
		return weaponslist[str(weapons["secondary"])]["pickupscene"].instance()
	return null
	
func get_weapon_pickup(gun):
	
	return weaponslist[str(gun)]["pickupscene"].instance()
	

func get_weapons():
	return weapons
