extends Spatial

const _materials = [
	preload("./opaque_color_material.tres"),
	preload("./transparent_color_material.tres")
]

var _mesh_instance : MeshInstance
var _mesher = VoxelMesherCubes.new()


func _ready():
	_mesh_instance = MeshInstance.new()
	add_child(_mesh_instance)

	var voxels = VoxelBuffer.new()
	voxels.set_channel_depth(VoxelBuffer.CHANNEL_COLOR, VoxelBuffer.DEPTH_8_BIT)
	var palette = VoxelColorPalette.new()
	
	var loader = VoxelVoxLoader.new()
	var err = loader.load_from_file("res://vox/monu1.vox", voxels, palette)
	if err != OK:
		push_error(str("Error: ", err))
		return

	_mesher.palette = palette
	_mesher.color_mode = VoxelMesherCubes.COLOR_MESHER_PALETTE
	
	# Padding of 1 voxel required for now, a bit verbose but quite simple.
	var padded_voxels = VoxelBuffer.new()
	padded_voxels.create(
		voxels.get_size().x + 2, 
		voxels.get_size().y + 2, 
		voxels.get_size().z + 2)
	padded_voxels.set_channel_depth(
		VoxelBuffer.CHANNEL_COLOR, voxels.get_channel_depth(VoxelBuffer.CHANNEL_COLOR))
	padded_voxels.copy_channel_from_area(
		voxels, Vector3(), voxels.get_size(), Vector3(1, 1, 1), VoxelBuffer.CHANNEL_COLOR)

	var mesh = _mesher.build_mesh(padded_voxels, _materials)

	_mesh_instance.mesh = mesh
