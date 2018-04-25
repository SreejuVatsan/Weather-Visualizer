// Daniel Shiffman's Coding Challenge on Visualizing Earthquake data hacked and used to plot the cities
// repo - https://github.com/CodingTrain/website/tree/master/CodingChallenges/CC_58_EarthQuakeViz3D
//
//	Concepts Used
// Spherical Coordinates System : https://en.wikipedia.org/wiki/Spherical_coordinate_system
// Cross Product : https://de.wikipedia.org/wiki/Kreuzprodukt
// Euler Angle : https://en.wikipedia.org/wiki/Euler_angles
// Quaternions and spatial rotation : https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation

class Globe{
	PShape globe;	
	PVector position, xAxis, yAxis, zAxis;
	PImage texture;
	PGraphics pg;
	PFont pf1, pf2;

	float latitude;
	float longitude;
	float angle, x, y, z, vectorAngleBetween, vectorAngleBetweenYZ;

	int temperature, globeRadius;
	String city, country, icon, description;
	boolean circleOver;

	JSONObject jsonResponse, weather;

	ControlP5 cp5;
	Button b;

	Globe(int radius, PImage satelliteImage, JSONObject response, PApplet pa){
		texture = satelliteImage;
		globeRadius = radius;
		circleOver = false;
		jsonResponse = response;

		pf1 = createFont("SourceSansPro-Light", 60);
		pf2 = createFont("Source Sans Pro", 40);
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

	void updateGlobe(JSONObject response){
		jsonResponse = response;
	}
	void updateGlobe(){
		if (jsonResponse!=null){
			values = jsonResponse.getJSONArray("list");

			for (int i = 0; i < values.size(); i++) {
				city = values.getJSONObject(i).getString("name");
				country = values.getJSONObject(i).getJSONObject("sys").getString("country");
				temperature = values.getJSONObject(i).getJSONObject("main").getInt("temp");

				icon = values.getJSONObject(i).getJSONArray("weather").getJSONObject(0).getString("icon");
				description = values.getJSONObject(i).getJSONArray("weather").getJSONObject(0).getString("main");

				latitude = values.getJSONObject(i).getJSONObject("coord").getFloat("lat");
				longitude = values.getJSONObject(i).getJSONObject("coord").getFloat("lon");

				float theta = radians(latitude);
				float phi = radians(longitude);

				//formula from Daniel Shiffman's coding challenge. Coordintates signes were not propper. I had to correct them.
				x = -radius * cos(theta) * cos(phi);
				y = -radius * sin(theta);
				z = radius * cos(theta) * sin(phi);

				position = new PVector(x,y,z);
				zAxis = new PVector(0,0,1);
				vectorAngleBetween = PVector.angleBetween(zAxis, position);
				PVector rAxis = zAxis.cross(position);
				
				pushMatrix();
				translate(x, y, z);				
				rotate(vectorAngleBetween, rAxis.x, rAxis.y, rAxis.z);
				box(3);
				toolTip(latitude,longitude, city, country, temperature
					, icon, description);
				popMatrix();
			}
		}
		else {
			println("Unable to parse the URL");
		}
	}

	void toolTip(float latitude, float longitude, String city, String country, int temperature
		, String icon, String description){
		PImage iconImage = loadImage("icon/" + icon + ".png");
		pg= createGraphics(100*2, 100*2);
		pg.beginDraw();
		pg.background(255, 255, 255);
		pg.fill(70);
		pg.textAlign(CENTER);
		pg.imageMode(CENTER);
		//rectMode(CORNER);
		{
			pg.pushMatrix();
			pg.translate(0,20*2);
			pg.textFont(pf2, 20);
			pg.text(city + ", " + country, 50*2, 0);
			{
				pg.pushMatrix();
				pg.translate(0,30*2);
				pg.image(iconImage, 30*2, 0, 30*2, 30*2);
				{
					pg.pushMatrix();
					pg.translate(0,5*2);
					pg.textFont(pf1, 30);
					pg.text(temperature + "° C", 70*2, 0);
					pg.popMatrix();
				}
				{
					pg.pushMatrix();
					pg.translate(0, 40*2);
					pg.textFont(pf2, 20);
					pg.text(description, 50*2, 0);
					pg.popMatrix();
				}
				pg.popMatrix();
			}
			pg.popMatrix();
		}
		pg.endDraw();
		{	
			pushMatrix();
			translate(0, -35, 5);
			imageMode(CENTER);
			image(pg, 0, 0, 60, 60);
			popMatrix();
		}		
	}
}