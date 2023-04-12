
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

  Particle(PVector _pos, PVector _velocity, float _weight, float _size, color _color, float _KB, float _KD)
  {
    pos =_pos;
    vel = _velocity;
    weight = _weight;
    size = _size;
    color_p = _color;

    // Priodidades de la bandada de pajaros. Cuanto mas cerca de 1, mayor priodidad tendra
    KB = _KB; // Priodidad de seguir a la bandada
    KD = _KD; // Prioridad de seguir al objetivo
  }

  void Move(PVector destPos)
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

    dest = UnitaryVector(pos, destPos);
    flock = UnitaryVector(pos, FlockCenter());

    strenght.x = KD * dest.x + KB * flock.x;
    strenght.y = KD * dest.y + KB * flock.y;
    strenght.z = KD * dest.z + KB * flock.z;
    
    accel.x = strenght.x/weight;
    accel.y = strenght.y/weight;
    accel.z = strenght.z/weight;

    vel.x = vel.x + accel.x * deltaTime;
    vel.y = vel.y + accel.y * deltaTime;
    vel.z = vel.z + accel.z * deltaTime;

    pos.x = pos.x + vel.x * deltaTime;
    pos.y = pos.y + vel.y * deltaTime;
    pos.z = pos.z + vel.z * deltaTime;

    /*if (pos.x > width - size)
    {
      pos.x = width - size;
    } else if (pos.x < size)
    {
      pos.x = size;
    }

    if (pos.y > height - size)
    {
      pos.y = height - size;
    } else if (pos.y < size)
    {
      pos.y = size;
    }*/
  }

  void Draw()
  {
    pushMatrix();
    noFill();
    strokeWeight(1);
    stroke(color_p);
    translate(pos.x, pos.y, pos.z);
    sphere(size);
    popMatrix();
  }
}
