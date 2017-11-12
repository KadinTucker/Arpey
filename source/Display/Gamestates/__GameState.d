module display.gamestate.GameState;

import display.Display;
import display.panel.Panel;
import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;
import std.stdio;

abstract class GameState {

    Display display;
    Panel[] panels;

    this(Display display){
        this.display = display;
    }

    string[] getPressedButtons(int x, int y){
        string[] buttonsPressed;
        foreach(button; this.panels){
            if(button.isPointIn(x, y)){
                buttonsPressed ~= button.name;
            }
        }
        return buttonsPressed;
    }

    abstract void displayAll();
    abstract void handleEvent(SDL_Event event);
    abstract void handleButtons(string[] pressed);

}
