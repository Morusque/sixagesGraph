
// put "PlayerClanData.txt" in the sketch root folder
// use UP/DOWN to switch between variables
// use TAB to show/hide a given variable

String[] labels = {"Time", "Year", "passFail", "Tests", "Wins", "%expl", "pop", "warriors", "sick", "wound", "children", "goods", "herds", "horses", "magic", "mood", "ally", "feud", "fear", "hate", "like", "mock", "food", "treasure", "Exotics", "Grazing", "wp", "wpUsed", "direness", "troubles", "rByUs", "rOnUs", "rWon", "hLost", "hWon", "rBegan", "rSuc", "noCar", "noEm", "starv", "bandit", "chaos", "ram", "Exp", "charioteer", "elmal", "hyaloring", "vingkotling", "believer", "rejecter", "antlerAtt", "Last", "KnownFor"};
boolean[] isInt = new boolean[53];
int[] highestValues = new int[53];
int[] lowestValues = new int[53];
ArrayList<Season> seasons = new ArrayList<Season>();

int currentVariable = 0;
boolean[] show = new boolean[53];

void setup() {
  size(1000, 800);
  String[] txt = loadStrings("PlayerClanData.txt");
  for (int i=0; i<53; i++) isInt[i] = true;
  isInt[1]=false;
  isInt[51]=false;
  isInt[52]=false;
  for (int i=0; i<53; i++) show[i] = true;
  for (int i=1; i<txt.length; i++) {
    if (txt[i].length()>0) {
      if (txt[i].charAt(0)!='R') {
        String[] elements = txt[i].split("\t"); 
        int seasonNb = Integer.parseInt(elements[0]);
        for (int j=0; j<seasons.size(); j++) {
          if (seasons.get(j).intValues[0]==seasonNb) {
            seasons.remove(j--);
          }
        }
        seasons.add(new Season(elements));
      }
    }
  }
  /*
  for (int j=0; j<seasons.size(); j++) print(seasons.get(j));
   */
  int highestYear = -1;
  int lowestYear = -1;
  for (int j=0; j<seasons.size(); j++) {
    if (lowestYear==-1||lowestYear>seasons.get(j).intValues[0]) lowestYear = seasons.get(j).intValues[0];
    highestYear = max(highestYear, seasons.get(j).intValues[0]);
  }
  for (int i=0; i<labels.length; i++) {
    for (int j=0; j<seasons.size(); j++) {
      if (j==0) highestValues[i] = lowestValues[i] = seasons.get(j).intValues[i];
      highestValues[i] = max(highestValues[i], seasons.get(j).intValues[i]);
      lowestValues[i] = min(lowestValues[i], seasons.get(j).intValues[i]);
    }
  }
  show();
}

void draw() {
}

void keyPressed() {
  if (keyCode==UP) currentVariable = (currentVariable-1+labels.length)%labels.length;
  if (keyCode==DOWN) currentVariable = (currentVariable+1)%labels.length;
  if (keyCode==TAB) show[currentVariable]^=true; 
  show();
}

class Season {
  String[] strValues = new String[53];
  int[] intValues = new int[53];
  Season(String[] elements) {
    this.strValues = elements;
    for (int i=0; i<elements.length; i++) {
      try {
        intValues[i] = Integer.parseInt(elements[i]);
      } 
      catch(Exception e) {
        intValues[i] = 0;
      }
    }
  }
}

void print(Season s) {
  for (String txt : s.strValues) print(txt+" ");
  println();
}

void show() {
  colorMode(HSB);
  background(0);
  int nbShowed = 0;
  for (int i=0; i<labels.length; i++) if (show[i]) nbShowed++;
  int showedIndex = 0;
  for (int i=0; i<labels.length; i++) {
    if (show[i]||currentVariable==i) {
      color thisColor = color((float)showedIndex/nbShowed*0x100, 0xFF, 0xFF);
      fill(thisColor);
      if (currentVariable==i) fill(0xFF);
      noStroke();
      text((show[i]?"X ":"  ")+labels[i], 5, 13*i+60);
      beginShape();
      stroke(thisColor);
      strokeWeight(1);
      if (currentVariable==i) {
        stroke(0xFF);
        strokeWeight(3);
      }
      noFill();
      for (int j=0; j<seasons.size(); j++) {
        if (isInt[i]) {
          if (lowestValues[i]!=highestValues[i]) {
            vertex(map(j, 0, seasons.size(), 80, width), map(seasons.get(j).intValues[i], lowestValues[i], highestValues[i], height*9/10, height*1/10));
          }
        }
      }
      endShape(OPEN);
    }
    if (show[i]) showedIndex++;
  }
}
