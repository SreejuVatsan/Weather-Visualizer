// Example ControlP5ListenerForSingleController was refered to understand the working of Listeners with ControlP5 elements.
// www.sojamo.de/libraries/controlP5/#examples

import controlP5.*;

class GUIListener implements ControlListener {
	ControlP5 cp5;
	String searchString = "";
	Boolean windowClosed = true, searchStringUpdated = false;

	GUIListener(ControlP5 cp5Instance){
		cp5 = cp5Instance;
	}

	public void controlEvent(ControlEvent theEvent) {
	    if (theEvent.getController().getName() == "searchBox") {
	    	searchString = theEvent.getStringValue();
	    	searchStringUpdated = true;
	    }
	    else if (theEvent.getController().getName() == "searchBang") {
	    	searchString = cp5.get(Textfield.class,"searchBox").getText();
	    	searchStringUpdated = true;
	    }
	    else if (theEvent.getController().getName() == "buttonX") {
	    	windowClosed = true;
	    }
	}
}