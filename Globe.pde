class Globe{
	PShape globe;	
	PVector position, xAxis;
	PImage texture;

	// 13.0827° N, 80.2707° E
	float latitude;
	float longitude;
	float angle, x, y, z, vectorAngleBetween;

	int temperature, globeRadius;

	String city;

	JSONObject weather;

	Globe(int radius, PImage satelliteImage, JSONObject jWeather){
	texture = satelliteImage;
	globeRadius = radius;
	weather = jWeather;
	}

	void drawGlobe(){
		noStroke();
		globe = createShape(SPHERE, globeRadius);
		globe.setTexture(texture);
		rotateY(angle);
		angle += 0.001;
		lights();
		shape(globe);
	}

	void updateGlobe(){
		if (weather!=null) {
			values = weather.getJSONArray("list");    	
			city = values.getJSONObject(0).getString("name");
			//println(values.getJSONObject(0).getJSONObject("main"));
			temperature = values.getJSONObject(0).getJSONObject("main").getInt("temp");

			for (int i = 0; i < values.size(); i++) {
				latitude = values.getJSONObject(i).getJSONObject("coord").getFloat("lat");
				longitude = values.getJSONObject(i).getJSONObject("coord").getFloat("lon");

				float theta = radians(latitude);
				float phi = radians(longitude);

				//formula from Daniel Shiffman's coding challenge. Coordintates signes were not propper. I had to correct them.
				x = -radius * cos(theta) * cos(phi);
				y = -radius * sin(theta);
				z = radius * cos(theta) * sin(phi);

				position = new PVector(x,y,z);
				xAxis = new PVector(1,0,0);
				vectorAngleBetween = PVector.angleBetween(xAxis, position);
				PVector rAxis = xAxis.cross(position);

				pushMatrix();
				translate(x, y, z);
				rotate(vectorAngleBetween, rAxis.x, rAxis.y, rAxis.z);
				box(2);
				popMatrix();
			}
		}
		else {
			println("Unable to parse the URL");
		}
	}
}