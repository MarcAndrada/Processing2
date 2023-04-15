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

  float maxSpeed = 100;
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
    PVector strenght= new PVector(0.0, 0.0, 0.0);
    PVector accel = new PVector(0.0, 0.0, 0.0);
    PVector dest = new PVector(0.0, 0.0, 0.0);
    //Flock es bandada
    PVector flock = new PVector(0.0, 0.0, 0.0);
    PVector velocity = new PVector(0.0, 0.0, 0.0);

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

    if (vel.x > maxSpeed)
      vel.x = maxSpeed;
    if (vel.y > maxSpeed)
      vel.y = maxSpeed;
    if (vel.z > maxSpeed)
      vel.z = maxSpeed;

    pos.x = pos.x + vel.x * deltaTime;
    pos.y = pos.y + vel.y * deltaTime;
    pos.z = pos.z + vel.z * deltaTime;
  }

  void CheckCollision()
  {
  }


  void Draw()
  {
    pushMatrix();
    fill(color_p);
    noStroke();
    translate(pos.x, pos.y, pos.z);
    sphere(size);
    popMatrix();
  }
}
