#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

struct CustomMaterial {
    resolution: vec2<f32>
};

@group(1) @binding(0)
var<uniform> material: CustomMaterial;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let pos = in.position.xy / material.resolution;

    let RED = vec3(1.0, 0.0, 0.0);
    let BLUE = vec3(0.0, 0.0, 1.0);
    let col = mix(RED, BLUE, pos.x);

    return vec4(col, 1.0);
}