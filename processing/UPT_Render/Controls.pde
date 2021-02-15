float threshold = 127;
boolean debugDraw = false;

void keyPressed() {
  if (key=='g') {
    if (cp5.isVisible()) {
      cp5.hide();
      guiVisible = false;
    } else {
      cp5.show();
      guiVisible = true;
    }
  } else if (key == 'w') {
    threshold++;
  } else if (key == 's') {
    threshold--;
  }  else if (key == 'q') {
    threshold += 5;
  } else if (key == 'a') {
    threshold -= 5;
  } else if (key == 'd') {
    debugDraw = !debugDraw;
  } else if (key == ' ') {
    tex.save("render/mask_" + millis() + ".png");
  }
  
  threshold = constrain(threshold, 0, 255);
  kinect.update(threshold);
  println(threshold);
}
