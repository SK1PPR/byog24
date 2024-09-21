extends Sprite2D

func inside(pos) -> bool:
	return get_rect().has_point(to_local(pos))
