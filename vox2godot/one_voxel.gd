extends Node

const Util = preload("res://common/util.gd")

const _materials = [
	preload("./opaque_color_material.tres")
]

onready var _mesh_instance : MeshInstance = $MeshInstance
# This mesher transforms voxels in cubes
var _mesher = VoxelMesherCubes.new()
<<<<<<< HEAD

func _ready():
	var voxels_raw = VoxelBuffer.new()
	voxels_raw.set_channel_depth(VoxelBuffer.CHANNEL_COLOR, VoxelBuffer.DEPTH_8_BIT)
	voxels_raw.create(1, 1, 1)
	voxels_raw.set_voxel(2000000, 0, 0, 0, VoxelBuffer.CHANNEL_COLOR)
	# voxels_raw.fill(1)
	
	print("Voxels raw: ", voxels_raw.get_size())
	print("Voxel raw: ", voxels_raw.get_voxel(1, 1, 1))
	
	var voxels = voxels_raw
	
	_mesher.color_mode = VoxelMesherCubes.COLOR_RAW
=======
var _palette = VoxelColorPalette.new()

func _load_palette():
	_mesher.palette = _palette
	# The first entry in the palette must be Color8(0,0,0,0)
	_mesher.palette.set_color(0, Color8(0,0,0,0))
	_mesher.palette.set_color(1, Color8(238,0,0))
	_mesher.palette.set_color(2, Color8(0,238,0))

func _ready():
	_load_palette()
	var voxels = VoxelBuffer.new()
	voxels.set_channel_depth(VoxelBuffer.CHANNEL_COLOR, VoxelBuffer.DEPTH_8_BIT)
	voxels.create(2, 1, 1)
	voxels.set_voxel(2, 0, 0, 0, VoxelBuffer.CHANNEL_COLOR)
	voxels.set_voxel(1, 1, 0, 0, VoxelBuffer.CHANNEL_COLOR)
	
	print("Voxels raw: ", voxels.get_size())
	print("Voxel raw: ", voxels.get_voxel(1, 1, 1))
	
	_mesher.color_mode = VoxelMesherCubes.COLOR_MESHER_PALETTE
>>>>>>> vox2godot: add two voxels scene
	
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

<<<<<<< HEAD
	print("Padded voxels raw: ", voxels_raw.get_size())
	print("Padded voxel raw: ", voxels_raw.get_voxel(1, 1, 1))
=======
	print("Padded voxels raw: ", voxels.get_size())
	print("Padded voxel raw: ", voxels.get_voxel(1, 1, 1))
>>>>>>> vox2godot: add two voxels scene
	
	var time_before = OS.get_ticks_usec()
	# Create the mesh using the voxels and the materials
	var mesh = _mesher.build_mesh(padded_voxels, _materials)
	print("Spent ", OS.get_ticks_usec() - time_before, " us to mesh", mesh)

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
