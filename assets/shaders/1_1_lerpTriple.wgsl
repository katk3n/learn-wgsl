#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

struct CustomMaterial {
    resolution: vec2<f32>
};

@group(1) @binding(0)
var<uniform> material: CustomMaterial;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var pos = in.position.xy / material.resolution;

    var col3 = array(
        vec3(1.0, 0.0, 0.0),  // RED
        vec3(0.0, 0.0, 1.0),  // BLUE
        vec3(0.0, 1.0, 0.0)   // GREEN
    );

    pos.x *= 2.0;
    let idx1 = u32(pos.x);
    let idx2 = idx1 + u32(1);
    let col = mix(col3[idx1], col3[idx2], fract(pos.x));

    return vec4(col, 1.0);
}
