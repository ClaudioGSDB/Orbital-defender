class Button {
  float x, y, width, height;
  String label;
  
  // Constructor
  Button(float xPos, float yPos, String buttonLabel){};
  
  // Display the button
  void display();
  
  // Check if mouse is over button
  boolean isMouseOver();
  
  // Handle button click action
  void click();
}
