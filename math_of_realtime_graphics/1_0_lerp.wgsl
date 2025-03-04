struct WindowUniform {
    // window size in physical size
    resolution: vec2<f32>,
};

struct TimeUniform {
    // time elapsed since the program started
    duration: f32,
};

struct MouseUniform {
    // mouse position in physical size
    position: vec2<f32>,
};

@group(0) @binding(0) var<uniform> window: WindowUniform;
@group(0) @binding(1) var<uniform> time: TimeUniform;
@group(1) @binding(0) var<uniform> mouse: MouseUniform;

struct VertexOutput {
    @builtin(position) position: vec4<f32>,
};

fn to_linear_rgb(col: vec3<f32>) -> vec3<f32> {
    let gamma = 2.2;
    let c = clamp(col, vec3(0.0), vec3(1.0));
    return vec3(pow(c, vec3(gamma)));
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let pos = in.position.xy / window.resolution.xy;
    let red = vec3(1.0, 0.0, 0.0);
    let blue = vec3(0.0, 0.0, 1.0);
    let col = mix(red, blue, pos.x);
    return vec4(to_linear_rgb(col), 1.0);
}
