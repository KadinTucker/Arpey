module display.Polygon;

import std.math;

class Segment {

    int[2] initial;
    int[2] vector;

    this(int[2] initial, int[2] terminal){
        this.initial = initial;
        this.vector = [terminal[0] - initial[0], terminal[1] - initial[1]];
    }

    bool intersect(Segment other){
        double dotproduct = (this.vector[0] * other.vector[0] + this.vector[1]*other.vector[1]) / (hypot(this.vector[0], this.vector[1]) * hypot(other.vector[0], other.vector[1]));
        if(dotproduct == 1 || dotproduct == -1){
            return false;
        }
        double t = -(((other.initial[0] - this.initial[0]) * other.vector[1]) - ((other.initial[1] - this.initial[1]) * other.vector[0])) / ((other.vector[0] * this.vector[1]) - (other.vector[1] * this.vector[0]));
        if(t > 0 && t < 1){
            return true;
        }
        return false;
    }

    int[2][2] exportData(){
        return [this.initial, this.vector];
    }
}

class Polygon {

    Segment[] segments;

    this(int[2][] points){
        for(int i = 0; i < points.length - 1; i++){
            this.segments ~= new Segment(points[i], points[i+1]);
        }
        this.segments ~= new Segment(points[points.length - 1], points[0]);
    }

    this(Segment[] segments){
        this.segments = segments;
    }

    bool pointIn(int[2] point, int[2] bounds){
        Segment checker = new Segment([bounds[0], point[1]], [bounds[1], point[1]]);
        int count;
        foreach(segment; this.segments){
            if(checker.intersect(segment)){
                count += 1;
            }
        }
        if(count != 0 && count % 2 == 1){
            return true;
        }
        return false;
    }

    int[2][2][] exportData(){
        int[2][2][] allSegments;
        foreach(segment; this.segments){
            allSegments ~= segment.exportData();
        }
        return allSegments;
    }

}
