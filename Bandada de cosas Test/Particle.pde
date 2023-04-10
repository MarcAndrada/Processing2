
class Particle 
{
  PVector pos;
  PVector vel;

  float weight;
  float size;
   // KB de acercamiento a la bandada
  float KB;
  // KD de acercamiento a la meta
  float KD;
  color color_p;

  Particle(PVector p, PVector v, float w, float s, color c) 
  {
    pos = p;
    vel = v;
    weight = w;
    size = s;
    color_p = c;
    
    // Priodidades de la bandada de pajaros. Cuanto mas cerca de 1, mayor priodidad tendra
    KB = 0.9; // Priodidad de seguir a la bandada
    KD = 0.1; // Prioridad de seguir al objetivo
  }
  
  void Move() 
  {  
    PVector strenght;
    PVector accel;
    PVector dest;
    //Flock es bandada
    PVector flock;
    
    strenght = new PVector(0.0, 0.0, 0.0);
    accel = new PVector(0.0, 0.0, 0.0);
    dest = new PVector(0.0, 0.0, 0.0);
    flock = new PVector(0.0, 0.0, 0.0);

    dest = UnitaryVector(pos, dest);
    flock = UnitaryVector(pos, FlockCenter());
    
    strenght.x = KD * dest.x + KB * flock.x;
    strenght.y = KD * dest.y + KB * flock.y;
  
    accel.x = strenght.x/weight;
    accel.y = strenght.y/weight;

    vel.x = vel.x + accel.x * deltaTime;
    vel.y = vel.y + accel.y * deltaTime;

    pos.x = pos.x + vel.x * deltaTime;
    pos.y = pos.y + vel.y * deltaTime;
  }

  void Draw() 
  {
    strokeWeight(2);
    noFill();
    stroke(color_p);
    ellipse(pos.x, pos.y, size, size);
  }
}
