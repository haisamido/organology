# organology

# How to use:

The default CONTAINER_ENGINE is set to docker for now

```
make clean
make database-test
```

which is the same as

```
make clean CONTAINER_ENGINE=docker
make database-test CONTAINER_ENGINE=docker
```

or

```
make clean CONTAINER_ENGINE=podman
make database-test CONTAINER_ENGINE=podman
```

# Units (for later use TBD)
```
grams  = lbm * 453.592292 (mass, and not weight)
grams/cm = lbm/in * 178.579673 (mass per length, mu)
tension of lbm to metric = tension(lbm)* 444822.08503418 = tension(lbm) * 453.592292*980.665 
g0     = 980.665 cm/s**2 (gravity)

strings
all units must be in metric, g/mm, g, mm, tension => Force => F = m*a => kg * m/s**2 => g * mm/s**2
mass_per_length = g/cm
scale length    = cm
tension        ~= kg (which really mass and not force)

9806.65 = gravity in mm/s**2
980.665 = gravity in cm/s2

```

