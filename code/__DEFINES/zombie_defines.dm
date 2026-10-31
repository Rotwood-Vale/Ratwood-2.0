#define ZOMBIE_INFECTION_PROBABILITY 20 	/// Zombie infection probability for bites on a wound
#define ZOMBIE_INFECTION_TIME 3 MINUTES // How much time it takes to turn into a zombie with bite/wound bite

/// Rot accumulated before a corpse rises as a deadite. Lives here rather than in rotting.dm because
/// the ghost lock in observer.dm uses it too
#define DEAD_TO_ZOMBIE_TIME 4 MINUTES
