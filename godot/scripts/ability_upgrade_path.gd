class_name AbilityUpgradePath extends Resource

#this is a dictionary where the Key is the level at which
#the upgrade is unlocked, and the Value is the upgrade to
#be unlocked
@export var upgrades: Dictionary[int, AbilityUpgrade] = {}
