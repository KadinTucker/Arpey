module data.Tile;

import display.Polygon;
import data.Player;

import std.stdio;
import std.conv;

class Tile {

    int[2] location;
    Player owner;

    int farmers;
    int workers;
    int merchants;
    int politicians;
    int soldiers;

    int[2] granaries;               ///For resource buildings, there must be at least 1 worker for every 4 for them to work. The active resource buildings is the second number.
    int[2] workshops;
    int[2] markets;
    int[2] courthouses;
    int[2] forts;
    int[2] roads;                   ///First is the base number of roads, second is the number still available.
    int houses;

    int food;
    int materials;
    int money;
    int sovereignty;
    int[Player] tempSovereignty;    ///The sovereignty that has just been delivered

    int land;                    ///amount used
    int[2] population;           ///amount used, amount available

    this(int[2] location){
        this.location = location;
        this.updateStatistics();
    }

    void setTempSovKeys(Player[] allPlayers){
        foreach(player; allPlayers){
            this.tempSovereignty[player] = 0;
        }
    }

    void produce(){
        if(this.owner !is null){
            this.food += cast(int)(1.0 + 0.25 * this.granaries[1]) * this.farmers * 3;
            this.materials += cast(int)(1.0 + 0.25 * this.workshops[1]) * this.workers * 3;
            this.money += cast(int)(1.0 + 0.25 * this.markets[1]) * this.merchants * 3;
            this.sovereignty += cast(int)(1.0 + 0.25 * this.courthouses[1]) * this.politicians * 3;
        }
    }

    int getPopulation(){
        return this.farmers + this.workers + this.merchants + this.politicians + this.soldiers;
    }

    int getPopulationLimit(){
        return 5 * this.houses + 10;
    }

    void reduceSovereignty(){
        if(this.owner !is null){
            this.sovereignty -= (this.getPopulation - this.soldiers - this.politicians) / 5;        //Population consumes sovereignty.
            this.sovereignty += this.tempSovereignty[this.owner];                                   //Sovereignty delivered to this player is properly received.
        }
    }

    void receiveSovereignty(){
        //TODO: Make lower sov values go first
        foreach(sovereign; this.tempSovereignty.keys){
            if(sovereign !is this.owner){
                if(this.tempSovereignty[sovereign] > this.sovereignty + this.soldiers){
                    this.owner = sovereign;
                    this.sovereignty = this.tempSovereignty[sovereign] - this.sovereignty;
                }else{
                    this.sovereignty -= this.tempSovereignty[sovereign];
                }
            }
        }
        foreach(sovereign; this.tempSovereignty.keys){
            this.tempSovereignty[sovereign] = 0;
        }
        if(this.sovereignty <= 0){
            this.sovereignty = 0;
            this.owner = null;
        }
    }

    void sendSovereignty(Tile[][] world){
        Tile[] bordering = getBorderingTiles(world);
        int sovToSpread = this.sovereignty / 2;
        sovToSpread /= bordering.length;
        foreach(tile; bordering){
            tile.tempSovereignty[this.owner] += sovToSpread;
        }
        this.sovereignty /= 2;
    }

    Tile[] getBorderingTiles(Tile[][] world){
        Tile[] bordering;
        if(location[0] == 0){
            bordering ~= world[location[0] + 1][location[1]];
        }else if(location[0] == world.length - 1){
            bordering ~= world[location[0] - 1][location[1]];
        }else{
            bordering ~= world[location[0] + 1][location[1]];
            bordering ~= world[location[0] - 1][location[1]];
        }
        if(location[1] == 0){
            bordering ~= world[location[0]][location[1] + 1];
        }else if(location[1] == world[0].length - 1){
            bordering ~= world[location[0]][location[1] - 1];
        }else{
            bordering ~= world[location[0]][location[1] + 1];
            bordering ~= world[location[0]][location[1] - 1];
        }
        return bordering;
    }

    void resolveBuildings(){
        this.roads[1] = this.roads[0];
        this.granaries[1] = this.farmers * 4;
        if(this.granaries[1] > this.granaries[0]){
            this.granaries[1] = this.granaries[0];
        }
        this.workshops[1] = this.workers * 4;
        if(this.workshops[1] > this.workshops[0]){
            this.workshops[1] = this.workshops[0];
        }
        this.markets[1] = this.merchants * 4;
        if(this.markets[1] > this.markets[0]){
            this.markets[1] = this.markets[0];
        }
        this.courthouses[1] = this.politicians * 4;
        if(this.courthouses[1] > this.courthouses[0]){
            this.courthouses[1] = this.courthouses[0];
        }
    }

    void updateStatistics(){
        this.resolveBuildings();
        this.population[0] = this.getPopulation();
        this.population[1] = this.getPopulationLimit();
        this.land = this.farmers * 10 + this.houses * 5 + this.granaries[0] * 5 + this.workshops[0] * 5 + this.markets[0] * 5 + this.courthouses[0] * 5 + this.forts[0] * 5 + this.roads[0];
    }

    void grow(){
        if(this.food >= 15 && this.population[1] - this.population[0] > 0){
            this.workers += 1;
            this.food -= 15;
        }
        this.updateStatistics();
    }

    void tick(){
        this.updateStatistics();
        this.produce();
        this.grow();
        this.reduceSovereignty();
    }

    void addFarmer(){
        if(this.land <= 490 && this.workers >= 1){
            this.workers -= 1;
            this.farmers += 1;
            this.updateStatistics();
        }
    }

    void addMerchant(){
        if(this.materials >= 5 && this.workers >= 1){
            this.workers -= 1;
            this.merchants += 1;
            this.materials -= 5;
            this.updateStatistics();
        }
    }

    void addPolitician(){
        if(this.money >= 5 && this.workers >= 1){
            this.workers -= 1;
            this.politicians += 1;
            this.money -= 5;
            this.updateStatistics();
        }
    }

    void addSoldier(){
        if(this.materials >= 10 && this.workers >= 1){
            this.workers -= 1;
            this.soldiers += 1;
            this.materials -= 10;
            this.updateStatistics();
        }
    }


    void addHouse(){
        if(this.land <= 495 && this.materials >= 10){
            this.materials -= 10;
            this.houses += 1;
            this.updateStatistics();
        }
    }

    void addRoad(){
        if(this.land <= 499 && this.materials >= 5){
            this.materials -= 5;
            this.roads[0] += 1;
            this.updateStatistics();
        }
    }

    void addGranary(){
        if(this.land <= 495 && this.materials >= 30){
            this.materials -= 30;
            this.granaries[0] += 1;
            this.updateStatistics();
        }
    }

    void addWorkshop(){
        if(this.land <= 495 && this.materials >= 30){
            this.materials -= 30;
            this.workshops[0] += 1;
            this.updateStatistics();
        }
    }

    void addMarket(){
        if(this.land <= 495 && this.materials >= 20){
            this.materials -= 20;
            this.markets[0] += 1;
            this.updateStatistics();
        }
    }

    void addCourthouse(){
        if(this.land <= 495 && this.materials >= 50){
            this.materials -= 50;
            this.courthouses[0] += 1;
            this.updateStatistics();
        }
    }

    void addFort(){
        if(this.land <= 495 && this.materials >= 20){
            this.materials -= 20;
            this.forts[0] += 1;
            this.updateStatistics();
        }
    }


    Tile getTileFromDirection(Tile[][] world, int direction){
        if(this.location[0] == 0 && direction == 3){
            return this;
        }else if(this.location[0] == world.length - 1 && direction == 1){
            return this;
        }else if(this.location[1] == 0 && direction == 0){
            return this;
        }else if(this.location[1] == world.length - 1 && direction == 2){
            return this;
        }else{
            if(direction == 0){
                return world[this.location[0]][this.location[1] - 1];
            }else if(direction == 1){
                return world[this.location[0] + 1][this.location[1]];
            }else if(direction == 2){
                return world[this.location[0]][this.location[1] + 1];
            }else if(direction == 3){
                return world[this.location[0] - 1][this.location[1]];
            }
        }
        return this;
    }

    int getUsableRoads(int travellers){
        if(travellers > this.roads[1]){
            return this.roads[1];
        }else{
            return travellers;
        }
    }

    void moveFarmer(Tile[][] world, int direction){
        if(this.farmers <= 0){
            return;
        }
        Tile destination = getTileFromDirection(world, direction);
        if(this is destination){
            return;
        }else{
            int usedRoads = getUsableRoads(1);
            if(this.food >= 1 - usedRoads && destination.population[1] - destination.population[0] >= 1 && destination.land <= 490){
                this.roads[1] -= usedRoads;
                this.food -= 1 - usedRoads;
                this.farmers -= 1;
                destination.farmers += 1;
            }
        }
        this.updateStatistics();
        destination.updateStatistics();
    }

    void moveWorker(Tile[][] world, int direction){
        if(this.workers <= 0){
            return;
        }
        Tile destination = getTileFromDirection(world, direction);
        if(this is destination){
            return;
        }else{
            int usedRoads = getUsableRoads(1);
            if(this.food >= 1 - usedRoads && destination.population[1] - destination.population[0] >= 1){
                this.roads[1] -= usedRoads;
                this.food -= 1 - usedRoads;
                this.workers -= 1;
                destination.workers += 1;
            }
        }
        this.updateStatistics();
        destination.updateStatistics();
    }

    void moveMerchant(Tile[][] world, int direction){
        if(this.merchants <= 0){
            return;
        }
        Tile destination = getTileFromDirection(world, direction);
        if(this is destination){
            return;
        }else{
            int usedRoads = getUsableRoads(1);
            if(this.food >= 1 - usedRoads && destination.population[1] - destination.population[0] >= 1){
                this.roads[1] -= usedRoads;
                this.food -= 1 - usedRoads;
                this.merchants -= 1;
                destination.merchants += 1;
            }
        }
        this.updateStatistics();
        destination.updateStatistics();
    }

    void movePolitician(Tile[][] world, int direction){
        if(this.politicians <= 0){
            return;
        }
        Tile destination = getTileFromDirection(world, direction);
        if(this is destination){
            return;
        }else{
            int usedRoads = getUsableRoads(1);
            if(this.food >= 1 - usedRoads && destination.population[1] - destination.population[0] >= 1){
                this.roads[1] -= usedRoads;
                this.food -= 1 - usedRoads;
                this.politicians -= 1;
                destination.politicians += 1;
            }
        }
        this.updateStatistics();
        destination.updateStatistics();
    }

    //TODO: Implement combattere
    void moveSoldier(Tile[][] world, int direction){
        if(this.soldiers <= 0){
            return;
        }
        Tile destination = getTileFromDirection(world, direction);
        if(this is destination){
            return;
        }else{
            int usedRoads = getUsableRoads(1);
            if(this.food >= 1 - usedRoads && destination.population[1] - destination.population[0] >= 1){
                this.roads[1] -= usedRoads;
                this.food -= 1 - usedRoads;
                this.soldiers -= 1;
                destination.soldiers += 1;
            }
        }
        this.updateStatistics();
        destination.updateStatistics();
    }

    void moveFood(Tile[][] world, int direction){
        if(this.food <= 0){
            return;
        }
        Tile destination = getTileFromDirection(world, direction);
        if(this is destination){
            return;
        }else{
            int usedRoads = getUsableRoads(1);
            if(this.money >= 1 - usedRoads){
                this.roads[1] -= usedRoads;
                this.money -= 1 - usedRoads;
                this.food -= 1;
                destination.food += 1;
            }
        }
        this.updateStatistics();
        destination.updateStatistics();
    }

    void moveMaterials(Tile[][] world, int direction){
        if(this.materials <= 0){
            return;
        }
        Tile destination = getTileFromDirection(world, direction);
        if(this is destination){
            return;
        }else{
            int usedRoads = getUsableRoads(1);
            if(this.money >= 1 - usedRoads){
                this.roads[1] -= usedRoads;
                this.money -= 1 - usedRoads;
                this.materials -= 1;
                destination.materials += 1;
            }
        }
        this.updateStatistics();
        destination.updateStatistics();
    }

    void moveMoney(Tile[][] world, int direction){
        if(this.money <= 0){
            return;
        }
        Tile destination = getTileFromDirection(world, direction);
        if(this is destination){
            return;
        }else{
            this.money -= 1;
            destination.money += 1;
        }
        this.updateStatistics();
        destination.updateStatistics();
    }

}
