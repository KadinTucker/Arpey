module display.Display;

import display.gamestate.GameState;
import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;


/**
 * A sructure to store red, green, and blue colors.
 */

struct RGBColor {
    int r;
    int g;
    int b;
}

/**
 * A class containing static sdl resources for use in other locations.
 * Allows for easy access from anywhere, regular destruction of resources, and for initialization during runime.
 */
class SDLResource {

    static SDL2 sdl;
    static SDLTTF sdlttf;
    static SDLImage sdlimage;

    static void initialize(){
        sdl = new SDL2(null);
        sdlttf = new SDLTTF(sdl);
        sdlimage = new SDLImage(sdl);
    }

    static void destroyAllResources(){
        sdl.destroy();
        sdlttf.destroy();
        sdlimage.destroy();
    }

}

/**
 * The main display object.
 * Contains the window and renderer, as well as the gamestate and whether or not the program has been quit.
 */
class Display {

    SDL2Window window;
    SDL2Renderer renderer;
    bool quit;
    GameState gamestate;

    /**
     *
     */
    this(int width, int height){
        this.window = new SDL2Window(SDLResource.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN |  SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        this.renderer = new SDL2Renderer(this.window);
        this.window.setTitle("Arpey");
    }

    ~this(){
        this.window.destroy();
        this.renderer.destroy();
        this.gamestate.destroy();
    }

    void handleEvents(){
        SDL_Event event;
        while(SDLResource.sdl.pollEvent(&event)){
            if(event.type == SDL_QUIT){
                this.quit = true;
            }else{
                this.gamestate.handleEvent(event);
            }
        }
    }

    void run(){
        this.gamestate.displayAll();
        this.handleEvents();
    }

}
