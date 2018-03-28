# Tic-Tac-Toe
A simple touch-gesture-based game of Tic-Tac-Toe for iOS

### Developer Information
* Owen LeJeune
* 101034825

### Usage and Tesing
1. Begin the game by drawing a game board.
    * Support for multitouch gestures to draw the lines has been implemented
    * Once four lines have been drawn, the game will be ready to accept character input
2. Draw either and X or and O in one of the sections of the board to begin
3. If and illegal character or 2 of the same characters in a row (eg. X followed by X) are drawn, they will not count and will be removed from the board.
4. The game will display a prompt at the bottom on the screen, displaying the current character to be drawn (X or O)
5. A printout of the board is displayed in the console after every move
6. When a player gets 3 in a row, a line will drawn the winning row, and the prompt will display the winner
7. Once the game has finished in either a win or tie, double tapping on the screen will clear the screen and a new game board can be drawn

### Enhancements
* Label to display current players turn and game completion state (win/tie)
* Different colours when drawing X or O
