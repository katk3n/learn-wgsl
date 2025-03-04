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
    var pos = in.position.xy / window.resolution.xy;

    // this variable needs to be `var`, not `let`
    // `let` causes "may only be indexed by a constant" error
    // https://users.rust-lang.org/t/wgsl-index-array-w-varlable/98146
    var col3 = array(
        vec3(1.0, 0.0, 0.0),
        vec3(0.0, 0.0, 1.0),
        vec3(0.0, 1.0, 0.0)
    );
    pos.x *= 2.0;
    let ind = u32(pos.x);

    // fract(x) = x - floor(x)
    // e.g. fract(2.3) = 0.3, fract(-1.8) = 0.2
    let col = mix(col3[ind], col3[ind + 1], fract(pos.x));
    return vec4(to_linear_rgb(col), 1.0);
}
