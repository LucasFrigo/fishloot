extends Camera3D

@export var fixed_rotation_angle := Vector3(-45, 45, 0) 


func _process(delta: float) -> void:
    global_rotation_degrees = fixed_rotation_angle
