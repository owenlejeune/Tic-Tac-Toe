//
//  Shape.swift
//  TicTacToe
//
//  Created by Owen LeJeune on 2018-03-26.
//  Copyright © 2018 Owen LeJeune. All rights reserved.
//

import Foundation
import CoreGraphics

struct Shape {
    var lines : [Line] = [];
    
    private func xspan() -> CGFloat {
        return abs(lines[0].begin.x - lines[lines.count-1].end.x);
    }
    
    private func yspan() -> CGFloat {
        return abs(lines[0].begin.y - lines[lines.count-1].end.y);
    }
    
    func isO() -> Bool {
        let avgPnt = avgPoint();
        if xspan() < 10 && yspan() < 10 && indexOfLineNearPoint(point: avgPnt) == nil {
            return true;
        }
        return false;
    }
    
    func isX() -> Bool {
        let avgPnt = avgPoint();
        if (xspan() > 5 || yspan() > 5) && indexOfLineNearPoint(point: avgPnt) != nil {
            return true;
        }
        return false;
    }
    
    func isLine() -> Bool {
        let shapeLine = Line(begin: lines[0].begin, end: lines[lines.count-1].end);
        let lineSlope = shapeLine.slope();
        var totalSlope: CGFloat = 0;
        
        for i in stride(from: 0, to: lines.count-3, by: 3){
            let startX = lines[i].begin.x;
            let startY = lines[i].begin.y;
            let endX = lines[i+2].end.x;
            let endY = lines[i+2].end.y;
            let startPoint = CGPoint(x: startX, y: startY);
            let endPoint = CGPoint(x: endX, y: endY);
            let line = Line(begin: startPoint, end: endPoint);
            totalSlope += line.slope();
        }
        
        let avgSlope = totalSlope/CGFloat(lines.count);
        if abs(lineSlope-avgSlope) < 1 { return true; }
        return false;
    }
    
    func avgPoint() -> CGPoint {
        var x : CGFloat = 0;
        var y : CGFloat = 0;
        let count = CGFloat(lines.count);
        for line in lines {
            x += line.begin.x;
            y += line.begin.y;
        }
        return CGPoint(x: x/count, y: y/count);
    }
    
    private func indexOfLineNearPoint(point: CGPoint) -> Int? {
        let tolerence: Float = 5.0 //experiment with this value
        for (index, line) in lines.enumerated() {
            let begin = line.begin;
            let end = line.end;
            let lineLength = distanceBetween(from: begin, to: end);
            let beginToTapDistance = distanceBetween(from: begin, to: point);
            let endToTapDistance = distanceBetween(from: end, to: point);
            if (beginToTapDistance + endToTapDistance - lineLength) < tolerence {
                return index;
            }
        }
        return nil;
    }
    
    private func distanceBetween(from: CGPoint, to: CGPoint) -> CFloat{
        let distXsquared = Float((to.x-from.x)*(to.x-from.x));
        let distYsquared = Float((to.y-from.y)*(to.y-from.y));
        return sqrt(distXsquared + distYsquared);
    }
}
