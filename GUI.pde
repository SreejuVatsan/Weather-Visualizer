// Examples ControlP5 Bang, ControlP5 Textfield was refered to understand how the library works.
// www.sojamo.de/libraries/controlP5/#examples
//

import controlP5.*;

class GUI {
	String theTooltipString;
	ControlP5 cp5;
	ControllerGroup messageBox;	
	PeasyCam cam;
	GUIListener guiListener;

	int temperature, globeRadius, temperatureMax, temperatureMin;
	String city, country, icon, description, apiKey;
	float windSpeed, windAngle;

	GUI (PApplet pa, PeasyCam camInstance, String pAPIKey) {
		PFont font = createFont("arial",20);
		textFont(font);

		cam = camInstance;
		apiKey = pAPIKey;

		cp5 = new ControlP5(pa);
		cp5.addTextfield("searchBox")
		.setPosition(20,50)
		.setSize(200,30)
		.setFont(createFont("arial",15))
		.setAutoClear(true)
		.setLabel("Search a city. Ex: Limerick or Limerick, IR")
		.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);

		cp5.addBang("searchBang")
		.setPosition(240,50)
		.setSize(60,30)
		.setFont(createFont("arial",10))
		.setTriggerEvent(Bang.RELEASE)
		.setLabel("Search")
		.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
		 
		cp5.setAutoDraw(false);

		guiListener = new GUIListener(cp5);		
		cp5.getController("searchBox").addListener(guiListener);
		cp5.getController("searchBang").addListener(guiListener);
		createMessageBox();
	}


	void createMessageBox() {
		if (!guiListener.searchString.equals("")) {
			queryAPI();
		}

		if(cp5.get(ControlGroup.class, "messageBox") != null){
			cp5.remove("messageBox");
		}

		int messageBoxW = int(displayWidth * 0.35);
		int messageBoxH = int(displayWidth * 0.35);

		//create a group to store the messageBox elements
		messageBox = cp5.addGroup("messageBox",int(displayWidth * 0.35),int(displayHeight * 0.18));
		messageBox.setWidth(messageBoxW);
		messageBox.setHeight(messageBoxH);
		messageBox.addCanvas(new WeatherCanvas(messageBox.getWidth(), messageBox.getHeight()
							, city, country, temperature, temperatureMax, temperatureMin
							, icon, description, windSpeed, windAngle));
		messageBox.hideBar();
		messageBox.show();

		Button b1 = cp5.addButton("buttonX",0,10,10,20,20);
	  	b1.moveTo(messageBox);
	  	b1.setColorBackground(color(40));
	  	b1.setColorActive(color(20));
		b1.setBroadcast(false); 
		b1.setValue(1);
		b1.setBroadcast(true);
		b1.setCaptionLabel("X");
		b1.setPosition(messageBox.getWidth() - 20, 0);
		
		cp5.getController("buttonX").addListener(guiListener);

	}

	void updateGUI() {
		if (guiListener.windowClosed == true) {
			messageBox.hide();
		}
		else{
			messageBox.show();
		}

		if (guiListener.searchStringUpdated == true) {			
			guiListener.searchStringUpdated = false;
			guiListener.windowClosed = false;
			createMessageBox();
			messageBox.show();			
		}

		hint(DISABLE_DEPTH_TEST);
		cam.beginHUD();
		cp5.draw();
		cam.endHUD();
		hint(ENABLE_DEPTH_TEST);
	}

	void queryAPI(){
		if (guiListener.searchString.equals("")) {
			println("Search Box Empty");
		}
		else {
			lines = loadStrings("http://api.openweathermap.org/data/2.5/find?q="+ guiListener.searchString 
								+"&units=metric&appid=" + apiKey);
			weather = parseJSONObject(lines[0]);//returns JSONObject.
			if (weather!=null && weather.getInt("count") > 0){
				values = weather.getJSONArray("list");
				city = values.getJSONObject(0).getString("name");
				country = values.getJSONObject(0).getJSONObject("sys").getString("country");
				temperature = values.getJSONObject(0).getJSONObject("main").getInt("temp");
				temperatureMax = values.getJSONObject(0).getJSONObject("main").getInt("temp_max");
				temperatureMin = values.getJSONObject(0).getJSONObject("main").getInt("temp_min");

				icon = values.getJSONObject(0).getJSONArray("weather").getJSONObject(0).getString("icon");
				description = values.getJSONObject(0).getJSONArray("weather").getJSONObject(0).getString("description");
				windSpeed = values.getJSONObject(0).getJSONObject("wind").getFloat("speed");
				windAngle = (values.getJSONObject(0).getJSONObject("wind").isNull("deg")) ? 
							0 : values.getJSONObject(0).getJSONObject("wind").getFloat("deg");
			}
			else {
				println("NULL JSON Error");
			}
		}		
	}

}