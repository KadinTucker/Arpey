module display.panel.Panel;

import display.Display;
import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;

class Panel {

    RGBColor color;
    int x;
    int y;
    int width;
    int height;
    string name;

    this(RGBColor color, int x, int y, int width, int height, string name){
        this.color = color;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.name = name;
    }

    void render(SDL2Renderer renderer){
        renderer.setColor(this.color.r, this.color.g, this.color.b);
        renderer.fillRect(this.x, this.y, this.width, this.height);
        renderer.setColor(0, 0, 0);
        renderer.drawRect(this.x, this.y, this.width, this.height);
    }

    bool isPointIn(int x, int y){
        return x - this.x >= 0 && x - this.x <= this.width && y - this.y >= 0 && y - this.y <= this.height;
    }

}
