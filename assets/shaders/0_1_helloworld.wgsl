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
    // Note that the origin (0,0) is located at top-left in wgsl,
    // while bottom-left in glsl.
    return vec4(1.0, pos, 1.0);
}
