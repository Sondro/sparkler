package sparkler.modules;

import sparkler.core.Particle;
import sparkler.core.ParticleModule;
import sparkler.core.Components;
import sparkler.components.Velocity;
import sparkler.modules.helpers.VelocityUpdateModule;

import luxe.Vector;

using sparkler.utils.VectorTools;


class GravityModule extends ParticleModule {


	public var gravity(default, null):Vector;

	var vel_comps:Components<Velocity>;


	public function new(_options:GravityModuleOptions) {

		super(_options);

		gravity = _options.gravity != null ? _options.gravity : new Vector(0, 98);

	}

	override function init() {

	    if(emitter.get_module(VelocityUpdateModule) == null) {
			emitter.add_module(new VelocityUpdateModule());
		}

		vel_comps = emitter.components.get(Velocity);

	}

	override function onremoved() {

		emitter.remove_module(VelocityUpdateModule);
		vel_comps = null;
		
	}

	override function ondisabled() {

		particles.for_each(
			function(p) {
				vel_comps.get(p).set_xy(0,0);
			}
		);
		
	}

	override function onunspawn(p:Particle) {

		var v:Velocity = vel_comps.get(p);
		v.set_xy(0,0);
		
	}

	override function update(dt:Float) {

		var vel:Vector;
		for (p in particles) {
			vel = vel_comps.get(p);
			vel.x += gravity.x * dt;
			vel.y += gravity.y * dt;
		}

	}


// import/export

	override function from_json(d:Dynamic) {

		super.from_json(d);

		gravity.from_json(d.gravity);

		return this;
	    
	}

	override function to_json():Dynamic {

		var d = super.to_json();

		d.gravity = gravity.to_json();

		return d;
	    
	}


}


typedef GravityModuleOptions = {

	>ParticleModuleOptions,
	
	@:optional var gravity : Vector;

}


