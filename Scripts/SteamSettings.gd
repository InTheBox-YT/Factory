extends Node

var AppID = "480"

func _init() -> void:
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)

func _ready() -> void: 
	Steam.steamInit()
	var isRunning = Steam.isSteamRunning()
	
	if !isRunning:
		print("STEAM AINT RUNNING HOMEBOY!")
		return
	
	print("Steam running gng you good")
	
	var id = Steam.getSteamID()
	var name = Steam.getFriendPersonaName(id)
	print("Hood Name: ", str(name))
