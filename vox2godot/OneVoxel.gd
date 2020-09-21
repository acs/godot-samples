extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# The full process is described in https://github.com/Zylann/godot_voxel/issues/194

# TODO: how this materials are created?
const _materials = [
	preload("./red_material.tres")
]

# From project/blocky_game/generator/test_generator.gd in voxelgame
func _generate():
	var voxels = VoxelBuffer.new()
	voxels.create(16, 16, 16)
	# _generator.generate_block(voxels, _origin, 0)

	var padded_voxels = VoxelBuffer.new()
	padded_voxels.create(
			voxels.get_size().x + 2,
			voxels.get_size().y + 2,
			voxels.get_size().z + 2)
	padded_voxels.copy_channel_from_area(
			voxels, Vector3(), voxels.get_size(), Vector3(1, 1, 1), VoxelBuffer.CHANNEL_TYPE)

	var mesher = VoxelMesherBlocky.new()
	# mesher.set_library(VoxelLibraryResource)
	var mesh = mesher.build_mesh(padded_voxels, _materials)

	$VoxelMesh.mesh = mesh

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create the Voxel and add it to a MeshInstance
	var mesher = VoxelMesherBlocky.new()
	var voxel_buffer = VoxelBuffer.new()
	# TODO: understand this line
	# voxel_buffer.set_channel_depth(VoxelBuffer.CHANNEL_COLOR, VoxelBuffer.DEPTH_8_BIT)
	# voxel_buffer.set_voxel(1, 0, 0, 0, 1)
	voxel_buffer.create(16, 16, 16)
	# mesher.set_library(VoxelLibraryResource)
	var mesh = mesher.build_mesh(voxel_buffer, _materials)
	$VoxelMesh.mesh = mesh
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
