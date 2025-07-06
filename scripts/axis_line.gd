extends MeshInstance3D

func draw_line(start : Vector3, end : Vector3) -> void:
	var _mesh : ImmediateMesh = mesh
	
	_mesh.clear_surfaces()
	_mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	_mesh.surface_add_vertex(start)
	_mesh.surface_add_vertex(end)

	_mesh.surface_end()

func remove_mesh():
	mesh.clear_surfaces()
