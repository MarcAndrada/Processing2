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
  //KC separacion de las colisiones
  float KC;
  color color_p;

  float maxSpeed;
  Particle(PVector _pos, PVector _velocity, float _maxSpeed, float _weight, float _size, color _color, float _KB, float _KD)
  {
    pos =_pos;
    vel = _velocity;
    maxSpeed = _maxSpeed;
    weight = _weight;
    size = _size;
    color_p = _color;

    // Priodidades de la bandada de pajaros. Cuanto mas cerca de 1, mayor priodidad tendra
    KB = _KB; // Priodidad de seguir a la bandada
    KD = _KD; // Prioridad de seguir al objetivo
    KC = 3.5f; // Prioridad de evitar colisiones
  }

  void Move(PVector _destPos, CollisionObj[] _colliders)
  {
    PVector strenght= new PVector(0.0, 0.0, 0.0);
    PVector accel = new PVector(0.0, 0.0, 0.0);
    PVector dest = new PVector(0.0, 0.0, 0.0);
    //Flock es bandada
    PVector flock = new PVector(0.0, 0.0, 0.0);
    //El objeto con el que colisiona
    PVector collisionObject = CheckCollision(_colliders);

    dest = UnitaryVector(pos, _destPos);
    flock = UnitaryVector(pos, FlockCenter());
    collisionObject = UnitaryVector(pos, collisionObject);

    strenght.x = KD * dest.x + KB * flock.x + KC * collisionObject.x;
    strenght.y = KD * dest.y + KB * flock.y + KC * collisionObject.y;
    strenght.z = KD * dest.z + KB * flock.z + KC * collisionObject.z;

    accel.x = strenght.x/weight;
    accel.y = strenght.y/weight;
    accel.z = strenght.z/weight;

    vel.x += accel.x * deltaTime;
    vel.y += accel.y * deltaTime;
    vel.z += accel.z * deltaTime;

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

  PVector CheckCollision(CollisionObj[] _colliders)
  {

    for (int i = 0; i < _colliders.length; i++)
    {
      if (isColliding(pos, _colliders[i].pos, size, _colliders[i].size)) //Si esta chocando con algo
      {
        //Devolverle la posicion de el objeto encontrado
        return _colliders[i].pos;
      }
    }

    //Si no esta tocando nada devuelve un Vector 0
    return new PVector(0, 0, 0);
  }

  boolean isColliding(PVector _p1, PVector _p2, float _s1, float _s2)
  {
    if (_p1.x - _s1 <= _p2.x + _s2 && _p1.x + _s1 >= _p2.x - _s2
      && _p1.y - _s1 <= _p2.y + _s2 && _p1.y + _s1 >= _p2.y - _s2
      && _p1.z - _s1 <= _p2.z + _s2 && _p1.z + _s1 >= _p2.z - _s2)
    {
      return true;
    }

    return false;
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
