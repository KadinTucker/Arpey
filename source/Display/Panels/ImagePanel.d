module display.panel.ImagePanel;

import display.Display;
import display.panel.Panel;
import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;

class ImagePanel : Panel {

    SDL2Texture image;

    this(int x, int y, int width, int height, string imageFilename, Display display, string name){
        super(RGBColor(0, 0, 0), x, y, width, height, name);
        this.image = new SDL2Texture(display.renderer, SDLResource.sdlimage.load(imageFilename));
    }

    ~this(){
        this.image.destroy();
    }

    override void render(SDL2Renderer renderer){
        renderer.copy(this.image, x, y);
    }
}
