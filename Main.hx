import h3d.prim.Cylinder;
import hxd.Event;
import h3d.prim.Sphere;
import oimo.dynamics.World;
import oimo.common.Vec3;
import oimo.common.MathUtil;
import oimo.dynamics.rigidbody.RigidBodyType;

class Main extends hxd.App {

	var oimo_world : World;
    var light : h3d.scene.pbr.DirLight;
    var obj : h3d.scene.Object;
    var rnd : hxd.Rand;

    override function init() {
        light = new h3d.scene.pbr.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), s3d);
        light.enableSpecular = true;
        light.color.set(0.58, 0.58, 0.58);
        s3d.lightSystem.ambientLight.set(0.74, 0.74, 0.74);

        s3d.camera.zNear = 1;
		s3d.camera.zFar = 500;
		s3d.camera.pos.set(14.98, 46.68, 38.2, 1);
        new h3d.scene.CameraController(s3d).loadFromCamera();
		
		oimo_world = new World(null, new Vec3(0, -9.80665, 0));
		
		// first step, must do before anything else !!!
		OimoUtils.setWorld(oimo_world);

        var ground = new h3d.prim.Cube(20, 20, 2, true);
        ground.addNormals();
        ground.addUVs();
		var groundMesh = new h3d.scene.Mesh(ground, s3d);
        groundMesh.material.mainPass.enableLights = true;
		groundMesh.material.shadows = true;
		OimoUtils.addPhysics(groundMesh, RigidBodyType.STATIC, [0, 0, 0]);

		var boxPrim = new h3d.prim.Cube(1.8, 1.8, 1.8, true);
		boxPrim.addNormals();
		boxPrim.addUVs();

		var cylPrim = new h3d.prim.Cylinder(10, 1.8, 3, true);
		cylPrim.addNormals();
		cylPrim.addUVs();
		
		var spherePrim = new h3d.prim.Sphere(1.0, 12, 12);
		spherePrim.addNormals();
		spherePrim.addUVs();
		var staticSphere1Mesh = new h3d.scene.Mesh(spherePrim, s3d);
		staticSphere1Mesh.material.color.setColor(0xff0000);
		staticSphere1Mesh.setScale(2.5);
		staticSphere1Mesh.setPosition(-4, -4, 6);
		staticSphere1Mesh.material.mainPass.enableLights = true;
        staticSphere1Mesh.material.shadows = true;	
		OimoUtils.addPhysics(staticSphere1Mesh, RigidBodyType.STATIC, [-4, -4, 3]);
		
		var staticSphere2Mesh = new h3d.scene.Mesh(spherePrim, s3d);
		staticSphere2Mesh.setScale(2.5);
		staticSphere2Mesh.material.color.setColor(0xff0000);
		staticSphere2Mesh.setPosition(4, 4, 6);
		OimoUtils.addPhysics(staticSphere2Mesh, RigidBodyType.STATIC, [4, 6, 4]);
		
		var staticSphere3Mesh = new h3d.scene.Mesh(spherePrim, s3d);
		staticSphere3Mesh.setScale(2.5);
		staticSphere3Mesh.material.color.setColor(0xff0000);
		staticSphere3Mesh.setPosition(4, -4, 6);
		OimoUtils.addPhysics(staticSphere3Mesh, RigidBodyType.STATIC, [4, 6, -4]);

		var staticSphere4Mesh = new h3d.scene.Mesh(spherePrim, s3d);
		staticSphere4Mesh.setScale(2.5);
		staticSphere4Mesh.material.color.setColor(0xff0000);
		staticSphere4Mesh.setPosition(-4, 4, 6);
		OimoUtils.addPhysics(staticSphere4Mesh, RigidBodyType.STATIC, [-4, 6, 4]);

		for (i in 0...20) {
			var sphere = new h3d.scene.Mesh(spherePrim, s3d);
			sphere.material.color.setColor(0x0000ff);
			OimoUtils.addPhysics(sphere, RigidBodyType.DYNAMIC, [OimoUtils.getRandomFloat(-5, 5), 3 + (i * 1.2), OimoUtils.getRandomFloat(-5, 5)]);
		}

		for (i in 0...20) {
			var box = new h3d.scene.Mesh(boxPrim, s3d);
			box.material.color.setColor(0x00ff00);
			OimoUtils.addPhysics(box, RigidBodyType.DYNAMIC, [OimoUtils.getRandomFloat(-5, 5), 5 + (i * 1.2), OimoUtils.getRandomFloat(-5, 5)]);
		}
	}

	var tmpVec3_0:Vec3 = new Vec3();
	var tmpVec3_1:Vec3 = new Vec3();
	function teleportRigidBodies(thresholdY:Float, toY:Float, rangeX:Float, rangeZ:Float):Void {
		var rb = oimo_world.getRigidBodyList();
		tmpVec3_0.zero();
		while (rb != null) {
			rb.getPositionTo(tmpVec3_1);
			if (tmpVec3_1.y < thresholdY) {
				tmpVec3_1.y = toY;
				tmpVec3_1.x = MathUtil.randIn(-1, 1) * rangeX;
				tmpVec3_1.z = MathUtil.randIn(-1, 1) * rangeZ;
				rb.setPosition(tmpVec3_1);
				rb.setLinearVelocity(tmpVec3_0);
			}
			rb = rb.getNext();
		}
	}
	
	override function update(dt:Float) {
		OimoUtils.updatePhysics();
		teleportRigidBodies(-12, 25, 10, 10);
	}

    static function main() {
        new Main();
    }
}