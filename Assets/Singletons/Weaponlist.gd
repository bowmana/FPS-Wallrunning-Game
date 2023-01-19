extends Node

onready var lmg :PackedScene = preload("res://Scenes/Player/Weapons/lmg.tscn")
onready var lmg_pickup :PackedScene = preload("res://Scenes/Player/Weapons/pickups/lmg_pickup.tscn")
onready var lmg2 :PackedScene = preload("res://Scenes/Player/Weapons/lmg2.tscn")
onready var lmg2_pickup :PackedScene = preload("res://Scenes/Player/Weapons/pickups/lmg2_pickup.tscn")
onready var airplanegun : PackedScene = preload("res://Scenes/Player/Weapons/AirPlane.tscn")
onready var airplanegun_pickup : PackedScene = preload("res://Scenes/Player/Weapons/pickups/airplaneGun_pickup.tscn")


onready var weapons = {"primary": null, "secondary": null}
onready var weaponslist = {"lmg": {"scene": lmg, "pickupscene": lmg_pickup},"lmg2": {"scene": lmg2, "pickupscene": lmg2_pickup}, "airplanegun": {"scene": airplanegun, "pickupscene": airplanegun_pickup}}

onready var primary_changed = false
onready var secondary_changed = false


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
