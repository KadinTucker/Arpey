module data.Player;

import data.Tile;

class Player {

    int[3] color;
    string name;
    int[2] capital;

    this(int[3] color, string name, int[2] capital, Tile[][] world){
        this.color = color;
        this.name = name;
        this.capital = capital;
        world[capital[0]][capital[1]].owner = this;
        world[capital[0]][capital[1]].sovereignty = 10;
        world[capital[0]][capital[1]].workers = 10;
    }

}
