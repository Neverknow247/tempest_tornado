extends DirectionalLight3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.player != null:
		look_at(Global.player.global_transform.origin,Vector3.UP)
