**Act as a Senior Game Developer and Godot Engine Expert.**
I am developing a First-Person Horror puzzle game titled "Happy's Humble Care: Funbot's Revenge" using **Godot 4.x** and **GDScript**. I need you to generate production-ready, highly optimized, and well-documented code for the core game systems based on my Game Design Document (GDD).
**Strict Technical Requirements & Best Practices:**
 1. **Architecture:** Use Object-Oriented Programming (OOP) principles and a highly modular design. Rely heavily on Godot's Signal system for decoupled communication between nodes (e.g., Player should not directly call Door methods; use signals or an Event Bus).
 2. **State Machines:** Implement a Finite State Machine (FSM) pattern for the Enemy AI (Funbot) and the Player Controller.
 3. **Clean Code:** Adhere to strict GDScript style guides. Use static typing wherever possible (e.g., var speed: float = 5.0, func do_something() -> void:). Keep classes small and focused on a Single Responsibility.
 4. **Export Variables:** Use @export extensively so level designers can tweak variables (speed, detection radius, required item counts) directly in the Godot Inspector without touching the code.
 5. **Structure:** For every script you provide, clearly state the required Node hierarchy (e.g., CharacterBody3D -> CollisionShape3D -> Camera3D).
**Game Overview & Required Systems:**
The game involves a player waking up in a ruined kindergarten, solving puzzles, and fleeing from a malfunctioning robot-nanny (Funbot).
Please design and generate the GDScript code and Node structure for the following core foundational systems:
**System 1: First-Person Player Controller & Inventory**
 * A CharacterBody3D controller with smooth walking, running, and jumping mechanics.
 * A lightweight Inventory Component that can store integers for specific items (e.g., toys_collected, batteries_collected) and emit signals when the count changes.
 * A RayCast3D-based Interaction Component to detect and interact with objects in the world (doors, items, buttons) using a custom Interactable class or group.
**System 2: Modular Interactables**
 * Create a base Interactable.gd class.
 * Create specific inherited classes for:
   * **Collectibles:** Items (Toys, Batteries) that queue_free() on interaction and update the player's inventory.
   * **Receptacles:** Objects that require a specific number of items to trigger an event (e.g., a Toy Slot that requires 4 toys to emit an unlocked signal).
   * **Doors:** An automated door script that listens to signals (like the Toy Slot's unlocked signal) to play an opening animation.
**System 3: Enemy AI Framework (Funbot)**
 * A CharacterBody3D using NavigationAgent3D.
 * An FSM with at least two starting states: StateChase (navigating towards the player's global position) and StateScriptedSequence (moving to a specific Node3D marker for cutscenes, ignoring the player).
**System 4: The Cutscene/Event Manager**
 * Provide a generic script for triggering the "Smart Escape" sequence. It should temporarily disable player input, play an animation (or move the camera to simulate hiding in a closet), force the Enemy AI into a StateScriptedSequence to run towards a trap, and trigger a camera shake and sound effect (metallic robotic scream) upon the AI reaching the trap.
**Initial Request:**
Do not generate the entire game at once. To start, please provide the complete Node architecture and GDScript code for **System 1 (Player Controller & Inventory)** and **System 2 (Modular Interactables)**. Make sure the code is production-ready, heavily commented, and explicitly shows how the Player interacts with a Collectible and a Receptacle using signals.
