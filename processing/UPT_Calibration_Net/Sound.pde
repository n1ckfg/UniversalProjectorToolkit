import ddf.minim.*;

Minim minim;
String filePath = "sounds";
AudioSample startRecSound, stopRecSound, pKeySound, sKeySound;

void setupSound() {
  startRecSound = minim.loadSample(filePath + "/" + "startRec.wav");
  stopRecSound = minim.loadSample(filePath + "/" + "stopRec.wav");
  pKeySound = minim.loadSample(filePath + "/" + "24th blip sync pop.wav");
  sKeySound = minim.loadSample(filePath + "/" + "24th blip sync pop.wav");
}

void playSoundStartRec() {
  pKeySound.trigger();
}

void playSoundStopRec() {
  pKeySound.trigger();
}

void playSoundPkey() {
  pKeySound.trigger();
}

void playSoundSkey() {
  pKeySound.trigger();
}
