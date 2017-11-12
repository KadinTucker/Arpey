module display.panel.TextPanel;

import display.Display;
import display.panel.Panel;
import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;

class TextPanel : Panel {

    SDL2Texture textTexture;

    this(RGBColor color, int x, int y, string text, int fontsize, Display display, string name){
        SDLFont font = new SDLFont(SDLResource.sdlttf, "Cantarell-Regular.ttf", fontsize);
        SDL2Surface renderedText = font.renderTextBlended(text, SDL_Color(0, 0, 0, 255));
        this.textTexture = new SDL2Texture(display.renderer, renderedText);
        super(color, x, y, cast(int)(fontsize * 0.67 * text.length), fontsize + 10, name);
        font.destroy();
        renderedText.destroy();
    }

    ~this(){
        this.textTexture.destroy();
    }

    void changeText(string newText, int fontsize, Display display){
        this.textTexture.destroy();
        SDLFont font = new SDLFont(SDLResource.sdlttf, "Cantarell-Regular.ttf", fontsize);
        SDL2Surface renderedText = font.renderTextBlended(newText, SDL_Color(0, 0, 0, 255));
        this.textTexture = new SDL2Texture(display.renderer, renderedText);
        this.width = cast(int)(fontsize * 0.67 * newText.length);
        this.height = fontsize + 10;
        font.destroy();
        renderedText.destroy();
    }

    override void render(SDL2Renderer renderer){
        super.render(renderer);
        renderer.copy(textTexture, x + 5, y);
    }

}
