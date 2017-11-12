module display.gamestate.MainState;

import display.Display;
import display.panel.Panel;
import display.panel.TextPanel;
import display.gamestate.GameState;
import data.Tile;
import data.Player;
import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;
import std.stdio;
import std.conv;
import std.algorithm;

enum MoveActions {
    NONE = 0,
    MOVE_FOOD = 1,
    MOVE_MATERIAL = 2,
    MOVE_MONEY = 3,
    MOVE_FARMER = 4,
    MOVE_WORKER = 5,
    MOVE_MERCHANT = 6,
    MOVE_POLITICIAN = 7,
    MOVE_SOLDIER = 7,
}

class MainState : GameState {

    Tile[][] world;
    SDL2Texture gridImage;
    Tile selectedTile;
    Player[] allPlayers = [];
    MoveActions moveAction = MoveActions.NONE;

    this(Display display){
        super(display);
        this.allPlayers ~= null;                                            //null is barbarian
        this.display.window.setTitle("Arpey");
        this.gridImage = new SDL2Texture(display.renderer, SDLResource.sdlimage.load("grid_element_small.png"));
        for(int x = 0; x < 40; x++){
            Tile[] blankArray;
            world ~= blankArray;
            for(int y = 0; y < 24; y++){
                world[x] ~= new Tile([x, y]);
            }
        }
        this.allPlayers ~= new Player([150, 40, 40], "Kxoe", [0, 0], world);
        foreach(row; world){
            foreach(tile; row){
                tile.setTempSovKeys(allPlayers);
            }
        }
        this.selectedTile = world[0][0];
        this.initializePanels();
        this.setLabelAmounts();
    }

    ~this(){
        foreach(panel; this.panels){
            panel.destroy();
        }
        this.gridImage.destroy();
    }

    void initializePanels(){
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 30, "+  ", 12, display, "AddFarmer");
        //this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 60, "+  ", 12, display, "AddWorker");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 90, "+  ", 12, display, "AddMerchant");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 120, "+  ", 12, display, "AddPolitician");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 150, "+  ", 12, display, "AddSoldier");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 190, "+  ", 12, display, "AddHouse");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 220, "+  ", 12, display, "AddRoad");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 250, "+  ", 12, display, "AddGranary");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 280, "+  ", 12, display, "AddWorkshop");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 310, "+  ", 12, display, "AddMarket");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 340, "+  ", 12, display, "AddCourthouse");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 370, "+  ", 12, display, "AddFort");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 410, "+  ", 12, display, "AddFood");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 440, "+  ", 12, display, "AddMaterials");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1030, 500, "+  ", 12, display, "AddSovereignty");

        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 30,  "Farmers:     ", 12, display, "FarmerLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 60,  "Workers:     ", 12, display, "WorkerLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 90,  "Merchants:   ", 12, display, "MerchantLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 120, "Politicians: ", 12, display, "PoliticianLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 150, "Soldiers:    ", 12, display, "SoldierLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 190, "Houses:      ", 12, display, "HouseLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 220, "Roads:       ", 12, display, "RoadLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 250, "Granaries:   ", 12, display, "GranaryLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 280, "Workshops:   ", 12, display, "WorkshopLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 310, "Markets:     ", 12, display, "MarketLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 340, "Courthouses: ", 12, display, "CourthouseLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 370, "Forts:       ", 12, display, "FortLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 410, "Food:        ", 12, display, "FoodLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 440, "Materials:   ", 12, display, "MaterialsLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 470, "Money:       ", 12, display, "MoneyLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 500, "Sovereignty: ", 12, display, "SovereigntyLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 540, "Population:  ", 12, display, "PopulationLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 570, "Land:        ", 12, display, "LandLabel");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1060, 600, "Owner:       ", 12, display, "OwnerLabel");

        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 30,  " ", 12, display, "FarmerAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 60,  " ", 12, display, "WorkerAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 90,  " ", 12, display, "MerchantAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 120, " ", 12, display, "PoliticianAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 150, " ", 12, display, "SoldierAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 190, " ", 12, display, "HouseAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 220, " ", 12, display, "RoadAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 250, " ", 12, display, "GranaryAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 280, " ", 12, display, "WorkshopAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 310, " ", 12, display, "MarketAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 340, " ", 12, display, "CourthouseAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 370, " ", 12, display, "FortAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 410, " ", 12, display, "FoodAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 440, " ", 12, display, "MaterialsAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 470, " ", 12, display, "MoneyAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 500, " ", 12, display, "SovereigntyAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 540, " ", 12, display, "PopulationAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 570, " ", 12, display, "LandAmt");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1150, 600, " ", 12, display, "Owner");

        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 20, 612, "End Turn", 12, display, "EndTurn");

        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1005, 30,  "@  ", 12, display, "MoveFarmer");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1005, 60,  "@  ", 12, display, "MoveWorker");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1005, 90,  "@  ", 12, display, "MoveMerchant");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1005, 120, "@  ", 12, display, "MovePolitician");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1005, 150, "@  ", 12, display, "MoveSoldier");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1005, 410, "@  ", 12, display, "MoveFood");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1005, 440, "@  ", 12, display, "MoveMaterials");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 1005, 470, "@  ", 12, display, "MoveMoney");

        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 500, 600, "/\\ ", 10, display, "MoveUp");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 525, 615, "> ", 10, display, "MoveRight");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 500, 630, "\\/ ", 10, display, "MoveDown");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 480, 615, "< ", 10, display, "MoveLeft");
        this.panels ~= new TextPanel(RGBColor(200, 200, 200), 450, 615, "X  ", 10, display, "MoveCancel");
    }

    void setLabelAmounts(){
        (cast(TextPanel)this.panels[33]).changeText(to!string(this.selectedTile.farmers) ~ " ", 12, display);
        (cast(TextPanel)this.panels[34]).changeText(to!string(this.selectedTile.workers) ~ " ", 12, display);
        (cast(TextPanel)this.panels[35]).changeText(to!string(this.selectedTile.merchants) ~ " ", 12, display);
        (cast(TextPanel)this.panels[36]).changeText(to!string(this.selectedTile.politicians) ~ " ", 12, display);
        (cast(TextPanel)this.panels[37]).changeText(to!string(this.selectedTile.soldiers) ~ " ", 12, display);
        (cast(TextPanel)this.panels[38]).changeText(to!string(this.selectedTile.houses) ~ " ", 12, display);
        (cast(TextPanel)this.panels[39]).changeText(to!string(this.selectedTile.roads[0]) ~ " ", 12, display);
        (cast(TextPanel)this.panels[40]).changeText(to!string(this.selectedTile.granaries[0]) ~ " ", 12, display);
        (cast(TextPanel)this.panels[41]).changeText(to!string(this.selectedTile.workshops[0]) ~ " ", 12, display);
        (cast(TextPanel)this.panels[42]).changeText(to!string(this.selectedTile.markets[0]) ~ " ", 12, display);
        (cast(TextPanel)this.panels[43]).changeText(to!string(this.selectedTile.courthouses[0]) ~ " ", 12, display);
        (cast(TextPanel)this.panels[44]).changeText(to!string(this.selectedTile.forts[0]) ~ " ", 12, display);
        (cast(TextPanel)this.panels[45]).changeText(to!string(this.selectedTile.food) ~ " ", 12, display);
        (cast(TextPanel)this.panels[46]).changeText(to!string(this.selectedTile.materials) ~ " ", 12, display);
        (cast(TextPanel)this.panels[47]).changeText(to!string(this.selectedTile.money) ~ " ", 12, display);
        (cast(TextPanel)this.panels[48]).changeText(to!string(this.selectedTile.sovereignty) ~ " ", 12, display);
        (cast(TextPanel)this.panels[49]).changeText(to!string(this.selectedTile.population[0]) ~ " / " ~ to!string(this.selectedTile.population[1]), 12, display);
        (cast(TextPanel)this.panels[50]).changeText(to!string(this.selectedTile.land) ~ " / " ~ "500", 12, display);
        if(this.selectedTile.owner !is null){
            (cast(TextPanel)this.panels[51]).changeText(to!string(this.selectedTile.owner.name) ~ " ", 12, display);
        }else{
            (cast(TextPanel)this.panels[51]).changeText("No one ", 12, display);
        }
    }

    override void displayAll(){
        this.display.renderer.setViewportFull();
        this.display.renderer.setColor(225, 225, 225, 255);
        this.display.renderer.clear();
        this.displayGrid();
        foreach(panel; this.panels){
            panel.render(this.display.renderer);
        }
        this.display.renderer.present();
    }

    override void handleEvent(SDL_Event event){
        if(event.type == SDL_MOUSEBUTTONDOWN){
            if(event.button.button == SDL_BUTTON_LEFT){
                this.selectNewTile(event.button.x, event.button.y);
                this.handleButtons(this.getPressedButtons(event.button.x, event.button.y));
                this.setLabelAmounts();
            }
        }
    }

    override void handleButtons(string[] pressed){
        if(pressed.canFind("EndTurn")){
            this.endTurn();
        }else if(pressed.canFind("AddFarmer")){
            this.selectedTile.addFarmer();
        }else if(pressed.canFind("AddMerchant")){
            this.selectedTile.addMerchant();
        }else if(pressed.canFind("AddPolitician")){
            this.selectedTile.addPolitician();
        }else if(pressed.canFind("AddSoldier")){
            this.selectedTile.addSoldier();
        }else if(pressed.canFind("AddHouse")){
            this.selectedTile.addHouse();
        }else if(pressed.canFind("AddRoad")){
            this.selectedTile.addRoad();
        }else if(pressed.canFind("AddGranary")){
            this.selectedTile.addGranary();
        }else if(pressed.canFind("AddWorkshop")){
            this.selectedTile.addWorkshop();
        }else if(pressed.canFind("AddMarket")){
            this.selectedTile.addMarket();
        }else if(pressed.canFind("AddCourthouse")){
            this.selectedTile.addCourthouse();
        }else if(pressed.canFind("AddFort")){
            this.selectedTile.addFort();
        }
        else if(pressed.canFind("MoveFarmer")){
            this.moveAction = MoveActions.MOVE_FARMER;
        }else if(pressed.canFind("MoveWorker")){
            this.moveAction = MoveActions.MOVE_WORKER;
        }else if(pressed.canFind("MoveMerchant")){
            this.moveAction = MoveActions.MOVE_MERCHANT;
        }else if(pressed.canFind("MovePolitician")){
            this.moveAction = MoveActions.MOVE_POLITICIAN;
        }else if(pressed.canFind("MoveSoldier")){
            this.moveAction = MoveActions.MOVE_SOLDIER;
        }else if(pressed.canFind("MoveFood")){
            this.moveAction = MoveActions.MOVE_FOOD;
        }else if(pressed.canFind("MoveMaterials")){
            this.moveAction = MoveActions.MOVE_MATERIAL;
        }else if(pressed.canFind("MoveMoney")){
            this.moveAction = MoveActions.MOVE_MONEY;
        }
        if(this.moveAction != MoveActions.NONE){
            bool moving;
            int direction;
            if(pressed.canFind("MoveCancel")){
                this.moveAction = MoveActions.NONE;
            }else if(pressed.canFind("MoveUp")){
                moving = true;
                direction = 0;
            }else if(pressed.canFind("MoveRight")){
                moving = true;
                direction = 1;
            }else if(pressed.canFind("MoveDown")){
                moving = true;
                direction = 2;
            }else if(pressed.canFind("MoveLeft")){
                moving = true;
                direction = 3;
            }
            if(moving){
                if(this.moveAction == MoveActions.MOVE_FARMER){
                    this.selectedTile.moveFarmer(world, direction);
                }else if(this.moveAction == MoveActions.MOVE_WORKER){
                    this.selectedTile.moveWorker(world, direction);
                }else if(this.moveAction == MoveActions.MOVE_MERCHANT){
                    this.selectedTile.moveMerchant(world, direction);
                }else if(this.moveAction == MoveActions.MOVE_POLITICIAN){
                    this.selectedTile.movePolitician(world, direction);
                }else if(this.moveAction == MoveActions.MOVE_SOLDIER){
                    this.selectedTile.moveSoldier(world, direction);
                }else if(this.moveAction == MoveActions.MOVE_FOOD){
                    this.selectedTile.moveFood(world, direction);
                }else if(this.moveAction == MoveActions.MOVE_MATERIAL){
                    this.selectedTile.moveMaterials(world, direction);
                }else if(this.moveAction == MoveActions.MOVE_MONEY){
                    this.selectedTile.moveMoney(world, direction);
                }
                this.moveAction = MoveActions.NONE;
            }
        }
    }

    void displayGrid(){
        for(int x = 0; x < world.length; x++){
            for(int y = 0; y < world[x].length; y++){
                if(world[x][y].owner !is null){
                    this.display.renderer.setColor(world[x][y].owner.color[0], world[x][y].owner.color[1], world[x][y].owner.color[2]);
                    this.display.renderer.fillRect(x * 25, y * 25, 25, 25);
                }
                this.display.renderer.copy(this.gridImage, x * 25, y * 25);
            }
        }
    }

    void selectNewTile(int x, int y){
        if(x <= 25 * 40 && y <= 25 * 24){
            this.selectedTile = world[x / 25][y / 25];
        }
    }

    void endTurn(){
        foreach(row; this.world){
            foreach(tile; row){
                tile.tick();
                tile.receiveSovereignty();
                tile.sendSovereignty(world);
            }
        }
        foreach(player; allPlayers){
            if(player !is null && world[player.capital[0]][player.capital[1]].owner is player){
                world[player.capital[0]][player.capital[1]].sovereignty += 10;
            }
        }
        this.setLabelAmounts();
    }

}
