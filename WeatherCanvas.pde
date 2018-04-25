// Scaled up implementation of the Card using Canvas linked to a ControlP5.ControlGroup

class WeatherCanvas extends Canvas {
	String city, country, description;
	int temperature, temperatureMax, temperatureMin, canvasWidth, canvasHeight;
	PImage iconImage, windCompass, windArrow;
	float windSpeed, windAngle;
	PFont pf1, pf2;
	PGraphics buffer;
	String sector[];

	WeatherCanvas(int pWidth, int pHeight, String pCity, String pCountry, int pTemperature
				, int pTemperatureMax, int pTemperatureMin, String pIcon, String pDescription
				, float pWindSpeed, float pWindAngle){
		city = pCity;
		country = pCountry;
		description = pDescription;
		temperature = pTemperature;
		temperatureMax = pTemperatureMax;
		temperatureMin = pTemperatureMin;
		canvasWidth = pWidth;
		canvasHeight = pHeight;
		windSpeed = pWindSpeed;
		windAngle = pWindAngle;
		iconImage = loadImage("icon/" + pIcon + ".png");
		windCompass = loadImage("icon/compassOuter.png");
		windArrow = loadImage("icon/compassInner.png");
		pf1 = createFont("SourceSansPro-Light", 60);
		pf2 = createFont("Source Sans Pro", 40);

		buffer = createGraphics(1500, 1500);

	}

	public void draw(PGraphics pg) {
		pg = createGraphics(canvasWidth, canvasHeight);
		pg.beginDraw();
		pg.background(255, 255, 255);
		pg.fill(70);
		if (iconImage != null) {
			pg.textAlign(CENTER);
			pg.imageMode(CENTER);
			{	
				pg.pushMatrix();
				pg.translate(0, canvasHeight*0.2);
				pg.textFont(pf2, 40);
				pg.text(city + ", " + country, canvasWidth * 0.5, 0);
				{
					pg.pushMatrix();
					pg.translate(0,100);					
					pg.image(iconImage, (canvasWidth * 0.5) - 75, 0, 150, 150);
					{
						pg.pushMatrix();
						pg.translate(canvasWidth * 0.18,20);
						pg.textFont(pf1, 120);
						pg.text(temperature, (canvasWidth * 0.5), 0);
						pg.textFont(pf1, 30);
						pg.text("° C", (canvasWidth * 0.5) + 55 +pg.textWidth(""+temperature), 0); 
						pg.popMatrix();
					}
					{
						pg.pushMatrix();
						pg.translate(0, 110);
						pg.textFont(pf2, 25);
						pg.text(description, canvasWidth * 0.5, 0);
						{
							pg.pushMatrix();
							pg.translate(0, 45);
							pg.text("Wind", canvasWidth * 0.5, 0);
							{
								pg.pushMatrix();
								pg.translate(0, 30);
								pg.text(windSpeed + "km/h", canvasWidth * 0.5 - (pg.textWidth(windSpeed + "km/h")/2), 0);
								buffer.beginDraw();								
								buffer.translate(750, 750);
								buffer.imageMode(CENTER);
								buffer.image(windCompass, 0, 0, 1500, 1500);
								buffer.rotate(radians(windAngle));
								buffer.image(windArrow, 0, 0, 1500, 1500);
								buffer.endDraw();
								pg.image(buffer, (canvasWidth * 0.5) + (canvasWidth * 0.15), -10, 50, 50);
								{
									pg.pushMatrix();
									pg.translate(0, 50);
									pg.text("Max: " + temperatureMax + "° C         Min: " + temperatureMin + "° C", canvasWidth * 0.5, 0);
									pg.popMatrix();
								}
								pg.popMatrix();
							}
							pg.popMatrix();
						}
						pg.popMatrix();						
					}
					pg.popMatrix();
				}
				pg.popMatrix();
			}			
		}
		image(pg, 0, 0);			
	}
}