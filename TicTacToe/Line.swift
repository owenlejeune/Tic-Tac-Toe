//
//  Line.swift
//  TicTacToe
//
//  Created by Owen LeJeune on 2018-03-21.
//  Copyright © 2018 Owen LeJeune. All rights reserved.
//

import Foundation
import CoreGraphics

struct Line {
    var begin = CGPoint.zero;
    var end = CGPoint.zero;
    
    func slope() -> CGFloat {
        return (end.y-begin.y)/(end.x-begin.x);
    }
    
    func getLength() -> CGFloat {
        let xlen = begin.x - end.x;
        let ylen = begin.y - end.y;
        return CGFloat(sqrt((xlen*xlen) + (ylen*ylen)));
    }
    
    func isVertical() -> Bool {
        return abs(begin.x - end.x) < abs(begin.y - end.y);
    }
    
    func getClosestToZeroZero() -> CGPoint {
        if isVertical() {
            if begin.y < end.y {
                return begin;
            }else{
                return end;
            }
        }else{
            if begin.x < end.x{
                return begin;
            }else{
                return end;
            }
        }
    }
}
