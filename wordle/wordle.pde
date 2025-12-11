int cols = 5;
int rows = 6;
int x_padding; 
int y_padding = 65;
int box_len = 100;
int guess_idx = 0;

String [] word_bank;
String word;
String guess;
String [] words_guessed;
String letters_guessed="";

color green = color(27, 149, 0);
color yellow = color(200, 200, 0);
color gray = color(80);
color [][] box_colors;

Boolean correct = false;

void setup(){
  size(800, 800);
  background(0);
  x_padding = (width / 2) - (cols * (box_len / 2));
  get_word();
  init_box_colors();
  words_guessed = new String[rows];
}

void init_box_colors(){
  box_colors = new color[cols][rows];
  for(int i=0; i<cols; i++){
    for(int j=0; j<rows; j++){
      box_colors[i][j] = gray;
    }
  }
}

void get_word(){
  word_bank = loadStrings("word-bank.csv");
  int idx = (int) random(word_bank.length);
  word = word_bank[idx];
  println(word);
}

void draw(){
  textAlign(CENTER, CENTER);
  render_title();
  render_boxes();
  render_prev_guesses();
  render_current_guess();
}

void render_title(){
  if(!correct){
    fill(gray);
  }
  else{
    fill(green);
  }
  textSize(50);
  text("WORDLE", width / 2, 30);
}

void render_boxes(){
  for(int i=0; i<cols; i++){
    for(int j=0; j<rows; j++){
      if(j > guess_idx){
        fill(gray);
      }
      else{
        fill(box_colors[i][j]);
      }
      int x = x_padding + (box_len * i);
      int y = y_padding + (box_len * j);
      rect(x, y, box_len, box_len);
    }
  }
}

void render_prev_guesses(){
  for(int i=0; i<cols; i++){
    for(int j=0; j<guess_idx; j++){
        textSize(50);
        fill(0);
        text("" + words_guessed[j].charAt(i), x_padding + (box_len * i) + (box_len / 2), y_padding + (box_len * j) + (box_len / 2));
    }
  }
}

void render_current_guess(){
  for(int i=0; i<letters_guessed.length(); i++){
      textSize(50);
      fill(0);
      text("" + letters_guessed.charAt(i), x_padding + (box_len * i) + (box_len / 2), y_padding + (box_len * guess_idx) + (box_len / 2));
  }
}

void keyPressed(){
  if(!correct){
    if(key >= 'a' && key <= 'z'){
      if(letters_guessed.length() < cols){
        letters_guessed += key;
      }
    }
    else if(key == BACKSPACE){
      int guess_len = letters_guessed.length();
      if(guess_len > 0){
        letters_guessed = letters_guessed.substring(0, guess_len - 1);
      }
    }
    else if(key == ENTER && letters_guessed.length() == cols){
      words_guessed[guess_idx] = letters_guessed;
      check_guess();
    }
  }
}

void check_guess(){
  int num_correct_letters = 0;
  for(int i=0; i<cols; i++){
    if(word.charAt(i) == letters_guessed.charAt(i)){
      box_colors[i][guess_idx] = green;
      num_correct_letters++;
    }
    else if(word.indexOf(letters_guessed.charAt(i)) > -1){
      box_colors[i][guess_idx] = yellow;
    }
    else{
      box_colors[i][guess_idx] = gray;
    }
  }
 if(num_correct_letters == cols){
   correct = true;
 }
 else{
   guess_idx++;
   letters_guessed = "";
   if(guess_idx == rows){
     fill(80, 0, 0);
     text(word, width / 2, height - 50);
   }
 }
}
