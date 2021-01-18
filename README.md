# The Knight's Gambit
A simple iOS app that lists all pssible paths a knight can take between two positions in 3 moves.

## Functionality
The user selects the starting and ending position and lets the knight go for a ride! 🐴

If any paths are found, the user can check them one by one, or all at once by being too patient or... Impatient. (Hint: try the next/previous button when you're at the first/last path).

The board can be reset by choosing another square, once two squares have already been selected.

## The Chess Solver
The chess solver contains some checks before trying any move, such as a distance check (the knight can't travel more than 2*3 squares in 3 moves on an axis) and a color check (the knight can't end up on the same color in 3 moves.)

There is also a heuristic distance checking function that checks if the solver should consider a move before perfoming it that uses the principle that uses the same principle as the color check.

### Other Notes
This app was created on a cold quarantine weekend. Hopefully, a fireplace, hot chocolate and music were enough help!

And yes... The name is inspired by Netflix. ♛🍿🎬
