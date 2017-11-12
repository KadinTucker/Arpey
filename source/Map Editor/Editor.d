module display.gamestate.Editor;

import display.Display;
import display.gamestate.GameState;
import display.Polygon;
import display.panel.ImagePanel;
import display.panel.TextPanel;

import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;
import std.stdio;
import std.algorithm;

class EditorState : GameState {

    int[2][] nodes;
    Polygon[] territories;
    bool controlPressed;

    this(Display display){
        super(display);
        this.panels ~= new ImagePanel(0, 0, 1165, 575, "bg_map.png", this.display, "Background");
        this.panels ~= new TextPanel(RGBColor(150, 50, 50), 1165, 100, "Add Territory", 12, display, "AddTerritory");
        this.panels ~= new TextPanel(RGBColor(150, 50, 50), 1165, 150, "   Save      ", 12, display, "Save");
        this.display.window.setTitle("Arpey Map Editor");
    }

    override void displayAll(){
        this.display.renderer.setViewportFull();
        this.display.renderer.setColor(50, 150, 70, 255);
        this.display.renderer.clear();
        this.panels[0].render(this.display.renderer);
        this.panels[1].render(this.display.renderer);
        this.panels[2].render(this.display.renderer);
        this.displayNodes();
        this.displayTerritories();
        this.display.renderer.present();
    }

    override void handleEvent(SDL_Event event){
        if(event.type == SDL_MOUSEBUTTONDOWN){
            if(event.button.button == SDL_BUTTON_LEFT){
                if(event.button.x <= 1165){
                    this.nodes ~= [event.button.x, event.button.y];
                }else{
                    this.handleButtons(this.getPressedButtons(event.button.x, event.button.y));
                }
            }
        }
    }

    override void handleButtons(string[] pressed){
        if(this.nodes.length > 0){
            if(pressed.canFind("AddTerritory")){
                this.territories ~= new Polygon(this.nodes);
                this.nodes = [];
            }if(pressed.canFind("Save")){
                this.exportTerritories();
            }
        }
    }

    void displayNodes(){
        this.display.renderer.setColor(0, 0, 0, 255);
        if(this.nodes.length > 0){
            for(int node = 0; node < this.nodes.length - 1; node += 1){
                this.display.renderer.drawLine(this.nodes[node][0], this.nodes[node][1], this.nodes[node + 1][0], this.nodes[node + 1][1]);
            }
        }
    }

    void displayTerritories(){
        this.display.renderer.setColor(0, 255, 0, 255);
        foreach(territory; this.territories){
            foreach(segment; territory.segments){
                this.display.renderer.drawLine(segment.initial[0], segment.initial[1], segment.initial[0] + segment.vector[0], segment.initial[1] + segment.vector[1]);
            }
        }
    }

    void exportTerritories(){
        int[2][2][][] allTerritories;
        foreach(territory; this.territories){
            allTerritories ~= territory.exportData();
        }
        toFile(allTerritories, "deleteme.am");
    }

}
