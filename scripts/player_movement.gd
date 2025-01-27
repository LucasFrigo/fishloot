extends Node3D

@onready var player_nav_agent := $NavigationAgent3D

func _ready() -> void:
    pass 


func _process(delta: float) -> void:
    pass

func _input(event):
    if Input.is_action_just_pressed("left_mouse"):
        var player_cam := $Camera3D 
        var mouse_pos = get_viewport().get_mouse_position()
        
        # Ray properties
        var ray_length = 1000
        var ray_origin = player_cam.project_ray_origin(mouse_pos)
        var ray_direction = player_cam.project_ray_normal(mouse_pos)
        var ray_destiny = ray_origin + ray_direction * ray_length
        
        var space = get_world_3d().direct_space_state
        var ray_query = PhysicsRayQueryParameters3D.new()
        
        # Configure ray query
        ray_query.from = ray_origin
        ray_query.to = ray_destiny
        ray_query.collide_with_areas = true  
        ray_query.collide_with_bodies = true 
        # Set a different collision layer
        # ray_query.collision_mask = 1

        var ray_result = space.intersect_ray(ray_query)

        if ray_result:
            print("Hit: ", ray_result.position)
            player_nav_agent.target_position = ray_result.position
