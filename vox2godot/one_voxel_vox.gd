extends Node

# The goal of this script is to create a single Voxel from scratch

const Util = preload("res://common/util.gd")

const _materials = [
	preload("./opaque_color_material.tres")
]

onready var _mesh_instance : MeshInstance = $MeshInstance
# This mesher transforms voxels in cubes
var _mesher = VoxelMesherCubes.new()


func _ready():

	# A VoxelBuffer is always needed to render voxels
	var voxels = VoxelBuffer.new()
	# The VoxelBuffer is organized in channels.
	# A channel has information about the colors for the voxels in it
	# MV uses 8 bits to defind the color from the palette
	voxels.set_channel_depth(VoxelBuffer.CHANNEL_COLOR, VoxelBuffer.DEPTH_8_BIT)
	
	# Vox loader specific code
	# Palette from vox file
	var palette = VoxelColorPalette.new()
	var loader = VoxelVoxLoader.new()
	# The loader loads the voxels and the palette
	var err = loader.load_from_file("res://vox/1x1x1.vox", voxels, palette)
	# var err = loader.load_from_file("res://vox/monu1.vox", voxels, palette)

	if err != OK:
		push_error(str("Error: ", err))
		return

	# palette to be used when converting the voxels to cubes
	_mesher.palette = palette
	# Use the paletter to fill the voxels colors
	_mesher.color_mode = VoxelMesherCubes.COLOR_MESHER_PALETTE
	
	# Pad the voxels so all of them are included
	var padded_voxels = VoxelBuffer.new()
	padded_voxels.create(
		voxels.get_size().x + 2, 
		voxels.get_size().y + 2, 
		voxels.get_size().z + 2)
	padded_voxels.set_channel_depth(
		VoxelBuffer.CHANNEL_COLOR, voxels.get_channel_depth(VoxelBuffer.CHANNEL_COLOR))
	padded_voxels.copy_channel_from_area(
		voxels, Vector3(), voxels.get_size(), Vector3(1, 1, 1), VoxelBuffer.CHANNEL_COLOR)

	var time_before = OS.get_ticks_usec()
	# Create the mesh using the voxels and the materials
	var mesh = _mesher.build_mesh(padded_voxels, _materials)
	print("Spent ", OS.get_ticks_usec() - time_before, " us to mesh")

	# Compute the numer of vertex for debugging purposes
	var vertex_count = 0
	for si in mesh.get_surface_count():
		var arrays = mesh.surface_get_arrays(si)
		var vertices = arrays[Mesh.ARRAY_VERTEX]
		print("Surface ", si, " has ", len(vertices))
		vertex_count += len(vertices)
	print("Vertex count: ", vertex_count)

	# Use then generated mesh inside the existing MeshInstance node
	_mesh_instance.mesh = mesh

func _process(delta):
	#_mesh_instance.rotate_y(delta)
	pass
