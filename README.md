## Game Design
### Objective
Balance the lever on the fulcrum in every level. With every level the
difficulty will rise and will demand a near perfect balance. The window
allowed for the balance perfection will be bigger in the beginning.


### Gameplay Mechanics
The game employes the simple physics of balancing weights. A player can
tap either on the left or the right part of the screen. Depending on
where the tap took place the object will fall on that side of the lever.
The world contains of the fulcrum, lever, baskets and weighted objects.

The objects entering the world are selected at random and hence can be
of different weights. Every attempt is timed and the player is required
to have the lever balanced such that it falls in the allowed window
before the timer expires. The window size allows for the variation in
level creation.


### Level Design
As mentioned earlier the levels are focused on making the balance close
to perfect as the player levels up in the game. This balance limit is
dictated by the balance window shown on both the sides of the screen. If
the lever falls in the higlighted balance window at the end of the timer
the player will successfully clear the level. Initial levels will have
much wider window hence making it easier to pass. The shortening of the
window with every increase in the window will make the experience
challenging and fun.

The levels are laid out horizontally to allow more room for player taps
and provider a better view of the balance which has more width then it
has height. The player get to chose the level depending upon how far
he/she has reached in the game.


## Technical
### Scenes
* Main Menu (needs continue button to avoid level select when possible)
* Level Select
* Gameplay

### Controls/Input
* Tap based controls
  * Tap on left to have an object on left
  * Tap on right to have an object on right
  * Tap on resart button to restart
  * Tap on pause button to pause

### Classes/CCBs
* Scenes
  * Main Menu
  * Level Select
  * Gameplay
* Nodes/Sprites
  * Entity (abstract superclass)
    * Weighted objects
  * WorldObject (abstract superclass)
    * Fulcrum
    * Lever
    * Baskets


## MVP Milestones
### Week 1
* Main Menu
  * Entity movement
    * Objects fall
* Control scheme for player

### Week 2
* Implement physics
* Balance movement

### Week 3
* Need to implement timer
* Finish and polish balance movement
* Scoring

### Week 4
* Level design
* Refine levels -- playtest even more often!!
* Refine control scheme

### Week 5
* Level select scene
* Determine what other polish is needed

### Week 6
* User feedback, testing and polishing

## PM notes by Sohil
* Same as last week's as Harshit is stuck with level completion logic
* Discuss issue with course TAs
* Scoring should be done
* Win/Loss detection
