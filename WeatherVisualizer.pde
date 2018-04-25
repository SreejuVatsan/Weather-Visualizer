import peasy.*;
import ddf.minim.*;

JSONObject weather;
JSONArray values;
String lines[], cityArray[], queryString, apiKey;
int radius = 300, lastRefreshTime = 0;

PImage satelliteImage;
Globe g;
GUI gui;

Minim minim;
AudioPlayer song;

PeasyCam cam;

void setup() {
	fullScreen(OPENGL);
	cam = new PeasyCam(this, 800);
	cam.setMinimumDistance(radius + 105);
	cam.setMaximumDistance(1100);

	minim = new Minim(this);
	//Ambient music from FreeSound.org
	song = minim.loadFile("erokia__elementary-wave-11.wav", 2048);
	song.loop();

	apiKey = loadStrings("APIKey.txt")[0];

	//Earth texture from https://visibleearth.nasa.gov/view.php?id=73826
	satelliteImage = loadImage("world.topo.bathy.200410.3x5400x2700.jpg");
	
	initializeGlobe();

	gui = new GUI(this, cam, apiKey);
}

void loadCityListCSV(){
	cityArray = loadStrings("city-list.csv");
	queryString = split(cityArray[int(random(0, cityArray.length-1))], ",")[0] + ","
				+ split(cityArray[int(random(0, cityArray.length-1))], ",")[0] + ","
				+ split(cityArray[int(random(0, cityArray.length-1))], ",")[0] + ","
				+ split(cityArray[int(random(0, cityArray.length-1))], ",")[0] + ","
				+ split(cityArray[int(random(0, cityArray.length-1))], ",")[0];
  //println(queryString);
}

void updateCoordinates(){
	lines = loadStrings("http://api.openweathermap.org/data/2.5/group?id=" + queryString +"&units=metric&appid=" + apiKey);
	//lines = loadStrings("weatherInfo2.json"); //<>//
	weather = parseJSONObject(lines[0]);//returns JSONObject.	
}

void initializeGlobe(){
	loadCityListCSV();
	updateCoordinates();
	g = new Globe(radius, satelliteImage, weather, this);
}

void draw() {
	background(0);
	if ((millis() - lastRefreshTime) > 30000) {
		lastRefreshTime = millis();
		loadCityListCSV();
		updateCoordinates();
		g.updateGlobe(weather);
		println("Refresh");
	}
	g.drawGlobe();
	g.updateGlobe();

	gui.updateGUI();

}

