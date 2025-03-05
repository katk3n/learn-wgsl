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

fn xy2pol(xy: vec2<f32>) -> vec2<f32> {
    return vec2(atan2(xy.y, xy.x), length(xy));
}

fn pol2xy(pol: vec2<f32>) -> vec2<f32> {
    return pol.y * vec2(cos(pol.x), sin(pol.x));
}

fn tex(in: vec2<f32>) -> vec3<f32> {
    let PI = 3.1415926;
    let t = 0.2 * time.duration;
    var st = in;
    let circ = vec3(pol2xy(vec2(t, 0.5)) + 0.5, 1.0);
    var col3 = array(circ.rgb, circ.gbr, circ.brg);
    st.x = st.x / PI + 1.0;
    st.x += t;
    let ind = i32(st.x);
    let col = mix(col3[ind % 2], col3[(ind + 1) % 2], fract(st.x));
    return mix(col3[2], col, st.y);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    var pos = in.position.xy / window.resolution.xy;
    pos = 2.0 * pos.xy - vec2(1.0);
    pos = xy2pol(pos);
    return vec4(to_linear_rgb(tex(pos)), 1.0);
}
