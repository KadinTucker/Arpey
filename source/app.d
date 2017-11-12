import std.stdio;
import display.Display;
import display.gamestate.GameState;
import display.gamestate.Editor;
import display.gamestate.MainState;

import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;
import std.stdio;

void main(){
	SDLResource.initialize();
	writeln("init resources");
    Display display = new Display(1300, 650);
	writeln("constructed display");
    display.gamestate = new MainState(display);
    while(!display.quit){
		display.run();
    }
    display.destroy();
    SDLResource.destroyAllResources();
}
