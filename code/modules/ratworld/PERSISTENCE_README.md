# Ratworld World Persistence System

## Overview
The world persistence system allows buildings, structures, and other objects to persist across server restarts, creating a truly persistent world for Ratworld.

## Architecture

### Core Components

1. **world_persistence.dm** - Main save/load system
   - Round-end full world saves
   - Autosave with crash recovery
   - Timestamped backups
   - Admin tools for manual save/load

2. **object_serialization.dm** - Object-specific serialization
   - Defines how each object type saves/loads its state
   - Base implementations for common object types
   - Extensible for custom objects

3. **construction_hooks.dm** - Transaction logging
   - Tracks all building/destruction events
   - Logs to transaction file for crash recovery
   - Admin tools for managing builds
   - Approval system for major structures

### How It Works

#### Saving (Round End)
1. At round end, `SSpersistence.CollectData()` is called
2. `RatworldSaveWorld()` iterates all persistent objects
3. Each object serializes itself via `Write(savefile)`
4. Full state saved to `data/ratworld/world_state.sav`
5. Transaction log cleared (we just did a full save)
6. Timestamped backup created

#### Crash Recovery (Transaction Log)
1. During round, every build/destroy action logged instantly
2. Logs appended to `data/ratworld/transactions.log`
3. Buffer flushed every 10 seconds (no lag)
4. On server restart after crash:
   - Load last official save
   - Replay transaction log from that point
   - Recover all builds since last save

#### Loading (Round Start)
1. `RatworldLoadWorld()` called during `SSpersistence.Initialize()`
2. Check if autosave is newer than official save (crash detection)
3. Load from appropriate file
4. Each object deserializes itself via `Read(savefile)`
5. Objects recreated at saved positions with saved state

## Adding Persistence to Objects

### Simple Persistence
Just mark the object as persistent:
```dm
/obj/structure/my_building
    persistent = TRUE
```

### Custom Serialization
Override Write/Read for special properties:
```dm
/obj/structure/my_building/Write(savefile/F)
    F["custom_var"] << custom_var
    F["some_list"] << some_list
    return ..() // Call parent!

/obj/structure/my_building/Read(savefile/F)
    F["custom_var"] >> custom_var
    F["some_list"] >> some_list
    return ..()
```

### What NOT to Save
Mark these with /tmp to prevent auto-saving:
```dm
/obj/structure/my_building
    var/tmp/runtime_cache        // Calculated at runtime
    var/tmp/mob/last_user       // Never save mob references!
    var/tmp/visual_effects      // VFX that get recreated
    var/durable_data            // This WILL save (not tmp)
```

## Admin Tools

### Available Verbs
- **Ratworld: Save World** - Manually trigger a world save
- **Ratworld: Load World** - Manually reload world (WARNING: replaces current state!)
- **Ratworld: Delete Player Builds** - Remove all builds by a player from last X hours
- **Ratworld: Build Statistics** - View who built what

### Examining Objects
Admins see extra info when examining persistent objects:
- Whether it's persistent
- Whether it's approved
- Who built it
- When it was built

### Approval System
Major structures can require admin approval before persisting:
```dm
/obj/structure/castle_wall/Initialize()
    . = ..()
    RequestPersistenceApproval(usr)
```

## File Structure

```
data/
  ratworld/
    world_state.sav          - Official round-end save
    world_autosave.sav       - Latest crash-recovery save
    transactions.log         - Build/destroy event log
    backups/
      world_YYYY-MM-DD_hh-mm-ss.sav  - Historical backups
```

## Configuration

In world_persistence.dm:
```dm
#define TRANSACTION_FLUSH_INTERVAL 100  // How often to write log (ds)
#define MAX_BACKUPS 10                  // How many backups to keep
```

## Performance

### High Population Optimization
- Transaction logging is instant (microseconds per event)
- Transaction buffer flushed asynchronously in background
- Full saves only at round end (no mid-round lag)
- I'm hoping this shit doesn't lag with our pop.

### What Causes Lag
- Full world saves (only at round end)
- Loading world on startup (acceptable one-time cost)

### What Doesn't Cause Lag (hopefully)
- Transaction logging (instant append to buffer)
- Transaction flushing (background process)

## Anti-Grief Features

### Ownership Tracking
Every persistent object tracks:
- `builder_ckey` - Who built it
- `build_time` - When it was built
- `approved_persistent` - Admin approval status

### Recovery Options
1. **Timestamped backups** - Rollback to any previous save
2. **Transaction log** - Replay history to specific point
3. **Delete by player** - Remove all builds by a griefer
4. **Approval system** - Major changes need admin OK

### Forensics
All building/destruction logged to:
- Transaction log file (for replay)
- world.log (for admin review)
- Admin alerts (for live monitoring)

## Troubleshooting

### Save Failed
Check logs for:
- Disk space issues
- Permission errors
- Object serialization errors (catch blocks will log them)

### Load Failed
Possible causes:
- Save file doesn't exist (fresh server)
- Corrupted save file (restore from backup)
- Object type no longer exists (will log and skip)

### Objects Not Persisting
Check:
- Is `persistent = TRUE` set?
- Is `approved_persistent = TRUE`?
- Is the object a mob? (mobs never persist)
- Check world.log for serialization errors

### Server Crashed, Lost Progress
- If autosave worked: Should auto-recover on restart
- If autosave failed: Restore from latest backup
- Check transaction log for what was lost

## Future Enhancements

### Planned
- [ ] Backup cleanup (auto-delete old backups)
- [ ] Web-based build log viewer
- [ ] Delta saves (only save changes)
- [ ] Zone-based saving (save specific areas)
- [ ] SQL database backend for huge worlds

### Possible
- [ ] Multi-server world sharing
- [ ] Real-time replication
- [ ] Player-visible build history
- [ ] Undo/redo system for admins

## Testing Checklist

Before deploying to live:
1. Test full save/load cycle
2. Test crash recovery (kill server mid-round)
3. Test with 100+ dummy objects
4. Test serialization of common objects
5. Test admin tools (delete builds, etc.)
6. Test backup rotation
7. Monitor performance during load tests

## Support

For issues or questions:
1. Check world.log for errors
2. Check transaction log for missing events
3. Review this documentation
4. Contact Ratworld dev team
