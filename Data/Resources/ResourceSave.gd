extends Resource

const SAVE_GAME_PATH := "res://Data/PlayerSave.tres" # for final build use user://

export var character : Resource


func write_savegame() -> void:
	ResourceSaver.save(SAVE_GAME_PATH, self)

static func load_savegame() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
