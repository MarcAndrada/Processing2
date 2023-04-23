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
  // KC separacion de las colisiones
  float KC;
  // Fuerza constante del damping
  float dampingForce;
  color color_p;

  PVector verletLastPos;


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
    KC = 6f; // Prioridad de evitar colisiones
    dampingForce = 6;
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

    //Calculamos cual es la velocidad de las fuerzas que mueven las particulas
    float totalSpeed = KD + KB;
    //Aplicamos la friccion (damping)
    strenght.x += -dampingForce * totalSpeed;
    strenght.y += -dampingForce * totalSpeed;
    strenght.z += -dampingForce * totalSpeed;


    accel.x = strenght.x/weight;
    accel.y = strenght.y/weight;
    accel.z = strenght.z/weight;

    switch (currentSolver) 
    {
      case Solver.EULER:
        EulerSolver();
        break;
      case Solver.VERLET:
        VerletSolver();
        break;
      default :
        break;	  
    }

    
  }

  void EulerSolver()
  {
    vel.x += accel.x * deltaTime;
    vel.y += accel.y * deltaTime;
    vel.z += accel.z * deltaTime;

    pos.x = pos.x + vel.x * deltaTime;
    pos.y = pos.y + vel.y * deltaTime;
    pos.z = pos.z + vel.z * deltaTime;

  }

  void VerletSolver(PVector _accel)
  {
    PVector lastPos = new PVector(0,0);  
    lastPos = pos;
    //Hacemos la formula del solver de verlet que es, pos = pos*2 - verletLastPos + _accel * (deltaTime * 2 (delta al cuadrado)) 
   posicion = new PVector(pos.x * 2 - verletLastPos.x + _accel.x * (deltaTime * 2) // Esta es la X
                        , pos.y * 2 - verletLastPos.y + _accel.y * (deltaTime * 2) // Esta la Y
                        , pos.z * 2 - verletLastPos.z + _accel.z * (deltaTime * 2)); // Esta es la Z
    verletLastPos = lastPos;

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
