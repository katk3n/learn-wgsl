//! A shader that uses dynamic data like the time since startup.
//! The time data is in the globals binding which is part of the `mesh_view_bindings` shader import.

use bevy::{
    prelude::*,
    reflect::{TypePath, TypeUuid},
    render::render_resource::*,
    sprite::{Material2d, Material2dPlugin, MaterialMesh2dBundle},
};

fn main() {
    App::new()
        .add_plugins((
            DefaultPlugins.set(WindowPlugin {
                primary_window: Some(Window {
                    resolution: (800.0, 800.0).into(),
                    ..default()
                }),
                ..default()
            }),
            Material2dPlugin::<CustomMaterial>::default(),
        ))
        .add_systems(Startup, setup)
        .run();
}

fn setup(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<CustomMaterial>>,
    windows: Query<&Window>,
) {
    let window = windows.get_single().unwrap();

    // Quad
    commands.spawn(MaterialMesh2dBundle {
        mesh: meshes
            .add(shape::Quad::new(Vec2::new(window.width(), window.height())).into())
            .into(),
        material: materials.add(CustomMaterial {
            resolution: Vec2::new(
                // It looks like shader treats the window resolution as physical size.
                // See the difference between logical and physical resolutions in bevy:
                // https://docs.rs/bevy/latest/bevy/window/struct.WindowResolution.html
                window.physical_width() as f32,
                window.physical_height() as f32,
            ),
        }),
        transform: Transform::from_translation(Vec3::new(0.0, 0.0, 0.0)),
        ..default()
    });

    // camera
    commands.spawn(Camera2dBundle::default());
}

#[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
#[uuid = "a3d71c04-d054-4946-80f8-ba6cfbc90cad"]
struct CustomMaterial {
    #[uniform(0)]
    resolution: Vec2,
}

impl Material2d for CustomMaterial {
    fn fragment_shader() -> ShaderRef {
        "shaders/1_1_lerpTriple.wgsl".into()
    }
}
