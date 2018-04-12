import peasy.*;

JSONObject weather;
JSONArray values;
String lines[];
int radius = 300;

PImage satelliteImage;
Globe g;

PeasyCam cam;

void setup() {
	size(800, 800,P3D);
	//size(800, 800,OPENGL);
	cam = new PeasyCam(this, 800);
	cam.setMinimumDistance(radius + 100);
	cam.setMaximumDistance(1100);

	//Earth texture from https://visibleearth.nasa.gov/view.php?id=73826
	//satelliteImage = loadImage("world.topo.bathy.200410.3x21600x10800.jpg");
	satelliteImage = loadImage("world.topo.bathy.200410.3x5400x2700.jpg");
	
	//lines = loadStrings("http://api.openweathermap.org/data/2.5/find?q=Limerick,IE&units=metric&appid=a94c4c52ca111142f002dc06f2cf5fbf");
	lines = loadStrings("weatherInfo2.json");
	//println(lines);
	weather = parseJSONObject(lines[0]);//returns JSONObject.

	g = new Globe(radius, satelliteImage, weather);

}

void draw() {
	background(50);
	//translate(width * 0.5, height * 0.5);

	g.drawGlobe();
	g.updateGlobe();	

	/*textSize(50);
	text(city, width/2, height/1.5);

	textSize(100);
	text(temperature, width/2, height/2);  */


}

