//
//  Board.swift
//  TicTacToe
//
//  Created by Owen LeJeune on 2018-03-26.
//  Copyright © 2018 Owen LeJeune. All rights reserved.
//

import Foundation

class Board{

    //representations of game board for printing and logic
    private var boardChars: [[Character]] = [[" ", "|", " ", "|", " "],
                                             [" ", "|", " ", "|", " "],
                                             [" ", "|", " ", "|", " "]];
    private var boardInts: [[Int]] = [[-1, -1, -1],
                                      [-1, -1, -1],
                                      [-1, -1, -1]];

    private let charsAsInts: [Int:Character] = [0: "O", 1: "X"];

    public func newPlay(x: Int, y: Int, piece: Int) -> Bool {

        if x < 0 || x > 2 || y < 0 || y > 2 || piece < 0 || piece > 1 { return false; }

        if boardInts[y][x] != -1 { return false; }

        boardChars[y][x*2] = charsAsInts[piece]!;
        boardInts[y][x] = piece;
        return true;
    }

    public func reset(){
        boardChars = [[" ", "|", " ", "|", " "],
                      [" ", "|", " ", "|", " "],
                      [" ", "|", " ", "|", " "]];
        boardInts = [[-1, -1, -1],
                     [-1, -1, -1],
                     [-1, -1, -1]];
    }

    public func toString() -> String {
        var board : String = "";
        for row in boardChars{
            for col in row{
                board += String(col);
            }
            board += "\n";
        }
        return board;
    }

    public func checkForWinner() -> [Int] {
        
        if boardInts[0][0] != -1 {
//            print("top left")
            if boardInts[0][1] == boardInts[0][0] &&
                boardInts[0][2] == boardInts[0][0]{
//                print(" across")
                return [boardInts[0][0], DrawView.TOP_L_ROW];
            }else if boardInts[1][1] == boardInts[0][0] &&
                boardInts[2][2] == boardInts[0][0]{
//                print(" diagonal")
                return [boardInts[0][0], DrawView.TOP_L_DIAG];
            }else if boardInts[1][0] == boardInts[0][0] &&
                boardInts[2][0] == boardInts[0][0]{
//                print(" down")
                return [boardInts[0][0], DrawView.TOP_L_COL];
            }
        }
        
        if boardInts[0][1] != -1 {
//            print("top mid")
            if boardInts[1][1] == boardInts[0][1] &&
                boardInts[2][1] == boardInts[0][1]{
//                print(" down")
                return [boardInts[0][1], DrawView.TOP_M_COL];
            }
        }
        
        if boardInts[0][2] != -1 {
//            print("top right")
            if boardInts[1][1] == boardInts[0][2] &&
                boardInts[2][0] == boardInts[0][2]{
//                print(" diagonal")
                return [boardInts[0][2], DrawView.TOP_R_DIAG];
            }else if boardInts[1][2] == boardInts[0][2] &&
                boardInts[2][2] == boardInts[0][2]{
//                print(" down")
                return [boardInts[0][2], DrawView.TOP_R_COL];
            }
        }
        
        if boardInts[1][0] != -1 {
//            print("mid left")
            if boardInts[1][1] == boardInts[1][0] &&
                boardInts[1][2] == boardInts[1][0]{
//                print(" across")
                return [boardInts[1][0], DrawView.MID_L_ROW];
            }
        }
        
        if boardInts[2][0] != -1 {
//            print("bottom left")
            if boardInts[2][1] == boardInts[2][0] &&
                boardInts[2][2] == boardInts[2][0]{
//                print(" across")
                return [boardInts[2][0], DrawView.BOT_L_ROW];
            }
        }
        
        for row in boardInts {
            for col in row {
                if col == -1 {return [-1, -1];}
            }
        }
        
        return [3, 3];
    }
}
