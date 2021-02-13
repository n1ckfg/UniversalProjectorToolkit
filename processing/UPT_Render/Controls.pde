void keyPressed() {
  if (key=='g') {
    if (cp5.isVisible()) {
      cp5.hide();
      guiVisible = false;
    }
    else {
      cp5.show();
      guiVisible = true;
    }
  }
}
