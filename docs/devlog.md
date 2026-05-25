## Development Log

This is an ongoing record of development in the _Star Battle HD_ project.

### Milestone 1: 2026-05-24

Demo Stage 1 is considered feature complete.

- Direct control of one starship which can rotate, accelerate, and fire a missile weapon.
- Large gameplay area constrained by wrapping object positions at the edges.
- Subtle background pattern of stars to convey a sense of motion, seamlessly repeating at the edges.
- Terrain in the form of stationary base of operations and other starships stationed in the area.
- Destructible objects with which to practice missile firing and collision mechanics.
- Asteroids slowly spawn up to a low population limit, providing a constant gameplay loop.

Bugs and anti-patterns are identified for further development.

- "programs.lua" contains a lot of repeated code hacked together to make the initial demo work without introducing half-baked solutions to the class modules in "src".
- "graphics.lua" is in need of refactoring and some of the asset-specific code might be delegated to specialized modules.
- Whether to pass x,y coordinate pairs or "position" objects to functions and methods should be standardized.
- The way object components like "sprite" and "hitbox" are accessed should be standardized. (for instance, call "object.sprite.paint" instead of "object.paint".)
- Bullets should be able to damage starships so the "damaged" sprites can be used.
