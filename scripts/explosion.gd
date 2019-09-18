extends Sprite

# Función de explosión instántanea para la colisión del proyectil.
func explotar():
	$anim.play("explode")
	get_parent().get_node("Explode").play()