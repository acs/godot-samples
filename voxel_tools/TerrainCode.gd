extends Spatial

const HEIGHT_MAP = preload("res://noise_distorted.png")

var terrain = VoxelTerrain.new()

func _ready():
	terrain.stream = VoxelGeneratorImage.new()
	terrain.stream.image = HEIGHT_MAP
	terrain.view_distance = 256
	terrain.viewer_path = "/root/TerrainCode/Camera"
	add_child(terrain) # Add the terrain to the tree so Godot will render it
