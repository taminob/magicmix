# magicmix

This is a small proof-of-concept on a 3D game written in Godot.
It is fully written in GDScript.

It contains the skeleton of various RPG elements like

- Inventory system
- Spell system
- Skill trees
- Dialogue system
- Experience system (WIP)
- NPC AI (for more see AI section)
- ...

## Usage

Open the project in Godot and press "Play".

The tags should contain a playable version at different key points in development.
Use `git checkout <tag>` to switch to one of the following tags:

- `2d`
- `3d-utility-ai`
- `3d-behavior-tree-ai`
- `3d-goap-ai`
- `v-0.1`
- `v-0.2`

I recommend to close Godot before switching to a different version.
To checkout the most recent version,
use `git checkout main` (stable) or `git checkout dev` (unstable).

Beware that everything in this repository is unstable. :)

### Controls

#### General

Pause menu: `<Esc>`
Console: `<` or `°` or `<Shift>+.`

#### Movement

Movement: `WASD`
Jump: `<Space>`
Sprint: `<Shift>`
Walk: `<Alt>`
Crouch: `<Control>`
Switch to spirit mode: `<Tab>`
Spirit sprint: `<Space>`

#### Interaction/Dialogue

Interact: `F`
Switch answer: `<Arrow Up>/<Arrow Down>`
Choose answer: `<Enter>`

#### Skills

To use these shortcuts, the currently controlled character has to own these skills.
This can be done via the skill tree or with spell crafting.

Switch element: `<1-4>`
Cast spell: `Q/E/R/T/Y`

#### Panels

Open/Close last panel: `X`
Open/Close inventory panel: `I`
Open/Close spell crafting panel: `C`
Open/Close spells panel: `K`
Open/Close skill tree panel: `Z`
Open/Close character panel: `P`

### Console

- `help`: List all commands
- `load <level>`: Load level
- `exit`: Close console
- `reload`: Reload current level
- `save`: Save game
- `quit [force]`: Quit game; pass `force` to quit without saving
- `inspect <character>`: Show debug information about character
- `control <character>`: Make character the current player character
- `spawn <character>`: Spawn character in current level
- `respawn`: Reset player to spawn point
- `kill <character>`: Kill character
- `give_all`: Give player all available (except mutually exclusive) skills
- `heal`: Heal player character

Typing a command without its argument will list all possible arguments.

## AI

I tried different approaches for the AI.

- [Behavior Trees](https://github.com/taminob/magicmix/tree/3d-behavior-tree-ai/characters/state/ai)
- [Goal Oriented Action Planner (GOAP)](https://github.com/taminob/magicmix/tree/3d-goap-ai/characters/state/ai)
- [First Utility AI](https://github.com/taminob/magicmix/tree/3d-utility-ai/characters/state/ai)
- [Final Utility AI](https://github.com/taminob/magicmix/tree/main/characters/state/ai)

Behavior Trees might be a pretty good way to implement a solid AI,
but this requires manual work for different behaviors.

A Goal Oriented Action Planner looked like the solution to this problem.
However, defining the exact outcome of especially combat actions was impossible
due to player interaction.
I tried to fix this by switching to a behavior tree in combat,
but I was not able to design a good enough behavior tree.
Additionally, because of the wide range of actions,
the planning process caused performance issues.

Before switching to a GOAP AI, I tried a Utility AI.
However, the behavior did not work out as expected.

Finally, after testing the GOAP approach,
I decided to revisit the idea of a Utility AI.
This second Utility AI offered good enough results at a neglectable performance impact.
