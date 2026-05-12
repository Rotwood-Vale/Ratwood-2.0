#define GNOLL_SCALING_RANDOM  0 // Mode 0: Pick one of the supported gnoll scaling modes at random.
#define GNOLL_SCALING_DYNAMIC 1 // Mode 1: Starts at 2 slots, then adds slots as population rises.
#define GNOLL_SCALING_FLAT    2 // Mode 2: Uses 2 slots below 125 players and 4 slots at 125+.
#define GNOLL_SCALING_DOUBLE  3 // Mode 3: Always keep gnolls at two slots.
#define GNOLL_SCALING_NONE    4 // Mode 4: Disable gnoll spawning entirely (0 slots).
