//
//  DrawView.swift
//  TicTacToe
//
//  Created by Owen LeJeune on 2018-03-21.
//  Copyright © 2018 Owen LeJeune. All rights reserved.
//

import UIKit

class DrawView: UIView{

    @IBOutlet weak var lblWinner: UILabel!
    
    let X_PLAY: Int = 1;
    let O_PLAY: Int = 0;
    let NO_WIN: Int = 3;
    static let TOP_L_ROW: Int = 0;
    static let TOP_L_DIAG: Int = 1;
    static let TOP_L_COL: Int = 2;
    static let TOP_M_COL: Int = 3;
    static let TOP_R_COL: Int = 4;
    static let TOP_R_DIAG: Int = 5;
    static let MID_L_ROW: Int = 6;
    static let BOT_L_ROW: Int = 7;

    var lastMove : Int = -1;
    var board : Board = Board();
    var isBoardDrawn : Bool = false;
    
    //lines drawn on screen
    var currentLines = [NSValue:Line]();
    var finishedLines = [Line]();
    var currentShapes = [NSValue:Shape]();
    var pendingShapes = [Shape]();
    var finishedShapes = [Shape]();
    var linePoints = [CGPoint]();
    var win: Int = -1;
    var winningLine: Line?;

    @IBInspectable var finishedLineColor: UIColor = UIColor.black{didSet{setNeedsDisplay();}}
    @IBInspectable var currentLineColor: UIColor = UIColor.red{didSet{setNeedsDisplay();}}
    @IBInspectable var lineThickness: CGFloat = 5{didSet{setNeedsDisplay();}}
    @IBInspectable var finishedShapeColor: UIColor = UIColor.blue{didSet{setNeedsDisplay();}}
    @IBInspectable var pendingShapeColor: UIColor = UIColor.green{didSet{setNeedsDisplay();}}
    @IBInspectable var winningLineColor: UIColor = UIColor.purple{didSet{setNeedsDisplay();}}
    @IBInspectable var winningLineThickness: CGFloat = 15{didSet{setNeedsDisplay();}}
    
    //register double-tap to clear gesture
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder);
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector(DrawView.doubleTap(_:)));
        doubleTapRecognizer.numberOfTapsRequired = 2;
        addGestureRecognizer(doubleTapRecognizer);
    }

    //clear board and reset representations on double-tap
    @objc func doubleTap(_ gestureRecognizer: UITapGestureRecognizer){
        print("I got a double tap");
        if win != -1 {
            reset();
        }
    }
    
    func reset() {
        finishedLines.removeAll(keepingCapacity: false);
        finishedShapes.removeAll(keepingCapacity: false);
        linePoints.removeAll(keepingCapacity: false);
        isBoardDrawn = false;
        lblWinner!.text = "";
        lastMove = -1;
        winningLine = nil;
        board.reset();
        setNeedsDisplay();
    }

    //draw a line
    func strokeLine(line: Line, lineThickness: CGFloat){
        let path = UIBezierPath();
        path.lineWidth = lineThickness;
        
        path.lineCapStyle = CGLineCap.round;
        path.move(to: line.begin);
        path.addLine(to: line.end);
        path.stroke();
    }

    //draw all lines and shapes to the screen
    override func draw(_ rect: CGRect){
        finishedLineColor.setStroke();

        for line in finishedLines{
            strokeLine(line: line, lineThickness: lineThickness);
        }
        
        finishedShapeColor.setStroke();

        for shape in finishedShapes{
            for line in shape.lines{
                strokeLine(line: line, lineThickness: lineThickness);
            }
        }

        pendingShapeColor.setStroke();

        for shape in pendingShapes{
            for line in shape.lines{
                strokeLine(line: line, lineThickness: lineThickness);
            }
        }

        currentLineColor.setStroke();

        for(_,line) in currentLines{
            strokeLine(line: line, lineThickness: lineThickness);
        }

        for(_,shape) in currentShapes{
            for line in shape.lines{
                strokeLine(line: line, lineThickness: lineThickness);
            }
        }
        
        if winningLine != nil {
            winningLineColor.setStroke();
            strokeLine(line: winningLine!, lineThickness: winningLineThickness);
        }
        
        if lastMove != -1 && win == -1 {
            lblWinner.text = (lastMove == X_PLAY) ? "Os Turn" : "Xs Turn";
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        print(#function);
        for touch in touches{
            let location = touch.location(in: self);
            let newLine = Line(begin: location, end: location);
            let key = NSValue(nonretainedObject: touch);
            currentLines[key] = newLine;
            if isBoardDrawn {
                let newShape = (pendingShapes.count == 0) ? Shape() : pendingShapes[0];
                currentShapes[key] = newShape;
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        print(#function);
        for touch in touches{
            let location = touch.location(in: self);
            let key = NSValue(nonretainedObject: touch);
            currentLines[key]!.end = location;
            if isBoardDrawn {
                currentShapes[key]!.lines.append(currentLines[key]!);
                currentLines[key]! = Line(begin: location, end: location);
            }
        }
        setNeedsDisplay();
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        print(#function)
        for touch in touches{
            let location = touch.location(in: self);
            let key = NSValue(nonretainedObject: touch);
            currentLines[key]!.end = location;
            if isBoardDrawn {
                currentShapes[key]!.lines.append(currentLines[key]!);
                if currentShapes[key]!.isO() {
                    makeMove(player: O_PLAY, key: key);
                }else if pendingShapes.count == 1 {
                    if currentShapes[key]!.isX() {
                        makeMove(player: X_PLAY, key: key);
                        pendingShapes.removeAll(keepingCapacity: false);
                    }
                }else if currentShapes[key]!.isLine() {
                    pendingShapes.append(currentShapes[key]!);
                }else{
                    pendingShapes.removeAll(keepingCapacity: false);
                }
                currentShapes[key] = nil;
                currentLines[key] = nil;
            }else{
                if currentLines[key]!.getLength() > 200 {
                    finishedLines.append(currentLines[key]!);
                    if finishedLines.count == 4{
                        isBoardDrawn = true;
                        print(board.toString());
                        findLinePoints();
                    }
                }
                currentLines[key] = nil;
            }
        }
        setNeedsDisplay();
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?){
        print(#function)
        for touch in touches!{
            let key = NSValue(nonretainedObject: touch);
            currentLines[key] = nil;
            currentShapes[key] = nil;
        }
        setNeedsDisplay();
    }

    func findLinePoints(){
        var horizontalLines = [Line]();
        var verticalLines = [Line]();

        for line in finishedLines {
            if line.isVertical() {
                verticalLines.append(line);
            }else{
                horizontalLines.append(line);
            }
        }

        if verticalLines[0].getClosestToZeroZero().x < verticalLines[1].getClosestToZeroZero().x {
            linePoints.append(verticalLines[0].getClosestToZeroZero());
            linePoints.append(verticalLines[1].getClosestToZeroZero());
        }else{
            linePoints.append(verticalLines[1].getClosestToZeroZero());
            linePoints.append(verticalLines[0].getClosestToZeroZero());
        }

        if horizontalLines[0].getClosestToZeroZero().y < horizontalLines[1].getClosestToZeroZero().y {
            linePoints.append(horizontalLines[0].getClosestToZeroZero());
            linePoints.append(horizontalLines[1].getClosestToZeroZero());
        }else{
            linePoints.append(horizontalLines[1].getClosestToZeroZero());
            linePoints.append(horizontalLines[0].getClosestToZeroZero());
        }
        
        for line in linePoints {
            print(line);
        }
    }

    func makeMove(player: Int, key: NSValue){
        if player != lastMove {
            let position = findPositionOnBoard(shape: currentShapes[key]!);
            if board.newPlay(x: Int(position.x), y: Int(position.y), piece: player) {
                finishedShapes.append(currentShapes[key]!);
                print(board.toString());
                let result = board.checkForWinner();
                win = result[0];
                if win == NO_WIN {
                    lblWinner.text = "Tie!";
                    setNeedsDisplay();
                }else if win != -1 {
                    let char = (win == X_PLAY) ? "X" : "O";
                    lblWinner.text = "\(char) Wins!";
                    makeWinningLine(location: result[1]);
                    setNeedsDisplay();
                }
                lastMove = player;
            }
        }
    }

    func findPositionOnBoard(shape: Shape) -> CGPoint {
        let point : CGPoint = shape.avgPoint();

        if point.x < linePoints[0].x {
            if point.y < linePoints[2].y{
                return CGPoint(x: 0, y: 0);
            }else if point.y < linePoints[3].y {
                return CGPoint(x: 0, y: 1);
            }else{
                return CGPoint(x: 0, y: 2);
            }
        }else if point.x < linePoints[1].x {
            if point.y < linePoints[2].y{
                return CGPoint(x: 1, y: 0);
            }else if point.y < linePoints[3].y {
                return CGPoint(x: 1, y: 1);
            }else{
                return CGPoint(x: 1, y: 2);
            }
        }else{
            if point.y < linePoints[2].y{
                return CGPoint(x: 2, y: 0);
            }else if point.y < linePoints[3].y {
                return CGPoint(x: 2, y: 1);
            }else{
                return CGPoint(x: 2, y: 2);
            }
        }
    }
    
    func makeWinningLine(location: Int) {
        
        let width = self.frame.size.width;
        let height = self.frame.size.height;
        let half = CGFloat(2);
        
        switch location {
        case DrawView.TOP_L_COL:
            let beginY = linePoints[0].y;
            let beginX = linePoints[0].x/half;
            let endY = linePoints[3].y + ((height - linePoints[3].y)/half);
            let startPoint = CGPoint(x: beginX, y: beginY);
            let endPoint = CGPoint(x: beginX, y: endY);
            winningLine = Line(begin: startPoint, end: endPoint);
            break;
        case DrawView.TOP_L_DIAG:
            let beginX = linePoints[0].x/half;
            let endX = linePoints[1].x + ((width - linePoints[1].x)/half);
            let beginY = linePoints[0].y;
            let endY = linePoints[3].y + ((height - linePoints[3].y)/half);
            let startPoint = CGPoint(x: beginX, y: beginY);
            let endPoint = CGPoint(x: endX, y: endY);
            winningLine = Line(begin: startPoint, end: endPoint);
            break;
        case DrawView.TOP_L_ROW:
            let beginX = linePoints[0].x/half;
            let endX = linePoints[1].x + ((width - linePoints[1].x)/half);
            let beginY = linePoints[0].y + ((linePoints[2].y - linePoints[0].y)/half);
            let startPoint = CGPoint(x: beginX, y: beginY);
            let endPoint = CGPoint(x: endX, y: beginY);
            winningLine = Line(begin: startPoint, end: endPoint);
            break;
        case DrawView.TOP_M_COL:
            let beginY = linePoints[0].y;
            let beginX = (linePoints[0].x + linePoints[1].x)/half;
            let endY = linePoints[3].y + ((height - linePoints[3].y)/half);
            let startPoint = CGPoint(x: beginX, y: beginY);
            let endPoint = CGPoint(x: beginX, y: endY);
            winningLine = Line(begin: startPoint, end: endPoint);
            break;
        case DrawView.TOP_R_COL:
            let beginY = linePoints[1].y;
            let beginX = linePoints[1].x + ((width - linePoints[1].x)/half);
            let endY = linePoints[3].y + ((height - linePoints[3].y)/half);
            let startPoint = CGPoint(x: beginX, y: beginY);
            let endPoint = CGPoint(x: beginX, y: endY);
            winningLine = Line(begin: startPoint, end: endPoint);
            break;
        case DrawView.TOP_R_DIAG:
            let beginX = linePoints[1].x + ((width - linePoints[1].x)/half);
            let endX = linePoints[0].x/half;
            let beginY = linePoints[0].y;
            let endY = linePoints[3].y + ((height - linePoints[3].y)/half);
            let startPoint = CGPoint(x: beginX, y: beginY);
            let endPoint = CGPoint(x: endX, y: endY);
            winningLine = Line(begin: startPoint, end: endPoint);
            break;
        case DrawView.MID_L_ROW:
            let beginX = linePoints[0].x/half;
            let endX = linePoints[1].x + ((width - linePoints[1].x)/half);
            let beginY = (linePoints[2].y + linePoints[3].y)/half;
            let startPoint = CGPoint(x: beginX, y: beginY);
            let endPoint = CGPoint(x: endX, y: beginY);
            winningLine = Line(begin: startPoint, end: endPoint);
            break;
        case DrawView.BOT_L_ROW:
            let beginX = linePoints[0].x/half;
            let endX = linePoints[1].x + ((width - linePoints[1].x)/half);
            let beginY = linePoints[3].y + CGFloat(50);
            let startPoint = CGPoint(x: beginX, y: beginY);
            let endPoint = CGPoint(x: endX, y: beginY);
            winningLine = Line(begin: startPoint, end: endPoint);
            break;
        default:
            winningLine = nil;
        }
    }
}
